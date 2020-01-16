
obj/kern/kernel：     文件格式 elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 00 12 00       	mov    $0x120000,%eax
	movl	%eax, %cr3			//cr3 寄存器保存页目录表的物理基地址
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0			//cr0 的最高位PG位设置为1后，正式打开分页功能
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 00 12 f0       	mov    $0xf0120000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 5e 00 00 00       	call   f010009c <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100048:	83 3d 80 9e 1e f0 00 	cmpl   $0x0,0xf01e9e80
f010004f:	74 0f                	je     f0100060 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100051:	83 ec 0c             	sub    $0xc,%esp
f0100054:	6a 00                	push   $0x0
f0100056:	e8 d5 08 00 00       	call   f0100930 <monitor>
f010005b:	83 c4 10             	add    $0x10,%esp
f010005e:	eb f1                	jmp    f0100051 <_panic+0x11>
	panicstr = fmt;
f0100060:	89 35 80 9e 1e f0    	mov    %esi,0xf01e9e80
	asm volatile("cli; cld");
f0100066:	fa                   	cli    
f0100067:	fc                   	cld    
	va_start(ap, fmt);
f0100068:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006b:	e8 87 5d 00 00       	call   f0105df7 <cpunum>
f0100070:	ff 75 0c             	pushl  0xc(%ebp)
f0100073:	ff 75 08             	pushl  0x8(%ebp)
f0100076:	50                   	push   %eax
f0100077:	68 40 64 10 f0       	push   $0xf0106440
f010007c:	e8 12 38 00 00       	call   f0103893 <cprintf>
	vcprintf(fmt, ap);
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	53                   	push   %ebx
f0100085:	56                   	push   %esi
f0100086:	e8 e2 37 00 00       	call   f010386d <vcprintf>
	cprintf("\n");
f010008b:	c7 04 24 3b 76 10 f0 	movl   $0xf010763b,(%esp)
f0100092:	e8 fc 37 00 00       	call   f0103893 <cprintf>
f0100097:	83 c4 10             	add    $0x10,%esp
f010009a:	eb b5                	jmp    f0100051 <_panic+0x11>

f010009c <i386_init>:
{
f010009c:	55                   	push   %ebp
f010009d:	89 e5                	mov    %esp,%ebp
f010009f:	53                   	push   %ebx
f01000a0:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000a3:	e8 ae 05 00 00       	call   f0100656 <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000a8:	83 ec 08             	sub    $0x8,%esp
f01000ab:	68 ac 1a 00 00       	push   $0x1aac
f01000b0:	68 ac 64 10 f0       	push   $0xf01064ac
f01000b5:	e8 d9 37 00 00       	call   f0103893 <cprintf>
	mem_init();
f01000ba:	e8 13 12 00 00       	call   f01012d2 <mem_init>
	env_init();
f01000bf:	e8 03 30 00 00       	call   f01030c7 <env_init>
	trap_init();
f01000c4:	e8 ae 38 00 00       	call   f0103977 <trap_init>
	mp_init();		//初始化cpus数组，bootcpu指针，ncpu，LAPIC地址lapicaddr
f01000c9:	e8 17 5a 00 00       	call   f0105ae5 <mp_init>
	lapic_init();	//初始化LAPIC，将虚拟地址MMIOBASE映射到lapicaddr(lapicaddr is the physical address of the LAPIC's 4K MMIO region)
f01000ce:	e8 3e 5d 00 00       	call   f0105e11 <lapic_init>
	pic_init();
f01000d3:	e8 de 36 00 00       	call   f01037b6 <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000d8:	c7 04 24 c0 23 12 f0 	movl   $0xf01223c0,(%esp)
f01000df:	e8 83 5f 00 00       	call   f0106067 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000e4:	83 c4 10             	add    $0x10,%esp
f01000e7:	83 3d 88 9e 1e f0 07 	cmpl   $0x7,0xf01e9e88
f01000ee:	76 27                	jbe    f0100117 <i386_init+0x7b>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01000f0:	83 ec 04             	sub    $0x4,%esp
f01000f3:	b8 4a 5a 10 f0       	mov    $0xf0105a4a,%eax
f01000f8:	2d d0 59 10 f0       	sub    $0xf01059d0,%eax
f01000fd:	50                   	push   %eax
f01000fe:	68 d0 59 10 f0       	push   $0xf01059d0
f0100103:	68 00 70 00 f0       	push   $0xf0007000
f0100108:	e8 12 57 00 00       	call   f010581f <memmove>
f010010d:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f0100110:	bb 20 a0 1e f0       	mov    $0xf01ea020,%ebx
f0100115:	eb 19                	jmp    f0100130 <i386_init+0x94>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100117:	68 00 70 00 00       	push   $0x7000
f010011c:	68 64 64 10 f0       	push   $0xf0106464
f0100121:	6a 52                	push   $0x52
f0100123:	68 c7 64 10 f0       	push   $0xf01064c7
f0100128:	e8 13 ff ff ff       	call   f0100040 <_panic>
f010012d:	83 c3 74             	add    $0x74,%ebx
f0100130:	6b 05 c4 a3 1e f0 74 	imul   $0x74,0xf01ea3c4,%eax
f0100137:	05 20 a0 1e f0       	add    $0xf01ea020,%eax
f010013c:	39 c3                	cmp    %eax,%ebx
f010013e:	73 4c                	jae    f010018c <i386_init+0xf0>
		if (c == cpus + cpunum())  // We've started already. 现在运行在BSP
f0100140:	e8 b2 5c 00 00       	call   f0105df7 <cpunum>
f0100145:	6b c0 74             	imul   $0x74,%eax,%eax
f0100148:	05 20 a0 1e f0       	add    $0xf01ea020,%eax
f010014d:	39 c3                	cmp    %eax,%ebx
f010014f:	74 dc                	je     f010012d <i386_init+0x91>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100151:	89 d8                	mov    %ebx,%eax
f0100153:	2d 20 a0 1e f0       	sub    $0xf01ea020,%eax
f0100158:	c1 f8 02             	sar    $0x2,%eax
f010015b:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100161:	c1 e0 0f             	shl    $0xf,%eax
f0100164:	05 00 30 1f f0       	add    $0xf01f3000,%eax
f0100169:	a3 84 9e 1e f0       	mov    %eax,0xf01e9e84
		lapic_startap(c->cpu_id, PADDR(code));
f010016e:	83 ec 08             	sub    $0x8,%esp
f0100171:	68 00 70 00 00       	push   $0x7000
f0100176:	0f b6 03             	movzbl (%ebx),%eax
f0100179:	50                   	push   %eax
f010017a:	e8 e3 5d 00 00       	call   f0105f62 <lapic_startap>
f010017f:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f0100182:	8b 43 04             	mov    0x4(%ebx),%eax
f0100185:	83 f8 01             	cmp    $0x1,%eax
f0100188:	75 f8                	jne    f0100182 <i386_init+0xe6>
f010018a:	eb a1                	jmp    f010012d <i386_init+0x91>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f010018c:	83 ec 08             	sub    $0x8,%esp
f010018f:	6a 01                	push   $0x1
f0100191:	68 74 78 1a f0       	push   $0xf01a7874
f0100196:	e8 00 31 00 00       	call   f010329b <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f010019b:	83 c4 08             	add    $0x8,%esp
f010019e:	6a 00                	push   $0x0
f01001a0:	68 c4 db 19 f0       	push   $0xf019dbc4
f01001a5:	e8 f1 30 00 00       	call   f010329b <env_create>
	kbd_intr();
f01001aa:	e8 4c 04 00 00       	call   f01005fb <kbd_intr>
	sched_yield();
f01001af:	e8 95 44 00 00       	call   f0104649 <sched_yield>

f01001b4 <mp_main>:
{
f01001b4:	55                   	push   %ebp
f01001b5:	89 e5                	mov    %esp,%ebp
f01001b7:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001ba:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01001bf:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001c4:	77 12                	ja     f01001d8 <mp_main+0x24>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01001c6:	50                   	push   %eax
f01001c7:	68 88 64 10 f0       	push   $0xf0106488
f01001cc:	6a 69                	push   $0x69
f01001ce:	68 c7 64 10 f0       	push   $0xf01064c7
f01001d3:	e8 68 fe ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01001d8:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001dd:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001e0:	e8 12 5c 00 00       	call   f0105df7 <cpunum>
f01001e5:	83 ec 08             	sub    $0x8,%esp
f01001e8:	50                   	push   %eax
f01001e9:	68 d3 64 10 f0       	push   $0xf01064d3
f01001ee:	e8 a0 36 00 00       	call   f0103893 <cprintf>
	lapic_init();
f01001f3:	e8 19 5c 00 00       	call   f0105e11 <lapic_init>
	env_init_percpu();			//设置GDT，每个CPU都需要执行一次
f01001f8:	e8 9a 2e 00 00       	call   f0103097 <env_init_percpu>
	trap_init_percpu();			//安装TSS描述符，每个CPU都需要执行一次
f01001fd:	e8 a5 36 00 00       	call   f01038a7 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up，需要原子操作
f0100202:	e8 f0 5b 00 00       	call   f0105df7 <cpunum>
f0100207:	6b d0 74             	imul   $0x74,%eax,%edx
f010020a:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f010020d:	b8 01 00 00 00       	mov    $0x1,%eax
f0100212:	f0 87 82 20 a0 1e f0 	lock xchg %eax,-0xfe15fe0(%edx)
f0100219:	c7 04 24 c0 23 12 f0 	movl   $0xf01223c0,(%esp)
f0100220:	e8 42 5e 00 00       	call   f0106067 <spin_lock>
	sched_yield();
f0100225:	e8 1f 44 00 00       	call   f0104649 <sched_yield>

f010022a <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010022a:	55                   	push   %ebp
f010022b:	89 e5                	mov    %esp,%ebp
f010022d:	53                   	push   %ebx
f010022e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100231:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100234:	ff 75 0c             	pushl  0xc(%ebp)
f0100237:	ff 75 08             	pushl  0x8(%ebp)
f010023a:	68 e9 64 10 f0       	push   $0xf01064e9
f010023f:	e8 4f 36 00 00       	call   f0103893 <cprintf>
	vcprintf(fmt, ap);
f0100244:	83 c4 08             	add    $0x8,%esp
f0100247:	53                   	push   %ebx
f0100248:	ff 75 10             	pushl  0x10(%ebp)
f010024b:	e8 1d 36 00 00       	call   f010386d <vcprintf>
	cprintf("\n");
f0100250:	c7 04 24 3b 76 10 f0 	movl   $0xf010763b,(%esp)
f0100257:	e8 37 36 00 00       	call   f0103893 <cprintf>
	va_end(ap);
}
f010025c:	83 c4 10             	add    $0x10,%esp
f010025f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100262:	c9                   	leave  
f0100263:	c3                   	ret    

f0100264 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100264:	55                   	push   %ebp
f0100265:	89 e5                	mov    %esp,%ebp
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100267:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010026c:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010026d:	a8 01                	test   $0x1,%al
f010026f:	74 0b                	je     f010027c <serial_proc_data+0x18>
f0100271:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100276:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100277:	0f b6 c0             	movzbl %al,%eax
}
f010027a:	5d                   	pop    %ebp
f010027b:	c3                   	ret    
		return -1;
f010027c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100281:	eb f7                	jmp    f010027a <serial_proc_data+0x16>

f0100283 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100283:	55                   	push   %ebp
f0100284:	89 e5                	mov    %esp,%ebp
f0100286:	53                   	push   %ebx
f0100287:	83 ec 04             	sub    $0x4,%esp
f010028a:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f010028c:	ff d3                	call   *%ebx
f010028e:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100291:	74 2d                	je     f01002c0 <cons_intr+0x3d>
		if (c == 0)
f0100293:	85 c0                	test   %eax,%eax
f0100295:	74 f5                	je     f010028c <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f0100297:	8b 0d 24 92 1e f0    	mov    0xf01e9224,%ecx
f010029d:	8d 51 01             	lea    0x1(%ecx),%edx
f01002a0:	89 15 24 92 1e f0    	mov    %edx,0xf01e9224
f01002a6:	88 81 20 90 1e f0    	mov    %al,-0xfe16fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002ac:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01002b2:	75 d8                	jne    f010028c <cons_intr+0x9>
			cons.wpos = 0;
f01002b4:	c7 05 24 92 1e f0 00 	movl   $0x0,0xf01e9224
f01002bb:	00 00 00 
f01002be:	eb cc                	jmp    f010028c <cons_intr+0x9>
	}
}
f01002c0:	83 c4 04             	add    $0x4,%esp
f01002c3:	5b                   	pop    %ebx
f01002c4:	5d                   	pop    %ebp
f01002c5:	c3                   	ret    

f01002c6 <kbd_proc_data>:
{
f01002c6:	55                   	push   %ebp
f01002c7:	89 e5                	mov    %esp,%ebp
f01002c9:	53                   	push   %ebx
f01002ca:	83 ec 04             	sub    $0x4,%esp
f01002cd:	ba 64 00 00 00       	mov    $0x64,%edx
f01002d2:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002d3:	a8 01                	test   $0x1,%al
f01002d5:	0f 84 fa 00 00 00    	je     f01003d5 <kbd_proc_data+0x10f>
	if (stat & KBS_TERR)
f01002db:	a8 20                	test   $0x20,%al
f01002dd:	0f 85 f9 00 00 00    	jne    f01003dc <kbd_proc_data+0x116>
f01002e3:	ba 60 00 00 00       	mov    $0x60,%edx
f01002e8:	ec                   	in     (%dx),%al
f01002e9:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002eb:	3c e0                	cmp    $0xe0,%al
f01002ed:	0f 84 8e 00 00 00    	je     f0100381 <kbd_proc_data+0xbb>
	} else if (data & 0x80) {
f01002f3:	84 c0                	test   %al,%al
f01002f5:	0f 88 99 00 00 00    	js     f0100394 <kbd_proc_data+0xce>
	} else if (shift & E0ESC) {
f01002fb:	8b 0d 00 90 1e f0    	mov    0xf01e9000,%ecx
f0100301:	f6 c1 40             	test   $0x40,%cl
f0100304:	74 0e                	je     f0100314 <kbd_proc_data+0x4e>
		data |= 0x80;
f0100306:	83 c8 80             	or     $0xffffff80,%eax
f0100309:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f010030b:	83 e1 bf             	and    $0xffffffbf,%ecx
f010030e:	89 0d 00 90 1e f0    	mov    %ecx,0xf01e9000
	shift |= shiftcode[data];
f0100314:	0f b6 d2             	movzbl %dl,%edx
f0100317:	0f b6 82 60 66 10 f0 	movzbl -0xfef99a0(%edx),%eax
f010031e:	0b 05 00 90 1e f0    	or     0xf01e9000,%eax
	shift ^= togglecode[data];
f0100324:	0f b6 8a 60 65 10 f0 	movzbl -0xfef9aa0(%edx),%ecx
f010032b:	31 c8                	xor    %ecx,%eax
f010032d:	a3 00 90 1e f0       	mov    %eax,0xf01e9000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100332:	89 c1                	mov    %eax,%ecx
f0100334:	83 e1 03             	and    $0x3,%ecx
f0100337:	8b 0c 8d 40 65 10 f0 	mov    -0xfef9ac0(,%ecx,4),%ecx
f010033e:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100342:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100345:	a8 08                	test   $0x8,%al
f0100347:	74 0d                	je     f0100356 <kbd_proc_data+0x90>
		if ('a' <= c && c <= 'z')
f0100349:	89 da                	mov    %ebx,%edx
f010034b:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f010034e:	83 f9 19             	cmp    $0x19,%ecx
f0100351:	77 74                	ja     f01003c7 <kbd_proc_data+0x101>
			c += 'A' - 'a';
f0100353:	83 eb 20             	sub    $0x20,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100356:	f7 d0                	not    %eax
f0100358:	a8 06                	test   $0x6,%al
f010035a:	75 31                	jne    f010038d <kbd_proc_data+0xc7>
f010035c:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100362:	75 29                	jne    f010038d <kbd_proc_data+0xc7>
		cprintf("Rebooting!\n");
f0100364:	83 ec 0c             	sub    $0xc,%esp
f0100367:	68 03 65 10 f0       	push   $0xf0106503
f010036c:	e8 22 35 00 00       	call   f0103893 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100371:	b8 03 00 00 00       	mov    $0x3,%eax
f0100376:	ba 92 00 00 00       	mov    $0x92,%edx
f010037b:	ee                   	out    %al,(%dx)
f010037c:	83 c4 10             	add    $0x10,%esp
f010037f:	eb 0c                	jmp    f010038d <kbd_proc_data+0xc7>
		shift |= E0ESC;
f0100381:	83 0d 00 90 1e f0 40 	orl    $0x40,0xf01e9000
		return 0;
f0100388:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010038d:	89 d8                	mov    %ebx,%eax
f010038f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100392:	c9                   	leave  
f0100393:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100394:	8b 0d 00 90 1e f0    	mov    0xf01e9000,%ecx
f010039a:	89 cb                	mov    %ecx,%ebx
f010039c:	83 e3 40             	and    $0x40,%ebx
f010039f:	83 e0 7f             	and    $0x7f,%eax
f01003a2:	85 db                	test   %ebx,%ebx
f01003a4:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003a7:	0f b6 d2             	movzbl %dl,%edx
f01003aa:	0f b6 82 60 66 10 f0 	movzbl -0xfef99a0(%edx),%eax
f01003b1:	83 c8 40             	or     $0x40,%eax
f01003b4:	0f b6 c0             	movzbl %al,%eax
f01003b7:	f7 d0                	not    %eax
f01003b9:	21 c8                	and    %ecx,%eax
f01003bb:	a3 00 90 1e f0       	mov    %eax,0xf01e9000
		return 0;
f01003c0:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003c5:	eb c6                	jmp    f010038d <kbd_proc_data+0xc7>
		else if ('A' <= c && c <= 'Z')
f01003c7:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003ca:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003cd:	83 fa 1a             	cmp    $0x1a,%edx
f01003d0:	0f 42 d9             	cmovb  %ecx,%ebx
f01003d3:	eb 81                	jmp    f0100356 <kbd_proc_data+0x90>
		return -1;
f01003d5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003da:	eb b1                	jmp    f010038d <kbd_proc_data+0xc7>
		return -1;
f01003dc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003e1:	eb aa                	jmp    f010038d <kbd_proc_data+0xc7>

f01003e3 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003e3:	55                   	push   %ebp
f01003e4:	89 e5                	mov    %esp,%ebp
f01003e6:	57                   	push   %edi
f01003e7:	56                   	push   %esi
f01003e8:	53                   	push   %ebx
f01003e9:	83 ec 1c             	sub    $0x1c,%esp
f01003ec:	89 c7                	mov    %eax,%edi
	for (i = 0;
f01003ee:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003f3:	be fd 03 00 00       	mov    $0x3fd,%esi
f01003f8:	b9 84 00 00 00       	mov    $0x84,%ecx
f01003fd:	eb 09                	jmp    f0100408 <cons_putc+0x25>
f01003ff:	89 ca                	mov    %ecx,%edx
f0100401:	ec                   	in     (%dx),%al
f0100402:	ec                   	in     (%dx),%al
f0100403:	ec                   	in     (%dx),%al
f0100404:	ec                   	in     (%dx),%al
	     i++)
f0100405:	83 c3 01             	add    $0x1,%ebx
f0100408:	89 f2                	mov    %esi,%edx
f010040a:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f010040b:	a8 20                	test   $0x20,%al
f010040d:	75 08                	jne    f0100417 <cons_putc+0x34>
f010040f:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f0100415:	7e e8                	jle    f01003ff <cons_putc+0x1c>
	outb(COM1 + COM_TX, c);
f0100417:	89 f8                	mov    %edi,%eax
f0100419:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010041c:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100421:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100422:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100427:	be 79 03 00 00       	mov    $0x379,%esi
f010042c:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100431:	eb 09                	jmp    f010043c <cons_putc+0x59>
f0100433:	89 ca                	mov    %ecx,%edx
f0100435:	ec                   	in     (%dx),%al
f0100436:	ec                   	in     (%dx),%al
f0100437:	ec                   	in     (%dx),%al
f0100438:	ec                   	in     (%dx),%al
f0100439:	83 c3 01             	add    $0x1,%ebx
f010043c:	89 f2                	mov    %esi,%edx
f010043e:	ec                   	in     (%dx),%al
f010043f:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f0100445:	7f 04                	jg     f010044b <cons_putc+0x68>
f0100447:	84 c0                	test   %al,%al
f0100449:	79 e8                	jns    f0100433 <cons_putc+0x50>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010044b:	ba 78 03 00 00       	mov    $0x378,%edx
f0100450:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100454:	ee                   	out    %al,(%dx)
f0100455:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010045a:	b8 0d 00 00 00       	mov    $0xd,%eax
f010045f:	ee                   	out    %al,(%dx)
f0100460:	b8 08 00 00 00       	mov    $0x8,%eax
f0100465:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f0100466:	89 fa                	mov    %edi,%edx
f0100468:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f010046e:	89 f8                	mov    %edi,%eax
f0100470:	80 cc 07             	or     $0x7,%ah
f0100473:	85 d2                	test   %edx,%edx
f0100475:	0f 44 f8             	cmove  %eax,%edi
	switch (c & 0xff) {
f0100478:	89 f8                	mov    %edi,%eax
f010047a:	0f b6 c0             	movzbl %al,%eax
f010047d:	83 f8 09             	cmp    $0x9,%eax
f0100480:	0f 84 b6 00 00 00    	je     f010053c <cons_putc+0x159>
f0100486:	83 f8 09             	cmp    $0x9,%eax
f0100489:	7e 73                	jle    f01004fe <cons_putc+0x11b>
f010048b:	83 f8 0a             	cmp    $0xa,%eax
f010048e:	0f 84 9b 00 00 00    	je     f010052f <cons_putc+0x14c>
f0100494:	83 f8 0d             	cmp    $0xd,%eax
f0100497:	0f 85 d6 00 00 00    	jne    f0100573 <cons_putc+0x190>
		crt_pos -= (crt_pos % CRT_COLS);
f010049d:	0f b7 05 28 92 1e f0 	movzwl 0xf01e9228,%eax
f01004a4:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004aa:	c1 e8 16             	shr    $0x16,%eax
f01004ad:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004b0:	c1 e0 04             	shl    $0x4,%eax
f01004b3:	66 a3 28 92 1e f0    	mov    %ax,0xf01e9228
	if (crt_pos >= CRT_SIZE) {		//判断是否需要滚屏。文本模式下一页屏幕最多显示25*80个字符，
f01004b9:	66 81 3d 28 92 1e f0 	cmpw   $0x7cf,0xf01e9228
f01004c0:	cf 07 
f01004c2:	0f 87 ce 00 00 00    	ja     f0100596 <cons_putc+0x1b3>
	outb(addr_6845, 14);
f01004c8:	8b 0d 30 92 1e f0    	mov    0xf01e9230,%ecx
f01004ce:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004d3:	89 ca                	mov    %ecx,%edx
f01004d5:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004d6:	0f b7 1d 28 92 1e f0 	movzwl 0xf01e9228,%ebx
f01004dd:	8d 71 01             	lea    0x1(%ecx),%esi
f01004e0:	89 d8                	mov    %ebx,%eax
f01004e2:	66 c1 e8 08          	shr    $0x8,%ax
f01004e6:	89 f2                	mov    %esi,%edx
f01004e8:	ee                   	out    %al,(%dx)
f01004e9:	b8 0f 00 00 00       	mov    $0xf,%eax
f01004ee:	89 ca                	mov    %ecx,%edx
f01004f0:	ee                   	out    %al,(%dx)
f01004f1:	89 d8                	mov    %ebx,%eax
f01004f3:	89 f2                	mov    %esi,%edx
f01004f5:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f01004f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01004f9:	5b                   	pop    %ebx
f01004fa:	5e                   	pop    %esi
f01004fb:	5f                   	pop    %edi
f01004fc:	5d                   	pop    %ebp
f01004fd:	c3                   	ret    
	switch (c & 0xff) {
f01004fe:	83 f8 08             	cmp    $0x8,%eax
f0100501:	75 70                	jne    f0100573 <cons_putc+0x190>
		if (crt_pos > 0) {
f0100503:	0f b7 05 28 92 1e f0 	movzwl 0xf01e9228,%eax
f010050a:	66 85 c0             	test   %ax,%ax
f010050d:	74 b9                	je     f01004c8 <cons_putc+0xe5>
			crt_pos--;
f010050f:	83 e8 01             	sub    $0x1,%eax
f0100512:	66 a3 28 92 1e f0    	mov    %ax,0xf01e9228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100518:	0f b7 c0             	movzwl %ax,%eax
f010051b:	66 81 e7 00 ff       	and    $0xff00,%di
f0100520:	83 cf 20             	or     $0x20,%edi
f0100523:	8b 15 2c 92 1e f0    	mov    0xf01e922c,%edx
f0100529:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f010052d:	eb 8a                	jmp    f01004b9 <cons_putc+0xd6>
		crt_pos += CRT_COLS;
f010052f:	66 83 05 28 92 1e f0 	addw   $0x50,0xf01e9228
f0100536:	50 
f0100537:	e9 61 ff ff ff       	jmp    f010049d <cons_putc+0xba>
		cons_putc(' ');
f010053c:	b8 20 00 00 00       	mov    $0x20,%eax
f0100541:	e8 9d fe ff ff       	call   f01003e3 <cons_putc>
		cons_putc(' ');
f0100546:	b8 20 00 00 00       	mov    $0x20,%eax
f010054b:	e8 93 fe ff ff       	call   f01003e3 <cons_putc>
		cons_putc(' ');
f0100550:	b8 20 00 00 00       	mov    $0x20,%eax
f0100555:	e8 89 fe ff ff       	call   f01003e3 <cons_putc>
		cons_putc(' ');
f010055a:	b8 20 00 00 00       	mov    $0x20,%eax
f010055f:	e8 7f fe ff ff       	call   f01003e3 <cons_putc>
		cons_putc(' ');
f0100564:	b8 20 00 00 00       	mov    $0x20,%eax
f0100569:	e8 75 fe ff ff       	call   f01003e3 <cons_putc>
f010056e:	e9 46 ff ff ff       	jmp    f01004b9 <cons_putc+0xd6>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100573:	0f b7 05 28 92 1e f0 	movzwl 0xf01e9228,%eax
f010057a:	8d 50 01             	lea    0x1(%eax),%edx
f010057d:	66 89 15 28 92 1e f0 	mov    %dx,0xf01e9228
f0100584:	0f b7 c0             	movzwl %ax,%eax
f0100587:	8b 15 2c 92 1e f0    	mov    0xf01e922c,%edx
f010058d:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100591:	e9 23 ff ff ff       	jmp    f01004b9 <cons_putc+0xd6>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100596:	a1 2c 92 1e f0       	mov    0xf01e922c,%eax
f010059b:	83 ec 04             	sub    $0x4,%esp
f010059e:	68 00 0f 00 00       	push   $0xf00
f01005a3:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005a9:	52                   	push   %edx
f01005aa:	50                   	push   %eax
f01005ab:	e8 6f 52 00 00       	call   f010581f <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005b0:	8b 15 2c 92 1e f0    	mov    0xf01e922c,%edx
f01005b6:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005bc:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005c2:	83 c4 10             	add    $0x10,%esp
f01005c5:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005ca:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005cd:	39 d0                	cmp    %edx,%eax
f01005cf:	75 f4                	jne    f01005c5 <cons_putc+0x1e2>
		crt_pos -= CRT_COLS;
f01005d1:	66 83 2d 28 92 1e f0 	subw   $0x50,0xf01e9228
f01005d8:	50 
f01005d9:	e9 ea fe ff ff       	jmp    f01004c8 <cons_putc+0xe5>

f01005de <serial_intr>:
	if (serial_exists)
f01005de:	80 3d 34 92 1e f0 00 	cmpb   $0x0,0xf01e9234
f01005e5:	75 02                	jne    f01005e9 <serial_intr+0xb>
f01005e7:	f3 c3                	repz ret 
{
f01005e9:	55                   	push   %ebp
f01005ea:	89 e5                	mov    %esp,%ebp
f01005ec:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01005ef:	b8 64 02 10 f0       	mov    $0xf0100264,%eax
f01005f4:	e8 8a fc ff ff       	call   f0100283 <cons_intr>
}
f01005f9:	c9                   	leave  
f01005fa:	c3                   	ret    

f01005fb <kbd_intr>:
{
f01005fb:	55                   	push   %ebp
f01005fc:	89 e5                	mov    %esp,%ebp
f01005fe:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100601:	b8 c6 02 10 f0       	mov    $0xf01002c6,%eax
f0100606:	e8 78 fc ff ff       	call   f0100283 <cons_intr>
}
f010060b:	c9                   	leave  
f010060c:	c3                   	ret    

f010060d <cons_getc>:
{
f010060d:	55                   	push   %ebp
f010060e:	89 e5                	mov    %esp,%ebp
f0100610:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f0100613:	e8 c6 ff ff ff       	call   f01005de <serial_intr>
	kbd_intr();
f0100618:	e8 de ff ff ff       	call   f01005fb <kbd_intr>
	if (cons.rpos != cons.wpos) {
f010061d:	8b 15 20 92 1e f0    	mov    0xf01e9220,%edx
	return 0;
f0100623:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100628:	3b 15 24 92 1e f0    	cmp    0xf01e9224,%edx
f010062e:	74 18                	je     f0100648 <cons_getc+0x3b>
		c = cons.buf[cons.rpos++];
f0100630:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100633:	89 0d 20 92 1e f0    	mov    %ecx,0xf01e9220
f0100639:	0f b6 82 20 90 1e f0 	movzbl -0xfe16fe0(%edx),%eax
		if (cons.rpos == CONSBUFSIZE)
f0100640:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100646:	74 02                	je     f010064a <cons_getc+0x3d>
}
f0100648:	c9                   	leave  
f0100649:	c3                   	ret    
			cons.rpos = 0;
f010064a:	c7 05 20 92 1e f0 00 	movl   $0x0,0xf01e9220
f0100651:	00 00 00 
f0100654:	eb f2                	jmp    f0100648 <cons_getc+0x3b>

f0100656 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100656:	55                   	push   %ebp
f0100657:	89 e5                	mov    %esp,%ebp
f0100659:	57                   	push   %edi
f010065a:	56                   	push   %esi
f010065b:	53                   	push   %ebx
f010065c:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f010065f:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f0100666:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f010066d:	5a a5 
	if (*cp != 0xA55A) {
f010066f:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100676:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010067a:	0f 84 de 00 00 00    	je     f010075e <cons_init+0x108>
		addr_6845 = MONO_BASE;
f0100680:	c7 05 30 92 1e f0 b4 	movl   $0x3b4,0xf01e9230
f0100687:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010068a:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f010068f:	8b 3d 30 92 1e f0    	mov    0xf01e9230,%edi
f0100695:	b8 0e 00 00 00       	mov    $0xe,%eax
f010069a:	89 fa                	mov    %edi,%edx
f010069c:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010069d:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006a0:	89 ca                	mov    %ecx,%edx
f01006a2:	ec                   	in     (%dx),%al
f01006a3:	0f b6 c0             	movzbl %al,%eax
f01006a6:	c1 e0 08             	shl    $0x8,%eax
f01006a9:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006ab:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006b0:	89 fa                	mov    %edi,%edx
f01006b2:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006b3:	89 ca                	mov    %ecx,%edx
f01006b5:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006b6:	89 35 2c 92 1e f0    	mov    %esi,0xf01e922c
	pos |= inb(addr_6845 + 1);
f01006bc:	0f b6 c0             	movzbl %al,%eax
f01006bf:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006c1:	66 a3 28 92 1e f0    	mov    %ax,0xf01e9228
	kbd_intr();
f01006c7:	e8 2f ff ff ff       	call   f01005fb <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006cc:	83 ec 0c             	sub    $0xc,%esp
f01006cf:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f01006d6:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006db:	50                   	push   %eax
f01006dc:	e8 57 30 00 00       	call   f0103738 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006e1:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006e6:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01006eb:	89 d8                	mov    %ebx,%eax
f01006ed:	89 ca                	mov    %ecx,%edx
f01006ef:	ee                   	out    %al,(%dx)
f01006f0:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01006f5:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01006fa:	89 fa                	mov    %edi,%edx
f01006fc:	ee                   	out    %al,(%dx)
f01006fd:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100702:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100707:	ee                   	out    %al,(%dx)
f0100708:	be f9 03 00 00       	mov    $0x3f9,%esi
f010070d:	89 d8                	mov    %ebx,%eax
f010070f:	89 f2                	mov    %esi,%edx
f0100711:	ee                   	out    %al,(%dx)
f0100712:	b8 03 00 00 00       	mov    $0x3,%eax
f0100717:	89 fa                	mov    %edi,%edx
f0100719:	ee                   	out    %al,(%dx)
f010071a:	ba fc 03 00 00       	mov    $0x3fc,%edx
f010071f:	89 d8                	mov    %ebx,%eax
f0100721:	ee                   	out    %al,(%dx)
f0100722:	b8 01 00 00 00       	mov    $0x1,%eax
f0100727:	89 f2                	mov    %esi,%edx
f0100729:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010072a:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010072f:	ec                   	in     (%dx),%al
f0100730:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100732:	83 c4 10             	add    $0x10,%esp
f0100735:	3c ff                	cmp    $0xff,%al
f0100737:	0f 95 05 34 92 1e f0 	setne  0xf01e9234
f010073e:	89 ca                	mov    %ecx,%edx
f0100740:	ec                   	in     (%dx),%al
f0100741:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100746:	ec                   	in     (%dx),%al
	if (serial_exists)
f0100747:	80 fb ff             	cmp    $0xff,%bl
f010074a:	75 2d                	jne    f0100779 <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f010074c:	83 ec 0c             	sub    $0xc,%esp
f010074f:	68 0f 65 10 f0       	push   $0xf010650f
f0100754:	e8 3a 31 00 00       	call   f0103893 <cprintf>
f0100759:	83 c4 10             	add    $0x10,%esp
}
f010075c:	eb 3c                	jmp    f010079a <cons_init+0x144>
		*cp = was;
f010075e:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100765:	c7 05 30 92 1e f0 d4 	movl   $0x3d4,0xf01e9230
f010076c:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f010076f:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100774:	e9 16 ff ff ff       	jmp    f010068f <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100779:	83 ec 0c             	sub    $0xc,%esp
f010077c:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f0100783:	25 ef ff 00 00       	and    $0xffef,%eax
f0100788:	50                   	push   %eax
f0100789:	e8 aa 2f 00 00       	call   f0103738 <irq_setmask_8259A>
	if (!serial_exists)
f010078e:	83 c4 10             	add    $0x10,%esp
f0100791:	80 3d 34 92 1e f0 00 	cmpb   $0x0,0xf01e9234
f0100798:	74 b2                	je     f010074c <cons_init+0xf6>
}
f010079a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010079d:	5b                   	pop    %ebx
f010079e:	5e                   	pop    %esi
f010079f:	5f                   	pop    %edi
f01007a0:	5d                   	pop    %ebp
f01007a1:	c3                   	ret    

f01007a2 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007a2:	55                   	push   %ebp
f01007a3:	89 e5                	mov    %esp,%ebp
f01007a5:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007a8:	8b 45 08             	mov    0x8(%ebp),%eax
f01007ab:	e8 33 fc ff ff       	call   f01003e3 <cons_putc>
}
f01007b0:	c9                   	leave  
f01007b1:	c3                   	ret    

f01007b2 <getchar>:

int
getchar(void)
{
f01007b2:	55                   	push   %ebp
f01007b3:	89 e5                	mov    %esp,%ebp
f01007b5:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007b8:	e8 50 fe ff ff       	call   f010060d <cons_getc>
f01007bd:	85 c0                	test   %eax,%eax
f01007bf:	74 f7                	je     f01007b8 <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007c1:	c9                   	leave  
f01007c2:	c3                   	ret    

f01007c3 <iscons>:

int
iscons(int fdnum)
{
f01007c3:	55                   	push   %ebp
f01007c4:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01007c6:	b8 01 00 00 00       	mov    $0x1,%eax
f01007cb:	5d                   	pop    %ebp
f01007cc:	c3                   	ret    

f01007cd <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007cd:	55                   	push   %ebp
f01007ce:	89 e5                	mov    %esp,%ebp
f01007d0:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007d3:	68 60 67 10 f0       	push   $0xf0106760
f01007d8:	68 7e 67 10 f0       	push   $0xf010677e
f01007dd:	68 83 67 10 f0       	push   $0xf0106783
f01007e2:	e8 ac 30 00 00       	call   f0103893 <cprintf>
f01007e7:	83 c4 0c             	add    $0xc,%esp
f01007ea:	68 0c 68 10 f0       	push   $0xf010680c
f01007ef:	68 8c 67 10 f0       	push   $0xf010678c
f01007f4:	68 83 67 10 f0       	push   $0xf0106783
f01007f9:	e8 95 30 00 00       	call   f0103893 <cprintf>
f01007fe:	83 c4 0c             	add    $0xc,%esp
f0100801:	68 95 67 10 f0       	push   $0xf0106795
f0100806:	68 9b 67 10 f0       	push   $0xf010679b
f010080b:	68 83 67 10 f0       	push   $0xf0106783
f0100810:	e8 7e 30 00 00       	call   f0103893 <cprintf>
	return 0;
}
f0100815:	b8 00 00 00 00       	mov    $0x0,%eax
f010081a:	c9                   	leave  
f010081b:	c3                   	ret    

f010081c <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f010081c:	55                   	push   %ebp
f010081d:	89 e5                	mov    %esp,%ebp
f010081f:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100822:	68 a5 67 10 f0       	push   $0xf01067a5
f0100827:	e8 67 30 00 00       	call   f0103893 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f010082c:	83 c4 08             	add    $0x8,%esp
f010082f:	68 0c 00 10 00       	push   $0x10000c
f0100834:	68 34 68 10 f0       	push   $0xf0106834
f0100839:	e8 55 30 00 00       	call   f0103893 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010083e:	83 c4 0c             	add    $0xc,%esp
f0100841:	68 0c 00 10 00       	push   $0x10000c
f0100846:	68 0c 00 10 f0       	push   $0xf010000c
f010084b:	68 5c 68 10 f0       	push   $0xf010685c
f0100850:	e8 3e 30 00 00       	call   f0103893 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100855:	83 c4 0c             	add    $0xc,%esp
f0100858:	68 29 64 10 00       	push   $0x106429
f010085d:	68 29 64 10 f0       	push   $0xf0106429
f0100862:	68 80 68 10 f0       	push   $0xf0106880
f0100867:	e8 27 30 00 00       	call   f0103893 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010086c:	83 c4 0c             	add    $0xc,%esp
f010086f:	68 00 90 1e 00       	push   $0x1e9000
f0100874:	68 00 90 1e f0       	push   $0xf01e9000
f0100879:	68 a4 68 10 f0       	push   $0xf01068a4
f010087e:	e8 10 30 00 00       	call   f0103893 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100883:	83 c4 0c             	add    $0xc,%esp
f0100886:	68 08 b0 22 00       	push   $0x22b008
f010088b:	68 08 b0 22 f0       	push   $0xf022b008
f0100890:	68 c8 68 10 f0       	push   $0xf01068c8
f0100895:	e8 f9 2f 00 00       	call   f0103893 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f010089a:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f010089d:	b8 07 b4 22 f0       	mov    $0xf022b407,%eax
f01008a2:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008a7:	c1 f8 0a             	sar    $0xa,%eax
f01008aa:	50                   	push   %eax
f01008ab:	68 ec 68 10 f0       	push   $0xf01068ec
f01008b0:	e8 de 2f 00 00       	call   f0103893 <cprintf>
	return 0;
}
f01008b5:	b8 00 00 00 00       	mov    $0x0,%eax
f01008ba:	c9                   	leave  
f01008bb:	c3                   	ret    

f01008bc <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008bc:	55                   	push   %ebp
f01008bd:	89 e5                	mov    %esp,%ebp
f01008bf:	57                   	push   %edi
f01008c0:	56                   	push   %esi
f01008c1:	53                   	push   %ebx
f01008c2:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008c5:	89 eb                	mov    %ebp,%ebx
	while (ebp != 0) {
		//打印ebp, eip, 最近的五个参数
		uint32_t eip = *(ebp + 1);
		cprintf("ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, eip, *(ebp + 2), *(ebp + 3), *(ebp + 4), *(ebp + 5), *(ebp + 6));
		//打印文件名等信息
		debuginfo_eip((uintptr_t)eip, &eipdebuginfo);
f01008c7:	8d 7d d0             	lea    -0x30(%ebp),%edi
	while (ebp != 0) {
f01008ca:	eb 53                	jmp    f010091f <mon_backtrace+0x63>
		uint32_t eip = *(ebp + 1);
f01008cc:	8b 73 04             	mov    0x4(%ebx),%esi
		cprintf("ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, eip, *(ebp + 2), *(ebp + 3), *(ebp + 4), *(ebp + 5), *(ebp + 6));
f01008cf:	ff 73 18             	pushl  0x18(%ebx)
f01008d2:	ff 73 14             	pushl  0x14(%ebx)
f01008d5:	ff 73 10             	pushl  0x10(%ebx)
f01008d8:	ff 73 0c             	pushl  0xc(%ebx)
f01008db:	ff 73 08             	pushl  0x8(%ebx)
f01008de:	56                   	push   %esi
f01008df:	53                   	push   %ebx
f01008e0:	68 18 69 10 f0       	push   $0xf0106918
f01008e5:	e8 a9 2f 00 00       	call   f0103893 <cprintf>
		debuginfo_eip((uintptr_t)eip, &eipdebuginfo);
f01008ea:	83 c4 18             	add    $0x18,%esp
f01008ed:	57                   	push   %edi
f01008ee:	56                   	push   %esi
f01008ef:	e8 43 44 00 00       	call   f0104d37 <debuginfo_eip>
		cprintf("%s:%d", eipdebuginfo.eip_file, eipdebuginfo.eip_line);
f01008f4:	83 c4 0c             	add    $0xc,%esp
f01008f7:	ff 75 d4             	pushl  -0x2c(%ebp)
f01008fa:	ff 75 d0             	pushl  -0x30(%ebp)
f01008fd:	68 be 67 10 f0       	push   $0xf01067be
f0100902:	e8 8c 2f 00 00       	call   f0103893 <cprintf>
		cprintf(": %.*s+%d\n", eipdebuginfo.eip_fn_namelen, eipdebuginfo.eip_fn_name, eipdebuginfo.eip_fn_addr);
f0100907:	ff 75 e0             	pushl  -0x20(%ebp)
f010090a:	ff 75 d8             	pushl  -0x28(%ebp)
f010090d:	ff 75 dc             	pushl  -0x24(%ebp)
f0100910:	68 c4 67 10 f0       	push   $0xf01067c4
f0100915:	e8 79 2f 00 00       	call   f0103893 <cprintf>
		//更新ebp
		ebp = (uint32_t *)(*ebp);
f010091a:	8b 1b                	mov    (%ebx),%ebx
f010091c:	83 c4 20             	add    $0x20,%esp
	while (ebp != 0) {
f010091f:	85 db                	test   %ebx,%ebx
f0100921:	75 a9                	jne    f01008cc <mon_backtrace+0x10>
	}
	return 0;
}
f0100923:	b8 00 00 00 00       	mov    $0x0,%eax
f0100928:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010092b:	5b                   	pop    %ebx
f010092c:	5e                   	pop    %esi
f010092d:	5f                   	pop    %edi
f010092e:	5d                   	pop    %ebp
f010092f:	c3                   	ret    

f0100930 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100930:	55                   	push   %ebp
f0100931:	89 e5                	mov    %esp,%ebp
f0100933:	57                   	push   %edi
f0100934:	56                   	push   %esi
f0100935:	53                   	push   %ebx
f0100936:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100939:	68 4c 69 10 f0       	push   $0xf010694c
f010093e:	e8 50 2f 00 00       	call   f0103893 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100943:	c7 04 24 70 69 10 f0 	movl   $0xf0106970,(%esp)
f010094a:	e8 44 2f 00 00       	call   f0103893 <cprintf>

	if (tf != NULL)
f010094f:	83 c4 10             	add    $0x10,%esp
f0100952:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100956:	74 57                	je     f01009af <monitor+0x7f>
		print_trapframe(tf);
f0100958:	83 ec 0c             	sub    $0xc,%esp
f010095b:	ff 75 08             	pushl  0x8(%ebp)
f010095e:	e8 0f 36 00 00       	call   f0103f72 <print_trapframe>
f0100963:	83 c4 10             	add    $0x10,%esp
f0100966:	eb 47                	jmp    f01009af <monitor+0x7f>
		while (*buf && strchr(WHITESPACE, *buf))
f0100968:	83 ec 08             	sub    $0x8,%esp
f010096b:	0f be c0             	movsbl %al,%eax
f010096e:	50                   	push   %eax
f010096f:	68 d3 67 10 f0       	push   $0xf01067d3
f0100974:	e8 1c 4e 00 00       	call   f0105795 <strchr>
f0100979:	83 c4 10             	add    $0x10,%esp
f010097c:	85 c0                	test   %eax,%eax
f010097e:	74 0a                	je     f010098a <monitor+0x5a>
			*buf++ = 0;
f0100980:	c6 03 00             	movb   $0x0,(%ebx)
f0100983:	89 f7                	mov    %esi,%edi
f0100985:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100988:	eb 6b                	jmp    f01009f5 <monitor+0xc5>
		if (*buf == 0)
f010098a:	80 3b 00             	cmpb   $0x0,(%ebx)
f010098d:	74 73                	je     f0100a02 <monitor+0xd2>
		if (argc == MAXARGS-1) {
f010098f:	83 fe 0f             	cmp    $0xf,%esi
f0100992:	74 09                	je     f010099d <monitor+0x6d>
		argv[argc++] = buf;
f0100994:	8d 7e 01             	lea    0x1(%esi),%edi
f0100997:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f010099b:	eb 39                	jmp    f01009d6 <monitor+0xa6>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f010099d:	83 ec 08             	sub    $0x8,%esp
f01009a0:	6a 10                	push   $0x10
f01009a2:	68 d8 67 10 f0       	push   $0xf01067d8
f01009a7:	e8 e7 2e 00 00       	call   f0103893 <cprintf>
f01009ac:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f01009af:	83 ec 0c             	sub    $0xc,%esp
f01009b2:	68 cf 67 10 f0       	push   $0xf01067cf
f01009b7:	e8 b0 4b 00 00       	call   f010556c <readline>
f01009bc:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f01009be:	83 c4 10             	add    $0x10,%esp
f01009c1:	85 c0                	test   %eax,%eax
f01009c3:	74 ea                	je     f01009af <monitor+0x7f>
	argv[argc] = 0;
f01009c5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f01009cc:	be 00 00 00 00       	mov    $0x0,%esi
f01009d1:	eb 24                	jmp    f01009f7 <monitor+0xc7>
			buf++;
f01009d3:	83 c3 01             	add    $0x1,%ebx
		while (*buf && !strchr(WHITESPACE, *buf))
f01009d6:	0f b6 03             	movzbl (%ebx),%eax
f01009d9:	84 c0                	test   %al,%al
f01009db:	74 18                	je     f01009f5 <monitor+0xc5>
f01009dd:	83 ec 08             	sub    $0x8,%esp
f01009e0:	0f be c0             	movsbl %al,%eax
f01009e3:	50                   	push   %eax
f01009e4:	68 d3 67 10 f0       	push   $0xf01067d3
f01009e9:	e8 a7 4d 00 00       	call   f0105795 <strchr>
f01009ee:	83 c4 10             	add    $0x10,%esp
f01009f1:	85 c0                	test   %eax,%eax
f01009f3:	74 de                	je     f01009d3 <monitor+0xa3>
			*buf++ = 0;
f01009f5:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f01009f7:	0f b6 03             	movzbl (%ebx),%eax
f01009fa:	84 c0                	test   %al,%al
f01009fc:	0f 85 66 ff ff ff    	jne    f0100968 <monitor+0x38>
	argv[argc] = 0;
f0100a02:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100a09:	00 
	if (argc == 0)
f0100a0a:	85 f6                	test   %esi,%esi
f0100a0c:	74 a1                	je     f01009af <monitor+0x7f>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a0e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100a13:	83 ec 08             	sub    $0x8,%esp
f0100a16:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a19:	ff 34 85 a0 69 10 f0 	pushl  -0xfef9660(,%eax,4)
f0100a20:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a23:	e8 0f 4d 00 00       	call   f0105737 <strcmp>
f0100a28:	83 c4 10             	add    $0x10,%esp
f0100a2b:	85 c0                	test   %eax,%eax
f0100a2d:	74 20                	je     f0100a4f <monitor+0x11f>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a2f:	83 c3 01             	add    $0x1,%ebx
f0100a32:	83 fb 03             	cmp    $0x3,%ebx
f0100a35:	75 dc                	jne    f0100a13 <monitor+0xe3>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a37:	83 ec 08             	sub    $0x8,%esp
f0100a3a:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a3d:	68 f5 67 10 f0       	push   $0xf01067f5
f0100a42:	e8 4c 2e 00 00       	call   f0103893 <cprintf>
f0100a47:	83 c4 10             	add    $0x10,%esp
f0100a4a:	e9 60 ff ff ff       	jmp    f01009af <monitor+0x7f>
			return commands[i].func(argc, argv, tf);
f0100a4f:	83 ec 04             	sub    $0x4,%esp
f0100a52:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a55:	ff 75 08             	pushl  0x8(%ebp)
f0100a58:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100a5b:	52                   	push   %edx
f0100a5c:	56                   	push   %esi
f0100a5d:	ff 14 85 a8 69 10 f0 	call   *-0xfef9658(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100a64:	83 c4 10             	add    $0x10,%esp
f0100a67:	85 c0                	test   %eax,%eax
f0100a69:	0f 89 40 ff ff ff    	jns    f01009af <monitor+0x7f>
				break;
	}
}
f0100a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a72:	5b                   	pop    %ebx
f0100a73:	5e                   	pop    %esi
f0100a74:	5f                   	pop    %edi
f0100a75:	5d                   	pop    %ebp
f0100a76:	c3                   	ret    

f0100a77 <boot_alloc>:
// before the page_free_list list has been set up.
// Note that when this function is called, we are still using entry_pgdir,
// which only maps the first 4MB of physical memory.
static void *
boot_alloc(uint32_t n)
{
f0100a77:	55                   	push   %ebp
f0100a78:	89 e5                	mov    %esp,%ebp
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100a7a:	83 3d 38 92 1e f0 00 	cmpl   $0x0,0xf01e9238
f0100a81:	74 1d                	je     f0100aa0 <boot_alloc+0x29>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
f0100a83:	8b 0d 38 92 1e f0    	mov    0xf01e9238,%ecx
	nextfree = ROUNDUP((char *)result + n, PGSIZE);
f0100a89:	8d 94 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edx
f0100a90:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100a96:	89 15 38 92 1e f0    	mov    %edx,0xf01e9238
	return result;
}
f0100a9c:	89 c8                	mov    %ecx,%eax
f0100a9e:	5d                   	pop    %ebp
f0100a9f:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100aa0:	ba 07 c0 22 f0       	mov    $0xf022c007,%edx
f0100aa5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100aab:	89 15 38 92 1e f0    	mov    %edx,0xf01e9238
f0100ab1:	eb d0                	jmp    f0100a83 <boot_alloc+0xc>

f0100ab3 <nvram_read>:
{
f0100ab3:	55                   	push   %ebp
f0100ab4:	89 e5                	mov    %esp,%ebp
f0100ab6:	56                   	push   %esi
f0100ab7:	53                   	push   %ebx
f0100ab8:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100aba:	83 ec 0c             	sub    $0xc,%esp
f0100abd:	50                   	push   %eax
f0100abe:	e8 47 2c 00 00       	call   f010370a <mc146818_read>
f0100ac3:	89 c3                	mov    %eax,%ebx
f0100ac5:	83 c6 01             	add    $0x1,%esi
f0100ac8:	89 34 24             	mov    %esi,(%esp)
f0100acb:	e8 3a 2c 00 00       	call   f010370a <mc146818_read>
f0100ad0:	c1 e0 08             	shl    $0x8,%eax
f0100ad3:	09 d8                	or     %ebx,%eax
}
f0100ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100ad8:	5b                   	pop    %ebx
f0100ad9:	5e                   	pop    %esi
f0100ada:	5d                   	pop    %ebp
f0100adb:	c3                   	ret    

f0100adc <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100adc:	89 d1                	mov    %edx,%ecx
f0100ade:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100ae1:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100ae4:	a8 01                	test   $0x1,%al
f0100ae6:	74 52                	je     f0100b3a <check_va2pa+0x5e>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100ae8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100aed:	89 c1                	mov    %eax,%ecx
f0100aef:	c1 e9 0c             	shr    $0xc,%ecx
f0100af2:	3b 0d 88 9e 1e f0    	cmp    0xf01e9e88,%ecx
f0100af8:	73 25                	jae    f0100b1f <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0100afa:	c1 ea 0c             	shr    $0xc,%edx
f0100afd:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b03:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100b0a:	89 c2                	mov    %eax,%edx
f0100b0c:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b14:	85 d2                	test   %edx,%edx
f0100b16:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b1b:	0f 44 c2             	cmove  %edx,%eax
f0100b1e:	c3                   	ret    
{
f0100b1f:	55                   	push   %ebp
f0100b20:	89 e5                	mov    %esp,%ebp
f0100b22:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b25:	50                   	push   %eax
f0100b26:	68 64 64 10 f0       	push   $0xf0106464
f0100b2b:	68 8e 03 00 00       	push   $0x38e
f0100b30:	68 49 73 10 f0       	push   $0xf0107349
f0100b35:	e8 06 f5 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100b3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100b3f:	c3                   	ret    

f0100b40 <check_page_free_list>:
{
f0100b40:	55                   	push   %ebp
f0100b41:	89 e5                	mov    %esp,%ebp
f0100b43:	57                   	push   %edi
f0100b44:	56                   	push   %esi
f0100b45:	53                   	push   %ebx
f0100b46:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b49:	84 c0                	test   %al,%al
f0100b4b:	0f 85 86 02 00 00    	jne    f0100dd7 <check_page_free_list+0x297>
	if (!page_free_list)
f0100b51:	83 3d 40 92 1e f0 00 	cmpl   $0x0,0xf01e9240
f0100b58:	74 0a                	je     f0100b64 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b5a:	be 00 04 00 00       	mov    $0x400,%esi
f0100b5f:	e9 ce 02 00 00       	jmp    f0100e32 <check_page_free_list+0x2f2>
		panic("'page_free_list' is a null pointer!");
f0100b64:	83 ec 04             	sub    $0x4,%esp
f0100b67:	68 c4 69 10 f0       	push   $0xf01069c4
f0100b6c:	68 c1 02 00 00       	push   $0x2c1
f0100b71:	68 49 73 10 f0       	push   $0xf0107349
f0100b76:	e8 c5 f4 ff ff       	call   f0100040 <_panic>
f0100b7b:	50                   	push   %eax
f0100b7c:	68 64 64 10 f0       	push   $0xf0106464
f0100b81:	6a 58                	push   $0x58
f0100b83:	68 55 73 10 f0       	push   $0xf0107355
f0100b88:	e8 b3 f4 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100b8d:	8b 1b                	mov    (%ebx),%ebx
f0100b8f:	85 db                	test   %ebx,%ebx
f0100b91:	74 41                	je     f0100bd4 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100b93:	89 d8                	mov    %ebx,%eax
f0100b95:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0100b9b:	c1 f8 03             	sar    $0x3,%eax
f0100b9e:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100ba1:	89 c2                	mov    %eax,%edx
f0100ba3:	c1 ea 16             	shr    $0x16,%edx
f0100ba6:	39 f2                	cmp    %esi,%edx
f0100ba8:	73 e3                	jae    f0100b8d <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100baa:	89 c2                	mov    %eax,%edx
f0100bac:	c1 ea 0c             	shr    $0xc,%edx
f0100baf:	3b 15 88 9e 1e f0    	cmp    0xf01e9e88,%edx
f0100bb5:	73 c4                	jae    f0100b7b <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100bb7:	83 ec 04             	sub    $0x4,%esp
f0100bba:	68 80 00 00 00       	push   $0x80
f0100bbf:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100bc4:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100bc9:	50                   	push   %eax
f0100bca:	e8 03 4c 00 00       	call   f01057d2 <memset>
f0100bcf:	83 c4 10             	add    $0x10,%esp
f0100bd2:	eb b9                	jmp    f0100b8d <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100bd4:	b8 00 00 00 00       	mov    $0x0,%eax
f0100bd9:	e8 99 fe ff ff       	call   f0100a77 <boot_alloc>
f0100bde:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100be1:	8b 15 40 92 1e f0    	mov    0xf01e9240,%edx
		assert(pp >= pages);
f0100be7:	8b 0d 90 9e 1e f0    	mov    0xf01e9e90,%ecx
		assert(pp < pages + npages);
f0100bed:	a1 88 9e 1e f0       	mov    0xf01e9e88,%eax
f0100bf2:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100bf5:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f0100bf8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100bfb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
	int nfree_basemem = 0, nfree_extmem = 0;
f0100bfe:	be 00 00 00 00       	mov    $0x0,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c03:	e9 04 01 00 00       	jmp    f0100d0c <check_page_free_list+0x1cc>
		assert(pp >= pages);
f0100c08:	68 63 73 10 f0       	push   $0xf0107363
f0100c0d:	68 6f 73 10 f0       	push   $0xf010736f
f0100c12:	68 db 02 00 00       	push   $0x2db
f0100c17:	68 49 73 10 f0       	push   $0xf0107349
f0100c1c:	e8 1f f4 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100c21:	68 84 73 10 f0       	push   $0xf0107384
f0100c26:	68 6f 73 10 f0       	push   $0xf010736f
f0100c2b:	68 dc 02 00 00       	push   $0x2dc
f0100c30:	68 49 73 10 f0       	push   $0xf0107349
f0100c35:	e8 06 f4 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100c3a:	68 e8 69 10 f0       	push   $0xf01069e8
f0100c3f:	68 6f 73 10 f0       	push   $0xf010736f
f0100c44:	68 dd 02 00 00       	push   $0x2dd
f0100c49:	68 49 73 10 f0       	push   $0xf0107349
f0100c4e:	e8 ed f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100c53:	68 98 73 10 f0       	push   $0xf0107398
f0100c58:	68 6f 73 10 f0       	push   $0xf010736f
f0100c5d:	68 e0 02 00 00       	push   $0x2e0
f0100c62:	68 49 73 10 f0       	push   $0xf0107349
f0100c67:	e8 d4 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100c6c:	68 a9 73 10 f0       	push   $0xf01073a9
f0100c71:	68 6f 73 10 f0       	push   $0xf010736f
f0100c76:	68 e1 02 00 00       	push   $0x2e1
f0100c7b:	68 49 73 10 f0       	push   $0xf0107349
f0100c80:	e8 bb f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100c85:	68 1c 6a 10 f0       	push   $0xf0106a1c
f0100c8a:	68 6f 73 10 f0       	push   $0xf010736f
f0100c8f:	68 e2 02 00 00       	push   $0x2e2
f0100c94:	68 49 73 10 f0       	push   $0xf0107349
f0100c99:	e8 a2 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100c9e:	68 c2 73 10 f0       	push   $0xf01073c2
f0100ca3:	68 6f 73 10 f0       	push   $0xf010736f
f0100ca8:	68 e3 02 00 00       	push   $0x2e3
f0100cad:	68 49 73 10 f0       	push   $0xf0107349
f0100cb2:	e8 89 f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100cb7:	89 c7                	mov    %eax,%edi
f0100cb9:	c1 ef 0c             	shr    $0xc,%edi
f0100cbc:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0100cbf:	76 1b                	jbe    f0100cdc <check_page_free_list+0x19c>
	return (void *)(pa + KERNBASE);
f0100cc1:	8d b8 00 00 00 f0    	lea    -0x10000000(%eax),%edi
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100cc7:	39 7d c8             	cmp    %edi,-0x38(%ebp)
f0100cca:	77 22                	ja     f0100cee <check_page_free_list+0x1ae>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100ccc:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100cd1:	0f 84 98 00 00 00    	je     f0100d6f <check_page_free_list+0x22f>
			++nfree_extmem;
f0100cd7:	83 c3 01             	add    $0x1,%ebx
f0100cda:	eb 2e                	jmp    f0100d0a <check_page_free_list+0x1ca>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100cdc:	50                   	push   %eax
f0100cdd:	68 64 64 10 f0       	push   $0xf0106464
f0100ce2:	6a 58                	push   $0x58
f0100ce4:	68 55 73 10 f0       	push   $0xf0107355
f0100ce9:	e8 52 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100cee:	68 40 6a 10 f0       	push   $0xf0106a40
f0100cf3:	68 6f 73 10 f0       	push   $0xf010736f
f0100cf8:	68 e4 02 00 00       	push   $0x2e4
f0100cfd:	68 49 73 10 f0       	push   $0xf0107349
f0100d02:	e8 39 f3 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100d07:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d0a:	8b 12                	mov    (%edx),%edx
f0100d0c:	85 d2                	test   %edx,%edx
f0100d0e:	74 78                	je     f0100d88 <check_page_free_list+0x248>
		assert(pp >= pages);
f0100d10:	39 d1                	cmp    %edx,%ecx
f0100d12:	0f 87 f0 fe ff ff    	ja     f0100c08 <check_page_free_list+0xc8>
		assert(pp < pages + npages);
f0100d18:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
f0100d1b:	0f 86 00 ff ff ff    	jbe    f0100c21 <check_page_free_list+0xe1>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d21:	89 d0                	mov    %edx,%eax
f0100d23:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0100d26:	a8 07                	test   $0x7,%al
f0100d28:	0f 85 0c ff ff ff    	jne    f0100c3a <check_page_free_list+0xfa>
	return (pp - pages) << PGSHIFT;
f0100d2e:	c1 f8 03             	sar    $0x3,%eax
f0100d31:	c1 e0 0c             	shl    $0xc,%eax
		assert(page2pa(pp) != 0);
f0100d34:	85 c0                	test   %eax,%eax
f0100d36:	0f 84 17 ff ff ff    	je     f0100c53 <check_page_free_list+0x113>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d3c:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100d41:	0f 84 25 ff ff ff    	je     f0100c6c <check_page_free_list+0x12c>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d47:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100d4c:	0f 84 33 ff ff ff    	je     f0100c85 <check_page_free_list+0x145>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d52:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100d57:	0f 84 41 ff ff ff    	je     f0100c9e <check_page_free_list+0x15e>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d5d:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100d62:	0f 87 4f ff ff ff    	ja     f0100cb7 <check_page_free_list+0x177>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100d68:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100d6d:	75 98                	jne    f0100d07 <check_page_free_list+0x1c7>
f0100d6f:	68 dc 73 10 f0       	push   $0xf01073dc
f0100d74:	68 6f 73 10 f0       	push   $0xf010736f
f0100d79:	68 e6 02 00 00       	push   $0x2e6
f0100d7e:	68 49 73 10 f0       	push   $0xf0107349
f0100d83:	e8 b8 f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_basemem > 0);
f0100d88:	85 f6                	test   %esi,%esi
f0100d8a:	7e 19                	jle    f0100da5 <check_page_free_list+0x265>
	assert(nfree_extmem > 0);
f0100d8c:	85 db                	test   %ebx,%ebx
f0100d8e:	7e 2e                	jle    f0100dbe <check_page_free_list+0x27e>
	cprintf("check_page_free_list() succeeded!\n");
f0100d90:	83 ec 0c             	sub    $0xc,%esp
f0100d93:	68 88 6a 10 f0       	push   $0xf0106a88
f0100d98:	e8 f6 2a 00 00       	call   f0103893 <cprintf>
}
f0100d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100da0:	5b                   	pop    %ebx
f0100da1:	5e                   	pop    %esi
f0100da2:	5f                   	pop    %edi
f0100da3:	5d                   	pop    %ebp
f0100da4:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100da5:	68 f9 73 10 f0       	push   $0xf01073f9
f0100daa:	68 6f 73 10 f0       	push   $0xf010736f
f0100daf:	68 ee 02 00 00       	push   $0x2ee
f0100db4:	68 49 73 10 f0       	push   $0xf0107349
f0100db9:	e8 82 f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100dbe:	68 0b 74 10 f0       	push   $0xf010740b
f0100dc3:	68 6f 73 10 f0       	push   $0xf010736f
f0100dc8:	68 ef 02 00 00       	push   $0x2ef
f0100dcd:	68 49 73 10 f0       	push   $0xf0107349
f0100dd2:	e8 69 f2 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100dd7:	a1 40 92 1e f0       	mov    0xf01e9240,%eax
f0100ddc:	85 c0                	test   %eax,%eax
f0100dde:	0f 84 80 fd ff ff    	je     f0100b64 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100de4:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100de7:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100dea:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100ded:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100df0:	89 c2                	mov    %eax,%edx
f0100df2:	2b 15 90 9e 1e f0    	sub    0xf01e9e90,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100df8:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100dfe:	0f 95 c2             	setne  %dl
f0100e01:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100e04:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100e08:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100e0a:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e0e:	8b 00                	mov    (%eax),%eax
f0100e10:	85 c0                	test   %eax,%eax
f0100e12:	75 dc                	jne    f0100df0 <check_page_free_list+0x2b0>
		*tp[1] = 0;
f0100e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100e1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e23:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100e25:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e28:	a3 40 92 1e f0       	mov    %eax,0xf01e9240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100e2d:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100e32:	8b 1d 40 92 1e f0    	mov    0xf01e9240,%ebx
f0100e38:	e9 52 fd ff ff       	jmp    f0100b8f <check_page_free_list+0x4f>

f0100e3d <page_init>:
{
f0100e3d:	55                   	push   %ebp
f0100e3e:	89 e5                	mov    %esp,%ebp
f0100e40:	57                   	push   %edi
f0100e41:	56                   	push   %esi
f0100e42:	53                   	push   %ebx
f0100e43:	83 ec 0c             	sub    $0xc,%esp
	size_t kernel_end_page = PADDR(boot_alloc(0)) / PGSIZE;		//这里调了半天，boot_alloc返回的是虚拟地址，需要转为物理地址
f0100e46:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e4b:	e8 27 fc ff ff       	call   f0100a77 <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100e50:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e55:	76 1f                	jbe    f0100e76 <page_init+0x39>
	return (physaddr_t)kva - KERNBASE;
f0100e57:	05 00 00 00 10       	add    $0x10000000,%eax
f0100e5c:	c1 e8 0c             	shr    $0xc,%eax
f0100e5f:	8b 35 40 92 1e f0    	mov    0xf01e9240,%esi
	for (i = 0; i < npages; i++) {
f0100e65:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100e6a:	ba 00 00 00 00       	mov    $0x0,%edx
			page_free_list = &pages[i];
f0100e6f:	bf 01 00 00 00       	mov    $0x1,%edi
	for (i = 0; i < npages; i++) {
f0100e74:	eb 39                	jmp    f0100eaf <page_init+0x72>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100e76:	50                   	push   %eax
f0100e77:	68 88 64 10 f0       	push   $0xf0106488
f0100e7c:	68 47 01 00 00       	push   $0x147
f0100e81:	68 49 73 10 f0       	push   $0xf0107349
f0100e86:	e8 b5 f1 ff ff       	call   f0100040 <_panic>
		} else if (i >= io_hole_start_page && i < kernel_end_page) {
f0100e8b:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
f0100e91:	76 3c                	jbe    f0100ecf <page_init+0x92>
f0100e93:	39 c2                	cmp    %eax,%edx
f0100e95:	73 38                	jae    f0100ecf <page_init+0x92>
			pages[i].pp_ref = 1;
f0100e97:	8b 0d 90 9e 1e f0    	mov    0xf01e9e90,%ecx
f0100e9d:	8d 0c d1             	lea    (%ecx,%edx,8),%ecx
f0100ea0:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
			pages[i].pp_link = NULL;
f0100ea6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	for (i = 0; i < npages; i++) {
f0100eac:	83 c2 01             	add    $0x1,%edx
f0100eaf:	39 15 88 9e 1e f0    	cmp    %edx,0xf01e9e88
f0100eb5:	76 55                	jbe    f0100f0c <page_init+0xcf>
		if (i == 0) {
f0100eb7:	85 d2                	test   %edx,%edx
f0100eb9:	75 d0                	jne    f0100e8b <page_init+0x4e>
			pages[i].pp_ref = 1;
f0100ebb:	8b 0d 90 9e 1e f0    	mov    0xf01e9e90,%ecx
f0100ec1:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
			pages[i].pp_link = NULL;
f0100ec7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0100ecd:	eb dd                	jmp    f0100eac <page_init+0x6f>
		} else if (i == MPENTRY_PADDR / PGSIZE) {
f0100ecf:	83 fa 07             	cmp    $0x7,%edx
f0100ed2:	74 23                	je     f0100ef7 <page_init+0xba>
f0100ed4:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
			pages[i].pp_ref = 0;
f0100edb:	89 cb                	mov    %ecx,%ebx
f0100edd:	03 1d 90 9e 1e f0    	add    0xf01e9e90,%ebx
f0100ee3:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
			pages[i].pp_link = page_free_list;
f0100ee9:	89 33                	mov    %esi,(%ebx)
			page_free_list = &pages[i];
f0100eeb:	89 ce                	mov    %ecx,%esi
f0100eed:	03 35 90 9e 1e f0    	add    0xf01e9e90,%esi
f0100ef3:	89 fb                	mov    %edi,%ebx
f0100ef5:	eb b5                	jmp    f0100eac <page_init+0x6f>
			pages[i].pp_ref = 1;
f0100ef7:	8b 0d 90 9e 1e f0    	mov    0xf01e9e90,%ecx
f0100efd:	66 c7 41 3c 01 00    	movw   $0x1,0x3c(%ecx)
			pages[i].pp_link = NULL;
f0100f03:	c7 41 38 00 00 00 00 	movl   $0x0,0x38(%ecx)
f0100f0a:	eb a0                	jmp    f0100eac <page_init+0x6f>
f0100f0c:	84 db                	test   %bl,%bl
f0100f0e:	75 08                	jne    f0100f18 <page_init+0xdb>
}
f0100f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f13:	5b                   	pop    %ebx
f0100f14:	5e                   	pop    %esi
f0100f15:	5f                   	pop    %edi
f0100f16:	5d                   	pop    %ebp
f0100f17:	c3                   	ret    
f0100f18:	89 35 40 92 1e f0    	mov    %esi,0xf01e9240
f0100f1e:	eb f0                	jmp    f0100f10 <page_init+0xd3>

f0100f20 <page_alloc>:
{
f0100f20:	55                   	push   %ebp
f0100f21:	89 e5                	mov    %esp,%ebp
f0100f23:	53                   	push   %ebx
f0100f24:	83 ec 04             	sub    $0x4,%esp
	struct PageInfo *ret = page_free_list;
f0100f27:	8b 1d 40 92 1e f0    	mov    0xf01e9240,%ebx
	if (ret == NULL) {
f0100f2d:	85 db                	test   %ebx,%ebx
f0100f2f:	74 13                	je     f0100f44 <page_alloc+0x24>
	page_free_list = ret->pp_link;
f0100f31:	8b 03                	mov    (%ebx),%eax
f0100f33:	a3 40 92 1e f0       	mov    %eax,0xf01e9240
	ret->pp_link = NULL;
f0100f38:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if (alloc_flags & ALLOC_ZERO) {
f0100f3e:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0100f42:	75 07                	jne    f0100f4b <page_alloc+0x2b>
}
f0100f44:	89 d8                	mov    %ebx,%eax
f0100f46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100f49:	c9                   	leave  
f0100f4a:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0100f4b:	89 d8                	mov    %ebx,%eax
f0100f4d:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0100f53:	c1 f8 03             	sar    $0x3,%eax
f0100f56:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0100f59:	89 c2                	mov    %eax,%edx
f0100f5b:	c1 ea 0c             	shr    $0xc,%edx
f0100f5e:	3b 15 88 9e 1e f0    	cmp    0xf01e9e88,%edx
f0100f64:	73 1a                	jae    f0100f80 <page_alloc+0x60>
		memset(page2kva(ret), 0, PGSIZE);
f0100f66:	83 ec 04             	sub    $0x4,%esp
f0100f69:	68 00 10 00 00       	push   $0x1000
f0100f6e:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0100f70:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100f75:	50                   	push   %eax
f0100f76:	e8 57 48 00 00       	call   f01057d2 <memset>
f0100f7b:	83 c4 10             	add    $0x10,%esp
f0100f7e:	eb c4                	jmp    f0100f44 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f80:	50                   	push   %eax
f0100f81:	68 64 64 10 f0       	push   $0xf0106464
f0100f86:	6a 58                	push   $0x58
f0100f88:	68 55 73 10 f0       	push   $0xf0107355
f0100f8d:	e8 ae f0 ff ff       	call   f0100040 <_panic>

f0100f92 <page_free>:
{
f0100f92:	55                   	push   %ebp
f0100f93:	89 e5                	mov    %esp,%ebp
f0100f95:	83 ec 08             	sub    $0x8,%esp
f0100f98:	8b 45 08             	mov    0x8(%ebp),%eax
	if (pp->pp_ref != 0 || pp->pp_link != NULL) {
f0100f9b:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0100fa0:	75 14                	jne    f0100fb6 <page_free+0x24>
f0100fa2:	83 38 00             	cmpl   $0x0,(%eax)
f0100fa5:	75 0f                	jne    f0100fb6 <page_free+0x24>
	pp->pp_link = page_free_list;
f0100fa7:	8b 15 40 92 1e f0    	mov    0xf01e9240,%edx
f0100fad:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0100faf:	a3 40 92 1e f0       	mov    %eax,0xf01e9240
}
f0100fb4:	c9                   	leave  
f0100fb5:	c3                   	ret    
		panic("page_free: pp->pp_ref is nonzero or pp->pp_link is not NULL\n");
f0100fb6:	83 ec 04             	sub    $0x4,%esp
f0100fb9:	68 ac 6a 10 f0       	push   $0xf0106aac
f0100fbe:	68 80 01 00 00       	push   $0x180
f0100fc3:	68 49 73 10 f0       	push   $0xf0107349
f0100fc8:	e8 73 f0 ff ff       	call   f0100040 <_panic>

f0100fcd <page_decref>:
{
f0100fcd:	55                   	push   %ebp
f0100fce:	89 e5                	mov    %esp,%ebp
f0100fd0:	83 ec 08             	sub    $0x8,%esp
f0100fd3:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0100fd6:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f0100fda:	83 e8 01             	sub    $0x1,%eax
f0100fdd:	66 89 42 04          	mov    %ax,0x4(%edx)
f0100fe1:	66 85 c0             	test   %ax,%ax
f0100fe4:	74 02                	je     f0100fe8 <page_decref+0x1b>
}
f0100fe6:	c9                   	leave  
f0100fe7:	c3                   	ret    
		page_free(pp);
f0100fe8:	83 ec 0c             	sub    $0xc,%esp
f0100feb:	52                   	push   %edx
f0100fec:	e8 a1 ff ff ff       	call   f0100f92 <page_free>
f0100ff1:	83 c4 10             	add    $0x10,%esp
}
f0100ff4:	eb f0                	jmp    f0100fe6 <page_decref+0x19>

f0100ff6 <pgdir_walk>:
{
f0100ff6:	55                   	push   %ebp
f0100ff7:	89 e5                	mov    %esp,%ebp
f0100ff9:	56                   	push   %esi
f0100ffa:	53                   	push   %ebx
f0100ffb:	8b 75 0c             	mov    0xc(%ebp),%esi
	pde_t* pde_ptr = pgdir + PDX(va);
f0100ffe:	89 f3                	mov    %esi,%ebx
f0101000:	c1 eb 16             	shr    $0x16,%ebx
f0101003:	c1 e3 02             	shl    $0x2,%ebx
f0101006:	03 5d 08             	add    0x8(%ebp),%ebx
	if (!(*pde_ptr & PTE_P)) {								//页表还没有分配
f0101009:	f6 03 01             	testb  $0x1,(%ebx)
f010100c:	75 2d                	jne    f010103b <pgdir_walk+0x45>
		if (create) {
f010100e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101012:	74 67                	je     f010107b <pgdir_walk+0x85>
			struct PageInfo *pp = page_alloc(1);
f0101014:	83 ec 0c             	sub    $0xc,%esp
f0101017:	6a 01                	push   $0x1
f0101019:	e8 02 ff ff ff       	call   f0100f20 <page_alloc>
			if (pp == NULL) {
f010101e:	83 c4 10             	add    $0x10,%esp
f0101021:	85 c0                	test   %eax,%eax
f0101023:	74 5d                	je     f0101082 <pgdir_walk+0x8c>
			pp->pp_ref++;
f0101025:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010102a:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0101030:	c1 f8 03             	sar    $0x3,%eax
f0101033:	c1 e0 0c             	shl    $0xc,%eax
			*pde_ptr = (page2pa(pp)) | PTE_P | PTE_U | PTE_W;	//更新页目录
f0101036:	83 c8 07             	or     $0x7,%eax
f0101039:	89 03                	mov    %eax,(%ebx)
	return (pte_t *)KADDR(PTE_ADDR(*pde_ptr)) + PTX(va);		//这里记得转为pte_t*类型，因为KADDR返回的的是void*类型。调了一个多小时才发现
f010103b:	8b 03                	mov    (%ebx),%eax
f010103d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101042:	89 c2                	mov    %eax,%edx
f0101044:	c1 ea 0c             	shr    $0xc,%edx
f0101047:	3b 15 88 9e 1e f0    	cmp    0xf01e9e88,%edx
f010104d:	73 17                	jae    f0101066 <pgdir_walk+0x70>
f010104f:	c1 ee 0a             	shr    $0xa,%esi
f0101052:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101058:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
}
f010105f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101062:	5b                   	pop    %ebx
f0101063:	5e                   	pop    %esi
f0101064:	5d                   	pop    %ebp
f0101065:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101066:	50                   	push   %eax
f0101067:	68 64 64 10 f0       	push   $0xf0106464
f010106c:	68 ba 01 00 00       	push   $0x1ba
f0101071:	68 49 73 10 f0       	push   $0xf0107349
f0101076:	e8 c5 ef ff ff       	call   f0100040 <_panic>
			return NULL;
f010107b:	b8 00 00 00 00       	mov    $0x0,%eax
f0101080:	eb dd                	jmp    f010105f <pgdir_walk+0x69>
				return NULL;
f0101082:	b8 00 00 00 00       	mov    $0x0,%eax
f0101087:	eb d6                	jmp    f010105f <pgdir_walk+0x69>

f0101089 <boot_map_region>:
{
f0101089:	55                   	push   %ebp
f010108a:	89 e5                	mov    %esp,%ebp
f010108c:	57                   	push   %edi
f010108d:	56                   	push   %esi
f010108e:	53                   	push   %ebx
f010108f:	83 ec 1c             	sub    $0x1c,%esp
f0101092:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101095:	8b 45 08             	mov    0x8(%ebp),%eax
	size_t pgs = size / PGSIZE;
f0101098:	89 cb                	mov    %ecx,%ebx
f010109a:	c1 eb 0c             	shr    $0xc,%ebx
	if (size % PGSIZE != 0) {
f010109d:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		pgs++;
f01010a3:	83 f9 01             	cmp    $0x1,%ecx
f01010a6:	83 db ff             	sbb    $0xffffffff,%ebx
f01010a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	for (int i = 0; i < pgs; i++) {
f01010ac:	89 c3                	mov    %eax,%ebx
f01010ae:	be 00 00 00 00       	mov    $0x0,%esi
		pte_t *pte = pgdir_walk(pgdir, (void *)va, 1);
f01010b3:	89 d7                	mov    %edx,%edi
f01010b5:	29 c7                	sub    %eax,%edi
		*pte = pa | PTE_P | perm;
f01010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01010ba:	83 c8 01             	or     $0x1,%eax
f01010bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	for (int i = 0; i < pgs; i++) {
f01010c0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
f01010c3:	74 41                	je     f0101106 <boot_map_region+0x7d>
		pte_t *pte = pgdir_walk(pgdir, (void *)va, 1);
f01010c5:	83 ec 04             	sub    $0x4,%esp
f01010c8:	6a 01                	push   $0x1
f01010ca:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
f01010cd:	50                   	push   %eax
f01010ce:	ff 75 e0             	pushl  -0x20(%ebp)
f01010d1:	e8 20 ff ff ff       	call   f0100ff6 <pgdir_walk>
		if (pte == NULL) {
f01010d6:	83 c4 10             	add    $0x10,%esp
f01010d9:	85 c0                	test   %eax,%eax
f01010db:	74 12                	je     f01010ef <boot_map_region+0x66>
		*pte = pa | PTE_P | perm;
f01010dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01010e0:	09 da                	or     %ebx,%edx
f01010e2:	89 10                	mov    %edx,(%eax)
		pa += PGSIZE;
f01010e4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (int i = 0; i < pgs; i++) {
f01010ea:	83 c6 01             	add    $0x1,%esi
f01010ed:	eb d1                	jmp    f01010c0 <boot_map_region+0x37>
			panic("boot_map_region(): out of memory\n");
f01010ef:	83 ec 04             	sub    $0x4,%esp
f01010f2:	68 ec 6a 10 f0       	push   $0xf0106aec
f01010f7:	68 d3 01 00 00       	push   $0x1d3
f01010fc:	68 49 73 10 f0       	push   $0xf0107349
f0101101:	e8 3a ef ff ff       	call   f0100040 <_panic>
}
f0101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101109:	5b                   	pop    %ebx
f010110a:	5e                   	pop    %esi
f010110b:	5f                   	pop    %edi
f010110c:	5d                   	pop    %ebp
f010110d:	c3                   	ret    

f010110e <page_lookup>:
{
f010110e:	55                   	push   %ebp
f010110f:	89 e5                	mov    %esp,%ebp
f0101111:	53                   	push   %ebx
f0101112:	83 ec 08             	sub    $0x8,%esp
f0101115:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *pte =  pgdir_walk(pgdir, va, 0);			//如果对应的页表不存在，不进行创建
f0101118:	6a 00                	push   $0x0
f010111a:	ff 75 0c             	pushl  0xc(%ebp)
f010111d:	ff 75 08             	pushl  0x8(%ebp)
f0101120:	e8 d1 fe ff ff       	call   f0100ff6 <pgdir_walk>
	if (pte == NULL) {
f0101125:	83 c4 10             	add    $0x10,%esp
f0101128:	85 c0                	test   %eax,%eax
f010112a:	74 3a                	je     f0101166 <page_lookup+0x58>
f010112c:	89 c1                	mov    %eax,%ecx
	if (!(*pte) & PTE_P) {
f010112e:	8b 10                	mov    (%eax),%edx
f0101130:	85 d2                	test   %edx,%edx
f0101132:	74 39                	je     f010116d <page_lookup+0x5f>
f0101134:	c1 ea 0c             	shr    $0xc,%edx
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101137:	39 15 88 9e 1e f0    	cmp    %edx,0xf01e9e88
f010113d:	76 13                	jbe    f0101152 <page_lookup+0x44>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f010113f:	a1 90 9e 1e f0       	mov    0xf01e9e90,%eax
f0101144:	8d 04 d0             	lea    (%eax,%edx,8),%eax
	if (pte_store != NULL) {
f0101147:	85 db                	test   %ebx,%ebx
f0101149:	74 02                	je     f010114d <page_lookup+0x3f>
		*pte_store = pte;
f010114b:	89 0b                	mov    %ecx,(%ebx)
}
f010114d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101150:	c9                   	leave  
f0101151:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101152:	83 ec 04             	sub    $0x4,%esp
f0101155:	68 10 6b 10 f0       	push   $0xf0106b10
f010115a:	6a 51                	push   $0x51
f010115c:	68 55 73 10 f0       	push   $0xf0107355
f0101161:	e8 da ee ff ff       	call   f0100040 <_panic>
		return NULL;
f0101166:	b8 00 00 00 00       	mov    $0x0,%eax
f010116b:	eb e0                	jmp    f010114d <page_lookup+0x3f>
		return NULL;
f010116d:	b8 00 00 00 00       	mov    $0x0,%eax
f0101172:	eb d9                	jmp    f010114d <page_lookup+0x3f>

f0101174 <tlb_invalidate>:
{
f0101174:	55                   	push   %ebp
f0101175:	89 e5                	mov    %esp,%ebp
f0101177:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f010117a:	e8 78 4c 00 00       	call   f0105df7 <cpunum>
f010117f:	6b c0 74             	imul   $0x74,%eax,%eax
f0101182:	83 b8 28 a0 1e f0 00 	cmpl   $0x0,-0xfe15fd8(%eax)
f0101189:	74 16                	je     f01011a1 <tlb_invalidate+0x2d>
f010118b:	e8 67 4c 00 00       	call   f0105df7 <cpunum>
f0101190:	6b c0 74             	imul   $0x74,%eax,%eax
f0101193:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0101199:	8b 55 08             	mov    0x8(%ebp),%edx
f010119c:	39 50 60             	cmp    %edx,0x60(%eax)
f010119f:	75 06                	jne    f01011a7 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01011a4:	0f 01 38             	invlpg (%eax)
}
f01011a7:	c9                   	leave  
f01011a8:	c3                   	ret    

f01011a9 <page_remove>:
{
f01011a9:	55                   	push   %ebp
f01011aa:	89 e5                	mov    %esp,%ebp
f01011ac:	56                   	push   %esi
f01011ad:	53                   	push   %ebx
f01011ae:	83 ec 14             	sub    $0x14,%esp
f01011b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01011b4:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *pp = page_lookup(pgdir, va, &pte_store);
f01011b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01011ba:	50                   	push   %eax
f01011bb:	56                   	push   %esi
f01011bc:	53                   	push   %ebx
f01011bd:	e8 4c ff ff ff       	call   f010110e <page_lookup>
	if (pp == NULL) {
f01011c2:	83 c4 10             	add    $0x10,%esp
f01011c5:	85 c0                	test   %eax,%eax
f01011c7:	75 07                	jne    f01011d0 <page_remove+0x27>
}
f01011c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01011cc:	5b                   	pop    %ebx
f01011cd:	5e                   	pop    %esi
f01011ce:	5d                   	pop    %ebp
f01011cf:	c3                   	ret    
	page_decref(pp);
f01011d0:	83 ec 0c             	sub    $0xc,%esp
f01011d3:	50                   	push   %eax
f01011d4:	e8 f4 fd ff ff       	call   f0100fcd <page_decref>
	*pte_store = 0;
f01011d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01011dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, va);
f01011e2:	83 c4 08             	add    $0x8,%esp
f01011e5:	56                   	push   %esi
f01011e6:	53                   	push   %ebx
f01011e7:	e8 88 ff ff ff       	call   f0101174 <tlb_invalidate>
f01011ec:	83 c4 10             	add    $0x10,%esp
f01011ef:	eb d8                	jmp    f01011c9 <page_remove+0x20>

f01011f1 <page_insert>:
{
f01011f1:	55                   	push   %ebp
f01011f2:	89 e5                	mov    %esp,%ebp
f01011f4:	57                   	push   %edi
f01011f5:	56                   	push   %esi
f01011f6:	53                   	push   %ebx
f01011f7:	83 ec 10             	sub    $0x10,%esp
f01011fa:	8b 75 08             	mov    0x8(%ebp),%esi
f01011fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *pte = pgdir_walk(pgdir, va, 1);
f0101200:	6a 01                	push   $0x1
f0101202:	ff 75 10             	pushl  0x10(%ebp)
f0101205:	56                   	push   %esi
f0101206:	e8 eb fd ff ff       	call   f0100ff6 <pgdir_walk>
	if (pte == NULL) {
f010120b:	83 c4 10             	add    $0x10,%esp
f010120e:	85 c0                	test   %eax,%eax
f0101210:	74 4c                	je     f010125e <page_insert+0x6d>
f0101212:	89 c7                	mov    %eax,%edi
	pp->pp_ref++;										//引用加1
f0101214:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	if ((*pte) & PTE_P) {								//当前虚拟地址va已经被映射过，需要先释放
f0101219:	f6 00 01             	testb  $0x1,(%eax)
f010121c:	75 2f                	jne    f010124d <page_insert+0x5c>
	return (pp - pages) << PGSHIFT;
f010121e:	2b 1d 90 9e 1e f0    	sub    0xf01e9e90,%ebx
f0101224:	c1 fb 03             	sar    $0x3,%ebx
f0101227:	c1 e3 0c             	shl    $0xc,%ebx
	*pte = pa | perm | PTE_P;
f010122a:	8b 45 14             	mov    0x14(%ebp),%eax
f010122d:	83 c8 01             	or     $0x1,%eax
f0101230:	09 c3                	or     %eax,%ebx
f0101232:	89 1f                	mov    %ebx,(%edi)
	pgdir[PDX(va)] |= perm;
f0101234:	8b 45 10             	mov    0x10(%ebp),%eax
f0101237:	c1 e8 16             	shr    $0x16,%eax
f010123a:	8b 55 14             	mov    0x14(%ebp),%edx
f010123d:	09 14 86             	or     %edx,(%esi,%eax,4)
	return 0;
f0101240:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101245:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101248:	5b                   	pop    %ebx
f0101249:	5e                   	pop    %esi
f010124a:	5f                   	pop    %edi
f010124b:	5d                   	pop    %ebp
f010124c:	c3                   	ret    
		page_remove(pgdir, va);
f010124d:	83 ec 08             	sub    $0x8,%esp
f0101250:	ff 75 10             	pushl  0x10(%ebp)
f0101253:	56                   	push   %esi
f0101254:	e8 50 ff ff ff       	call   f01011a9 <page_remove>
f0101259:	83 c4 10             	add    $0x10,%esp
f010125c:	eb c0                	jmp    f010121e <page_insert+0x2d>
		return -E_NO_MEM;
f010125e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101263:	eb e0                	jmp    f0101245 <page_insert+0x54>

f0101265 <mmio_map_region>:
{
f0101265:	55                   	push   %ebp
f0101266:	89 e5                	mov    %esp,%ebp
f0101268:	53                   	push   %ebx
f0101269:	83 ec 04             	sub    $0x4,%esp
f010126c:	8b 45 08             	mov    0x8(%ebp),%eax
	size = ROUNDUP(pa+size, PGSIZE);
f010126f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101272:	8d 9c 10 ff 0f 00 00 	lea    0xfff(%eax,%edx,1),%ebx
f0101279:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	pa = ROUNDDOWN(pa, PGSIZE);
f010127f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	size -= pa;
f0101284:	29 c3                	sub    %eax,%ebx
	if (base+size >= MMIOLIM) panic("not enough memory");
f0101286:	8b 15 00 23 12 f0    	mov    0xf0122300,%edx
f010128c:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
f010128f:	81 f9 ff ff bf ef    	cmp    $0xefbfffff,%ecx
f0101295:	77 24                	ja     f01012bb <mmio_map_region+0x56>
	boot_map_region(kern_pgdir, base, size, pa, PTE_PCD|PTE_PWT|PTE_W);
f0101297:	83 ec 08             	sub    $0x8,%esp
f010129a:	6a 1a                	push   $0x1a
f010129c:	50                   	push   %eax
f010129d:	89 d9                	mov    %ebx,%ecx
f010129f:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f01012a4:	e8 e0 fd ff ff       	call   f0101089 <boot_map_region>
	base += size;
f01012a9:	a1 00 23 12 f0       	mov    0xf0122300,%eax
f01012ae:	01 c3                	add    %eax,%ebx
f01012b0:	89 1d 00 23 12 f0    	mov    %ebx,0xf0122300
}
f01012b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012b9:	c9                   	leave  
f01012ba:	c3                   	ret    
	if (base+size >= MMIOLIM) panic("not enough memory");
f01012bb:	83 ec 04             	sub    $0x4,%esp
f01012be:	68 1c 74 10 f0       	push   $0xf010741c
f01012c3:	68 72 02 00 00       	push   $0x272
f01012c8:	68 49 73 10 f0       	push   $0xf0107349
f01012cd:	e8 6e ed ff ff       	call   f0100040 <_panic>

f01012d2 <mem_init>:
{
f01012d2:	55                   	push   %ebp
f01012d3:	89 e5                	mov    %esp,%ebp
f01012d5:	57                   	push   %edi
f01012d6:	56                   	push   %esi
f01012d7:	53                   	push   %ebx
f01012d8:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f01012db:	b8 15 00 00 00       	mov    $0x15,%eax
f01012e0:	e8 ce f7 ff ff       	call   f0100ab3 <nvram_read>
f01012e5:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f01012e7:	b8 17 00 00 00       	mov    $0x17,%eax
f01012ec:	e8 c2 f7 ff ff       	call   f0100ab3 <nvram_read>
f01012f1:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f01012f3:	b8 34 00 00 00       	mov    $0x34,%eax
f01012f8:	e8 b6 f7 ff ff       	call   f0100ab3 <nvram_read>
f01012fd:	c1 e0 06             	shl    $0x6,%eax
	if (ext16mem)
f0101300:	85 c0                	test   %eax,%eax
f0101302:	0f 85 d9 00 00 00    	jne    f01013e1 <mem_init+0x10f>
		totalmem = 1 * 1024 + extmem;
f0101308:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f010130e:	85 f6                	test   %esi,%esi
f0101310:	0f 44 c3             	cmove  %ebx,%eax
	npages = totalmem / (PGSIZE / 1024);
f0101313:	89 c2                	mov    %eax,%edx
f0101315:	c1 ea 02             	shr    $0x2,%edx
f0101318:	89 15 88 9e 1e f0    	mov    %edx,0xf01e9e88
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010131e:	89 c2                	mov    %eax,%edx
f0101320:	29 da                	sub    %ebx,%edx
f0101322:	52                   	push   %edx
f0101323:	53                   	push   %ebx
f0101324:	50                   	push   %eax
f0101325:	68 30 6b 10 f0       	push   $0xf0106b30
f010132a:	e8 64 25 00 00       	call   f0103893 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);					//分配一个页的空间保存页目录表
f010132f:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101334:	e8 3e f7 ff ff       	call   f0100a77 <boot_alloc>
f0101339:	a3 8c 9e 1e f0       	mov    %eax,0xf01e9e8c
	memset(kern_pgdir, 0, PGSIZE);
f010133e:	83 c4 0c             	add    $0xc,%esp
f0101341:	68 00 10 00 00       	push   $0x1000
f0101346:	6a 00                	push   $0x0
f0101348:	50                   	push   %eax
f0101349:	e8 84 44 00 00       	call   f01057d2 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;	//页目录表的低PDX(UVPT)项指向页目录本身，
f010134e:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0101353:	83 c4 10             	add    $0x10,%esp
f0101356:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010135b:	0f 86 8a 00 00 00    	jbe    f01013eb <mem_init+0x119>
	return (physaddr_t)kva - KERNBASE;
f0101361:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101367:	83 ca 05             	or     $0x5,%edx
f010136a:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);	//分配足够大的空间(PGSIZE的倍数)保存pages数组
f0101370:	a1 88 9e 1e f0       	mov    0xf01e9e88,%eax
f0101375:	c1 e0 03             	shl    $0x3,%eax
f0101378:	e8 fa f6 ff ff       	call   f0100a77 <boot_alloc>
f010137d:	a3 90 9e 1e f0       	mov    %eax,0xf01e9e90
	memset(pages, 0, sizeof(struct PageInfo) * npages);
f0101382:	83 ec 04             	sub    $0x4,%esp
f0101385:	8b 0d 88 9e 1e f0    	mov    0xf01e9e88,%ecx
f010138b:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f0101392:	52                   	push   %edx
f0101393:	6a 00                	push   $0x0
f0101395:	50                   	push   %eax
f0101396:	e8 37 44 00 00       	call   f01057d2 <memset>
	envs = (struct Env*)boot_alloc(sizeof(struct Env) * NENV);
f010139b:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01013a0:	e8 d2 f6 ff ff       	call   f0100a77 <boot_alloc>
f01013a5:	a3 44 92 1e f0       	mov    %eax,0xf01e9244
	memset(envs, 0, sizeof(struct Env) * NENV);
f01013aa:	83 c4 0c             	add    $0xc,%esp
f01013ad:	68 00 f0 01 00       	push   $0x1f000
f01013b2:	6a 00                	push   $0x0
f01013b4:	50                   	push   %eax
f01013b5:	e8 18 44 00 00       	call   f01057d2 <memset>
	page_init();
f01013ba:	e8 7e fa ff ff       	call   f0100e3d <page_init>
	check_page_free_list(1);
f01013bf:	b8 01 00 00 00       	mov    $0x1,%eax
f01013c4:	e8 77 f7 ff ff       	call   f0100b40 <check_page_free_list>
	if (!pages)
f01013c9:	83 c4 10             	add    $0x10,%esp
f01013cc:	83 3d 90 9e 1e f0 00 	cmpl   $0x0,0xf01e9e90
f01013d3:	74 2b                	je     f0101400 <mem_init+0x12e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01013d5:	a1 40 92 1e f0       	mov    0xf01e9240,%eax
f01013da:	bb 00 00 00 00       	mov    $0x0,%ebx
f01013df:	eb 3b                	jmp    f010141c <mem_init+0x14a>
		totalmem = 16 * 1024 + ext16mem;
f01013e1:	05 00 40 00 00       	add    $0x4000,%eax
f01013e6:	e9 28 ff ff ff       	jmp    f0101313 <mem_init+0x41>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01013eb:	50                   	push   %eax
f01013ec:	68 88 64 10 f0       	push   $0xf0106488
f01013f1:	68 94 00 00 00       	push   $0x94
f01013f6:	68 49 73 10 f0       	push   $0xf0107349
f01013fb:	e8 40 ec ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f0101400:	83 ec 04             	sub    $0x4,%esp
f0101403:	68 2e 74 10 f0       	push   $0xf010742e
f0101408:	68 02 03 00 00       	push   $0x302
f010140d:	68 49 73 10 f0       	push   $0xf0107349
f0101412:	e8 29 ec ff ff       	call   f0100040 <_panic>
		++nfree;
f0101417:	83 c3 01             	add    $0x1,%ebx
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010141a:	8b 00                	mov    (%eax),%eax
f010141c:	85 c0                	test   %eax,%eax
f010141e:	75 f7                	jne    f0101417 <mem_init+0x145>
	assert((pp0 = page_alloc(0)));
f0101420:	83 ec 0c             	sub    $0xc,%esp
f0101423:	6a 00                	push   $0x0
f0101425:	e8 f6 fa ff ff       	call   f0100f20 <page_alloc>
f010142a:	89 c7                	mov    %eax,%edi
f010142c:	83 c4 10             	add    $0x10,%esp
f010142f:	85 c0                	test   %eax,%eax
f0101431:	0f 84 12 02 00 00    	je     f0101649 <mem_init+0x377>
	assert((pp1 = page_alloc(0)));
f0101437:	83 ec 0c             	sub    $0xc,%esp
f010143a:	6a 00                	push   $0x0
f010143c:	e8 df fa ff ff       	call   f0100f20 <page_alloc>
f0101441:	89 c6                	mov    %eax,%esi
f0101443:	83 c4 10             	add    $0x10,%esp
f0101446:	85 c0                	test   %eax,%eax
f0101448:	0f 84 14 02 00 00    	je     f0101662 <mem_init+0x390>
	assert((pp2 = page_alloc(0)));
f010144e:	83 ec 0c             	sub    $0xc,%esp
f0101451:	6a 00                	push   $0x0
f0101453:	e8 c8 fa ff ff       	call   f0100f20 <page_alloc>
f0101458:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010145b:	83 c4 10             	add    $0x10,%esp
f010145e:	85 c0                	test   %eax,%eax
f0101460:	0f 84 15 02 00 00    	je     f010167b <mem_init+0x3a9>
	assert(pp1 && pp1 != pp0);
f0101466:	39 f7                	cmp    %esi,%edi
f0101468:	0f 84 26 02 00 00    	je     f0101694 <mem_init+0x3c2>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010146e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101471:	39 c7                	cmp    %eax,%edi
f0101473:	0f 84 34 02 00 00    	je     f01016ad <mem_init+0x3db>
f0101479:	39 c6                	cmp    %eax,%esi
f010147b:	0f 84 2c 02 00 00    	je     f01016ad <mem_init+0x3db>
	return (pp - pages) << PGSHIFT;
f0101481:	8b 0d 90 9e 1e f0    	mov    0xf01e9e90,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101487:	8b 15 88 9e 1e f0    	mov    0xf01e9e88,%edx
f010148d:	c1 e2 0c             	shl    $0xc,%edx
f0101490:	89 f8                	mov    %edi,%eax
f0101492:	29 c8                	sub    %ecx,%eax
f0101494:	c1 f8 03             	sar    $0x3,%eax
f0101497:	c1 e0 0c             	shl    $0xc,%eax
f010149a:	39 d0                	cmp    %edx,%eax
f010149c:	0f 83 24 02 00 00    	jae    f01016c6 <mem_init+0x3f4>
f01014a2:	89 f0                	mov    %esi,%eax
f01014a4:	29 c8                	sub    %ecx,%eax
f01014a6:	c1 f8 03             	sar    $0x3,%eax
f01014a9:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f01014ac:	39 c2                	cmp    %eax,%edx
f01014ae:	0f 86 2b 02 00 00    	jbe    f01016df <mem_init+0x40d>
f01014b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01014b7:	29 c8                	sub    %ecx,%eax
f01014b9:	c1 f8 03             	sar    $0x3,%eax
f01014bc:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f01014bf:	39 c2                	cmp    %eax,%edx
f01014c1:	0f 86 31 02 00 00    	jbe    f01016f8 <mem_init+0x426>
	fl = page_free_list;
f01014c7:	a1 40 92 1e f0       	mov    0xf01e9240,%eax
f01014cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f01014cf:	c7 05 40 92 1e f0 00 	movl   $0x0,0xf01e9240
f01014d6:	00 00 00 
	assert(!page_alloc(0));
f01014d9:	83 ec 0c             	sub    $0xc,%esp
f01014dc:	6a 00                	push   $0x0
f01014de:	e8 3d fa ff ff       	call   f0100f20 <page_alloc>
f01014e3:	83 c4 10             	add    $0x10,%esp
f01014e6:	85 c0                	test   %eax,%eax
f01014e8:	0f 85 23 02 00 00    	jne    f0101711 <mem_init+0x43f>
	page_free(pp0);
f01014ee:	83 ec 0c             	sub    $0xc,%esp
f01014f1:	57                   	push   %edi
f01014f2:	e8 9b fa ff ff       	call   f0100f92 <page_free>
	page_free(pp1);
f01014f7:	89 34 24             	mov    %esi,(%esp)
f01014fa:	e8 93 fa ff ff       	call   f0100f92 <page_free>
	page_free(pp2);
f01014ff:	83 c4 04             	add    $0x4,%esp
f0101502:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101505:	e8 88 fa ff ff       	call   f0100f92 <page_free>
	assert((pp0 = page_alloc(0)));
f010150a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101511:	e8 0a fa ff ff       	call   f0100f20 <page_alloc>
f0101516:	89 c6                	mov    %eax,%esi
f0101518:	83 c4 10             	add    $0x10,%esp
f010151b:	85 c0                	test   %eax,%eax
f010151d:	0f 84 07 02 00 00    	je     f010172a <mem_init+0x458>
	assert((pp1 = page_alloc(0)));
f0101523:	83 ec 0c             	sub    $0xc,%esp
f0101526:	6a 00                	push   $0x0
f0101528:	e8 f3 f9 ff ff       	call   f0100f20 <page_alloc>
f010152d:	89 c7                	mov    %eax,%edi
f010152f:	83 c4 10             	add    $0x10,%esp
f0101532:	85 c0                	test   %eax,%eax
f0101534:	0f 84 09 02 00 00    	je     f0101743 <mem_init+0x471>
	assert((pp2 = page_alloc(0)));
f010153a:	83 ec 0c             	sub    $0xc,%esp
f010153d:	6a 00                	push   $0x0
f010153f:	e8 dc f9 ff ff       	call   f0100f20 <page_alloc>
f0101544:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101547:	83 c4 10             	add    $0x10,%esp
f010154a:	85 c0                	test   %eax,%eax
f010154c:	0f 84 0a 02 00 00    	je     f010175c <mem_init+0x48a>
	assert(pp1 && pp1 != pp0);
f0101552:	39 fe                	cmp    %edi,%esi
f0101554:	0f 84 1b 02 00 00    	je     f0101775 <mem_init+0x4a3>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010155a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010155d:	39 c7                	cmp    %eax,%edi
f010155f:	0f 84 29 02 00 00    	je     f010178e <mem_init+0x4bc>
f0101565:	39 c6                	cmp    %eax,%esi
f0101567:	0f 84 21 02 00 00    	je     f010178e <mem_init+0x4bc>
	assert(!page_alloc(0));
f010156d:	83 ec 0c             	sub    $0xc,%esp
f0101570:	6a 00                	push   $0x0
f0101572:	e8 a9 f9 ff ff       	call   f0100f20 <page_alloc>
f0101577:	83 c4 10             	add    $0x10,%esp
f010157a:	85 c0                	test   %eax,%eax
f010157c:	0f 85 25 02 00 00    	jne    f01017a7 <mem_init+0x4d5>
f0101582:	89 f0                	mov    %esi,%eax
f0101584:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f010158a:	c1 f8 03             	sar    $0x3,%eax
f010158d:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101590:	89 c2                	mov    %eax,%edx
f0101592:	c1 ea 0c             	shr    $0xc,%edx
f0101595:	3b 15 88 9e 1e f0    	cmp    0xf01e9e88,%edx
f010159b:	0f 83 1f 02 00 00    	jae    f01017c0 <mem_init+0x4ee>
	memset(page2kva(pp0), 1, PGSIZE);
f01015a1:	83 ec 04             	sub    $0x4,%esp
f01015a4:	68 00 10 00 00       	push   $0x1000
f01015a9:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01015ab:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01015b0:	50                   	push   %eax
f01015b1:	e8 1c 42 00 00       	call   f01057d2 <memset>
	page_free(pp0);
f01015b6:	89 34 24             	mov    %esi,(%esp)
f01015b9:	e8 d4 f9 ff ff       	call   f0100f92 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01015c5:	e8 56 f9 ff ff       	call   f0100f20 <page_alloc>
f01015ca:	83 c4 10             	add    $0x10,%esp
f01015cd:	85 c0                	test   %eax,%eax
f01015cf:	0f 84 fd 01 00 00    	je     f01017d2 <mem_init+0x500>
	assert(pp && pp0 == pp);
f01015d5:	39 c6                	cmp    %eax,%esi
f01015d7:	0f 85 0e 02 00 00    	jne    f01017eb <mem_init+0x519>
	return (pp - pages) << PGSHIFT;
f01015dd:	89 f2                	mov    %esi,%edx
f01015df:	2b 15 90 9e 1e f0    	sub    0xf01e9e90,%edx
f01015e5:	c1 fa 03             	sar    $0x3,%edx
f01015e8:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01015eb:	89 d0                	mov    %edx,%eax
f01015ed:	c1 e8 0c             	shr    $0xc,%eax
f01015f0:	3b 05 88 9e 1e f0    	cmp    0xf01e9e88,%eax
f01015f6:	0f 83 08 02 00 00    	jae    f0101804 <mem_init+0x532>
	return (void *)(pa + KERNBASE);
f01015fc:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101602:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f0101608:	80 38 00             	cmpb   $0x0,(%eax)
f010160b:	0f 85 05 02 00 00    	jne    f0101816 <mem_init+0x544>
f0101611:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f0101614:	39 d0                	cmp    %edx,%eax
f0101616:	75 f0                	jne    f0101608 <mem_init+0x336>
	page_free_list = fl;
f0101618:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010161b:	a3 40 92 1e f0       	mov    %eax,0xf01e9240
	page_free(pp0);
f0101620:	83 ec 0c             	sub    $0xc,%esp
f0101623:	56                   	push   %esi
f0101624:	e8 69 f9 ff ff       	call   f0100f92 <page_free>
	page_free(pp1);
f0101629:	89 3c 24             	mov    %edi,(%esp)
f010162c:	e8 61 f9 ff ff       	call   f0100f92 <page_free>
	page_free(pp2);
f0101631:	83 c4 04             	add    $0x4,%esp
f0101634:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101637:	e8 56 f9 ff ff       	call   f0100f92 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010163c:	a1 40 92 1e f0       	mov    0xf01e9240,%eax
f0101641:	83 c4 10             	add    $0x10,%esp
f0101644:	e9 eb 01 00 00       	jmp    f0101834 <mem_init+0x562>
	assert((pp0 = page_alloc(0)));
f0101649:	68 49 74 10 f0       	push   $0xf0107449
f010164e:	68 6f 73 10 f0       	push   $0xf010736f
f0101653:	68 0a 03 00 00       	push   $0x30a
f0101658:	68 49 73 10 f0       	push   $0xf0107349
f010165d:	e8 de e9 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101662:	68 5f 74 10 f0       	push   $0xf010745f
f0101667:	68 6f 73 10 f0       	push   $0xf010736f
f010166c:	68 0b 03 00 00       	push   $0x30b
f0101671:	68 49 73 10 f0       	push   $0xf0107349
f0101676:	e8 c5 e9 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f010167b:	68 75 74 10 f0       	push   $0xf0107475
f0101680:	68 6f 73 10 f0       	push   $0xf010736f
f0101685:	68 0c 03 00 00       	push   $0x30c
f010168a:	68 49 73 10 f0       	push   $0xf0107349
f010168f:	e8 ac e9 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101694:	68 8b 74 10 f0       	push   $0xf010748b
f0101699:	68 6f 73 10 f0       	push   $0xf010736f
f010169e:	68 0f 03 00 00       	push   $0x30f
f01016a3:	68 49 73 10 f0       	push   $0xf0107349
f01016a8:	e8 93 e9 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01016ad:	68 6c 6b 10 f0       	push   $0xf0106b6c
f01016b2:	68 6f 73 10 f0       	push   $0xf010736f
f01016b7:	68 10 03 00 00       	push   $0x310
f01016bc:	68 49 73 10 f0       	push   $0xf0107349
f01016c1:	e8 7a e9 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f01016c6:	68 9d 74 10 f0       	push   $0xf010749d
f01016cb:	68 6f 73 10 f0       	push   $0xf010736f
f01016d0:	68 11 03 00 00       	push   $0x311
f01016d5:	68 49 73 10 f0       	push   $0xf0107349
f01016da:	e8 61 e9 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f01016df:	68 ba 74 10 f0       	push   $0xf01074ba
f01016e4:	68 6f 73 10 f0       	push   $0xf010736f
f01016e9:	68 12 03 00 00       	push   $0x312
f01016ee:	68 49 73 10 f0       	push   $0xf0107349
f01016f3:	e8 48 e9 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f01016f8:	68 d7 74 10 f0       	push   $0xf01074d7
f01016fd:	68 6f 73 10 f0       	push   $0xf010736f
f0101702:	68 13 03 00 00       	push   $0x313
f0101707:	68 49 73 10 f0       	push   $0xf0107349
f010170c:	e8 2f e9 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101711:	68 f4 74 10 f0       	push   $0xf01074f4
f0101716:	68 6f 73 10 f0       	push   $0xf010736f
f010171b:	68 1a 03 00 00       	push   $0x31a
f0101720:	68 49 73 10 f0       	push   $0xf0107349
f0101725:	e8 16 e9 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f010172a:	68 49 74 10 f0       	push   $0xf0107449
f010172f:	68 6f 73 10 f0       	push   $0xf010736f
f0101734:	68 21 03 00 00       	push   $0x321
f0101739:	68 49 73 10 f0       	push   $0xf0107349
f010173e:	e8 fd e8 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101743:	68 5f 74 10 f0       	push   $0xf010745f
f0101748:	68 6f 73 10 f0       	push   $0xf010736f
f010174d:	68 22 03 00 00       	push   $0x322
f0101752:	68 49 73 10 f0       	push   $0xf0107349
f0101757:	e8 e4 e8 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f010175c:	68 75 74 10 f0       	push   $0xf0107475
f0101761:	68 6f 73 10 f0       	push   $0xf010736f
f0101766:	68 23 03 00 00       	push   $0x323
f010176b:	68 49 73 10 f0       	push   $0xf0107349
f0101770:	e8 cb e8 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101775:	68 8b 74 10 f0       	push   $0xf010748b
f010177a:	68 6f 73 10 f0       	push   $0xf010736f
f010177f:	68 25 03 00 00       	push   $0x325
f0101784:	68 49 73 10 f0       	push   $0xf0107349
f0101789:	e8 b2 e8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010178e:	68 6c 6b 10 f0       	push   $0xf0106b6c
f0101793:	68 6f 73 10 f0       	push   $0xf010736f
f0101798:	68 26 03 00 00       	push   $0x326
f010179d:	68 49 73 10 f0       	push   $0xf0107349
f01017a2:	e8 99 e8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01017a7:	68 f4 74 10 f0       	push   $0xf01074f4
f01017ac:	68 6f 73 10 f0       	push   $0xf010736f
f01017b1:	68 27 03 00 00       	push   $0x327
f01017b6:	68 49 73 10 f0       	push   $0xf0107349
f01017bb:	e8 80 e8 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01017c0:	50                   	push   %eax
f01017c1:	68 64 64 10 f0       	push   $0xf0106464
f01017c6:	6a 58                	push   $0x58
f01017c8:	68 55 73 10 f0       	push   $0xf0107355
f01017cd:	e8 6e e8 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01017d2:	68 03 75 10 f0       	push   $0xf0107503
f01017d7:	68 6f 73 10 f0       	push   $0xf010736f
f01017dc:	68 2c 03 00 00       	push   $0x32c
f01017e1:	68 49 73 10 f0       	push   $0xf0107349
f01017e6:	e8 55 e8 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f01017eb:	68 21 75 10 f0       	push   $0xf0107521
f01017f0:	68 6f 73 10 f0       	push   $0xf010736f
f01017f5:	68 2d 03 00 00       	push   $0x32d
f01017fa:	68 49 73 10 f0       	push   $0xf0107349
f01017ff:	e8 3c e8 ff ff       	call   f0100040 <_panic>
f0101804:	52                   	push   %edx
f0101805:	68 64 64 10 f0       	push   $0xf0106464
f010180a:	6a 58                	push   $0x58
f010180c:	68 55 73 10 f0       	push   $0xf0107355
f0101811:	e8 2a e8 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f0101816:	68 31 75 10 f0       	push   $0xf0107531
f010181b:	68 6f 73 10 f0       	push   $0xf010736f
f0101820:	68 30 03 00 00       	push   $0x330
f0101825:	68 49 73 10 f0       	push   $0xf0107349
f010182a:	e8 11 e8 ff ff       	call   f0100040 <_panic>
		--nfree;
f010182f:	83 eb 01             	sub    $0x1,%ebx
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101832:	8b 00                	mov    (%eax),%eax
f0101834:	85 c0                	test   %eax,%eax
f0101836:	75 f7                	jne    f010182f <mem_init+0x55d>
	assert(nfree == 0);
f0101838:	85 db                	test   %ebx,%ebx
f010183a:	0f 85 64 09 00 00    	jne    f01021a4 <mem_init+0xed2>
	cprintf("check_page_alloc() succeeded!\n");
f0101840:	83 ec 0c             	sub    $0xc,%esp
f0101843:	68 8c 6b 10 f0       	push   $0xf0106b8c
f0101848:	e8 46 20 00 00       	call   f0103893 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f010184d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101854:	e8 c7 f6 ff ff       	call   f0100f20 <page_alloc>
f0101859:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010185c:	83 c4 10             	add    $0x10,%esp
f010185f:	85 c0                	test   %eax,%eax
f0101861:	0f 84 56 09 00 00    	je     f01021bd <mem_init+0xeeb>
	assert((pp1 = page_alloc(0)));
f0101867:	83 ec 0c             	sub    $0xc,%esp
f010186a:	6a 00                	push   $0x0
f010186c:	e8 af f6 ff ff       	call   f0100f20 <page_alloc>
f0101871:	89 c3                	mov    %eax,%ebx
f0101873:	83 c4 10             	add    $0x10,%esp
f0101876:	85 c0                	test   %eax,%eax
f0101878:	0f 84 58 09 00 00    	je     f01021d6 <mem_init+0xf04>
	assert((pp2 = page_alloc(0)));
f010187e:	83 ec 0c             	sub    $0xc,%esp
f0101881:	6a 00                	push   $0x0
f0101883:	e8 98 f6 ff ff       	call   f0100f20 <page_alloc>
f0101888:	89 c6                	mov    %eax,%esi
f010188a:	83 c4 10             	add    $0x10,%esp
f010188d:	85 c0                	test   %eax,%eax
f010188f:	0f 84 5a 09 00 00    	je     f01021ef <mem_init+0xf1d>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101895:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0101898:	0f 84 6a 09 00 00    	je     f0102208 <mem_init+0xf36>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010189e:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f01018a1:	0f 84 7a 09 00 00    	je     f0102221 <mem_init+0xf4f>
f01018a7:	39 c3                	cmp    %eax,%ebx
f01018a9:	0f 84 72 09 00 00    	je     f0102221 <mem_init+0xf4f>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f01018af:	a1 40 92 1e f0       	mov    0xf01e9240,%eax
f01018b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f01018b7:	c7 05 40 92 1e f0 00 	movl   $0x0,0xf01e9240
f01018be:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f01018c1:	83 ec 0c             	sub    $0xc,%esp
f01018c4:	6a 00                	push   $0x0
f01018c6:	e8 55 f6 ff ff       	call   f0100f20 <page_alloc>
f01018cb:	83 c4 10             	add    $0x10,%esp
f01018ce:	85 c0                	test   %eax,%eax
f01018d0:	0f 85 64 09 00 00    	jne    f010223a <mem_init+0xf68>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01018d6:	83 ec 04             	sub    $0x4,%esp
f01018d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01018dc:	50                   	push   %eax
f01018dd:	6a 00                	push   $0x0
f01018df:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f01018e5:	e8 24 f8 ff ff       	call   f010110e <page_lookup>
f01018ea:	83 c4 10             	add    $0x10,%esp
f01018ed:	85 c0                	test   %eax,%eax
f01018ef:	0f 85 5e 09 00 00    	jne    f0102253 <mem_init+0xf81>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01018f5:	6a 02                	push   $0x2
f01018f7:	6a 00                	push   $0x0
f01018f9:	53                   	push   %ebx
f01018fa:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101900:	e8 ec f8 ff ff       	call   f01011f1 <page_insert>
f0101905:	83 c4 10             	add    $0x10,%esp
f0101908:	85 c0                	test   %eax,%eax
f010190a:	0f 89 5c 09 00 00    	jns    f010226c <mem_init+0xf9a>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101910:	83 ec 0c             	sub    $0xc,%esp
f0101913:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101916:	e8 77 f6 ff ff       	call   f0100f92 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010191b:	6a 02                	push   $0x2
f010191d:	6a 00                	push   $0x0
f010191f:	53                   	push   %ebx
f0101920:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101926:	e8 c6 f8 ff ff       	call   f01011f1 <page_insert>
f010192b:	83 c4 20             	add    $0x20,%esp
f010192e:	85 c0                	test   %eax,%eax
f0101930:	0f 85 4f 09 00 00    	jne    f0102285 <mem_init+0xfb3>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101936:	8b 3d 8c 9e 1e f0    	mov    0xf01e9e8c,%edi
	return (pp - pages) << PGSHIFT;
f010193c:	8b 0d 90 9e 1e f0    	mov    0xf01e9e90,%ecx
f0101942:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101945:	8b 17                	mov    (%edi),%edx
f0101947:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010194d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101950:	29 c8                	sub    %ecx,%eax
f0101952:	c1 f8 03             	sar    $0x3,%eax
f0101955:	c1 e0 0c             	shl    $0xc,%eax
f0101958:	39 c2                	cmp    %eax,%edx
f010195a:	0f 85 3e 09 00 00    	jne    f010229e <mem_init+0xfcc>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101960:	ba 00 00 00 00       	mov    $0x0,%edx
f0101965:	89 f8                	mov    %edi,%eax
f0101967:	e8 70 f1 ff ff       	call   f0100adc <check_va2pa>
f010196c:	89 da                	mov    %ebx,%edx
f010196e:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101971:	c1 fa 03             	sar    $0x3,%edx
f0101974:	c1 e2 0c             	shl    $0xc,%edx
f0101977:	39 d0                	cmp    %edx,%eax
f0101979:	0f 85 38 09 00 00    	jne    f01022b7 <mem_init+0xfe5>
	assert(pp1->pp_ref == 1);
f010197f:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101984:	0f 85 46 09 00 00    	jne    f01022d0 <mem_init+0xffe>
	assert(pp0->pp_ref == 1);
f010198a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010198d:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101992:	0f 85 51 09 00 00    	jne    f01022e9 <mem_init+0x1017>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101998:	6a 02                	push   $0x2
f010199a:	68 00 10 00 00       	push   $0x1000
f010199f:	56                   	push   %esi
f01019a0:	57                   	push   %edi
f01019a1:	e8 4b f8 ff ff       	call   f01011f1 <page_insert>
f01019a6:	83 c4 10             	add    $0x10,%esp
f01019a9:	85 c0                	test   %eax,%eax
f01019ab:	0f 85 51 09 00 00    	jne    f0102302 <mem_init+0x1030>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01019b1:	ba 00 10 00 00       	mov    $0x1000,%edx
f01019b6:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f01019bb:	e8 1c f1 ff ff       	call   f0100adc <check_va2pa>
f01019c0:	89 f2                	mov    %esi,%edx
f01019c2:	2b 15 90 9e 1e f0    	sub    0xf01e9e90,%edx
f01019c8:	c1 fa 03             	sar    $0x3,%edx
f01019cb:	c1 e2 0c             	shl    $0xc,%edx
f01019ce:	39 d0                	cmp    %edx,%eax
f01019d0:	0f 85 45 09 00 00    	jne    f010231b <mem_init+0x1049>
	assert(pp2->pp_ref == 1);
f01019d6:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01019db:	0f 85 53 09 00 00    	jne    f0102334 <mem_init+0x1062>

	// should be no free memory
	assert(!page_alloc(0));
f01019e1:	83 ec 0c             	sub    $0xc,%esp
f01019e4:	6a 00                	push   $0x0
f01019e6:	e8 35 f5 ff ff       	call   f0100f20 <page_alloc>
f01019eb:	83 c4 10             	add    $0x10,%esp
f01019ee:	85 c0                	test   %eax,%eax
f01019f0:	0f 85 57 09 00 00    	jne    f010234d <mem_init+0x107b>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01019f6:	6a 02                	push   $0x2
f01019f8:	68 00 10 00 00       	push   $0x1000
f01019fd:	56                   	push   %esi
f01019fe:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101a04:	e8 e8 f7 ff ff       	call   f01011f1 <page_insert>
f0101a09:	83 c4 10             	add    $0x10,%esp
f0101a0c:	85 c0                	test   %eax,%eax
f0101a0e:	0f 85 52 09 00 00    	jne    f0102366 <mem_init+0x1094>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101a14:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101a19:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f0101a1e:	e8 b9 f0 ff ff       	call   f0100adc <check_va2pa>
f0101a23:	89 f2                	mov    %esi,%edx
f0101a25:	2b 15 90 9e 1e f0    	sub    0xf01e9e90,%edx
f0101a2b:	c1 fa 03             	sar    $0x3,%edx
f0101a2e:	c1 e2 0c             	shl    $0xc,%edx
f0101a31:	39 d0                	cmp    %edx,%eax
f0101a33:	0f 85 46 09 00 00    	jne    f010237f <mem_init+0x10ad>
	assert(pp2->pp_ref == 1);
f0101a39:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101a3e:	0f 85 54 09 00 00    	jne    f0102398 <mem_init+0x10c6>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101a44:	83 ec 0c             	sub    $0xc,%esp
f0101a47:	6a 00                	push   $0x0
f0101a49:	e8 d2 f4 ff ff       	call   f0100f20 <page_alloc>
f0101a4e:	83 c4 10             	add    $0x10,%esp
f0101a51:	85 c0                	test   %eax,%eax
f0101a53:	0f 85 58 09 00 00    	jne    f01023b1 <mem_init+0x10df>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101a59:	8b 15 8c 9e 1e f0    	mov    0xf01e9e8c,%edx
f0101a5f:	8b 02                	mov    (%edx),%eax
f0101a61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101a66:	89 c1                	mov    %eax,%ecx
f0101a68:	c1 e9 0c             	shr    $0xc,%ecx
f0101a6b:	3b 0d 88 9e 1e f0    	cmp    0xf01e9e88,%ecx
f0101a71:	0f 83 53 09 00 00    	jae    f01023ca <mem_init+0x10f8>
	return (void *)(pa + KERNBASE);
f0101a77:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101a7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101a7f:	83 ec 04             	sub    $0x4,%esp
f0101a82:	6a 00                	push   $0x0
f0101a84:	68 00 10 00 00       	push   $0x1000
f0101a89:	52                   	push   %edx
f0101a8a:	e8 67 f5 ff ff       	call   f0100ff6 <pgdir_walk>
f0101a8f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101a92:	8d 51 04             	lea    0x4(%ecx),%edx
f0101a95:	83 c4 10             	add    $0x10,%esp
f0101a98:	39 d0                	cmp    %edx,%eax
f0101a9a:	0f 85 3f 09 00 00    	jne    f01023df <mem_init+0x110d>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101aa0:	6a 06                	push   $0x6
f0101aa2:	68 00 10 00 00       	push   $0x1000
f0101aa7:	56                   	push   %esi
f0101aa8:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101aae:	e8 3e f7 ff ff       	call   f01011f1 <page_insert>
f0101ab3:	83 c4 10             	add    $0x10,%esp
f0101ab6:	85 c0                	test   %eax,%eax
f0101ab8:	0f 85 3a 09 00 00    	jne    f01023f8 <mem_init+0x1126>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101abe:	8b 3d 8c 9e 1e f0    	mov    0xf01e9e8c,%edi
f0101ac4:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ac9:	89 f8                	mov    %edi,%eax
f0101acb:	e8 0c f0 ff ff       	call   f0100adc <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101ad0:	89 f2                	mov    %esi,%edx
f0101ad2:	2b 15 90 9e 1e f0    	sub    0xf01e9e90,%edx
f0101ad8:	c1 fa 03             	sar    $0x3,%edx
f0101adb:	c1 e2 0c             	shl    $0xc,%edx
f0101ade:	39 d0                	cmp    %edx,%eax
f0101ae0:	0f 85 2b 09 00 00    	jne    f0102411 <mem_init+0x113f>
	assert(pp2->pp_ref == 1);
f0101ae6:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101aeb:	0f 85 39 09 00 00    	jne    f010242a <mem_init+0x1158>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101af1:	83 ec 04             	sub    $0x4,%esp
f0101af4:	6a 00                	push   $0x0
f0101af6:	68 00 10 00 00       	push   $0x1000
f0101afb:	57                   	push   %edi
f0101afc:	e8 f5 f4 ff ff       	call   f0100ff6 <pgdir_walk>
f0101b01:	83 c4 10             	add    $0x10,%esp
f0101b04:	f6 00 04             	testb  $0x4,(%eax)
f0101b07:	0f 84 36 09 00 00    	je     f0102443 <mem_init+0x1171>
	assert(kern_pgdir[0] & PTE_U);
f0101b0d:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f0101b12:	f6 00 04             	testb  $0x4,(%eax)
f0101b15:	0f 84 41 09 00 00    	je     f010245c <mem_init+0x118a>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101b1b:	6a 02                	push   $0x2
f0101b1d:	68 00 10 00 00       	push   $0x1000
f0101b22:	56                   	push   %esi
f0101b23:	50                   	push   %eax
f0101b24:	e8 c8 f6 ff ff       	call   f01011f1 <page_insert>
f0101b29:	83 c4 10             	add    $0x10,%esp
f0101b2c:	85 c0                	test   %eax,%eax
f0101b2e:	0f 85 41 09 00 00    	jne    f0102475 <mem_init+0x11a3>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101b34:	83 ec 04             	sub    $0x4,%esp
f0101b37:	6a 00                	push   $0x0
f0101b39:	68 00 10 00 00       	push   $0x1000
f0101b3e:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101b44:	e8 ad f4 ff ff       	call   f0100ff6 <pgdir_walk>
f0101b49:	83 c4 10             	add    $0x10,%esp
f0101b4c:	f6 00 02             	testb  $0x2,(%eax)
f0101b4f:	0f 84 39 09 00 00    	je     f010248e <mem_init+0x11bc>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101b55:	83 ec 04             	sub    $0x4,%esp
f0101b58:	6a 00                	push   $0x0
f0101b5a:	68 00 10 00 00       	push   $0x1000
f0101b5f:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101b65:	e8 8c f4 ff ff       	call   f0100ff6 <pgdir_walk>
f0101b6a:	83 c4 10             	add    $0x10,%esp
f0101b6d:	f6 00 04             	testb  $0x4,(%eax)
f0101b70:	0f 85 31 09 00 00    	jne    f01024a7 <mem_init+0x11d5>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101b76:	6a 02                	push   $0x2
f0101b78:	68 00 00 40 00       	push   $0x400000
f0101b7d:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101b80:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101b86:	e8 66 f6 ff ff       	call   f01011f1 <page_insert>
f0101b8b:	83 c4 10             	add    $0x10,%esp
f0101b8e:	85 c0                	test   %eax,%eax
f0101b90:	0f 89 2a 09 00 00    	jns    f01024c0 <mem_init+0x11ee>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101b96:	6a 02                	push   $0x2
f0101b98:	68 00 10 00 00       	push   $0x1000
f0101b9d:	53                   	push   %ebx
f0101b9e:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101ba4:	e8 48 f6 ff ff       	call   f01011f1 <page_insert>
f0101ba9:	83 c4 10             	add    $0x10,%esp
f0101bac:	85 c0                	test   %eax,%eax
f0101bae:	0f 85 25 09 00 00    	jne    f01024d9 <mem_init+0x1207>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101bb4:	83 ec 04             	sub    $0x4,%esp
f0101bb7:	6a 00                	push   $0x0
f0101bb9:	68 00 10 00 00       	push   $0x1000
f0101bbe:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101bc4:	e8 2d f4 ff ff       	call   f0100ff6 <pgdir_walk>
f0101bc9:	83 c4 10             	add    $0x10,%esp
f0101bcc:	f6 00 04             	testb  $0x4,(%eax)
f0101bcf:	0f 85 1d 09 00 00    	jne    f01024f2 <mem_init+0x1220>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101bd5:	8b 3d 8c 9e 1e f0    	mov    0xf01e9e8c,%edi
f0101bdb:	ba 00 00 00 00       	mov    $0x0,%edx
f0101be0:	89 f8                	mov    %edi,%eax
f0101be2:	e8 f5 ee ff ff       	call   f0100adc <check_va2pa>
f0101be7:	89 c1                	mov    %eax,%ecx
f0101be9:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101bec:	89 d8                	mov    %ebx,%eax
f0101bee:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0101bf4:	c1 f8 03             	sar    $0x3,%eax
f0101bf7:	c1 e0 0c             	shl    $0xc,%eax
f0101bfa:	39 c1                	cmp    %eax,%ecx
f0101bfc:	0f 85 09 09 00 00    	jne    f010250b <mem_init+0x1239>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101c02:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c07:	89 f8                	mov    %edi,%eax
f0101c09:	e8 ce ee ff ff       	call   f0100adc <check_va2pa>
f0101c0e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101c11:	0f 85 0d 09 00 00    	jne    f0102524 <mem_init+0x1252>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101c17:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0101c1c:	0f 85 1b 09 00 00    	jne    f010253d <mem_init+0x126b>
	assert(pp2->pp_ref == 0);
f0101c22:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101c27:	0f 85 29 09 00 00    	jne    f0102556 <mem_init+0x1284>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101c2d:	83 ec 0c             	sub    $0xc,%esp
f0101c30:	6a 00                	push   $0x0
f0101c32:	e8 e9 f2 ff ff       	call   f0100f20 <page_alloc>
f0101c37:	83 c4 10             	add    $0x10,%esp
f0101c3a:	39 c6                	cmp    %eax,%esi
f0101c3c:	0f 85 2d 09 00 00    	jne    f010256f <mem_init+0x129d>
f0101c42:	85 c0                	test   %eax,%eax
f0101c44:	0f 84 25 09 00 00    	je     f010256f <mem_init+0x129d>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101c4a:	83 ec 08             	sub    $0x8,%esp
f0101c4d:	6a 00                	push   $0x0
f0101c4f:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101c55:	e8 4f f5 ff ff       	call   f01011a9 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101c5a:	8b 3d 8c 9e 1e f0    	mov    0xf01e9e8c,%edi
f0101c60:	ba 00 00 00 00       	mov    $0x0,%edx
f0101c65:	89 f8                	mov    %edi,%eax
f0101c67:	e8 70 ee ff ff       	call   f0100adc <check_va2pa>
f0101c6c:	83 c4 10             	add    $0x10,%esp
f0101c6f:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101c72:	0f 85 10 09 00 00    	jne    f0102588 <mem_init+0x12b6>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101c78:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c7d:	89 f8                	mov    %edi,%eax
f0101c7f:	e8 58 ee ff ff       	call   f0100adc <check_va2pa>
f0101c84:	89 da                	mov    %ebx,%edx
f0101c86:	2b 15 90 9e 1e f0    	sub    0xf01e9e90,%edx
f0101c8c:	c1 fa 03             	sar    $0x3,%edx
f0101c8f:	c1 e2 0c             	shl    $0xc,%edx
f0101c92:	39 d0                	cmp    %edx,%eax
f0101c94:	0f 85 07 09 00 00    	jne    f01025a1 <mem_init+0x12cf>
	assert(pp1->pp_ref == 1);
f0101c9a:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101c9f:	0f 85 15 09 00 00    	jne    f01025ba <mem_init+0x12e8>
	assert(pp2->pp_ref == 0);
f0101ca5:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101caa:	0f 85 23 09 00 00    	jne    f01025d3 <mem_init+0x1301>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101cb0:	6a 00                	push   $0x0
f0101cb2:	68 00 10 00 00       	push   $0x1000
f0101cb7:	53                   	push   %ebx
f0101cb8:	57                   	push   %edi
f0101cb9:	e8 33 f5 ff ff       	call   f01011f1 <page_insert>
f0101cbe:	83 c4 10             	add    $0x10,%esp
f0101cc1:	85 c0                	test   %eax,%eax
f0101cc3:	0f 85 23 09 00 00    	jne    f01025ec <mem_init+0x131a>
	assert(pp1->pp_ref);
f0101cc9:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101cce:	0f 84 31 09 00 00    	je     f0102605 <mem_init+0x1333>
	assert(pp1->pp_link == NULL);
f0101cd4:	83 3b 00             	cmpl   $0x0,(%ebx)
f0101cd7:	0f 85 41 09 00 00    	jne    f010261e <mem_init+0x134c>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101cdd:	83 ec 08             	sub    $0x8,%esp
f0101ce0:	68 00 10 00 00       	push   $0x1000
f0101ce5:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101ceb:	e8 b9 f4 ff ff       	call   f01011a9 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101cf0:	8b 3d 8c 9e 1e f0    	mov    0xf01e9e8c,%edi
f0101cf6:	ba 00 00 00 00       	mov    $0x0,%edx
f0101cfb:	89 f8                	mov    %edi,%eax
f0101cfd:	e8 da ed ff ff       	call   f0100adc <check_va2pa>
f0101d02:	83 c4 10             	add    $0x10,%esp
f0101d05:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d08:	0f 85 29 09 00 00    	jne    f0102637 <mem_init+0x1365>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101d0e:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d13:	89 f8                	mov    %edi,%eax
f0101d15:	e8 c2 ed ff ff       	call   f0100adc <check_va2pa>
f0101d1a:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d1d:	0f 85 2d 09 00 00    	jne    f0102650 <mem_init+0x137e>
	assert(pp1->pp_ref == 0);
f0101d23:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101d28:	0f 85 3b 09 00 00    	jne    f0102669 <mem_init+0x1397>
	assert(pp2->pp_ref == 0);
f0101d2e:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101d33:	0f 85 49 09 00 00    	jne    f0102682 <mem_init+0x13b0>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101d39:	83 ec 0c             	sub    $0xc,%esp
f0101d3c:	6a 00                	push   $0x0
f0101d3e:	e8 dd f1 ff ff       	call   f0100f20 <page_alloc>
f0101d43:	83 c4 10             	add    $0x10,%esp
f0101d46:	85 c0                	test   %eax,%eax
f0101d48:	0f 84 4d 09 00 00    	je     f010269b <mem_init+0x13c9>
f0101d4e:	39 c3                	cmp    %eax,%ebx
f0101d50:	0f 85 45 09 00 00    	jne    f010269b <mem_init+0x13c9>

	// should be no free memory
	assert(!page_alloc(0));
f0101d56:	83 ec 0c             	sub    $0xc,%esp
f0101d59:	6a 00                	push   $0x0
f0101d5b:	e8 c0 f1 ff ff       	call   f0100f20 <page_alloc>
f0101d60:	83 c4 10             	add    $0x10,%esp
f0101d63:	85 c0                	test   %eax,%eax
f0101d65:	0f 85 49 09 00 00    	jne    f01026b4 <mem_init+0x13e2>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101d6b:	8b 0d 8c 9e 1e f0    	mov    0xf01e9e8c,%ecx
f0101d71:	8b 11                	mov    (%ecx),%edx
f0101d73:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101d79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d7c:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0101d82:	c1 f8 03             	sar    $0x3,%eax
f0101d85:	c1 e0 0c             	shl    $0xc,%eax
f0101d88:	39 c2                	cmp    %eax,%edx
f0101d8a:	0f 85 3d 09 00 00    	jne    f01026cd <mem_init+0x13fb>
	kern_pgdir[0] = 0;
f0101d90:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101d96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d99:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101d9e:	0f 85 42 09 00 00    	jne    f01026e6 <mem_init+0x1414>
	pp0->pp_ref = 0;
f0101da4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101da7:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101dad:	83 ec 0c             	sub    $0xc,%esp
f0101db0:	50                   	push   %eax
f0101db1:	e8 dc f1 ff ff       	call   f0100f92 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101db6:	83 c4 0c             	add    $0xc,%esp
f0101db9:	6a 01                	push   $0x1
f0101dbb:	68 00 10 40 00       	push   $0x401000
f0101dc0:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101dc6:	e8 2b f2 ff ff       	call   f0100ff6 <pgdir_walk>
f0101dcb:	89 c7                	mov    %eax,%edi
f0101dcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101dd0:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f0101dd5:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101dd8:	8b 40 04             	mov    0x4(%eax),%eax
f0101ddb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101de0:	8b 0d 88 9e 1e f0    	mov    0xf01e9e88,%ecx
f0101de6:	89 c2                	mov    %eax,%edx
f0101de8:	c1 ea 0c             	shr    $0xc,%edx
f0101deb:	83 c4 10             	add    $0x10,%esp
f0101dee:	39 ca                	cmp    %ecx,%edx
f0101df0:	0f 83 09 09 00 00    	jae    f01026ff <mem_init+0x142d>
	assert(ptep == ptep1 + PTX(va));
f0101df6:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f0101dfb:	39 c7                	cmp    %eax,%edi
f0101dfd:	0f 85 11 09 00 00    	jne    f0102714 <mem_init+0x1442>
	kern_pgdir[PDX(va)] = 0;
f0101e03:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101e06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f0101e0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e10:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101e16:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0101e1c:	c1 f8 03             	sar    $0x3,%eax
f0101e1f:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101e22:	89 c2                	mov    %eax,%edx
f0101e24:	c1 ea 0c             	shr    $0xc,%edx
f0101e27:	39 d1                	cmp    %edx,%ecx
f0101e29:	0f 86 fe 08 00 00    	jbe    f010272d <mem_init+0x145b>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101e2f:	83 ec 04             	sub    $0x4,%esp
f0101e32:	68 00 10 00 00       	push   $0x1000
f0101e37:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101e3c:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101e41:	50                   	push   %eax
f0101e42:	e8 8b 39 00 00       	call   f01057d2 <memset>
	page_free(pp0);
f0101e47:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0101e4a:	89 3c 24             	mov    %edi,(%esp)
f0101e4d:	e8 40 f1 ff ff       	call   f0100f92 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101e52:	83 c4 0c             	add    $0xc,%esp
f0101e55:	6a 01                	push   $0x1
f0101e57:	6a 00                	push   $0x0
f0101e59:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101e5f:	e8 92 f1 ff ff       	call   f0100ff6 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101e64:	89 fa                	mov    %edi,%edx
f0101e66:	2b 15 90 9e 1e f0    	sub    0xf01e9e90,%edx
f0101e6c:	c1 fa 03             	sar    $0x3,%edx
f0101e6f:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101e72:	89 d0                	mov    %edx,%eax
f0101e74:	c1 e8 0c             	shr    $0xc,%eax
f0101e77:	83 c4 10             	add    $0x10,%esp
f0101e7a:	3b 05 88 9e 1e f0    	cmp    0xf01e9e88,%eax
f0101e80:	0f 83 b9 08 00 00    	jae    f010273f <mem_init+0x146d>
	return (void *)(pa + KERNBASE);
f0101e86:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0101e8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101e8f:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0101e95:	f6 00 01             	testb  $0x1,(%eax)
f0101e98:	0f 85 b3 08 00 00    	jne    f0102751 <mem_init+0x147f>
f0101e9e:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f0101ea1:	39 d0                	cmp    %edx,%eax
f0101ea3:	75 f0                	jne    f0101e95 <mem_init+0xbc3>
	kern_pgdir[0] = 0;
f0101ea5:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f0101eaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0101eb0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101eb3:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0101eb9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101ebc:	89 0d 40 92 1e f0    	mov    %ecx,0xf01e9240

	// free the pages we took
	page_free(pp0);
f0101ec2:	83 ec 0c             	sub    $0xc,%esp
f0101ec5:	50                   	push   %eax
f0101ec6:	e8 c7 f0 ff ff       	call   f0100f92 <page_free>
	page_free(pp1);
f0101ecb:	89 1c 24             	mov    %ebx,(%esp)
f0101ece:	e8 bf f0 ff ff       	call   f0100f92 <page_free>
	page_free(pp2);
f0101ed3:	89 34 24             	mov    %esi,(%esp)
f0101ed6:	e8 b7 f0 ff ff       	call   f0100f92 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0101edb:	83 c4 08             	add    $0x8,%esp
f0101ede:	68 01 10 00 00       	push   $0x1001
f0101ee3:	6a 00                	push   $0x0
f0101ee5:	e8 7b f3 ff ff       	call   f0101265 <mmio_map_region>
f0101eea:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0101eec:	83 c4 08             	add    $0x8,%esp
f0101eef:	68 00 10 00 00       	push   $0x1000
f0101ef4:	6a 00                	push   $0x0
f0101ef6:	e8 6a f3 ff ff       	call   f0101265 <mmio_map_region>
f0101efb:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0101efd:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0101f03:	83 c4 10             	add    $0x10,%esp
f0101f06:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0101f0c:	0f 86 58 08 00 00    	jbe    f010276a <mem_init+0x1498>
f0101f12:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0101f17:	0f 87 4d 08 00 00    	ja     f010276a <mem_init+0x1498>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0101f1d:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0101f23:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0101f29:	0f 87 54 08 00 00    	ja     f0102783 <mem_init+0x14b1>
f0101f2f:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0101f35:	0f 86 48 08 00 00    	jbe    f0102783 <mem_init+0x14b1>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0101f3b:	89 da                	mov    %ebx,%edx
f0101f3d:	09 f2                	or     %esi,%edx
f0101f3f:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0101f45:	0f 85 51 08 00 00    	jne    f010279c <mem_init+0x14ca>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0101f4b:	39 c6                	cmp    %eax,%esi
f0101f4d:	0f 82 62 08 00 00    	jb     f01027b5 <mem_init+0x14e3>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0101f53:	8b 3d 8c 9e 1e f0    	mov    0xf01e9e8c,%edi
f0101f59:	89 da                	mov    %ebx,%edx
f0101f5b:	89 f8                	mov    %edi,%eax
f0101f5d:	e8 7a eb ff ff       	call   f0100adc <check_va2pa>
f0101f62:	85 c0                	test   %eax,%eax
f0101f64:	0f 85 64 08 00 00    	jne    f01027ce <mem_init+0x14fc>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0101f6a:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0101f70:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101f73:	89 c2                	mov    %eax,%edx
f0101f75:	89 f8                	mov    %edi,%eax
f0101f77:	e8 60 eb ff ff       	call   f0100adc <check_va2pa>
f0101f7c:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0101f81:	0f 85 60 08 00 00    	jne    f01027e7 <mem_init+0x1515>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0101f87:	89 f2                	mov    %esi,%edx
f0101f89:	89 f8                	mov    %edi,%eax
f0101f8b:	e8 4c eb ff ff       	call   f0100adc <check_va2pa>
f0101f90:	85 c0                	test   %eax,%eax
f0101f92:	0f 85 68 08 00 00    	jne    f0102800 <mem_init+0x152e>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0101f98:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0101f9e:	89 f8                	mov    %edi,%eax
f0101fa0:	e8 37 eb ff ff       	call   f0100adc <check_va2pa>
f0101fa5:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101fa8:	0f 85 6b 08 00 00    	jne    f0102819 <mem_init+0x1547>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0101fae:	83 ec 04             	sub    $0x4,%esp
f0101fb1:	6a 00                	push   $0x0
f0101fb3:	53                   	push   %ebx
f0101fb4:	57                   	push   %edi
f0101fb5:	e8 3c f0 ff ff       	call   f0100ff6 <pgdir_walk>
f0101fba:	83 c4 10             	add    $0x10,%esp
f0101fbd:	f6 00 1a             	testb  $0x1a,(%eax)
f0101fc0:	0f 84 6c 08 00 00    	je     f0102832 <mem_init+0x1560>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0101fc6:	83 ec 04             	sub    $0x4,%esp
f0101fc9:	6a 00                	push   $0x0
f0101fcb:	53                   	push   %ebx
f0101fcc:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101fd2:	e8 1f f0 ff ff       	call   f0100ff6 <pgdir_walk>
f0101fd7:	83 c4 10             	add    $0x10,%esp
f0101fda:	f6 00 04             	testb  $0x4,(%eax)
f0101fdd:	0f 85 68 08 00 00    	jne    f010284b <mem_init+0x1579>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0101fe3:	83 ec 04             	sub    $0x4,%esp
f0101fe6:	6a 00                	push   $0x0
f0101fe8:	53                   	push   %ebx
f0101fe9:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0101fef:	e8 02 f0 ff ff       	call   f0100ff6 <pgdir_walk>
f0101ff4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0101ffa:	83 c4 0c             	add    $0xc,%esp
f0101ffd:	6a 00                	push   $0x0
f0101fff:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102002:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0102008:	e8 e9 ef ff ff       	call   f0100ff6 <pgdir_walk>
f010200d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102013:	83 c4 0c             	add    $0xc,%esp
f0102016:	6a 00                	push   $0x0
f0102018:	56                   	push   %esi
f0102019:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f010201f:	e8 d2 ef ff ff       	call   f0100ff6 <pgdir_walk>
f0102024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f010202a:	c7 04 24 24 76 10 f0 	movl   $0xf0107624,(%esp)
f0102031:	e8 5d 18 00 00       	call   f0103893 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f0102036:	a1 90 9e 1e f0       	mov    0xf01e9e90,%eax
	if ((uint32_t)kva < KERNBASE)
f010203b:	83 c4 10             	add    $0x10,%esp
f010203e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102043:	0f 86 1b 08 00 00    	jbe    f0102864 <mem_init+0x1592>
f0102049:	83 ec 08             	sub    $0x8,%esp
f010204c:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f010204e:	05 00 00 00 10       	add    $0x10000000,%eax
f0102053:	50                   	push   %eax
f0102054:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102059:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f010205e:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f0102063:	e8 21 f0 ff ff       	call   f0101089 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f0102068:	a1 44 92 1e f0       	mov    0xf01e9244,%eax
	if ((uint32_t)kva < KERNBASE)
f010206d:	83 c4 10             	add    $0x10,%esp
f0102070:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102075:	0f 86 fe 07 00 00    	jbe    f0102879 <mem_init+0x15a7>
f010207b:	83 ec 08             	sub    $0x8,%esp
f010207e:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102080:	05 00 00 00 10       	add    $0x10000000,%eax
f0102085:	50                   	push   %eax
f0102086:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010208b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102090:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f0102095:	e8 ef ef ff ff       	call   f0101089 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f010209a:	83 c4 10             	add    $0x10,%esp
f010209d:	b8 00 80 11 f0       	mov    $0xf0118000,%eax
f01020a2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01020a7:	0f 86 e1 07 00 00    	jbe    f010288e <mem_init+0x15bc>
	boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f01020ad:	83 ec 08             	sub    $0x8,%esp
f01020b0:	6a 02                	push   $0x2
f01020b2:	68 00 80 11 00       	push   $0x118000
f01020b7:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01020bc:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01020c1:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f01020c6:	e8 be ef ff ff       	call   f0101089 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W);
f01020cb:	83 c4 08             	add    $0x8,%esp
f01020ce:	6a 02                	push   $0x2
f01020d0:	6a 00                	push   $0x0
f01020d2:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f01020d7:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01020dc:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f01020e1:	e8 a3 ef ff ff       	call   f0101089 <boot_map_region>
f01020e6:	c7 45 cc 00 b0 1e f0 	movl   $0xf01eb000,-0x34(%ebp)
f01020ed:	bf 00 b0 22 f0       	mov    $0xf022b000,%edi
f01020f2:	83 c4 10             	add    $0x10,%esp
f01020f5:	bb 00 b0 1e f0       	mov    $0xf01eb000,%ebx
f01020fa:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f01020ff:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102105:	0f 86 98 07 00 00    	jbe    f01028a3 <mem_init+0x15d1>
		boot_map_region(kern_pgdir, 
f010210b:	83 ec 08             	sub    $0x8,%esp
f010210e:	6a 02                	push   $0x2
f0102110:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102116:	50                   	push   %eax
f0102117:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010211c:	89 f2                	mov    %esi,%edx
f010211e:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
f0102123:	e8 61 ef ff ff       	call   f0101089 <boot_map_region>
f0102128:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f010212e:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for (int i = 0; i < NCPU; i++) {
f0102134:	83 c4 10             	add    $0x10,%esp
f0102137:	39 fb                	cmp    %edi,%ebx
f0102139:	75 c4                	jne    f01020ff <mem_init+0xe2d>
	pgdir = kern_pgdir;
f010213b:	8b 3d 8c 9e 1e f0    	mov    0xf01e9e8c,%edi
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102141:	a1 88 9e 1e f0       	mov    0xf01e9e88,%eax
f0102146:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0102149:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102150:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102155:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102158:	a1 90 9e 1e f0       	mov    0xf01e9e90,%eax
f010215d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102160:	89 45 d0             	mov    %eax,-0x30(%ebp)
	return (physaddr_t)kva - KERNBASE;
f0102163:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi
	for (i = 0; i < n; i += PGSIZE)
f0102169:	bb 00 00 00 00       	mov    $0x0,%ebx
f010216e:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0102171:	0f 86 71 07 00 00    	jbe    f01028e8 <mem_init+0x1616>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102177:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f010217d:	89 f8                	mov    %edi,%eax
f010217f:	e8 58 e9 ff ff       	call   f0100adc <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102184:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f010218b:	0f 86 27 07 00 00    	jbe    f01028b8 <mem_init+0x15e6>
f0102191:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f0102194:	39 d0                	cmp    %edx,%eax
f0102196:	0f 85 33 07 00 00    	jne    f01028cf <mem_init+0x15fd>
	for (i = 0; i < n; i += PGSIZE)
f010219c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01021a2:	eb ca                	jmp    f010216e <mem_init+0xe9c>
	assert(nfree == 0);
f01021a4:	68 3b 75 10 f0       	push   $0xf010753b
f01021a9:	68 6f 73 10 f0       	push   $0xf010736f
f01021ae:	68 3d 03 00 00       	push   $0x33d
f01021b3:	68 49 73 10 f0       	push   $0xf0107349
f01021b8:	e8 83 de ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01021bd:	68 49 74 10 f0       	push   $0xf0107449
f01021c2:	68 6f 73 10 f0       	push   $0xf010736f
f01021c7:	68 a3 03 00 00       	push   $0x3a3
f01021cc:	68 49 73 10 f0       	push   $0xf0107349
f01021d1:	e8 6a de ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01021d6:	68 5f 74 10 f0       	push   $0xf010745f
f01021db:	68 6f 73 10 f0       	push   $0xf010736f
f01021e0:	68 a4 03 00 00       	push   $0x3a4
f01021e5:	68 49 73 10 f0       	push   $0xf0107349
f01021ea:	e8 51 de ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01021ef:	68 75 74 10 f0       	push   $0xf0107475
f01021f4:	68 6f 73 10 f0       	push   $0xf010736f
f01021f9:	68 a5 03 00 00       	push   $0x3a5
f01021fe:	68 49 73 10 f0       	push   $0xf0107349
f0102203:	e8 38 de ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0102208:	68 8b 74 10 f0       	push   $0xf010748b
f010220d:	68 6f 73 10 f0       	push   $0xf010736f
f0102212:	68 a8 03 00 00       	push   $0x3a8
f0102217:	68 49 73 10 f0       	push   $0xf0107349
f010221c:	e8 1f de ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102221:	68 6c 6b 10 f0       	push   $0xf0106b6c
f0102226:	68 6f 73 10 f0       	push   $0xf010736f
f010222b:	68 a9 03 00 00       	push   $0x3a9
f0102230:	68 49 73 10 f0       	push   $0xf0107349
f0102235:	e8 06 de ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010223a:	68 f4 74 10 f0       	push   $0xf01074f4
f010223f:	68 6f 73 10 f0       	push   $0xf010736f
f0102244:	68 b0 03 00 00       	push   $0x3b0
f0102249:	68 49 73 10 f0       	push   $0xf0107349
f010224e:	e8 ed dd ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102253:	68 ac 6b 10 f0       	push   $0xf0106bac
f0102258:	68 6f 73 10 f0       	push   $0xf010736f
f010225d:	68 b3 03 00 00       	push   $0x3b3
f0102262:	68 49 73 10 f0       	push   $0xf0107349
f0102267:	e8 d4 dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f010226c:	68 e4 6b 10 f0       	push   $0xf0106be4
f0102271:	68 6f 73 10 f0       	push   $0xf010736f
f0102276:	68 b6 03 00 00       	push   $0x3b6
f010227b:	68 49 73 10 f0       	push   $0xf0107349
f0102280:	e8 bb dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102285:	68 14 6c 10 f0       	push   $0xf0106c14
f010228a:	68 6f 73 10 f0       	push   $0xf010736f
f010228f:	68 ba 03 00 00       	push   $0x3ba
f0102294:	68 49 73 10 f0       	push   $0xf0107349
f0102299:	e8 a2 dd ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010229e:	68 44 6c 10 f0       	push   $0xf0106c44
f01022a3:	68 6f 73 10 f0       	push   $0xf010736f
f01022a8:	68 bb 03 00 00       	push   $0x3bb
f01022ad:	68 49 73 10 f0       	push   $0xf0107349
f01022b2:	e8 89 dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01022b7:	68 6c 6c 10 f0       	push   $0xf0106c6c
f01022bc:	68 6f 73 10 f0       	push   $0xf010736f
f01022c1:	68 bc 03 00 00       	push   $0x3bc
f01022c6:	68 49 73 10 f0       	push   $0xf0107349
f01022cb:	e8 70 dd ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01022d0:	68 46 75 10 f0       	push   $0xf0107546
f01022d5:	68 6f 73 10 f0       	push   $0xf010736f
f01022da:	68 bd 03 00 00       	push   $0x3bd
f01022df:	68 49 73 10 f0       	push   $0xf0107349
f01022e4:	e8 57 dd ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f01022e9:	68 57 75 10 f0       	push   $0xf0107557
f01022ee:	68 6f 73 10 f0       	push   $0xf010736f
f01022f3:	68 be 03 00 00       	push   $0x3be
f01022f8:	68 49 73 10 f0       	push   $0xf0107349
f01022fd:	e8 3e dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102302:	68 9c 6c 10 f0       	push   $0xf0106c9c
f0102307:	68 6f 73 10 f0       	push   $0xf010736f
f010230c:	68 c1 03 00 00       	push   $0x3c1
f0102311:	68 49 73 10 f0       	push   $0xf0107349
f0102316:	e8 25 dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010231b:	68 d8 6c 10 f0       	push   $0xf0106cd8
f0102320:	68 6f 73 10 f0       	push   $0xf010736f
f0102325:	68 c2 03 00 00       	push   $0x3c2
f010232a:	68 49 73 10 f0       	push   $0xf0107349
f010232f:	e8 0c dd ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102334:	68 68 75 10 f0       	push   $0xf0107568
f0102339:	68 6f 73 10 f0       	push   $0xf010736f
f010233e:	68 c3 03 00 00       	push   $0x3c3
f0102343:	68 49 73 10 f0       	push   $0xf0107349
f0102348:	e8 f3 dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010234d:	68 f4 74 10 f0       	push   $0xf01074f4
f0102352:	68 6f 73 10 f0       	push   $0xf010736f
f0102357:	68 c6 03 00 00       	push   $0x3c6
f010235c:	68 49 73 10 f0       	push   $0xf0107349
f0102361:	e8 da dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102366:	68 9c 6c 10 f0       	push   $0xf0106c9c
f010236b:	68 6f 73 10 f0       	push   $0xf010736f
f0102370:	68 c9 03 00 00       	push   $0x3c9
f0102375:	68 49 73 10 f0       	push   $0xf0107349
f010237a:	e8 c1 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010237f:	68 d8 6c 10 f0       	push   $0xf0106cd8
f0102384:	68 6f 73 10 f0       	push   $0xf010736f
f0102389:	68 ca 03 00 00       	push   $0x3ca
f010238e:	68 49 73 10 f0       	push   $0xf0107349
f0102393:	e8 a8 dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102398:	68 68 75 10 f0       	push   $0xf0107568
f010239d:	68 6f 73 10 f0       	push   $0xf010736f
f01023a2:	68 cb 03 00 00       	push   $0x3cb
f01023a7:	68 49 73 10 f0       	push   $0xf0107349
f01023ac:	e8 8f dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01023b1:	68 f4 74 10 f0       	push   $0xf01074f4
f01023b6:	68 6f 73 10 f0       	push   $0xf010736f
f01023bb:	68 cf 03 00 00       	push   $0x3cf
f01023c0:	68 49 73 10 f0       	push   $0xf0107349
f01023c5:	e8 76 dc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01023ca:	50                   	push   %eax
f01023cb:	68 64 64 10 f0       	push   $0xf0106464
f01023d0:	68 d2 03 00 00       	push   $0x3d2
f01023d5:	68 49 73 10 f0       	push   $0xf0107349
f01023da:	e8 61 dc ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f01023df:	68 08 6d 10 f0       	push   $0xf0106d08
f01023e4:	68 6f 73 10 f0       	push   $0xf010736f
f01023e9:	68 d3 03 00 00       	push   $0x3d3
f01023ee:	68 49 73 10 f0       	push   $0xf0107349
f01023f3:	e8 48 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01023f8:	68 48 6d 10 f0       	push   $0xf0106d48
f01023fd:	68 6f 73 10 f0       	push   $0xf010736f
f0102402:	68 d6 03 00 00       	push   $0x3d6
f0102407:	68 49 73 10 f0       	push   $0xf0107349
f010240c:	e8 2f dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102411:	68 d8 6c 10 f0       	push   $0xf0106cd8
f0102416:	68 6f 73 10 f0       	push   $0xf010736f
f010241b:	68 d7 03 00 00       	push   $0x3d7
f0102420:	68 49 73 10 f0       	push   $0xf0107349
f0102425:	e8 16 dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010242a:	68 68 75 10 f0       	push   $0xf0107568
f010242f:	68 6f 73 10 f0       	push   $0xf010736f
f0102434:	68 d8 03 00 00       	push   $0x3d8
f0102439:	68 49 73 10 f0       	push   $0xf0107349
f010243e:	e8 fd db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102443:	68 88 6d 10 f0       	push   $0xf0106d88
f0102448:	68 6f 73 10 f0       	push   $0xf010736f
f010244d:	68 d9 03 00 00       	push   $0x3d9
f0102452:	68 49 73 10 f0       	push   $0xf0107349
f0102457:	e8 e4 db ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f010245c:	68 79 75 10 f0       	push   $0xf0107579
f0102461:	68 6f 73 10 f0       	push   $0xf010736f
f0102466:	68 da 03 00 00       	push   $0x3da
f010246b:	68 49 73 10 f0       	push   $0xf0107349
f0102470:	e8 cb db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102475:	68 9c 6c 10 f0       	push   $0xf0106c9c
f010247a:	68 6f 73 10 f0       	push   $0xf010736f
f010247f:	68 dd 03 00 00       	push   $0x3dd
f0102484:	68 49 73 10 f0       	push   $0xf0107349
f0102489:	e8 b2 db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f010248e:	68 bc 6d 10 f0       	push   $0xf0106dbc
f0102493:	68 6f 73 10 f0       	push   $0xf010736f
f0102498:	68 de 03 00 00       	push   $0x3de
f010249d:	68 49 73 10 f0       	push   $0xf0107349
f01024a2:	e8 99 db ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01024a7:	68 f0 6d 10 f0       	push   $0xf0106df0
f01024ac:	68 6f 73 10 f0       	push   $0xf010736f
f01024b1:	68 df 03 00 00       	push   $0x3df
f01024b6:	68 49 73 10 f0       	push   $0xf0107349
f01024bb:	e8 80 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01024c0:	68 28 6e 10 f0       	push   $0xf0106e28
f01024c5:	68 6f 73 10 f0       	push   $0xf010736f
f01024ca:	68 e2 03 00 00       	push   $0x3e2
f01024cf:	68 49 73 10 f0       	push   $0xf0107349
f01024d4:	e8 67 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01024d9:	68 60 6e 10 f0       	push   $0xf0106e60
f01024de:	68 6f 73 10 f0       	push   $0xf010736f
f01024e3:	68 e5 03 00 00       	push   $0x3e5
f01024e8:	68 49 73 10 f0       	push   $0xf0107349
f01024ed:	e8 4e db ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01024f2:	68 f0 6d 10 f0       	push   $0xf0106df0
f01024f7:	68 6f 73 10 f0       	push   $0xf010736f
f01024fc:	68 e6 03 00 00       	push   $0x3e6
f0102501:	68 49 73 10 f0       	push   $0xf0107349
f0102506:	e8 35 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010250b:	68 9c 6e 10 f0       	push   $0xf0106e9c
f0102510:	68 6f 73 10 f0       	push   $0xf010736f
f0102515:	68 e9 03 00 00       	push   $0x3e9
f010251a:	68 49 73 10 f0       	push   $0xf0107349
f010251f:	e8 1c db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102524:	68 c8 6e 10 f0       	push   $0xf0106ec8
f0102529:	68 6f 73 10 f0       	push   $0xf010736f
f010252e:	68 ea 03 00 00       	push   $0x3ea
f0102533:	68 49 73 10 f0       	push   $0xf0107349
f0102538:	e8 03 db ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f010253d:	68 8f 75 10 f0       	push   $0xf010758f
f0102542:	68 6f 73 10 f0       	push   $0xf010736f
f0102547:	68 ec 03 00 00       	push   $0x3ec
f010254c:	68 49 73 10 f0       	push   $0xf0107349
f0102551:	e8 ea da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102556:	68 a0 75 10 f0       	push   $0xf01075a0
f010255b:	68 6f 73 10 f0       	push   $0xf010736f
f0102560:	68 ed 03 00 00       	push   $0x3ed
f0102565:	68 49 73 10 f0       	push   $0xf0107349
f010256a:	e8 d1 da ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f010256f:	68 f8 6e 10 f0       	push   $0xf0106ef8
f0102574:	68 6f 73 10 f0       	push   $0xf010736f
f0102579:	68 f0 03 00 00       	push   $0x3f0
f010257e:	68 49 73 10 f0       	push   $0xf0107349
f0102583:	e8 b8 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102588:	68 1c 6f 10 f0       	push   $0xf0106f1c
f010258d:	68 6f 73 10 f0       	push   $0xf010736f
f0102592:	68 f4 03 00 00       	push   $0x3f4
f0102597:	68 49 73 10 f0       	push   $0xf0107349
f010259c:	e8 9f da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01025a1:	68 c8 6e 10 f0       	push   $0xf0106ec8
f01025a6:	68 6f 73 10 f0       	push   $0xf010736f
f01025ab:	68 f5 03 00 00       	push   $0x3f5
f01025b0:	68 49 73 10 f0       	push   $0xf0107349
f01025b5:	e8 86 da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01025ba:	68 46 75 10 f0       	push   $0xf0107546
f01025bf:	68 6f 73 10 f0       	push   $0xf010736f
f01025c4:	68 f6 03 00 00       	push   $0x3f6
f01025c9:	68 49 73 10 f0       	push   $0xf0107349
f01025ce:	e8 6d da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01025d3:	68 a0 75 10 f0       	push   $0xf01075a0
f01025d8:	68 6f 73 10 f0       	push   $0xf010736f
f01025dd:	68 f7 03 00 00       	push   $0x3f7
f01025e2:	68 49 73 10 f0       	push   $0xf0107349
f01025e7:	e8 54 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01025ec:	68 40 6f 10 f0       	push   $0xf0106f40
f01025f1:	68 6f 73 10 f0       	push   $0xf010736f
f01025f6:	68 fa 03 00 00       	push   $0x3fa
f01025fb:	68 49 73 10 f0       	push   $0xf0107349
f0102600:	e8 3b da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f0102605:	68 b1 75 10 f0       	push   $0xf01075b1
f010260a:	68 6f 73 10 f0       	push   $0xf010736f
f010260f:	68 fb 03 00 00       	push   $0x3fb
f0102614:	68 49 73 10 f0       	push   $0xf0107349
f0102619:	e8 22 da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f010261e:	68 bd 75 10 f0       	push   $0xf01075bd
f0102623:	68 6f 73 10 f0       	push   $0xf010736f
f0102628:	68 fc 03 00 00       	push   $0x3fc
f010262d:	68 49 73 10 f0       	push   $0xf0107349
f0102632:	e8 09 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102637:	68 1c 6f 10 f0       	push   $0xf0106f1c
f010263c:	68 6f 73 10 f0       	push   $0xf010736f
f0102641:	68 00 04 00 00       	push   $0x400
f0102646:	68 49 73 10 f0       	push   $0xf0107349
f010264b:	e8 f0 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102650:	68 78 6f 10 f0       	push   $0xf0106f78
f0102655:	68 6f 73 10 f0       	push   $0xf010736f
f010265a:	68 01 04 00 00       	push   $0x401
f010265f:	68 49 73 10 f0       	push   $0xf0107349
f0102664:	e8 d7 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102669:	68 d2 75 10 f0       	push   $0xf01075d2
f010266e:	68 6f 73 10 f0       	push   $0xf010736f
f0102673:	68 02 04 00 00       	push   $0x402
f0102678:	68 49 73 10 f0       	push   $0xf0107349
f010267d:	e8 be d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102682:	68 a0 75 10 f0       	push   $0xf01075a0
f0102687:	68 6f 73 10 f0       	push   $0xf010736f
f010268c:	68 03 04 00 00       	push   $0x403
f0102691:	68 49 73 10 f0       	push   $0xf0107349
f0102696:	e8 a5 d9 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f010269b:	68 a0 6f 10 f0       	push   $0xf0106fa0
f01026a0:	68 6f 73 10 f0       	push   $0xf010736f
f01026a5:	68 06 04 00 00       	push   $0x406
f01026aa:	68 49 73 10 f0       	push   $0xf0107349
f01026af:	e8 8c d9 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01026b4:	68 f4 74 10 f0       	push   $0xf01074f4
f01026b9:	68 6f 73 10 f0       	push   $0xf010736f
f01026be:	68 09 04 00 00       	push   $0x409
f01026c3:	68 49 73 10 f0       	push   $0xf0107349
f01026c8:	e8 73 d9 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01026cd:	68 44 6c 10 f0       	push   $0xf0106c44
f01026d2:	68 6f 73 10 f0       	push   $0xf010736f
f01026d7:	68 0c 04 00 00       	push   $0x40c
f01026dc:	68 49 73 10 f0       	push   $0xf0107349
f01026e1:	e8 5a d9 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f01026e6:	68 57 75 10 f0       	push   $0xf0107557
f01026eb:	68 6f 73 10 f0       	push   $0xf010736f
f01026f0:	68 0e 04 00 00       	push   $0x40e
f01026f5:	68 49 73 10 f0       	push   $0xf0107349
f01026fa:	e8 41 d9 ff ff       	call   f0100040 <_panic>
f01026ff:	50                   	push   %eax
f0102700:	68 64 64 10 f0       	push   $0xf0106464
f0102705:	68 15 04 00 00       	push   $0x415
f010270a:	68 49 73 10 f0       	push   $0xf0107349
f010270f:	e8 2c d9 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102714:	68 e3 75 10 f0       	push   $0xf01075e3
f0102719:	68 6f 73 10 f0       	push   $0xf010736f
f010271e:	68 16 04 00 00       	push   $0x416
f0102723:	68 49 73 10 f0       	push   $0xf0107349
f0102728:	e8 13 d9 ff ff       	call   f0100040 <_panic>
f010272d:	50                   	push   %eax
f010272e:	68 64 64 10 f0       	push   $0xf0106464
f0102733:	6a 58                	push   $0x58
f0102735:	68 55 73 10 f0       	push   $0xf0107355
f010273a:	e8 01 d9 ff ff       	call   f0100040 <_panic>
f010273f:	52                   	push   %edx
f0102740:	68 64 64 10 f0       	push   $0xf0106464
f0102745:	6a 58                	push   $0x58
f0102747:	68 55 73 10 f0       	push   $0xf0107355
f010274c:	e8 ef d8 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102751:	68 fb 75 10 f0       	push   $0xf01075fb
f0102756:	68 6f 73 10 f0       	push   $0xf010736f
f010275b:	68 20 04 00 00       	push   $0x420
f0102760:	68 49 73 10 f0       	push   $0xf0107349
f0102765:	e8 d6 d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f010276a:	68 c4 6f 10 f0       	push   $0xf0106fc4
f010276f:	68 6f 73 10 f0       	push   $0xf010736f
f0102774:	68 30 04 00 00       	push   $0x430
f0102779:	68 49 73 10 f0       	push   $0xf0107349
f010277e:	e8 bd d8 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102783:	68 ec 6f 10 f0       	push   $0xf0106fec
f0102788:	68 6f 73 10 f0       	push   $0xf010736f
f010278d:	68 31 04 00 00       	push   $0x431
f0102792:	68 49 73 10 f0       	push   $0xf0107349
f0102797:	e8 a4 d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f010279c:	68 14 70 10 f0       	push   $0xf0107014
f01027a1:	68 6f 73 10 f0       	push   $0xf010736f
f01027a6:	68 33 04 00 00       	push   $0x433
f01027ab:	68 49 73 10 f0       	push   $0xf0107349
f01027b0:	e8 8b d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f01027b5:	68 12 76 10 f0       	push   $0xf0107612
f01027ba:	68 6f 73 10 f0       	push   $0xf010736f
f01027bf:	68 35 04 00 00       	push   $0x435
f01027c4:	68 49 73 10 f0       	push   $0xf0107349
f01027c9:	e8 72 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01027ce:	68 3c 70 10 f0       	push   $0xf010703c
f01027d3:	68 6f 73 10 f0       	push   $0xf010736f
f01027d8:	68 37 04 00 00       	push   $0x437
f01027dd:	68 49 73 10 f0       	push   $0xf0107349
f01027e2:	e8 59 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01027e7:	68 60 70 10 f0       	push   $0xf0107060
f01027ec:	68 6f 73 10 f0       	push   $0xf010736f
f01027f1:	68 38 04 00 00       	push   $0x438
f01027f6:	68 49 73 10 f0       	push   $0xf0107349
f01027fb:	e8 40 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102800:	68 90 70 10 f0       	push   $0xf0107090
f0102805:	68 6f 73 10 f0       	push   $0xf010736f
f010280a:	68 39 04 00 00       	push   $0x439
f010280f:	68 49 73 10 f0       	push   $0xf0107349
f0102814:	e8 27 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102819:	68 b4 70 10 f0       	push   $0xf01070b4
f010281e:	68 6f 73 10 f0       	push   $0xf010736f
f0102823:	68 3a 04 00 00       	push   $0x43a
f0102828:	68 49 73 10 f0       	push   $0xf0107349
f010282d:	e8 0e d8 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102832:	68 e0 70 10 f0       	push   $0xf01070e0
f0102837:	68 6f 73 10 f0       	push   $0xf010736f
f010283c:	68 3c 04 00 00       	push   $0x43c
f0102841:	68 49 73 10 f0       	push   $0xf0107349
f0102846:	e8 f5 d7 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f010284b:	68 24 71 10 f0       	push   $0xf0107124
f0102850:	68 6f 73 10 f0       	push   $0xf010736f
f0102855:	68 3d 04 00 00       	push   $0x43d
f010285a:	68 49 73 10 f0       	push   $0xf0107349
f010285f:	e8 dc d7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102864:	50                   	push   %eax
f0102865:	68 88 64 10 f0       	push   $0xf0106488
f010286a:	68 be 00 00 00       	push   $0xbe
f010286f:	68 49 73 10 f0       	push   $0xf0107349
f0102874:	e8 c7 d7 ff ff       	call   f0100040 <_panic>
f0102879:	50                   	push   %eax
f010287a:	68 88 64 10 f0       	push   $0xf0106488
f010287f:	68 c7 00 00 00       	push   $0xc7
f0102884:	68 49 73 10 f0       	push   $0xf0107349
f0102889:	e8 b2 d7 ff ff       	call   f0100040 <_panic>
f010288e:	50                   	push   %eax
f010288f:	68 88 64 10 f0       	push   $0xf0106488
f0102894:	68 d5 00 00 00       	push   $0xd5
f0102899:	68 49 73 10 f0       	push   $0xf0107349
f010289e:	e8 9d d7 ff ff       	call   f0100040 <_panic>
f01028a3:	53                   	push   %ebx
f01028a4:	68 88 64 10 f0       	push   $0xf0106488
f01028a9:	68 17 01 00 00       	push   $0x117
f01028ae:	68 49 73 10 f0       	push   $0xf0107349
f01028b3:	e8 88 d7 ff ff       	call   f0100040 <_panic>
f01028b8:	ff 75 c4             	pushl  -0x3c(%ebp)
f01028bb:	68 88 64 10 f0       	push   $0xf0106488
f01028c0:	68 55 03 00 00       	push   $0x355
f01028c5:	68 49 73 10 f0       	push   $0xf0107349
f01028ca:	e8 71 d7 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01028cf:	68 58 71 10 f0       	push   $0xf0107158
f01028d4:	68 6f 73 10 f0       	push   $0xf010736f
f01028d9:	68 55 03 00 00       	push   $0x355
f01028de:	68 49 73 10 f0       	push   $0xf0107349
f01028e3:	e8 58 d7 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01028e8:	a1 44 92 1e f0       	mov    0xf01e9244,%eax
f01028ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((uint32_t)kva < KERNBASE)
f01028f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01028f3:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f01028f8:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f01028fe:	89 da                	mov    %ebx,%edx
f0102900:	89 f8                	mov    %edi,%eax
f0102902:	e8 d5 e1 ff ff       	call   f0100adc <check_va2pa>
f0102907:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f010290e:	76 22                	jbe    f0102932 <mem_init+0x1660>
f0102910:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102913:	39 d0                	cmp    %edx,%eax
f0102915:	75 32                	jne    f0102949 <mem_init+0x1677>
f0102917:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f010291d:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0102923:	75 d9                	jne    f01028fe <mem_init+0x162c>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102925:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0102928:	c1 e6 0c             	shl    $0xc,%esi
f010292b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102930:	eb 4b                	jmp    f010297d <mem_init+0x16ab>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102932:	ff 75 d0             	pushl  -0x30(%ebp)
f0102935:	68 88 64 10 f0       	push   $0xf0106488
f010293a:	68 5a 03 00 00       	push   $0x35a
f010293f:	68 49 73 10 f0       	push   $0xf0107349
f0102944:	e8 f7 d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102949:	68 8c 71 10 f0       	push   $0xf010718c
f010294e:	68 6f 73 10 f0       	push   $0xf010736f
f0102953:	68 5a 03 00 00       	push   $0x35a
f0102958:	68 49 73 10 f0       	push   $0xf0107349
f010295d:	e8 de d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102962:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102968:	89 f8                	mov    %edi,%eax
f010296a:	e8 6d e1 ff ff       	call   f0100adc <check_va2pa>
f010296f:	39 c3                	cmp    %eax,%ebx
f0102971:	0f 85 f9 00 00 00    	jne    f0102a70 <mem_init+0x179e>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102977:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010297d:	39 f3                	cmp    %esi,%ebx
f010297f:	72 e1                	jb     f0102962 <mem_init+0x1690>
f0102981:	c7 45 d4 00 b0 1e f0 	movl   $0xf01eb000,-0x2c(%ebp)
f0102988:	be 00 80 ff ef       	mov    $0xefff8000,%esi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f010298d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102990:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102993:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102999:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010299c:	89 f3                	mov    %esi,%ebx
f010299e:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01029a1:	05 00 80 00 20       	add    $0x20008000,%eax
f01029a6:	89 75 c8             	mov    %esi,-0x38(%ebp)
f01029a9:	89 c6                	mov    %eax,%esi
f01029ab:	89 da                	mov    %ebx,%edx
f01029ad:	89 f8                	mov    %edi,%eax
f01029af:	e8 28 e1 ff ff       	call   f0100adc <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01029b4:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f01029bb:	0f 86 c8 00 00 00    	jbe    f0102a89 <mem_init+0x17b7>
f01029c1:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f01029c4:	39 d0                	cmp    %edx,%eax
f01029c6:	0f 85 d4 00 00 00    	jne    f0102aa0 <mem_init+0x17ce>
f01029cc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f01029d2:	3b 5d d0             	cmp    -0x30(%ebp),%ebx
f01029d5:	75 d4                	jne    f01029ab <mem_init+0x16d9>
f01029d7:	8b 75 c8             	mov    -0x38(%ebp),%esi
f01029da:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f01029e0:	89 da                	mov    %ebx,%edx
f01029e2:	89 f8                	mov    %edi,%eax
f01029e4:	e8 f3 e0 ff ff       	call   f0100adc <check_va2pa>
f01029e9:	83 f8 ff             	cmp    $0xffffffff,%eax
f01029ec:	0f 85 c7 00 00 00    	jne    f0102ab9 <mem_init+0x17e7>
f01029f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f01029f8:	39 f3                	cmp    %esi,%ebx
f01029fa:	75 e4                	jne    f01029e0 <mem_init+0x170e>
f01029fc:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102a02:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
f0102a09:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102a0c:	81 45 d4 00 80 00 00 	addl   $0x8000,-0x2c(%ebp)
	for (n = 0; n < NCPU; n++) {
f0102a13:	3d 00 b0 2a f0       	cmp    $0xf02ab000,%eax
f0102a18:	0f 85 6f ff ff ff    	jne    f010298d <mem_init+0x16bb>
	for (i = 0; i < NPDENTRIES; i++) {
f0102a1e:	b8 00 00 00 00       	mov    $0x0,%eax
			if (i >= PDX(KERNBASE)) {
f0102a23:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0102a28:	0f 87 a4 00 00 00    	ja     f0102ad2 <mem_init+0x1800>
				assert(pgdir[i] == 0);
f0102a2e:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0102a32:	0f 85 dd 00 00 00    	jne    f0102b15 <mem_init+0x1843>
	for (i = 0; i < NPDENTRIES; i++) {
f0102a38:	83 c0 01             	add    $0x1,%eax
f0102a3b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0102a40:	0f 87 e8 00 00 00    	ja     f0102b2e <mem_init+0x185c>
		switch (i) {
f0102a46:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0102a4c:	83 fa 04             	cmp    $0x4,%edx
f0102a4f:	77 d2                	ja     f0102a23 <mem_init+0x1751>
			assert(pgdir[i] & PTE_P);
f0102a51:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0102a55:	75 e1                	jne    f0102a38 <mem_init+0x1766>
f0102a57:	68 3d 76 10 f0       	push   $0xf010763d
f0102a5c:	68 6f 73 10 f0       	push   $0xf010736f
f0102a61:	68 73 03 00 00       	push   $0x373
f0102a66:	68 49 73 10 f0       	push   $0xf0107349
f0102a6b:	e8 d0 d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a70:	68 c0 71 10 f0       	push   $0xf01071c0
f0102a75:	68 6f 73 10 f0       	push   $0xf010736f
f0102a7a:	68 5e 03 00 00       	push   $0x35e
f0102a7f:	68 49 73 10 f0       	push   $0xf0107349
f0102a84:	e8 b7 d5 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102a89:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102a8c:	68 88 64 10 f0       	push   $0xf0106488
f0102a91:	68 66 03 00 00       	push   $0x366
f0102a96:	68 49 73 10 f0       	push   $0xf0107349
f0102a9b:	e8 a0 d5 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102aa0:	68 e8 71 10 f0       	push   $0xf01071e8
f0102aa5:	68 6f 73 10 f0       	push   $0xf010736f
f0102aaa:	68 66 03 00 00       	push   $0x366
f0102aaf:	68 49 73 10 f0       	push   $0xf0107349
f0102ab4:	e8 87 d5 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102ab9:	68 30 72 10 f0       	push   $0xf0107230
f0102abe:	68 6f 73 10 f0       	push   $0xf010736f
f0102ac3:	68 68 03 00 00       	push   $0x368
f0102ac8:	68 49 73 10 f0       	push   $0xf0107349
f0102acd:	e8 6e d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102ad2:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0102ad5:	f6 c2 01             	test   $0x1,%dl
f0102ad8:	74 22                	je     f0102afc <mem_init+0x182a>
				assert(pgdir[i] & PTE_W);
f0102ada:	f6 c2 02             	test   $0x2,%dl
f0102add:	0f 85 55 ff ff ff    	jne    f0102a38 <mem_init+0x1766>
f0102ae3:	68 4e 76 10 f0       	push   $0xf010764e
f0102ae8:	68 6f 73 10 f0       	push   $0xf010736f
f0102aed:	68 78 03 00 00       	push   $0x378
f0102af2:	68 49 73 10 f0       	push   $0xf0107349
f0102af7:	e8 44 d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102afc:	68 3d 76 10 f0       	push   $0xf010763d
f0102b01:	68 6f 73 10 f0       	push   $0xf010736f
f0102b06:	68 77 03 00 00       	push   $0x377
f0102b0b:	68 49 73 10 f0       	push   $0xf0107349
f0102b10:	e8 2b d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102b15:	68 5f 76 10 f0       	push   $0xf010765f
f0102b1a:	68 6f 73 10 f0       	push   $0xf010736f
f0102b1f:	68 7a 03 00 00       	push   $0x37a
f0102b24:	68 49 73 10 f0       	push   $0xf0107349
f0102b29:	e8 12 d5 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102b2e:	83 ec 0c             	sub    $0xc,%esp
f0102b31:	68 54 72 10 f0       	push   $0xf0107254
f0102b36:	e8 58 0d 00 00       	call   f0103893 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102b3b:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0102b40:	83 c4 10             	add    $0x10,%esp
f0102b43:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102b48:	0f 86 fe 01 00 00    	jbe    f0102d4c <mem_init+0x1a7a>
	return (physaddr_t)kva - KERNBASE;
f0102b4e:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102b53:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102b56:	b8 00 00 00 00       	mov    $0x0,%eax
f0102b5b:	e8 e0 df ff ff       	call   f0100b40 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102b60:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102b63:	83 e0 f3             	and    $0xfffffff3,%eax
f0102b66:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102b6b:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102b6e:	83 ec 0c             	sub    $0xc,%esp
f0102b71:	6a 00                	push   $0x0
f0102b73:	e8 a8 e3 ff ff       	call   f0100f20 <page_alloc>
f0102b78:	89 c3                	mov    %eax,%ebx
f0102b7a:	83 c4 10             	add    $0x10,%esp
f0102b7d:	85 c0                	test   %eax,%eax
f0102b7f:	0f 84 dc 01 00 00    	je     f0102d61 <mem_init+0x1a8f>
	assert((pp1 = page_alloc(0)));
f0102b85:	83 ec 0c             	sub    $0xc,%esp
f0102b88:	6a 00                	push   $0x0
f0102b8a:	e8 91 e3 ff ff       	call   f0100f20 <page_alloc>
f0102b8f:	89 c7                	mov    %eax,%edi
f0102b91:	83 c4 10             	add    $0x10,%esp
f0102b94:	85 c0                	test   %eax,%eax
f0102b96:	0f 84 de 01 00 00    	je     f0102d7a <mem_init+0x1aa8>
	assert((pp2 = page_alloc(0)));
f0102b9c:	83 ec 0c             	sub    $0xc,%esp
f0102b9f:	6a 00                	push   $0x0
f0102ba1:	e8 7a e3 ff ff       	call   f0100f20 <page_alloc>
f0102ba6:	89 c6                	mov    %eax,%esi
f0102ba8:	83 c4 10             	add    $0x10,%esp
f0102bab:	85 c0                	test   %eax,%eax
f0102bad:	0f 84 e0 01 00 00    	je     f0102d93 <mem_init+0x1ac1>
	page_free(pp0);
f0102bb3:	83 ec 0c             	sub    $0xc,%esp
f0102bb6:	53                   	push   %ebx
f0102bb7:	e8 d6 e3 ff ff       	call   f0100f92 <page_free>
	return (pp - pages) << PGSHIFT;
f0102bbc:	89 f8                	mov    %edi,%eax
f0102bbe:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0102bc4:	c1 f8 03             	sar    $0x3,%eax
f0102bc7:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102bca:	89 c2                	mov    %eax,%edx
f0102bcc:	c1 ea 0c             	shr    $0xc,%edx
f0102bcf:	83 c4 10             	add    $0x10,%esp
f0102bd2:	3b 15 88 9e 1e f0    	cmp    0xf01e9e88,%edx
f0102bd8:	0f 83 ce 01 00 00    	jae    f0102dac <mem_init+0x1ada>
	memset(page2kva(pp1), 1, PGSIZE);
f0102bde:	83 ec 04             	sub    $0x4,%esp
f0102be1:	68 00 10 00 00       	push   $0x1000
f0102be6:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102be8:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102bed:	50                   	push   %eax
f0102bee:	e8 df 2b 00 00       	call   f01057d2 <memset>
	return (pp - pages) << PGSHIFT;
f0102bf3:	89 f0                	mov    %esi,%eax
f0102bf5:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0102bfb:	c1 f8 03             	sar    $0x3,%eax
f0102bfe:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102c01:	89 c2                	mov    %eax,%edx
f0102c03:	c1 ea 0c             	shr    $0xc,%edx
f0102c06:	83 c4 10             	add    $0x10,%esp
f0102c09:	3b 15 88 9e 1e f0    	cmp    0xf01e9e88,%edx
f0102c0f:	0f 83 a9 01 00 00    	jae    f0102dbe <mem_init+0x1aec>
	memset(page2kva(pp2), 2, PGSIZE);
f0102c15:	83 ec 04             	sub    $0x4,%esp
f0102c18:	68 00 10 00 00       	push   $0x1000
f0102c1d:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102c1f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102c24:	50                   	push   %eax
f0102c25:	e8 a8 2b 00 00       	call   f01057d2 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102c2a:	6a 02                	push   $0x2
f0102c2c:	68 00 10 00 00       	push   $0x1000
f0102c31:	57                   	push   %edi
f0102c32:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0102c38:	e8 b4 e5 ff ff       	call   f01011f1 <page_insert>
	assert(pp1->pp_ref == 1);
f0102c3d:	83 c4 20             	add    $0x20,%esp
f0102c40:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102c45:	0f 85 85 01 00 00    	jne    f0102dd0 <mem_init+0x1afe>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102c4b:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102c52:	01 01 01 
f0102c55:	0f 85 8e 01 00 00    	jne    f0102de9 <mem_init+0x1b17>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102c5b:	6a 02                	push   $0x2
f0102c5d:	68 00 10 00 00       	push   $0x1000
f0102c62:	56                   	push   %esi
f0102c63:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0102c69:	e8 83 e5 ff ff       	call   f01011f1 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102c6e:	83 c4 10             	add    $0x10,%esp
f0102c71:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102c78:	02 02 02 
f0102c7b:	0f 85 81 01 00 00    	jne    f0102e02 <mem_init+0x1b30>
	assert(pp2->pp_ref == 1);
f0102c81:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102c86:	0f 85 8f 01 00 00    	jne    f0102e1b <mem_init+0x1b49>
	assert(pp1->pp_ref == 0);
f0102c8c:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102c91:	0f 85 9d 01 00 00    	jne    f0102e34 <mem_init+0x1b62>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102c97:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102c9e:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102ca1:	89 f0                	mov    %esi,%eax
f0102ca3:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0102ca9:	c1 f8 03             	sar    $0x3,%eax
f0102cac:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102caf:	89 c2                	mov    %eax,%edx
f0102cb1:	c1 ea 0c             	shr    $0xc,%edx
f0102cb4:	3b 15 88 9e 1e f0    	cmp    0xf01e9e88,%edx
f0102cba:	0f 83 8d 01 00 00    	jae    f0102e4d <mem_init+0x1b7b>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102cc0:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0102cc7:	03 03 03 
f0102cca:	0f 85 8f 01 00 00    	jne    f0102e5f <mem_init+0x1b8d>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102cd0:	83 ec 08             	sub    $0x8,%esp
f0102cd3:	68 00 10 00 00       	push   $0x1000
f0102cd8:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0102cde:	e8 c6 e4 ff ff       	call   f01011a9 <page_remove>
	assert(pp2->pp_ref == 0);
f0102ce3:	83 c4 10             	add    $0x10,%esp
f0102ce6:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102ceb:	0f 85 87 01 00 00    	jne    f0102e78 <mem_init+0x1ba6>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102cf1:	8b 0d 8c 9e 1e f0    	mov    0xf01e9e8c,%ecx
f0102cf7:	8b 11                	mov    (%ecx),%edx
f0102cf9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102cff:	89 d8                	mov    %ebx,%eax
f0102d01:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0102d07:	c1 f8 03             	sar    $0x3,%eax
f0102d0a:	c1 e0 0c             	shl    $0xc,%eax
f0102d0d:	39 c2                	cmp    %eax,%edx
f0102d0f:	0f 85 7c 01 00 00    	jne    f0102e91 <mem_init+0x1bbf>
	kern_pgdir[0] = 0;
f0102d15:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102d1b:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102d20:	0f 85 84 01 00 00    	jne    f0102eaa <mem_init+0x1bd8>
	pp0->pp_ref = 0;
f0102d26:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);
f0102d2c:	83 ec 0c             	sub    $0xc,%esp
f0102d2f:	53                   	push   %ebx
f0102d30:	e8 5d e2 ff ff       	call   f0100f92 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102d35:	c7 04 24 e8 72 10 f0 	movl   $0xf01072e8,(%esp)
f0102d3c:	e8 52 0b 00 00       	call   f0103893 <cprintf>
}
f0102d41:	83 c4 10             	add    $0x10,%esp
f0102d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102d47:	5b                   	pop    %ebx
f0102d48:	5e                   	pop    %esi
f0102d49:	5f                   	pop    %edi
f0102d4a:	5d                   	pop    %ebp
f0102d4b:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102d4c:	50                   	push   %eax
f0102d4d:	68 88 64 10 f0       	push   $0xf0106488
f0102d52:	68 ee 00 00 00       	push   $0xee
f0102d57:	68 49 73 10 f0       	push   $0xf0107349
f0102d5c:	e8 df d2 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102d61:	68 49 74 10 f0       	push   $0xf0107449
f0102d66:	68 6f 73 10 f0       	push   $0xf010736f
f0102d6b:	68 52 04 00 00       	push   $0x452
f0102d70:	68 49 73 10 f0       	push   $0xf0107349
f0102d75:	e8 c6 d2 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102d7a:	68 5f 74 10 f0       	push   $0xf010745f
f0102d7f:	68 6f 73 10 f0       	push   $0xf010736f
f0102d84:	68 53 04 00 00       	push   $0x453
f0102d89:	68 49 73 10 f0       	push   $0xf0107349
f0102d8e:	e8 ad d2 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102d93:	68 75 74 10 f0       	push   $0xf0107475
f0102d98:	68 6f 73 10 f0       	push   $0xf010736f
f0102d9d:	68 54 04 00 00       	push   $0x454
f0102da2:	68 49 73 10 f0       	push   $0xf0107349
f0102da7:	e8 94 d2 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102dac:	50                   	push   %eax
f0102dad:	68 64 64 10 f0       	push   $0xf0106464
f0102db2:	6a 58                	push   $0x58
f0102db4:	68 55 73 10 f0       	push   $0xf0107355
f0102db9:	e8 82 d2 ff ff       	call   f0100040 <_panic>
f0102dbe:	50                   	push   %eax
f0102dbf:	68 64 64 10 f0       	push   $0xf0106464
f0102dc4:	6a 58                	push   $0x58
f0102dc6:	68 55 73 10 f0       	push   $0xf0107355
f0102dcb:	e8 70 d2 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102dd0:	68 46 75 10 f0       	push   $0xf0107546
f0102dd5:	68 6f 73 10 f0       	push   $0xf010736f
f0102dda:	68 59 04 00 00       	push   $0x459
f0102ddf:	68 49 73 10 f0       	push   $0xf0107349
f0102de4:	e8 57 d2 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102de9:	68 74 72 10 f0       	push   $0xf0107274
f0102dee:	68 6f 73 10 f0       	push   $0xf010736f
f0102df3:	68 5a 04 00 00       	push   $0x45a
f0102df8:	68 49 73 10 f0       	push   $0xf0107349
f0102dfd:	e8 3e d2 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102e02:	68 98 72 10 f0       	push   $0xf0107298
f0102e07:	68 6f 73 10 f0       	push   $0xf010736f
f0102e0c:	68 5c 04 00 00       	push   $0x45c
f0102e11:	68 49 73 10 f0       	push   $0xf0107349
f0102e16:	e8 25 d2 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102e1b:	68 68 75 10 f0       	push   $0xf0107568
f0102e20:	68 6f 73 10 f0       	push   $0xf010736f
f0102e25:	68 5d 04 00 00       	push   $0x45d
f0102e2a:	68 49 73 10 f0       	push   $0xf0107349
f0102e2f:	e8 0c d2 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102e34:	68 d2 75 10 f0       	push   $0xf01075d2
f0102e39:	68 6f 73 10 f0       	push   $0xf010736f
f0102e3e:	68 5e 04 00 00       	push   $0x45e
f0102e43:	68 49 73 10 f0       	push   $0xf0107349
f0102e48:	e8 f3 d1 ff ff       	call   f0100040 <_panic>
f0102e4d:	50                   	push   %eax
f0102e4e:	68 64 64 10 f0       	push   $0xf0106464
f0102e53:	6a 58                	push   $0x58
f0102e55:	68 55 73 10 f0       	push   $0xf0107355
f0102e5a:	e8 e1 d1 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102e5f:	68 bc 72 10 f0       	push   $0xf01072bc
f0102e64:	68 6f 73 10 f0       	push   $0xf010736f
f0102e69:	68 60 04 00 00       	push   $0x460
f0102e6e:	68 49 73 10 f0       	push   $0xf0107349
f0102e73:	e8 c8 d1 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102e78:	68 a0 75 10 f0       	push   $0xf01075a0
f0102e7d:	68 6f 73 10 f0       	push   $0xf010736f
f0102e82:	68 62 04 00 00       	push   $0x462
f0102e87:	68 49 73 10 f0       	push   $0xf0107349
f0102e8c:	e8 af d1 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102e91:	68 44 6c 10 f0       	push   $0xf0106c44
f0102e96:	68 6f 73 10 f0       	push   $0xf010736f
f0102e9b:	68 65 04 00 00       	push   $0x465
f0102ea0:	68 49 73 10 f0       	push   $0xf0107349
f0102ea5:	e8 96 d1 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102eaa:	68 57 75 10 f0       	push   $0xf0107557
f0102eaf:	68 6f 73 10 f0       	push   $0xf010736f
f0102eb4:	68 67 04 00 00       	push   $0x467
f0102eb9:	68 49 73 10 f0       	push   $0xf0107349
f0102ebe:	e8 7d d1 ff ff       	call   f0100040 <_panic>

f0102ec3 <user_mem_check>:
{
f0102ec3:	55                   	push   %ebp
f0102ec4:	89 e5                	mov    %esp,%ebp
f0102ec6:	57                   	push   %edi
f0102ec7:	56                   	push   %esi
f0102ec8:	53                   	push   %ebx
f0102ec9:	83 ec 0c             	sub    $0xc,%esp
f0102ecc:	8b 75 14             	mov    0x14(%ebp),%esi
	uint32_t begin = (uint32_t) ROUNDDOWN(va, PGSIZE); 
f0102ecf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102ed2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t end = (uint32_t) ROUNDUP(va+len, PGSIZE);
f0102ed8:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0102edb:	03 7d 10             	add    0x10(%ebp),%edi
f0102ede:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
f0102ee4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	for (i = (uint32_t)begin; i < end; i+=PGSIZE) {
f0102eea:	39 fb                	cmp    %edi,%ebx
f0102eec:	73 4e                	jae    f0102f3c <user_mem_check+0x79>
		pte_t *pte = pgdir_walk(env->env_pgdir, (void*)i, 0);
f0102eee:	83 ec 04             	sub    $0x4,%esp
f0102ef1:	6a 00                	push   $0x0
f0102ef3:	53                   	push   %ebx
f0102ef4:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ef7:	ff 70 60             	pushl  0x60(%eax)
f0102efa:	e8 f7 e0 ff ff       	call   f0100ff6 <pgdir_walk>
		if ((i >= ULIM) || !pte || !(*pte & PTE_P) || ((*pte & perm) != perm)) {
f0102eff:	83 c4 10             	add    $0x10,%esp
f0102f02:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102f08:	77 18                	ja     f0102f22 <user_mem_check+0x5f>
f0102f0a:	85 c0                	test   %eax,%eax
f0102f0c:	74 14                	je     f0102f22 <user_mem_check+0x5f>
f0102f0e:	8b 00                	mov    (%eax),%eax
f0102f10:	a8 01                	test   $0x1,%al
f0102f12:	74 0e                	je     f0102f22 <user_mem_check+0x5f>
f0102f14:	21 f0                	and    %esi,%eax
f0102f16:	39 c6                	cmp    %eax,%esi
f0102f18:	75 08                	jne    f0102f22 <user_mem_check+0x5f>
	for (i = (uint32_t)begin; i < end; i+=PGSIZE) {
f0102f1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102f20:	eb c8                	jmp    f0102eea <user_mem_check+0x27>
			user_mem_check_addr = (i < (uint32_t)va ? (uint32_t)va : i);
f0102f22:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f0102f25:	0f 42 5d 0c          	cmovb  0xc(%ebp),%ebx
f0102f29:	89 1d 3c 92 1e f0    	mov    %ebx,0xf01e923c
			return -E_FAULT;
f0102f2f:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0102f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102f37:	5b                   	pop    %ebx
f0102f38:	5e                   	pop    %esi
f0102f39:	5f                   	pop    %edi
f0102f3a:	5d                   	pop    %ebp
f0102f3b:	c3                   	ret    
	return 0;
f0102f3c:	b8 00 00 00 00       	mov    $0x0,%eax
f0102f41:	eb f1                	jmp    f0102f34 <user_mem_check+0x71>

f0102f43 <user_mem_assert>:
{
f0102f43:	55                   	push   %ebp
f0102f44:	89 e5                	mov    %esp,%ebp
f0102f46:	53                   	push   %ebx
f0102f47:	83 ec 04             	sub    $0x4,%esp
f0102f4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0102f4d:	8b 45 14             	mov    0x14(%ebp),%eax
f0102f50:	83 c8 04             	or     $0x4,%eax
f0102f53:	50                   	push   %eax
f0102f54:	ff 75 10             	pushl  0x10(%ebp)
f0102f57:	ff 75 0c             	pushl  0xc(%ebp)
f0102f5a:	53                   	push   %ebx
f0102f5b:	e8 63 ff ff ff       	call   f0102ec3 <user_mem_check>
f0102f60:	83 c4 10             	add    $0x10,%esp
f0102f63:	85 c0                	test   %eax,%eax
f0102f65:	78 05                	js     f0102f6c <user_mem_assert+0x29>
}
f0102f67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102f6a:	c9                   	leave  
f0102f6b:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0102f6c:	83 ec 04             	sub    $0x4,%esp
f0102f6f:	ff 35 3c 92 1e f0    	pushl  0xf01e923c
f0102f75:	ff 73 48             	pushl  0x48(%ebx)
f0102f78:	68 14 73 10 f0       	push   $0xf0107314
f0102f7d:	e8 11 09 00 00       	call   f0103893 <cprintf>
		env_destroy(env);	// may not return
f0102f82:	89 1c 24             	mov    %ebx,(%esp)
f0102f85:	e8 44 06 00 00       	call   f01035ce <env_destroy>
f0102f8a:	83 c4 10             	add    $0x10,%esp
}
f0102f8d:	eb d8                	jmp    f0102f67 <user_mem_assert+0x24>

f0102f8f <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0102f8f:	55                   	push   %ebp
f0102f90:	89 e5                	mov    %esp,%ebp
f0102f92:	57                   	push   %edi
f0102f93:	56                   	push   %esi
f0102f94:	53                   	push   %ebx
f0102f95:	83 ec 0c             	sub    $0xc,%esp
f0102f98:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	void *begin = ROUNDDOWN(va, PGSIZE), *end = ROUNDUP(va+len, PGSIZE);
f0102f9a:	89 d3                	mov    %edx,%ebx
f0102f9c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0102fa2:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f0102fa9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	while (begin < end) {
f0102faf:	39 f3                	cmp    %esi,%ebx
f0102fb1:	73 3f                	jae    f0102ff2 <region_alloc+0x63>
		struct PageInfo *pg = page_alloc(0);
f0102fb3:	83 ec 0c             	sub    $0xc,%esp
f0102fb6:	6a 00                	push   $0x0
f0102fb8:	e8 63 df ff ff       	call   f0100f20 <page_alloc>
		if (!pg) {
f0102fbd:	83 c4 10             	add    $0x10,%esp
f0102fc0:	85 c0                	test   %eax,%eax
f0102fc2:	74 17                	je     f0102fdb <region_alloc+0x4c>
			panic("region_alloc failed\n");
		}
		page_insert(e->env_pgdir, pg, begin, PTE_W | PTE_U);
f0102fc4:	6a 06                	push   $0x6
f0102fc6:	53                   	push   %ebx
f0102fc7:	50                   	push   %eax
f0102fc8:	ff 77 60             	pushl  0x60(%edi)
f0102fcb:	e8 21 e2 ff ff       	call   f01011f1 <page_insert>
		begin += PGSIZE;
f0102fd0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102fd6:	83 c4 10             	add    $0x10,%esp
f0102fd9:	eb d4                	jmp    f0102faf <region_alloc+0x20>
			panic("region_alloc failed\n");
f0102fdb:	83 ec 04             	sub    $0x4,%esp
f0102fde:	68 6d 76 10 f0       	push   $0xf010766d
f0102fe3:	68 27 01 00 00       	push   $0x127
f0102fe8:	68 82 76 10 f0       	push   $0xf0107682
f0102fed:	e8 4e d0 ff ff       	call   f0100040 <_panic>
	}
}
f0102ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102ff5:	5b                   	pop    %ebx
f0102ff6:	5e                   	pop    %esi
f0102ff7:	5f                   	pop    %edi
f0102ff8:	5d                   	pop    %ebp
f0102ff9:	c3                   	ret    

f0102ffa <envid2env>:
{
f0102ffa:	55                   	push   %ebp
f0102ffb:	89 e5                	mov    %esp,%ebp
f0102ffd:	56                   	push   %esi
f0102ffe:	53                   	push   %ebx
f0102fff:	8b 45 08             	mov    0x8(%ebp),%eax
f0103002:	8b 55 10             	mov    0x10(%ebp),%edx
	if (envid == 0) {
f0103005:	85 c0                	test   %eax,%eax
f0103007:	74 2e                	je     f0103037 <envid2env+0x3d>
	e = &envs[ENVX(envid)];
f0103009:	89 c3                	mov    %eax,%ebx
f010300b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103011:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103014:	03 1d 44 92 1e f0    	add    0xf01e9244,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010301a:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f010301e:	74 31                	je     f0103051 <envid2env+0x57>
f0103020:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103023:	75 2c                	jne    f0103051 <envid2env+0x57>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103025:	84 d2                	test   %dl,%dl
f0103027:	75 38                	jne    f0103061 <envid2env+0x67>
	*env_store = e;
f0103029:	8b 45 0c             	mov    0xc(%ebp),%eax
f010302c:	89 18                	mov    %ebx,(%eax)
	return 0;
f010302e:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103033:	5b                   	pop    %ebx
f0103034:	5e                   	pop    %esi
f0103035:	5d                   	pop    %ebp
f0103036:	c3                   	ret    
		*env_store = curenv;
f0103037:	e8 bb 2d 00 00       	call   f0105df7 <cpunum>
f010303c:	6b c0 74             	imul   $0x74,%eax,%eax
f010303f:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0103045:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103048:	89 01                	mov    %eax,(%ecx)
		return 0;
f010304a:	b8 00 00 00 00       	mov    $0x0,%eax
f010304f:	eb e2                	jmp    f0103033 <envid2env+0x39>
		*env_store = 0;
f0103051:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103054:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f010305a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010305f:	eb d2                	jmp    f0103033 <envid2env+0x39>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103061:	e8 91 2d 00 00       	call   f0105df7 <cpunum>
f0103066:	6b c0 74             	imul   $0x74,%eax,%eax
f0103069:	39 98 28 a0 1e f0    	cmp    %ebx,-0xfe15fd8(%eax)
f010306f:	74 b8                	je     f0103029 <envid2env+0x2f>
f0103071:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103074:	e8 7e 2d 00 00       	call   f0105df7 <cpunum>
f0103079:	6b c0 74             	imul   $0x74,%eax,%eax
f010307c:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0103082:	3b 70 48             	cmp    0x48(%eax),%esi
f0103085:	74 a2                	je     f0103029 <envid2env+0x2f>
		*env_store = 0;
f0103087:	8b 45 0c             	mov    0xc(%ebp),%eax
f010308a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103090:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103095:	eb 9c                	jmp    f0103033 <envid2env+0x39>

f0103097 <env_init_percpu>:
{
f0103097:	55                   	push   %ebp
f0103098:	89 e5                	mov    %esp,%ebp
	asm volatile("lgdt (%0)" : : "r" (p));
f010309a:	b8 20 23 12 f0       	mov    $0xf0122320,%eax
f010309f:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f01030a2:	b8 23 00 00 00       	mov    $0x23,%eax
f01030a7:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f01030a9:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01030ab:	b8 10 00 00 00       	mov    $0x10,%eax
f01030b0:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01030b2:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01030b4:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01030b6:	ea bd 30 10 f0 08 00 	ljmp   $0x8,$0xf01030bd
	asm volatile("lldt %0" : : "r" (sel));
f01030bd:	b8 00 00 00 00       	mov    $0x0,%eax
f01030c2:	0f 00 d0             	lldt   %ax
}
f01030c5:	5d                   	pop    %ebp
f01030c6:	c3                   	ret    

f01030c7 <env_init>:
{
f01030c7:	55                   	push   %ebp
f01030c8:	89 e5                	mov    %esp,%ebp
f01030ca:	56                   	push   %esi
f01030cb:	53                   	push   %ebx
		envs[i].env_id = 0;
f01030cc:	8b 35 44 92 1e f0    	mov    0xf01e9244,%esi
f01030d2:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f01030d8:	8d 5e 84             	lea    -0x7c(%esi),%ebx
f01030db:	ba 00 00 00 00       	mov    $0x0,%edx
f01030e0:	89 c1                	mov    %eax,%ecx
f01030e2:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_link = env_free_list;
f01030e9:	89 50 44             	mov    %edx,0x44(%eax)
f01030ec:	83 e8 7c             	sub    $0x7c,%eax
		env_free_list = &envs[i];
f01030ef:	89 ca                	mov    %ecx,%edx
	for (int i = NENV - 1; i >= 0; i--) {		//前插法构建链表
f01030f1:	39 d8                	cmp    %ebx,%eax
f01030f3:	75 eb                	jne    f01030e0 <env_init+0x19>
f01030f5:	89 35 48 92 1e f0    	mov    %esi,0xf01e9248
	env_init_percpu();
f01030fb:	e8 97 ff ff ff       	call   f0103097 <env_init_percpu>
}
f0103100:	5b                   	pop    %ebx
f0103101:	5e                   	pop    %esi
f0103102:	5d                   	pop    %ebp
f0103103:	c3                   	ret    

f0103104 <env_alloc>:
{
f0103104:	55                   	push   %ebp
f0103105:	89 e5                	mov    %esp,%ebp
f0103107:	53                   	push   %ebx
f0103108:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f010310b:	8b 1d 48 92 1e f0    	mov    0xf01e9248,%ebx
f0103111:	85 db                	test   %ebx,%ebx
f0103113:	0f 84 74 01 00 00    	je     f010328d <env_alloc+0x189>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103119:	83 ec 0c             	sub    $0xc,%esp
f010311c:	6a 01                	push   $0x1
f010311e:	e8 fd dd ff ff       	call   f0100f20 <page_alloc>
f0103123:	83 c4 10             	add    $0x10,%esp
f0103126:	85 c0                	test   %eax,%eax
f0103128:	0f 84 66 01 00 00    	je     f0103294 <env_alloc+0x190>
	p->pp_ref++;
f010312e:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0103133:	2b 05 90 9e 1e f0    	sub    0xf01e9e90,%eax
f0103139:	c1 f8 03             	sar    $0x3,%eax
f010313c:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010313f:	89 c2                	mov    %eax,%edx
f0103141:	c1 ea 0c             	shr    $0xc,%edx
f0103144:	3b 15 88 9e 1e f0    	cmp    0xf01e9e88,%edx
f010314a:	0f 83 16 01 00 00    	jae    f0103266 <env_alloc+0x162>
	return (void *)(pa + KERNBASE);
f0103150:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_pgdir = (pde_t *) page2kva(p);
f0103155:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f0103158:	83 ec 04             	sub    $0x4,%esp
f010315b:	68 00 10 00 00       	push   $0x1000
f0103160:	ff 35 8c 9e 1e f0    	pushl  0xf01e9e8c
f0103166:	50                   	push   %eax
f0103167:	e8 1b 27 00 00       	call   f0105887 <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f010316c:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010316f:	83 c4 10             	add    $0x10,%esp
f0103172:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103177:	0f 86 fb 00 00 00    	jbe    f0103278 <env_alloc+0x174>
	return (physaddr_t)kva - KERNBASE;
f010317d:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103183:	83 ca 05             	or     $0x5,%edx
f0103186:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f010318c:	8b 43 48             	mov    0x48(%ebx),%eax
f010318f:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103194:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103199:	ba 00 10 00 00       	mov    $0x1000,%edx
f010319e:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01031a1:	89 da                	mov    %ebx,%edx
f01031a3:	2b 15 44 92 1e f0    	sub    0xf01e9244,%edx
f01031a9:	c1 fa 02             	sar    $0x2,%edx
f01031ac:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01031b2:	09 d0                	or     %edx,%eax
f01031b4:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f01031b7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031ba:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01031bd:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01031c4:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01031cb:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01031d2:	83 ec 04             	sub    $0x4,%esp
f01031d5:	6a 44                	push   $0x44
f01031d7:	6a 00                	push   $0x0
f01031d9:	53                   	push   %ebx
f01031da:	e8 f3 25 00 00       	call   f01057d2 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f01031df:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01031e5:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01031eb:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f01031f1:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f01031f8:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f01031fe:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103205:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f010320c:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f0103210:	8b 43 44             	mov    0x44(%ebx),%eax
f0103213:	a3 48 92 1e f0       	mov    %eax,0xf01e9248
	*newenv_store = e;
f0103218:	8b 45 08             	mov    0x8(%ebp),%eax
f010321b:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010321d:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103220:	e8 d2 2b 00 00       	call   f0105df7 <cpunum>
f0103225:	6b c0 74             	imul   $0x74,%eax,%eax
f0103228:	83 c4 10             	add    $0x10,%esp
f010322b:	ba 00 00 00 00       	mov    $0x0,%edx
f0103230:	83 b8 28 a0 1e f0 00 	cmpl   $0x0,-0xfe15fd8(%eax)
f0103237:	74 11                	je     f010324a <env_alloc+0x146>
f0103239:	e8 b9 2b 00 00       	call   f0105df7 <cpunum>
f010323e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103241:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0103247:	8b 50 48             	mov    0x48(%eax),%edx
f010324a:	83 ec 04             	sub    $0x4,%esp
f010324d:	53                   	push   %ebx
f010324e:	52                   	push   %edx
f010324f:	68 8d 76 10 f0       	push   $0xf010768d
f0103254:	e8 3a 06 00 00       	call   f0103893 <cprintf>
	return 0;
f0103259:	83 c4 10             	add    $0x10,%esp
f010325c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103261:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103264:	c9                   	leave  
f0103265:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103266:	50                   	push   %eax
f0103267:	68 64 64 10 f0       	push   $0xf0106464
f010326c:	6a 58                	push   $0x58
f010326e:	68 55 73 10 f0       	push   $0xf0107355
f0103273:	e8 c8 cd ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103278:	50                   	push   %eax
f0103279:	68 88 64 10 f0       	push   $0xf0106488
f010327e:	68 c5 00 00 00       	push   $0xc5
f0103283:	68 82 76 10 f0       	push   $0xf0107682
f0103288:	e8 b3 cd ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f010328d:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103292:	eb cd                	jmp    f0103261 <env_alloc+0x15d>
		return -E_NO_MEM;
f0103294:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103299:	eb c6                	jmp    f0103261 <env_alloc+0x15d>

f010329b <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f010329b:	55                   	push   %ebp
f010329c:	89 e5                	mov    %esp,%ebp
f010329e:	57                   	push   %edi
f010329f:	56                   	push   %esi
f01032a0:	53                   	push   %ebx
f01032a1:	83 ec 34             	sub    $0x34,%esp
	// LAB 3: Your code here.
	struct Env *e;
	int r;
	if ((r = env_alloc(&e, 0) != 0)) {
f01032a4:	6a 00                	push   $0x0
f01032a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01032a9:	50                   	push   %eax
f01032aa:	e8 55 fe ff ff       	call   f0103104 <env_alloc>
f01032af:	83 c4 10             	add    $0x10,%esp
f01032b2:	85 c0                	test   %eax,%eax
f01032b4:	75 3d                	jne    f01032f3 <env_create+0x58>
f01032b6:	89 c6                	mov    %eax,%esi
		panic("create env failed\n");
	}

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	if (type == ENV_TYPE_FS) e->env_tf.tf_eflags |= FL_IOPL_3;
f01032b8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f01032bc:	74 4c                	je     f010330a <env_create+0x6f>

	load_icode(e, binary);
f01032be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01032c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ELFHDR->e_magic != ELF_MAGIC) {
f01032c4:	8b 45 08             	mov    0x8(%ebp),%eax
f01032c7:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
f01032cd:	75 47                	jne    f0103316 <env_create+0x7b>
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
f01032cf:	8b 45 08             	mov    0x8(%ebp),%eax
f01032d2:	8b 58 1c             	mov    0x1c(%eax),%ebx
	ph_num = ELFHDR->e_phnum;
f01032d5:	0f b7 78 2c          	movzwl 0x2c(%eax),%edi
	lcr3(PADDR(e->env_pgdir));			//这步别忘了，虽然到目前为止e->env_pgdir和kern_pgdir除了PDX(UVPT)这一项不同，其他都一样。
f01032d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01032dc:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01032df:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01032e4:	76 47                	jbe    f010332d <env_create+0x92>
	return (physaddr_t)kva - KERNBASE;
f01032e6:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01032eb:	0f 22 d8             	mov    %eax,%cr3
f01032ee:	03 5d 08             	add    0x8(%ebp),%ebx
f01032f1:	eb 55                	jmp    f0103348 <env_create+0xad>
		panic("create env failed\n");
f01032f3:	83 ec 04             	sub    $0x4,%esp
f01032f6:	68 a2 76 10 f0       	push   $0xf01076a2
f01032fb:	68 90 01 00 00       	push   $0x190
f0103300:	68 82 76 10 f0       	push   $0xf0107682
f0103305:	e8 36 cd ff ff       	call   f0100040 <_panic>
	if (type == ENV_TYPE_FS) e->env_tf.tf_eflags |= FL_IOPL_3;
f010330a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010330d:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
f0103314:	eb a8                	jmp    f01032be <env_create+0x23>
		panic("binary is not ELF format\n");
f0103316:	83 ec 04             	sub    $0x4,%esp
f0103319:	68 b5 76 10 f0       	push   $0xf01076b5
f010331e:	68 68 01 00 00       	push   $0x168
f0103323:	68 82 76 10 f0       	push   $0xf0107682
f0103328:	e8 13 cd ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010332d:	50                   	push   %eax
f010332e:	68 88 64 10 f0       	push   $0xf0106488
f0103333:	68 6d 01 00 00       	push   $0x16d
f0103338:	68 82 76 10 f0       	push   $0xf0107682
f010333d:	e8 fe cc ff ff       	call   f0100040 <_panic>
	for (int i = 0; i < ph_num; i++) {
f0103342:	83 c6 01             	add    $0x1,%esi
f0103345:	83 c3 20             	add    $0x20,%ebx
f0103348:	39 f7                	cmp    %esi,%edi
f010334a:	74 3d                	je     f0103389 <env_create+0xee>
		if (ph[i].p_type == ELF_PROG_LOAD) {		//只加载LOAD类型的Segment
f010334c:	83 3b 01             	cmpl   $0x1,(%ebx)
f010334f:	75 f1                	jne    f0103342 <env_create+0xa7>
			region_alloc(e, (void *)ph[i].p_va, ph[i].p_memsz);
f0103351:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0103354:	8b 53 08             	mov    0x8(%ebx),%edx
f0103357:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010335a:	e8 30 fc ff ff       	call   f0102f8f <region_alloc>
			memset((void *)ph[i].p_va, 0, ph[i].p_memsz);		//因为这里需要访问刚分配的内存，所以之前需要切换页目录
f010335f:	83 ec 04             	sub    $0x4,%esp
f0103362:	ff 73 14             	pushl  0x14(%ebx)
f0103365:	6a 00                	push   $0x0
f0103367:	ff 73 08             	pushl  0x8(%ebx)
f010336a:	e8 63 24 00 00       	call   f01057d2 <memset>
			memcpy((void *)ph[i].p_va, binary + ph[i].p_offset, ph[i].p_filesz); //应该有如下关系：ph->p_filesz <= ph->p_memsz。搜索BSS段
f010336f:	83 c4 0c             	add    $0xc,%esp
f0103372:	ff 73 10             	pushl  0x10(%ebx)
f0103375:	8b 45 08             	mov    0x8(%ebp),%eax
f0103378:	03 43 04             	add    0x4(%ebx),%eax
f010337b:	50                   	push   %eax
f010337c:	ff 73 08             	pushl  0x8(%ebx)
f010337f:	e8 03 25 00 00       	call   f0105887 <memcpy>
f0103384:	83 c4 10             	add    $0x10,%esp
f0103387:	eb b9                	jmp    f0103342 <env_create+0xa7>
	lcr3(PADDR(kern_pgdir));
f0103389:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f010338e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103393:	76 36                	jbe    f01033cb <env_create+0x130>
	return (physaddr_t)kva - KERNBASE;
f0103395:	05 00 00 00 10       	add    $0x10000000,%eax
f010339a:	0f 22 d8             	mov    %eax,%cr3
	e->env_tf.tf_eip = ELFHDR->e_entry;
f010339d:	8b 45 08             	mov    0x8(%ebp),%eax
f01033a0:	8b 40 18             	mov    0x18(%eax),%eax
f01033a3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01033a6:	89 47 30             	mov    %eax,0x30(%edi)
	region_alloc(e, (void *) (USTACKTOP - PGSIZE), PGSIZE);
f01033a9:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01033ae:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01033b3:	89 f8                	mov    %edi,%eax
f01033b5:	e8 d5 fb ff ff       	call   f0102f8f <region_alloc>
	e->env_type = type;
f01033ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01033bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01033c0:	89 48 50             	mov    %ecx,0x50(%eax)
}
f01033c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01033c6:	5b                   	pop    %ebx
f01033c7:	5e                   	pop    %esi
f01033c8:	5f                   	pop    %edi
f01033c9:	5d                   	pop    %ebp
f01033ca:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033cb:	50                   	push   %eax
f01033cc:	68 88 64 10 f0       	push   $0xf0106488
f01033d1:	68 78 01 00 00       	push   $0x178
f01033d6:	68 82 76 10 f0       	push   $0xf0107682
f01033db:	e8 60 cc ff ff       	call   f0100040 <_panic>

f01033e0 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f01033e0:	55                   	push   %ebp
f01033e1:	89 e5                	mov    %esp,%ebp
f01033e3:	57                   	push   %edi
f01033e4:	56                   	push   %esi
f01033e5:	53                   	push   %ebx
f01033e6:	83 ec 1c             	sub    $0x1c,%esp
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f01033e9:	e8 09 2a 00 00       	call   f0105df7 <cpunum>
f01033ee:	6b c0 74             	imul   $0x74,%eax,%eax
f01033f1:	8b 55 08             	mov    0x8(%ebp),%edx
f01033f4:	39 90 28 a0 1e f0    	cmp    %edx,-0xfe15fd8(%eax)
f01033fa:	75 14                	jne    f0103410 <env_free+0x30>
		lcr3(PADDR(kern_pgdir));
f01033fc:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103401:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103406:	76 56                	jbe    f010345e <env_free+0x7e>
	return (physaddr_t)kva - KERNBASE;
f0103408:	05 00 00 00 10       	add    $0x10000000,%eax
f010340d:	0f 22 d8             	mov    %eax,%cr3

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103410:	8b 45 08             	mov    0x8(%ebp),%eax
f0103413:	8b 58 48             	mov    0x48(%eax),%ebx
f0103416:	e8 dc 29 00 00       	call   f0105df7 <cpunum>
f010341b:	6b c0 74             	imul   $0x74,%eax,%eax
f010341e:	ba 00 00 00 00       	mov    $0x0,%edx
f0103423:	83 b8 28 a0 1e f0 00 	cmpl   $0x0,-0xfe15fd8(%eax)
f010342a:	74 11                	je     f010343d <env_free+0x5d>
f010342c:	e8 c6 29 00 00       	call   f0105df7 <cpunum>
f0103431:	6b c0 74             	imul   $0x74,%eax,%eax
f0103434:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f010343a:	8b 50 48             	mov    0x48(%eax),%edx
f010343d:	83 ec 04             	sub    $0x4,%esp
f0103440:	53                   	push   %ebx
f0103441:	52                   	push   %edx
f0103442:	68 cf 76 10 f0       	push   $0xf01076cf
f0103447:	e8 47 04 00 00       	call   f0103893 <cprintf>
f010344c:	83 c4 10             	add    $0x10,%esp
f010344f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0103456:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103459:	e9 8f 00 00 00       	jmp    f01034ed <env_free+0x10d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010345e:	50                   	push   %eax
f010345f:	68 88 64 10 f0       	push   $0xf0106488
f0103464:	68 a9 01 00 00       	push   $0x1a9
f0103469:	68 82 76 10 f0       	push   $0xf0107682
f010346e:	e8 cd cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103473:	50                   	push   %eax
f0103474:	68 64 64 10 f0       	push   $0xf0106464
f0103479:	68 b8 01 00 00       	push   $0x1b8
f010347e:	68 82 76 10 f0       	push   $0xf0107682
f0103483:	e8 b8 cb ff ff       	call   f0100040 <_panic>
f0103488:	83 c3 04             	add    $0x4,%ebx
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f010348b:	39 f3                	cmp    %esi,%ebx
f010348d:	74 21                	je     f01034b0 <env_free+0xd0>
			if (pt[pteno] & PTE_P)
f010348f:	f6 03 01             	testb  $0x1,(%ebx)
f0103492:	74 f4                	je     f0103488 <env_free+0xa8>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103494:	83 ec 08             	sub    $0x8,%esp
f0103497:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010349a:	01 d8                	add    %ebx,%eax
f010349c:	c1 e0 0a             	shl    $0xa,%eax
f010349f:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01034a2:	50                   	push   %eax
f01034a3:	ff 77 60             	pushl  0x60(%edi)
f01034a6:	e8 fe dc ff ff       	call   f01011a9 <page_remove>
f01034ab:	83 c4 10             	add    $0x10,%esp
f01034ae:	eb d8                	jmp    f0103488 <env_free+0xa8>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f01034b0:	8b 47 60             	mov    0x60(%edi),%eax
f01034b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01034b6:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f01034bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01034c0:	3b 05 88 9e 1e f0    	cmp    0xf01e9e88,%eax
f01034c6:	73 6a                	jae    f0103532 <env_free+0x152>
		page_decref(pa2page(pa));
f01034c8:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01034cb:	a1 90 9e 1e f0       	mov    0xf01e9e90,%eax
f01034d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01034d3:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f01034d6:	50                   	push   %eax
f01034d7:	e8 f1 da ff ff       	call   f0100fcd <page_decref>
f01034dc:	83 c4 10             	add    $0x10,%esp
f01034df:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
f01034e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01034e6:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f01034eb:	74 59                	je     f0103546 <env_free+0x166>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f01034ed:	8b 47 60             	mov    0x60(%edi),%eax
f01034f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01034f3:	8b 04 10             	mov    (%eax,%edx,1),%eax
f01034f6:	a8 01                	test   $0x1,%al
f01034f8:	74 e5                	je     f01034df <env_free+0xff>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f01034fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01034ff:	89 c2                	mov    %eax,%edx
f0103501:	c1 ea 0c             	shr    $0xc,%edx
f0103504:	89 55 d8             	mov    %edx,-0x28(%ebp)
f0103507:	39 15 88 9e 1e f0    	cmp    %edx,0xf01e9e88
f010350d:	0f 86 60 ff ff ff    	jbe    f0103473 <env_free+0x93>
	return (void *)(pa + KERNBASE);
f0103513:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103519:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010351c:	c1 e2 14             	shl    $0x14,%edx
f010351f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0103522:	8d b0 00 10 00 f0    	lea    -0xffff000(%eax),%esi
f0103528:	f7 d8                	neg    %eax
f010352a:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010352d:	e9 5d ff ff ff       	jmp    f010348f <env_free+0xaf>
		panic("pa2page called with invalid pa");
f0103532:	83 ec 04             	sub    $0x4,%esp
f0103535:	68 10 6b 10 f0       	push   $0xf0106b10
f010353a:	6a 51                	push   $0x51
f010353c:	68 55 73 10 f0       	push   $0xf0107355
f0103541:	e8 fa ca ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103546:	8b 45 08             	mov    0x8(%ebp),%eax
f0103549:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f010354c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103551:	76 52                	jbe    f01035a5 <env_free+0x1c5>
	e->env_pgdir = 0;
f0103553:	8b 55 08             	mov    0x8(%ebp),%edx
f0103556:	c7 42 60 00 00 00 00 	movl   $0x0,0x60(%edx)
	return (physaddr_t)kva - KERNBASE;
f010355d:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103562:	c1 e8 0c             	shr    $0xc,%eax
f0103565:	3b 05 88 9e 1e f0    	cmp    0xf01e9e88,%eax
f010356b:	73 4d                	jae    f01035ba <env_free+0x1da>
	page_decref(pa2page(pa));
f010356d:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103570:	8b 15 90 9e 1e f0    	mov    0xf01e9e90,%edx
f0103576:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103579:	50                   	push   %eax
f010357a:	e8 4e da ff ff       	call   f0100fcd <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f010357f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103582:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	e->env_link = env_free_list;
f0103589:	a1 48 92 1e f0       	mov    0xf01e9248,%eax
f010358e:	8b 55 08             	mov    0x8(%ebp),%edx
f0103591:	89 42 44             	mov    %eax,0x44(%edx)
	env_free_list = e;
f0103594:	89 15 48 92 1e f0    	mov    %edx,0xf01e9248
}
f010359a:	83 c4 10             	add    $0x10,%esp
f010359d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01035a0:	5b                   	pop    %ebx
f01035a1:	5e                   	pop    %esi
f01035a2:	5f                   	pop    %edi
f01035a3:	5d                   	pop    %ebp
f01035a4:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01035a5:	50                   	push   %eax
f01035a6:	68 88 64 10 f0       	push   $0xf0106488
f01035ab:	68 c6 01 00 00       	push   $0x1c6
f01035b0:	68 82 76 10 f0       	push   $0xf0107682
f01035b5:	e8 86 ca ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f01035ba:	83 ec 04             	sub    $0x4,%esp
f01035bd:	68 10 6b 10 f0       	push   $0xf0106b10
f01035c2:	6a 51                	push   $0x51
f01035c4:	68 55 73 10 f0       	push   $0xf0107355
f01035c9:	e8 72 ca ff ff       	call   f0100040 <_panic>

f01035ce <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f01035ce:	55                   	push   %ebp
f01035cf:	89 e5                	mov    %esp,%ebp
f01035d1:	53                   	push   %ebx
f01035d2:	83 ec 04             	sub    $0x4,%esp
f01035d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f01035d8:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f01035dc:	74 21                	je     f01035ff <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f01035de:	83 ec 0c             	sub    $0xc,%esp
f01035e1:	53                   	push   %ebx
f01035e2:	e8 f9 fd ff ff       	call   f01033e0 <env_free>

	if (curenv == e) {
f01035e7:	e8 0b 28 00 00       	call   f0105df7 <cpunum>
f01035ec:	6b c0 74             	imul   $0x74,%eax,%eax
f01035ef:	83 c4 10             	add    $0x10,%esp
f01035f2:	39 98 28 a0 1e f0    	cmp    %ebx,-0xfe15fd8(%eax)
f01035f8:	74 1e                	je     f0103618 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f01035fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01035fd:	c9                   	leave  
f01035fe:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f01035ff:	e8 f3 27 00 00       	call   f0105df7 <cpunum>
f0103604:	6b c0 74             	imul   $0x74,%eax,%eax
f0103607:	39 98 28 a0 1e f0    	cmp    %ebx,-0xfe15fd8(%eax)
f010360d:	74 cf                	je     f01035de <env_destroy+0x10>
		e->env_status = ENV_DYING;
f010360f:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103616:	eb e2                	jmp    f01035fa <env_destroy+0x2c>
		curenv = NULL;
f0103618:	e8 da 27 00 00       	call   f0105df7 <cpunum>
f010361d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103620:	c7 80 28 a0 1e f0 00 	movl   $0x0,-0xfe15fd8(%eax)
f0103627:	00 00 00 
		sched_yield();
f010362a:	e8 1a 10 00 00       	call   f0104649 <sched_yield>

f010362f <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f010362f:	55                   	push   %ebp
f0103630:	89 e5                	mov    %esp,%ebp
f0103632:	53                   	push   %ebx
f0103633:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103636:	e8 bc 27 00 00       	call   f0105df7 <cpunum>
f010363b:	6b c0 74             	imul   $0x74,%eax,%eax
f010363e:	8b 98 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%ebx
f0103644:	e8 ae 27 00 00       	call   f0105df7 <cpunum>
f0103649:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f010364c:	8b 65 08             	mov    0x8(%ebp),%esp
f010364f:	61                   	popa   
f0103650:	07                   	pop    %es
f0103651:	1f                   	pop    %ds
f0103652:	83 c4 08             	add    $0x8,%esp
f0103655:	cf                   	iret   
		"\tpopl %%es\n"					//弹出Trapframe结构中的tf_es值到%es寄存器
		"\tpopl %%ds\n"					//弹出Trapframe结构中的tf_ds值到%ds寄存器
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"						//中断返回指令，具体动作如下：从Trapframe结构中依次弹出tf_eip,tf_cs,tf_eflags,tf_esp,tf_ss到相应寄存器
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103656:	83 ec 04             	sub    $0x4,%esp
f0103659:	68 e5 76 10 f0       	push   $0xf01076e5
f010365e:	68 fd 01 00 00       	push   $0x1fd
f0103663:	68 82 76 10 f0       	push   $0xf0107682
f0103668:	e8 d3 c9 ff ff       	call   f0100040 <_panic>

f010366d <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f010366d:	55                   	push   %ebp
f010366e:	89 e5                	mov    %esp,%ebp
f0103670:	53                   	push   %ebx
f0103671:	83 ec 04             	sub    $0x4,%esp
f0103674:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if (curenv != NULL && curenv->env_status == ENV_RUNNING) {	//将原来正在运行的Env设置为ENV_RUNNABLE
f0103677:	e8 7b 27 00 00       	call   f0105df7 <cpunum>
f010367c:	6b c0 74             	imul   $0x74,%eax,%eax
f010367f:	83 b8 28 a0 1e f0 00 	cmpl   $0x0,-0xfe15fd8(%eax)
f0103686:	74 14                	je     f010369c <env_run+0x2f>
f0103688:	e8 6a 27 00 00       	call   f0105df7 <cpunum>
f010368d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103690:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0103696:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010369a:	74 38                	je     f01036d4 <env_run+0x67>
		curenv->env_status = ENV_RUNNABLE;
	}
	curenv = e;
f010369c:	e8 56 27 00 00       	call   f0105df7 <cpunum>
f01036a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01036a4:	89 98 28 a0 1e f0    	mov    %ebx,-0xfe15fd8(%eax)
	e->env_status = ENV_RUNNING;
f01036aa:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
	e->env_runs++;
f01036b1:	83 43 58 01          	addl   $0x1,0x58(%ebx)
	lcr3(PADDR(e->env_pgdir));
f01036b5:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01036b8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01036bd:	77 2c                	ja     f01036eb <env_run+0x7e>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01036bf:	50                   	push   %eax
f01036c0:	68 88 64 10 f0       	push   $0xf0106488
f01036c5:	68 21 02 00 00       	push   $0x221
f01036ca:	68 82 76 10 f0       	push   $0xf0107682
f01036cf:	e8 6c c9 ff ff       	call   f0100040 <_panic>
		curenv->env_status = ENV_RUNNABLE;
f01036d4:	e8 1e 27 00 00       	call   f0105df7 <cpunum>
f01036d9:	6b c0 74             	imul   $0x74,%eax,%eax
f01036dc:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f01036e2:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f01036e9:	eb b1                	jmp    f010369c <env_run+0x2f>
	return (physaddr_t)kva - KERNBASE;
f01036eb:	05 00 00 00 10       	add    $0x10000000,%eax
f01036f0:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f01036f3:	83 ec 0c             	sub    $0xc,%esp
f01036f6:	68 c0 23 12 f0       	push   $0xf01223c0
f01036fb:	e8 04 2a 00 00       	call   f0106104 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103700:	f3 90                	pause  
	unlock_kernel();						//注意不能放最后，因为在env_pop_tr()后的语句执行不到
	env_pop_tf(&e->env_tf);
f0103702:	89 1c 24             	mov    %ebx,(%esp)
f0103705:	e8 25 ff ff ff       	call   f010362f <env_pop_tf>

f010370a <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010370a:	55                   	push   %ebp
f010370b:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010370d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103710:	ba 70 00 00 00       	mov    $0x70,%edx
f0103715:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103716:	ba 71 00 00 00       	mov    $0x71,%edx
f010371b:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f010371c:	0f b6 c0             	movzbl %al,%eax
}
f010371f:	5d                   	pop    %ebp
f0103720:	c3                   	ret    

f0103721 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103721:	55                   	push   %ebp
f0103722:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103724:	8b 45 08             	mov    0x8(%ebp),%eax
f0103727:	ba 70 00 00 00       	mov    $0x70,%edx
f010372c:	ee                   	out    %al,(%dx)
f010372d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103730:	ba 71 00 00 00       	mov    $0x71,%edx
f0103735:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103736:	5d                   	pop    %ebp
f0103737:	c3                   	ret    

f0103738 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103738:	55                   	push   %ebp
f0103739:	89 e5                	mov    %esp,%ebp
f010373b:	56                   	push   %esi
f010373c:	53                   	push   %ebx
f010373d:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103740:	66 a3 a8 23 12 f0    	mov    %ax,0xf01223a8
	if (!didinit)
f0103746:	80 3d 4c 92 1e f0 00 	cmpb   $0x0,0xf01e924c
f010374d:	75 07                	jne    f0103756 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f010374f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103752:	5b                   	pop    %ebx
f0103753:	5e                   	pop    %esi
f0103754:	5d                   	pop    %ebp
f0103755:	c3                   	ret    
f0103756:	89 c6                	mov    %eax,%esi
f0103758:	ba 21 00 00 00       	mov    $0x21,%edx
f010375d:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f010375e:	66 c1 e8 08          	shr    $0x8,%ax
f0103762:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103767:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103768:	83 ec 0c             	sub    $0xc,%esp
f010376b:	68 f1 76 10 f0       	push   $0xf01076f1
f0103770:	e8 1e 01 00 00       	call   f0103893 <cprintf>
f0103775:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103778:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f010377d:	0f b7 f6             	movzwl %si,%esi
f0103780:	f7 d6                	not    %esi
f0103782:	eb 08                	jmp    f010378c <irq_setmask_8259A+0x54>
	for (i = 0; i < 16; i++)
f0103784:	83 c3 01             	add    $0x1,%ebx
f0103787:	83 fb 10             	cmp    $0x10,%ebx
f010378a:	74 18                	je     f01037a4 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f010378c:	0f a3 de             	bt     %ebx,%esi
f010378f:	73 f3                	jae    f0103784 <irq_setmask_8259A+0x4c>
			cprintf(" %d", i);
f0103791:	83 ec 08             	sub    $0x8,%esp
f0103794:	53                   	push   %ebx
f0103795:	68 df 7b 10 f0       	push   $0xf0107bdf
f010379a:	e8 f4 00 00 00       	call   f0103893 <cprintf>
f010379f:	83 c4 10             	add    $0x10,%esp
f01037a2:	eb e0                	jmp    f0103784 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f01037a4:	83 ec 0c             	sub    $0xc,%esp
f01037a7:	68 3b 76 10 f0       	push   $0xf010763b
f01037ac:	e8 e2 00 00 00       	call   f0103893 <cprintf>
f01037b1:	83 c4 10             	add    $0x10,%esp
f01037b4:	eb 99                	jmp    f010374f <irq_setmask_8259A+0x17>

f01037b6 <pic_init>:
{
f01037b6:	55                   	push   %ebp
f01037b7:	89 e5                	mov    %esp,%ebp
f01037b9:	57                   	push   %edi
f01037ba:	56                   	push   %esi
f01037bb:	53                   	push   %ebx
f01037bc:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f01037bf:	c6 05 4c 92 1e f0 01 	movb   $0x1,0xf01e924c
f01037c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01037cb:	bb 21 00 00 00       	mov    $0x21,%ebx
f01037d0:	89 da                	mov    %ebx,%edx
f01037d2:	ee                   	out    %al,(%dx)
f01037d3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f01037d8:	89 ca                	mov    %ecx,%edx
f01037da:	ee                   	out    %al,(%dx)
f01037db:	bf 11 00 00 00       	mov    $0x11,%edi
f01037e0:	be 20 00 00 00       	mov    $0x20,%esi
f01037e5:	89 f8                	mov    %edi,%eax
f01037e7:	89 f2                	mov    %esi,%edx
f01037e9:	ee                   	out    %al,(%dx)
f01037ea:	b8 20 00 00 00       	mov    $0x20,%eax
f01037ef:	89 da                	mov    %ebx,%edx
f01037f1:	ee                   	out    %al,(%dx)
f01037f2:	b8 04 00 00 00       	mov    $0x4,%eax
f01037f7:	ee                   	out    %al,(%dx)
f01037f8:	b8 03 00 00 00       	mov    $0x3,%eax
f01037fd:	ee                   	out    %al,(%dx)
f01037fe:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103803:	89 f8                	mov    %edi,%eax
f0103805:	89 da                	mov    %ebx,%edx
f0103807:	ee                   	out    %al,(%dx)
f0103808:	b8 28 00 00 00       	mov    $0x28,%eax
f010380d:	89 ca                	mov    %ecx,%edx
f010380f:	ee                   	out    %al,(%dx)
f0103810:	b8 02 00 00 00       	mov    $0x2,%eax
f0103815:	ee                   	out    %al,(%dx)
f0103816:	b8 01 00 00 00       	mov    $0x1,%eax
f010381b:	ee                   	out    %al,(%dx)
f010381c:	bf 68 00 00 00       	mov    $0x68,%edi
f0103821:	89 f8                	mov    %edi,%eax
f0103823:	89 f2                	mov    %esi,%edx
f0103825:	ee                   	out    %al,(%dx)
f0103826:	b9 0a 00 00 00       	mov    $0xa,%ecx
f010382b:	89 c8                	mov    %ecx,%eax
f010382d:	ee                   	out    %al,(%dx)
f010382e:	89 f8                	mov    %edi,%eax
f0103830:	89 da                	mov    %ebx,%edx
f0103832:	ee                   	out    %al,(%dx)
f0103833:	89 c8                	mov    %ecx,%eax
f0103835:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103836:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f010383d:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103841:	74 0f                	je     f0103852 <pic_init+0x9c>
		irq_setmask_8259A(irq_mask_8259A);
f0103843:	83 ec 0c             	sub    $0xc,%esp
f0103846:	0f b7 c0             	movzwl %ax,%eax
f0103849:	50                   	push   %eax
f010384a:	e8 e9 fe ff ff       	call   f0103738 <irq_setmask_8259A>
f010384f:	83 c4 10             	add    $0x10,%esp
}
f0103852:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103855:	5b                   	pop    %ebx
f0103856:	5e                   	pop    %esi
f0103857:	5f                   	pop    %edi
f0103858:	5d                   	pop    %ebp
f0103859:	c3                   	ret    

f010385a <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f010385a:	55                   	push   %ebp
f010385b:	89 e5                	mov    %esp,%ebp
f010385d:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0103860:	ff 75 08             	pushl  0x8(%ebp)
f0103863:	e8 3a cf ff ff       	call   f01007a2 <cputchar>
	*cnt++;
}
f0103868:	83 c4 10             	add    $0x10,%esp
f010386b:	c9                   	leave  
f010386c:	c3                   	ret    

f010386d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010386d:	55                   	push   %ebp
f010386e:	89 e5                	mov    %esp,%ebp
f0103870:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103873:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f010387a:	ff 75 0c             	pushl  0xc(%ebp)
f010387d:	ff 75 08             	pushl  0x8(%ebp)
f0103880:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103883:	50                   	push   %eax
f0103884:	68 5a 38 10 f0       	push   $0xf010385a
f0103889:	e8 f3 17 00 00       	call   f0105081 <vprintfmt>
	return cnt;
}
f010388e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103891:	c9                   	leave  
f0103892:	c3                   	ret    

f0103893 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103893:	55                   	push   %ebp
f0103894:	89 e5                	mov    %esp,%ebp
f0103896:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103899:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f010389c:	50                   	push   %eax
f010389d:	ff 75 08             	pushl  0x8(%ebp)
f01038a0:	e8 c8 ff ff ff       	call   f010386d <vcprintf>
	va_end(ap);

	return cnt;
}
f01038a5:	c9                   	leave  
f01038a6:	c3                   	ret    

f01038a7 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f01038a7:	55                   	push   %ebp
f01038a8:	89 e5                	mov    %esp,%ebp
f01038aa:	57                   	push   %edi
f01038ab:	56                   	push   %esi
f01038ac:	53                   	push   %ebx
f01038ad:	83 ec 0c             	sub    $0xc,%esp
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	int cid = thiscpu->cpu_id;
f01038b0:	e8 42 25 00 00       	call   f0105df7 <cpunum>
f01038b5:	6b c0 74             	imul   $0x74,%eax,%eax
f01038b8:	0f b6 98 20 a0 1e f0 	movzbl -0xfe15fe0(%eax),%ebx
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - cid * (KSTKSIZE + KSTKGAP);
f01038bf:	e8 33 25 00 00       	call   f0105df7 <cpunum>
f01038c4:	6b c0 74             	imul   $0x74,%eax,%eax
f01038c7:	89 d9                	mov    %ebx,%ecx
f01038c9:	c1 e1 10             	shl    $0x10,%ecx
f01038cc:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01038d1:	29 ca                	sub    %ecx,%edx
f01038d3:	89 90 30 a0 1e f0    	mov    %edx,-0xfe15fd0(%eax)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f01038d9:	e8 19 25 00 00       	call   f0105df7 <cpunum>
f01038de:	6b c0 74             	imul   $0x74,%eax,%eax
f01038e1:	66 c7 80 34 a0 1e f0 	movw   $0x10,-0xfe15fcc(%eax)
f01038e8:	10 00 
	thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);	
f01038ea:	e8 08 25 00 00       	call   f0105df7 <cpunum>
f01038ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01038f2:	66 c7 80 92 a0 1e f0 	movw   $0x68,-0xfe15f6e(%eax)
f01038f9:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3)+cid] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f01038fb:	83 c3 05             	add    $0x5,%ebx
f01038fe:	e8 f4 24 00 00       	call   f0105df7 <cpunum>
f0103903:	89 c7                	mov    %eax,%edi
f0103905:	e8 ed 24 00 00       	call   f0105df7 <cpunum>
f010390a:	89 c6                	mov    %eax,%esi
f010390c:	e8 e6 24 00 00       	call   f0105df7 <cpunum>
f0103911:	66 c7 04 dd 40 23 12 	movw   $0x68,-0xfeddcc0(,%ebx,8)
f0103918:	f0 68 00 
f010391b:	6b ff 74             	imul   $0x74,%edi,%edi
f010391e:	81 c7 2c a0 1e f0    	add    $0xf01ea02c,%edi
f0103924:	66 89 3c dd 42 23 12 	mov    %di,-0xfeddcbe(,%ebx,8)
f010392b:	f0 
f010392c:	6b d6 74             	imul   $0x74,%esi,%edx
f010392f:	81 c2 2c a0 1e f0    	add    $0xf01ea02c,%edx
f0103935:	c1 ea 10             	shr    $0x10,%edx
f0103938:	88 14 dd 44 23 12 f0 	mov    %dl,-0xfeddcbc(,%ebx,8)
f010393f:	c6 04 dd 46 23 12 f0 	movb   $0x40,-0xfeddcba(,%ebx,8)
f0103946:	40 
f0103947:	6b c0 74             	imul   $0x74,%eax,%eax
f010394a:	05 2c a0 1e f0       	add    $0xf01ea02c,%eax
f010394f:	c1 e8 18             	shr    $0x18,%eax
f0103952:	88 04 dd 47 23 12 f0 	mov    %al,-0xfeddcb9(,%ebx,8)
					sizeof(struct Taskstate), 0);
	gdt[(GD_TSS0 >> 3)+cid].sd_s = 0;
f0103959:	c6 04 dd 45 23 12 f0 	movb   $0x89,-0xfeddcbb(,%ebx,8)
f0103960:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0+8*cid);
f0103961:	c1 e3 03             	shl    $0x3,%ebx
	asm volatile("ltr %0" : : "r" (sel));
f0103964:	0f 00 db             	ltr    %bx
	asm volatile("lidt (%0)" : : "r" (p));
f0103967:	b8 ac 23 12 f0       	mov    $0xf01223ac,%eax
f010396c:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f010396f:	83 c4 0c             	add    $0xc,%esp
f0103972:	5b                   	pop    %ebx
f0103973:	5e                   	pop    %esi
f0103974:	5f                   	pop    %edi
f0103975:	5d                   	pop    %ebp
f0103976:	c3                   	ret    

f0103977 <trap_init>:
{
f0103977:	55                   	push   %ebp
f0103978:	89 e5                	mov    %esp,%ebp
f010397a:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[0], 0, GD_KT, th0, 0);		//格式如下：SETGATE(gate, istrap, sel, off, dpl)，定义在inc/mmu.h中
f010397d:	b8 90 44 10 f0       	mov    $0xf0104490,%eax
f0103982:	66 a3 60 92 1e f0    	mov    %ax,0xf01e9260
f0103988:	66 c7 05 62 92 1e f0 	movw   $0x8,0xf01e9262
f010398f:	08 00 
f0103991:	c6 05 64 92 1e f0 00 	movb   $0x0,0xf01e9264
f0103998:	c6 05 65 92 1e f0 8e 	movb   $0x8e,0xf01e9265
f010399f:	c1 e8 10             	shr    $0x10,%eax
f01039a2:	66 a3 66 92 1e f0    	mov    %ax,0xf01e9266
	SETGATE(idt[1], 0, GD_KT, th1, 0);
f01039a8:	b8 9a 44 10 f0       	mov    $0xf010449a,%eax
f01039ad:	66 a3 68 92 1e f0    	mov    %ax,0xf01e9268
f01039b3:	66 c7 05 6a 92 1e f0 	movw   $0x8,0xf01e926a
f01039ba:	08 00 
f01039bc:	c6 05 6c 92 1e f0 00 	movb   $0x0,0xf01e926c
f01039c3:	c6 05 6d 92 1e f0 8e 	movb   $0x8e,0xf01e926d
f01039ca:	c1 e8 10             	shr    $0x10,%eax
f01039cd:	66 a3 6e 92 1e f0    	mov    %ax,0xf01e926e
	SETGATE(idt[3], 0, GD_KT, th3, 3);
f01039d3:	b8 a4 44 10 f0       	mov    $0xf01044a4,%eax
f01039d8:	66 a3 78 92 1e f0    	mov    %ax,0xf01e9278
f01039de:	66 c7 05 7a 92 1e f0 	movw   $0x8,0xf01e927a
f01039e5:	08 00 
f01039e7:	c6 05 7c 92 1e f0 00 	movb   $0x0,0xf01e927c
f01039ee:	c6 05 7d 92 1e f0 ee 	movb   $0xee,0xf01e927d
f01039f5:	c1 e8 10             	shr    $0x10,%eax
f01039f8:	66 a3 7e 92 1e f0    	mov    %ax,0xf01e927e
	SETGATE(idt[4], 0, GD_KT, th4, 0);
f01039fe:	b8 ae 44 10 f0       	mov    $0xf01044ae,%eax
f0103a03:	66 a3 80 92 1e f0    	mov    %ax,0xf01e9280
f0103a09:	66 c7 05 82 92 1e f0 	movw   $0x8,0xf01e9282
f0103a10:	08 00 
f0103a12:	c6 05 84 92 1e f0 00 	movb   $0x0,0xf01e9284
f0103a19:	c6 05 85 92 1e f0 8e 	movb   $0x8e,0xf01e9285
f0103a20:	c1 e8 10             	shr    $0x10,%eax
f0103a23:	66 a3 86 92 1e f0    	mov    %ax,0xf01e9286
	SETGATE(idt[5], 0, GD_KT, th5, 0);
f0103a29:	b8 b8 44 10 f0       	mov    $0xf01044b8,%eax
f0103a2e:	66 a3 88 92 1e f0    	mov    %ax,0xf01e9288
f0103a34:	66 c7 05 8a 92 1e f0 	movw   $0x8,0xf01e928a
f0103a3b:	08 00 
f0103a3d:	c6 05 8c 92 1e f0 00 	movb   $0x0,0xf01e928c
f0103a44:	c6 05 8d 92 1e f0 8e 	movb   $0x8e,0xf01e928d
f0103a4b:	c1 e8 10             	shr    $0x10,%eax
f0103a4e:	66 a3 8e 92 1e f0    	mov    %ax,0xf01e928e
	SETGATE(idt[6], 0, GD_KT, th6, 0);
f0103a54:	b8 c2 44 10 f0       	mov    $0xf01044c2,%eax
f0103a59:	66 a3 90 92 1e f0    	mov    %ax,0xf01e9290
f0103a5f:	66 c7 05 92 92 1e f0 	movw   $0x8,0xf01e9292
f0103a66:	08 00 
f0103a68:	c6 05 94 92 1e f0 00 	movb   $0x0,0xf01e9294
f0103a6f:	c6 05 95 92 1e f0 8e 	movb   $0x8e,0xf01e9295
f0103a76:	c1 e8 10             	shr    $0x10,%eax
f0103a79:	66 a3 96 92 1e f0    	mov    %ax,0xf01e9296
	SETGATE(idt[7], 0, GD_KT, th7, 0);
f0103a7f:	b8 cc 44 10 f0       	mov    $0xf01044cc,%eax
f0103a84:	66 a3 98 92 1e f0    	mov    %ax,0xf01e9298
f0103a8a:	66 c7 05 9a 92 1e f0 	movw   $0x8,0xf01e929a
f0103a91:	08 00 
f0103a93:	c6 05 9c 92 1e f0 00 	movb   $0x0,0xf01e929c
f0103a9a:	c6 05 9d 92 1e f0 8e 	movb   $0x8e,0xf01e929d
f0103aa1:	c1 e8 10             	shr    $0x10,%eax
f0103aa4:	66 a3 9e 92 1e f0    	mov    %ax,0xf01e929e
	SETGATE(idt[8], 0, GD_KT, th8, 0);
f0103aaa:	b8 d6 44 10 f0       	mov    $0xf01044d6,%eax
f0103aaf:	66 a3 a0 92 1e f0    	mov    %ax,0xf01e92a0
f0103ab5:	66 c7 05 a2 92 1e f0 	movw   $0x8,0xf01e92a2
f0103abc:	08 00 
f0103abe:	c6 05 a4 92 1e f0 00 	movb   $0x0,0xf01e92a4
f0103ac5:	c6 05 a5 92 1e f0 8e 	movb   $0x8e,0xf01e92a5
f0103acc:	c1 e8 10             	shr    $0x10,%eax
f0103acf:	66 a3 a6 92 1e f0    	mov    %ax,0xf01e92a6
	SETGATE(idt[9], 0, GD_KT, th9, 0);
f0103ad5:	b8 de 44 10 f0       	mov    $0xf01044de,%eax
f0103ada:	66 a3 a8 92 1e f0    	mov    %ax,0xf01e92a8
f0103ae0:	66 c7 05 aa 92 1e f0 	movw   $0x8,0xf01e92aa
f0103ae7:	08 00 
f0103ae9:	c6 05 ac 92 1e f0 00 	movb   $0x0,0xf01e92ac
f0103af0:	c6 05 ad 92 1e f0 8e 	movb   $0x8e,0xf01e92ad
f0103af7:	c1 e8 10             	shr    $0x10,%eax
f0103afa:	66 a3 ae 92 1e f0    	mov    %ax,0xf01e92ae
	SETGATE(idt[10], 0, GD_KT, th10, 0);
f0103b00:	b8 e8 44 10 f0       	mov    $0xf01044e8,%eax
f0103b05:	66 a3 b0 92 1e f0    	mov    %ax,0xf01e92b0
f0103b0b:	66 c7 05 b2 92 1e f0 	movw   $0x8,0xf01e92b2
f0103b12:	08 00 
f0103b14:	c6 05 b4 92 1e f0 00 	movb   $0x0,0xf01e92b4
f0103b1b:	c6 05 b5 92 1e f0 8e 	movb   $0x8e,0xf01e92b5
f0103b22:	c1 e8 10             	shr    $0x10,%eax
f0103b25:	66 a3 b6 92 1e f0    	mov    %ax,0xf01e92b6
	SETGATE(idt[11], 0, GD_KT, th11, 0);
f0103b2b:	b8 ec 44 10 f0       	mov    $0xf01044ec,%eax
f0103b30:	66 a3 b8 92 1e f0    	mov    %ax,0xf01e92b8
f0103b36:	66 c7 05 ba 92 1e f0 	movw   $0x8,0xf01e92ba
f0103b3d:	08 00 
f0103b3f:	c6 05 bc 92 1e f0 00 	movb   $0x0,0xf01e92bc
f0103b46:	c6 05 bd 92 1e f0 8e 	movb   $0x8e,0xf01e92bd
f0103b4d:	c1 e8 10             	shr    $0x10,%eax
f0103b50:	66 a3 be 92 1e f0    	mov    %ax,0xf01e92be
	SETGATE(idt[12], 0, GD_KT, th12, 0);
f0103b56:	b8 f0 44 10 f0       	mov    $0xf01044f0,%eax
f0103b5b:	66 a3 c0 92 1e f0    	mov    %ax,0xf01e92c0
f0103b61:	66 c7 05 c2 92 1e f0 	movw   $0x8,0xf01e92c2
f0103b68:	08 00 
f0103b6a:	c6 05 c4 92 1e f0 00 	movb   $0x0,0xf01e92c4
f0103b71:	c6 05 c5 92 1e f0 8e 	movb   $0x8e,0xf01e92c5
f0103b78:	c1 e8 10             	shr    $0x10,%eax
f0103b7b:	66 a3 c6 92 1e f0    	mov    %ax,0xf01e92c6
	SETGATE(idt[13], 0, GD_KT, th13, 0);
f0103b81:	b8 f4 44 10 f0       	mov    $0xf01044f4,%eax
f0103b86:	66 a3 c8 92 1e f0    	mov    %ax,0xf01e92c8
f0103b8c:	66 c7 05 ca 92 1e f0 	movw   $0x8,0xf01e92ca
f0103b93:	08 00 
f0103b95:	c6 05 cc 92 1e f0 00 	movb   $0x0,0xf01e92cc
f0103b9c:	c6 05 cd 92 1e f0 8e 	movb   $0x8e,0xf01e92cd
f0103ba3:	c1 e8 10             	shr    $0x10,%eax
f0103ba6:	66 a3 ce 92 1e f0    	mov    %ax,0xf01e92ce
	SETGATE(idt[14], 0, GD_KT, th14, 0);
f0103bac:	b8 f8 44 10 f0       	mov    $0xf01044f8,%eax
f0103bb1:	66 a3 d0 92 1e f0    	mov    %ax,0xf01e92d0
f0103bb7:	66 c7 05 d2 92 1e f0 	movw   $0x8,0xf01e92d2
f0103bbe:	08 00 
f0103bc0:	c6 05 d4 92 1e f0 00 	movb   $0x0,0xf01e92d4
f0103bc7:	c6 05 d5 92 1e f0 8e 	movb   $0x8e,0xf01e92d5
f0103bce:	c1 e8 10             	shr    $0x10,%eax
f0103bd1:	66 a3 d6 92 1e f0    	mov    %ax,0xf01e92d6
	SETGATE(idt[16], 0, GD_KT, th16, 0);
f0103bd7:	b8 fc 44 10 f0       	mov    $0xf01044fc,%eax
f0103bdc:	66 a3 e0 92 1e f0    	mov    %ax,0xf01e92e0
f0103be2:	66 c7 05 e2 92 1e f0 	movw   $0x8,0xf01e92e2
f0103be9:	08 00 
f0103beb:	c6 05 e4 92 1e f0 00 	movb   $0x0,0xf01e92e4
f0103bf2:	c6 05 e5 92 1e f0 8e 	movb   $0x8e,0xf01e92e5
f0103bf9:	c1 e8 10             	shr    $0x10,%eax
f0103bfc:	66 a3 e6 92 1e f0    	mov    %ax,0xf01e92e6
	SETGATE(idt[IRQ_OFFSET], 0, GD_KT, th32, 0);
f0103c02:	b8 02 45 10 f0       	mov    $0xf0104502,%eax
f0103c07:	66 a3 60 93 1e f0    	mov    %ax,0xf01e9360
f0103c0d:	66 c7 05 62 93 1e f0 	movw   $0x8,0xf01e9362
f0103c14:	08 00 
f0103c16:	c6 05 64 93 1e f0 00 	movb   $0x0,0xf01e9364
f0103c1d:	c6 05 65 93 1e f0 8e 	movb   $0x8e,0xf01e9365
f0103c24:	c1 e8 10             	shr    $0x10,%eax
f0103c27:	66 a3 66 93 1e f0    	mov    %ax,0xf01e9366
	SETGATE(idt[IRQ_OFFSET + 1], 0, GD_KT, th33, 0);
f0103c2d:	b8 08 45 10 f0       	mov    $0xf0104508,%eax
f0103c32:	66 a3 68 93 1e f0    	mov    %ax,0xf01e9368
f0103c38:	66 c7 05 6a 93 1e f0 	movw   $0x8,0xf01e936a
f0103c3f:	08 00 
f0103c41:	c6 05 6c 93 1e f0 00 	movb   $0x0,0xf01e936c
f0103c48:	c6 05 6d 93 1e f0 8e 	movb   $0x8e,0xf01e936d
f0103c4f:	c1 e8 10             	shr    $0x10,%eax
f0103c52:	66 a3 6e 93 1e f0    	mov    %ax,0xf01e936e
	SETGATE(idt[IRQ_OFFSET + 2], 0, GD_KT, th34, 0);
f0103c58:	b8 0e 45 10 f0       	mov    $0xf010450e,%eax
f0103c5d:	66 a3 70 93 1e f0    	mov    %ax,0xf01e9370
f0103c63:	66 c7 05 72 93 1e f0 	movw   $0x8,0xf01e9372
f0103c6a:	08 00 
f0103c6c:	c6 05 74 93 1e f0 00 	movb   $0x0,0xf01e9374
f0103c73:	c6 05 75 93 1e f0 8e 	movb   $0x8e,0xf01e9375
f0103c7a:	c1 e8 10             	shr    $0x10,%eax
f0103c7d:	66 a3 76 93 1e f0    	mov    %ax,0xf01e9376
	SETGATE(idt[IRQ_OFFSET + 3], 0, GD_KT, th35, 0);
f0103c83:	b8 14 45 10 f0       	mov    $0xf0104514,%eax
f0103c88:	66 a3 78 93 1e f0    	mov    %ax,0xf01e9378
f0103c8e:	66 c7 05 7a 93 1e f0 	movw   $0x8,0xf01e937a
f0103c95:	08 00 
f0103c97:	c6 05 7c 93 1e f0 00 	movb   $0x0,0xf01e937c
f0103c9e:	c6 05 7d 93 1e f0 8e 	movb   $0x8e,0xf01e937d
f0103ca5:	c1 e8 10             	shr    $0x10,%eax
f0103ca8:	66 a3 7e 93 1e f0    	mov    %ax,0xf01e937e
	SETGATE(idt[IRQ_OFFSET + 4], 0, GD_KT, th36, 0);
f0103cae:	b8 1a 45 10 f0       	mov    $0xf010451a,%eax
f0103cb3:	66 a3 80 93 1e f0    	mov    %ax,0xf01e9380
f0103cb9:	66 c7 05 82 93 1e f0 	movw   $0x8,0xf01e9382
f0103cc0:	08 00 
f0103cc2:	c6 05 84 93 1e f0 00 	movb   $0x0,0xf01e9384
f0103cc9:	c6 05 85 93 1e f0 8e 	movb   $0x8e,0xf01e9385
f0103cd0:	c1 e8 10             	shr    $0x10,%eax
f0103cd3:	66 a3 86 93 1e f0    	mov    %ax,0xf01e9386
	SETGATE(idt[IRQ_OFFSET + 5], 0, GD_KT, th37, 0);
f0103cd9:	b8 20 45 10 f0       	mov    $0xf0104520,%eax
f0103cde:	66 a3 88 93 1e f0    	mov    %ax,0xf01e9388
f0103ce4:	66 c7 05 8a 93 1e f0 	movw   $0x8,0xf01e938a
f0103ceb:	08 00 
f0103ced:	c6 05 8c 93 1e f0 00 	movb   $0x0,0xf01e938c
f0103cf4:	c6 05 8d 93 1e f0 8e 	movb   $0x8e,0xf01e938d
f0103cfb:	c1 e8 10             	shr    $0x10,%eax
f0103cfe:	66 a3 8e 93 1e f0    	mov    %ax,0xf01e938e
	SETGATE(idt[IRQ_OFFSET + 6], 0, GD_KT, th38, 0);
f0103d04:	b8 26 45 10 f0       	mov    $0xf0104526,%eax
f0103d09:	66 a3 90 93 1e f0    	mov    %ax,0xf01e9390
f0103d0f:	66 c7 05 92 93 1e f0 	movw   $0x8,0xf01e9392
f0103d16:	08 00 
f0103d18:	c6 05 94 93 1e f0 00 	movb   $0x0,0xf01e9394
f0103d1f:	c6 05 95 93 1e f0 8e 	movb   $0x8e,0xf01e9395
f0103d26:	c1 e8 10             	shr    $0x10,%eax
f0103d29:	66 a3 96 93 1e f0    	mov    %ax,0xf01e9396
	SETGATE(idt[IRQ_OFFSET + 7], 0, GD_KT, th39, 0);
f0103d2f:	b8 2c 45 10 f0       	mov    $0xf010452c,%eax
f0103d34:	66 a3 98 93 1e f0    	mov    %ax,0xf01e9398
f0103d3a:	66 c7 05 9a 93 1e f0 	movw   $0x8,0xf01e939a
f0103d41:	08 00 
f0103d43:	c6 05 9c 93 1e f0 00 	movb   $0x0,0xf01e939c
f0103d4a:	c6 05 9d 93 1e f0 8e 	movb   $0x8e,0xf01e939d
f0103d51:	c1 e8 10             	shr    $0x10,%eax
f0103d54:	66 a3 9e 93 1e f0    	mov    %ax,0xf01e939e
	SETGATE(idt[IRQ_OFFSET + 8], 0, GD_KT, th40, 0);
f0103d5a:	b8 32 45 10 f0       	mov    $0xf0104532,%eax
f0103d5f:	66 a3 a0 93 1e f0    	mov    %ax,0xf01e93a0
f0103d65:	66 c7 05 a2 93 1e f0 	movw   $0x8,0xf01e93a2
f0103d6c:	08 00 
f0103d6e:	c6 05 a4 93 1e f0 00 	movb   $0x0,0xf01e93a4
f0103d75:	c6 05 a5 93 1e f0 8e 	movb   $0x8e,0xf01e93a5
f0103d7c:	c1 e8 10             	shr    $0x10,%eax
f0103d7f:	66 a3 a6 93 1e f0    	mov    %ax,0xf01e93a6
	SETGATE(idt[IRQ_OFFSET + 9], 0, GD_KT, th41, 0);
f0103d85:	b8 38 45 10 f0       	mov    $0xf0104538,%eax
f0103d8a:	66 a3 a8 93 1e f0    	mov    %ax,0xf01e93a8
f0103d90:	66 c7 05 aa 93 1e f0 	movw   $0x8,0xf01e93aa
f0103d97:	08 00 
f0103d99:	c6 05 ac 93 1e f0 00 	movb   $0x0,0xf01e93ac
f0103da0:	c6 05 ad 93 1e f0 8e 	movb   $0x8e,0xf01e93ad
f0103da7:	c1 e8 10             	shr    $0x10,%eax
f0103daa:	66 a3 ae 93 1e f0    	mov    %ax,0xf01e93ae
	SETGATE(idt[IRQ_OFFSET + 10], 0, GD_KT, th42, 0);
f0103db0:	b8 3e 45 10 f0       	mov    $0xf010453e,%eax
f0103db5:	66 a3 b0 93 1e f0    	mov    %ax,0xf01e93b0
f0103dbb:	66 c7 05 b2 93 1e f0 	movw   $0x8,0xf01e93b2
f0103dc2:	08 00 
f0103dc4:	c6 05 b4 93 1e f0 00 	movb   $0x0,0xf01e93b4
f0103dcb:	c6 05 b5 93 1e f0 8e 	movb   $0x8e,0xf01e93b5
f0103dd2:	c1 e8 10             	shr    $0x10,%eax
f0103dd5:	66 a3 b6 93 1e f0    	mov    %ax,0xf01e93b6
	SETGATE(idt[IRQ_OFFSET + 11], 0, GD_KT, th43, 0);
f0103ddb:	b8 44 45 10 f0       	mov    $0xf0104544,%eax
f0103de0:	66 a3 b8 93 1e f0    	mov    %ax,0xf01e93b8
f0103de6:	66 c7 05 ba 93 1e f0 	movw   $0x8,0xf01e93ba
f0103ded:	08 00 
f0103def:	c6 05 bc 93 1e f0 00 	movb   $0x0,0xf01e93bc
f0103df6:	c6 05 bd 93 1e f0 8e 	movb   $0x8e,0xf01e93bd
f0103dfd:	c1 e8 10             	shr    $0x10,%eax
f0103e00:	66 a3 be 93 1e f0    	mov    %ax,0xf01e93be
	SETGATE(idt[IRQ_OFFSET + 12], 0, GD_KT, th44, 0);
f0103e06:	b8 4a 45 10 f0       	mov    $0xf010454a,%eax
f0103e0b:	66 a3 c0 93 1e f0    	mov    %ax,0xf01e93c0
f0103e11:	66 c7 05 c2 93 1e f0 	movw   $0x8,0xf01e93c2
f0103e18:	08 00 
f0103e1a:	c6 05 c4 93 1e f0 00 	movb   $0x0,0xf01e93c4
f0103e21:	c6 05 c5 93 1e f0 8e 	movb   $0x8e,0xf01e93c5
f0103e28:	c1 e8 10             	shr    $0x10,%eax
f0103e2b:	66 a3 c6 93 1e f0    	mov    %ax,0xf01e93c6
	SETGATE(idt[IRQ_OFFSET + 13], 0, GD_KT, th45, 0);
f0103e31:	b8 50 45 10 f0       	mov    $0xf0104550,%eax
f0103e36:	66 a3 c8 93 1e f0    	mov    %ax,0xf01e93c8
f0103e3c:	66 c7 05 ca 93 1e f0 	movw   $0x8,0xf01e93ca
f0103e43:	08 00 
f0103e45:	c6 05 cc 93 1e f0 00 	movb   $0x0,0xf01e93cc
f0103e4c:	c6 05 cd 93 1e f0 8e 	movb   $0x8e,0xf01e93cd
f0103e53:	c1 e8 10             	shr    $0x10,%eax
f0103e56:	66 a3 ce 93 1e f0    	mov    %ax,0xf01e93ce
	SETGATE(idt[IRQ_OFFSET + 14], 0, GD_KT, th46, 0);
f0103e5c:	b8 56 45 10 f0       	mov    $0xf0104556,%eax
f0103e61:	66 a3 d0 93 1e f0    	mov    %ax,0xf01e93d0
f0103e67:	66 c7 05 d2 93 1e f0 	movw   $0x8,0xf01e93d2
f0103e6e:	08 00 
f0103e70:	c6 05 d4 93 1e f0 00 	movb   $0x0,0xf01e93d4
f0103e77:	c6 05 d5 93 1e f0 8e 	movb   $0x8e,0xf01e93d5
f0103e7e:	c1 e8 10             	shr    $0x10,%eax
f0103e81:	66 a3 d6 93 1e f0    	mov    %ax,0xf01e93d6
	SETGATE(idt[IRQ_OFFSET + 15], 0, GD_KT, th47, 0);
f0103e87:	b8 5c 45 10 f0       	mov    $0xf010455c,%eax
f0103e8c:	66 a3 d8 93 1e f0    	mov    %ax,0xf01e93d8
f0103e92:	66 c7 05 da 93 1e f0 	movw   $0x8,0xf01e93da
f0103e99:	08 00 
f0103e9b:	c6 05 dc 93 1e f0 00 	movb   $0x0,0xf01e93dc
f0103ea2:	c6 05 dd 93 1e f0 8e 	movb   $0x8e,0xf01e93dd
f0103ea9:	c1 e8 10             	shr    $0x10,%eax
f0103eac:	66 a3 de 93 1e f0    	mov    %ax,0xf01e93de
	SETGATE(idt[T_SYSCALL], 0, GD_KT, th_syscall, 3);		//为什么门的DPL要定义为3，参考《x86汇编语言-从实模式到保护模式》p345
f0103eb2:	b8 62 45 10 f0       	mov    $0xf0104562,%eax
f0103eb7:	66 a3 e0 93 1e f0    	mov    %ax,0xf01e93e0
f0103ebd:	66 c7 05 e2 93 1e f0 	movw   $0x8,0xf01e93e2
f0103ec4:	08 00 
f0103ec6:	c6 05 e4 93 1e f0 00 	movb   $0x0,0xf01e93e4
f0103ecd:	c6 05 e5 93 1e f0 ee 	movb   $0xee,0xf01e93e5
f0103ed4:	c1 e8 10             	shr    $0x10,%eax
f0103ed7:	66 a3 e6 93 1e f0    	mov    %ax,0xf01e93e6
	trap_init_percpu();
f0103edd:	e8 c5 f9 ff ff       	call   f01038a7 <trap_init_percpu>
}
f0103ee2:	c9                   	leave  
f0103ee3:	c3                   	ret    

f0103ee4 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103ee4:	55                   	push   %ebp
f0103ee5:	89 e5                	mov    %esp,%ebp
f0103ee7:	53                   	push   %ebx
f0103ee8:	83 ec 0c             	sub    $0xc,%esp
f0103eeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103eee:	ff 33                	pushl  (%ebx)
f0103ef0:	68 05 77 10 f0       	push   $0xf0107705
f0103ef5:	e8 99 f9 ff ff       	call   f0103893 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103efa:	83 c4 08             	add    $0x8,%esp
f0103efd:	ff 73 04             	pushl  0x4(%ebx)
f0103f00:	68 14 77 10 f0       	push   $0xf0107714
f0103f05:	e8 89 f9 ff ff       	call   f0103893 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103f0a:	83 c4 08             	add    $0x8,%esp
f0103f0d:	ff 73 08             	pushl  0x8(%ebx)
f0103f10:	68 23 77 10 f0       	push   $0xf0107723
f0103f15:	e8 79 f9 ff ff       	call   f0103893 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103f1a:	83 c4 08             	add    $0x8,%esp
f0103f1d:	ff 73 0c             	pushl  0xc(%ebx)
f0103f20:	68 32 77 10 f0       	push   $0xf0107732
f0103f25:	e8 69 f9 ff ff       	call   f0103893 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103f2a:	83 c4 08             	add    $0x8,%esp
f0103f2d:	ff 73 10             	pushl  0x10(%ebx)
f0103f30:	68 41 77 10 f0       	push   $0xf0107741
f0103f35:	e8 59 f9 ff ff       	call   f0103893 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103f3a:	83 c4 08             	add    $0x8,%esp
f0103f3d:	ff 73 14             	pushl  0x14(%ebx)
f0103f40:	68 50 77 10 f0       	push   $0xf0107750
f0103f45:	e8 49 f9 ff ff       	call   f0103893 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103f4a:	83 c4 08             	add    $0x8,%esp
f0103f4d:	ff 73 18             	pushl  0x18(%ebx)
f0103f50:	68 5f 77 10 f0       	push   $0xf010775f
f0103f55:	e8 39 f9 ff ff       	call   f0103893 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103f5a:	83 c4 08             	add    $0x8,%esp
f0103f5d:	ff 73 1c             	pushl  0x1c(%ebx)
f0103f60:	68 6e 77 10 f0       	push   $0xf010776e
f0103f65:	e8 29 f9 ff ff       	call   f0103893 <cprintf>
}
f0103f6a:	83 c4 10             	add    $0x10,%esp
f0103f6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103f70:	c9                   	leave  
f0103f71:	c3                   	ret    

f0103f72 <print_trapframe>:
{
f0103f72:	55                   	push   %ebp
f0103f73:	89 e5                	mov    %esp,%ebp
f0103f75:	56                   	push   %esi
f0103f76:	53                   	push   %ebx
f0103f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0103f7a:	e8 78 1e 00 00       	call   f0105df7 <cpunum>
f0103f7f:	83 ec 04             	sub    $0x4,%esp
f0103f82:	50                   	push   %eax
f0103f83:	53                   	push   %ebx
f0103f84:	68 d2 77 10 f0       	push   $0xf01077d2
f0103f89:	e8 05 f9 ff ff       	call   f0103893 <cprintf>
	print_regs(&tf->tf_regs);
f0103f8e:	89 1c 24             	mov    %ebx,(%esp)
f0103f91:	e8 4e ff ff ff       	call   f0103ee4 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103f96:	83 c4 08             	add    $0x8,%esp
f0103f99:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103f9d:	50                   	push   %eax
f0103f9e:	68 f0 77 10 f0       	push   $0xf01077f0
f0103fa3:	e8 eb f8 ff ff       	call   f0103893 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103fa8:	83 c4 08             	add    $0x8,%esp
f0103fab:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103faf:	50                   	push   %eax
f0103fb0:	68 03 78 10 f0       	push   $0xf0107803
f0103fb5:	e8 d9 f8 ff ff       	call   f0103893 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103fba:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0103fbd:	83 c4 10             	add    $0x10,%esp
f0103fc0:	83 f8 13             	cmp    $0x13,%eax
f0103fc3:	76 1f                	jbe    f0103fe4 <print_trapframe+0x72>
		return "System call";
f0103fc5:	ba 7d 77 10 f0       	mov    $0xf010777d,%edx
	if (trapno == T_SYSCALL)
f0103fca:	83 f8 30             	cmp    $0x30,%eax
f0103fcd:	74 1c                	je     f0103feb <print_trapframe+0x79>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0103fcf:	8d 50 e0             	lea    -0x20(%eax),%edx
	return "(unknown trap)";
f0103fd2:	83 fa 10             	cmp    $0x10,%edx
f0103fd5:	ba 89 77 10 f0       	mov    $0xf0107789,%edx
f0103fda:	b9 9c 77 10 f0       	mov    $0xf010779c,%ecx
f0103fdf:	0f 43 d1             	cmovae %ecx,%edx
f0103fe2:	eb 07                	jmp    f0103feb <print_trapframe+0x79>
		return excnames[trapno];
f0103fe4:	8b 14 85 c0 7a 10 f0 	mov    -0xfef8540(,%eax,4),%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103feb:	83 ec 04             	sub    $0x4,%esp
f0103fee:	52                   	push   %edx
f0103fef:	50                   	push   %eax
f0103ff0:	68 16 78 10 f0       	push   $0xf0107816
f0103ff5:	e8 99 f8 ff ff       	call   f0103893 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103ffa:	83 c4 10             	add    $0x10,%esp
f0103ffd:	39 1d 60 9a 1e f0    	cmp    %ebx,0xf01e9a60
f0104003:	0f 84 a6 00 00 00    	je     f01040af <print_trapframe+0x13d>
	cprintf("  err  0x%08x", tf->tf_err);
f0104009:	83 ec 08             	sub    $0x8,%esp
f010400c:	ff 73 2c             	pushl  0x2c(%ebx)
f010400f:	68 37 78 10 f0       	push   $0xf0107837
f0104014:	e8 7a f8 ff ff       	call   f0103893 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0104019:	83 c4 10             	add    $0x10,%esp
f010401c:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104020:	0f 85 ac 00 00 00    	jne    f01040d2 <print_trapframe+0x160>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104026:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0104029:	89 c2                	mov    %eax,%edx
f010402b:	83 e2 01             	and    $0x1,%edx
f010402e:	b9 ab 77 10 f0       	mov    $0xf01077ab,%ecx
f0104033:	ba b6 77 10 f0       	mov    $0xf01077b6,%edx
f0104038:	0f 44 ca             	cmove  %edx,%ecx
f010403b:	89 c2                	mov    %eax,%edx
f010403d:	83 e2 02             	and    $0x2,%edx
f0104040:	be c2 77 10 f0       	mov    $0xf01077c2,%esi
f0104045:	ba c8 77 10 f0       	mov    $0xf01077c8,%edx
f010404a:	0f 45 d6             	cmovne %esi,%edx
f010404d:	83 e0 04             	and    $0x4,%eax
f0104050:	b8 cd 77 10 f0       	mov    $0xf01077cd,%eax
f0104055:	be 02 79 10 f0       	mov    $0xf0107902,%esi
f010405a:	0f 44 c6             	cmove  %esi,%eax
f010405d:	51                   	push   %ecx
f010405e:	52                   	push   %edx
f010405f:	50                   	push   %eax
f0104060:	68 45 78 10 f0       	push   $0xf0107845
f0104065:	e8 29 f8 ff ff       	call   f0103893 <cprintf>
f010406a:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f010406d:	83 ec 08             	sub    $0x8,%esp
f0104070:	ff 73 30             	pushl  0x30(%ebx)
f0104073:	68 54 78 10 f0       	push   $0xf0107854
f0104078:	e8 16 f8 ff ff       	call   f0103893 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f010407d:	83 c4 08             	add    $0x8,%esp
f0104080:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104084:	50                   	push   %eax
f0104085:	68 63 78 10 f0       	push   $0xf0107863
f010408a:	e8 04 f8 ff ff       	call   f0103893 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f010408f:	83 c4 08             	add    $0x8,%esp
f0104092:	ff 73 38             	pushl  0x38(%ebx)
f0104095:	68 76 78 10 f0       	push   $0xf0107876
f010409a:	e8 f4 f7 ff ff       	call   f0103893 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f010409f:	83 c4 10             	add    $0x10,%esp
f01040a2:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01040a6:	75 3c                	jne    f01040e4 <print_trapframe+0x172>
}
f01040a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01040ab:	5b                   	pop    %ebx
f01040ac:	5e                   	pop    %esi
f01040ad:	5d                   	pop    %ebp
f01040ae:	c3                   	ret    
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01040af:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01040b3:	0f 85 50 ff ff ff    	jne    f0104009 <print_trapframe+0x97>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f01040b9:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f01040bc:	83 ec 08             	sub    $0x8,%esp
f01040bf:	50                   	push   %eax
f01040c0:	68 28 78 10 f0       	push   $0xf0107828
f01040c5:	e8 c9 f7 ff ff       	call   f0103893 <cprintf>
f01040ca:	83 c4 10             	add    $0x10,%esp
f01040cd:	e9 37 ff ff ff       	jmp    f0104009 <print_trapframe+0x97>
		cprintf("\n");
f01040d2:	83 ec 0c             	sub    $0xc,%esp
f01040d5:	68 3b 76 10 f0       	push   $0xf010763b
f01040da:	e8 b4 f7 ff ff       	call   f0103893 <cprintf>
f01040df:	83 c4 10             	add    $0x10,%esp
f01040e2:	eb 89                	jmp    f010406d <print_trapframe+0xfb>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f01040e4:	83 ec 08             	sub    $0x8,%esp
f01040e7:	ff 73 3c             	pushl  0x3c(%ebx)
f01040ea:	68 85 78 10 f0       	push   $0xf0107885
f01040ef:	e8 9f f7 ff ff       	call   f0103893 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f01040f4:	83 c4 08             	add    $0x8,%esp
f01040f7:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f01040fb:	50                   	push   %eax
f01040fc:	68 94 78 10 f0       	push   $0xf0107894
f0104101:	e8 8d f7 ff ff       	call   f0103893 <cprintf>
f0104106:	83 c4 10             	add    $0x10,%esp
}
f0104109:	eb 9d                	jmp    f01040a8 <print_trapframe+0x136>

f010410b <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f010410b:	55                   	push   %ebp
f010410c:	89 e5                	mov    %esp,%ebp
f010410e:	57                   	push   %edi
f010410f:	56                   	push   %esi
f0104110:	53                   	push   %ebx
f0104111:	83 ec 1c             	sub    $0x1c,%esp
f0104114:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104117:	0f 20 d6             	mov    %cr2,%esi
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if ((tf->tf_cs & 3) == 0)
f010411a:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010411e:	74 5d                	je     f010417d <page_fault_handler+0x72>
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	if (curenv->env_pgfault_upcall) {
f0104120:	e8 d2 1c 00 00       	call   f0105df7 <cpunum>
f0104125:	6b c0 74             	imul   $0x74,%eax,%eax
f0104128:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f010412e:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0104132:	75 60                	jne    f0104194 <page_fault_handler+0x89>
		curenv->env_tf.tf_esp = (uintptr_t)utr;
		env_run(curenv);			//重新进入用户态
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104134:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f0104137:	e8 bb 1c 00 00       	call   f0105df7 <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010413c:	57                   	push   %edi
f010413d:	56                   	push   %esi
		curenv->env_id, fault_va, tf->tf_eip);
f010413e:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104141:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104147:	ff 70 48             	pushl  0x48(%eax)
f010414a:	68 80 7a 10 f0       	push   $0xf0107a80
f010414f:	e8 3f f7 ff ff       	call   f0103893 <cprintf>
	print_trapframe(tf);
f0104154:	89 1c 24             	mov    %ebx,(%esp)
f0104157:	e8 16 fe ff ff       	call   f0103f72 <print_trapframe>
	env_destroy(curenv);
f010415c:	e8 96 1c 00 00       	call   f0105df7 <cpunum>
f0104161:	83 c4 04             	add    $0x4,%esp
f0104164:	6b c0 74             	imul   $0x74,%eax,%eax
f0104167:	ff b0 28 a0 1e f0    	pushl  -0xfe15fd8(%eax)
f010416d:	e8 5c f4 ff ff       	call   f01035ce <env_destroy>
}
f0104172:	83 c4 10             	add    $0x10,%esp
f0104175:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104178:	5b                   	pop    %ebx
f0104179:	5e                   	pop    %esi
f010417a:	5f                   	pop    %edi
f010417b:	5d                   	pop    %ebp
f010417c:	c3                   	ret    
		panic("page_fault_handler():page fault in kernel mode!\n");
f010417d:	83 ec 04             	sub    $0x4,%esp
f0104180:	68 4c 7a 10 f0       	push   $0xf0107a4c
f0104185:	68 70 01 00 00       	push   $0x170
f010418a:	68 a7 78 10 f0       	push   $0xf01078a7
f010418f:	e8 ac be ff ff       	call   f0100040 <_panic>
		if (UXSTACKTOP - PGSIZE < tf->tf_esp && tf->tf_esp < UXSTACKTOP) {
f0104194:	8b 7b 3c             	mov    0x3c(%ebx),%edi
f0104197:	8d 87 ff 0f 40 11    	lea    0x11400fff(%edi),%eax
		uintptr_t stacktop = UXSTACKTOP;
f010419d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f01041a2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f01041a7:	0f 43 f8             	cmovae %eax,%edi
		user_mem_assert(curenv, (void *)stacktop - size, size, PTE_U | PTE_W);
f01041aa:	8d 57 c8             	lea    -0x38(%edi),%edx
f01041ad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01041b0:	e8 42 1c 00 00       	call   f0105df7 <cpunum>
f01041b5:	6a 06                	push   $0x6
f01041b7:	6a 38                	push   $0x38
f01041b9:	ff 75 e4             	pushl  -0x1c(%ebp)
f01041bc:	6b c0 74             	imul   $0x74,%eax,%eax
f01041bf:	ff b0 28 a0 1e f0    	pushl  -0xfe15fd8(%eax)
f01041c5:	e8 79 ed ff ff       	call   f0102f43 <user_mem_assert>
		utr->utf_fault_va = fault_va;
f01041ca:	89 77 c8             	mov    %esi,-0x38(%edi)
		utr->utf_err = tf->tf_err;
f01041cd:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01041d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01041d3:	89 42 04             	mov    %eax,0x4(%edx)
		utr->utf_regs = tf->tf_regs;
f01041d6:	83 ef 30             	sub    $0x30,%edi
f01041d9:	b9 08 00 00 00       	mov    $0x8,%ecx
f01041de:	89 de                	mov    %ebx,%esi
f01041e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utr->utf_eip = tf->tf_eip;
f01041e2:	8b 43 30             	mov    0x30(%ebx),%eax
f01041e5:	89 42 28             	mov    %eax,0x28(%edx)
		utr->utf_eflags = tf->tf_eflags;
f01041e8:	8b 43 38             	mov    0x38(%ebx),%eax
f01041eb:	89 d6                	mov    %edx,%esi
f01041ed:	89 42 2c             	mov    %eax,0x2c(%edx)
		utr->utf_esp = tf->tf_esp;				//UXSTACKTOP栈上需要保存发生缺页异常时的%esp和%eip
f01041f0:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01041f3:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f01041f6:	e8 fc 1b 00 00       	call   f0105df7 <cpunum>
f01041fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01041fe:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104204:	8b 58 64             	mov    0x64(%eax),%ebx
f0104207:	e8 eb 1b 00 00       	call   f0105df7 <cpunum>
f010420c:	6b c0 74             	imul   $0x74,%eax,%eax
f010420f:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104215:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utr;
f0104218:	e8 da 1b 00 00       	call   f0105df7 <cpunum>
f010421d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104220:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104226:	89 70 3c             	mov    %esi,0x3c(%eax)
		env_run(curenv);			//重新进入用户态
f0104229:	e8 c9 1b 00 00       	call   f0105df7 <cpunum>
f010422e:	83 c4 04             	add    $0x4,%esp
f0104231:	6b c0 74             	imul   $0x74,%eax,%eax
f0104234:	ff b0 28 a0 1e f0    	pushl  -0xfe15fd8(%eax)
f010423a:	e8 2e f4 ff ff       	call   f010366d <env_run>

f010423f <trap>:
{
f010423f:	55                   	push   %ebp
f0104240:	89 e5                	mov    %esp,%ebp
f0104242:	57                   	push   %edi
f0104243:	56                   	push   %esi
f0104244:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104247:	fc                   	cld    
	if (panicstr)
f0104248:	83 3d 80 9e 1e f0 00 	cmpl   $0x0,0xf01e9e80
f010424f:	74 01                	je     f0104252 <trap+0x13>
		asm volatile("hlt");
f0104251:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104252:	e8 a0 1b 00 00       	call   f0105df7 <cpunum>
f0104257:	6b d0 74             	imul   $0x74,%eax,%edx
f010425a:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010425d:	b8 01 00 00 00       	mov    $0x1,%eax
f0104262:	f0 87 82 20 a0 1e f0 	lock xchg %eax,-0xfe15fe0(%edx)
f0104269:	83 f8 02             	cmp    $0x2,%eax
f010426c:	0f 84 b0 00 00 00    	je     f0104322 <trap+0xe3>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0104272:	9c                   	pushf  
f0104273:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0104274:	f6 c4 02             	test   $0x2,%ah
f0104277:	0f 85 ba 00 00 00    	jne    f0104337 <trap+0xf8>
	if ((tf->tf_cs & 3) == 3) {
f010427d:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104281:	83 e0 03             	and    $0x3,%eax
f0104284:	66 83 f8 03          	cmp    $0x3,%ax
f0104288:	0f 84 c2 00 00 00    	je     f0104350 <trap+0x111>
	last_tf = tf;
f010428e:	89 35 60 9a 1e f0    	mov    %esi,0xf01e9a60
	if (tf->tf_trapno == T_PGFLT) {
f0104294:	8b 46 28             	mov    0x28(%esi),%eax
f0104297:	83 f8 0e             	cmp    $0xe,%eax
f010429a:	0f 84 55 01 00 00    	je     f01043f5 <trap+0x1b6>
	if (tf->tf_trapno == T_BRKPT) {
f01042a0:	83 f8 03             	cmp    $0x3,%eax
f01042a3:	0f 84 5d 01 00 00    	je     f0104406 <trap+0x1c7>
	if (tf->tf_trapno == T_SYSCALL) {
f01042a9:	83 f8 30             	cmp    $0x30,%eax
f01042ac:	0f 84 65 01 00 00    	je     f0104417 <trap+0x1d8>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f01042b2:	83 f8 27             	cmp    $0x27,%eax
f01042b5:	0f 84 80 01 00 00    	je     f010443b <trap+0x1fc>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f01042bb:	83 f8 20             	cmp    $0x20,%eax
f01042be:	0f 84 94 01 00 00    	je     f0104458 <trap+0x219>
	print_trapframe(tf);
f01042c4:	83 ec 0c             	sub    $0xc,%esp
f01042c7:	56                   	push   %esi
f01042c8:	e8 a5 fc ff ff       	call   f0103f72 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f01042cd:	83 c4 10             	add    $0x10,%esp
f01042d0:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f01042d5:	0f 84 87 01 00 00    	je     f0104462 <trap+0x223>
		env_destroy(curenv);
f01042db:	e8 17 1b 00 00       	call   f0105df7 <cpunum>
f01042e0:	83 ec 0c             	sub    $0xc,%esp
f01042e3:	6b c0 74             	imul   $0x74,%eax,%eax
f01042e6:	ff b0 28 a0 1e f0    	pushl  -0xfe15fd8(%eax)
f01042ec:	e8 dd f2 ff ff       	call   f01035ce <env_destroy>
f01042f1:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f01042f4:	e8 fe 1a 00 00       	call   f0105df7 <cpunum>
f01042f9:	6b c0 74             	imul   $0x74,%eax,%eax
f01042fc:	83 b8 28 a0 1e f0 00 	cmpl   $0x0,-0xfe15fd8(%eax)
f0104303:	74 18                	je     f010431d <trap+0xde>
f0104305:	e8 ed 1a 00 00       	call   f0105df7 <cpunum>
f010430a:	6b c0 74             	imul   $0x74,%eax,%eax
f010430d:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104313:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104317:	0f 84 5c 01 00 00    	je     f0104479 <trap+0x23a>
		sched_yield();
f010431d:	e8 27 03 00 00       	call   f0104649 <sched_yield>
	spin_lock(&kernel_lock);
f0104322:	83 ec 0c             	sub    $0xc,%esp
f0104325:	68 c0 23 12 f0       	push   $0xf01223c0
f010432a:	e8 38 1d 00 00       	call   f0106067 <spin_lock>
f010432f:	83 c4 10             	add    $0x10,%esp
f0104332:	e9 3b ff ff ff       	jmp    f0104272 <trap+0x33>
	assert(!(read_eflags() & FL_IF));
f0104337:	68 b3 78 10 f0       	push   $0xf01078b3
f010433c:	68 6f 73 10 f0       	push   $0xf010736f
f0104341:	68 3a 01 00 00       	push   $0x13a
f0104346:	68 a7 78 10 f0       	push   $0xf01078a7
f010434b:	e8 f0 bc ff ff       	call   f0100040 <_panic>
		assert(curenv);
f0104350:	e8 a2 1a 00 00       	call   f0105df7 <cpunum>
f0104355:	6b c0 74             	imul   $0x74,%eax,%eax
f0104358:	83 b8 28 a0 1e f0 00 	cmpl   $0x0,-0xfe15fd8(%eax)
f010435f:	74 4e                	je     f01043af <trap+0x170>
f0104361:	83 ec 0c             	sub    $0xc,%esp
f0104364:	68 c0 23 12 f0       	push   $0xf01223c0
f0104369:	e8 f9 1c 00 00       	call   f0106067 <spin_lock>
		if (curenv->env_status == ENV_DYING) {
f010436e:	e8 84 1a 00 00       	call   f0105df7 <cpunum>
f0104373:	6b c0 74             	imul   $0x74,%eax,%eax
f0104376:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f010437c:	83 c4 10             	add    $0x10,%esp
f010437f:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104383:	74 43                	je     f01043c8 <trap+0x189>
		curenv->env_tf = *tf;								//将栈上的Trapframe结构拷贝一份到curenv指向的ENV结构中
f0104385:	e8 6d 1a 00 00       	call   f0105df7 <cpunum>
f010438a:	6b c0 74             	imul   $0x74,%eax,%eax
f010438d:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104393:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104398:	89 c7                	mov    %eax,%edi
f010439a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f010439c:	e8 56 1a 00 00       	call   f0105df7 <cpunum>
f01043a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01043a4:	8b b0 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%esi
f01043aa:	e9 df fe ff ff       	jmp    f010428e <trap+0x4f>
		assert(curenv);
f01043af:	68 cc 78 10 f0       	push   $0xf01078cc
f01043b4:	68 6f 73 10 f0       	push   $0xf010736f
f01043b9:	68 41 01 00 00       	push   $0x141
f01043be:	68 a7 78 10 f0       	push   $0xf01078a7
f01043c3:	e8 78 bc ff ff       	call   f0100040 <_panic>
			env_free(curenv);
f01043c8:	e8 2a 1a 00 00       	call   f0105df7 <cpunum>
f01043cd:	83 ec 0c             	sub    $0xc,%esp
f01043d0:	6b c0 74             	imul   $0x74,%eax,%eax
f01043d3:	ff b0 28 a0 1e f0    	pushl  -0xfe15fd8(%eax)
f01043d9:	e8 02 f0 ff ff       	call   f01033e0 <env_free>
			curenv = NULL;
f01043de:	e8 14 1a 00 00       	call   f0105df7 <cpunum>
f01043e3:	6b c0 74             	imul   $0x74,%eax,%eax
f01043e6:	c7 80 28 a0 1e f0 00 	movl   $0x0,-0xfe15fd8(%eax)
f01043ed:	00 00 00 
			sched_yield();
f01043f0:	e8 54 02 00 00       	call   f0104649 <sched_yield>
		page_fault_handler(tf);
f01043f5:	83 ec 0c             	sub    $0xc,%esp
f01043f8:	56                   	push   %esi
f01043f9:	e8 0d fd ff ff       	call   f010410b <page_fault_handler>
f01043fe:	83 c4 10             	add    $0x10,%esp
f0104401:	e9 ee fe ff ff       	jmp    f01042f4 <trap+0xb5>
		monitor(tf);
f0104406:	83 ec 0c             	sub    $0xc,%esp
f0104409:	56                   	push   %esi
f010440a:	e8 21 c5 ff ff       	call   f0100930 <monitor>
f010440f:	83 c4 10             	add    $0x10,%esp
f0104412:	e9 dd fe ff ff       	jmp    f01042f4 <trap+0xb5>
		tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx,
f0104417:	83 ec 08             	sub    $0x8,%esp
f010441a:	ff 76 04             	pushl  0x4(%esi)
f010441d:	ff 36                	pushl  (%esi)
f010441f:	ff 76 10             	pushl  0x10(%esi)
f0104422:	ff 76 18             	pushl  0x18(%esi)
f0104425:	ff 76 14             	pushl  0x14(%esi)
f0104428:	ff 76 1c             	pushl  0x1c(%esi)
f010442b:	e8 d0 02 00 00       	call   f0104700 <syscall>
f0104430:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104433:	83 c4 20             	add    $0x20,%esp
f0104436:	e9 b9 fe ff ff       	jmp    f01042f4 <trap+0xb5>
		cprintf("Spurious interrupt on irq 7\n");
f010443b:	83 ec 0c             	sub    $0xc,%esp
f010443e:	68 d3 78 10 f0       	push   $0xf01078d3
f0104443:	e8 4b f4 ff ff       	call   f0103893 <cprintf>
		print_trapframe(tf);
f0104448:	89 34 24             	mov    %esi,(%esp)
f010444b:	e8 22 fb ff ff       	call   f0103f72 <print_trapframe>
f0104450:	83 c4 10             	add    $0x10,%esp
f0104453:	e9 9c fe ff ff       	jmp    f01042f4 <trap+0xb5>
		lapic_eoi();
f0104458:	e8 e6 1a 00 00       	call   f0105f43 <lapic_eoi>
		sched_yield();
f010445d:	e8 e7 01 00 00       	call   f0104649 <sched_yield>
		panic("unhandled trap in kernel");
f0104462:	83 ec 04             	sub    $0x4,%esp
f0104465:	68 f0 78 10 f0       	push   $0xf01078f0
f010446a:	68 20 01 00 00       	push   $0x120
f010446f:	68 a7 78 10 f0       	push   $0xf01078a7
f0104474:	e8 c7 bb ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f0104479:	e8 79 19 00 00       	call   f0105df7 <cpunum>
f010447e:	83 ec 0c             	sub    $0xc,%esp
f0104481:	6b c0 74             	imul   $0x74,%eax,%eax
f0104484:	ff b0 28 a0 1e f0    	pushl  -0xfe15fd8(%eax)
f010448a:	e8 de f1 ff ff       	call   f010366d <env_run>
f010448f:	90                   	nop

f0104490 <th0>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(th0, 0)
f0104490:	6a 00                	push   $0x0
f0104492:	6a 00                	push   $0x0
f0104494:	e9 cf 00 00 00       	jmp    f0104568 <_alltraps>
f0104499:	90                   	nop

f010449a <th1>:
	TRAPHANDLER_NOEC(th1, 1)
f010449a:	6a 00                	push   $0x0
f010449c:	6a 01                	push   $0x1
f010449e:	e9 c5 00 00 00       	jmp    f0104568 <_alltraps>
f01044a3:	90                   	nop

f01044a4 <th3>:
	TRAPHANDLER_NOEC(th3, 3)
f01044a4:	6a 00                	push   $0x0
f01044a6:	6a 03                	push   $0x3
f01044a8:	e9 bb 00 00 00       	jmp    f0104568 <_alltraps>
f01044ad:	90                   	nop

f01044ae <th4>:
	TRAPHANDLER_NOEC(th4, 4)
f01044ae:	6a 00                	push   $0x0
f01044b0:	6a 04                	push   $0x4
f01044b2:	e9 b1 00 00 00       	jmp    f0104568 <_alltraps>
f01044b7:	90                   	nop

f01044b8 <th5>:
	TRAPHANDLER_NOEC(th5, 5)
f01044b8:	6a 00                	push   $0x0
f01044ba:	6a 05                	push   $0x5
f01044bc:	e9 a7 00 00 00       	jmp    f0104568 <_alltraps>
f01044c1:	90                   	nop

f01044c2 <th6>:
	TRAPHANDLER_NOEC(th6, 6)
f01044c2:	6a 00                	push   $0x0
f01044c4:	6a 06                	push   $0x6
f01044c6:	e9 9d 00 00 00       	jmp    f0104568 <_alltraps>
f01044cb:	90                   	nop

f01044cc <th7>:
	TRAPHANDLER_NOEC(th7, 7)
f01044cc:	6a 00                	push   $0x0
f01044ce:	6a 07                	push   $0x7
f01044d0:	e9 93 00 00 00       	jmp    f0104568 <_alltraps>
f01044d5:	90                   	nop

f01044d6 <th8>:
	TRAPHANDLER(th8, 8)
f01044d6:	6a 08                	push   $0x8
f01044d8:	e9 8b 00 00 00       	jmp    f0104568 <_alltraps>
f01044dd:	90                   	nop

f01044de <th9>:
	TRAPHANDLER_NOEC(th9, 9)
f01044de:	6a 00                	push   $0x0
f01044e0:	6a 09                	push   $0x9
f01044e2:	e9 81 00 00 00       	jmp    f0104568 <_alltraps>
f01044e7:	90                   	nop

f01044e8 <th10>:
	TRAPHANDLER(th10, 10)
f01044e8:	6a 0a                	push   $0xa
f01044ea:	eb 7c                	jmp    f0104568 <_alltraps>

f01044ec <th11>:
	TRAPHANDLER(th11, 11)
f01044ec:	6a 0b                	push   $0xb
f01044ee:	eb 78                	jmp    f0104568 <_alltraps>

f01044f0 <th12>:
	TRAPHANDLER(th12, 12)
f01044f0:	6a 0c                	push   $0xc
f01044f2:	eb 74                	jmp    f0104568 <_alltraps>

f01044f4 <th13>:
	TRAPHANDLER(th13, 13)
f01044f4:	6a 0d                	push   $0xd
f01044f6:	eb 70                	jmp    f0104568 <_alltraps>

f01044f8 <th14>:
	TRAPHANDLER(th14, 14)
f01044f8:	6a 0e                	push   $0xe
f01044fa:	eb 6c                	jmp    f0104568 <_alltraps>

f01044fc <th16>:
	TRAPHANDLER_NOEC(th16, 16)
f01044fc:	6a 00                	push   $0x0
f01044fe:	6a 10                	push   $0x10
f0104500:	eb 66                	jmp    f0104568 <_alltraps>

f0104502 <th32>:

	TRAPHANDLER_NOEC(th32, IRQ_OFFSET)
f0104502:	6a 00                	push   $0x0
f0104504:	6a 20                	push   $0x20
f0104506:	eb 60                	jmp    f0104568 <_alltraps>

f0104508 <th33>:
	TRAPHANDLER_NOEC(th33, IRQ_OFFSET + 1)
f0104508:	6a 00                	push   $0x0
f010450a:	6a 21                	push   $0x21
f010450c:	eb 5a                	jmp    f0104568 <_alltraps>

f010450e <th34>:
	TRAPHANDLER_NOEC(th34, IRQ_OFFSET + 2)
f010450e:	6a 00                	push   $0x0
f0104510:	6a 22                	push   $0x22
f0104512:	eb 54                	jmp    f0104568 <_alltraps>

f0104514 <th35>:
	TRAPHANDLER_NOEC(th35, IRQ_OFFSET + 3)
f0104514:	6a 00                	push   $0x0
f0104516:	6a 23                	push   $0x23
f0104518:	eb 4e                	jmp    f0104568 <_alltraps>

f010451a <th36>:
	TRAPHANDLER_NOEC(th36, IRQ_OFFSET + 4)
f010451a:	6a 00                	push   $0x0
f010451c:	6a 24                	push   $0x24
f010451e:	eb 48                	jmp    f0104568 <_alltraps>

f0104520 <th37>:
	TRAPHANDLER_NOEC(th37, IRQ_OFFSET + 5)
f0104520:	6a 00                	push   $0x0
f0104522:	6a 25                	push   $0x25
f0104524:	eb 42                	jmp    f0104568 <_alltraps>

f0104526 <th38>:
	TRAPHANDLER_NOEC(th38, IRQ_OFFSET + 6)
f0104526:	6a 00                	push   $0x0
f0104528:	6a 26                	push   $0x26
f010452a:	eb 3c                	jmp    f0104568 <_alltraps>

f010452c <th39>:
	TRAPHANDLER_NOEC(th39, IRQ_OFFSET + 7)
f010452c:	6a 00                	push   $0x0
f010452e:	6a 27                	push   $0x27
f0104530:	eb 36                	jmp    f0104568 <_alltraps>

f0104532 <th40>:
	TRAPHANDLER_NOEC(th40, IRQ_OFFSET + 8)
f0104532:	6a 00                	push   $0x0
f0104534:	6a 28                	push   $0x28
f0104536:	eb 30                	jmp    f0104568 <_alltraps>

f0104538 <th41>:
	TRAPHANDLER_NOEC(th41, IRQ_OFFSET + 9)
f0104538:	6a 00                	push   $0x0
f010453a:	6a 29                	push   $0x29
f010453c:	eb 2a                	jmp    f0104568 <_alltraps>

f010453e <th42>:
	TRAPHANDLER_NOEC(th42, IRQ_OFFSET + 10)
f010453e:	6a 00                	push   $0x0
f0104540:	6a 2a                	push   $0x2a
f0104542:	eb 24                	jmp    f0104568 <_alltraps>

f0104544 <th43>:
	TRAPHANDLER_NOEC(th43, IRQ_OFFSET + 11)
f0104544:	6a 00                	push   $0x0
f0104546:	6a 2b                	push   $0x2b
f0104548:	eb 1e                	jmp    f0104568 <_alltraps>

f010454a <th44>:
	TRAPHANDLER_NOEC(th44, IRQ_OFFSET + 12)
f010454a:	6a 00                	push   $0x0
f010454c:	6a 2c                	push   $0x2c
f010454e:	eb 18                	jmp    f0104568 <_alltraps>

f0104550 <th45>:
	TRAPHANDLER_NOEC(th45, IRQ_OFFSET + 13)
f0104550:	6a 00                	push   $0x0
f0104552:	6a 2d                	push   $0x2d
f0104554:	eb 12                	jmp    f0104568 <_alltraps>

f0104556 <th46>:
	TRAPHANDLER_NOEC(th46, IRQ_OFFSET + 14)
f0104556:	6a 00                	push   $0x0
f0104558:	6a 2e                	push   $0x2e
f010455a:	eb 0c                	jmp    f0104568 <_alltraps>

f010455c <th47>:
	TRAPHANDLER_NOEC(th47, IRQ_OFFSET + 15)
f010455c:	6a 00                	push   $0x0
f010455e:	6a 2f                	push   $0x2f
f0104560:	eb 06                	jmp    f0104568 <_alltraps>

f0104562 <th_syscall>:

	TRAPHANDLER_NOEC(th_syscall, T_SYSCALL)
f0104562:	6a 00                	push   $0x0
f0104564:	6a 30                	push   $0x30
f0104566:	eb 00                	jmp    f0104568 <_alltraps>

f0104568 <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */
	//参考inc/trap.h中的Trapframe结构。tf_ss，tf_esp，tf_eflags，tf_cs，tf_eip，tf_err由处理器压入，所以现在只需要压入剩下寄存器（%ds,%es,通用寄存器）
	//切换到内核数据段
	_alltraps:
	pushl %ds
f0104568:	1e                   	push   %ds
	pushl %es
f0104569:	06                   	push   %es
	pushal
f010456a:	60                   	pusha  
	pushl $GD_KD
f010456b:	6a 10                	push   $0x10
	popl %ds
f010456d:	1f                   	pop    %ds
	pushl $GD_KD
f010456e:	6a 10                	push   $0x10
	popl %es
f0104570:	07                   	pop    %es
	pushl %esp				//压入trap()的参数tf，%esp指向Trapframe结构的起始地址
f0104571:	54                   	push   %esp
	call trap
f0104572:	e8 c8 fc ff ff       	call   f010423f <trap>

f0104577 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104577:	55                   	push   %ebp
f0104578:	89 e5                	mov    %esp,%ebp
f010457a:	83 ec 08             	sub    $0x8,%esp
f010457d:	a1 44 92 1e f0       	mov    0xf01e9244,%eax
f0104582:	83 c0 54             	add    $0x54,%eax
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104585:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f010458a:	8b 10                	mov    (%eax),%edx
f010458c:	83 ea 01             	sub    $0x1,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f010458f:	83 fa 02             	cmp    $0x2,%edx
f0104592:	76 2d                	jbe    f01045c1 <sched_halt+0x4a>
	for (i = 0; i < NENV; i++) {
f0104594:	83 c1 01             	add    $0x1,%ecx
f0104597:	83 c0 7c             	add    $0x7c,%eax
f010459a:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01045a0:	75 e8                	jne    f010458a <sched_halt+0x13>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f01045a2:	83 ec 0c             	sub    $0xc,%esp
f01045a5:	68 10 7b 10 f0       	push   $0xf0107b10
f01045aa:	e8 e4 f2 ff ff       	call   f0103893 <cprintf>
f01045af:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f01045b2:	83 ec 0c             	sub    $0xc,%esp
f01045b5:	6a 00                	push   $0x0
f01045b7:	e8 74 c3 ff ff       	call   f0100930 <monitor>
f01045bc:	83 c4 10             	add    $0x10,%esp
f01045bf:	eb f1                	jmp    f01045b2 <sched_halt+0x3b>
	if (i == NENV) {
f01045c1:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01045c7:	74 d9                	je     f01045a2 <sched_halt+0x2b>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f01045c9:	e8 29 18 00 00       	call   f0105df7 <cpunum>
f01045ce:	6b c0 74             	imul   $0x74,%eax,%eax
f01045d1:	c7 80 28 a0 1e f0 00 	movl   $0x0,-0xfe15fd8(%eax)
f01045d8:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f01045db:	a1 8c 9e 1e f0       	mov    0xf01e9e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01045e0:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01045e5:	76 50                	jbe    f0104637 <sched_halt+0xc0>
	return (physaddr_t)kva - KERNBASE;
f01045e7:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01045ec:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f01045ef:	e8 03 18 00 00       	call   f0105df7 <cpunum>
f01045f4:	6b d0 74             	imul   $0x74,%eax,%edx
f01045f7:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01045fa:	b8 02 00 00 00       	mov    $0x2,%eax
f01045ff:	f0 87 82 20 a0 1e f0 	lock xchg %eax,-0xfe15fe0(%edx)
	spin_unlock(&kernel_lock);
f0104606:	83 ec 0c             	sub    $0xc,%esp
f0104609:	68 c0 23 12 f0       	push   $0xf01223c0
f010460e:	e8 f1 1a 00 00       	call   f0106104 <spin_unlock>
	asm volatile("pause");
f0104613:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104615:	e8 dd 17 00 00       	call   f0105df7 <cpunum>
f010461a:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f010461d:	8b 80 30 a0 1e f0    	mov    -0xfe15fd0(%eax),%eax
f0104623:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104628:	89 c4                	mov    %eax,%esp
f010462a:	6a 00                	push   $0x0
f010462c:	6a 00                	push   $0x0
f010462e:	fb                   	sti    
f010462f:	f4                   	hlt    
f0104630:	eb fd                	jmp    f010462f <sched_halt+0xb8>
}
f0104632:	83 c4 10             	add    $0x10,%esp
f0104635:	c9                   	leave  
f0104636:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104637:	50                   	push   %eax
f0104638:	68 88 64 10 f0       	push   $0xf0106488
f010463d:	6a 4b                	push   $0x4b
f010463f:	68 39 7b 10 f0       	push   $0xf0107b39
f0104644:	e8 f7 b9 ff ff       	call   f0100040 <_panic>

f0104649 <sched_yield>:
{
f0104649:	55                   	push   %ebp
f010464a:	89 e5                	mov    %esp,%ebp
f010464c:	56                   	push   %esi
f010464d:	53                   	push   %ebx
	if (curenv) {
f010464e:	e8 a4 17 00 00       	call   f0105df7 <cpunum>
f0104653:	6b c0 74             	imul   $0x74,%eax,%eax
	int start = 0;
f0104656:	b9 00 00 00 00       	mov    $0x0,%ecx
	if (curenv) {
f010465b:	83 b8 28 a0 1e f0 00 	cmpl   $0x0,-0xfe15fd8(%eax)
f0104662:	74 1a                	je     f010467e <sched_yield+0x35>
		start = ENVX(curenv->env_id) + 1;	//从当前Env结构的后一个开始
f0104664:	e8 8e 17 00 00       	call   f0105df7 <cpunum>
f0104669:	6b c0 74             	imul   $0x74,%eax,%eax
f010466c:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104672:	8b 48 48             	mov    0x48(%eax),%ecx
f0104675:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
f010467b:	83 c1 01             	add    $0x1,%ecx
		if (envs[j].env_status == ENV_RUNNABLE) {
f010467e:	8b 1d 44 92 1e f0    	mov    0xf01e9244,%ebx
f0104684:	89 ca                	mov    %ecx,%edx
f0104686:	81 c1 00 04 00 00    	add    $0x400,%ecx
		j = (start + i) % NENV;
f010468c:	89 d6                	mov    %edx,%esi
f010468e:	c1 fe 1f             	sar    $0x1f,%esi
f0104691:	c1 ee 16             	shr    $0x16,%esi
f0104694:	8d 04 32             	lea    (%edx,%esi,1),%eax
f0104697:	25 ff 03 00 00       	and    $0x3ff,%eax
f010469c:	29 f0                	sub    %esi,%eax
		if (envs[j].env_status == ENV_RUNNABLE) {
f010469e:	6b c0 7c             	imul   $0x7c,%eax,%eax
f01046a1:	01 d8                	add    %ebx,%eax
f01046a3:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01046a7:	74 38                	je     f01046e1 <sched_yield+0x98>
f01046a9:	83 c2 01             	add    $0x1,%edx
	for (int i = 0; i < NENV; i++) {		//遍历所有Env结构
f01046ac:	39 ca                	cmp    %ecx,%edx
f01046ae:	75 dc                	jne    f010468c <sched_yield+0x43>
	if (curenv && curenv->env_status == ENV_RUNNING) {
f01046b0:	e8 42 17 00 00       	call   f0105df7 <cpunum>
f01046b5:	6b c0 74             	imul   $0x74,%eax,%eax
f01046b8:	83 b8 28 a0 1e f0 00 	cmpl   $0x0,-0xfe15fd8(%eax)
f01046bf:	74 14                	je     f01046d5 <sched_yield+0x8c>
f01046c1:	e8 31 17 00 00       	call   f0105df7 <cpunum>
f01046c6:	6b c0 74             	imul   $0x74,%eax,%eax
f01046c9:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f01046cf:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01046d3:	74 15                	je     f01046ea <sched_yield+0xa1>
	sched_halt();
f01046d5:	e8 9d fe ff ff       	call   f0104577 <sched_halt>
}
f01046da:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01046dd:	5b                   	pop    %ebx
f01046de:	5e                   	pop    %esi
f01046df:	5d                   	pop    %ebp
f01046e0:	c3                   	ret    
			env_run(&envs[j]);
f01046e1:	83 ec 0c             	sub    $0xc,%esp
f01046e4:	50                   	push   %eax
f01046e5:	e8 83 ef ff ff       	call   f010366d <env_run>
		env_run(curenv);
f01046ea:	e8 08 17 00 00       	call   f0105df7 <cpunum>
f01046ef:	83 ec 0c             	sub    $0xc,%esp
f01046f2:	6b c0 74             	imul   $0x74,%eax,%eax
f01046f5:	ff b0 28 a0 1e f0    	pushl  -0xfe15fd8(%eax)
f01046fb:	e8 6d ef ff ff       	call   f010366d <env_run>

f0104700 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104700:	55                   	push   %ebp
f0104701:	89 e5                	mov    %esp,%ebp
f0104703:	57                   	push   %edi
f0104704:	56                   	push   %esi
f0104705:	53                   	push   %ebx
f0104706:	83 ec 1c             	sub    $0x1c,%esp
f0104709:	8b 45 08             	mov    0x8(%ebp),%eax
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
	int32_t ret;
	switch (syscallno) {
f010470c:	83 f8 0d             	cmp    $0xd,%eax
f010470f:	0f 87 28 05 00 00    	ja     f0104c3d <syscall+0x53d>
f0104715:	ff 24 85 80 7b 10 f0 	jmp    *-0xfef8480(,%eax,4)
	user_mem_assert(curenv, s, len, 0);
f010471c:	e8 d6 16 00 00       	call   f0105df7 <cpunum>
f0104721:	6a 00                	push   $0x0
f0104723:	ff 75 10             	pushl  0x10(%ebp)
f0104726:	ff 75 0c             	pushl  0xc(%ebp)
f0104729:	6b c0 74             	imul   $0x74,%eax,%eax
f010472c:	ff b0 28 a0 1e f0    	pushl  -0xfe15fd8(%eax)
f0104732:	e8 0c e8 ff ff       	call   f0102f43 <user_mem_assert>
	cprintf("%.*s", len, s);
f0104737:	83 c4 0c             	add    $0xc,%esp
f010473a:	ff 75 0c             	pushl  0xc(%ebp)
f010473d:	ff 75 10             	pushl  0x10(%ebp)
f0104740:	68 46 7b 10 f0       	push   $0xf0107b46
f0104745:	e8 49 f1 ff ff       	call   f0103893 <cprintf>
f010474a:	83 c4 10             	add    $0x10,%esp
		case SYS_cputs:
			sys_cputs((char *)a1, (size_t)a2);
			ret = 0;
f010474d:	bb 00 00 00 00       	mov    $0x0,%ebx
		default:
			return -E_INVAL;
	}

	return ret;
}
f0104752:	89 d8                	mov    %ebx,%eax
f0104754:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104757:	5b                   	pop    %ebx
f0104758:	5e                   	pop    %esi
f0104759:	5f                   	pop    %edi
f010475a:	5d                   	pop    %ebp
f010475b:	c3                   	ret    
	return cons_getc();
f010475c:	e8 ac be ff ff       	call   f010060d <cons_getc>
f0104761:	89 c3                	mov    %eax,%ebx
			break;
f0104763:	eb ed                	jmp    f0104752 <syscall+0x52>
	return curenv->env_id;
f0104765:	e8 8d 16 00 00       	call   f0105df7 <cpunum>
f010476a:	6b c0 74             	imul   $0x74,%eax,%eax
f010476d:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104773:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f0104776:	eb da                	jmp    f0104752 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104778:	83 ec 04             	sub    $0x4,%esp
f010477b:	6a 01                	push   $0x1
f010477d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104780:	50                   	push   %eax
f0104781:	ff 75 0c             	pushl  0xc(%ebp)
f0104784:	e8 71 e8 ff ff       	call   f0102ffa <envid2env>
f0104789:	89 c3                	mov    %eax,%ebx
f010478b:	83 c4 10             	add    $0x10,%esp
f010478e:	85 c0                	test   %eax,%eax
f0104790:	78 c0                	js     f0104752 <syscall+0x52>
    if (e == curenv)
f0104792:	e8 60 16 00 00       	call   f0105df7 <cpunum>
f0104797:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010479a:	6b c0 74             	imul   $0x74,%eax,%eax
f010479d:	39 90 28 a0 1e f0    	cmp    %edx,-0xfe15fd8(%eax)
f01047a3:	74 3d                	je     f01047e2 <syscall+0xe2>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01047a5:	8b 5a 48             	mov    0x48(%edx),%ebx
f01047a8:	e8 4a 16 00 00       	call   f0105df7 <cpunum>
f01047ad:	83 ec 04             	sub    $0x4,%esp
f01047b0:	53                   	push   %ebx
f01047b1:	6b c0 74             	imul   $0x74,%eax,%eax
f01047b4:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f01047ba:	ff 70 48             	pushl  0x48(%eax)
f01047bd:	68 66 7b 10 f0       	push   $0xf0107b66
f01047c2:	e8 cc f0 ff ff       	call   f0103893 <cprintf>
f01047c7:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f01047ca:	83 ec 0c             	sub    $0xc,%esp
f01047cd:	ff 75 e4             	pushl  -0x1c(%ebp)
f01047d0:	e8 f9 ed ff ff       	call   f01035ce <env_destroy>
f01047d5:	83 c4 10             	add    $0x10,%esp
	return 0;
f01047d8:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f01047dd:	e9 70 ff ff ff       	jmp    f0104752 <syscall+0x52>
        cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01047e2:	e8 10 16 00 00       	call   f0105df7 <cpunum>
f01047e7:	83 ec 08             	sub    $0x8,%esp
f01047ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01047ed:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f01047f3:	ff 70 48             	pushl  0x48(%eax)
f01047f6:	68 4b 7b 10 f0       	push   $0xf0107b4b
f01047fb:	e8 93 f0 ff ff       	call   f0103893 <cprintf>
f0104800:	83 c4 10             	add    $0x10,%esp
f0104803:	eb c5                	jmp    f01047ca <syscall+0xca>
	sched_yield();
f0104805:	e8 3f fe ff ff       	call   f0104649 <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f010480a:	e8 e8 15 00 00       	call   f0105df7 <cpunum>
f010480f:	83 ec 08             	sub    $0x8,%esp
f0104812:	6b c0 74             	imul   $0x74,%eax,%eax
f0104815:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f010481b:	ff 70 48             	pushl  0x48(%eax)
f010481e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104821:	50                   	push   %eax
f0104822:	e8 dd e8 ff ff       	call   f0103104 <env_alloc>
f0104827:	89 c3                	mov    %eax,%ebx
	if (ret < 0) {
f0104829:	83 c4 10             	add    $0x10,%esp
f010482c:	85 c0                	test   %eax,%eax
f010482e:	0f 88 1e ff ff ff    	js     f0104752 <syscall+0x52>
	e->env_tf = curenv->env_tf;			//寄存器状态和当前用户环境一致
f0104834:	e8 be 15 00 00       	call   f0105df7 <cpunum>
f0104839:	6b c0 74             	imul   $0x74,%eax,%eax
f010483c:	8b b0 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%esi
f0104842:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104847:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010484a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_status = ENV_NOT_RUNNABLE;
f010484c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010484f:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf.tf_regs.reg_eax = 0;		//新的用户环境从sys_exofork()的返回值应该为0
f0104856:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f010485d:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f0104860:	e9 ed fe ff ff       	jmp    f0104752 <syscall+0x52>
	if (status != ENV_NOT_RUNNABLE && status != ENV_RUNNABLE) return -E_INVAL;
f0104865:	8b 45 10             	mov    0x10(%ebp),%eax
f0104868:	83 e8 02             	sub    $0x2,%eax
f010486b:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f0104870:	75 31                	jne    f01048a3 <syscall+0x1a3>
	int ret = envid2env(envid, &e, 1);
f0104872:	83 ec 04             	sub    $0x4,%esp
f0104875:	6a 01                	push   $0x1
f0104877:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010487a:	50                   	push   %eax
f010487b:	ff 75 0c             	pushl  0xc(%ebp)
f010487e:	e8 77 e7 ff ff       	call   f0102ffa <envid2env>
f0104883:	89 c3                	mov    %eax,%ebx
	if (ret < 0) {
f0104885:	83 c4 10             	add    $0x10,%esp
f0104888:	85 c0                	test   %eax,%eax
f010488a:	0f 88 c2 fe ff ff    	js     f0104752 <syscall+0x52>
	e->env_status = status;
f0104890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104893:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104896:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f0104899:	bb 00 00 00 00       	mov    $0x0,%ebx
f010489e:	e9 af fe ff ff       	jmp    f0104752 <syscall+0x52>
	if (status != ENV_NOT_RUNNABLE && status != ENV_RUNNABLE) return -E_INVAL;
f01048a3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f01048a8:	e9 a5 fe ff ff       	jmp    f0104752 <syscall+0x52>
	int ret = envid2env(envid, &e, 1);
f01048ad:	83 ec 04             	sub    $0x4,%esp
f01048b0:	6a 01                	push   $0x1
f01048b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01048b5:	50                   	push   %eax
f01048b6:	ff 75 0c             	pushl  0xc(%ebp)
f01048b9:	e8 3c e7 ff ff       	call   f0102ffa <envid2env>
f01048be:	89 c3                	mov    %eax,%ebx
	if (ret) return ret;	//bad_env
f01048c0:	83 c4 10             	add    $0x10,%esp
f01048c3:	85 c0                	test   %eax,%eax
f01048c5:	0f 85 87 fe ff ff    	jne    f0104752 <syscall+0x52>
	if ((va >= (void*)UTOP) || (ROUNDDOWN(va, PGSIZE) != va)) return -E_INVAL;		//一系列判定
f01048cb:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f01048d2:	77 57                	ja     f010492b <syscall+0x22b>
f01048d4:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f01048db:	75 58                	jne    f0104935 <syscall+0x235>
	if ((perm & flag) != flag) return -E_INVAL;
f01048dd:	8b 45 14             	mov    0x14(%ebp),%eax
f01048e0:	83 e0 05             	and    $0x5,%eax
f01048e3:	83 f8 05             	cmp    $0x5,%eax
f01048e6:	75 57                	jne    f010493f <syscall+0x23f>
	struct PageInfo *pg = page_alloc(1);			//分配物理页
f01048e8:	83 ec 0c             	sub    $0xc,%esp
f01048eb:	6a 01                	push   $0x1
f01048ed:	e8 2e c6 ff ff       	call   f0100f20 <page_alloc>
f01048f2:	89 c6                	mov    %eax,%esi
	if (!pg) return -E_NO_MEM;
f01048f4:	83 c4 10             	add    $0x10,%esp
f01048f7:	85 c0                	test   %eax,%eax
f01048f9:	74 4e                	je     f0104949 <syscall+0x249>
	ret = page_insert(e->env_pgdir, pg, va, perm);	//建立映射关系
f01048fb:	ff 75 14             	pushl  0x14(%ebp)
f01048fe:	ff 75 10             	pushl  0x10(%ebp)
f0104901:	50                   	push   %eax
f0104902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104905:	ff 70 60             	pushl  0x60(%eax)
f0104908:	e8 e4 c8 ff ff       	call   f01011f1 <page_insert>
f010490d:	89 c3                	mov    %eax,%ebx
	if (ret) {
f010490f:	83 c4 10             	add    $0x10,%esp
f0104912:	85 c0                	test   %eax,%eax
f0104914:	0f 84 38 fe ff ff    	je     f0104752 <syscall+0x52>
		page_free(pg);
f010491a:	83 ec 0c             	sub    $0xc,%esp
f010491d:	56                   	push   %esi
f010491e:	e8 6f c6 ff ff       	call   f0100f92 <page_free>
f0104923:	83 c4 10             	add    $0x10,%esp
f0104926:	e9 27 fe ff ff       	jmp    f0104752 <syscall+0x52>
	if ((va >= (void*)UTOP) || (ROUNDDOWN(va, PGSIZE) != va)) return -E_INVAL;		//一系列判定
f010492b:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104930:	e9 1d fe ff ff       	jmp    f0104752 <syscall+0x52>
f0104935:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010493a:	e9 13 fe ff ff       	jmp    f0104752 <syscall+0x52>
	if ((perm & flag) != flag) return -E_INVAL;
f010493f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104944:	e9 09 fe ff ff       	jmp    f0104752 <syscall+0x52>
	if (!pg) return -E_NO_MEM;
f0104949:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			break;
f010494e:	e9 ff fd ff ff       	jmp    f0104752 <syscall+0x52>
	int ret = envid2env(srcenvid, &se, 1);
f0104953:	83 ec 04             	sub    $0x4,%esp
f0104956:	6a 01                	push   $0x1
f0104958:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010495b:	50                   	push   %eax
f010495c:	ff 75 0c             	pushl  0xc(%ebp)
f010495f:	e8 96 e6 ff ff       	call   f0102ffa <envid2env>
f0104964:	89 c3                	mov    %eax,%ebx
	if (ret) return ret;	//bad_env
f0104966:	83 c4 10             	add    $0x10,%esp
f0104969:	85 c0                	test   %eax,%eax
f010496b:	0f 85 e1 fd ff ff    	jne    f0104752 <syscall+0x52>
	ret = envid2env(dstenvid, &de, 1);
f0104971:	83 ec 04             	sub    $0x4,%esp
f0104974:	6a 01                	push   $0x1
f0104976:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104979:	50                   	push   %eax
f010497a:	ff 75 14             	pushl  0x14(%ebp)
f010497d:	e8 78 e6 ff ff       	call   f0102ffa <envid2env>
f0104982:	89 c3                	mov    %eax,%ebx
	if (ret) return ret;	//bad_env
f0104984:	83 c4 10             	add    $0x10,%esp
f0104987:	85 c0                	test   %eax,%eax
f0104989:	0f 85 c3 fd ff ff    	jne    f0104752 <syscall+0x52>
	if (srcva >= (void*)UTOP || dstva >= (void*)UTOP || 
f010498f:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104996:	77 6c                	ja     f0104a04 <syscall+0x304>
f0104998:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f010499f:	77 63                	ja     f0104a04 <syscall+0x304>
f01049a1:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f01049a8:	75 64                	jne    f0104a0e <syscall+0x30e>
		ROUNDDOWN(srcva,PGSIZE) != srcva || ROUNDDOWN(dstva,PGSIZE) != dstva) 
f01049aa:	f7 45 18 ff 0f 00 00 	testl  $0xfff,0x18(%ebp)
f01049b1:	75 65                	jne    f0104a18 <syscall+0x318>
	struct PageInfo *pg = page_lookup(se->env_pgdir, srcva, &pte);
f01049b3:	83 ec 04             	sub    $0x4,%esp
f01049b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01049b9:	50                   	push   %eax
f01049ba:	ff 75 10             	pushl  0x10(%ebp)
f01049bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01049c0:	ff 70 60             	pushl  0x60(%eax)
f01049c3:	e8 46 c7 ff ff       	call   f010110e <page_lookup>
	if (!pg) return -E_INVAL;
f01049c8:	83 c4 10             	add    $0x10,%esp
f01049cb:	85 c0                	test   %eax,%eax
f01049cd:	74 53                	je     f0104a22 <syscall+0x322>
	if ((perm & flag) != flag) return -E_INVAL;
f01049cf:	8b 55 1c             	mov    0x1c(%ebp),%edx
f01049d2:	83 e2 05             	and    $0x5,%edx
f01049d5:	83 fa 05             	cmp    $0x5,%edx
f01049d8:	75 52                	jne    f0104a2c <syscall+0x32c>
	if (((*pte&PTE_W) == 0) && (perm&PTE_W)) return -E_INVAL;
f01049da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01049dd:	f6 02 02             	testb  $0x2,(%edx)
f01049e0:	75 06                	jne    f01049e8 <syscall+0x2e8>
f01049e2:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f01049e6:	75 4e                	jne    f0104a36 <syscall+0x336>
	ret = page_insert(de->env_pgdir, pg, dstva, perm);
f01049e8:	ff 75 1c             	pushl  0x1c(%ebp)
f01049eb:	ff 75 18             	pushl  0x18(%ebp)
f01049ee:	50                   	push   %eax
f01049ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01049f2:	ff 70 60             	pushl  0x60(%eax)
f01049f5:	e8 f7 c7 ff ff       	call   f01011f1 <page_insert>
f01049fa:	89 c3                	mov    %eax,%ebx
f01049fc:	83 c4 10             	add    $0x10,%esp
f01049ff:	e9 4e fd ff ff       	jmp    f0104752 <syscall+0x52>
		return -E_INVAL;
f0104a04:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a09:	e9 44 fd ff ff       	jmp    f0104752 <syscall+0x52>
f0104a0e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a13:	e9 3a fd ff ff       	jmp    f0104752 <syscall+0x52>
f0104a18:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a1d:	e9 30 fd ff ff       	jmp    f0104752 <syscall+0x52>
	if (!pg) return -E_INVAL;
f0104a22:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a27:	e9 26 fd ff ff       	jmp    f0104752 <syscall+0x52>
	if ((perm & flag) != flag) return -E_INVAL;
f0104a2c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a31:	e9 1c fd ff ff       	jmp    f0104752 <syscall+0x52>
	if (((*pte&PTE_W) == 0) && (perm&PTE_W)) return -E_INVAL;
f0104a36:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0104a3b:	e9 12 fd ff ff       	jmp    f0104752 <syscall+0x52>
	int ret = envid2env(envid, &env, 1);
f0104a40:	83 ec 04             	sub    $0x4,%esp
f0104a43:	6a 01                	push   $0x1
f0104a45:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a48:	50                   	push   %eax
f0104a49:	ff 75 0c             	pushl  0xc(%ebp)
f0104a4c:	e8 a9 e5 ff ff       	call   f0102ffa <envid2env>
f0104a51:	89 c3                	mov    %eax,%ebx
	if (ret) return ret;
f0104a53:	83 c4 10             	add    $0x10,%esp
f0104a56:	85 c0                	test   %eax,%eax
f0104a58:	0f 85 f4 fc ff ff    	jne    f0104752 <syscall+0x52>
	if ((va >= (void*)UTOP) || (ROUNDDOWN(va, PGSIZE) != va)) return -E_INVAL;
f0104a5e:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104a65:	77 22                	ja     f0104a89 <syscall+0x389>
f0104a67:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104a6e:	75 23                	jne    f0104a93 <syscall+0x393>
	page_remove(env->env_pgdir, va);
f0104a70:	83 ec 08             	sub    $0x8,%esp
f0104a73:	ff 75 10             	pushl  0x10(%ebp)
f0104a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a79:	ff 70 60             	pushl  0x60(%eax)
f0104a7c:	e8 28 c7 ff ff       	call   f01011a9 <page_remove>
f0104a81:	83 c4 10             	add    $0x10,%esp
f0104a84:	e9 c9 fc ff ff       	jmp    f0104752 <syscall+0x52>
	if ((va >= (void*)UTOP) || (ROUNDDOWN(va, PGSIZE) != va)) return -E_INVAL;
f0104a89:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a8e:	e9 bf fc ff ff       	jmp    f0104752 <syscall+0x52>
f0104a93:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0104a98:	e9 b5 fc ff ff       	jmp    f0104752 <syscall+0x52>
	if ((ret = envid2env(envid, &env, 1)) < 0) {
f0104a9d:	83 ec 04             	sub    $0x4,%esp
f0104aa0:	6a 01                	push   $0x1
f0104aa2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104aa5:	50                   	push   %eax
f0104aa6:	ff 75 0c             	pushl  0xc(%ebp)
f0104aa9:	e8 4c e5 ff ff       	call   f0102ffa <envid2env>
f0104aae:	89 c3                	mov    %eax,%ebx
f0104ab0:	83 c4 10             	add    $0x10,%esp
f0104ab3:	85 c0                	test   %eax,%eax
f0104ab5:	0f 88 97 fc ff ff    	js     f0104752 <syscall+0x52>
	env->env_pgfault_upcall = func;
f0104abb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104abe:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104ac1:	89 78 64             	mov    %edi,0x64(%eax)
	return 0;
f0104ac4:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0104ac9:	e9 84 fc ff ff       	jmp    f0104752 <syscall+0x52>
	int ret = envid2env(envid, &rcvenv, 0);
f0104ace:	83 ec 04             	sub    $0x4,%esp
f0104ad1:	6a 00                	push   $0x0
f0104ad3:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104ad6:	50                   	push   %eax
f0104ad7:	ff 75 0c             	pushl  0xc(%ebp)
f0104ada:	e8 1b e5 ff ff       	call   f0102ffa <envid2env>
f0104adf:	89 c3                	mov    %eax,%ebx
	if (ret) return ret;
f0104ae1:	83 c4 10             	add    $0x10,%esp
f0104ae4:	85 c0                	test   %eax,%eax
f0104ae6:	0f 85 66 fc ff ff    	jne    f0104752 <syscall+0x52>
	if (!rcvenv->env_ipc_recving) return -E_IPC_NOT_RECV;
f0104aec:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104aef:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104af3:	0f 84 de 00 00 00    	je     f0104bd7 <syscall+0x4d7>
	if (srcva < (void*)UTOP) {
f0104af9:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0104b00:	77 64                	ja     f0104b66 <syscall+0x466>
		struct PageInfo *pg = page_lookup(curenv->env_pgdir, srcva, &pte);
f0104b02:	e8 f0 12 00 00       	call   f0105df7 <cpunum>
f0104b07:	83 ec 04             	sub    $0x4,%esp
f0104b0a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104b0d:	52                   	push   %edx
f0104b0e:	ff 75 14             	pushl  0x14(%ebp)
f0104b11:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b14:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104b1a:	ff 70 60             	pushl  0x60(%eax)
f0104b1d:	e8 ec c5 ff ff       	call   f010110e <page_lookup>
		if (srcva != ROUNDDOWN(srcva, PGSIZE)) {		//srcva没有页对齐
f0104b22:	83 c4 10             	add    $0x10,%esp
f0104b25:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0104b2c:	74 0a                	je     f0104b38 <syscall+0x438>
			return -E_INVAL;
f0104b2e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b33:	e9 1a fc ff ff       	jmp    f0104752 <syscall+0x52>
		if ((*pte & perm & 7) != (perm & 7)) {  //perm应该是*pte的子集
f0104b38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104b3b:	8b 0a                	mov    (%edx),%ecx
f0104b3d:	89 ca                	mov    %ecx,%edx
f0104b3f:	f7 d2                	not    %edx
f0104b41:	83 e2 07             	and    $0x7,%edx
		if (!pg) {			//srcva还没有映射到物理页
f0104b44:	85 55 18             	test   %edx,0x18(%ebp)
f0104b47:	75 73                	jne    f0104bbc <syscall+0x4bc>
f0104b49:	85 c0                	test   %eax,%eax
f0104b4b:	74 6f                	je     f0104bbc <syscall+0x4bc>
		if ((perm & PTE_W) && !(*pte & PTE_W)) {	//写权限
f0104b4d:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104b51:	74 05                	je     f0104b58 <syscall+0x458>
f0104b53:	f6 c1 02             	test   $0x2,%cl
f0104b56:	74 6e                	je     f0104bc6 <syscall+0x4c6>
		if (rcvenv->env_ipc_dstva < (void*)UTOP) {
f0104b58:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104b5b:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0104b5e:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0104b64:	76 37                	jbe    f0104b9d <syscall+0x49d>
	rcvenv->env_ipc_recving = 0;					//标记接受进程可再次接受信息
f0104b66:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104b69:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	rcvenv->env_ipc_from = curenv->env_id;
f0104b6d:	e8 85 12 00 00       	call   f0105df7 <cpunum>
f0104b72:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104b75:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b78:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104b7e:	8b 40 48             	mov    0x48(%eax),%eax
f0104b81:	89 42 74             	mov    %eax,0x74(%edx)
	rcvenv->env_ipc_value = value; 
f0104b84:	8b 45 10             	mov    0x10(%ebp),%eax
f0104b87:	89 42 70             	mov    %eax,0x70(%edx)
	rcvenv->env_status = ENV_RUNNABLE;
f0104b8a:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	rcvenv->env_tf.tf_regs.reg_eax = 0;
f0104b91:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
f0104b98:	e9 b5 fb ff ff       	jmp    f0104752 <syscall+0x52>
			ret = page_insert(rcvenv->env_pgdir, pg, rcvenv->env_ipc_dstva, perm); //共享相同的映射关系
f0104b9d:	ff 75 18             	pushl  0x18(%ebp)
f0104ba0:	51                   	push   %ecx
f0104ba1:	50                   	push   %eax
f0104ba2:	ff 72 60             	pushl  0x60(%edx)
f0104ba5:	e8 47 c6 ff ff       	call   f01011f1 <page_insert>
			if (ret) return ret;
f0104baa:	83 c4 10             	add    $0x10,%esp
f0104bad:	85 c0                	test   %eax,%eax
f0104baf:	75 1f                	jne    f0104bd0 <syscall+0x4d0>
			rcvenv->env_ipc_perm = perm;
f0104bb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104bb4:	8b 7d 18             	mov    0x18(%ebp),%edi
f0104bb7:	89 78 78             	mov    %edi,0x78(%eax)
f0104bba:	eb aa                	jmp    f0104b66 <syscall+0x466>
			return -E_INVAL;
f0104bbc:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104bc1:	e9 8c fb ff ff       	jmp    f0104752 <syscall+0x52>
			return -E_INVAL;
f0104bc6:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104bcb:	e9 82 fb ff ff       	jmp    f0104752 <syscall+0x52>
			if (ret) return ret;
f0104bd0:	89 c3                	mov    %eax,%ebx
f0104bd2:	e9 7b fb ff ff       	jmp    f0104752 <syscall+0x52>
	if (!rcvenv->env_ipc_recving) return -E_IPC_NOT_RECV;
f0104bd7:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			break;
f0104bdc:	e9 71 fb ff ff       	jmp    f0104752 <syscall+0x52>
	if (dstva < (void *)UTOP && dstva != ROUNDDOWN(dstva, PGSIZE)) {
f0104be1:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0104be8:	77 13                	ja     f0104bfd <syscall+0x4fd>
f0104bea:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104bf1:	74 0a                	je     f0104bfd <syscall+0x4fd>
			ret = sys_ipc_recv((void *)a1);
f0104bf3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104bf8:	e9 55 fb ff ff       	jmp    f0104752 <syscall+0x52>
	curenv->env_ipc_recving = 1;
f0104bfd:	e8 f5 11 00 00       	call   f0105df7 <cpunum>
f0104c02:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c05:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104c0b:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0104c0f:	e8 e3 11 00 00       	call   f0105df7 <cpunum>
f0104c14:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c17:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104c1d:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	curenv->env_ipc_dstva = dstva;
f0104c24:	e8 ce 11 00 00       	call   f0105df7 <cpunum>
f0104c29:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c2c:	8b 80 28 a0 1e f0    	mov    -0xfe15fd8(%eax),%eax
f0104c32:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0104c35:	89 78 6c             	mov    %edi,0x6c(%eax)
	sched_yield();
f0104c38:	e8 0c fa ff ff       	call   f0104649 <sched_yield>
			return -E_INVAL;
f0104c3d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c42:	e9 0b fb ff ff       	jmp    f0104752 <syscall+0x52>

f0104c47 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0104c47:	55                   	push   %ebp
f0104c48:	89 e5                	mov    %esp,%ebp
f0104c4a:	57                   	push   %edi
f0104c4b:	56                   	push   %esi
f0104c4c:	53                   	push   %ebx
f0104c4d:	83 ec 14             	sub    $0x14,%esp
f0104c50:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104c53:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104c56:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104c59:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104c5c:	8b 32                	mov    (%edx),%esi
f0104c5e:	8b 01                	mov    (%ecx),%eax
f0104c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104c63:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104c6a:	eb 2f                	jmp    f0104c9b <stab_binsearch+0x54>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f0104c6c:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f0104c6f:	39 c6                	cmp    %eax,%esi
f0104c71:	7f 49                	jg     f0104cbc <stab_binsearch+0x75>
f0104c73:	0f b6 0a             	movzbl (%edx),%ecx
f0104c76:	83 ea 0c             	sub    $0xc,%edx
f0104c79:	39 f9                	cmp    %edi,%ecx
f0104c7b:	75 ef                	jne    f0104c6c <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104c7d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104c80:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104c83:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104c87:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104c8a:	73 35                	jae    f0104cc1 <stab_binsearch+0x7a>
			*region_left = m;
f0104c8c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104c8f:	89 06                	mov    %eax,(%esi)
			l = true_m + 1;
f0104c91:	8d 73 01             	lea    0x1(%ebx),%esi
		any_matches = 1;
f0104c94:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104c9b:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0104c9e:	7f 4e                	jg     f0104cee <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0104ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104ca3:	01 f0                	add    %esi,%eax
f0104ca5:	89 c3                	mov    %eax,%ebx
f0104ca7:	c1 eb 1f             	shr    $0x1f,%ebx
f0104caa:	01 c3                	add    %eax,%ebx
f0104cac:	d1 fb                	sar    %ebx
f0104cae:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104cb1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104cb4:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104cb8:	89 d8                	mov    %ebx,%eax
		while (m >= l && stabs[m].n_type != type)
f0104cba:	eb b3                	jmp    f0104c6f <stab_binsearch+0x28>
			l = true_m + 1;
f0104cbc:	8d 73 01             	lea    0x1(%ebx),%esi
			continue;
f0104cbf:	eb da                	jmp    f0104c9b <stab_binsearch+0x54>
		} else if (stabs[m].n_value > addr) {
f0104cc1:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104cc4:	76 14                	jbe    f0104cda <stab_binsearch+0x93>
			*region_right = m - 1;
f0104cc6:	83 e8 01             	sub    $0x1,%eax
f0104cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104ccc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104ccf:	89 03                	mov    %eax,(%ebx)
		any_matches = 1;
f0104cd1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104cd8:	eb c1                	jmp    f0104c9b <stab_binsearch+0x54>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104cda:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104cdd:	89 06                	mov    %eax,(%esi)
			l = m;
			addr++;
f0104cdf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104ce3:	89 c6                	mov    %eax,%esi
		any_matches = 1;
f0104ce5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104cec:	eb ad                	jmp    f0104c9b <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f0104cee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104cf2:	74 16                	je     f0104d0a <stab_binsearch+0xc3>
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0104cf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104cf7:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104cf9:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104cfc:	8b 0e                	mov    (%esi),%ecx
f0104cfe:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104d01:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0104d04:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
		for (l = *region_right;
f0104d08:	eb 12                	jmp    f0104d1c <stab_binsearch+0xd5>
		*region_right = *region_left - 1;
f0104d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104d0d:	8b 00                	mov    (%eax),%eax
f0104d0f:	83 e8 01             	sub    $0x1,%eax
f0104d12:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104d15:	89 07                	mov    %eax,(%edi)
f0104d17:	eb 16                	jmp    f0104d2f <stab_binsearch+0xe8>
		     l--)
f0104d19:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104d1c:	39 c1                	cmp    %eax,%ecx
f0104d1e:	7d 0a                	jge    f0104d2a <stab_binsearch+0xe3>
		     l > *region_left && stabs[l].n_type != type;
f0104d20:	0f b6 1a             	movzbl (%edx),%ebx
f0104d23:	83 ea 0c             	sub    $0xc,%edx
f0104d26:	39 fb                	cmp    %edi,%ebx
f0104d28:	75 ef                	jne    f0104d19 <stab_binsearch+0xd2>
			/* do nothing */;
		*region_left = l;
f0104d2a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104d2d:	89 07                	mov    %eax,(%edi)
	}
}
f0104d2f:	83 c4 14             	add    $0x14,%esp
f0104d32:	5b                   	pop    %ebx
f0104d33:	5e                   	pop    %esi
f0104d34:	5f                   	pop    %edi
f0104d35:	5d                   	pop    %ebp
f0104d36:	c3                   	ret    

f0104d37 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104d37:	55                   	push   %ebp
f0104d38:	89 e5                	mov    %esp,%ebp
f0104d3a:	57                   	push   %edi
f0104d3b:	56                   	push   %esi
f0104d3c:	53                   	push   %ebx
f0104d3d:	83 ec 4c             	sub    $0x4c,%esp
f0104d40:	8b 75 08             	mov    0x8(%ebp),%esi
f0104d43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104d46:	c7 03 b8 7b 10 f0    	movl   $0xf0107bb8,(%ebx)
	info->eip_line = 0;
f0104d4c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0104d53:	c7 43 08 b8 7b 10 f0 	movl   $0xf0107bb8,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0104d5a:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0104d61:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0104d64:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104d6b:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0104d71:	77 21                	ja     f0104d94 <debuginfo_eip+0x5d>

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.

		stabs = usd->stabs;
f0104d73:	a1 00 00 20 00       	mov    0x200000,%eax
f0104d78:	89 45 bc             	mov    %eax,-0x44(%ebp)
		stab_end = usd->stab_end;
f0104d7b:	a1 04 00 20 00       	mov    0x200004,%eax
		stabstr = usd->stabstr;
f0104d80:	8b 3d 08 00 20 00    	mov    0x200008,%edi
f0104d86:	89 7d b4             	mov    %edi,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0104d89:	8b 3d 0c 00 20 00    	mov    0x20000c,%edi
f0104d8f:	89 7d b8             	mov    %edi,-0x48(%ebp)
f0104d92:	eb 1a                	jmp    f0104dae <debuginfo_eip+0x77>
		stabstr_end = __STABSTR_END__;
f0104d94:	c7 45 b8 3c 70 11 f0 	movl   $0xf011703c,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104d9b:	c7 45 b4 5d 38 11 f0 	movl   $0xf011385d,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0104da2:	b8 5c 38 11 f0       	mov    $0xf011385c,%eax
		stabs = __STAB_BEGIN__;
f0104da7:	c7 45 bc 50 81 10 f0 	movl   $0xf0108150,-0x44(%ebp)
		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104dae:	8b 7d b8             	mov    -0x48(%ebp),%edi
f0104db1:	39 7d b4             	cmp    %edi,-0x4c(%ebp)
f0104db4:	0f 83 bc 01 00 00    	jae    f0104f76 <debuginfo_eip+0x23f>
f0104dba:	80 7f ff 00          	cmpb   $0x0,-0x1(%edi)
f0104dbe:	0f 85 b9 01 00 00    	jne    f0104f7d <debuginfo_eip+0x246>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104dc4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104dcb:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104dce:	29 f8                	sub    %edi,%eax
f0104dd0:	c1 f8 02             	sar    $0x2,%eax
f0104dd3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0104dd9:	83 e8 01             	sub    $0x1,%eax
f0104ddc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104ddf:	56                   	push   %esi
f0104de0:	6a 64                	push   $0x64
f0104de2:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104de5:	89 c1                	mov    %eax,%ecx
f0104de7:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104dea:	89 f8                	mov    %edi,%eax
f0104dec:	e8 56 fe ff ff       	call   f0104c47 <stab_binsearch>
	if (lfile == 0)
f0104df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104df4:	83 c4 08             	add    $0x8,%esp
f0104df7:	85 c0                	test   %eax,%eax
f0104df9:	0f 84 85 01 00 00    	je     f0104f84 <debuginfo_eip+0x24d>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104dff:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0104e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104e05:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104e08:	56                   	push   %esi
f0104e09:	6a 24                	push   $0x24
f0104e0b:	8d 45 d8             	lea    -0x28(%ebp),%eax
f0104e0e:	89 c1                	mov    %eax,%ecx
f0104e10:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104e13:	89 f8                	mov    %edi,%eax
f0104e15:	e8 2d fe ff ff       	call   f0104c47 <stab_binsearch>

	if (lfun <= rfun) {
f0104e1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104e1d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0104e20:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0104e23:	83 c4 08             	add    $0x8,%esp
f0104e26:	39 c8                	cmp    %ecx,%eax
f0104e28:	0f 8f 87 00 00 00    	jg     f0104eb5 <debuginfo_eip+0x17e>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104e2e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104e31:	8d 0c 97             	lea    (%edi,%edx,4),%ecx
f0104e34:	8b 11                	mov    (%ecx),%edx
f0104e36:	8b 7d b8             	mov    -0x48(%ebp),%edi
f0104e39:	2b 7d b4             	sub    -0x4c(%ebp),%edi
f0104e3c:	39 fa                	cmp    %edi,%edx
f0104e3e:	73 06                	jae    f0104e46 <debuginfo_eip+0x10f>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104e40:	03 55 b4             	add    -0x4c(%ebp),%edx
f0104e43:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104e46:	8b 51 08             	mov    0x8(%ecx),%edx
f0104e49:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0104e4c:	29 d6                	sub    %edx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0104e4e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0104e51:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0104e54:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104e57:	83 ec 08             	sub    $0x8,%esp
f0104e5a:	6a 3a                	push   $0x3a
f0104e5c:	ff 73 08             	pushl  0x8(%ebx)
f0104e5f:	e8 52 09 00 00       	call   f01057b6 <strfind>
f0104e64:	2b 43 08             	sub    0x8(%ebx),%eax
f0104e67:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0104e6a:	83 c4 08             	add    $0x8,%esp
f0104e6d:	56                   	push   %esi
f0104e6e:	6a 44                	push   $0x44
f0104e70:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104e73:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104e76:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104e79:	89 f0                	mov    %esi,%eax
f0104e7b:	e8 c7 fd ff ff       	call   f0104c47 <stab_binsearch>
    if(lline <= rline){
f0104e80:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104e83:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0104e86:	83 c4 10             	add    $0x10,%esp
f0104e89:	39 c2                	cmp    %eax,%edx
f0104e8b:	7f 39                	jg     f0104ec6 <debuginfo_eip+0x18f>
        info->eip_line = stabs[rline].n_desc;
f0104e8d:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104e90:	0f b7 44 86 06       	movzwl 0x6(%esi,%eax,4),%eax
f0104e95:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0104e98:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104e9b:	89 d0                	mov    %edx,%eax
f0104e9d:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104ea0:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104ea3:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0104ea7:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0104eab:	be 01 00 00 00       	mov    $0x1,%esi
f0104eb0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0104eb3:	eb 25                	jmp    f0104eda <debuginfo_eip+0x1a3>
		info->eip_fn_addr = addr;
f0104eb5:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0104eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104ebb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0104ebe:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104ec1:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104ec4:	eb 91                	jmp    f0104e57 <debuginfo_eip+0x120>
        info->eip_line = -1;
f0104ec6:	c7 43 04 ff ff ff ff 	movl   $0xffffffff,0x4(%ebx)
f0104ecd:	eb c9                	jmp    f0104e98 <debuginfo_eip+0x161>
f0104ecf:	83 e8 01             	sub    $0x1,%eax
f0104ed2:	83 ea 0c             	sub    $0xc,%edx
f0104ed5:	89 f3                	mov    %esi,%ebx
f0104ed7:	88 5d c4             	mov    %bl,-0x3c(%ebp)
f0104eda:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0104edd:	39 c7                	cmp    %eax,%edi
f0104edf:	7f 24                	jg     f0104f05 <debuginfo_eip+0x1ce>
	       && stabs[lline].n_type != N_SOL
f0104ee1:	0f b6 0a             	movzbl (%edx),%ecx
f0104ee4:	80 f9 84             	cmp    $0x84,%cl
f0104ee7:	74 42                	je     f0104f2b <debuginfo_eip+0x1f4>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104ee9:	80 f9 64             	cmp    $0x64,%cl
f0104eec:	75 e1                	jne    f0104ecf <debuginfo_eip+0x198>
f0104eee:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0104ef2:	74 db                	je     f0104ecf <debuginfo_eip+0x198>
f0104ef4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104ef7:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104efb:	74 37                	je     f0104f34 <debuginfo_eip+0x1fd>
f0104efd:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0104f00:	89 75 d4             	mov    %esi,-0x2c(%ebp)
f0104f03:	eb 2f                	jmp    f0104f34 <debuginfo_eip+0x1fd>
f0104f05:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		info->eip_file = stabstr + stabs[lline].n_strx;


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0104f08:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104f0b:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104f0e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0104f13:	39 f2                	cmp    %esi,%edx
f0104f15:	7d 79                	jge    f0104f90 <debuginfo_eip+0x259>
		for (lline = lfun + 1;
f0104f17:	83 c2 01             	add    $0x1,%edx
f0104f1a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0104f1d:	89 d0                	mov    %edx,%eax
f0104f1f:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104f22:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104f25:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0104f29:	eb 32                	jmp    f0104f5d <debuginfo_eip+0x226>
f0104f2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104f2e:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104f32:	75 1d                	jne    f0104f51 <debuginfo_eip+0x21a>
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104f34:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104f37:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104f3a:	8b 14 86             	mov    (%esi,%eax,4),%edx
f0104f3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0104f40:	8b 75 b4             	mov    -0x4c(%ebp),%esi
f0104f43:	29 f0                	sub    %esi,%eax
f0104f45:	39 c2                	cmp    %eax,%edx
f0104f47:	73 bf                	jae    f0104f08 <debuginfo_eip+0x1d1>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104f49:	89 f0                	mov    %esi,%eax
f0104f4b:	01 d0                	add    %edx,%eax
f0104f4d:	89 03                	mov    %eax,(%ebx)
f0104f4f:	eb b7                	jmp    f0104f08 <debuginfo_eip+0x1d1>
f0104f51:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0104f54:	89 75 d4             	mov    %esi,-0x2c(%ebp)
f0104f57:	eb db                	jmp    f0104f34 <debuginfo_eip+0x1fd>
			info->eip_fn_narg++;
f0104f59:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0104f5d:	39 c6                	cmp    %eax,%esi
f0104f5f:	7e 2a                	jle    f0104f8b <debuginfo_eip+0x254>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0104f61:	0f b6 0a             	movzbl (%edx),%ecx
f0104f64:	83 c0 01             	add    $0x1,%eax
f0104f67:	83 c2 0c             	add    $0xc,%edx
f0104f6a:	80 f9 a0             	cmp    $0xa0,%cl
f0104f6d:	74 ea                	je     f0104f59 <debuginfo_eip+0x222>
	return 0;
f0104f6f:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f74:	eb 1a                	jmp    f0104f90 <debuginfo_eip+0x259>
		return -1;
f0104f76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104f7b:	eb 13                	jmp    f0104f90 <debuginfo_eip+0x259>
f0104f7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104f82:	eb 0c                	jmp    f0104f90 <debuginfo_eip+0x259>
		return -1;
f0104f84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104f89:	eb 05                	jmp    f0104f90 <debuginfo_eip+0x259>
	return 0;
f0104f8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104f93:	5b                   	pop    %ebx
f0104f94:	5e                   	pop    %esi
f0104f95:	5f                   	pop    %edi
f0104f96:	5d                   	pop    %ebp
f0104f97:	c3                   	ret    

f0104f98 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0104f98:	55                   	push   %ebp
f0104f99:	89 e5                	mov    %esp,%ebp
f0104f9b:	57                   	push   %edi
f0104f9c:	56                   	push   %esi
f0104f9d:	53                   	push   %ebx
f0104f9e:	83 ec 1c             	sub    $0x1c,%esp
f0104fa1:	89 c7                	mov    %eax,%edi
f0104fa3:	89 d6                	mov    %edx,%esi
f0104fa5:	8b 45 08             	mov    0x8(%ebp),%eax
f0104fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104fab:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104fae:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0104fb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104fb4:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104fb9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104fbc:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0104fbf:	39 d3                	cmp    %edx,%ebx
f0104fc1:	72 05                	jb     f0104fc8 <printnum+0x30>
f0104fc3:	39 45 10             	cmp    %eax,0x10(%ebp)
f0104fc6:	77 7a                	ja     f0105042 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0104fc8:	83 ec 0c             	sub    $0xc,%esp
f0104fcb:	ff 75 18             	pushl  0x18(%ebp)
f0104fce:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0104fd4:	53                   	push   %ebx
f0104fd5:	ff 75 10             	pushl  0x10(%ebp)
f0104fd8:	83 ec 08             	sub    $0x8,%esp
f0104fdb:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104fde:	ff 75 e0             	pushl  -0x20(%ebp)
f0104fe1:	ff 75 dc             	pushl  -0x24(%ebp)
f0104fe4:	ff 75 d8             	pushl  -0x28(%ebp)
f0104fe7:	e8 04 12 00 00       	call   f01061f0 <__udivdi3>
f0104fec:	83 c4 18             	add    $0x18,%esp
f0104fef:	52                   	push   %edx
f0104ff0:	50                   	push   %eax
f0104ff1:	89 f2                	mov    %esi,%edx
f0104ff3:	89 f8                	mov    %edi,%eax
f0104ff5:	e8 9e ff ff ff       	call   f0104f98 <printnum>
f0104ffa:	83 c4 20             	add    $0x20,%esp
f0104ffd:	eb 13                	jmp    f0105012 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104fff:	83 ec 08             	sub    $0x8,%esp
f0105002:	56                   	push   %esi
f0105003:	ff 75 18             	pushl  0x18(%ebp)
f0105006:	ff d7                	call   *%edi
f0105008:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f010500b:	83 eb 01             	sub    $0x1,%ebx
f010500e:	85 db                	test   %ebx,%ebx
f0105010:	7f ed                	jg     f0104fff <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0105012:	83 ec 08             	sub    $0x8,%esp
f0105015:	56                   	push   %esi
f0105016:	83 ec 04             	sub    $0x4,%esp
f0105019:	ff 75 e4             	pushl  -0x1c(%ebp)
f010501c:	ff 75 e0             	pushl  -0x20(%ebp)
f010501f:	ff 75 dc             	pushl  -0x24(%ebp)
f0105022:	ff 75 d8             	pushl  -0x28(%ebp)
f0105025:	e8 e6 12 00 00       	call   f0106310 <__umoddi3>
f010502a:	83 c4 14             	add    $0x14,%esp
f010502d:	0f be 80 c2 7b 10 f0 	movsbl -0xfef843e(%eax),%eax
f0105034:	50                   	push   %eax
f0105035:	ff d7                	call   *%edi
}
f0105037:	83 c4 10             	add    $0x10,%esp
f010503a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010503d:	5b                   	pop    %ebx
f010503e:	5e                   	pop    %esi
f010503f:	5f                   	pop    %edi
f0105040:	5d                   	pop    %ebp
f0105041:	c3                   	ret    
f0105042:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105045:	eb c4                	jmp    f010500b <printnum+0x73>

f0105047 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105047:	55                   	push   %ebp
f0105048:	89 e5                	mov    %esp,%ebp
f010504a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f010504d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105051:	8b 10                	mov    (%eax),%edx
f0105053:	3b 50 04             	cmp    0x4(%eax),%edx
f0105056:	73 0a                	jae    f0105062 <sprintputch+0x1b>
		*b->buf++ = ch;
f0105058:	8d 4a 01             	lea    0x1(%edx),%ecx
f010505b:	89 08                	mov    %ecx,(%eax)
f010505d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105060:	88 02                	mov    %al,(%edx)
}
f0105062:	5d                   	pop    %ebp
f0105063:	c3                   	ret    

f0105064 <printfmt>:
{
f0105064:	55                   	push   %ebp
f0105065:	89 e5                	mov    %esp,%ebp
f0105067:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f010506a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010506d:	50                   	push   %eax
f010506e:	ff 75 10             	pushl  0x10(%ebp)
f0105071:	ff 75 0c             	pushl  0xc(%ebp)
f0105074:	ff 75 08             	pushl  0x8(%ebp)
f0105077:	e8 05 00 00 00       	call   f0105081 <vprintfmt>
}
f010507c:	83 c4 10             	add    $0x10,%esp
f010507f:	c9                   	leave  
f0105080:	c3                   	ret    

f0105081 <vprintfmt>:
{
f0105081:	55                   	push   %ebp
f0105082:	89 e5                	mov    %esp,%ebp
f0105084:	57                   	push   %edi
f0105085:	56                   	push   %esi
f0105086:	53                   	push   %ebx
f0105087:	83 ec 2c             	sub    $0x2c,%esp
f010508a:	8b 75 08             	mov    0x8(%ebp),%esi
f010508d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105090:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105093:	e9 c1 03 00 00       	jmp    f0105459 <vprintfmt+0x3d8>
		padc = ' ';
f0105098:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f010509c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f01050a3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
f01050aa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f01050b1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f01050b6:	8d 47 01             	lea    0x1(%edi),%eax
f01050b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01050bc:	0f b6 17             	movzbl (%edi),%edx
f01050bf:	8d 42 dd             	lea    -0x23(%edx),%eax
f01050c2:	3c 55                	cmp    $0x55,%al
f01050c4:	0f 87 12 04 00 00    	ja     f01054dc <vprintfmt+0x45b>
f01050ca:	0f b6 c0             	movzbl %al,%eax
f01050cd:	ff 24 85 00 7d 10 f0 	jmp    *-0xfef8300(,%eax,4)
f01050d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f01050d7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f01050db:	eb d9                	jmp    f01050b6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f01050dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f01050e0:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f01050e4:	eb d0                	jmp    f01050b6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f01050e6:	0f b6 d2             	movzbl %dl,%edx
f01050e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01050ec:	b8 00 00 00 00       	mov    $0x0,%eax
f01050f1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f01050f4:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01050f7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01050fb:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01050fe:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0105101:	83 f9 09             	cmp    $0x9,%ecx
f0105104:	77 55                	ja     f010515b <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
f0105106:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0105109:	eb e9                	jmp    f01050f4 <vprintfmt+0x73>
			precision = va_arg(ap, int);
f010510b:	8b 45 14             	mov    0x14(%ebp),%eax
f010510e:	8b 00                	mov    (%eax),%eax
f0105110:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105113:	8b 45 14             	mov    0x14(%ebp),%eax
f0105116:	8d 40 04             	lea    0x4(%eax),%eax
f0105119:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010511c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f010511f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105123:	79 91                	jns    f01050b6 <vprintfmt+0x35>
				width = precision, precision = -1;
f0105125:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105128:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010512b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f0105132:	eb 82                	jmp    f01050b6 <vprintfmt+0x35>
f0105134:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105137:	85 c0                	test   %eax,%eax
f0105139:	ba 00 00 00 00       	mov    $0x0,%edx
f010513e:	0f 49 d0             	cmovns %eax,%edx
f0105141:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105144:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105147:	e9 6a ff ff ff       	jmp    f01050b6 <vprintfmt+0x35>
f010514c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f010514f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0105156:	e9 5b ff ff ff       	jmp    f01050b6 <vprintfmt+0x35>
f010515b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010515e:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105161:	eb bc                	jmp    f010511f <vprintfmt+0x9e>
			lflag++;
f0105163:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105166:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105169:	e9 48 ff ff ff       	jmp    f01050b6 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
f010516e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105171:	8d 78 04             	lea    0x4(%eax),%edi
f0105174:	83 ec 08             	sub    $0x8,%esp
f0105177:	53                   	push   %ebx
f0105178:	ff 30                	pushl  (%eax)
f010517a:	ff d6                	call   *%esi
			break;
f010517c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f010517f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105182:	e9 cf 02 00 00       	jmp    f0105456 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
f0105187:	8b 45 14             	mov    0x14(%ebp),%eax
f010518a:	8d 78 04             	lea    0x4(%eax),%edi
f010518d:	8b 00                	mov    (%eax),%eax
f010518f:	99                   	cltd   
f0105190:	31 d0                	xor    %edx,%eax
f0105192:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105194:	83 f8 0f             	cmp    $0xf,%eax
f0105197:	7f 23                	jg     f01051bc <vprintfmt+0x13b>
f0105199:	8b 14 85 60 7e 10 f0 	mov    -0xfef81a0(,%eax,4),%edx
f01051a0:	85 d2                	test   %edx,%edx
f01051a2:	74 18                	je     f01051bc <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
f01051a4:	52                   	push   %edx
f01051a5:	68 81 73 10 f0       	push   $0xf0107381
f01051aa:	53                   	push   %ebx
f01051ab:	56                   	push   %esi
f01051ac:	e8 b3 fe ff ff       	call   f0105064 <printfmt>
f01051b1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01051b4:	89 7d 14             	mov    %edi,0x14(%ebp)
f01051b7:	e9 9a 02 00 00       	jmp    f0105456 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
f01051bc:	50                   	push   %eax
f01051bd:	68 da 7b 10 f0       	push   $0xf0107bda
f01051c2:	53                   	push   %ebx
f01051c3:	56                   	push   %esi
f01051c4:	e8 9b fe ff ff       	call   f0105064 <printfmt>
f01051c9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01051cc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01051cf:	e9 82 02 00 00       	jmp    f0105456 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
f01051d4:	8b 45 14             	mov    0x14(%ebp),%eax
f01051d7:	83 c0 04             	add    $0x4,%eax
f01051da:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01051dd:	8b 45 14             	mov    0x14(%ebp),%eax
f01051e0:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f01051e2:	85 ff                	test   %edi,%edi
f01051e4:	b8 d3 7b 10 f0       	mov    $0xf0107bd3,%eax
f01051e9:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f01051ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01051f0:	0f 8e bd 00 00 00    	jle    f01052b3 <vprintfmt+0x232>
f01051f6:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f01051fa:	75 0e                	jne    f010520a <vprintfmt+0x189>
f01051fc:	89 75 08             	mov    %esi,0x8(%ebp)
f01051ff:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0105202:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0105205:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0105208:	eb 6d                	jmp    f0105277 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
f010520a:	83 ec 08             	sub    $0x8,%esp
f010520d:	ff 75 d0             	pushl  -0x30(%ebp)
f0105210:	57                   	push   %edi
f0105211:	e8 5c 04 00 00       	call   f0105672 <strnlen>
f0105216:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105219:	29 c1                	sub    %eax,%ecx
f010521b:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f010521e:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f0105221:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f0105225:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105228:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f010522b:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f010522d:	eb 0f                	jmp    f010523e <vprintfmt+0x1bd>
					putch(padc, putdat);
f010522f:	83 ec 08             	sub    $0x8,%esp
f0105232:	53                   	push   %ebx
f0105233:	ff 75 e0             	pushl  -0x20(%ebp)
f0105236:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105238:	83 ef 01             	sub    $0x1,%edi
f010523b:	83 c4 10             	add    $0x10,%esp
f010523e:	85 ff                	test   %edi,%edi
f0105240:	7f ed                	jg     f010522f <vprintfmt+0x1ae>
f0105242:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0105245:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0105248:	85 c9                	test   %ecx,%ecx
f010524a:	b8 00 00 00 00       	mov    $0x0,%eax
f010524f:	0f 49 c1             	cmovns %ecx,%eax
f0105252:	29 c1                	sub    %eax,%ecx
f0105254:	89 75 08             	mov    %esi,0x8(%ebp)
f0105257:	8b 75 d0             	mov    -0x30(%ebp),%esi
f010525a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f010525d:	89 cb                	mov    %ecx,%ebx
f010525f:	eb 16                	jmp    f0105277 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
f0105261:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105265:	75 31                	jne    f0105298 <vprintfmt+0x217>
					putch(ch, putdat);
f0105267:	83 ec 08             	sub    $0x8,%esp
f010526a:	ff 75 0c             	pushl  0xc(%ebp)
f010526d:	50                   	push   %eax
f010526e:	ff 55 08             	call   *0x8(%ebp)
f0105271:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105274:	83 eb 01             	sub    $0x1,%ebx
f0105277:	83 c7 01             	add    $0x1,%edi
f010527a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f010527e:	0f be c2             	movsbl %dl,%eax
f0105281:	85 c0                	test   %eax,%eax
f0105283:	74 59                	je     f01052de <vprintfmt+0x25d>
f0105285:	85 f6                	test   %esi,%esi
f0105287:	78 d8                	js     f0105261 <vprintfmt+0x1e0>
f0105289:	83 ee 01             	sub    $0x1,%esi
f010528c:	79 d3                	jns    f0105261 <vprintfmt+0x1e0>
f010528e:	89 df                	mov    %ebx,%edi
f0105290:	8b 75 08             	mov    0x8(%ebp),%esi
f0105293:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105296:	eb 37                	jmp    f01052cf <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
f0105298:	0f be d2             	movsbl %dl,%edx
f010529b:	83 ea 20             	sub    $0x20,%edx
f010529e:	83 fa 5e             	cmp    $0x5e,%edx
f01052a1:	76 c4                	jbe    f0105267 <vprintfmt+0x1e6>
					putch('?', putdat);
f01052a3:	83 ec 08             	sub    $0x8,%esp
f01052a6:	ff 75 0c             	pushl  0xc(%ebp)
f01052a9:	6a 3f                	push   $0x3f
f01052ab:	ff 55 08             	call   *0x8(%ebp)
f01052ae:	83 c4 10             	add    $0x10,%esp
f01052b1:	eb c1                	jmp    f0105274 <vprintfmt+0x1f3>
f01052b3:	89 75 08             	mov    %esi,0x8(%ebp)
f01052b6:	8b 75 d0             	mov    -0x30(%ebp),%esi
f01052b9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f01052bc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01052bf:	eb b6                	jmp    f0105277 <vprintfmt+0x1f6>
				putch(' ', putdat);
f01052c1:	83 ec 08             	sub    $0x8,%esp
f01052c4:	53                   	push   %ebx
f01052c5:	6a 20                	push   $0x20
f01052c7:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01052c9:	83 ef 01             	sub    $0x1,%edi
f01052cc:	83 c4 10             	add    $0x10,%esp
f01052cf:	85 ff                	test   %edi,%edi
f01052d1:	7f ee                	jg     f01052c1 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
f01052d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01052d6:	89 45 14             	mov    %eax,0x14(%ebp)
f01052d9:	e9 78 01 00 00       	jmp    f0105456 <vprintfmt+0x3d5>
f01052de:	89 df                	mov    %ebx,%edi
f01052e0:	8b 75 08             	mov    0x8(%ebp),%esi
f01052e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01052e6:	eb e7                	jmp    f01052cf <vprintfmt+0x24e>
	if (lflag >= 2)
f01052e8:	83 f9 01             	cmp    $0x1,%ecx
f01052eb:	7e 3f                	jle    f010532c <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
f01052ed:	8b 45 14             	mov    0x14(%ebp),%eax
f01052f0:	8b 50 04             	mov    0x4(%eax),%edx
f01052f3:	8b 00                	mov    (%eax),%eax
f01052f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01052f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01052fb:	8b 45 14             	mov    0x14(%ebp),%eax
f01052fe:	8d 40 08             	lea    0x8(%eax),%eax
f0105301:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0105304:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0105308:	79 5c                	jns    f0105366 <vprintfmt+0x2e5>
				putch('-', putdat);
f010530a:	83 ec 08             	sub    $0x8,%esp
f010530d:	53                   	push   %ebx
f010530e:	6a 2d                	push   $0x2d
f0105310:	ff d6                	call   *%esi
				num = -(long long) num;
f0105312:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105315:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105318:	f7 da                	neg    %edx
f010531a:	83 d1 00             	adc    $0x0,%ecx
f010531d:	f7 d9                	neg    %ecx
f010531f:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105322:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105327:	e9 10 01 00 00       	jmp    f010543c <vprintfmt+0x3bb>
	else if (lflag)
f010532c:	85 c9                	test   %ecx,%ecx
f010532e:	75 1b                	jne    f010534b <vprintfmt+0x2ca>
		return va_arg(*ap, int);
f0105330:	8b 45 14             	mov    0x14(%ebp),%eax
f0105333:	8b 00                	mov    (%eax),%eax
f0105335:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105338:	89 c1                	mov    %eax,%ecx
f010533a:	c1 f9 1f             	sar    $0x1f,%ecx
f010533d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105340:	8b 45 14             	mov    0x14(%ebp),%eax
f0105343:	8d 40 04             	lea    0x4(%eax),%eax
f0105346:	89 45 14             	mov    %eax,0x14(%ebp)
f0105349:	eb b9                	jmp    f0105304 <vprintfmt+0x283>
		return va_arg(*ap, long);
f010534b:	8b 45 14             	mov    0x14(%ebp),%eax
f010534e:	8b 00                	mov    (%eax),%eax
f0105350:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105353:	89 c1                	mov    %eax,%ecx
f0105355:	c1 f9 1f             	sar    $0x1f,%ecx
f0105358:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010535b:	8b 45 14             	mov    0x14(%ebp),%eax
f010535e:	8d 40 04             	lea    0x4(%eax),%eax
f0105361:	89 45 14             	mov    %eax,0x14(%ebp)
f0105364:	eb 9e                	jmp    f0105304 <vprintfmt+0x283>
			num = getint(&ap, lflag);
f0105366:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105369:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f010536c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105371:	e9 c6 00 00 00       	jmp    f010543c <vprintfmt+0x3bb>
	if (lflag >= 2)
f0105376:	83 f9 01             	cmp    $0x1,%ecx
f0105379:	7e 18                	jle    f0105393 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
f010537b:	8b 45 14             	mov    0x14(%ebp),%eax
f010537e:	8b 10                	mov    (%eax),%edx
f0105380:	8b 48 04             	mov    0x4(%eax),%ecx
f0105383:	8d 40 08             	lea    0x8(%eax),%eax
f0105386:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105389:	b8 0a 00 00 00       	mov    $0xa,%eax
f010538e:	e9 a9 00 00 00       	jmp    f010543c <vprintfmt+0x3bb>
	else if (lflag)
f0105393:	85 c9                	test   %ecx,%ecx
f0105395:	75 1a                	jne    f01053b1 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
f0105397:	8b 45 14             	mov    0x14(%ebp),%eax
f010539a:	8b 10                	mov    (%eax),%edx
f010539c:	b9 00 00 00 00       	mov    $0x0,%ecx
f01053a1:	8d 40 04             	lea    0x4(%eax),%eax
f01053a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01053a7:	b8 0a 00 00 00       	mov    $0xa,%eax
f01053ac:	e9 8b 00 00 00       	jmp    f010543c <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
f01053b1:	8b 45 14             	mov    0x14(%ebp),%eax
f01053b4:	8b 10                	mov    (%eax),%edx
f01053b6:	b9 00 00 00 00       	mov    $0x0,%ecx
f01053bb:	8d 40 04             	lea    0x4(%eax),%eax
f01053be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01053c1:	b8 0a 00 00 00       	mov    $0xa,%eax
f01053c6:	eb 74                	jmp    f010543c <vprintfmt+0x3bb>
	if (lflag >= 2)
f01053c8:	83 f9 01             	cmp    $0x1,%ecx
f01053cb:	7e 15                	jle    f01053e2 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
f01053cd:	8b 45 14             	mov    0x14(%ebp),%eax
f01053d0:	8b 10                	mov    (%eax),%edx
f01053d2:	8b 48 04             	mov    0x4(%eax),%ecx
f01053d5:	8d 40 08             	lea    0x8(%eax),%eax
f01053d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01053db:	b8 08 00 00 00       	mov    $0x8,%eax
f01053e0:	eb 5a                	jmp    f010543c <vprintfmt+0x3bb>
	else if (lflag)
f01053e2:	85 c9                	test   %ecx,%ecx
f01053e4:	75 17                	jne    f01053fd <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
f01053e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01053e9:	8b 10                	mov    (%eax),%edx
f01053eb:	b9 00 00 00 00       	mov    $0x0,%ecx
f01053f0:	8d 40 04             	lea    0x4(%eax),%eax
f01053f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01053f6:	b8 08 00 00 00       	mov    $0x8,%eax
f01053fb:	eb 3f                	jmp    f010543c <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
f01053fd:	8b 45 14             	mov    0x14(%ebp),%eax
f0105400:	8b 10                	mov    (%eax),%edx
f0105402:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105407:	8d 40 04             	lea    0x4(%eax),%eax
f010540a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010540d:	b8 08 00 00 00       	mov    $0x8,%eax
f0105412:	eb 28                	jmp    f010543c <vprintfmt+0x3bb>
			putch('0', putdat);
f0105414:	83 ec 08             	sub    $0x8,%esp
f0105417:	53                   	push   %ebx
f0105418:	6a 30                	push   $0x30
f010541a:	ff d6                	call   *%esi
			putch('x', putdat);
f010541c:	83 c4 08             	add    $0x8,%esp
f010541f:	53                   	push   %ebx
f0105420:	6a 78                	push   $0x78
f0105422:	ff d6                	call   *%esi
			num = (unsigned long long)
f0105424:	8b 45 14             	mov    0x14(%ebp),%eax
f0105427:	8b 10                	mov    (%eax),%edx
f0105429:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f010542e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0105431:	8d 40 04             	lea    0x4(%eax),%eax
f0105434:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105437:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f010543c:	83 ec 0c             	sub    $0xc,%esp
f010543f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f0105443:	57                   	push   %edi
f0105444:	ff 75 e0             	pushl  -0x20(%ebp)
f0105447:	50                   	push   %eax
f0105448:	51                   	push   %ecx
f0105449:	52                   	push   %edx
f010544a:	89 da                	mov    %ebx,%edx
f010544c:	89 f0                	mov    %esi,%eax
f010544e:	e8 45 fb ff ff       	call   f0104f98 <printnum>
			break;
f0105453:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f0105456:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
f0105459:	83 c7 01             	add    $0x1,%edi
f010545c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105460:	83 f8 25             	cmp    $0x25,%eax
f0105463:	0f 84 2f fc ff ff    	je     f0105098 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
f0105469:	85 c0                	test   %eax,%eax
f010546b:	0f 84 8b 00 00 00    	je     f01054fc <vprintfmt+0x47b>
			putch(ch, putdat);
f0105471:	83 ec 08             	sub    $0x8,%esp
f0105474:	53                   	push   %ebx
f0105475:	50                   	push   %eax
f0105476:	ff d6                	call   *%esi
f0105478:	83 c4 10             	add    $0x10,%esp
f010547b:	eb dc                	jmp    f0105459 <vprintfmt+0x3d8>
	if (lflag >= 2)
f010547d:	83 f9 01             	cmp    $0x1,%ecx
f0105480:	7e 15                	jle    f0105497 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
f0105482:	8b 45 14             	mov    0x14(%ebp),%eax
f0105485:	8b 10                	mov    (%eax),%edx
f0105487:	8b 48 04             	mov    0x4(%eax),%ecx
f010548a:	8d 40 08             	lea    0x8(%eax),%eax
f010548d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105490:	b8 10 00 00 00       	mov    $0x10,%eax
f0105495:	eb a5                	jmp    f010543c <vprintfmt+0x3bb>
	else if (lflag)
f0105497:	85 c9                	test   %ecx,%ecx
f0105499:	75 17                	jne    f01054b2 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
f010549b:	8b 45 14             	mov    0x14(%ebp),%eax
f010549e:	8b 10                	mov    (%eax),%edx
f01054a0:	b9 00 00 00 00       	mov    $0x0,%ecx
f01054a5:	8d 40 04             	lea    0x4(%eax),%eax
f01054a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01054ab:	b8 10 00 00 00       	mov    $0x10,%eax
f01054b0:	eb 8a                	jmp    f010543c <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
f01054b2:	8b 45 14             	mov    0x14(%ebp),%eax
f01054b5:	8b 10                	mov    (%eax),%edx
f01054b7:	b9 00 00 00 00       	mov    $0x0,%ecx
f01054bc:	8d 40 04             	lea    0x4(%eax),%eax
f01054bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01054c2:	b8 10 00 00 00       	mov    $0x10,%eax
f01054c7:	e9 70 ff ff ff       	jmp    f010543c <vprintfmt+0x3bb>
			putch(ch, putdat);
f01054cc:	83 ec 08             	sub    $0x8,%esp
f01054cf:	53                   	push   %ebx
f01054d0:	6a 25                	push   $0x25
f01054d2:	ff d6                	call   *%esi
			break;
f01054d4:	83 c4 10             	add    $0x10,%esp
f01054d7:	e9 7a ff ff ff       	jmp    f0105456 <vprintfmt+0x3d5>
			putch('%', putdat);
f01054dc:	83 ec 08             	sub    $0x8,%esp
f01054df:	53                   	push   %ebx
f01054e0:	6a 25                	push   $0x25
f01054e2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01054e4:	83 c4 10             	add    $0x10,%esp
f01054e7:	89 f8                	mov    %edi,%eax
f01054e9:	eb 03                	jmp    f01054ee <vprintfmt+0x46d>
f01054eb:	83 e8 01             	sub    $0x1,%eax
f01054ee:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01054f2:	75 f7                	jne    f01054eb <vprintfmt+0x46a>
f01054f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01054f7:	e9 5a ff ff ff       	jmp    f0105456 <vprintfmt+0x3d5>
}
f01054fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01054ff:	5b                   	pop    %ebx
f0105500:	5e                   	pop    %esi
f0105501:	5f                   	pop    %edi
f0105502:	5d                   	pop    %ebp
f0105503:	c3                   	ret    

f0105504 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0105504:	55                   	push   %ebp
f0105505:	89 e5                	mov    %esp,%ebp
f0105507:	83 ec 18             	sub    $0x18,%esp
f010550a:	8b 45 08             	mov    0x8(%ebp),%eax
f010550d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0105510:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105513:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0105517:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f010551a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0105521:	85 c0                	test   %eax,%eax
f0105523:	74 26                	je     f010554b <vsnprintf+0x47>
f0105525:	85 d2                	test   %edx,%edx
f0105527:	7e 22                	jle    f010554b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0105529:	ff 75 14             	pushl  0x14(%ebp)
f010552c:	ff 75 10             	pushl  0x10(%ebp)
f010552f:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105532:	50                   	push   %eax
f0105533:	68 47 50 10 f0       	push   $0xf0105047
f0105538:	e8 44 fb ff ff       	call   f0105081 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010553d:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105540:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105543:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105546:	83 c4 10             	add    $0x10,%esp
}
f0105549:	c9                   	leave  
f010554a:	c3                   	ret    
		return -E_INVAL;
f010554b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105550:	eb f7                	jmp    f0105549 <vsnprintf+0x45>

f0105552 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105552:	55                   	push   %ebp
f0105553:	89 e5                	mov    %esp,%ebp
f0105555:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105558:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010555b:	50                   	push   %eax
f010555c:	ff 75 10             	pushl  0x10(%ebp)
f010555f:	ff 75 0c             	pushl  0xc(%ebp)
f0105562:	ff 75 08             	pushl  0x8(%ebp)
f0105565:	e8 9a ff ff ff       	call   f0105504 <vsnprintf>
	va_end(ap);

	return rc;
}
f010556a:	c9                   	leave  
f010556b:	c3                   	ret    

f010556c <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010556c:	55                   	push   %ebp
f010556d:	89 e5                	mov    %esp,%ebp
f010556f:	57                   	push   %edi
f0105570:	56                   	push   %esi
f0105571:	53                   	push   %ebx
f0105572:	83 ec 0c             	sub    $0xc,%esp
f0105575:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0105578:	85 c0                	test   %eax,%eax
f010557a:	74 11                	je     f010558d <readline+0x21>
		cprintf("%s", prompt);
f010557c:	83 ec 08             	sub    $0x8,%esp
f010557f:	50                   	push   %eax
f0105580:	68 81 73 10 f0       	push   $0xf0107381
f0105585:	e8 09 e3 ff ff       	call   f0103893 <cprintf>
f010558a:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010558d:	83 ec 0c             	sub    $0xc,%esp
f0105590:	6a 00                	push   $0x0
f0105592:	e8 2c b2 ff ff       	call   f01007c3 <iscons>
f0105597:	89 c7                	mov    %eax,%edi
f0105599:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010559c:	be 00 00 00 00       	mov    $0x0,%esi
f01055a1:	eb 4b                	jmp    f01055ee <readline+0x82>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f01055a3:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f01055a8:	83 fb f8             	cmp    $0xfffffff8,%ebx
f01055ab:	75 08                	jne    f01055b5 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f01055ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01055b0:	5b                   	pop    %ebx
f01055b1:	5e                   	pop    %esi
f01055b2:	5f                   	pop    %edi
f01055b3:	5d                   	pop    %ebp
f01055b4:	c3                   	ret    
				cprintf("read error: %e\n", c);
f01055b5:	83 ec 08             	sub    $0x8,%esp
f01055b8:	53                   	push   %ebx
f01055b9:	68 bf 7e 10 f0       	push   $0xf0107ebf
f01055be:	e8 d0 e2 ff ff       	call   f0103893 <cprintf>
f01055c3:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01055c6:	b8 00 00 00 00       	mov    $0x0,%eax
f01055cb:	eb e0                	jmp    f01055ad <readline+0x41>
			if (echoing)
f01055cd:	85 ff                	test   %edi,%edi
f01055cf:	75 05                	jne    f01055d6 <readline+0x6a>
			i--;
f01055d1:	83 ee 01             	sub    $0x1,%esi
f01055d4:	eb 18                	jmp    f01055ee <readline+0x82>
				cputchar('\b');
f01055d6:	83 ec 0c             	sub    $0xc,%esp
f01055d9:	6a 08                	push   $0x8
f01055db:	e8 c2 b1 ff ff       	call   f01007a2 <cputchar>
f01055e0:	83 c4 10             	add    $0x10,%esp
f01055e3:	eb ec                	jmp    f01055d1 <readline+0x65>
			buf[i++] = c;
f01055e5:	88 9e 80 9a 1e f0    	mov    %bl,-0xfe16580(%esi)
f01055eb:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01055ee:	e8 bf b1 ff ff       	call   f01007b2 <getchar>
f01055f3:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01055f5:	85 c0                	test   %eax,%eax
f01055f7:	78 aa                	js     f01055a3 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01055f9:	83 f8 08             	cmp    $0x8,%eax
f01055fc:	0f 94 c2             	sete   %dl
f01055ff:	83 f8 7f             	cmp    $0x7f,%eax
f0105602:	0f 94 c0             	sete   %al
f0105605:	08 c2                	or     %al,%dl
f0105607:	74 04                	je     f010560d <readline+0xa1>
f0105609:	85 f6                	test   %esi,%esi
f010560b:	7f c0                	jg     f01055cd <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f010560d:	83 fb 1f             	cmp    $0x1f,%ebx
f0105610:	7e 1a                	jle    f010562c <readline+0xc0>
f0105612:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0105618:	7f 12                	jg     f010562c <readline+0xc0>
			if (echoing)
f010561a:	85 ff                	test   %edi,%edi
f010561c:	74 c7                	je     f01055e5 <readline+0x79>
				cputchar(c);
f010561e:	83 ec 0c             	sub    $0xc,%esp
f0105621:	53                   	push   %ebx
f0105622:	e8 7b b1 ff ff       	call   f01007a2 <cputchar>
f0105627:	83 c4 10             	add    $0x10,%esp
f010562a:	eb b9                	jmp    f01055e5 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f010562c:	83 fb 0a             	cmp    $0xa,%ebx
f010562f:	74 05                	je     f0105636 <readline+0xca>
f0105631:	83 fb 0d             	cmp    $0xd,%ebx
f0105634:	75 b8                	jne    f01055ee <readline+0x82>
			if (echoing)
f0105636:	85 ff                	test   %edi,%edi
f0105638:	75 11                	jne    f010564b <readline+0xdf>
			buf[i] = 0;
f010563a:	c6 86 80 9a 1e f0 00 	movb   $0x0,-0xfe16580(%esi)
			return buf;
f0105641:	b8 80 9a 1e f0       	mov    $0xf01e9a80,%eax
f0105646:	e9 62 ff ff ff       	jmp    f01055ad <readline+0x41>
				cputchar('\n');
f010564b:	83 ec 0c             	sub    $0xc,%esp
f010564e:	6a 0a                	push   $0xa
f0105650:	e8 4d b1 ff ff       	call   f01007a2 <cputchar>
f0105655:	83 c4 10             	add    $0x10,%esp
f0105658:	eb e0                	jmp    f010563a <readline+0xce>

f010565a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f010565a:	55                   	push   %ebp
f010565b:	89 e5                	mov    %esp,%ebp
f010565d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105660:	b8 00 00 00 00       	mov    $0x0,%eax
f0105665:	eb 03                	jmp    f010566a <strlen+0x10>
		n++;
f0105667:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f010566a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f010566e:	75 f7                	jne    f0105667 <strlen+0xd>
	return n;
}
f0105670:	5d                   	pop    %ebp
f0105671:	c3                   	ret    

f0105672 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105672:	55                   	push   %ebp
f0105673:	89 e5                	mov    %esp,%ebp
f0105675:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105678:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010567b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105680:	eb 03                	jmp    f0105685 <strnlen+0x13>
		n++;
f0105682:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105685:	39 d0                	cmp    %edx,%eax
f0105687:	74 06                	je     f010568f <strnlen+0x1d>
f0105689:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010568d:	75 f3                	jne    f0105682 <strnlen+0x10>
	return n;
}
f010568f:	5d                   	pop    %ebp
f0105690:	c3                   	ret    

f0105691 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105691:	55                   	push   %ebp
f0105692:	89 e5                	mov    %esp,%ebp
f0105694:	53                   	push   %ebx
f0105695:	8b 45 08             	mov    0x8(%ebp),%eax
f0105698:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010569b:	89 c2                	mov    %eax,%edx
f010569d:	83 c1 01             	add    $0x1,%ecx
f01056a0:	83 c2 01             	add    $0x1,%edx
f01056a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f01056a7:	88 5a ff             	mov    %bl,-0x1(%edx)
f01056aa:	84 db                	test   %bl,%bl
f01056ac:	75 ef                	jne    f010569d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f01056ae:	5b                   	pop    %ebx
f01056af:	5d                   	pop    %ebp
f01056b0:	c3                   	ret    

f01056b1 <strcat>:

char *
strcat(char *dst, const char *src)
{
f01056b1:	55                   	push   %ebp
f01056b2:	89 e5                	mov    %esp,%ebp
f01056b4:	53                   	push   %ebx
f01056b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01056b8:	53                   	push   %ebx
f01056b9:	e8 9c ff ff ff       	call   f010565a <strlen>
f01056be:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f01056c1:	ff 75 0c             	pushl  0xc(%ebp)
f01056c4:	01 d8                	add    %ebx,%eax
f01056c6:	50                   	push   %eax
f01056c7:	e8 c5 ff ff ff       	call   f0105691 <strcpy>
	return dst;
}
f01056cc:	89 d8                	mov    %ebx,%eax
f01056ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01056d1:	c9                   	leave  
f01056d2:	c3                   	ret    

f01056d3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01056d3:	55                   	push   %ebp
f01056d4:	89 e5                	mov    %esp,%ebp
f01056d6:	56                   	push   %esi
f01056d7:	53                   	push   %ebx
f01056d8:	8b 75 08             	mov    0x8(%ebp),%esi
f01056db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01056de:	89 f3                	mov    %esi,%ebx
f01056e0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01056e3:	89 f2                	mov    %esi,%edx
f01056e5:	eb 0f                	jmp    f01056f6 <strncpy+0x23>
		*dst++ = *src;
f01056e7:	83 c2 01             	add    $0x1,%edx
f01056ea:	0f b6 01             	movzbl (%ecx),%eax
f01056ed:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01056f0:	80 39 01             	cmpb   $0x1,(%ecx)
f01056f3:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f01056f6:	39 da                	cmp    %ebx,%edx
f01056f8:	75 ed                	jne    f01056e7 <strncpy+0x14>
	}
	return ret;
}
f01056fa:	89 f0                	mov    %esi,%eax
f01056fc:	5b                   	pop    %ebx
f01056fd:	5e                   	pop    %esi
f01056fe:	5d                   	pop    %ebp
f01056ff:	c3                   	ret    

f0105700 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0105700:	55                   	push   %ebp
f0105701:	89 e5                	mov    %esp,%ebp
f0105703:	56                   	push   %esi
f0105704:	53                   	push   %ebx
f0105705:	8b 75 08             	mov    0x8(%ebp),%esi
f0105708:	8b 55 0c             	mov    0xc(%ebp),%edx
f010570b:	8b 4d 10             	mov    0x10(%ebp),%ecx
f010570e:	89 f0                	mov    %esi,%eax
f0105710:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0105714:	85 c9                	test   %ecx,%ecx
f0105716:	75 0b                	jne    f0105723 <strlcpy+0x23>
f0105718:	eb 17                	jmp    f0105731 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f010571a:	83 c2 01             	add    $0x1,%edx
f010571d:	83 c0 01             	add    $0x1,%eax
f0105720:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f0105723:	39 d8                	cmp    %ebx,%eax
f0105725:	74 07                	je     f010572e <strlcpy+0x2e>
f0105727:	0f b6 0a             	movzbl (%edx),%ecx
f010572a:	84 c9                	test   %cl,%cl
f010572c:	75 ec                	jne    f010571a <strlcpy+0x1a>
		*dst = '\0';
f010572e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105731:	29 f0                	sub    %esi,%eax
}
f0105733:	5b                   	pop    %ebx
f0105734:	5e                   	pop    %esi
f0105735:	5d                   	pop    %ebp
f0105736:	c3                   	ret    

f0105737 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105737:	55                   	push   %ebp
f0105738:	89 e5                	mov    %esp,%ebp
f010573a:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010573d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105740:	eb 06                	jmp    f0105748 <strcmp+0x11>
		p++, q++;
f0105742:	83 c1 01             	add    $0x1,%ecx
f0105745:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f0105748:	0f b6 01             	movzbl (%ecx),%eax
f010574b:	84 c0                	test   %al,%al
f010574d:	74 04                	je     f0105753 <strcmp+0x1c>
f010574f:	3a 02                	cmp    (%edx),%al
f0105751:	74 ef                	je     f0105742 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105753:	0f b6 c0             	movzbl %al,%eax
f0105756:	0f b6 12             	movzbl (%edx),%edx
f0105759:	29 d0                	sub    %edx,%eax
}
f010575b:	5d                   	pop    %ebp
f010575c:	c3                   	ret    

f010575d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010575d:	55                   	push   %ebp
f010575e:	89 e5                	mov    %esp,%ebp
f0105760:	53                   	push   %ebx
f0105761:	8b 45 08             	mov    0x8(%ebp),%eax
f0105764:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105767:	89 c3                	mov    %eax,%ebx
f0105769:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010576c:	eb 06                	jmp    f0105774 <strncmp+0x17>
		n--, p++, q++;
f010576e:	83 c0 01             	add    $0x1,%eax
f0105771:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105774:	39 d8                	cmp    %ebx,%eax
f0105776:	74 16                	je     f010578e <strncmp+0x31>
f0105778:	0f b6 08             	movzbl (%eax),%ecx
f010577b:	84 c9                	test   %cl,%cl
f010577d:	74 04                	je     f0105783 <strncmp+0x26>
f010577f:	3a 0a                	cmp    (%edx),%cl
f0105781:	74 eb                	je     f010576e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105783:	0f b6 00             	movzbl (%eax),%eax
f0105786:	0f b6 12             	movzbl (%edx),%edx
f0105789:	29 d0                	sub    %edx,%eax
}
f010578b:	5b                   	pop    %ebx
f010578c:	5d                   	pop    %ebp
f010578d:	c3                   	ret    
		return 0;
f010578e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105793:	eb f6                	jmp    f010578b <strncmp+0x2e>

f0105795 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105795:	55                   	push   %ebp
f0105796:	89 e5                	mov    %esp,%ebp
f0105798:	8b 45 08             	mov    0x8(%ebp),%eax
f010579b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010579f:	0f b6 10             	movzbl (%eax),%edx
f01057a2:	84 d2                	test   %dl,%dl
f01057a4:	74 09                	je     f01057af <strchr+0x1a>
		if (*s == c)
f01057a6:	38 ca                	cmp    %cl,%dl
f01057a8:	74 0a                	je     f01057b4 <strchr+0x1f>
	for (; *s; s++)
f01057aa:	83 c0 01             	add    $0x1,%eax
f01057ad:	eb f0                	jmp    f010579f <strchr+0xa>
			return (char *) s;
	return 0;
f01057af:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01057b4:	5d                   	pop    %ebp
f01057b5:	c3                   	ret    

f01057b6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01057b6:	55                   	push   %ebp
f01057b7:	89 e5                	mov    %esp,%ebp
f01057b9:	8b 45 08             	mov    0x8(%ebp),%eax
f01057bc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01057c0:	eb 03                	jmp    f01057c5 <strfind+0xf>
f01057c2:	83 c0 01             	add    $0x1,%eax
f01057c5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01057c8:	38 ca                	cmp    %cl,%dl
f01057ca:	74 04                	je     f01057d0 <strfind+0x1a>
f01057cc:	84 d2                	test   %dl,%dl
f01057ce:	75 f2                	jne    f01057c2 <strfind+0xc>
			break;
	return (char *) s;
}
f01057d0:	5d                   	pop    %ebp
f01057d1:	c3                   	ret    

f01057d2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01057d2:	55                   	push   %ebp
f01057d3:	89 e5                	mov    %esp,%ebp
f01057d5:	57                   	push   %edi
f01057d6:	56                   	push   %esi
f01057d7:	53                   	push   %ebx
f01057d8:	8b 7d 08             	mov    0x8(%ebp),%edi
f01057db:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01057de:	85 c9                	test   %ecx,%ecx
f01057e0:	74 13                	je     f01057f5 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01057e2:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01057e8:	75 05                	jne    f01057ef <memset+0x1d>
f01057ea:	f6 c1 03             	test   $0x3,%cl
f01057ed:	74 0d                	je     f01057fc <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01057ef:	8b 45 0c             	mov    0xc(%ebp),%eax
f01057f2:	fc                   	cld    
f01057f3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01057f5:	89 f8                	mov    %edi,%eax
f01057f7:	5b                   	pop    %ebx
f01057f8:	5e                   	pop    %esi
f01057f9:	5f                   	pop    %edi
f01057fa:	5d                   	pop    %ebp
f01057fb:	c3                   	ret    
		c &= 0xFF;
f01057fc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0105800:	89 d3                	mov    %edx,%ebx
f0105802:	c1 e3 08             	shl    $0x8,%ebx
f0105805:	89 d0                	mov    %edx,%eax
f0105807:	c1 e0 18             	shl    $0x18,%eax
f010580a:	89 d6                	mov    %edx,%esi
f010580c:	c1 e6 10             	shl    $0x10,%esi
f010580f:	09 f0                	or     %esi,%eax
f0105811:	09 c2                	or     %eax,%edx
f0105813:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f0105815:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0105818:	89 d0                	mov    %edx,%eax
f010581a:	fc                   	cld    
f010581b:	f3 ab                	rep stos %eax,%es:(%edi)
f010581d:	eb d6                	jmp    f01057f5 <memset+0x23>

f010581f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f010581f:	55                   	push   %ebp
f0105820:	89 e5                	mov    %esp,%ebp
f0105822:	57                   	push   %edi
f0105823:	56                   	push   %esi
f0105824:	8b 45 08             	mov    0x8(%ebp),%eax
f0105827:	8b 75 0c             	mov    0xc(%ebp),%esi
f010582a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010582d:	39 c6                	cmp    %eax,%esi
f010582f:	73 35                	jae    f0105866 <memmove+0x47>
f0105831:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105834:	39 c2                	cmp    %eax,%edx
f0105836:	76 2e                	jbe    f0105866 <memmove+0x47>
		s += n;
		d += n;
f0105838:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010583b:	89 d6                	mov    %edx,%esi
f010583d:	09 fe                	or     %edi,%esi
f010583f:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105845:	74 0c                	je     f0105853 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105847:	83 ef 01             	sub    $0x1,%edi
f010584a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010584d:	fd                   	std    
f010584e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105850:	fc                   	cld    
f0105851:	eb 21                	jmp    f0105874 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105853:	f6 c1 03             	test   $0x3,%cl
f0105856:	75 ef                	jne    f0105847 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105858:	83 ef 04             	sub    $0x4,%edi
f010585b:	8d 72 fc             	lea    -0x4(%edx),%esi
f010585e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105861:	fd                   	std    
f0105862:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105864:	eb ea                	jmp    f0105850 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105866:	89 f2                	mov    %esi,%edx
f0105868:	09 c2                	or     %eax,%edx
f010586a:	f6 c2 03             	test   $0x3,%dl
f010586d:	74 09                	je     f0105878 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f010586f:	89 c7                	mov    %eax,%edi
f0105871:	fc                   	cld    
f0105872:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105874:	5e                   	pop    %esi
f0105875:	5f                   	pop    %edi
f0105876:	5d                   	pop    %ebp
f0105877:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105878:	f6 c1 03             	test   $0x3,%cl
f010587b:	75 f2                	jne    f010586f <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010587d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105880:	89 c7                	mov    %eax,%edi
f0105882:	fc                   	cld    
f0105883:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105885:	eb ed                	jmp    f0105874 <memmove+0x55>

f0105887 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105887:	55                   	push   %ebp
f0105888:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f010588a:	ff 75 10             	pushl  0x10(%ebp)
f010588d:	ff 75 0c             	pushl  0xc(%ebp)
f0105890:	ff 75 08             	pushl  0x8(%ebp)
f0105893:	e8 87 ff ff ff       	call   f010581f <memmove>
}
f0105898:	c9                   	leave  
f0105899:	c3                   	ret    

f010589a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f010589a:	55                   	push   %ebp
f010589b:	89 e5                	mov    %esp,%ebp
f010589d:	56                   	push   %esi
f010589e:	53                   	push   %ebx
f010589f:	8b 45 08             	mov    0x8(%ebp),%eax
f01058a2:	8b 55 0c             	mov    0xc(%ebp),%edx
f01058a5:	89 c6                	mov    %eax,%esi
f01058a7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01058aa:	39 f0                	cmp    %esi,%eax
f01058ac:	74 1c                	je     f01058ca <memcmp+0x30>
		if (*s1 != *s2)
f01058ae:	0f b6 08             	movzbl (%eax),%ecx
f01058b1:	0f b6 1a             	movzbl (%edx),%ebx
f01058b4:	38 d9                	cmp    %bl,%cl
f01058b6:	75 08                	jne    f01058c0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01058b8:	83 c0 01             	add    $0x1,%eax
f01058bb:	83 c2 01             	add    $0x1,%edx
f01058be:	eb ea                	jmp    f01058aa <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f01058c0:	0f b6 c1             	movzbl %cl,%eax
f01058c3:	0f b6 db             	movzbl %bl,%ebx
f01058c6:	29 d8                	sub    %ebx,%eax
f01058c8:	eb 05                	jmp    f01058cf <memcmp+0x35>
	}

	return 0;
f01058ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01058cf:	5b                   	pop    %ebx
f01058d0:	5e                   	pop    %esi
f01058d1:	5d                   	pop    %ebp
f01058d2:	c3                   	ret    

f01058d3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01058d3:	55                   	push   %ebp
f01058d4:	89 e5                	mov    %esp,%ebp
f01058d6:	8b 45 08             	mov    0x8(%ebp),%eax
f01058d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01058dc:	89 c2                	mov    %eax,%edx
f01058de:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01058e1:	39 d0                	cmp    %edx,%eax
f01058e3:	73 09                	jae    f01058ee <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01058e5:	38 08                	cmp    %cl,(%eax)
f01058e7:	74 05                	je     f01058ee <memfind+0x1b>
	for (; s < ends; s++)
f01058e9:	83 c0 01             	add    $0x1,%eax
f01058ec:	eb f3                	jmp    f01058e1 <memfind+0xe>
			break;
	return (void *) s;
}
f01058ee:	5d                   	pop    %ebp
f01058ef:	c3                   	ret    

f01058f0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01058f0:	55                   	push   %ebp
f01058f1:	89 e5                	mov    %esp,%ebp
f01058f3:	57                   	push   %edi
f01058f4:	56                   	push   %esi
f01058f5:	53                   	push   %ebx
f01058f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01058f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01058fc:	eb 03                	jmp    f0105901 <strtol+0x11>
		s++;
f01058fe:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0105901:	0f b6 01             	movzbl (%ecx),%eax
f0105904:	3c 20                	cmp    $0x20,%al
f0105906:	74 f6                	je     f01058fe <strtol+0xe>
f0105908:	3c 09                	cmp    $0x9,%al
f010590a:	74 f2                	je     f01058fe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f010590c:	3c 2b                	cmp    $0x2b,%al
f010590e:	74 2e                	je     f010593e <strtol+0x4e>
	int neg = 0;
f0105910:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0105915:	3c 2d                	cmp    $0x2d,%al
f0105917:	74 2f                	je     f0105948 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105919:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f010591f:	75 05                	jne    f0105926 <strtol+0x36>
f0105921:	80 39 30             	cmpb   $0x30,(%ecx)
f0105924:	74 2c                	je     f0105952 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0105926:	85 db                	test   %ebx,%ebx
f0105928:	75 0a                	jne    f0105934 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f010592a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f010592f:	80 39 30             	cmpb   $0x30,(%ecx)
f0105932:	74 28                	je     f010595c <strtol+0x6c>
		base = 10;
f0105934:	b8 00 00 00 00       	mov    $0x0,%eax
f0105939:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010593c:	eb 50                	jmp    f010598e <strtol+0x9e>
		s++;
f010593e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105941:	bf 00 00 00 00       	mov    $0x0,%edi
f0105946:	eb d1                	jmp    f0105919 <strtol+0x29>
		s++, neg = 1;
f0105948:	83 c1 01             	add    $0x1,%ecx
f010594b:	bf 01 00 00 00       	mov    $0x1,%edi
f0105950:	eb c7                	jmp    f0105919 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105952:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105956:	74 0e                	je     f0105966 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105958:	85 db                	test   %ebx,%ebx
f010595a:	75 d8                	jne    f0105934 <strtol+0x44>
		s++, base = 8;
f010595c:	83 c1 01             	add    $0x1,%ecx
f010595f:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105964:	eb ce                	jmp    f0105934 <strtol+0x44>
		s += 2, base = 16;
f0105966:	83 c1 02             	add    $0x2,%ecx
f0105969:	bb 10 00 00 00       	mov    $0x10,%ebx
f010596e:	eb c4                	jmp    f0105934 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0105970:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105973:	89 f3                	mov    %esi,%ebx
f0105975:	80 fb 19             	cmp    $0x19,%bl
f0105978:	77 29                	ja     f01059a3 <strtol+0xb3>
			dig = *s - 'a' + 10;
f010597a:	0f be d2             	movsbl %dl,%edx
f010597d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105980:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105983:	7d 30                	jge    f01059b5 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105985:	83 c1 01             	add    $0x1,%ecx
f0105988:	0f af 45 10          	imul   0x10(%ebp),%eax
f010598c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f010598e:	0f b6 11             	movzbl (%ecx),%edx
f0105991:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105994:	89 f3                	mov    %esi,%ebx
f0105996:	80 fb 09             	cmp    $0x9,%bl
f0105999:	77 d5                	ja     f0105970 <strtol+0x80>
			dig = *s - '0';
f010599b:	0f be d2             	movsbl %dl,%edx
f010599e:	83 ea 30             	sub    $0x30,%edx
f01059a1:	eb dd                	jmp    f0105980 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f01059a3:	8d 72 bf             	lea    -0x41(%edx),%esi
f01059a6:	89 f3                	mov    %esi,%ebx
f01059a8:	80 fb 19             	cmp    $0x19,%bl
f01059ab:	77 08                	ja     f01059b5 <strtol+0xc5>
			dig = *s - 'A' + 10;
f01059ad:	0f be d2             	movsbl %dl,%edx
f01059b0:	83 ea 37             	sub    $0x37,%edx
f01059b3:	eb cb                	jmp    f0105980 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f01059b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01059b9:	74 05                	je     f01059c0 <strtol+0xd0>
		*endptr = (char *) s;
f01059bb:	8b 75 0c             	mov    0xc(%ebp),%esi
f01059be:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f01059c0:	89 c2                	mov    %eax,%edx
f01059c2:	f7 da                	neg    %edx
f01059c4:	85 ff                	test   %edi,%edi
f01059c6:	0f 45 c2             	cmovne %edx,%eax
}
f01059c9:	5b                   	pop    %ebx
f01059ca:	5e                   	pop    %esi
f01059cb:	5f                   	pop    %edi
f01059cc:	5d                   	pop    %ebp
f01059cd:	c3                   	ret    
f01059ce:	66 90                	xchg   %ax,%ax

f01059d0 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01059d0:	fa                   	cli    

	xorw    %ax, %ax
f01059d1:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01059d3:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01059d5:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01059d7:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01059d9:	0f 01 16             	lgdtl  (%esi)
f01059dc:	74 70                	je     f0105a4e <mpsearch1+0x3>
	movl    %cr0, %eax
f01059de:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01059e1:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01059e5:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01059e8:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01059ee:	08 00                	or     %al,(%eax)

f01059f0 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01059f0:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01059f4:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01059f6:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01059f8:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01059fa:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01059fe:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0105a00:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0105a02:	b8 00 00 12 00       	mov    $0x120000,%eax
	movl    %eax, %cr3
f0105a07:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0105a0a:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105a0d:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105a12:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0105a15:	8b 25 84 9e 1e f0    	mov    0xf01e9e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105a1b:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105a20:	b8 b4 01 10 f0       	mov    $0xf01001b4,%eax
	call    *%eax
f0105a25:	ff d0                	call   *%eax

f0105a27 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105a27:	eb fe                	jmp    f0105a27 <spin>
f0105a29:	8d 76 00             	lea    0x0(%esi),%esi

f0105a2c <gdt>:
	...
f0105a34:	ff                   	(bad)  
f0105a35:	ff 00                	incl   (%eax)
f0105a37:	00 00                	add    %al,(%eax)
f0105a39:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105a40:	00                   	.byte 0x0
f0105a41:	92                   	xchg   %eax,%edx
f0105a42:	cf                   	iret   
	...

f0105a44 <gdtdesc>:
f0105a44:	17                   	pop    %ss
f0105a45:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105a4a <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105a4a:	90                   	nop

f0105a4b <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105a4b:	55                   	push   %ebp
f0105a4c:	89 e5                	mov    %esp,%ebp
f0105a4e:	57                   	push   %edi
f0105a4f:	56                   	push   %esi
f0105a50:	53                   	push   %ebx
f0105a51:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0105a54:	8b 0d 88 9e 1e f0    	mov    0xf01e9e88,%ecx
f0105a5a:	89 c3                	mov    %eax,%ebx
f0105a5c:	c1 eb 0c             	shr    $0xc,%ebx
f0105a5f:	39 cb                	cmp    %ecx,%ebx
f0105a61:	73 1a                	jae    f0105a7d <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105a63:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105a69:	8d 34 02             	lea    (%edx,%eax,1),%esi
	if (PGNUM(pa) >= npages)
f0105a6c:	89 f0                	mov    %esi,%eax
f0105a6e:	c1 e8 0c             	shr    $0xc,%eax
f0105a71:	39 c8                	cmp    %ecx,%eax
f0105a73:	73 1a                	jae    f0105a8f <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105a75:	81 ee 00 00 00 10    	sub    $0x10000000,%esi

	for (; mp < end; mp++)
f0105a7b:	eb 27                	jmp    f0105aa4 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105a7d:	50                   	push   %eax
f0105a7e:	68 64 64 10 f0       	push   $0xf0106464
f0105a83:	6a 57                	push   $0x57
f0105a85:	68 5d 80 10 f0       	push   $0xf010805d
f0105a8a:	e8 b1 a5 ff ff       	call   f0100040 <_panic>
f0105a8f:	56                   	push   %esi
f0105a90:	68 64 64 10 f0       	push   $0xf0106464
f0105a95:	6a 57                	push   $0x57
f0105a97:	68 5d 80 10 f0       	push   $0xf010805d
f0105a9c:	e8 9f a5 ff ff       	call   f0100040 <_panic>
f0105aa1:	83 c3 10             	add    $0x10,%ebx
f0105aa4:	39 f3                	cmp    %esi,%ebx
f0105aa6:	73 2e                	jae    f0105ad6 <mpsearch1+0x8b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105aa8:	83 ec 04             	sub    $0x4,%esp
f0105aab:	6a 04                	push   $0x4
f0105aad:	68 6d 80 10 f0       	push   $0xf010806d
f0105ab2:	53                   	push   %ebx
f0105ab3:	e8 e2 fd ff ff       	call   f010589a <memcmp>
f0105ab8:	83 c4 10             	add    $0x10,%esp
f0105abb:	85 c0                	test   %eax,%eax
f0105abd:	75 e2                	jne    f0105aa1 <mpsearch1+0x56>
f0105abf:	89 da                	mov    %ebx,%edx
f0105ac1:	8d 7b 10             	lea    0x10(%ebx),%edi
		sum += ((uint8_t *)addr)[i];
f0105ac4:	0f b6 0a             	movzbl (%edx),%ecx
f0105ac7:	01 c8                	add    %ecx,%eax
f0105ac9:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105acc:	39 fa                	cmp    %edi,%edx
f0105ace:	75 f4                	jne    f0105ac4 <mpsearch1+0x79>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105ad0:	84 c0                	test   %al,%al
f0105ad2:	75 cd                	jne    f0105aa1 <mpsearch1+0x56>
f0105ad4:	eb 05                	jmp    f0105adb <mpsearch1+0x90>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105ad6:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105adb:	89 d8                	mov    %ebx,%eax
f0105add:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105ae0:	5b                   	pop    %ebx
f0105ae1:	5e                   	pop    %esi
f0105ae2:	5f                   	pop    %edi
f0105ae3:	5d                   	pop    %ebp
f0105ae4:	c3                   	ret    

f0105ae5 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0105ae5:	55                   	push   %ebp
f0105ae6:	89 e5                	mov    %esp,%ebp
f0105ae8:	57                   	push   %edi
f0105ae9:	56                   	push   %esi
f0105aea:	53                   	push   %ebx
f0105aeb:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105aee:	c7 05 c0 a3 1e f0 20 	movl   $0xf01ea020,0xf01ea3c0
f0105af5:	a0 1e f0 
	if (PGNUM(pa) >= npages)
f0105af8:	83 3d 88 9e 1e f0 00 	cmpl   $0x0,0xf01e9e88
f0105aff:	0f 84 87 00 00 00    	je     f0105b8c <mp_init+0xa7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105b05:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0105b0c:	85 c0                	test   %eax,%eax
f0105b0e:	0f 84 8e 00 00 00    	je     f0105ba2 <mp_init+0xbd>
		p <<= 4;	// Translate from segment to PA
f0105b14:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105b17:	ba 00 04 00 00       	mov    $0x400,%edx
f0105b1c:	e8 2a ff ff ff       	call   f0105a4b <mpsearch1>
f0105b21:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105b24:	85 c0                	test   %eax,%eax
f0105b26:	0f 84 9a 00 00 00    	je     f0105bc6 <mp_init+0xe1>
	if (mp->physaddr == 0 || mp->type != 0) {
f0105b2c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105b2f:	8b 41 04             	mov    0x4(%ecx),%eax
f0105b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105b35:	85 c0                	test   %eax,%eax
f0105b37:	0f 84 a8 00 00 00    	je     f0105be5 <mp_init+0x100>
f0105b3d:	80 79 0b 00          	cmpb   $0x0,0xb(%ecx)
f0105b41:	0f 85 9e 00 00 00    	jne    f0105be5 <mp_init+0x100>
f0105b47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b4a:	c1 e8 0c             	shr    $0xc,%eax
f0105b4d:	3b 05 88 9e 1e f0    	cmp    0xf01e9e88,%eax
f0105b53:	0f 83 a1 00 00 00    	jae    f0105bfa <mp_init+0x115>
	return (void *)(pa + KERNBASE);
f0105b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b5c:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f0105b62:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105b64:	83 ec 04             	sub    $0x4,%esp
f0105b67:	6a 04                	push   $0x4
f0105b69:	68 72 80 10 f0       	push   $0xf0108072
f0105b6e:	53                   	push   %ebx
f0105b6f:	e8 26 fd ff ff       	call   f010589a <memcmp>
f0105b74:	83 c4 10             	add    $0x10,%esp
f0105b77:	85 c0                	test   %eax,%eax
f0105b79:	0f 85 92 00 00 00    	jne    f0105c11 <mp_init+0x12c>
f0105b7f:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105b83:	01 df                	add    %ebx,%edi
	sum = 0;
f0105b85:	89 c2                	mov    %eax,%edx
f0105b87:	e9 a2 00 00 00       	jmp    f0105c2e <mp_init+0x149>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105b8c:	68 00 04 00 00       	push   $0x400
f0105b91:	68 64 64 10 f0       	push   $0xf0106464
f0105b96:	6a 6f                	push   $0x6f
f0105b98:	68 5d 80 10 f0       	push   $0xf010805d
f0105b9d:	e8 9e a4 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105ba2:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105ba9:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105bac:	2d 00 04 00 00       	sub    $0x400,%eax
f0105bb1:	ba 00 04 00 00       	mov    $0x400,%edx
f0105bb6:	e8 90 fe ff ff       	call   f0105a4b <mpsearch1>
f0105bbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105bbe:	85 c0                	test   %eax,%eax
f0105bc0:	0f 85 66 ff ff ff    	jne    f0105b2c <mp_init+0x47>
	return mpsearch1(0xF0000, 0x10000);
f0105bc6:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105bcb:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105bd0:	e8 76 fe ff ff       	call   f0105a4b <mpsearch1>
f0105bd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if ((mp = mpsearch()) == 0)
f0105bd8:	85 c0                	test   %eax,%eax
f0105bda:	0f 85 4c ff ff ff    	jne    f0105b2c <mp_init+0x47>
f0105be0:	e9 a8 01 00 00       	jmp    f0105d8d <mp_init+0x2a8>
		cprintf("SMP: Default configurations not implemented\n");
f0105be5:	83 ec 0c             	sub    $0xc,%esp
f0105be8:	68 d0 7e 10 f0       	push   $0xf0107ed0
f0105bed:	e8 a1 dc ff ff       	call   f0103893 <cprintf>
f0105bf2:	83 c4 10             	add    $0x10,%esp
f0105bf5:	e9 93 01 00 00       	jmp    f0105d8d <mp_init+0x2a8>
f0105bfa:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105bfd:	68 64 64 10 f0       	push   $0xf0106464
f0105c02:	68 90 00 00 00       	push   $0x90
f0105c07:	68 5d 80 10 f0       	push   $0xf010805d
f0105c0c:	e8 2f a4 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105c11:	83 ec 0c             	sub    $0xc,%esp
f0105c14:	68 00 7f 10 f0       	push   $0xf0107f00
f0105c19:	e8 75 dc ff ff       	call   f0103893 <cprintf>
f0105c1e:	83 c4 10             	add    $0x10,%esp
f0105c21:	e9 67 01 00 00       	jmp    f0105d8d <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105c26:	0f b6 0b             	movzbl (%ebx),%ecx
f0105c29:	01 ca                	add    %ecx,%edx
f0105c2b:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105c2e:	39 fb                	cmp    %edi,%ebx
f0105c30:	75 f4                	jne    f0105c26 <mp_init+0x141>
	if (sum(conf, conf->length) != 0) {
f0105c32:	84 d2                	test   %dl,%dl
f0105c34:	75 16                	jne    f0105c4c <mp_init+0x167>
	if (conf->version != 1 && conf->version != 4) {
f0105c36:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105c3a:	80 fa 01             	cmp    $0x1,%dl
f0105c3d:	74 05                	je     f0105c44 <mp_init+0x15f>
f0105c3f:	80 fa 04             	cmp    $0x4,%dl
f0105c42:	75 1d                	jne    f0105c61 <mp_init+0x17c>
f0105c44:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105c48:	01 d9                	add    %ebx,%ecx
f0105c4a:	eb 36                	jmp    f0105c82 <mp_init+0x19d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105c4c:	83 ec 0c             	sub    $0xc,%esp
f0105c4f:	68 34 7f 10 f0       	push   $0xf0107f34
f0105c54:	e8 3a dc ff ff       	call   f0103893 <cprintf>
f0105c59:	83 c4 10             	add    $0x10,%esp
f0105c5c:	e9 2c 01 00 00       	jmp    f0105d8d <mp_init+0x2a8>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105c61:	83 ec 08             	sub    $0x8,%esp
f0105c64:	0f b6 d2             	movzbl %dl,%edx
f0105c67:	52                   	push   %edx
f0105c68:	68 58 7f 10 f0       	push   $0xf0107f58
f0105c6d:	e8 21 dc ff ff       	call   f0103893 <cprintf>
f0105c72:	83 c4 10             	add    $0x10,%esp
f0105c75:	e9 13 01 00 00       	jmp    f0105d8d <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105c7a:	0f b6 13             	movzbl (%ebx),%edx
f0105c7d:	01 d0                	add    %edx,%eax
f0105c7f:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105c82:	39 d9                	cmp    %ebx,%ecx
f0105c84:	75 f4                	jne    f0105c7a <mp_init+0x195>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105c86:	02 46 2a             	add    0x2a(%esi),%al
f0105c89:	75 29                	jne    f0105cb4 <mp_init+0x1cf>
	if ((conf = mpconfig(&mp)) == 0)
f0105c8b:	81 7d e4 00 00 00 10 	cmpl   $0x10000000,-0x1c(%ebp)
f0105c92:	0f 84 f5 00 00 00    	je     f0105d8d <mp_init+0x2a8>
		return;
	ismp = 1;
f0105c98:	c7 05 00 a0 1e f0 01 	movl   $0x1,0xf01ea000
f0105c9f:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105ca2:	8b 46 24             	mov    0x24(%esi),%eax
f0105ca5:	a3 00 b0 22 f0       	mov    %eax,0xf022b000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105caa:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105cad:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105cb2:	eb 4d                	jmp    f0105d01 <mp_init+0x21c>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105cb4:	83 ec 0c             	sub    $0xc,%esp
f0105cb7:	68 78 7f 10 f0       	push   $0xf0107f78
f0105cbc:	e8 d2 db ff ff       	call   f0103893 <cprintf>
f0105cc1:	83 c4 10             	add    $0x10,%esp
f0105cc4:	e9 c4 00 00 00       	jmp    f0105d8d <mp_init+0x2a8>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)			//如果设置了该标志位表明当前CPU是BSP
f0105cc9:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105ccd:	74 11                	je     f0105ce0 <mp_init+0x1fb>
				bootcpu = &cpus[ncpu];
f0105ccf:	6b 05 c4 a3 1e f0 74 	imul   $0x74,0xf01ea3c4,%eax
f0105cd6:	05 20 a0 1e f0       	add    $0xf01ea020,%eax
f0105cdb:	a3 c0 a3 1e f0       	mov    %eax,0xf01ea3c0
			if (ncpu < NCPU) {
f0105ce0:	a1 c4 a3 1e f0       	mov    0xf01ea3c4,%eax
f0105ce5:	83 f8 07             	cmp    $0x7,%eax
f0105ce8:	7f 2f                	jg     f0105d19 <mp_init+0x234>
				cpus[ncpu].cpu_id = ncpu;			//设置id
f0105cea:	6b d0 74             	imul   $0x74,%eax,%edx
f0105ced:	88 82 20 a0 1e f0    	mov    %al,-0xfe15fe0(%edx)
				ncpu++;
f0105cf3:	83 c0 01             	add    $0x1,%eax
f0105cf6:	a3 c4 a3 1e f0       	mov    %eax,0xf01ea3c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105cfb:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105cfe:	83 c3 01             	add    $0x1,%ebx
f0105d01:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0105d05:	39 d8                	cmp    %ebx,%eax
f0105d07:	76 4b                	jbe    f0105d54 <mp_init+0x26f>
		switch (*p) {
f0105d09:	0f b6 07             	movzbl (%edi),%eax
f0105d0c:	84 c0                	test   %al,%al
f0105d0e:	74 b9                	je     f0105cc9 <mp_init+0x1e4>
f0105d10:	3c 04                	cmp    $0x4,%al
f0105d12:	77 1c                	ja     f0105d30 <mp_init+0x24b>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105d14:	83 c7 08             	add    $0x8,%edi
			continue;
f0105d17:	eb e5                	jmp    f0105cfe <mp_init+0x219>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105d19:	83 ec 08             	sub    $0x8,%esp
f0105d1c:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0105d20:	50                   	push   %eax
f0105d21:	68 a8 7f 10 f0       	push   $0xf0107fa8
f0105d26:	e8 68 db ff ff       	call   f0103893 <cprintf>
f0105d2b:	83 c4 10             	add    $0x10,%esp
f0105d2e:	eb cb                	jmp    f0105cfb <mp_init+0x216>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105d30:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105d33:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105d36:	50                   	push   %eax
f0105d37:	68 d0 7f 10 f0       	push   $0xf0107fd0
f0105d3c:	e8 52 db ff ff       	call   f0103893 <cprintf>
			ismp = 0;
f0105d41:	c7 05 00 a0 1e f0 00 	movl   $0x0,0xf01ea000
f0105d48:	00 00 00 
			i = conf->entry;
f0105d4b:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0105d4f:	83 c4 10             	add    $0x10,%esp
f0105d52:	eb aa                	jmp    f0105cfe <mp_init+0x219>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105d54:	a1 c0 a3 1e f0       	mov    0xf01ea3c0,%eax
f0105d59:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105d60:	83 3d 00 a0 1e f0 00 	cmpl   $0x0,0xf01ea000
f0105d67:	75 2c                	jne    f0105d95 <mp_init+0x2b0>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0105d69:	c7 05 c4 a3 1e f0 01 	movl   $0x1,0xf01ea3c4
f0105d70:	00 00 00 
		lapicaddr = 0;
f0105d73:	c7 05 00 b0 22 f0 00 	movl   $0x0,0xf022b000
f0105d7a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105d7d:	83 ec 0c             	sub    $0xc,%esp
f0105d80:	68 f0 7f 10 f0       	push   $0xf0107ff0
f0105d85:	e8 09 db ff ff       	call   f0103893 <cprintf>
		return;
f0105d8a:	83 c4 10             	add    $0x10,%esp
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105d90:	5b                   	pop    %ebx
f0105d91:	5e                   	pop    %esi
f0105d92:	5f                   	pop    %edi
f0105d93:	5d                   	pop    %ebp
f0105d94:	c3                   	ret    
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105d95:	83 ec 04             	sub    $0x4,%esp
f0105d98:	ff 35 c4 a3 1e f0    	pushl  0xf01ea3c4
f0105d9e:	0f b6 00             	movzbl (%eax),%eax
f0105da1:	50                   	push   %eax
f0105da2:	68 77 80 10 f0       	push   $0xf0108077
f0105da7:	e8 e7 da ff ff       	call   f0103893 <cprintf>
	if (mp->imcrp) {
f0105dac:	83 c4 10             	add    $0x10,%esp
f0105daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105db2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105db6:	74 d5                	je     f0105d8d <mp_init+0x2a8>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105db8:	83 ec 0c             	sub    $0xc,%esp
f0105dbb:	68 1c 80 10 f0       	push   $0xf010801c
f0105dc0:	e8 ce da ff ff       	call   f0103893 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105dc5:	b8 70 00 00 00       	mov    $0x70,%eax
f0105dca:	ba 22 00 00 00       	mov    $0x22,%edx
f0105dcf:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105dd0:	ba 23 00 00 00       	mov    $0x23,%edx
f0105dd5:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105dd6:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105dd9:	ee                   	out    %al,(%dx)
f0105dda:	83 c4 10             	add    $0x10,%esp
f0105ddd:	eb ae                	jmp    f0105d8d <mp_init+0x2a8>

f0105ddf <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f0105ddf:	55                   	push   %ebp
f0105de0:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f0105de2:	8b 0d 04 b0 22 f0    	mov    0xf022b004,%ecx
f0105de8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105deb:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0105ded:	a1 04 b0 22 f0       	mov    0xf022b004,%eax
f0105df2:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105df5:	5d                   	pop    %ebp
f0105df6:	c3                   	ret    

f0105df7 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0105df7:	55                   	push   %ebp
f0105df8:	89 e5                	mov    %esp,%ebp
	if (lapic)
f0105dfa:	8b 15 04 b0 22 f0    	mov    0xf022b004,%edx
		return lapic[ID] >> 24;
	return 0;
f0105e00:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0105e05:	85 d2                	test   %edx,%edx
f0105e07:	74 06                	je     f0105e0f <cpunum+0x18>
		return lapic[ID] >> 24;
f0105e09:	8b 42 20             	mov    0x20(%edx),%eax
f0105e0c:	c1 e8 18             	shr    $0x18,%eax
}
f0105e0f:	5d                   	pop    %ebp
f0105e10:	c3                   	ret    

f0105e11 <lapic_init>:
	if (!lapicaddr)
f0105e11:	a1 00 b0 22 f0       	mov    0xf022b000,%eax
f0105e16:	85 c0                	test   %eax,%eax
f0105e18:	75 02                	jne    f0105e1c <lapic_init+0xb>
f0105e1a:	f3 c3                	repz ret 
{
f0105e1c:	55                   	push   %ebp
f0105e1d:	89 e5                	mov    %esp,%ebp
f0105e1f:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0105e22:	68 00 10 00 00       	push   $0x1000
f0105e27:	50                   	push   %eax
f0105e28:	e8 38 b4 ff ff       	call   f0101265 <mmio_map_region>
f0105e2d:	a3 04 b0 22 f0       	mov    %eax,0xf022b004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0105e32:	ba 27 01 00 00       	mov    $0x127,%edx
f0105e37:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105e3c:	e8 9e ff ff ff       	call   f0105ddf <lapicw>
	lapicw(TDCR, X1);
f0105e41:	ba 0b 00 00 00       	mov    $0xb,%edx
f0105e46:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105e4b:	e8 8f ff ff ff       	call   f0105ddf <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105e50:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105e55:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105e5a:	e8 80 ff ff ff       	call   f0105ddf <lapicw>
	lapicw(TICR, 10000000); 
f0105e5f:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105e64:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105e69:	e8 71 ff ff ff       	call   f0105ddf <lapicw>
	if (thiscpu != bootcpu)
f0105e6e:	e8 84 ff ff ff       	call   f0105df7 <cpunum>
f0105e73:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e76:	05 20 a0 1e f0       	add    $0xf01ea020,%eax
f0105e7b:	83 c4 10             	add    $0x10,%esp
f0105e7e:	39 05 c0 a3 1e f0    	cmp    %eax,0xf01ea3c0
f0105e84:	74 0f                	je     f0105e95 <lapic_init+0x84>
		lapicw(LINT0, MASKED);
f0105e86:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105e8b:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105e90:	e8 4a ff ff ff       	call   f0105ddf <lapicw>
	lapicw(LINT1, MASKED);
f0105e95:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105e9a:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105e9f:	e8 3b ff ff ff       	call   f0105ddf <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0105ea4:	a1 04 b0 22 f0       	mov    0xf022b004,%eax
f0105ea9:	8b 40 30             	mov    0x30(%eax),%eax
f0105eac:	c1 e8 10             	shr    $0x10,%eax
f0105eaf:	3c 03                	cmp    $0x3,%al
f0105eb1:	77 7c                	ja     f0105f2f <lapic_init+0x11e>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105eb3:	ba 33 00 00 00       	mov    $0x33,%edx
f0105eb8:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105ebd:	e8 1d ff ff ff       	call   f0105ddf <lapicw>
	lapicw(ESR, 0);
f0105ec2:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ec7:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105ecc:	e8 0e ff ff ff       	call   f0105ddf <lapicw>
	lapicw(ESR, 0);
f0105ed1:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ed6:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105edb:	e8 ff fe ff ff       	call   f0105ddf <lapicw>
	lapicw(EOI, 0);
f0105ee0:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ee5:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105eea:	e8 f0 fe ff ff       	call   f0105ddf <lapicw>
	lapicw(ICRHI, 0);
f0105eef:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ef4:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105ef9:	e8 e1 fe ff ff       	call   f0105ddf <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105efe:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105f03:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105f08:	e8 d2 fe ff ff       	call   f0105ddf <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0105f0d:	8b 15 04 b0 22 f0    	mov    0xf022b004,%edx
f0105f13:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105f19:	f6 c4 10             	test   $0x10,%ah
f0105f1c:	75 f5                	jne    f0105f13 <lapic_init+0x102>
	lapicw(TPR, 0);
f0105f1e:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f23:	b8 20 00 00 00       	mov    $0x20,%eax
f0105f28:	e8 b2 fe ff ff       	call   f0105ddf <lapicw>
}
f0105f2d:	c9                   	leave  
f0105f2e:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0105f2f:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105f34:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105f39:	e8 a1 fe ff ff       	call   f0105ddf <lapicw>
f0105f3e:	e9 70 ff ff ff       	jmp    f0105eb3 <lapic_init+0xa2>

f0105f43 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0105f43:	83 3d 04 b0 22 f0 00 	cmpl   $0x0,0xf022b004
f0105f4a:	74 14                	je     f0105f60 <lapic_eoi+0x1d>
{
f0105f4c:	55                   	push   %ebp
f0105f4d:	89 e5                	mov    %esp,%ebp
		lapicw(EOI, 0);
f0105f4f:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f54:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105f59:	e8 81 fe ff ff       	call   f0105ddf <lapicw>
}
f0105f5e:	5d                   	pop    %ebp
f0105f5f:	c3                   	ret    
f0105f60:	f3 c3                	repz ret 

f0105f62 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0105f62:	55                   	push   %ebp
f0105f63:	89 e5                	mov    %esp,%ebp
f0105f65:	56                   	push   %esi
f0105f66:	53                   	push   %ebx
f0105f67:	8b 75 08             	mov    0x8(%ebp),%esi
f0105f6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105f6d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0105f72:	ba 70 00 00 00       	mov    $0x70,%edx
f0105f77:	ee                   	out    %al,(%dx)
f0105f78:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f7d:	ba 71 00 00 00       	mov    $0x71,%edx
f0105f82:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0105f83:	83 3d 88 9e 1e f0 00 	cmpl   $0x0,0xf01e9e88
f0105f8a:	74 7e                	je     f010600a <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0105f8c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0105f93:	00 00 
	wrv[1] = addr >> 4;
f0105f95:	89 d8                	mov    %ebx,%eax
f0105f97:	c1 e8 04             	shr    $0x4,%eax
f0105f9a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0105fa0:	c1 e6 18             	shl    $0x18,%esi
f0105fa3:	89 f2                	mov    %esi,%edx
f0105fa5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105faa:	e8 30 fe ff ff       	call   f0105ddf <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0105faf:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0105fb4:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105fb9:	e8 21 fe ff ff       	call   f0105ddf <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0105fbe:	ba 00 85 00 00       	mov    $0x8500,%edx
f0105fc3:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105fc8:	e8 12 fe ff ff       	call   f0105ddf <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105fcd:	c1 eb 0c             	shr    $0xc,%ebx
f0105fd0:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0105fd3:	89 f2                	mov    %esi,%edx
f0105fd5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105fda:	e8 00 fe ff ff       	call   f0105ddf <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105fdf:	89 da                	mov    %ebx,%edx
f0105fe1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105fe6:	e8 f4 fd ff ff       	call   f0105ddf <lapicw>
		lapicw(ICRHI, apicid << 24);
f0105feb:	89 f2                	mov    %esi,%edx
f0105fed:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105ff2:	e8 e8 fd ff ff       	call   f0105ddf <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105ff7:	89 da                	mov    %ebx,%edx
f0105ff9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105ffe:	e8 dc fd ff ff       	call   f0105ddf <lapicw>
		microdelay(200);
	}
}
f0106003:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106006:	5b                   	pop    %ebx
f0106007:	5e                   	pop    %esi
f0106008:	5d                   	pop    %ebp
f0106009:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010600a:	68 67 04 00 00       	push   $0x467
f010600f:	68 64 64 10 f0       	push   $0xf0106464
f0106014:	68 98 00 00 00       	push   $0x98
f0106019:	68 94 80 10 f0       	push   $0xf0108094
f010601e:	e8 1d a0 ff ff       	call   f0100040 <_panic>

f0106023 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106023:	55                   	push   %ebp
f0106024:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106026:	8b 55 08             	mov    0x8(%ebp),%edx
f0106029:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f010602f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106034:	e8 a6 fd ff ff       	call   f0105ddf <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106039:	8b 15 04 b0 22 f0    	mov    0xf022b004,%edx
f010603f:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106045:	f6 c4 10             	test   $0x10,%ah
f0106048:	75 f5                	jne    f010603f <lapic_ipi+0x1c>
		;
}
f010604a:	5d                   	pop    %ebp
f010604b:	c3                   	ret    

f010604c <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f010604c:	55                   	push   %ebp
f010604d:	89 e5                	mov    %esp,%ebp
f010604f:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106052:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106058:	8b 55 0c             	mov    0xc(%ebp),%edx
f010605b:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f010605e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106065:	5d                   	pop    %ebp
f0106066:	c3                   	ret    

f0106067 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106067:	55                   	push   %ebp
f0106068:	89 e5                	mov    %esp,%ebp
f010606a:	56                   	push   %esi
f010606b:	53                   	push   %ebx
f010606c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f010606f:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106072:	75 07                	jne    f010607b <spin_lock+0x14>
	asm volatile("lock; xchgl %0, %1"
f0106074:	ba 01 00 00 00       	mov    $0x1,%edx
f0106079:	eb 34                	jmp    f01060af <spin_lock+0x48>
f010607b:	8b 73 08             	mov    0x8(%ebx),%esi
f010607e:	e8 74 fd ff ff       	call   f0105df7 <cpunum>
f0106083:	6b c0 74             	imul   $0x74,%eax,%eax
f0106086:	05 20 a0 1e f0       	add    $0xf01ea020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f010608b:	39 c6                	cmp    %eax,%esi
f010608d:	75 e5                	jne    f0106074 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f010608f:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106092:	e8 60 fd ff ff       	call   f0105df7 <cpunum>
f0106097:	83 ec 0c             	sub    $0xc,%esp
f010609a:	53                   	push   %ebx
f010609b:	50                   	push   %eax
f010609c:	68 a4 80 10 f0       	push   $0xf01080a4
f01060a1:	6a 41                	push   $0x41
f01060a3:	68 08 81 10 f0       	push   $0xf0108108
f01060a8:	e8 93 9f ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)			//原理见：https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf  chapter 4
		asm volatile ("pause");	
f01060ad:	f3 90                	pause  
f01060af:	89 d0                	mov    %edx,%eax
f01060b1:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)			//原理见：https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf  chapter 4
f01060b4:	85 c0                	test   %eax,%eax
f01060b6:	75 f5                	jne    f01060ad <spin_lock+0x46>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f01060b8:	e8 3a fd ff ff       	call   f0105df7 <cpunum>
f01060bd:	6b c0 74             	imul   $0x74,%eax,%eax
f01060c0:	05 20 a0 1e f0       	add    $0xf01ea020,%eax
f01060c5:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f01060c8:	83 c3 0c             	add    $0xc,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01060cb:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f01060cd:	b8 00 00 00 00       	mov    $0x0,%eax
f01060d2:	eb 0b                	jmp    f01060df <spin_lock+0x78>
		pcs[i] = ebp[1];          // saved %eip
f01060d4:	8b 4a 04             	mov    0x4(%edx),%ecx
f01060d7:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f01060da:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f01060dc:	83 c0 01             	add    $0x1,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01060df:	83 f8 09             	cmp    $0x9,%eax
f01060e2:	7f 14                	jg     f01060f8 <spin_lock+0x91>
f01060e4:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f01060ea:	77 e8                	ja     f01060d4 <spin_lock+0x6d>
f01060ec:	eb 0a                	jmp    f01060f8 <spin_lock+0x91>
		pcs[i] = 0;
f01060ee:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
	for (; i < 10; i++)
f01060f5:	83 c0 01             	add    $0x1,%eax
f01060f8:	83 f8 09             	cmp    $0x9,%eax
f01060fb:	7e f1                	jle    f01060ee <spin_lock+0x87>
#endif
}
f01060fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106100:	5b                   	pop    %ebx
f0106101:	5e                   	pop    %esi
f0106102:	5d                   	pop    %ebp
f0106103:	c3                   	ret    

f0106104 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106104:	55                   	push   %ebp
f0106105:	89 e5                	mov    %esp,%ebp
f0106107:	57                   	push   %edi
f0106108:	56                   	push   %esi
f0106109:	53                   	push   %ebx
f010610a:	83 ec 4c             	sub    $0x4c,%esp
f010610d:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106110:	83 3e 00             	cmpl   $0x0,(%esi)
f0106113:	75 35                	jne    f010614a <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106115:	83 ec 04             	sub    $0x4,%esp
f0106118:	6a 28                	push   $0x28
f010611a:	8d 46 0c             	lea    0xc(%esi),%eax
f010611d:	50                   	push   %eax
f010611e:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106121:	53                   	push   %ebx
f0106122:	e8 f8 f6 ff ff       	call   f010581f <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106127:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f010612a:	0f b6 38             	movzbl (%eax),%edi
f010612d:	8b 76 04             	mov    0x4(%esi),%esi
f0106130:	e8 c2 fc ff ff       	call   f0105df7 <cpunum>
f0106135:	57                   	push   %edi
f0106136:	56                   	push   %esi
f0106137:	50                   	push   %eax
f0106138:	68 d0 80 10 f0       	push   $0xf01080d0
f010613d:	e8 51 d7 ff ff       	call   f0103893 <cprintf>
f0106142:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106145:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106148:	eb 61                	jmp    f01061ab <spin_unlock+0xa7>
	return lock->locked && lock->cpu == thiscpu;
f010614a:	8b 5e 08             	mov    0x8(%esi),%ebx
f010614d:	e8 a5 fc ff ff       	call   f0105df7 <cpunum>
f0106152:	6b c0 74             	imul   $0x74,%eax,%eax
f0106155:	05 20 a0 1e f0       	add    $0xf01ea020,%eax
	if (!holding(lk)) {
f010615a:	39 c3                	cmp    %eax,%ebx
f010615c:	75 b7                	jne    f0106115 <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f010615e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106165:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f010616c:	b8 00 00 00 00       	mov    $0x0,%eax
f0106171:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106174:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106177:	5b                   	pop    %ebx
f0106178:	5e                   	pop    %esi
f0106179:	5f                   	pop    %edi
f010617a:	5d                   	pop    %ebp
f010617b:	c3                   	ret    
					pcs[i] - info.eip_fn_addr);
f010617c:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f010617e:	83 ec 04             	sub    $0x4,%esp
f0106181:	89 c2                	mov    %eax,%edx
f0106183:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106186:	52                   	push   %edx
f0106187:	ff 75 b0             	pushl  -0x50(%ebp)
f010618a:	ff 75 b4             	pushl  -0x4c(%ebp)
f010618d:	ff 75 ac             	pushl  -0x54(%ebp)
f0106190:	ff 75 a8             	pushl  -0x58(%ebp)
f0106193:	50                   	push   %eax
f0106194:	68 18 81 10 f0       	push   $0xf0108118
f0106199:	e8 f5 d6 ff ff       	call   f0103893 <cprintf>
f010619e:	83 c4 20             	add    $0x20,%esp
f01061a1:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f01061a4:	8d 45 e8             	lea    -0x18(%ebp),%eax
f01061a7:	39 c3                	cmp    %eax,%ebx
f01061a9:	74 2d                	je     f01061d8 <spin_unlock+0xd4>
f01061ab:	89 de                	mov    %ebx,%esi
f01061ad:	8b 03                	mov    (%ebx),%eax
f01061af:	85 c0                	test   %eax,%eax
f01061b1:	74 25                	je     f01061d8 <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01061b3:	83 ec 08             	sub    $0x8,%esp
f01061b6:	57                   	push   %edi
f01061b7:	50                   	push   %eax
f01061b8:	e8 7a eb ff ff       	call   f0104d37 <debuginfo_eip>
f01061bd:	83 c4 10             	add    $0x10,%esp
f01061c0:	85 c0                	test   %eax,%eax
f01061c2:	79 b8                	jns    f010617c <spin_unlock+0x78>
				cprintf("  %08x\n", pcs[i]);
f01061c4:	83 ec 08             	sub    $0x8,%esp
f01061c7:	ff 36                	pushl  (%esi)
f01061c9:	68 2f 81 10 f0       	push   $0xf010812f
f01061ce:	e8 c0 d6 ff ff       	call   f0103893 <cprintf>
f01061d3:	83 c4 10             	add    $0x10,%esp
f01061d6:	eb c9                	jmp    f01061a1 <spin_unlock+0x9d>
		panic("spin_unlock");
f01061d8:	83 ec 04             	sub    $0x4,%esp
f01061db:	68 37 81 10 f0       	push   $0xf0108137
f01061e0:	6a 67                	push   $0x67
f01061e2:	68 08 81 10 f0       	push   $0xf0108108
f01061e7:	e8 54 9e ff ff       	call   f0100040 <_panic>
f01061ec:	66 90                	xchg   %ax,%ax
f01061ee:	66 90                	xchg   %ax,%ax

f01061f0 <__udivdi3>:
f01061f0:	55                   	push   %ebp
f01061f1:	57                   	push   %edi
f01061f2:	56                   	push   %esi
f01061f3:	53                   	push   %ebx
f01061f4:	83 ec 1c             	sub    $0x1c,%esp
f01061f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f01061fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01061ff:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106203:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0106207:	85 d2                	test   %edx,%edx
f0106209:	75 35                	jne    f0106240 <__udivdi3+0x50>
f010620b:	39 f3                	cmp    %esi,%ebx
f010620d:	0f 87 bd 00 00 00    	ja     f01062d0 <__udivdi3+0xe0>
f0106213:	85 db                	test   %ebx,%ebx
f0106215:	89 d9                	mov    %ebx,%ecx
f0106217:	75 0b                	jne    f0106224 <__udivdi3+0x34>
f0106219:	b8 01 00 00 00       	mov    $0x1,%eax
f010621e:	31 d2                	xor    %edx,%edx
f0106220:	f7 f3                	div    %ebx
f0106222:	89 c1                	mov    %eax,%ecx
f0106224:	31 d2                	xor    %edx,%edx
f0106226:	89 f0                	mov    %esi,%eax
f0106228:	f7 f1                	div    %ecx
f010622a:	89 c6                	mov    %eax,%esi
f010622c:	89 e8                	mov    %ebp,%eax
f010622e:	89 f7                	mov    %esi,%edi
f0106230:	f7 f1                	div    %ecx
f0106232:	89 fa                	mov    %edi,%edx
f0106234:	83 c4 1c             	add    $0x1c,%esp
f0106237:	5b                   	pop    %ebx
f0106238:	5e                   	pop    %esi
f0106239:	5f                   	pop    %edi
f010623a:	5d                   	pop    %ebp
f010623b:	c3                   	ret    
f010623c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106240:	39 f2                	cmp    %esi,%edx
f0106242:	77 7c                	ja     f01062c0 <__udivdi3+0xd0>
f0106244:	0f bd fa             	bsr    %edx,%edi
f0106247:	83 f7 1f             	xor    $0x1f,%edi
f010624a:	0f 84 98 00 00 00    	je     f01062e8 <__udivdi3+0xf8>
f0106250:	89 f9                	mov    %edi,%ecx
f0106252:	b8 20 00 00 00       	mov    $0x20,%eax
f0106257:	29 f8                	sub    %edi,%eax
f0106259:	d3 e2                	shl    %cl,%edx
f010625b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010625f:	89 c1                	mov    %eax,%ecx
f0106261:	89 da                	mov    %ebx,%edx
f0106263:	d3 ea                	shr    %cl,%edx
f0106265:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106269:	09 d1                	or     %edx,%ecx
f010626b:	89 f2                	mov    %esi,%edx
f010626d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106271:	89 f9                	mov    %edi,%ecx
f0106273:	d3 e3                	shl    %cl,%ebx
f0106275:	89 c1                	mov    %eax,%ecx
f0106277:	d3 ea                	shr    %cl,%edx
f0106279:	89 f9                	mov    %edi,%ecx
f010627b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010627f:	d3 e6                	shl    %cl,%esi
f0106281:	89 eb                	mov    %ebp,%ebx
f0106283:	89 c1                	mov    %eax,%ecx
f0106285:	d3 eb                	shr    %cl,%ebx
f0106287:	09 de                	or     %ebx,%esi
f0106289:	89 f0                	mov    %esi,%eax
f010628b:	f7 74 24 08          	divl   0x8(%esp)
f010628f:	89 d6                	mov    %edx,%esi
f0106291:	89 c3                	mov    %eax,%ebx
f0106293:	f7 64 24 0c          	mull   0xc(%esp)
f0106297:	39 d6                	cmp    %edx,%esi
f0106299:	72 0c                	jb     f01062a7 <__udivdi3+0xb7>
f010629b:	89 f9                	mov    %edi,%ecx
f010629d:	d3 e5                	shl    %cl,%ebp
f010629f:	39 c5                	cmp    %eax,%ebp
f01062a1:	73 5d                	jae    f0106300 <__udivdi3+0x110>
f01062a3:	39 d6                	cmp    %edx,%esi
f01062a5:	75 59                	jne    f0106300 <__udivdi3+0x110>
f01062a7:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01062aa:	31 ff                	xor    %edi,%edi
f01062ac:	89 fa                	mov    %edi,%edx
f01062ae:	83 c4 1c             	add    $0x1c,%esp
f01062b1:	5b                   	pop    %ebx
f01062b2:	5e                   	pop    %esi
f01062b3:	5f                   	pop    %edi
f01062b4:	5d                   	pop    %ebp
f01062b5:	c3                   	ret    
f01062b6:	8d 76 00             	lea    0x0(%esi),%esi
f01062b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f01062c0:	31 ff                	xor    %edi,%edi
f01062c2:	31 c0                	xor    %eax,%eax
f01062c4:	89 fa                	mov    %edi,%edx
f01062c6:	83 c4 1c             	add    $0x1c,%esp
f01062c9:	5b                   	pop    %ebx
f01062ca:	5e                   	pop    %esi
f01062cb:	5f                   	pop    %edi
f01062cc:	5d                   	pop    %ebp
f01062cd:	c3                   	ret    
f01062ce:	66 90                	xchg   %ax,%ax
f01062d0:	31 ff                	xor    %edi,%edi
f01062d2:	89 e8                	mov    %ebp,%eax
f01062d4:	89 f2                	mov    %esi,%edx
f01062d6:	f7 f3                	div    %ebx
f01062d8:	89 fa                	mov    %edi,%edx
f01062da:	83 c4 1c             	add    $0x1c,%esp
f01062dd:	5b                   	pop    %ebx
f01062de:	5e                   	pop    %esi
f01062df:	5f                   	pop    %edi
f01062e0:	5d                   	pop    %ebp
f01062e1:	c3                   	ret    
f01062e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01062e8:	39 f2                	cmp    %esi,%edx
f01062ea:	72 06                	jb     f01062f2 <__udivdi3+0x102>
f01062ec:	31 c0                	xor    %eax,%eax
f01062ee:	39 eb                	cmp    %ebp,%ebx
f01062f0:	77 d2                	ja     f01062c4 <__udivdi3+0xd4>
f01062f2:	b8 01 00 00 00       	mov    $0x1,%eax
f01062f7:	eb cb                	jmp    f01062c4 <__udivdi3+0xd4>
f01062f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106300:	89 d8                	mov    %ebx,%eax
f0106302:	31 ff                	xor    %edi,%edi
f0106304:	eb be                	jmp    f01062c4 <__udivdi3+0xd4>
f0106306:	66 90                	xchg   %ax,%ax
f0106308:	66 90                	xchg   %ax,%ax
f010630a:	66 90                	xchg   %ax,%ax
f010630c:	66 90                	xchg   %ax,%ax
f010630e:	66 90                	xchg   %ax,%ax

f0106310 <__umoddi3>:
f0106310:	55                   	push   %ebp
f0106311:	57                   	push   %edi
f0106312:	56                   	push   %esi
f0106313:	53                   	push   %ebx
f0106314:	83 ec 1c             	sub    $0x1c,%esp
f0106317:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f010631b:	8b 74 24 30          	mov    0x30(%esp),%esi
f010631f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0106323:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0106327:	85 ed                	test   %ebp,%ebp
f0106329:	89 f0                	mov    %esi,%eax
f010632b:	89 da                	mov    %ebx,%edx
f010632d:	75 19                	jne    f0106348 <__umoddi3+0x38>
f010632f:	39 df                	cmp    %ebx,%edi
f0106331:	0f 86 b1 00 00 00    	jbe    f01063e8 <__umoddi3+0xd8>
f0106337:	f7 f7                	div    %edi
f0106339:	89 d0                	mov    %edx,%eax
f010633b:	31 d2                	xor    %edx,%edx
f010633d:	83 c4 1c             	add    $0x1c,%esp
f0106340:	5b                   	pop    %ebx
f0106341:	5e                   	pop    %esi
f0106342:	5f                   	pop    %edi
f0106343:	5d                   	pop    %ebp
f0106344:	c3                   	ret    
f0106345:	8d 76 00             	lea    0x0(%esi),%esi
f0106348:	39 dd                	cmp    %ebx,%ebp
f010634a:	77 f1                	ja     f010633d <__umoddi3+0x2d>
f010634c:	0f bd cd             	bsr    %ebp,%ecx
f010634f:	83 f1 1f             	xor    $0x1f,%ecx
f0106352:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106356:	0f 84 b4 00 00 00    	je     f0106410 <__umoddi3+0x100>
f010635c:	b8 20 00 00 00       	mov    $0x20,%eax
f0106361:	89 c2                	mov    %eax,%edx
f0106363:	8b 44 24 04          	mov    0x4(%esp),%eax
f0106367:	29 c2                	sub    %eax,%edx
f0106369:	89 c1                	mov    %eax,%ecx
f010636b:	89 f8                	mov    %edi,%eax
f010636d:	d3 e5                	shl    %cl,%ebp
f010636f:	89 d1                	mov    %edx,%ecx
f0106371:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106375:	d3 e8                	shr    %cl,%eax
f0106377:	09 c5                	or     %eax,%ebp
f0106379:	8b 44 24 04          	mov    0x4(%esp),%eax
f010637d:	89 c1                	mov    %eax,%ecx
f010637f:	d3 e7                	shl    %cl,%edi
f0106381:	89 d1                	mov    %edx,%ecx
f0106383:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0106387:	89 df                	mov    %ebx,%edi
f0106389:	d3 ef                	shr    %cl,%edi
f010638b:	89 c1                	mov    %eax,%ecx
f010638d:	89 f0                	mov    %esi,%eax
f010638f:	d3 e3                	shl    %cl,%ebx
f0106391:	89 d1                	mov    %edx,%ecx
f0106393:	89 fa                	mov    %edi,%edx
f0106395:	d3 e8                	shr    %cl,%eax
f0106397:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010639c:	09 d8                	or     %ebx,%eax
f010639e:	f7 f5                	div    %ebp
f01063a0:	d3 e6                	shl    %cl,%esi
f01063a2:	89 d1                	mov    %edx,%ecx
f01063a4:	f7 64 24 08          	mull   0x8(%esp)
f01063a8:	39 d1                	cmp    %edx,%ecx
f01063aa:	89 c3                	mov    %eax,%ebx
f01063ac:	89 d7                	mov    %edx,%edi
f01063ae:	72 06                	jb     f01063b6 <__umoddi3+0xa6>
f01063b0:	75 0e                	jne    f01063c0 <__umoddi3+0xb0>
f01063b2:	39 c6                	cmp    %eax,%esi
f01063b4:	73 0a                	jae    f01063c0 <__umoddi3+0xb0>
f01063b6:	2b 44 24 08          	sub    0x8(%esp),%eax
f01063ba:	19 ea                	sbb    %ebp,%edx
f01063bc:	89 d7                	mov    %edx,%edi
f01063be:	89 c3                	mov    %eax,%ebx
f01063c0:	89 ca                	mov    %ecx,%edx
f01063c2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f01063c7:	29 de                	sub    %ebx,%esi
f01063c9:	19 fa                	sbb    %edi,%edx
f01063cb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f01063cf:	89 d0                	mov    %edx,%eax
f01063d1:	d3 e0                	shl    %cl,%eax
f01063d3:	89 d9                	mov    %ebx,%ecx
f01063d5:	d3 ee                	shr    %cl,%esi
f01063d7:	d3 ea                	shr    %cl,%edx
f01063d9:	09 f0                	or     %esi,%eax
f01063db:	83 c4 1c             	add    $0x1c,%esp
f01063de:	5b                   	pop    %ebx
f01063df:	5e                   	pop    %esi
f01063e0:	5f                   	pop    %edi
f01063e1:	5d                   	pop    %ebp
f01063e2:	c3                   	ret    
f01063e3:	90                   	nop
f01063e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01063e8:	85 ff                	test   %edi,%edi
f01063ea:	89 f9                	mov    %edi,%ecx
f01063ec:	75 0b                	jne    f01063f9 <__umoddi3+0xe9>
f01063ee:	b8 01 00 00 00       	mov    $0x1,%eax
f01063f3:	31 d2                	xor    %edx,%edx
f01063f5:	f7 f7                	div    %edi
f01063f7:	89 c1                	mov    %eax,%ecx
f01063f9:	89 d8                	mov    %ebx,%eax
f01063fb:	31 d2                	xor    %edx,%edx
f01063fd:	f7 f1                	div    %ecx
f01063ff:	89 f0                	mov    %esi,%eax
f0106401:	f7 f1                	div    %ecx
f0106403:	e9 31 ff ff ff       	jmp    f0106339 <__umoddi3+0x29>
f0106408:	90                   	nop
f0106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106410:	39 dd                	cmp    %ebx,%ebp
f0106412:	72 08                	jb     f010641c <__umoddi3+0x10c>
f0106414:	39 f7                	cmp    %esi,%edi
f0106416:	0f 87 21 ff ff ff    	ja     f010633d <__umoddi3+0x2d>
f010641c:	89 da                	mov    %ebx,%edx
f010641e:	89 f0                	mov    %esi,%eax
f0106420:	29 f8                	sub    %edi,%eax
f0106422:	19 ea                	sbb    %ebp,%edx
f0106424:	e9 14 ff ff ff       	jmp    f010633d <__umoddi3+0x2d>
