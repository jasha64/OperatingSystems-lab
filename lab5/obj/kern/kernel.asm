
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
f0100015:	b8 00 80 11 00       	mov    $0x118000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
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
f0100034:	bc 00 60 11 f0       	mov    $0xf0116000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 02 00 00 00       	call   f0100040 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <i386_init>:
#include <kern/kclock.h>


void
i386_init(void)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 08             	sub    $0x8,%esp
f0100047:	e8 03 01 00 00       	call   f010014f <__x86.get_pc_thunk.bx>
f010004c:	81 c3 c0 72 01 00    	add    $0x172c0,%ebx
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100052:	c7 c2 60 90 11 f0    	mov    $0xf0119060,%edx
f0100058:	c7 c0 c0 96 11 f0    	mov    $0xf01196c0,%eax
f010005e:	29 d0                	sub    %edx,%eax
f0100060:	50                   	push   %eax
f0100061:	6a 00                	push   $0x0
f0100063:	52                   	push   %edx
f0100064:	e8 11 3b 00 00       	call   f0103b7a <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f0100069:	e8 36 05 00 00       	call   f01005a4 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f010006e:	83 c4 08             	add    $0x8,%esp
f0100071:	68 ac 1a 00 00       	push   $0x1aac
f0100076:	8d 83 b4 cc fe ff    	lea    -0x1334c(%ebx),%eax
f010007c:	50                   	push   %eax
f010007d:	e8 9c 2f 00 00       	call   f010301e <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f0100082:	e8 f9 11 00 00       	call   f0101280 <mem_init>
f0100087:	83 c4 10             	add    $0x10,%esp

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f010008a:	83 ec 0c             	sub    $0xc,%esp
f010008d:	6a 00                	push   $0x0
f010008f:	e8 8c 07 00 00       	call   f0100820 <monitor>
f0100094:	83 c4 10             	add    $0x10,%esp
f0100097:	eb f1                	jmp    f010008a <i386_init+0x4a>

f0100099 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100099:	55                   	push   %ebp
f010009a:	89 e5                	mov    %esp,%ebp
f010009c:	57                   	push   %edi
f010009d:	56                   	push   %esi
f010009e:	53                   	push   %ebx
f010009f:	83 ec 0c             	sub    $0xc,%esp
f01000a2:	e8 a8 00 00 00       	call   f010014f <__x86.get_pc_thunk.bx>
f01000a7:	81 c3 65 72 01 00    	add    $0x17265,%ebx
f01000ad:	8b 7d 10             	mov    0x10(%ebp),%edi
	va_list ap;

	if (panicstr)
f01000b0:	c7 c0 c4 96 11 f0    	mov    $0xf01196c4,%eax
f01000b6:	83 38 00             	cmpl   $0x0,(%eax)
f01000b9:	74 0f                	je     f01000ca <_panic+0x31>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000bb:	83 ec 0c             	sub    $0xc,%esp
f01000be:	6a 00                	push   $0x0
f01000c0:	e8 5b 07 00 00       	call   f0100820 <monitor>
f01000c5:	83 c4 10             	add    $0x10,%esp
f01000c8:	eb f1                	jmp    f01000bb <_panic+0x22>
	panicstr = fmt;
f01000ca:	89 38                	mov    %edi,(%eax)
	asm volatile("cli; cld");
f01000cc:	fa                   	cli    
f01000cd:	fc                   	cld    
	va_start(ap, fmt);
f01000ce:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel panic at %s:%d: ", file, line);
f01000d1:	83 ec 04             	sub    $0x4,%esp
f01000d4:	ff 75 0c             	pushl  0xc(%ebp)
f01000d7:	ff 75 08             	pushl  0x8(%ebp)
f01000da:	8d 83 cf cc fe ff    	lea    -0x13331(%ebx),%eax
f01000e0:	50                   	push   %eax
f01000e1:	e8 38 2f 00 00       	call   f010301e <cprintf>
	vcprintf(fmt, ap);
f01000e6:	83 c4 08             	add    $0x8,%esp
f01000e9:	56                   	push   %esi
f01000ea:	57                   	push   %edi
f01000eb:	e8 f7 2e 00 00       	call   f0102fe7 <vcprintf>
	cprintf("\n");
f01000f0:	8d 83 fa d3 fe ff    	lea    -0x12c06(%ebx),%eax
f01000f6:	89 04 24             	mov    %eax,(%esp)
f01000f9:	e8 20 2f 00 00       	call   f010301e <cprintf>
f01000fe:	83 c4 10             	add    $0x10,%esp
f0100101:	eb b8                	jmp    f01000bb <_panic+0x22>

f0100103 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100103:	55                   	push   %ebp
f0100104:	89 e5                	mov    %esp,%ebp
f0100106:	56                   	push   %esi
f0100107:	53                   	push   %ebx
f0100108:	e8 42 00 00 00       	call   f010014f <__x86.get_pc_thunk.bx>
f010010d:	81 c3 ff 71 01 00    	add    $0x171ff,%ebx
	va_list ap;

	va_start(ap, fmt);
f0100113:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel warning at %s:%d: ", file, line);
f0100116:	83 ec 04             	sub    $0x4,%esp
f0100119:	ff 75 0c             	pushl  0xc(%ebp)
f010011c:	ff 75 08             	pushl  0x8(%ebp)
f010011f:	8d 83 e7 cc fe ff    	lea    -0x13319(%ebx),%eax
f0100125:	50                   	push   %eax
f0100126:	e8 f3 2e 00 00       	call   f010301e <cprintf>
	vcprintf(fmt, ap);
f010012b:	83 c4 08             	add    $0x8,%esp
f010012e:	56                   	push   %esi
f010012f:	ff 75 10             	pushl  0x10(%ebp)
f0100132:	e8 b0 2e 00 00       	call   f0102fe7 <vcprintf>
	cprintf("\n");
f0100137:	8d 83 fa d3 fe ff    	lea    -0x12c06(%ebx),%eax
f010013d:	89 04 24             	mov    %eax,(%esp)
f0100140:	e8 d9 2e 00 00       	call   f010301e <cprintf>
	va_end(ap);
}
f0100145:	83 c4 10             	add    $0x10,%esp
f0100148:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010014b:	5b                   	pop    %ebx
f010014c:	5e                   	pop    %esi
f010014d:	5d                   	pop    %ebp
f010014e:	c3                   	ret    

f010014f <__x86.get_pc_thunk.bx>:
f010014f:	8b 1c 24             	mov    (%esp),%ebx
f0100152:	c3                   	ret    

f0100153 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100153:	55                   	push   %ebp
f0100154:	89 e5                	mov    %esp,%ebp

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100156:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010015b:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010015c:	a8 01                	test   $0x1,%al
f010015e:	74 0b                	je     f010016b <serial_proc_data+0x18>
f0100160:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100165:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100166:	0f b6 c0             	movzbl %al,%eax
}
f0100169:	5d                   	pop    %ebp
f010016a:	c3                   	ret    
		return -1;
f010016b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100170:	eb f7                	jmp    f0100169 <serial_proc_data+0x16>

f0100172 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100172:	55                   	push   %ebp
f0100173:	89 e5                	mov    %esp,%ebp
f0100175:	56                   	push   %esi
f0100176:	53                   	push   %ebx
f0100177:	e8 d3 ff ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f010017c:	81 c3 90 71 01 00    	add    $0x17190,%ebx
f0100182:	89 c6                	mov    %eax,%esi
	int c;

	while ((c = (*proc)()) != -1) {
f0100184:	ff d6                	call   *%esi
f0100186:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100189:	74 2e                	je     f01001b9 <cons_intr+0x47>
		if (c == 0)
f010018b:	85 c0                	test   %eax,%eax
f010018d:	74 f5                	je     f0100184 <cons_intr+0x12>
			continue;
		cons.buf[cons.wpos++] = c;
f010018f:	8b 8b 78 1f 00 00    	mov    0x1f78(%ebx),%ecx
f0100195:	8d 51 01             	lea    0x1(%ecx),%edx
f0100198:	89 93 78 1f 00 00    	mov    %edx,0x1f78(%ebx)
f010019e:	88 84 0b 74 1d 00 00 	mov    %al,0x1d74(%ebx,%ecx,1)
		if (cons.wpos == CONSBUFSIZE)
f01001a5:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01001ab:	75 d7                	jne    f0100184 <cons_intr+0x12>
			cons.wpos = 0;
f01001ad:	c7 83 78 1f 00 00 00 	movl   $0x0,0x1f78(%ebx)
f01001b4:	00 00 00 
f01001b7:	eb cb                	jmp    f0100184 <cons_intr+0x12>
	}
}
f01001b9:	5b                   	pop    %ebx
f01001ba:	5e                   	pop    %esi
f01001bb:	5d                   	pop    %ebp
f01001bc:	c3                   	ret    

f01001bd <kbd_proc_data>:
{
f01001bd:	55                   	push   %ebp
f01001be:	89 e5                	mov    %esp,%ebp
f01001c0:	56                   	push   %esi
f01001c1:	53                   	push   %ebx
f01001c2:	e8 88 ff ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f01001c7:	81 c3 45 71 01 00    	add    $0x17145,%ebx
f01001cd:	ba 64 00 00 00       	mov    $0x64,%edx
f01001d2:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01001d3:	a8 01                	test   $0x1,%al
f01001d5:	0f 84 06 01 00 00    	je     f01002e1 <kbd_proc_data+0x124>
	if (stat & KBS_TERR)
f01001db:	a8 20                	test   $0x20,%al
f01001dd:	0f 85 05 01 00 00    	jne    f01002e8 <kbd_proc_data+0x12b>
f01001e3:	ba 60 00 00 00       	mov    $0x60,%edx
f01001e8:	ec                   	in     (%dx),%al
f01001e9:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01001eb:	3c e0                	cmp    $0xe0,%al
f01001ed:	0f 84 93 00 00 00    	je     f0100286 <kbd_proc_data+0xc9>
	} else if (data & 0x80) {
f01001f3:	84 c0                	test   %al,%al
f01001f5:	0f 88 a0 00 00 00    	js     f010029b <kbd_proc_data+0xde>
	} else if (shift & E0ESC) {
f01001fb:	8b 8b 54 1d 00 00    	mov    0x1d54(%ebx),%ecx
f0100201:	f6 c1 40             	test   $0x40,%cl
f0100204:	74 0e                	je     f0100214 <kbd_proc_data+0x57>
		data |= 0x80;
f0100206:	83 c8 80             	or     $0xffffff80,%eax
f0100209:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f010020b:	83 e1 bf             	and    $0xffffffbf,%ecx
f010020e:	89 8b 54 1d 00 00    	mov    %ecx,0x1d54(%ebx)
	shift |= shiftcode[data];
f0100214:	0f b6 d2             	movzbl %dl,%edx
f0100217:	0f b6 84 13 34 ce fe 	movzbl -0x131cc(%ebx,%edx,1),%eax
f010021e:	ff 
f010021f:	0b 83 54 1d 00 00    	or     0x1d54(%ebx),%eax
	shift ^= togglecode[data];
f0100225:	0f b6 8c 13 34 cd fe 	movzbl -0x132cc(%ebx,%edx,1),%ecx
f010022c:	ff 
f010022d:	31 c8                	xor    %ecx,%eax
f010022f:	89 83 54 1d 00 00    	mov    %eax,0x1d54(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
f0100235:	89 c1                	mov    %eax,%ecx
f0100237:	83 e1 03             	and    $0x3,%ecx
f010023a:	8b 8c 8b f4 1c 00 00 	mov    0x1cf4(%ebx,%ecx,4),%ecx
f0100241:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100245:	0f b6 f2             	movzbl %dl,%esi
	if (shift & CAPSLOCK) {
f0100248:	a8 08                	test   $0x8,%al
f010024a:	74 0d                	je     f0100259 <kbd_proc_data+0x9c>
		if ('a' <= c && c <= 'z')
f010024c:	89 f2                	mov    %esi,%edx
f010024e:	8d 4e 9f             	lea    -0x61(%esi),%ecx
f0100251:	83 f9 19             	cmp    $0x19,%ecx
f0100254:	77 7a                	ja     f01002d0 <kbd_proc_data+0x113>
			c += 'A' - 'a';
f0100256:	83 ee 20             	sub    $0x20,%esi
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100259:	f7 d0                	not    %eax
f010025b:	a8 06                	test   $0x6,%al
f010025d:	75 33                	jne    f0100292 <kbd_proc_data+0xd5>
f010025f:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
f0100265:	75 2b                	jne    f0100292 <kbd_proc_data+0xd5>
		cprintf("Rebooting!\n");
f0100267:	83 ec 0c             	sub    $0xc,%esp
f010026a:	8d 83 01 cd fe ff    	lea    -0x132ff(%ebx),%eax
f0100270:	50                   	push   %eax
f0100271:	e8 a8 2d 00 00       	call   f010301e <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100276:	b8 03 00 00 00       	mov    $0x3,%eax
f010027b:	ba 92 00 00 00       	mov    $0x92,%edx
f0100280:	ee                   	out    %al,(%dx)
f0100281:	83 c4 10             	add    $0x10,%esp
f0100284:	eb 0c                	jmp    f0100292 <kbd_proc_data+0xd5>
		shift |= E0ESC;
f0100286:	83 8b 54 1d 00 00 40 	orl    $0x40,0x1d54(%ebx)
		return 0;
f010028d:	be 00 00 00 00       	mov    $0x0,%esi
}
f0100292:	89 f0                	mov    %esi,%eax
f0100294:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100297:	5b                   	pop    %ebx
f0100298:	5e                   	pop    %esi
f0100299:	5d                   	pop    %ebp
f010029a:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010029b:	8b 8b 54 1d 00 00    	mov    0x1d54(%ebx),%ecx
f01002a1:	89 ce                	mov    %ecx,%esi
f01002a3:	83 e6 40             	and    $0x40,%esi
f01002a6:	83 e0 7f             	and    $0x7f,%eax
f01002a9:	85 f6                	test   %esi,%esi
f01002ab:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01002ae:	0f b6 d2             	movzbl %dl,%edx
f01002b1:	0f b6 84 13 34 ce fe 	movzbl -0x131cc(%ebx,%edx,1),%eax
f01002b8:	ff 
f01002b9:	83 c8 40             	or     $0x40,%eax
f01002bc:	0f b6 c0             	movzbl %al,%eax
f01002bf:	f7 d0                	not    %eax
f01002c1:	21 c8                	and    %ecx,%eax
f01002c3:	89 83 54 1d 00 00    	mov    %eax,0x1d54(%ebx)
		return 0;
f01002c9:	be 00 00 00 00       	mov    $0x0,%esi
f01002ce:	eb c2                	jmp    f0100292 <kbd_proc_data+0xd5>
		else if ('A' <= c && c <= 'Z')
f01002d0:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01002d3:	8d 4e 20             	lea    0x20(%esi),%ecx
f01002d6:	83 fa 1a             	cmp    $0x1a,%edx
f01002d9:	0f 42 f1             	cmovb  %ecx,%esi
f01002dc:	e9 78 ff ff ff       	jmp    f0100259 <kbd_proc_data+0x9c>
		return -1;
f01002e1:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01002e6:	eb aa                	jmp    f0100292 <kbd_proc_data+0xd5>
		return -1;
f01002e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01002ed:	eb a3                	jmp    f0100292 <kbd_proc_data+0xd5>

f01002ef <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01002ef:	55                   	push   %ebp
f01002f0:	89 e5                	mov    %esp,%ebp
f01002f2:	57                   	push   %edi
f01002f3:	56                   	push   %esi
f01002f4:	53                   	push   %ebx
f01002f5:	83 ec 1c             	sub    $0x1c,%esp
f01002f8:	e8 52 fe ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f01002fd:	81 c3 0f 70 01 00    	add    $0x1700f,%ebx
f0100303:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0;
f0100306:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010030b:	bf fd 03 00 00       	mov    $0x3fd,%edi
f0100310:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100315:	eb 09                	jmp    f0100320 <cons_putc+0x31>
f0100317:	89 ca                	mov    %ecx,%edx
f0100319:	ec                   	in     (%dx),%al
f010031a:	ec                   	in     (%dx),%al
f010031b:	ec                   	in     (%dx),%al
f010031c:	ec                   	in     (%dx),%al
	     i++)
f010031d:	83 c6 01             	add    $0x1,%esi
f0100320:	89 fa                	mov    %edi,%edx
f0100322:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100323:	a8 20                	test   $0x20,%al
f0100325:	75 08                	jne    f010032f <cons_putc+0x40>
f0100327:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010032d:	7e e8                	jle    f0100317 <cons_putc+0x28>
	outb(COM1 + COM_TX, c);
f010032f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100332:	89 f8                	mov    %edi,%eax
f0100334:	88 45 e3             	mov    %al,-0x1d(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100337:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010033c:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010033d:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100342:	bf 79 03 00 00       	mov    $0x379,%edi
f0100347:	b9 84 00 00 00       	mov    $0x84,%ecx
f010034c:	eb 09                	jmp    f0100357 <cons_putc+0x68>
f010034e:	89 ca                	mov    %ecx,%edx
f0100350:	ec                   	in     (%dx),%al
f0100351:	ec                   	in     (%dx),%al
f0100352:	ec                   	in     (%dx),%al
f0100353:	ec                   	in     (%dx),%al
f0100354:	83 c6 01             	add    $0x1,%esi
f0100357:	89 fa                	mov    %edi,%edx
f0100359:	ec                   	in     (%dx),%al
f010035a:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100360:	7f 04                	jg     f0100366 <cons_putc+0x77>
f0100362:	84 c0                	test   %al,%al
f0100364:	79 e8                	jns    f010034e <cons_putc+0x5f>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100366:	ba 78 03 00 00       	mov    $0x378,%edx
f010036b:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
f010036f:	ee                   	out    %al,(%dx)
f0100370:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100375:	b8 0d 00 00 00       	mov    $0xd,%eax
f010037a:	ee                   	out    %al,(%dx)
f010037b:	b8 08 00 00 00       	mov    $0x8,%eax
f0100380:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f0100381:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100384:	89 fa                	mov    %edi,%edx
f0100386:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f010038c:	89 f8                	mov    %edi,%eax
f010038e:	80 cc 07             	or     $0x7,%ah
f0100391:	85 d2                	test   %edx,%edx
f0100393:	0f 45 c7             	cmovne %edi,%eax
f0100396:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	switch (c & 0xff) {
f0100399:	0f b6 c0             	movzbl %al,%eax
f010039c:	83 f8 09             	cmp    $0x9,%eax
f010039f:	0f 84 b9 00 00 00    	je     f010045e <cons_putc+0x16f>
f01003a5:	83 f8 09             	cmp    $0x9,%eax
f01003a8:	7e 74                	jle    f010041e <cons_putc+0x12f>
f01003aa:	83 f8 0a             	cmp    $0xa,%eax
f01003ad:	0f 84 9e 00 00 00    	je     f0100451 <cons_putc+0x162>
f01003b3:	83 f8 0d             	cmp    $0xd,%eax
f01003b6:	0f 85 d9 00 00 00    	jne    f0100495 <cons_putc+0x1a6>
		crt_pos -= (crt_pos % CRT_COLS);
f01003bc:	0f b7 83 7c 1f 00 00 	movzwl 0x1f7c(%ebx),%eax
f01003c3:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01003c9:	c1 e8 16             	shr    $0x16,%eax
f01003cc:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01003cf:	c1 e0 04             	shl    $0x4,%eax
f01003d2:	66 89 83 7c 1f 00 00 	mov    %ax,0x1f7c(%ebx)
	if (crt_pos >= CRT_SIZE) {
f01003d9:	66 81 bb 7c 1f 00 00 	cmpw   $0x7cf,0x1f7c(%ebx)
f01003e0:	cf 07 
f01003e2:	0f 87 d4 00 00 00    	ja     f01004bc <cons_putc+0x1cd>
	outb(addr_6845, 14);
f01003e8:	8b 8b 84 1f 00 00    	mov    0x1f84(%ebx),%ecx
f01003ee:	b8 0e 00 00 00       	mov    $0xe,%eax
f01003f3:	89 ca                	mov    %ecx,%edx
f01003f5:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01003f6:	0f b7 9b 7c 1f 00 00 	movzwl 0x1f7c(%ebx),%ebx
f01003fd:	8d 71 01             	lea    0x1(%ecx),%esi
f0100400:	89 d8                	mov    %ebx,%eax
f0100402:	66 c1 e8 08          	shr    $0x8,%ax
f0100406:	89 f2                	mov    %esi,%edx
f0100408:	ee                   	out    %al,(%dx)
f0100409:	b8 0f 00 00 00       	mov    $0xf,%eax
f010040e:	89 ca                	mov    %ecx,%edx
f0100410:	ee                   	out    %al,(%dx)
f0100411:	89 d8                	mov    %ebx,%eax
f0100413:	89 f2                	mov    %esi,%edx
f0100415:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100416:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100419:	5b                   	pop    %ebx
f010041a:	5e                   	pop    %esi
f010041b:	5f                   	pop    %edi
f010041c:	5d                   	pop    %ebp
f010041d:	c3                   	ret    
	switch (c & 0xff) {
f010041e:	83 f8 08             	cmp    $0x8,%eax
f0100421:	75 72                	jne    f0100495 <cons_putc+0x1a6>
		if (crt_pos > 0) {
f0100423:	0f b7 83 7c 1f 00 00 	movzwl 0x1f7c(%ebx),%eax
f010042a:	66 85 c0             	test   %ax,%ax
f010042d:	74 b9                	je     f01003e8 <cons_putc+0xf9>
			crt_pos--;
f010042f:	83 e8 01             	sub    $0x1,%eax
f0100432:	66 89 83 7c 1f 00 00 	mov    %ax,0x1f7c(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100439:	0f b7 c0             	movzwl %ax,%eax
f010043c:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
f0100440:	b2 00                	mov    $0x0,%dl
f0100442:	83 ca 20             	or     $0x20,%edx
f0100445:	8b 8b 80 1f 00 00    	mov    0x1f80(%ebx),%ecx
f010044b:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
f010044f:	eb 88                	jmp    f01003d9 <cons_putc+0xea>
		crt_pos += CRT_COLS;
f0100451:	66 83 83 7c 1f 00 00 	addw   $0x50,0x1f7c(%ebx)
f0100458:	50 
f0100459:	e9 5e ff ff ff       	jmp    f01003bc <cons_putc+0xcd>
		cons_putc(' ');
f010045e:	b8 20 00 00 00       	mov    $0x20,%eax
f0100463:	e8 87 fe ff ff       	call   f01002ef <cons_putc>
		cons_putc(' ');
f0100468:	b8 20 00 00 00       	mov    $0x20,%eax
f010046d:	e8 7d fe ff ff       	call   f01002ef <cons_putc>
		cons_putc(' ');
f0100472:	b8 20 00 00 00       	mov    $0x20,%eax
f0100477:	e8 73 fe ff ff       	call   f01002ef <cons_putc>
		cons_putc(' ');
f010047c:	b8 20 00 00 00       	mov    $0x20,%eax
f0100481:	e8 69 fe ff ff       	call   f01002ef <cons_putc>
		cons_putc(' ');
f0100486:	b8 20 00 00 00       	mov    $0x20,%eax
f010048b:	e8 5f fe ff ff       	call   f01002ef <cons_putc>
f0100490:	e9 44 ff ff ff       	jmp    f01003d9 <cons_putc+0xea>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100495:	0f b7 83 7c 1f 00 00 	movzwl 0x1f7c(%ebx),%eax
f010049c:	8d 50 01             	lea    0x1(%eax),%edx
f010049f:	66 89 93 7c 1f 00 00 	mov    %dx,0x1f7c(%ebx)
f01004a6:	0f b7 c0             	movzwl %ax,%eax
f01004a9:	8b 93 80 1f 00 00    	mov    0x1f80(%ebx),%edx
f01004af:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
f01004b3:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01004b7:	e9 1d ff ff ff       	jmp    f01003d9 <cons_putc+0xea>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01004bc:	8b 83 80 1f 00 00    	mov    0x1f80(%ebx),%eax
f01004c2:	83 ec 04             	sub    $0x4,%esp
f01004c5:	68 00 0f 00 00       	push   $0xf00
f01004ca:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004d0:	52                   	push   %edx
f01004d1:	50                   	push   %eax
f01004d2:	e8 f0 36 00 00       	call   f0103bc7 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01004d7:	8b 93 80 1f 00 00    	mov    0x1f80(%ebx),%edx
f01004dd:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01004e3:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01004e9:	83 c4 10             	add    $0x10,%esp
f01004ec:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01004f1:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01004f4:	39 d0                	cmp    %edx,%eax
f01004f6:	75 f4                	jne    f01004ec <cons_putc+0x1fd>
		crt_pos -= CRT_COLS;
f01004f8:	66 83 ab 7c 1f 00 00 	subw   $0x50,0x1f7c(%ebx)
f01004ff:	50 
f0100500:	e9 e3 fe ff ff       	jmp    f01003e8 <cons_putc+0xf9>

f0100505 <serial_intr>:
{
f0100505:	e8 e7 01 00 00       	call   f01006f1 <__x86.get_pc_thunk.ax>
f010050a:	05 02 6e 01 00       	add    $0x16e02,%eax
	if (serial_exists)
f010050f:	80 b8 88 1f 00 00 00 	cmpb   $0x0,0x1f88(%eax)
f0100516:	75 02                	jne    f010051a <serial_intr+0x15>
f0100518:	f3 c3                	repz ret 
{
f010051a:	55                   	push   %ebp
f010051b:	89 e5                	mov    %esp,%ebp
f010051d:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100520:	8d 80 47 8e fe ff    	lea    -0x171b9(%eax),%eax
f0100526:	e8 47 fc ff ff       	call   f0100172 <cons_intr>
}
f010052b:	c9                   	leave  
f010052c:	c3                   	ret    

f010052d <kbd_intr>:
{
f010052d:	55                   	push   %ebp
f010052e:	89 e5                	mov    %esp,%ebp
f0100530:	83 ec 08             	sub    $0x8,%esp
f0100533:	e8 b9 01 00 00       	call   f01006f1 <__x86.get_pc_thunk.ax>
f0100538:	05 d4 6d 01 00       	add    $0x16dd4,%eax
	cons_intr(kbd_proc_data);
f010053d:	8d 80 b1 8e fe ff    	lea    -0x1714f(%eax),%eax
f0100543:	e8 2a fc ff ff       	call   f0100172 <cons_intr>
}
f0100548:	c9                   	leave  
f0100549:	c3                   	ret    

f010054a <cons_getc>:
{
f010054a:	55                   	push   %ebp
f010054b:	89 e5                	mov    %esp,%ebp
f010054d:	53                   	push   %ebx
f010054e:	83 ec 04             	sub    $0x4,%esp
f0100551:	e8 f9 fb ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100556:	81 c3 b6 6d 01 00    	add    $0x16db6,%ebx
	serial_intr();
f010055c:	e8 a4 ff ff ff       	call   f0100505 <serial_intr>
	kbd_intr();
f0100561:	e8 c7 ff ff ff       	call   f010052d <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100566:	8b 93 74 1f 00 00    	mov    0x1f74(%ebx),%edx
	return 0;
f010056c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100571:	3b 93 78 1f 00 00    	cmp    0x1f78(%ebx),%edx
f0100577:	74 19                	je     f0100592 <cons_getc+0x48>
		c = cons.buf[cons.rpos++];
f0100579:	8d 4a 01             	lea    0x1(%edx),%ecx
f010057c:	89 8b 74 1f 00 00    	mov    %ecx,0x1f74(%ebx)
f0100582:	0f b6 84 13 74 1d 00 	movzbl 0x1d74(%ebx,%edx,1),%eax
f0100589:	00 
		if (cons.rpos == CONSBUFSIZE)
f010058a:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100590:	74 06                	je     f0100598 <cons_getc+0x4e>
}
f0100592:	83 c4 04             	add    $0x4,%esp
f0100595:	5b                   	pop    %ebx
f0100596:	5d                   	pop    %ebp
f0100597:	c3                   	ret    
			cons.rpos = 0;
f0100598:	c7 83 74 1f 00 00 00 	movl   $0x0,0x1f74(%ebx)
f010059f:	00 00 00 
f01005a2:	eb ee                	jmp    f0100592 <cons_getc+0x48>

f01005a4 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01005a4:	55                   	push   %ebp
f01005a5:	89 e5                	mov    %esp,%ebp
f01005a7:	57                   	push   %edi
f01005a8:	56                   	push   %esi
f01005a9:	53                   	push   %ebx
f01005aa:	83 ec 1c             	sub    $0x1c,%esp
f01005ad:	e8 9d fb ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f01005b2:	81 c3 5a 6d 01 00    	add    $0x16d5a,%ebx
	was = *cp;
f01005b8:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01005bf:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01005c6:	5a a5 
	if (*cp != 0xA55A) {
f01005c8:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01005cf:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01005d3:	0f 84 bc 00 00 00    	je     f0100695 <cons_init+0xf1>
		addr_6845 = MONO_BASE;
f01005d9:	c7 83 84 1f 00 00 b4 	movl   $0x3b4,0x1f84(%ebx)
f01005e0:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01005e3:	c7 45 e4 00 00 0b f0 	movl   $0xf00b0000,-0x1c(%ebp)
	outb(addr_6845, 14);
f01005ea:	8b bb 84 1f 00 00    	mov    0x1f84(%ebx),%edi
f01005f0:	b8 0e 00 00 00       	mov    $0xe,%eax
f01005f5:	89 fa                	mov    %edi,%edx
f01005f7:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01005f8:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01005fb:	89 ca                	mov    %ecx,%edx
f01005fd:	ec                   	in     (%dx),%al
f01005fe:	0f b6 f0             	movzbl %al,%esi
f0100601:	c1 e6 08             	shl    $0x8,%esi
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100604:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100609:	89 fa                	mov    %edi,%edx
f010060b:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010060c:	89 ca                	mov    %ecx,%edx
f010060e:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f010060f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100612:	89 bb 80 1f 00 00    	mov    %edi,0x1f80(%ebx)
	pos |= inb(addr_6845 + 1);
f0100618:	0f b6 c0             	movzbl %al,%eax
f010061b:	09 c6                	or     %eax,%esi
	crt_pos = pos;
f010061d:	66 89 b3 7c 1f 00 00 	mov    %si,0x1f7c(%ebx)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100624:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100629:	89 c8                	mov    %ecx,%eax
f010062b:	ba fa 03 00 00       	mov    $0x3fa,%edx
f0100630:	ee                   	out    %al,(%dx)
f0100631:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100636:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010063b:	89 fa                	mov    %edi,%edx
f010063d:	ee                   	out    %al,(%dx)
f010063e:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100643:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100648:	ee                   	out    %al,(%dx)
f0100649:	be f9 03 00 00       	mov    $0x3f9,%esi
f010064e:	89 c8                	mov    %ecx,%eax
f0100650:	89 f2                	mov    %esi,%edx
f0100652:	ee                   	out    %al,(%dx)
f0100653:	b8 03 00 00 00       	mov    $0x3,%eax
f0100658:	89 fa                	mov    %edi,%edx
f010065a:	ee                   	out    %al,(%dx)
f010065b:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100660:	89 c8                	mov    %ecx,%eax
f0100662:	ee                   	out    %al,(%dx)
f0100663:	b8 01 00 00 00       	mov    $0x1,%eax
f0100668:	89 f2                	mov    %esi,%edx
f010066a:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010066b:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100670:	ec                   	in     (%dx),%al
f0100671:	89 c1                	mov    %eax,%ecx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100673:	3c ff                	cmp    $0xff,%al
f0100675:	0f 95 83 88 1f 00 00 	setne  0x1f88(%ebx)
f010067c:	ba fa 03 00 00       	mov    $0x3fa,%edx
f0100681:	ec                   	in     (%dx),%al
f0100682:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100687:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f0100688:	80 f9 ff             	cmp    $0xff,%cl
f010068b:	74 25                	je     f01006b2 <cons_init+0x10e>
		cprintf("Serial port does not exist!\n");
}
f010068d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100690:	5b                   	pop    %ebx
f0100691:	5e                   	pop    %esi
f0100692:	5f                   	pop    %edi
f0100693:	5d                   	pop    %ebp
f0100694:	c3                   	ret    
		*cp = was;
f0100695:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010069c:	c7 83 84 1f 00 00 d4 	movl   $0x3d4,0x1f84(%ebx)
f01006a3:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01006a6:	c7 45 e4 00 80 0b f0 	movl   $0xf00b8000,-0x1c(%ebp)
f01006ad:	e9 38 ff ff ff       	jmp    f01005ea <cons_init+0x46>
		cprintf("Serial port does not exist!\n");
f01006b2:	83 ec 0c             	sub    $0xc,%esp
f01006b5:	8d 83 0d cd fe ff    	lea    -0x132f3(%ebx),%eax
f01006bb:	50                   	push   %eax
f01006bc:	e8 5d 29 00 00       	call   f010301e <cprintf>
f01006c1:	83 c4 10             	add    $0x10,%esp
}
f01006c4:	eb c7                	jmp    f010068d <cons_init+0xe9>

f01006c6 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01006c6:	55                   	push   %ebp
f01006c7:	89 e5                	mov    %esp,%ebp
f01006c9:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01006cc:	8b 45 08             	mov    0x8(%ebp),%eax
f01006cf:	e8 1b fc ff ff       	call   f01002ef <cons_putc>
}
f01006d4:	c9                   	leave  
f01006d5:	c3                   	ret    

f01006d6 <getchar>:

int
getchar(void)
{
f01006d6:	55                   	push   %ebp
f01006d7:	89 e5                	mov    %esp,%ebp
f01006d9:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01006dc:	e8 69 fe ff ff       	call   f010054a <cons_getc>
f01006e1:	85 c0                	test   %eax,%eax
f01006e3:	74 f7                	je     f01006dc <getchar+0x6>
		/* do nothing */;
	return c;
}
f01006e5:	c9                   	leave  
f01006e6:	c3                   	ret    

f01006e7 <iscons>:

int
iscons(int fdnum)
{
f01006e7:	55                   	push   %ebp
f01006e8:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01006ea:	b8 01 00 00 00       	mov    $0x1,%eax
f01006ef:	5d                   	pop    %ebp
f01006f0:	c3                   	ret    

f01006f1 <__x86.get_pc_thunk.ax>:
f01006f1:	8b 04 24             	mov    (%esp),%eax
f01006f4:	c3                   	ret    

f01006f5 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01006f5:	55                   	push   %ebp
f01006f6:	89 e5                	mov    %esp,%ebp
f01006f8:	56                   	push   %esi
f01006f9:	53                   	push   %ebx
f01006fa:	e8 50 fa ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f01006ff:	81 c3 0d 6c 01 00    	add    $0x16c0d,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100705:	83 ec 04             	sub    $0x4,%esp
f0100708:	8d 83 34 cf fe ff    	lea    -0x130cc(%ebx),%eax
f010070e:	50                   	push   %eax
f010070f:	8d 83 52 cf fe ff    	lea    -0x130ae(%ebx),%eax
f0100715:	50                   	push   %eax
f0100716:	8d b3 57 cf fe ff    	lea    -0x130a9(%ebx),%esi
f010071c:	56                   	push   %esi
f010071d:	e8 fc 28 00 00       	call   f010301e <cprintf>
f0100722:	83 c4 0c             	add    $0xc,%esp
f0100725:	8d 83 c0 cf fe ff    	lea    -0x13040(%ebx),%eax
f010072b:	50                   	push   %eax
f010072c:	8d 83 60 cf fe ff    	lea    -0x130a0(%ebx),%eax
f0100732:	50                   	push   %eax
f0100733:	56                   	push   %esi
f0100734:	e8 e5 28 00 00       	call   f010301e <cprintf>
	return 0;
}
f0100739:	b8 00 00 00 00       	mov    $0x0,%eax
f010073e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100741:	5b                   	pop    %ebx
f0100742:	5e                   	pop    %esi
f0100743:	5d                   	pop    %ebp
f0100744:	c3                   	ret    

f0100745 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100745:	55                   	push   %ebp
f0100746:	89 e5                	mov    %esp,%ebp
f0100748:	57                   	push   %edi
f0100749:	56                   	push   %esi
f010074a:	53                   	push   %ebx
f010074b:	83 ec 18             	sub    $0x18,%esp
f010074e:	e8 fc f9 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100753:	81 c3 b9 6b 01 00    	add    $0x16bb9,%ebx
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100759:	8d 83 69 cf fe ff    	lea    -0x13097(%ebx),%eax
f010075f:	50                   	push   %eax
f0100760:	e8 b9 28 00 00       	call   f010301e <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100765:	83 c4 08             	add    $0x8,%esp
f0100768:	ff b3 f4 ff ff ff    	pushl  -0xc(%ebx)
f010076e:	8d 83 e8 cf fe ff    	lea    -0x13018(%ebx),%eax
f0100774:	50                   	push   %eax
f0100775:	e8 a4 28 00 00       	call   f010301e <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010077a:	83 c4 0c             	add    $0xc,%esp
f010077d:	c7 c7 0c 00 10 f0    	mov    $0xf010000c,%edi
f0100783:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
f0100789:	50                   	push   %eax
f010078a:	57                   	push   %edi
f010078b:	8d 83 10 d0 fe ff    	lea    -0x12ff0(%ebx),%eax
f0100791:	50                   	push   %eax
f0100792:	e8 87 28 00 00       	call   f010301e <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100797:	83 c4 0c             	add    $0xc,%esp
f010079a:	c7 c0 b9 3f 10 f0    	mov    $0xf0103fb9,%eax
f01007a0:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01007a6:	52                   	push   %edx
f01007a7:	50                   	push   %eax
f01007a8:	8d 83 34 d0 fe ff    	lea    -0x12fcc(%ebx),%eax
f01007ae:	50                   	push   %eax
f01007af:	e8 6a 28 00 00       	call   f010301e <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01007b4:	83 c4 0c             	add    $0xc,%esp
f01007b7:	c7 c0 60 90 11 f0    	mov    $0xf0119060,%eax
f01007bd:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01007c3:	52                   	push   %edx
f01007c4:	50                   	push   %eax
f01007c5:	8d 83 58 d0 fe ff    	lea    -0x12fa8(%ebx),%eax
f01007cb:	50                   	push   %eax
f01007cc:	e8 4d 28 00 00       	call   f010301e <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01007d1:	83 c4 0c             	add    $0xc,%esp
f01007d4:	c7 c6 c0 96 11 f0    	mov    $0xf01196c0,%esi
f01007da:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01007e0:	50                   	push   %eax
f01007e1:	56                   	push   %esi
f01007e2:	8d 83 7c d0 fe ff    	lea    -0x12f84(%ebx),%eax
f01007e8:	50                   	push   %eax
f01007e9:	e8 30 28 00 00       	call   f010301e <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01007ee:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01007f1:	81 c6 ff 03 00 00    	add    $0x3ff,%esi
f01007f7:	29 fe                	sub    %edi,%esi
	cprintf("Kernel executable memory footprint: %dKB\n",
f01007f9:	c1 fe 0a             	sar    $0xa,%esi
f01007fc:	56                   	push   %esi
f01007fd:	8d 83 a0 d0 fe ff    	lea    -0x12f60(%ebx),%eax
f0100803:	50                   	push   %eax
f0100804:	e8 15 28 00 00       	call   f010301e <cprintf>
	return 0;
}
f0100809:	b8 00 00 00 00       	mov    $0x0,%eax
f010080e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100811:	5b                   	pop    %ebx
f0100812:	5e                   	pop    %esi
f0100813:	5f                   	pop    %edi
f0100814:	5d                   	pop    %ebp
f0100815:	c3                   	ret    

f0100816 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100816:	55                   	push   %ebp
f0100817:	89 e5                	mov    %esp,%ebp
	// Your code here.
	return 0;
}
f0100819:	b8 00 00 00 00       	mov    $0x0,%eax
f010081e:	5d                   	pop    %ebp
f010081f:	c3                   	ret    

f0100820 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100820:	55                   	push   %ebp
f0100821:	89 e5                	mov    %esp,%ebp
f0100823:	57                   	push   %edi
f0100824:	56                   	push   %esi
f0100825:	53                   	push   %ebx
f0100826:	83 ec 68             	sub    $0x68,%esp
f0100829:	e8 21 f9 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f010082e:	81 c3 de 6a 01 00    	add    $0x16ade,%ebx
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100834:	8d 83 cc d0 fe ff    	lea    -0x12f34(%ebx),%eax
f010083a:	50                   	push   %eax
f010083b:	e8 de 27 00 00       	call   f010301e <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100840:	8d 83 f0 d0 fe ff    	lea    -0x12f10(%ebx),%eax
f0100846:	89 04 24             	mov    %eax,(%esp)
f0100849:	e8 d0 27 00 00       	call   f010301e <cprintf>
f010084e:	83 c4 10             	add    $0x10,%esp
		while (*buf && strchr(WHITESPACE, *buf))
f0100851:	8d bb 86 cf fe ff    	lea    -0x1307a(%ebx),%edi
f0100857:	eb 4a                	jmp    f01008a3 <monitor+0x83>
f0100859:	83 ec 08             	sub    $0x8,%esp
f010085c:	0f be c0             	movsbl %al,%eax
f010085f:	50                   	push   %eax
f0100860:	57                   	push   %edi
f0100861:	e8 d7 32 00 00       	call   f0103b3d <strchr>
f0100866:	83 c4 10             	add    $0x10,%esp
f0100869:	85 c0                	test   %eax,%eax
f010086b:	74 08                	je     f0100875 <monitor+0x55>
			*buf++ = 0;
f010086d:	c6 06 00             	movb   $0x0,(%esi)
f0100870:	8d 76 01             	lea    0x1(%esi),%esi
f0100873:	eb 79                	jmp    f01008ee <monitor+0xce>
		if (*buf == 0)
f0100875:	80 3e 00             	cmpb   $0x0,(%esi)
f0100878:	74 7f                	je     f01008f9 <monitor+0xd9>
		if (argc == MAXARGS-1) {
f010087a:	83 7d a4 0f          	cmpl   $0xf,-0x5c(%ebp)
f010087e:	74 0f                	je     f010088f <monitor+0x6f>
		argv[argc++] = buf;
f0100880:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0100883:	8d 48 01             	lea    0x1(%eax),%ecx
f0100886:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
f0100889:	89 74 85 a8          	mov    %esi,-0x58(%ebp,%eax,4)
f010088d:	eb 44                	jmp    f01008d3 <monitor+0xb3>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f010088f:	83 ec 08             	sub    $0x8,%esp
f0100892:	6a 10                	push   $0x10
f0100894:	8d 83 8b cf fe ff    	lea    -0x13075(%ebx),%eax
f010089a:	50                   	push   %eax
f010089b:	e8 7e 27 00 00       	call   f010301e <cprintf>
f01008a0:	83 c4 10             	add    $0x10,%esp


	while (1) {
		buf = readline("K> ");
f01008a3:	8d 83 82 cf fe ff    	lea    -0x1307e(%ebx),%eax
f01008a9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f01008ac:	83 ec 0c             	sub    $0xc,%esp
f01008af:	ff 75 a4             	pushl  -0x5c(%ebp)
f01008b2:	e8 4e 30 00 00       	call   f0103905 <readline>
f01008b7:	89 c6                	mov    %eax,%esi
		if (buf != NULL)
f01008b9:	83 c4 10             	add    $0x10,%esp
f01008bc:	85 c0                	test   %eax,%eax
f01008be:	74 ec                	je     f01008ac <monitor+0x8c>
	argv[argc] = 0;
f01008c0:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f01008c7:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f01008ce:	eb 1e                	jmp    f01008ee <monitor+0xce>
			buf++;
f01008d0:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f01008d3:	0f b6 06             	movzbl (%esi),%eax
f01008d6:	84 c0                	test   %al,%al
f01008d8:	74 14                	je     f01008ee <monitor+0xce>
f01008da:	83 ec 08             	sub    $0x8,%esp
f01008dd:	0f be c0             	movsbl %al,%eax
f01008e0:	50                   	push   %eax
f01008e1:	57                   	push   %edi
f01008e2:	e8 56 32 00 00       	call   f0103b3d <strchr>
f01008e7:	83 c4 10             	add    $0x10,%esp
f01008ea:	85 c0                	test   %eax,%eax
f01008ec:	74 e2                	je     f01008d0 <monitor+0xb0>
		while (*buf && strchr(WHITESPACE, *buf))
f01008ee:	0f b6 06             	movzbl (%esi),%eax
f01008f1:	84 c0                	test   %al,%al
f01008f3:	0f 85 60 ff ff ff    	jne    f0100859 <monitor+0x39>
	argv[argc] = 0;
f01008f9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f01008fc:	c7 44 85 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%eax,4)
f0100903:	00 
	if (argc == 0)
f0100904:	85 c0                	test   %eax,%eax
f0100906:	74 9b                	je     f01008a3 <monitor+0x83>
		if (strcmp(argv[0], commands[i].name) == 0)
f0100908:	83 ec 08             	sub    $0x8,%esp
f010090b:	8d 83 52 cf fe ff    	lea    -0x130ae(%ebx),%eax
f0100911:	50                   	push   %eax
f0100912:	ff 75 a8             	pushl  -0x58(%ebp)
f0100915:	e8 c5 31 00 00       	call   f0103adf <strcmp>
f010091a:	83 c4 10             	add    $0x10,%esp
f010091d:	85 c0                	test   %eax,%eax
f010091f:	74 38                	je     f0100959 <monitor+0x139>
f0100921:	83 ec 08             	sub    $0x8,%esp
f0100924:	8d 83 60 cf fe ff    	lea    -0x130a0(%ebx),%eax
f010092a:	50                   	push   %eax
f010092b:	ff 75 a8             	pushl  -0x58(%ebp)
f010092e:	e8 ac 31 00 00       	call   f0103adf <strcmp>
f0100933:	83 c4 10             	add    $0x10,%esp
f0100936:	85 c0                	test   %eax,%eax
f0100938:	74 1a                	je     f0100954 <monitor+0x134>
	cprintf("Unknown command '%s'\n", argv[0]);
f010093a:	83 ec 08             	sub    $0x8,%esp
f010093d:	ff 75 a8             	pushl  -0x58(%ebp)
f0100940:	8d 83 a8 cf fe ff    	lea    -0x13058(%ebx),%eax
f0100946:	50                   	push   %eax
f0100947:	e8 d2 26 00 00       	call   f010301e <cprintf>
f010094c:	83 c4 10             	add    $0x10,%esp
f010094f:	e9 4f ff ff ff       	jmp    f01008a3 <monitor+0x83>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100954:	b8 01 00 00 00       	mov    $0x1,%eax
			return commands[i].func(argc, argv, tf);
f0100959:	83 ec 04             	sub    $0x4,%esp
f010095c:	8d 04 40             	lea    (%eax,%eax,2),%eax
f010095f:	ff 75 08             	pushl  0x8(%ebp)
f0100962:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100965:	52                   	push   %edx
f0100966:	ff 75 a4             	pushl  -0x5c(%ebp)
f0100969:	ff 94 83 0c 1d 00 00 	call   *0x1d0c(%ebx,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100970:	83 c4 10             	add    $0x10,%esp
f0100973:	85 c0                	test   %eax,%eax
f0100975:	0f 89 28 ff ff ff    	jns    f01008a3 <monitor+0x83>
				break;
	}
}
f010097b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010097e:	5b                   	pop    %ebx
f010097f:	5e                   	pop    %esi
f0100980:	5f                   	pop    %edi
f0100981:	5d                   	pop    %ebp
f0100982:	c3                   	ret    

f0100983 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100983:	55                   	push   %ebp
f0100984:	89 e5                	mov    %esp,%ebp
f0100986:	57                   	push   %edi
f0100987:	56                   	push   %esi
f0100988:	53                   	push   %ebx
f0100989:	83 ec 18             	sub    $0x18,%esp
f010098c:	e8 be f7 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100991:	81 c3 7b 69 01 00    	add    $0x1697b,%ebx
f0100997:	89 c7                	mov    %eax,%edi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100999:	50                   	push   %eax
f010099a:	e8 f8 25 00 00       	call   f0102f97 <mc146818_read>
f010099f:	89 c6                	mov    %eax,%esi
f01009a1:	83 c7 01             	add    $0x1,%edi
f01009a4:	89 3c 24             	mov    %edi,(%esp)
f01009a7:	e8 eb 25 00 00       	call   f0102f97 <mc146818_read>
f01009ac:	c1 e0 08             	shl    $0x8,%eax
f01009af:	09 f0                	or     %esi,%eax
}
f01009b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01009b4:	5b                   	pop    %ebx
f01009b5:	5e                   	pop    %esi
f01009b6:	5f                   	pop    %edi
f01009b7:	5d                   	pop    %ebp
f01009b8:	c3                   	ret    

f01009b9 <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f01009b9:	55                   	push   %ebp
f01009ba:	89 e5                	mov    %esp,%ebp
f01009bc:	56                   	push   %esi
f01009bd:	53                   	push   %ebx
f01009be:	e8 cc 25 00 00       	call   f0102f8f <__x86.get_pc_thunk.cx>
f01009c3:	81 c1 49 69 01 00    	add    $0x16949,%ecx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f01009c9:	83 b9 8c 1f 00 00 00 	cmpl   $0x0,0x1f8c(%ecx)
f01009d0:	74 37                	je     f0100a09 <boot_alloc+0x50>
	}

	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	result = nextfree;
f01009d2:	8b b1 8c 1f 00 00    	mov    0x1f8c(%ecx),%esi
	nextfree = ROUNDUP(nextfree+n, PGSIZE);
f01009d8:	8d 94 06 ff 0f 00 00 	lea    0xfff(%esi,%eax,1),%edx
f01009df:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01009e5:	89 91 8c 1f 00 00    	mov    %edx,0x1f8c(%ecx)
	if((uint32_t)nextfree - KERNBASE > (npages*PGSIZE))
f01009eb:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f01009f1:	c7 c0 c8 96 11 f0    	mov    $0xf01196c8,%eax
f01009f7:	8b 18                	mov    (%eax),%ebx
f01009f9:	c1 e3 0c             	shl    $0xc,%ebx
f01009fc:	39 da                	cmp    %ebx,%edx
f01009fe:	77 23                	ja     f0100a23 <boot_alloc+0x6a>
		panic("Out of memory!\n");
	return result;
}
f0100a00:	89 f0                	mov    %esi,%eax
f0100a02:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100a05:	5b                   	pop    %ebx
f0100a06:	5e                   	pop    %esi
f0100a07:	5d                   	pop    %ebp
f0100a08:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100a09:	c7 c2 c0 96 11 f0    	mov    $0xf01196c0,%edx
f0100a0f:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100a15:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100a1b:	89 91 8c 1f 00 00    	mov    %edx,0x1f8c(%ecx)
f0100a21:	eb af                	jmp    f01009d2 <boot_alloc+0x19>
		panic("Out of memory!\n");
f0100a23:	83 ec 04             	sub    $0x4,%esp
f0100a26:	8d 81 15 d1 fe ff    	lea    -0x12eeb(%ecx),%eax
f0100a2c:	50                   	push   %eax
f0100a2d:	6a 6a                	push   $0x6a
f0100a2f:	8d 81 25 d1 fe ff    	lea    -0x12edb(%ecx),%eax
f0100a35:	50                   	push   %eax
f0100a36:	89 cb                	mov    %ecx,%ebx
f0100a38:	e8 5c f6 ff ff       	call   f0100099 <_panic>

f0100a3d <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100a3d:	55                   	push   %ebp
f0100a3e:	89 e5                	mov    %esp,%ebp
f0100a40:	56                   	push   %esi
f0100a41:	53                   	push   %ebx
f0100a42:	e8 48 25 00 00       	call   f0102f8f <__x86.get_pc_thunk.cx>
f0100a47:	81 c1 c5 68 01 00    	add    $0x168c5,%ecx
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100a4d:	89 d3                	mov    %edx,%ebx
f0100a4f:	c1 eb 16             	shr    $0x16,%ebx
	if (!(*pgdir & PTE_P))
f0100a52:	8b 04 98             	mov    (%eax,%ebx,4),%eax
f0100a55:	a8 01                	test   $0x1,%al
f0100a57:	74 5a                	je     f0100ab3 <check_va2pa+0x76>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100a59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100a5e:	89 c6                	mov    %eax,%esi
f0100a60:	c1 ee 0c             	shr    $0xc,%esi
f0100a63:	c7 c3 c8 96 11 f0    	mov    $0xf01196c8,%ebx
f0100a69:	3b 33                	cmp    (%ebx),%esi
f0100a6b:	73 2b                	jae    f0100a98 <check_va2pa+0x5b>
	if (!(p[PTX(va)] & PTE_P))
f0100a6d:	c1 ea 0c             	shr    $0xc,%edx
f0100a70:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100a76:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100a7d:	89 c2                	mov    %eax,%edx
f0100a7f:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100a82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a87:	85 d2                	test   %edx,%edx
f0100a89:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100a8e:	0f 44 c2             	cmove  %edx,%eax
}
f0100a91:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100a94:	5b                   	pop    %ebx
f0100a95:	5e                   	pop    %esi
f0100a96:	5d                   	pop    %ebp
f0100a97:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100a98:	50                   	push   %eax
f0100a99:	8d 81 2c d4 fe ff    	lea    -0x12bd4(%ecx),%eax
f0100a9f:	50                   	push   %eax
f0100aa0:	68 db 02 00 00       	push   $0x2db
f0100aa5:	8d 81 25 d1 fe ff    	lea    -0x12edb(%ecx),%eax
f0100aab:	50                   	push   %eax
f0100aac:	89 cb                	mov    %ecx,%ebx
f0100aae:	e8 e6 f5 ff ff       	call   f0100099 <_panic>
		return ~0;
f0100ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100ab8:	eb d7                	jmp    f0100a91 <check_va2pa+0x54>

f0100aba <check_page_free_list>:
{
f0100aba:	55                   	push   %ebp
f0100abb:	89 e5                	mov    %esp,%ebp
f0100abd:	57                   	push   %edi
f0100abe:	56                   	push   %esi
f0100abf:	53                   	push   %ebx
f0100ac0:	83 ec 3c             	sub    $0x3c,%esp
f0100ac3:	e8 cb 24 00 00       	call   f0102f93 <__x86.get_pc_thunk.di>
f0100ac8:	81 c7 44 68 01 00    	add    $0x16844,%edi
f0100ace:	89 7d c4             	mov    %edi,-0x3c(%ebp)
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ad1:	84 c0                	test   %al,%al
f0100ad3:	0f 85 dd 02 00 00    	jne    f0100db6 <check_page_free_list+0x2fc>
	if (!page_free_list)
f0100ad9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0100adc:	83 b8 90 1f 00 00 00 	cmpl   $0x0,0x1f90(%eax)
f0100ae3:	74 0c                	je     f0100af1 <check_page_free_list+0x37>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ae5:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
f0100aec:	e9 2f 03 00 00       	jmp    f0100e20 <check_page_free_list+0x366>
		panic("'page_free_list' is a null pointer!");
f0100af1:	83 ec 04             	sub    $0x4,%esp
f0100af4:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100af7:	8d 83 50 d4 fe ff    	lea    -0x12bb0(%ebx),%eax
f0100afd:	50                   	push   %eax
f0100afe:	68 1c 02 00 00       	push   $0x21c
f0100b03:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100b09:	50                   	push   %eax
f0100b0a:	e8 8a f5 ff ff       	call   f0100099 <_panic>
f0100b0f:	50                   	push   %eax
f0100b10:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100b13:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f0100b19:	50                   	push   %eax
f0100b1a:	6a 52                	push   $0x52
f0100b1c:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f0100b22:	50                   	push   %eax
f0100b23:	e8 71 f5 ff ff       	call   f0100099 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100b28:	8b 36                	mov    (%esi),%esi
f0100b2a:	85 f6                	test   %esi,%esi
f0100b2c:	74 40                	je     f0100b6e <check_page_free_list+0xb4>
void	tlb_invalidate(pde_t *pgdir, void *va);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100b2e:	89 f0                	mov    %esi,%eax
f0100b30:	2b 07                	sub    (%edi),%eax
f0100b32:	c1 f8 03             	sar    $0x3,%eax
f0100b35:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100b38:	89 c2                	mov    %eax,%edx
f0100b3a:	c1 ea 16             	shr    $0x16,%edx
f0100b3d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
f0100b40:	73 e6                	jae    f0100b28 <check_page_free_list+0x6e>
	if (PGNUM(pa) >= npages)
f0100b42:	89 c2                	mov    %eax,%edx
f0100b44:	c1 ea 0c             	shr    $0xc,%edx
f0100b47:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100b4a:	3b 11                	cmp    (%ecx),%edx
f0100b4c:	73 c1                	jae    f0100b0f <check_page_free_list+0x55>
			memset(page2kva(pp), 0x97, 128);
f0100b4e:	83 ec 04             	sub    $0x4,%esp
f0100b51:	68 80 00 00 00       	push   $0x80
f0100b56:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100b5b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100b60:	50                   	push   %eax
f0100b61:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100b64:	e8 11 30 00 00       	call   f0103b7a <memset>
f0100b69:	83 c4 10             	add    $0x10,%esp
f0100b6c:	eb ba                	jmp    f0100b28 <check_page_free_list+0x6e>
	first_free_page = (char *) boot_alloc(0);
f0100b6e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b73:	e8 41 fe ff ff       	call   f01009b9 <boot_alloc>
f0100b78:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100b7b:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100b7e:	8b 97 90 1f 00 00    	mov    0x1f90(%edi),%edx
		assert(pp >= pages);
f0100b84:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0100b8a:	8b 08                	mov    (%eax),%ecx
		assert(pp < pages + npages);
f0100b8c:	c7 c0 c8 96 11 f0    	mov    $0xf01196c8,%eax
f0100b92:	8b 00                	mov    (%eax),%eax
f0100b94:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100b97:	8d 1c c1             	lea    (%ecx,%eax,8),%ebx
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100b9a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
	int nfree_basemem = 0, nfree_extmem = 0;
f0100b9d:	bf 00 00 00 00       	mov    $0x0,%edi
f0100ba2:	89 75 d0             	mov    %esi,-0x30(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100ba5:	e9 08 01 00 00       	jmp    f0100cb2 <check_page_free_list+0x1f8>
		assert(pp >= pages);
f0100baa:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100bad:	8d 83 3f d1 fe ff    	lea    -0x12ec1(%ebx),%eax
f0100bb3:	50                   	push   %eax
f0100bb4:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100bba:	50                   	push   %eax
f0100bbb:	68 36 02 00 00       	push   $0x236
f0100bc0:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100bc6:	50                   	push   %eax
f0100bc7:	e8 cd f4 ff ff       	call   f0100099 <_panic>
		assert(pp < pages + npages);
f0100bcc:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100bcf:	8d 83 60 d1 fe ff    	lea    -0x12ea0(%ebx),%eax
f0100bd5:	50                   	push   %eax
f0100bd6:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100bdc:	50                   	push   %eax
f0100bdd:	68 37 02 00 00       	push   $0x237
f0100be2:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100be8:	50                   	push   %eax
f0100be9:	e8 ab f4 ff ff       	call   f0100099 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100bee:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100bf1:	8d 83 74 d4 fe ff    	lea    -0x12b8c(%ebx),%eax
f0100bf7:	50                   	push   %eax
f0100bf8:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100bfe:	50                   	push   %eax
f0100bff:	68 38 02 00 00       	push   $0x238
f0100c04:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100c0a:	50                   	push   %eax
f0100c0b:	e8 89 f4 ff ff       	call   f0100099 <_panic>
		assert(page2pa(pp) != 0);
f0100c10:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100c13:	8d 83 74 d1 fe ff    	lea    -0x12e8c(%ebx),%eax
f0100c19:	50                   	push   %eax
f0100c1a:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100c20:	50                   	push   %eax
f0100c21:	68 3b 02 00 00       	push   $0x23b
f0100c26:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100c2c:	50                   	push   %eax
f0100c2d:	e8 67 f4 ff ff       	call   f0100099 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100c32:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100c35:	8d 83 85 d1 fe ff    	lea    -0x12e7b(%ebx),%eax
f0100c3b:	50                   	push   %eax
f0100c3c:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100c42:	50                   	push   %eax
f0100c43:	68 3c 02 00 00       	push   $0x23c
f0100c48:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100c4e:	50                   	push   %eax
f0100c4f:	e8 45 f4 ff ff       	call   f0100099 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100c54:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100c57:	8d 83 a8 d4 fe ff    	lea    -0x12b58(%ebx),%eax
f0100c5d:	50                   	push   %eax
f0100c5e:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100c64:	50                   	push   %eax
f0100c65:	68 3d 02 00 00       	push   $0x23d
f0100c6a:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100c70:	50                   	push   %eax
f0100c71:	e8 23 f4 ff ff       	call   f0100099 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100c76:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100c79:	8d 83 9e d1 fe ff    	lea    -0x12e62(%ebx),%eax
f0100c7f:	50                   	push   %eax
f0100c80:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100c86:	50                   	push   %eax
f0100c87:	68 3e 02 00 00       	push   $0x23e
f0100c8c:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100c92:	50                   	push   %eax
f0100c93:	e8 01 f4 ff ff       	call   f0100099 <_panic>
	if (PGNUM(pa) >= npages)
f0100c98:	89 c6                	mov    %eax,%esi
f0100c9a:	c1 ee 0c             	shr    $0xc,%esi
f0100c9d:	39 75 cc             	cmp    %esi,-0x34(%ebp)
f0100ca0:	76 70                	jbe    f0100d12 <check_page_free_list+0x258>
	return (void *)(pa + KERNBASE);
f0100ca2:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ca7:	39 45 c8             	cmp    %eax,-0x38(%ebp)
f0100caa:	77 7f                	ja     f0100d2b <check_page_free_list+0x271>
			++nfree_extmem;
f0100cac:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100cb0:	8b 12                	mov    (%edx),%edx
f0100cb2:	85 d2                	test   %edx,%edx
f0100cb4:	0f 84 93 00 00 00    	je     f0100d4d <check_page_free_list+0x293>
		assert(pp >= pages);
f0100cba:	39 d1                	cmp    %edx,%ecx
f0100cbc:	0f 87 e8 fe ff ff    	ja     f0100baa <check_page_free_list+0xf0>
		assert(pp < pages + npages);
f0100cc2:	39 d3                	cmp    %edx,%ebx
f0100cc4:	0f 86 02 ff ff ff    	jbe    f0100bcc <check_page_free_list+0x112>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100cca:	89 d0                	mov    %edx,%eax
f0100ccc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
f0100ccf:	a8 07                	test   $0x7,%al
f0100cd1:	0f 85 17 ff ff ff    	jne    f0100bee <check_page_free_list+0x134>
	return (pp - pages) << PGSHIFT;
f0100cd7:	c1 f8 03             	sar    $0x3,%eax
f0100cda:	c1 e0 0c             	shl    $0xc,%eax
		assert(page2pa(pp) != 0);
f0100cdd:	85 c0                	test   %eax,%eax
f0100cdf:	0f 84 2b ff ff ff    	je     f0100c10 <check_page_free_list+0x156>
		assert(page2pa(pp) != IOPHYSMEM);
f0100ce5:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100cea:	0f 84 42 ff ff ff    	je     f0100c32 <check_page_free_list+0x178>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100cf0:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100cf5:	0f 84 59 ff ff ff    	je     f0100c54 <check_page_free_list+0x19a>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100cfb:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100d00:	0f 84 70 ff ff ff    	je     f0100c76 <check_page_free_list+0x1bc>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d06:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100d0b:	77 8b                	ja     f0100c98 <check_page_free_list+0x1de>
			++nfree_basemem;
f0100d0d:	83 c7 01             	add    $0x1,%edi
f0100d10:	eb 9e                	jmp    f0100cb0 <check_page_free_list+0x1f6>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d12:	50                   	push   %eax
f0100d13:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100d16:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f0100d1c:	50                   	push   %eax
f0100d1d:	6a 52                	push   $0x52
f0100d1f:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f0100d25:	50                   	push   %eax
f0100d26:	e8 6e f3 ff ff       	call   f0100099 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d2b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100d2e:	8d 83 cc d4 fe ff    	lea    -0x12b34(%ebx),%eax
f0100d34:	50                   	push   %eax
f0100d35:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100d3b:	50                   	push   %eax
f0100d3c:	68 3f 02 00 00       	push   $0x23f
f0100d41:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100d47:	50                   	push   %eax
f0100d48:	e8 4c f3 ff ff       	call   f0100099 <_panic>
f0100d4d:	8b 75 d0             	mov    -0x30(%ebp),%esi
	assert(nfree_basemem > 0);
f0100d50:	85 ff                	test   %edi,%edi
f0100d52:	7e 1e                	jle    f0100d72 <check_page_free_list+0x2b8>
	assert(nfree_extmem > 0);
f0100d54:	85 f6                	test   %esi,%esi
f0100d56:	7e 3c                	jle    f0100d94 <check_page_free_list+0x2da>
	cprintf("check_page_free_list() succeeded!\n");
f0100d58:	83 ec 0c             	sub    $0xc,%esp
f0100d5b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100d5e:	8d 83 14 d5 fe ff    	lea    -0x12aec(%ebx),%eax
f0100d64:	50                   	push   %eax
f0100d65:	e8 b4 22 00 00       	call   f010301e <cprintf>
}
f0100d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100d6d:	5b                   	pop    %ebx
f0100d6e:	5e                   	pop    %esi
f0100d6f:	5f                   	pop    %edi
f0100d70:	5d                   	pop    %ebp
f0100d71:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100d72:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100d75:	8d 83 b8 d1 fe ff    	lea    -0x12e48(%ebx),%eax
f0100d7b:	50                   	push   %eax
f0100d7c:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100d82:	50                   	push   %eax
f0100d83:	68 47 02 00 00       	push   $0x247
f0100d88:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100d8e:	50                   	push   %eax
f0100d8f:	e8 05 f3 ff ff       	call   f0100099 <_panic>
	assert(nfree_extmem > 0);
f0100d94:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0100d97:	8d 83 ca d1 fe ff    	lea    -0x12e36(%ebx),%eax
f0100d9d:	50                   	push   %eax
f0100d9e:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100da4:	50                   	push   %eax
f0100da5:	68 48 02 00 00       	push   $0x248
f0100daa:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100db0:	50                   	push   %eax
f0100db1:	e8 e3 f2 ff ff       	call   f0100099 <_panic>
	if (!page_free_list)
f0100db6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0100db9:	8b 80 90 1f 00 00    	mov    0x1f90(%eax),%eax
f0100dbf:	85 c0                	test   %eax,%eax
f0100dc1:	0f 84 2a fd ff ff    	je     f0100af1 <check_page_free_list+0x37>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100dc7:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100dca:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100dcd:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100dd0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	return (pp - pages) << PGSHIFT;
f0100dd3:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100dd6:	c7 c3 d0 96 11 f0    	mov    $0xf01196d0,%ebx
f0100ddc:	89 c2                	mov    %eax,%edx
f0100dde:	2b 13                	sub    (%ebx),%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100de0:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100de6:	0f 95 c2             	setne  %dl
f0100de9:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100dec:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100df0:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100df2:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100df6:	8b 00                	mov    (%eax),%eax
f0100df8:	85 c0                	test   %eax,%eax
f0100dfa:	75 e0                	jne    f0100ddc <check_page_free_list+0x322>
		*tp[1] = 0;
f0100dfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100dff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100e05:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e0b:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100e0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e10:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100e13:	89 87 90 1f 00 00    	mov    %eax,0x1f90(%edi)
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100e19:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100e20:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0100e23:	8b b0 90 1f 00 00    	mov    0x1f90(%eax),%esi
f0100e29:	c7 c7 d0 96 11 f0    	mov    $0xf01196d0,%edi
	if (PGNUM(pa) >= npages)
f0100e2f:	c7 c0 c8 96 11 f0    	mov    $0xf01196c8,%eax
f0100e35:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100e38:	e9 ed fc ff ff       	jmp    f0100b2a <check_page_free_list+0x70>

f0100e3d <page_init>:
{
f0100e3d:	55                   	push   %ebp
f0100e3e:	89 e5                	mov    %esp,%ebp
f0100e40:	57                   	push   %edi
f0100e41:	56                   	push   %esi
f0100e42:	53                   	push   %ebx
f0100e43:	83 ec 2c             	sub    $0x2c,%esp
f0100e46:	e8 04 f3 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100e4b:	81 c3 c1 64 01 00    	add    $0x164c1,%ebx
	page_free_list = NULL;
f0100e51:	c7 83 90 1f 00 00 00 	movl   $0x0,0x1f90(%ebx)
f0100e58:	00 00 00 
	int num_alloc = ((uint32_t)boot_alloc(0) - KERNBASE) / PGSIZE;
f0100e5b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e60:	e8 54 fb ff ff       	call   f01009b9 <boot_alloc>
	    else if(i >= npages_basemem && i < npages_basemem + num_iohole + num_alloc)
f0100e65:	8b 93 94 1f 00 00    	mov    0x1f94(%ebx),%edx
f0100e6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	int num_alloc = ((uint32_t)boot_alloc(0) - KERNBASE) / PGSIZE;
f0100e6e:	05 00 00 00 10       	add    $0x10000000,%eax
f0100e73:	c1 e8 0c             	shr    $0xc,%eax
	    else if(i >= npages_basemem && i < npages_basemem + num_iohole + num_alloc)
f0100e76:	8d 44 02 60          	lea    0x60(%edx,%eax,1),%eax
f0100e7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for(i=0; i<npages; i++)
f0100e7d:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100e82:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0100e89:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e8e:	c7 c2 c8 96 11 f0    	mov    $0xf01196c8,%edx
	        pages[i].pp_ref = 0;
f0100e94:	c7 c7 d0 96 11 f0    	mov    $0xf01196d0,%edi
f0100e9a:	89 7d e0             	mov    %edi,-0x20(%ebp)
	        pages[i].pp_ref = 1;
f0100e9d:	89 7d d0             	mov    %edi,-0x30(%ebp)
	        pages[i].pp_ref = 1;
f0100ea0:	89 7d d8             	mov    %edi,-0x28(%ebp)
	for(i=0; i<npages; i++)
f0100ea3:	eb 43                	jmp    f0100ee8 <page_init+0xab>
	    else if(i >= npages_basemem && i < npages_basemem + num_iohole + num_alloc)
f0100ea5:	39 45 dc             	cmp    %eax,-0x24(%ebp)
f0100ea8:	77 13                	ja     f0100ebd <page_init+0x80>
f0100eaa:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0100ead:	76 0e                	jbe    f0100ebd <page_init+0x80>
	        pages[i].pp_ref = 1;
f0100eaf:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0100eb2:	8b 36                	mov    (%esi),%esi
f0100eb4:	66 c7 44 c6 04 01 00 	movw   $0x1,0x4(%esi,%eax,8)
f0100ebb:	eb 28                	jmp    f0100ee5 <page_init+0xa8>
f0100ebd:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
	        pages[i].pp_ref = 0;
f0100ec4:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0100ec7:	89 cf                	mov    %ecx,%edi
f0100ec9:	03 3e                	add    (%esi),%edi
f0100ecb:	89 fe                	mov    %edi,%esi
f0100ecd:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)
	        pages[i].pp_link = page_free_list;
f0100ed3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100ed6:	89 3e                	mov    %edi,(%esi)
	        page_free_list = &pages[i];
f0100ed8:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0100edb:	03 0e                	add    (%esi),%ecx
f0100edd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0100ee0:	b9 01 00 00 00       	mov    $0x1,%ecx
	for(i=0; i<npages; i++)
f0100ee5:	83 c0 01             	add    $0x1,%eax
f0100ee8:	39 02                	cmp    %eax,(%edx)
f0100eea:	76 11                	jbe    f0100efd <page_init+0xc0>
	    if(i==0)
f0100eec:	85 c0                	test   %eax,%eax
f0100eee:	75 b5                	jne    f0100ea5 <page_init+0x68>
	        pages[i].pp_ref = 1;
f0100ef0:	8b 7d d8             	mov    -0x28(%ebp),%edi
f0100ef3:	8b 37                	mov    (%edi),%esi
f0100ef5:	66 c7 46 04 01 00    	movw   $0x1,0x4(%esi)
f0100efb:	eb e8                	jmp    f0100ee5 <page_init+0xa8>
f0100efd:	84 c9                	test   %cl,%cl
f0100eff:	75 08                	jne    f0100f09 <page_init+0xcc>
}
f0100f01:	83 c4 2c             	add    $0x2c,%esp
f0100f04:	5b                   	pop    %ebx
f0100f05:	5e                   	pop    %esi
f0100f06:	5f                   	pop    %edi
f0100f07:	5d                   	pop    %ebp
f0100f08:	c3                   	ret    
f0100f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100f0c:	89 83 90 1f 00 00    	mov    %eax,0x1f90(%ebx)
f0100f12:	eb ed                	jmp    f0100f01 <page_init+0xc4>

f0100f14 <page_alloc>:
{
f0100f14:	55                   	push   %ebp
f0100f15:	89 e5                	mov    %esp,%ebp
f0100f17:	56                   	push   %esi
f0100f18:	53                   	push   %ebx
f0100f19:	e8 31 f2 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100f1e:	81 c3 ee 63 01 00    	add    $0x163ee,%ebx
    if (page_free_list == NULL)
f0100f24:	8b b3 90 1f 00 00    	mov    0x1f90(%ebx),%esi
f0100f2a:	85 f6                	test   %esi,%esi
f0100f2c:	74 14                	je     f0100f42 <page_alloc+0x2e>
      page_free_list = result->pp_link;
f0100f2e:	8b 06                	mov    (%esi),%eax
f0100f30:	89 83 90 1f 00 00    	mov    %eax,0x1f90(%ebx)
      result->pp_link = NULL;
f0100f36:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    if (alloc_flags & ALLOC_ZERO)
f0100f3c:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0100f40:	75 09                	jne    f0100f4b <page_alloc+0x37>
}
f0100f42:	89 f0                	mov    %esi,%eax
f0100f44:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100f47:	5b                   	pop    %ebx
f0100f48:	5e                   	pop    %esi
f0100f49:	5d                   	pop    %ebp
f0100f4a:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0100f4b:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0100f51:	89 f2                	mov    %esi,%edx
f0100f53:	2b 10                	sub    (%eax),%edx
f0100f55:	89 d0                	mov    %edx,%eax
f0100f57:	c1 f8 03             	sar    $0x3,%eax
f0100f5a:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0100f5d:	89 c1                	mov    %eax,%ecx
f0100f5f:	c1 e9 0c             	shr    $0xc,%ecx
f0100f62:	c7 c2 c8 96 11 f0    	mov    $0xf01196c8,%edx
f0100f68:	3b 0a                	cmp    (%edx),%ecx
f0100f6a:	73 1a                	jae    f0100f86 <page_alloc+0x72>
        memset(page2kva(result), 0, PGSIZE); 
f0100f6c:	83 ec 04             	sub    $0x4,%esp
f0100f6f:	68 00 10 00 00       	push   $0x1000
f0100f74:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0100f76:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100f7b:	50                   	push   %eax
f0100f7c:	e8 f9 2b 00 00       	call   f0103b7a <memset>
f0100f81:	83 c4 10             	add    $0x10,%esp
f0100f84:	eb bc                	jmp    f0100f42 <page_alloc+0x2e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f86:	50                   	push   %eax
f0100f87:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f0100f8d:	50                   	push   %eax
f0100f8e:	6a 52                	push   $0x52
f0100f90:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f0100f96:	50                   	push   %eax
f0100f97:	e8 fd f0 ff ff       	call   f0100099 <_panic>

f0100f9c <page_free>:
{
f0100f9c:	55                   	push   %ebp
f0100f9d:	89 e5                	mov    %esp,%ebp
f0100f9f:	53                   	push   %ebx
f0100fa0:	83 ec 04             	sub    $0x4,%esp
f0100fa3:	e8 a7 f1 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0100fa8:	81 c3 64 63 01 00    	add    $0x16364,%ebx
f0100fae:	8b 45 08             	mov    0x8(%ebp),%eax
      assert(pp->pp_ref == 0);
f0100fb1:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0100fb6:	75 18                	jne    f0100fd0 <page_free+0x34>
      assert(pp->pp_link == NULL);
f0100fb8:	83 38 00             	cmpl   $0x0,(%eax)
f0100fbb:	75 32                	jne    f0100fef <page_free+0x53>
      pp->pp_link = page_free_list;
f0100fbd:	8b 8b 90 1f 00 00    	mov    0x1f90(%ebx),%ecx
f0100fc3:	89 08                	mov    %ecx,(%eax)
      page_free_list = pp;
f0100fc5:	89 83 90 1f 00 00    	mov    %eax,0x1f90(%ebx)
}
f0100fcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100fce:	c9                   	leave  
f0100fcf:	c3                   	ret    
      assert(pp->pp_ref == 0);
f0100fd0:	8d 83 db d1 fe ff    	lea    -0x12e25(%ebx),%eax
f0100fd6:	50                   	push   %eax
f0100fd7:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100fdd:	50                   	push   %eax
f0100fde:	68 40 01 00 00       	push   $0x140
f0100fe3:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0100fe9:	50                   	push   %eax
f0100fea:	e8 aa f0 ff ff       	call   f0100099 <_panic>
      assert(pp->pp_link == NULL);
f0100fef:	8d 83 eb d1 fe ff    	lea    -0x12e15(%ebx),%eax
f0100ff5:	50                   	push   %eax
f0100ff6:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0100ffc:	50                   	push   %eax
f0100ffd:	68 41 01 00 00       	push   $0x141
f0101002:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0101008:	50                   	push   %eax
f0101009:	e8 8b f0 ff ff       	call   f0100099 <_panic>

f010100e <page_decref>:
{
f010100e:	55                   	push   %ebp
f010100f:	89 e5                	mov    %esp,%ebp
f0101011:	83 ec 08             	sub    $0x8,%esp
f0101014:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0101017:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f010101b:	83 e8 01             	sub    $0x1,%eax
f010101e:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101022:	66 85 c0             	test   %ax,%ax
f0101025:	74 02                	je     f0101029 <page_decref+0x1b>
}
f0101027:	c9                   	leave  
f0101028:	c3                   	ret    
		page_free(pp);
f0101029:	83 ec 0c             	sub    $0xc,%esp
f010102c:	52                   	push   %edx
f010102d:	e8 6a ff ff ff       	call   f0100f9c <page_free>
f0101032:	83 c4 10             	add    $0x10,%esp
}
f0101035:	eb f0                	jmp    f0101027 <page_decref+0x19>

f0101037 <pgdir_walk>:
{
f0101037:	55                   	push   %ebp
f0101038:	89 e5                	mov    %esp,%ebp
f010103a:	57                   	push   %edi
f010103b:	56                   	push   %esi
f010103c:	53                   	push   %ebx
f010103d:	83 ec 0c             	sub    $0xc,%esp
f0101040:	e8 0a f1 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0101045:	81 c3 c7 62 01 00    	add    $0x162c7,%ebx
f010104b:	8b 7d 0c             	mov    0xc(%ebp),%edi
      unsigned int dic_off = PDX(va);
f010104e:	89 fe                	mov    %edi,%esi
f0101050:	c1 ee 16             	shr    $0x16,%esi
      pde_t * dic_entry_ptr = pgdir + dic_off;
f0101053:	c1 e6 02             	shl    $0x2,%esi
f0101056:	03 75 08             	add    0x8(%ebp),%esi
      if(!(*dic_entry_ptr & PTE_P))
f0101059:	f6 06 01             	testb  $0x1,(%esi)
f010105c:	75 2f                	jne    f010108d <pgdir_walk+0x56>
            if(create)
f010105e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101062:	74 70                	je     f01010d4 <pgdir_walk+0x9d>
                   new_page = page_alloc(1);
f0101064:	83 ec 0c             	sub    $0xc,%esp
f0101067:	6a 01                	push   $0x1
f0101069:	e8 a6 fe ff ff       	call   f0100f14 <page_alloc>
                   if(new_page == NULL) return NULL;
f010106e:	83 c4 10             	add    $0x10,%esp
f0101071:	85 c0                	test   %eax,%eax
f0101073:	74 66                	je     f01010db <pgdir_walk+0xa4>
                   new_page->pp_ref++;
f0101075:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010107a:	c7 c2 d0 96 11 f0    	mov    $0xf01196d0,%edx
f0101080:	2b 02                	sub    (%edx),%eax
f0101082:	c1 f8 03             	sar    $0x3,%eax
f0101085:	c1 e0 0c             	shl    $0xc,%eax
                   *dic_entry_ptr = (page2pa(new_page) | PTE_P | PTE_W | PTE_U);
f0101088:	83 c8 07             	or     $0x7,%eax
f010108b:	89 06                	mov    %eax,(%esi)
      page_off = PTX(va);
f010108d:	c1 ef 0c             	shr    $0xc,%edi
f0101090:	81 e7 ff 03 00 00    	and    $0x3ff,%edi
      page_base = KADDR(PTE_ADDR(*dic_entry_ptr));
f0101096:	8b 06                	mov    (%esi),%eax
f0101098:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f010109d:	89 c1                	mov    %eax,%ecx
f010109f:	c1 e9 0c             	shr    $0xc,%ecx
f01010a2:	c7 c2 c8 96 11 f0    	mov    $0xf01196c8,%edx
f01010a8:	3b 0a                	cmp    (%edx),%ecx
f01010aa:	73 0f                	jae    f01010bb <pgdir_walk+0x84>
      return &page_base[page_off];
f01010ac:	8d 84 b8 00 00 00 f0 	lea    -0x10000000(%eax,%edi,4),%eax
}
f01010b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01010b6:	5b                   	pop    %ebx
f01010b7:	5e                   	pop    %esi
f01010b8:	5f                   	pop    %edi
f01010b9:	5d                   	pop    %ebp
f01010ba:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01010bb:	50                   	push   %eax
f01010bc:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f01010c2:	50                   	push   %eax
f01010c3:	68 7f 01 00 00       	push   $0x17f
f01010c8:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01010ce:	50                   	push   %eax
f01010cf:	e8 c5 ef ff ff       	call   f0100099 <_panic>
               return NULL;      
f01010d4:	b8 00 00 00 00       	mov    $0x0,%eax
f01010d9:	eb d8                	jmp    f01010b3 <pgdir_walk+0x7c>
                   if(new_page == NULL) return NULL;
f01010db:	b8 00 00 00 00       	mov    $0x0,%eax
f01010e0:	eb d1                	jmp    f01010b3 <pgdir_walk+0x7c>

f01010e2 <boot_map_region>:
{
f01010e2:	55                   	push   %ebp
f01010e3:	89 e5                	mov    %esp,%ebp
f01010e5:	57                   	push   %edi
f01010e6:	56                   	push   %esi
f01010e7:	53                   	push   %ebx
f01010e8:	83 ec 1c             	sub    $0x1c,%esp
f01010eb:	89 c7                	mov    %eax,%edi
f01010ed:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01010f0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    for(nadd = 0; nadd < size; nadd += PGSIZE)
f01010f3:	bb 00 00 00 00       	mov    $0x0,%ebx
        *entry = (pa | perm | PTE_P);
f01010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01010fb:	83 c8 01             	or     $0x1,%eax
f01010fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for(nadd = 0; nadd < size; nadd += PGSIZE)
f0101101:	eb 1f                	jmp    f0101122 <boot_map_region+0x40>
        entry = pgdir_walk(pgdir,(void *)va, 1);    //Get the table entry of this page.
f0101103:	83 ec 04             	sub    $0x4,%esp
f0101106:	6a 01                	push   $0x1
f0101108:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010110b:	01 d8                	add    %ebx,%eax
f010110d:	50                   	push   %eax
f010110e:	57                   	push   %edi
f010110f:	e8 23 ff ff ff       	call   f0101037 <pgdir_walk>
        *entry = (pa | perm | PTE_P);
f0101114:	0b 75 dc             	or     -0x24(%ebp),%esi
f0101117:	89 30                	mov    %esi,(%eax)
    for(nadd = 0; nadd < size; nadd += PGSIZE)
f0101119:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010111f:	83 c4 10             	add    $0x10,%esp
f0101122:	89 de                	mov    %ebx,%esi
f0101124:	03 75 08             	add    0x8(%ebp),%esi
f0101127:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
f010112a:	77 d7                	ja     f0101103 <boot_map_region+0x21>
}
f010112c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010112f:	5b                   	pop    %ebx
f0101130:	5e                   	pop    %esi
f0101131:	5f                   	pop    %edi
f0101132:	5d                   	pop    %ebp
f0101133:	c3                   	ret    

f0101134 <page_lookup>:
{
f0101134:	55                   	push   %ebp
f0101135:	89 e5                	mov    %esp,%ebp
f0101137:	56                   	push   %esi
f0101138:	53                   	push   %ebx
f0101139:	e8 11 f0 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f010113e:	81 c3 ce 61 01 00    	add    $0x161ce,%ebx
f0101144:	8b 75 10             	mov    0x10(%ebp),%esi
	pte_t* entry = pgdir_walk(pgdir, va, 0);
f0101147:	83 ec 04             	sub    $0x4,%esp
f010114a:	6a 00                	push   $0x0
f010114c:	ff 75 0c             	pushl  0xc(%ebp)
f010114f:	ff 75 08             	pushl  0x8(%ebp)
f0101152:	e8 e0 fe ff ff       	call   f0101037 <pgdir_walk>
	if (entry == NULL) return NULL;
f0101157:	83 c4 10             	add    $0x10,%esp
f010115a:	85 c0                	test   %eax,%eax
f010115c:	74 3f                	je     f010119d <page_lookup+0x69>
	if (pte_store != NULL) *pte_store = entry;
f010115e:	85 f6                	test   %esi,%esi
f0101160:	74 02                	je     f0101164 <page_lookup+0x30>
f0101162:	89 06                	mov    %eax,(%esi)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101164:	8b 00                	mov    (%eax),%eax
f0101166:	c1 e8 0c             	shr    $0xc,%eax
f0101169:	c7 c2 c8 96 11 f0    	mov    $0xf01196c8,%edx
f010116f:	3b 02                	cmp    (%edx),%eax
f0101171:	73 12                	jae    f0101185 <page_lookup+0x51>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101173:	c7 c2 d0 96 11 f0    	mov    $0xf01196d0,%edx
f0101179:	8b 12                	mov    (%edx),%edx
f010117b:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f010117e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101181:	5b                   	pop    %ebx
f0101182:	5e                   	pop    %esi
f0101183:	5d                   	pop    %ebp
f0101184:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101185:	83 ec 04             	sub    $0x4,%esp
f0101188:	8d 83 38 d5 fe ff    	lea    -0x12ac8(%ebx),%eax
f010118e:	50                   	push   %eax
f010118f:	6a 4b                	push   $0x4b
f0101191:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f0101197:	50                   	push   %eax
f0101198:	e8 fc ee ff ff       	call   f0100099 <_panic>
	if (entry == NULL) return NULL;
f010119d:	b8 00 00 00 00       	mov    $0x0,%eax
f01011a2:	eb da                	jmp    f010117e <page_lookup+0x4a>

f01011a4 <page_remove>:
{
f01011a4:	55                   	push   %ebp
f01011a5:	89 e5                	mov    %esp,%ebp
f01011a7:	57                   	push   %edi
f01011a8:	56                   	push   %esi
f01011a9:	53                   	push   %ebx
f01011aa:	83 ec 10             	sub    $0x10,%esp
f01011ad:	8b 75 08             	mov    0x8(%ebp),%esi
f01011b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct PageInfo * pp = page_lookup(pgdir, va, NULL);
f01011b3:	6a 00                	push   $0x0
f01011b5:	53                   	push   %ebx
f01011b6:	56                   	push   %esi
f01011b7:	e8 78 ff ff ff       	call   f0101134 <page_lookup>
f01011bc:	89 c7                	mov    %eax,%edi
	pte_t * entry = pgdir_walk(pgdir, va, 0);
f01011be:	83 c4 0c             	add    $0xc,%esp
f01011c1:	6a 00                	push   $0x0
f01011c3:	53                   	push   %ebx
f01011c4:	56                   	push   %esi
f01011c5:	e8 6d fe ff ff       	call   f0101037 <pgdir_walk>
	if (pp == NULL) return;
f01011ca:	83 c4 10             	add    $0x10,%esp
f01011cd:	85 ff                	test   %edi,%edi
f01011cf:	74 1b                	je     f01011ec <page_remove+0x48>
f01011d1:	89 c6                	mov    %eax,%esi
	page_decref(pp);
f01011d3:	83 ec 0c             	sub    $0xc,%esp
f01011d6:	57                   	push   %edi
f01011d7:	e8 32 fe ff ff       	call   f010100e <page_decref>
}

static inline void
invlpg(void *addr)
{
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01011dc:	0f 01 3b             	invlpg (%ebx)
	if (entry != NULL) *entry = 0;
f01011df:	83 c4 10             	add    $0x10,%esp
f01011e2:	85 f6                	test   %esi,%esi
f01011e4:	74 06                	je     f01011ec <page_remove+0x48>
f01011e6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
}
f01011ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011ef:	5b                   	pop    %ebx
f01011f0:	5e                   	pop    %esi
f01011f1:	5f                   	pop    %edi
f01011f2:	5d                   	pop    %ebp
f01011f3:	c3                   	ret    

f01011f4 <page_insert>:
{
f01011f4:	55                   	push   %ebp
f01011f5:	89 e5                	mov    %esp,%ebp
f01011f7:	57                   	push   %edi
f01011f8:	56                   	push   %esi
f01011f9:	53                   	push   %ebx
f01011fa:	83 ec 10             	sub    $0x10,%esp
f01011fd:	e8 91 1d 00 00       	call   f0102f93 <__x86.get_pc_thunk.di>
f0101202:	81 c7 0a 61 01 00    	add    $0x1610a,%edi
f0101208:	8b 5d 08             	mov    0x8(%ebp),%ebx
    entry =  pgdir_walk(pgdir, va, 1);    //Get the mapping page of this address va.
f010120b:	6a 01                	push   $0x1
f010120d:	ff 75 10             	pushl  0x10(%ebp)
f0101210:	53                   	push   %ebx
f0101211:	e8 21 fe ff ff       	call   f0101037 <pgdir_walk>
    if(entry == NULL) return -E_NO_MEM;
f0101216:	83 c4 10             	add    $0x10,%esp
f0101219:	85 c0                	test   %eax,%eax
f010121b:	74 5c                	je     f0101279 <page_insert+0x85>
f010121d:	89 c6                	mov    %eax,%esi
    pp->pp_ref++;
f010121f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101222:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
    if((*entry) & PTE_P)             //If this virtual address is already mapped.
f0101227:	f6 06 01             	testb  $0x1,(%esi)
f010122a:	75 36                	jne    f0101262 <page_insert+0x6e>
	return (pp - pages) << PGSHIFT;
f010122c:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0101232:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101235:	2b 08                	sub    (%eax),%ecx
f0101237:	89 c8                	mov    %ecx,%eax
f0101239:	c1 f8 03             	sar    $0x3,%eax
f010123c:	c1 e0 0c             	shl    $0xc,%eax
    *entry = (page2pa(pp) | perm | PTE_P);
f010123f:	8b 55 14             	mov    0x14(%ebp),%edx
f0101242:	83 ca 01             	or     $0x1,%edx
f0101245:	09 d0                	or     %edx,%eax
f0101247:	89 06                	mov    %eax,(%esi)
    pgdir[PDX(va)] |= perm;                  //Remember this step!
f0101249:	8b 45 10             	mov    0x10(%ebp),%eax
f010124c:	c1 e8 16             	shr    $0x16,%eax
f010124f:	8b 7d 14             	mov    0x14(%ebp),%edi
f0101252:	09 3c 83             	or     %edi,(%ebx,%eax,4)
    return 0;
f0101255:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010125d:	5b                   	pop    %ebx
f010125e:	5e                   	pop    %esi
f010125f:	5f                   	pop    %edi
f0101260:	5d                   	pop    %ebp
f0101261:	c3                   	ret    
f0101262:	8b 45 10             	mov    0x10(%ebp),%eax
f0101265:	0f 01 38             	invlpg (%eax)
        page_remove(pgdir, va);
f0101268:	83 ec 08             	sub    $0x8,%esp
f010126b:	ff 75 10             	pushl  0x10(%ebp)
f010126e:	53                   	push   %ebx
f010126f:	e8 30 ff ff ff       	call   f01011a4 <page_remove>
f0101274:	83 c4 10             	add    $0x10,%esp
f0101277:	eb b3                	jmp    f010122c <page_insert+0x38>
    if(entry == NULL) return -E_NO_MEM;
f0101279:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010127e:	eb da                	jmp    f010125a <page_insert+0x66>

f0101280 <mem_init>:
{
f0101280:	55                   	push   %ebp
f0101281:	89 e5                	mov    %esp,%ebp
f0101283:	57                   	push   %edi
f0101284:	56                   	push   %esi
f0101285:	53                   	push   %ebx
f0101286:	83 ec 3c             	sub    $0x3c,%esp
f0101289:	e8 63 f4 ff ff       	call   f01006f1 <__x86.get_pc_thunk.ax>
f010128e:	05 7e 60 01 00       	add    $0x1607e,%eax
f0101293:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	basemem = nvram_read(NVRAM_BASELO);
f0101296:	b8 15 00 00 00       	mov    $0x15,%eax
f010129b:	e8 e3 f6 ff ff       	call   f0100983 <nvram_read>
f01012a0:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f01012a2:	b8 17 00 00 00       	mov    $0x17,%eax
f01012a7:	e8 d7 f6 ff ff       	call   f0100983 <nvram_read>
f01012ac:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f01012ae:	b8 34 00 00 00       	mov    $0x34,%eax
f01012b3:	e8 cb f6 ff ff       	call   f0100983 <nvram_read>
f01012b8:	c1 e0 06             	shl    $0x6,%eax
	if (ext16mem)
f01012bb:	85 c0                	test   %eax,%eax
f01012bd:	0f 85 cd 00 00 00    	jne    f0101390 <mem_init+0x110>
		totalmem = 1 * 1024 + extmem;
f01012c3:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f01012c9:	85 f6                	test   %esi,%esi
f01012cb:	0f 44 c3             	cmove  %ebx,%eax
	npages = totalmem / (PGSIZE / 1024);
f01012ce:	89 c1                	mov    %eax,%ecx
f01012d0:	c1 e9 02             	shr    $0x2,%ecx
f01012d3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01012d6:	c7 c2 c8 96 11 f0    	mov    $0xf01196c8,%edx
f01012dc:	89 0a                	mov    %ecx,(%edx)
	npages_basemem = basemem / (PGSIZE / 1024);
f01012de:	89 da                	mov    %ebx,%edx
f01012e0:	c1 ea 02             	shr    $0x2,%edx
f01012e3:	89 97 94 1f 00 00    	mov    %edx,0x1f94(%edi)
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01012e9:	89 c2                	mov    %eax,%edx
f01012eb:	29 da                	sub    %ebx,%edx
f01012ed:	52                   	push   %edx
f01012ee:	53                   	push   %ebx
f01012ef:	50                   	push   %eax
f01012f0:	8d 87 58 d5 fe ff    	lea    -0x12aa8(%edi),%eax
f01012f6:	50                   	push   %eax
f01012f7:	89 fb                	mov    %edi,%ebx
f01012f9:	e8 20 1d 00 00       	call   f010301e <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01012fe:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101303:	e8 b1 f6 ff ff       	call   f01009b9 <boot_alloc>
f0101308:	c7 c6 cc 96 11 f0    	mov    $0xf01196cc,%esi
f010130e:	89 06                	mov    %eax,(%esi)
	memset(kern_pgdir, 0, PGSIZE);
f0101310:	83 c4 0c             	add    $0xc,%esp
f0101313:	68 00 10 00 00       	push   $0x1000
f0101318:	6a 00                	push   $0x0
f010131a:	50                   	push   %eax
f010131b:	e8 5a 28 00 00       	call   f0103b7a <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101320:	8b 06                	mov    (%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0101322:	83 c4 10             	add    $0x10,%esp
f0101325:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010132a:	76 6e                	jbe    f010139a <mem_init+0x11a>
	return (physaddr_t)kva - KERNBASE;
f010132c:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101332:	83 ca 05             	or     $0x5,%edx
f0101335:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo *) boot_alloc(npages * sizeof(struct PageInfo));
f010133b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f010133e:	c7 c3 c8 96 11 f0    	mov    $0xf01196c8,%ebx
f0101344:	8b 03                	mov    (%ebx),%eax
f0101346:	c1 e0 03             	shl    $0x3,%eax
f0101349:	e8 6b f6 ff ff       	call   f01009b9 <boot_alloc>
f010134e:	c7 c6 d0 96 11 f0    	mov    $0xf01196d0,%esi
f0101354:	89 06                	mov    %eax,(%esi)
	memset(pages, 0, npages * sizeof(struct PageInfo));
f0101356:	83 ec 04             	sub    $0x4,%esp
f0101359:	8b 13                	mov    (%ebx),%edx
f010135b:	c1 e2 03             	shl    $0x3,%edx
f010135e:	52                   	push   %edx
f010135f:	6a 00                	push   $0x0
f0101361:	50                   	push   %eax
f0101362:	89 fb                	mov    %edi,%ebx
f0101364:	e8 11 28 00 00       	call   f0103b7a <memset>
	page_init();
f0101369:	e8 cf fa ff ff       	call   f0100e3d <page_init>
	check_page_free_list(1);
f010136e:	b8 01 00 00 00       	mov    $0x1,%eax
f0101373:	e8 42 f7 ff ff       	call   f0100aba <check_page_free_list>
	if (!pages)
f0101378:	83 c4 10             	add    $0x10,%esp
f010137b:	83 3e 00             	cmpl   $0x0,(%esi)
f010137e:	74 36                	je     f01013b6 <mem_init+0x136>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101380:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101383:	8b 80 90 1f 00 00    	mov    0x1f90(%eax),%eax
f0101389:	be 00 00 00 00       	mov    $0x0,%esi
f010138e:	eb 49                	jmp    f01013d9 <mem_init+0x159>
		totalmem = 16 * 1024 + ext16mem;
f0101390:	05 00 40 00 00       	add    $0x4000,%eax
f0101395:	e9 34 ff ff ff       	jmp    f01012ce <mem_init+0x4e>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010139a:	50                   	push   %eax
f010139b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010139e:	8d 83 94 d5 fe ff    	lea    -0x12a6c(%ebx),%eax
f01013a4:	50                   	push   %eax
f01013a5:	68 8f 00 00 00       	push   $0x8f
f01013aa:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01013b0:	50                   	push   %eax
f01013b1:	e8 e3 ec ff ff       	call   f0100099 <_panic>
		panic("'pages' is a null pointer!");
f01013b6:	83 ec 04             	sub    $0x4,%esp
f01013b9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01013bc:	8d 83 ff d1 fe ff    	lea    -0x12e01(%ebx),%eax
f01013c2:	50                   	push   %eax
f01013c3:	68 5b 02 00 00       	push   $0x25b
f01013c8:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01013ce:	50                   	push   %eax
f01013cf:	e8 c5 ec ff ff       	call   f0100099 <_panic>
		++nfree;
f01013d4:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01013d7:	8b 00                	mov    (%eax),%eax
f01013d9:	85 c0                	test   %eax,%eax
f01013db:	75 f7                	jne    f01013d4 <mem_init+0x154>
	assert((pp0 = page_alloc(0)));
f01013dd:	83 ec 0c             	sub    $0xc,%esp
f01013e0:	6a 00                	push   $0x0
f01013e2:	e8 2d fb ff ff       	call   f0100f14 <page_alloc>
f01013e7:	89 c3                	mov    %eax,%ebx
f01013e9:	83 c4 10             	add    $0x10,%esp
f01013ec:	85 c0                	test   %eax,%eax
f01013ee:	0f 84 3b 02 00 00    	je     f010162f <mem_init+0x3af>
	assert((pp1 = page_alloc(0)));
f01013f4:	83 ec 0c             	sub    $0xc,%esp
f01013f7:	6a 00                	push   $0x0
f01013f9:	e8 16 fb ff ff       	call   f0100f14 <page_alloc>
f01013fe:	89 c7                	mov    %eax,%edi
f0101400:	83 c4 10             	add    $0x10,%esp
f0101403:	85 c0                	test   %eax,%eax
f0101405:	0f 84 46 02 00 00    	je     f0101651 <mem_init+0x3d1>
	assert((pp2 = page_alloc(0)));
f010140b:	83 ec 0c             	sub    $0xc,%esp
f010140e:	6a 00                	push   $0x0
f0101410:	e8 ff fa ff ff       	call   f0100f14 <page_alloc>
f0101415:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101418:	83 c4 10             	add    $0x10,%esp
f010141b:	85 c0                	test   %eax,%eax
f010141d:	0f 84 50 02 00 00    	je     f0101673 <mem_init+0x3f3>
	assert(pp1 && pp1 != pp0);
f0101423:	39 fb                	cmp    %edi,%ebx
f0101425:	0f 84 6a 02 00 00    	je     f0101695 <mem_init+0x415>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010142b:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010142e:	39 c7                	cmp    %eax,%edi
f0101430:	0f 84 81 02 00 00    	je     f01016b7 <mem_init+0x437>
f0101436:	39 c3                	cmp    %eax,%ebx
f0101438:	0f 84 79 02 00 00    	je     f01016b7 <mem_init+0x437>
	return (pp - pages) << PGSHIFT;
f010143e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101441:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0101447:	8b 08                	mov    (%eax),%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101449:	c7 c0 c8 96 11 f0    	mov    $0xf01196c8,%eax
f010144f:	8b 10                	mov    (%eax),%edx
f0101451:	c1 e2 0c             	shl    $0xc,%edx
f0101454:	89 d8                	mov    %ebx,%eax
f0101456:	29 c8                	sub    %ecx,%eax
f0101458:	c1 f8 03             	sar    $0x3,%eax
f010145b:	c1 e0 0c             	shl    $0xc,%eax
f010145e:	39 d0                	cmp    %edx,%eax
f0101460:	0f 83 73 02 00 00    	jae    f01016d9 <mem_init+0x459>
f0101466:	89 f8                	mov    %edi,%eax
f0101468:	29 c8                	sub    %ecx,%eax
f010146a:	c1 f8 03             	sar    $0x3,%eax
f010146d:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f0101470:	39 c2                	cmp    %eax,%edx
f0101472:	0f 86 83 02 00 00    	jbe    f01016fb <mem_init+0x47b>
f0101478:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010147b:	29 c8                	sub    %ecx,%eax
f010147d:	c1 f8 03             	sar    $0x3,%eax
f0101480:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f0101483:	39 c2                	cmp    %eax,%edx
f0101485:	0f 86 92 02 00 00    	jbe    f010171d <mem_init+0x49d>
	fl = page_free_list;
f010148b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010148e:	8b 88 90 1f 00 00    	mov    0x1f90(%eax),%ecx
f0101494:	89 4d c8             	mov    %ecx,-0x38(%ebp)
	page_free_list = 0;
f0101497:	c7 80 90 1f 00 00 00 	movl   $0x0,0x1f90(%eax)
f010149e:	00 00 00 
	assert(!page_alloc(0));
f01014a1:	83 ec 0c             	sub    $0xc,%esp
f01014a4:	6a 00                	push   $0x0
f01014a6:	e8 69 fa ff ff       	call   f0100f14 <page_alloc>
f01014ab:	83 c4 10             	add    $0x10,%esp
f01014ae:	85 c0                	test   %eax,%eax
f01014b0:	0f 85 89 02 00 00    	jne    f010173f <mem_init+0x4bf>
	page_free(pp0);
f01014b6:	83 ec 0c             	sub    $0xc,%esp
f01014b9:	53                   	push   %ebx
f01014ba:	e8 dd fa ff ff       	call   f0100f9c <page_free>
	page_free(pp1);
f01014bf:	89 3c 24             	mov    %edi,(%esp)
f01014c2:	e8 d5 fa ff ff       	call   f0100f9c <page_free>
	page_free(pp2);
f01014c7:	83 c4 04             	add    $0x4,%esp
f01014ca:	ff 75 d0             	pushl  -0x30(%ebp)
f01014cd:	e8 ca fa ff ff       	call   f0100f9c <page_free>
	assert((pp0 = page_alloc(0)));
f01014d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01014d9:	e8 36 fa ff ff       	call   f0100f14 <page_alloc>
f01014de:	89 c7                	mov    %eax,%edi
f01014e0:	83 c4 10             	add    $0x10,%esp
f01014e3:	85 c0                	test   %eax,%eax
f01014e5:	0f 84 76 02 00 00    	je     f0101761 <mem_init+0x4e1>
	assert((pp1 = page_alloc(0)));
f01014eb:	83 ec 0c             	sub    $0xc,%esp
f01014ee:	6a 00                	push   $0x0
f01014f0:	e8 1f fa ff ff       	call   f0100f14 <page_alloc>
f01014f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01014f8:	83 c4 10             	add    $0x10,%esp
f01014fb:	85 c0                	test   %eax,%eax
f01014fd:	0f 84 80 02 00 00    	je     f0101783 <mem_init+0x503>
	assert((pp2 = page_alloc(0)));
f0101503:	83 ec 0c             	sub    $0xc,%esp
f0101506:	6a 00                	push   $0x0
f0101508:	e8 07 fa ff ff       	call   f0100f14 <page_alloc>
f010150d:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101510:	83 c4 10             	add    $0x10,%esp
f0101513:	85 c0                	test   %eax,%eax
f0101515:	0f 84 8a 02 00 00    	je     f01017a5 <mem_init+0x525>
	assert(pp1 && pp1 != pp0);
f010151b:	3b 7d d0             	cmp    -0x30(%ebp),%edi
f010151e:	0f 84 a3 02 00 00    	je     f01017c7 <mem_init+0x547>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101524:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101527:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f010152a:	0f 84 b9 02 00 00    	je     f01017e9 <mem_init+0x569>
f0101530:	39 c7                	cmp    %eax,%edi
f0101532:	0f 84 b1 02 00 00    	je     f01017e9 <mem_init+0x569>
	assert(!page_alloc(0));
f0101538:	83 ec 0c             	sub    $0xc,%esp
f010153b:	6a 00                	push   $0x0
f010153d:	e8 d2 f9 ff ff       	call   f0100f14 <page_alloc>
f0101542:	83 c4 10             	add    $0x10,%esp
f0101545:	85 c0                	test   %eax,%eax
f0101547:	0f 85 be 02 00 00    	jne    f010180b <mem_init+0x58b>
f010154d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101550:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0101556:	89 f9                	mov    %edi,%ecx
f0101558:	2b 08                	sub    (%eax),%ecx
f010155a:	89 c8                	mov    %ecx,%eax
f010155c:	c1 f8 03             	sar    $0x3,%eax
f010155f:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101562:	89 c1                	mov    %eax,%ecx
f0101564:	c1 e9 0c             	shr    $0xc,%ecx
f0101567:	c7 c2 c8 96 11 f0    	mov    $0xf01196c8,%edx
f010156d:	3b 0a                	cmp    (%edx),%ecx
f010156f:	0f 83 b8 02 00 00    	jae    f010182d <mem_init+0x5ad>
	memset(page2kva(pp0), 1, PGSIZE);
f0101575:	83 ec 04             	sub    $0x4,%esp
f0101578:	68 00 10 00 00       	push   $0x1000
f010157d:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f010157f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101584:	50                   	push   %eax
f0101585:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101588:	e8 ed 25 00 00       	call   f0103b7a <memset>
	page_free(pp0);
f010158d:	89 3c 24             	mov    %edi,(%esp)
f0101590:	e8 07 fa ff ff       	call   f0100f9c <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101595:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010159c:	e8 73 f9 ff ff       	call   f0100f14 <page_alloc>
f01015a1:	83 c4 10             	add    $0x10,%esp
f01015a4:	85 c0                	test   %eax,%eax
f01015a6:	0f 84 97 02 00 00    	je     f0101843 <mem_init+0x5c3>
	assert(pp && pp0 == pp);
f01015ac:	39 c7                	cmp    %eax,%edi
f01015ae:	0f 85 b1 02 00 00    	jne    f0101865 <mem_init+0x5e5>
	return (pp - pages) << PGSHIFT;
f01015b4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01015b7:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f01015bd:	89 fa                	mov    %edi,%edx
f01015bf:	2b 10                	sub    (%eax),%edx
f01015c1:	c1 fa 03             	sar    $0x3,%edx
f01015c4:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01015c7:	89 d1                	mov    %edx,%ecx
f01015c9:	c1 e9 0c             	shr    $0xc,%ecx
f01015cc:	c7 c0 c8 96 11 f0    	mov    $0xf01196c8,%eax
f01015d2:	3b 08                	cmp    (%eax),%ecx
f01015d4:	0f 83 ad 02 00 00    	jae    f0101887 <mem_init+0x607>
	return (void *)(pa + KERNBASE);
f01015da:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f01015e0:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f01015e6:	80 38 00             	cmpb   $0x0,(%eax)
f01015e9:	0f 85 ae 02 00 00    	jne    f010189d <mem_init+0x61d>
f01015ef:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f01015f2:	39 d0                	cmp    %edx,%eax
f01015f4:	75 f0                	jne    f01015e6 <mem_init+0x366>
	page_free_list = fl;
f01015f6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01015f9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01015fc:	89 8b 90 1f 00 00    	mov    %ecx,0x1f90(%ebx)
	page_free(pp0);
f0101602:	83 ec 0c             	sub    $0xc,%esp
f0101605:	57                   	push   %edi
f0101606:	e8 91 f9 ff ff       	call   f0100f9c <page_free>
	page_free(pp1);
f010160b:	83 c4 04             	add    $0x4,%esp
f010160e:	ff 75 d0             	pushl  -0x30(%ebp)
f0101611:	e8 86 f9 ff ff       	call   f0100f9c <page_free>
	page_free(pp2);
f0101616:	83 c4 04             	add    $0x4,%esp
f0101619:	ff 75 cc             	pushl  -0x34(%ebp)
f010161c:	e8 7b f9 ff ff       	call   f0100f9c <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101621:	8b 83 90 1f 00 00    	mov    0x1f90(%ebx),%eax
f0101627:	83 c4 10             	add    $0x10,%esp
f010162a:	e9 95 02 00 00       	jmp    f01018c4 <mem_init+0x644>
	assert((pp0 = page_alloc(0)));
f010162f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101632:	8d 83 1a d2 fe ff    	lea    -0x12de6(%ebx),%eax
f0101638:	50                   	push   %eax
f0101639:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010163f:	50                   	push   %eax
f0101640:	68 63 02 00 00       	push   $0x263
f0101645:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010164b:	50                   	push   %eax
f010164c:	e8 48 ea ff ff       	call   f0100099 <_panic>
	assert((pp1 = page_alloc(0)));
f0101651:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101654:	8d 83 30 d2 fe ff    	lea    -0x12dd0(%ebx),%eax
f010165a:	50                   	push   %eax
f010165b:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0101661:	50                   	push   %eax
f0101662:	68 64 02 00 00       	push   $0x264
f0101667:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010166d:	50                   	push   %eax
f010166e:	e8 26 ea ff ff       	call   f0100099 <_panic>
	assert((pp2 = page_alloc(0)));
f0101673:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101676:	8d 83 46 d2 fe ff    	lea    -0x12dba(%ebx),%eax
f010167c:	50                   	push   %eax
f010167d:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0101683:	50                   	push   %eax
f0101684:	68 65 02 00 00       	push   $0x265
f0101689:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010168f:	50                   	push   %eax
f0101690:	e8 04 ea ff ff       	call   f0100099 <_panic>
	assert(pp1 && pp1 != pp0);
f0101695:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101698:	8d 83 5c d2 fe ff    	lea    -0x12da4(%ebx),%eax
f010169e:	50                   	push   %eax
f010169f:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01016a5:	50                   	push   %eax
f01016a6:	68 68 02 00 00       	push   $0x268
f01016ab:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01016b1:	50                   	push   %eax
f01016b2:	e8 e2 e9 ff ff       	call   f0100099 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01016b7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01016ba:	8d 83 b8 d5 fe ff    	lea    -0x12a48(%ebx),%eax
f01016c0:	50                   	push   %eax
f01016c1:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01016c7:	50                   	push   %eax
f01016c8:	68 69 02 00 00       	push   $0x269
f01016cd:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01016d3:	50                   	push   %eax
f01016d4:	e8 c0 e9 ff ff       	call   f0100099 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f01016d9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01016dc:	8d 83 6e d2 fe ff    	lea    -0x12d92(%ebx),%eax
f01016e2:	50                   	push   %eax
f01016e3:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01016e9:	50                   	push   %eax
f01016ea:	68 6a 02 00 00       	push   $0x26a
f01016ef:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01016f5:	50                   	push   %eax
f01016f6:	e8 9e e9 ff ff       	call   f0100099 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f01016fb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01016fe:	8d 83 8b d2 fe ff    	lea    -0x12d75(%ebx),%eax
f0101704:	50                   	push   %eax
f0101705:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010170b:	50                   	push   %eax
f010170c:	68 6b 02 00 00       	push   $0x26b
f0101711:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0101717:	50                   	push   %eax
f0101718:	e8 7c e9 ff ff       	call   f0100099 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f010171d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101720:	8d 83 a8 d2 fe ff    	lea    -0x12d58(%ebx),%eax
f0101726:	50                   	push   %eax
f0101727:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010172d:	50                   	push   %eax
f010172e:	68 6c 02 00 00       	push   $0x26c
f0101733:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0101739:	50                   	push   %eax
f010173a:	e8 5a e9 ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f010173f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101742:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0101748:	50                   	push   %eax
f0101749:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010174f:	50                   	push   %eax
f0101750:	68 73 02 00 00       	push   $0x273
f0101755:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010175b:	50                   	push   %eax
f010175c:	e8 38 e9 ff ff       	call   f0100099 <_panic>
	assert((pp0 = page_alloc(0)));
f0101761:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101764:	8d 83 1a d2 fe ff    	lea    -0x12de6(%ebx),%eax
f010176a:	50                   	push   %eax
f010176b:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0101771:	50                   	push   %eax
f0101772:	68 7a 02 00 00       	push   $0x27a
f0101777:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010177d:	50                   	push   %eax
f010177e:	e8 16 e9 ff ff       	call   f0100099 <_panic>
	assert((pp1 = page_alloc(0)));
f0101783:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101786:	8d 83 30 d2 fe ff    	lea    -0x12dd0(%ebx),%eax
f010178c:	50                   	push   %eax
f010178d:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0101793:	50                   	push   %eax
f0101794:	68 7b 02 00 00       	push   $0x27b
f0101799:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010179f:	50                   	push   %eax
f01017a0:	e8 f4 e8 ff ff       	call   f0100099 <_panic>
	assert((pp2 = page_alloc(0)));
f01017a5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01017a8:	8d 83 46 d2 fe ff    	lea    -0x12dba(%ebx),%eax
f01017ae:	50                   	push   %eax
f01017af:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01017b5:	50                   	push   %eax
f01017b6:	68 7c 02 00 00       	push   $0x27c
f01017bb:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01017c1:	50                   	push   %eax
f01017c2:	e8 d2 e8 ff ff       	call   f0100099 <_panic>
	assert(pp1 && pp1 != pp0);
f01017c7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01017ca:	8d 83 5c d2 fe ff    	lea    -0x12da4(%ebx),%eax
f01017d0:	50                   	push   %eax
f01017d1:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01017d7:	50                   	push   %eax
f01017d8:	68 7e 02 00 00       	push   $0x27e
f01017dd:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01017e3:	50                   	push   %eax
f01017e4:	e8 b0 e8 ff ff       	call   f0100099 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01017e9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01017ec:	8d 83 b8 d5 fe ff    	lea    -0x12a48(%ebx),%eax
f01017f2:	50                   	push   %eax
f01017f3:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01017f9:	50                   	push   %eax
f01017fa:	68 7f 02 00 00       	push   $0x27f
f01017ff:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0101805:	50                   	push   %eax
f0101806:	e8 8e e8 ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f010180b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010180e:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0101814:	50                   	push   %eax
f0101815:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010181b:	50                   	push   %eax
f010181c:	68 80 02 00 00       	push   $0x280
f0101821:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0101827:	50                   	push   %eax
f0101828:	e8 6c e8 ff ff       	call   f0100099 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010182d:	50                   	push   %eax
f010182e:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f0101834:	50                   	push   %eax
f0101835:	6a 52                	push   $0x52
f0101837:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f010183d:	50                   	push   %eax
f010183e:	e8 56 e8 ff ff       	call   f0100099 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101843:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101846:	8d 83 d4 d2 fe ff    	lea    -0x12d2c(%ebx),%eax
f010184c:	50                   	push   %eax
f010184d:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0101853:	50                   	push   %eax
f0101854:	68 85 02 00 00       	push   $0x285
f0101859:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010185f:	50                   	push   %eax
f0101860:	e8 34 e8 ff ff       	call   f0100099 <_panic>
	assert(pp && pp0 == pp);
f0101865:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101868:	8d 83 f2 d2 fe ff    	lea    -0x12d0e(%ebx),%eax
f010186e:	50                   	push   %eax
f010186f:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0101875:	50                   	push   %eax
f0101876:	68 86 02 00 00       	push   $0x286
f010187b:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0101881:	50                   	push   %eax
f0101882:	e8 12 e8 ff ff       	call   f0100099 <_panic>
f0101887:	52                   	push   %edx
f0101888:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f010188e:	50                   	push   %eax
f010188f:	6a 52                	push   $0x52
f0101891:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f0101897:	50                   	push   %eax
f0101898:	e8 fc e7 ff ff       	call   f0100099 <_panic>
		assert(c[i] == 0);
f010189d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01018a0:	8d 83 02 d3 fe ff    	lea    -0x12cfe(%ebx),%eax
f01018a6:	50                   	push   %eax
f01018a7:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01018ad:	50                   	push   %eax
f01018ae:	68 89 02 00 00       	push   $0x289
f01018b3:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01018b9:	50                   	push   %eax
f01018ba:	e8 da e7 ff ff       	call   f0100099 <_panic>
		--nfree;
f01018bf:	83 ee 01             	sub    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01018c2:	8b 00                	mov    (%eax),%eax
f01018c4:	85 c0                	test   %eax,%eax
f01018c6:	75 f7                	jne    f01018bf <mem_init+0x63f>
	assert(nfree == 0);
f01018c8:	85 f6                	test   %esi,%esi
f01018ca:	0f 85 55 08 00 00    	jne    f0102125 <mem_init+0xea5>
	cprintf("check_page_alloc() succeeded!\n");
f01018d0:	83 ec 0c             	sub    $0xc,%esp
f01018d3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01018d6:	8d 83 d8 d5 fe ff    	lea    -0x12a28(%ebx),%eax
f01018dc:	50                   	push   %eax
f01018dd:	e8 3c 17 00 00       	call   f010301e <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01018e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01018e9:	e8 26 f6 ff ff       	call   f0100f14 <page_alloc>
f01018ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01018f1:	83 c4 10             	add    $0x10,%esp
f01018f4:	85 c0                	test   %eax,%eax
f01018f6:	0f 84 4b 08 00 00    	je     f0102147 <mem_init+0xec7>
	assert((pp1 = page_alloc(0)));
f01018fc:	83 ec 0c             	sub    $0xc,%esp
f01018ff:	6a 00                	push   $0x0
f0101901:	e8 0e f6 ff ff       	call   f0100f14 <page_alloc>
f0101906:	89 c7                	mov    %eax,%edi
f0101908:	83 c4 10             	add    $0x10,%esp
f010190b:	85 c0                	test   %eax,%eax
f010190d:	0f 84 56 08 00 00    	je     f0102169 <mem_init+0xee9>
	assert((pp2 = page_alloc(0)));
f0101913:	83 ec 0c             	sub    $0xc,%esp
f0101916:	6a 00                	push   $0x0
f0101918:	e8 f7 f5 ff ff       	call   f0100f14 <page_alloc>
f010191d:	89 c6                	mov    %eax,%esi
f010191f:	83 c4 10             	add    $0x10,%esp
f0101922:	85 c0                	test   %eax,%eax
f0101924:	0f 84 61 08 00 00    	je     f010218b <mem_init+0xf0b>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f010192a:	39 7d d0             	cmp    %edi,-0x30(%ebp)
f010192d:	0f 84 7a 08 00 00    	je     f01021ad <mem_init+0xf2d>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101933:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101936:	0f 84 93 08 00 00    	je     f01021cf <mem_init+0xf4f>
f010193c:	39 c7                	cmp    %eax,%edi
f010193e:	0f 84 8b 08 00 00    	je     f01021cf <mem_init+0xf4f>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101947:	8b 88 90 1f 00 00    	mov    0x1f90(%eax),%ecx
f010194d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
	page_free_list = 0;
f0101950:	c7 80 90 1f 00 00 00 	movl   $0x0,0x1f90(%eax)
f0101957:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f010195a:	83 ec 0c             	sub    $0xc,%esp
f010195d:	6a 00                	push   $0x0
f010195f:	e8 b0 f5 ff ff       	call   f0100f14 <page_alloc>
f0101964:	83 c4 10             	add    $0x10,%esp
f0101967:	85 c0                	test   %eax,%eax
f0101969:	0f 85 82 08 00 00    	jne    f01021f1 <mem_init+0xf71>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f010196f:	83 ec 04             	sub    $0x4,%esp
f0101972:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101975:	50                   	push   %eax
f0101976:	6a 00                	push   $0x0
f0101978:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010197b:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101981:	ff 30                	pushl  (%eax)
f0101983:	e8 ac f7 ff ff       	call   f0101134 <page_lookup>
f0101988:	83 c4 10             	add    $0x10,%esp
f010198b:	85 c0                	test   %eax,%eax
f010198d:	0f 85 80 08 00 00    	jne    f0102213 <mem_init+0xf93>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101993:	6a 02                	push   $0x2
f0101995:	6a 00                	push   $0x0
f0101997:	57                   	push   %edi
f0101998:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010199b:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f01019a1:	ff 30                	pushl  (%eax)
f01019a3:	e8 4c f8 ff ff       	call   f01011f4 <page_insert>
f01019a8:	83 c4 10             	add    $0x10,%esp
f01019ab:	85 c0                	test   %eax,%eax
f01019ad:	0f 89 82 08 00 00    	jns    f0102235 <mem_init+0xfb5>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f01019b3:	83 ec 0c             	sub    $0xc,%esp
f01019b6:	ff 75 d0             	pushl  -0x30(%ebp)
f01019b9:	e8 de f5 ff ff       	call   f0100f9c <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01019be:	6a 02                	push   $0x2
f01019c0:	6a 00                	push   $0x0
f01019c2:	57                   	push   %edi
f01019c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019c6:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f01019cc:	ff 30                	pushl  (%eax)
f01019ce:	e8 21 f8 ff ff       	call   f01011f4 <page_insert>
f01019d3:	83 c4 20             	add    $0x20,%esp
f01019d6:	85 c0                	test   %eax,%eax
f01019d8:	0f 85 79 08 00 00    	jne    f0102257 <mem_init+0xfd7>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01019de:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01019e1:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f01019e7:	8b 18                	mov    (%eax),%ebx
	return (pp - pages) << PGSHIFT;
f01019e9:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f01019ef:	8b 08                	mov    (%eax),%ecx
f01019f1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f01019f4:	8b 13                	mov    (%ebx),%edx
f01019f6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01019fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01019ff:	29 c8                	sub    %ecx,%eax
f0101a01:	c1 f8 03             	sar    $0x3,%eax
f0101a04:	c1 e0 0c             	shl    $0xc,%eax
f0101a07:	39 c2                	cmp    %eax,%edx
f0101a09:	0f 85 6a 08 00 00    	jne    f0102279 <mem_init+0xff9>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101a0f:	ba 00 00 00 00       	mov    $0x0,%edx
f0101a14:	89 d8                	mov    %ebx,%eax
f0101a16:	e8 22 f0 ff ff       	call   f0100a3d <check_va2pa>
f0101a1b:	89 fa                	mov    %edi,%edx
f0101a1d:	2b 55 cc             	sub    -0x34(%ebp),%edx
f0101a20:	c1 fa 03             	sar    $0x3,%edx
f0101a23:	c1 e2 0c             	shl    $0xc,%edx
f0101a26:	39 d0                	cmp    %edx,%eax
f0101a28:	0f 85 6d 08 00 00    	jne    f010229b <mem_init+0x101b>
	assert(pp1->pp_ref == 1);
f0101a2e:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101a33:	0f 85 84 08 00 00    	jne    f01022bd <mem_init+0x103d>
	assert(pp0->pp_ref == 1);
f0101a39:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101a3c:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101a41:	0f 85 98 08 00 00    	jne    f01022df <mem_init+0x105f>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101a47:	6a 02                	push   $0x2
f0101a49:	68 00 10 00 00       	push   $0x1000
f0101a4e:	56                   	push   %esi
f0101a4f:	53                   	push   %ebx
f0101a50:	e8 9f f7 ff ff       	call   f01011f4 <page_insert>
f0101a55:	83 c4 10             	add    $0x10,%esp
f0101a58:	85 c0                	test   %eax,%eax
f0101a5a:	0f 85 a1 08 00 00    	jne    f0102301 <mem_init+0x1081>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101a60:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101a65:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101a68:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101a6e:	8b 00                	mov    (%eax),%eax
f0101a70:	e8 c8 ef ff ff       	call   f0100a3d <check_va2pa>
f0101a75:	c7 c2 d0 96 11 f0    	mov    $0xf01196d0,%edx
f0101a7b:	89 f1                	mov    %esi,%ecx
f0101a7d:	2b 0a                	sub    (%edx),%ecx
f0101a7f:	89 ca                	mov    %ecx,%edx
f0101a81:	c1 fa 03             	sar    $0x3,%edx
f0101a84:	c1 e2 0c             	shl    $0xc,%edx
f0101a87:	39 d0                	cmp    %edx,%eax
f0101a89:	0f 85 94 08 00 00    	jne    f0102323 <mem_init+0x10a3>
	assert(pp2->pp_ref == 1);
f0101a8f:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101a94:	0f 85 ab 08 00 00    	jne    f0102345 <mem_init+0x10c5>

	// should be no free memory
	assert(!page_alloc(0));
f0101a9a:	83 ec 0c             	sub    $0xc,%esp
f0101a9d:	6a 00                	push   $0x0
f0101a9f:	e8 70 f4 ff ff       	call   f0100f14 <page_alloc>
f0101aa4:	83 c4 10             	add    $0x10,%esp
f0101aa7:	85 c0                	test   %eax,%eax
f0101aa9:	0f 85 b8 08 00 00    	jne    f0102367 <mem_init+0x10e7>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101aaf:	6a 02                	push   $0x2
f0101ab1:	68 00 10 00 00       	push   $0x1000
f0101ab6:	56                   	push   %esi
f0101ab7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101aba:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101ac0:	ff 30                	pushl  (%eax)
f0101ac2:	e8 2d f7 ff ff       	call   f01011f4 <page_insert>
f0101ac7:	83 c4 10             	add    $0x10,%esp
f0101aca:	85 c0                	test   %eax,%eax
f0101acc:	0f 85 b7 08 00 00    	jne    f0102389 <mem_init+0x1109>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101ad2:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ad7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101ada:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101ae0:	8b 00                	mov    (%eax),%eax
f0101ae2:	e8 56 ef ff ff       	call   f0100a3d <check_va2pa>
f0101ae7:	c7 c2 d0 96 11 f0    	mov    $0xf01196d0,%edx
f0101aed:	89 f1                	mov    %esi,%ecx
f0101aef:	2b 0a                	sub    (%edx),%ecx
f0101af1:	89 ca                	mov    %ecx,%edx
f0101af3:	c1 fa 03             	sar    $0x3,%edx
f0101af6:	c1 e2 0c             	shl    $0xc,%edx
f0101af9:	39 d0                	cmp    %edx,%eax
f0101afb:	0f 85 aa 08 00 00    	jne    f01023ab <mem_init+0x112b>
	//cprintf("check_page: %d %u pp1=%u pp0=%u\n", pp2->pp_ref, pp2, pp1, pp0);
	assert(pp2->pp_ref == 1);
f0101b01:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101b06:	0f 85 c1 08 00 00    	jne    f01023cd <mem_init+0x114d>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101b0c:	83 ec 0c             	sub    $0xc,%esp
f0101b0f:	6a 00                	push   $0x0
f0101b11:	e8 fe f3 ff ff       	call   f0100f14 <page_alloc>
f0101b16:	83 c4 10             	add    $0x10,%esp
f0101b19:	85 c0                	test   %eax,%eax
f0101b1b:	0f 85 ce 08 00 00    	jne    f01023ef <mem_init+0x116f>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101b21:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101b24:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101b2a:	8b 10                	mov    (%eax),%edx
f0101b2c:	8b 02                	mov    (%edx),%eax
f0101b2e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101b33:	89 c3                	mov    %eax,%ebx
f0101b35:	c1 eb 0c             	shr    $0xc,%ebx
f0101b38:	c7 c1 c8 96 11 f0    	mov    $0xf01196c8,%ecx
f0101b3e:	3b 19                	cmp    (%ecx),%ebx
f0101b40:	0f 83 cb 08 00 00    	jae    f0102411 <mem_init+0x1191>
	return (void *)(pa + KERNBASE);
f0101b46:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101b4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101b4e:	83 ec 04             	sub    $0x4,%esp
f0101b51:	6a 00                	push   $0x0
f0101b53:	68 00 10 00 00       	push   $0x1000
f0101b58:	52                   	push   %edx
f0101b59:	e8 d9 f4 ff ff       	call   f0101037 <pgdir_walk>
f0101b5e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101b61:	8d 51 04             	lea    0x4(%ecx),%edx
f0101b64:	83 c4 10             	add    $0x10,%esp
f0101b67:	39 d0                	cmp    %edx,%eax
f0101b69:	0f 85 be 08 00 00    	jne    f010242d <mem_init+0x11ad>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101b6f:	6a 06                	push   $0x6
f0101b71:	68 00 10 00 00       	push   $0x1000
f0101b76:	56                   	push   %esi
f0101b77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101b7a:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101b80:	ff 30                	pushl  (%eax)
f0101b82:	e8 6d f6 ff ff       	call   f01011f4 <page_insert>
f0101b87:	83 c4 10             	add    $0x10,%esp
f0101b8a:	85 c0                	test   %eax,%eax
f0101b8c:	0f 85 bd 08 00 00    	jne    f010244f <mem_init+0x11cf>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101b95:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101b9b:	8b 18                	mov    (%eax),%ebx
f0101b9d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ba2:	89 d8                	mov    %ebx,%eax
f0101ba4:	e8 94 ee ff ff       	call   f0100a3d <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101ba9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101bac:	c7 c2 d0 96 11 f0    	mov    $0xf01196d0,%edx
f0101bb2:	89 f1                	mov    %esi,%ecx
f0101bb4:	2b 0a                	sub    (%edx),%ecx
f0101bb6:	89 ca                	mov    %ecx,%edx
f0101bb8:	c1 fa 03             	sar    $0x3,%edx
f0101bbb:	c1 e2 0c             	shl    $0xc,%edx
f0101bbe:	39 d0                	cmp    %edx,%eax
f0101bc0:	0f 85 ab 08 00 00    	jne    f0102471 <mem_init+0x11f1>
	assert(pp2->pp_ref == 1);
f0101bc6:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101bcb:	0f 85 c2 08 00 00    	jne    f0102493 <mem_init+0x1213>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101bd1:	83 ec 04             	sub    $0x4,%esp
f0101bd4:	6a 00                	push   $0x0
f0101bd6:	68 00 10 00 00       	push   $0x1000
f0101bdb:	53                   	push   %ebx
f0101bdc:	e8 56 f4 ff ff       	call   f0101037 <pgdir_walk>
f0101be1:	83 c4 10             	add    $0x10,%esp
f0101be4:	f6 00 04             	testb  $0x4,(%eax)
f0101be7:	0f 84 c8 08 00 00    	je     f01024b5 <mem_init+0x1235>
	assert(kern_pgdir[0] & PTE_U);
f0101bed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101bf0:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101bf6:	8b 00                	mov    (%eax),%eax
f0101bf8:	f6 00 04             	testb  $0x4,(%eax)
f0101bfb:	0f 84 d6 08 00 00    	je     f01024d7 <mem_init+0x1257>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101c01:	6a 02                	push   $0x2
f0101c03:	68 00 10 00 00       	push   $0x1000
f0101c08:	56                   	push   %esi
f0101c09:	50                   	push   %eax
f0101c0a:	e8 e5 f5 ff ff       	call   f01011f4 <page_insert>
f0101c0f:	83 c4 10             	add    $0x10,%esp
f0101c12:	85 c0                	test   %eax,%eax
f0101c14:	0f 85 df 08 00 00    	jne    f01024f9 <mem_init+0x1279>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101c1a:	83 ec 04             	sub    $0x4,%esp
f0101c1d:	6a 00                	push   $0x0
f0101c1f:	68 00 10 00 00       	push   $0x1000
f0101c24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c27:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101c2d:	ff 30                	pushl  (%eax)
f0101c2f:	e8 03 f4 ff ff       	call   f0101037 <pgdir_walk>
f0101c34:	83 c4 10             	add    $0x10,%esp
f0101c37:	f6 00 02             	testb  $0x2,(%eax)
f0101c3a:	0f 84 db 08 00 00    	je     f010251b <mem_init+0x129b>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101c40:	83 ec 04             	sub    $0x4,%esp
f0101c43:	6a 00                	push   $0x0
f0101c45:	68 00 10 00 00       	push   $0x1000
f0101c4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c4d:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101c53:	ff 30                	pushl  (%eax)
f0101c55:	e8 dd f3 ff ff       	call   f0101037 <pgdir_walk>
f0101c5a:	83 c4 10             	add    $0x10,%esp
f0101c5d:	f6 00 04             	testb  $0x4,(%eax)
f0101c60:	0f 85 d7 08 00 00    	jne    f010253d <mem_init+0x12bd>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101c66:	6a 02                	push   $0x2
f0101c68:	68 00 00 40 00       	push   $0x400000
f0101c6d:	ff 75 d0             	pushl  -0x30(%ebp)
f0101c70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c73:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101c79:	ff 30                	pushl  (%eax)
f0101c7b:	e8 74 f5 ff ff       	call   f01011f4 <page_insert>
f0101c80:	83 c4 10             	add    $0x10,%esp
f0101c83:	85 c0                	test   %eax,%eax
f0101c85:	0f 89 d4 08 00 00    	jns    f010255f <mem_init+0x12df>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101c8b:	6a 02                	push   $0x2
f0101c8d:	68 00 10 00 00       	push   $0x1000
f0101c92:	57                   	push   %edi
f0101c93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c96:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101c9c:	ff 30                	pushl  (%eax)
f0101c9e:	e8 51 f5 ff ff       	call   f01011f4 <page_insert>
f0101ca3:	83 c4 10             	add    $0x10,%esp
f0101ca6:	85 c0                	test   %eax,%eax
f0101ca8:	0f 85 d3 08 00 00    	jne    f0102581 <mem_init+0x1301>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101cae:	83 ec 04             	sub    $0x4,%esp
f0101cb1:	6a 00                	push   $0x0
f0101cb3:	68 00 10 00 00       	push   $0x1000
f0101cb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101cbb:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101cc1:	ff 30                	pushl  (%eax)
f0101cc3:	e8 6f f3 ff ff       	call   f0101037 <pgdir_walk>
f0101cc8:	83 c4 10             	add    $0x10,%esp
f0101ccb:	f6 00 04             	testb  $0x4,(%eax)
f0101cce:	0f 85 cf 08 00 00    	jne    f01025a3 <mem_init+0x1323>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101cd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101cd7:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101cdd:	8b 18                	mov    (%eax),%ebx
f0101cdf:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ce4:	89 d8                	mov    %ebx,%eax
f0101ce6:	e8 52 ed ff ff       	call   f0100a3d <check_va2pa>
f0101ceb:	89 c2                	mov    %eax,%edx
f0101ced:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101cf0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101cf3:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0101cf9:	89 f9                	mov    %edi,%ecx
f0101cfb:	2b 08                	sub    (%eax),%ecx
f0101cfd:	89 c8                	mov    %ecx,%eax
f0101cff:	c1 f8 03             	sar    $0x3,%eax
f0101d02:	c1 e0 0c             	shl    $0xc,%eax
f0101d05:	39 c2                	cmp    %eax,%edx
f0101d07:	0f 85 b8 08 00 00    	jne    f01025c5 <mem_init+0x1345>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d0d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d12:	89 d8                	mov    %ebx,%eax
f0101d14:	e8 24 ed ff ff       	call   f0100a3d <check_va2pa>
f0101d19:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0101d1c:	0f 85 c5 08 00 00    	jne    f01025e7 <mem_init+0x1367>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101d22:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0101d27:	0f 85 dc 08 00 00    	jne    f0102609 <mem_init+0x1389>
	assert(pp2->pp_ref == 0);
f0101d2d:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101d32:	0f 85 f3 08 00 00    	jne    f010262b <mem_init+0x13ab>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101d38:	83 ec 0c             	sub    $0xc,%esp
f0101d3b:	6a 00                	push   $0x0
f0101d3d:	e8 d2 f1 ff ff       	call   f0100f14 <page_alloc>
f0101d42:	83 c4 10             	add    $0x10,%esp
f0101d45:	39 c6                	cmp    %eax,%esi
f0101d47:	0f 85 00 09 00 00    	jne    f010264d <mem_init+0x13cd>
f0101d4d:	85 c0                	test   %eax,%eax
f0101d4f:	0f 84 f8 08 00 00    	je     f010264d <mem_init+0x13cd>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101d55:	83 ec 08             	sub    $0x8,%esp
f0101d58:	6a 00                	push   $0x0
f0101d5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d5d:	c7 c3 cc 96 11 f0    	mov    $0xf01196cc,%ebx
f0101d63:	ff 33                	pushl  (%ebx)
f0101d65:	e8 3a f4 ff ff       	call   f01011a4 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101d6a:	8b 1b                	mov    (%ebx),%ebx
f0101d6c:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d71:	89 d8                	mov    %ebx,%eax
f0101d73:	e8 c5 ec ff ff       	call   f0100a3d <check_va2pa>
f0101d78:	83 c4 10             	add    $0x10,%esp
f0101d7b:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d7e:	0f 85 eb 08 00 00    	jne    f010266f <mem_init+0x13ef>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d84:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d89:	89 d8                	mov    %ebx,%eax
f0101d8b:	e8 ad ec ff ff       	call   f0100a3d <check_va2pa>
f0101d90:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101d93:	c7 c2 d0 96 11 f0    	mov    $0xf01196d0,%edx
f0101d99:	89 f9                	mov    %edi,%ecx
f0101d9b:	2b 0a                	sub    (%edx),%ecx
f0101d9d:	89 ca                	mov    %ecx,%edx
f0101d9f:	c1 fa 03             	sar    $0x3,%edx
f0101da2:	c1 e2 0c             	shl    $0xc,%edx
f0101da5:	39 d0                	cmp    %edx,%eax
f0101da7:	0f 85 e4 08 00 00    	jne    f0102691 <mem_init+0x1411>
	assert(pp1->pp_ref == 1);
f0101dad:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101db2:	0f 85 fb 08 00 00    	jne    f01026b3 <mem_init+0x1433>
	assert(pp2->pp_ref == 0);
f0101db8:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101dbd:	0f 85 12 09 00 00    	jne    f01026d5 <mem_init+0x1455>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101dc3:	6a 00                	push   $0x0
f0101dc5:	68 00 10 00 00       	push   $0x1000
f0101dca:	57                   	push   %edi
f0101dcb:	53                   	push   %ebx
f0101dcc:	e8 23 f4 ff ff       	call   f01011f4 <page_insert>
f0101dd1:	83 c4 10             	add    $0x10,%esp
f0101dd4:	85 c0                	test   %eax,%eax
f0101dd6:	0f 85 1b 09 00 00    	jne    f01026f7 <mem_init+0x1477>
	assert(pp1->pp_ref);
f0101ddc:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101de1:	0f 84 32 09 00 00    	je     f0102719 <mem_init+0x1499>
	assert(pp1->pp_link == NULL);
f0101de7:	83 3f 00             	cmpl   $0x0,(%edi)
f0101dea:	0f 85 4b 09 00 00    	jne    f010273b <mem_init+0x14bb>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101df0:	83 ec 08             	sub    $0x8,%esp
f0101df3:	68 00 10 00 00       	push   $0x1000
f0101df8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101dfb:	c7 c3 cc 96 11 f0    	mov    $0xf01196cc,%ebx
f0101e01:	ff 33                	pushl  (%ebx)
f0101e03:	e8 9c f3 ff ff       	call   f01011a4 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101e08:	8b 1b                	mov    (%ebx),%ebx
f0101e0a:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e0f:	89 d8                	mov    %ebx,%eax
f0101e11:	e8 27 ec ff ff       	call   f0100a3d <check_va2pa>
f0101e16:	83 c4 10             	add    $0x10,%esp
f0101e19:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e1c:	0f 85 3b 09 00 00    	jne    f010275d <mem_init+0x14dd>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101e22:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e27:	89 d8                	mov    %ebx,%eax
f0101e29:	e8 0f ec ff ff       	call   f0100a3d <check_va2pa>
f0101e2e:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e31:	0f 85 48 09 00 00    	jne    f010277f <mem_init+0x14ff>
	assert(pp1->pp_ref == 0);
f0101e37:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101e3c:	0f 85 5f 09 00 00    	jne    f01027a1 <mem_init+0x1521>
	assert(pp2->pp_ref == 0);
f0101e42:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101e47:	0f 85 76 09 00 00    	jne    f01027c3 <mem_init+0x1543>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101e4d:	83 ec 0c             	sub    $0xc,%esp
f0101e50:	6a 00                	push   $0x0
f0101e52:	e8 bd f0 ff ff       	call   f0100f14 <page_alloc>
f0101e57:	83 c4 10             	add    $0x10,%esp
f0101e5a:	85 c0                	test   %eax,%eax
f0101e5c:	0f 84 83 09 00 00    	je     f01027e5 <mem_init+0x1565>
f0101e62:	39 c7                	cmp    %eax,%edi
f0101e64:	0f 85 7b 09 00 00    	jne    f01027e5 <mem_init+0x1565>

	// should be no free memory
	assert(!page_alloc(0));
f0101e6a:	83 ec 0c             	sub    $0xc,%esp
f0101e6d:	6a 00                	push   $0x0
f0101e6f:	e8 a0 f0 ff ff       	call   f0100f14 <page_alloc>
f0101e74:	83 c4 10             	add    $0x10,%esp
f0101e77:	85 c0                	test   %eax,%eax
f0101e79:	0f 85 88 09 00 00    	jne    f0102807 <mem_init+0x1587>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101e7f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101e82:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101e88:	8b 08                	mov    (%eax),%ecx
f0101e8a:	8b 11                	mov    (%ecx),%edx
f0101e8c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101e92:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0101e98:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0101e9b:	2b 18                	sub    (%eax),%ebx
f0101e9d:	89 d8                	mov    %ebx,%eax
f0101e9f:	c1 f8 03             	sar    $0x3,%eax
f0101ea2:	c1 e0 0c             	shl    $0xc,%eax
f0101ea5:	39 c2                	cmp    %eax,%edx
f0101ea7:	0f 85 7c 09 00 00    	jne    f0102829 <mem_init+0x15a9>
	kern_pgdir[0] = 0;
f0101ead:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101eb3:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101eb6:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101ebb:	0f 85 8a 09 00 00    	jne    f010284b <mem_init+0x15cb>
	pp0->pp_ref = 0;
f0101ec1:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101ec4:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101eca:	83 ec 0c             	sub    $0xc,%esp
f0101ecd:	50                   	push   %eax
f0101ece:	e8 c9 f0 ff ff       	call   f0100f9c <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101ed3:	83 c4 0c             	add    $0xc,%esp
f0101ed6:	6a 01                	push   $0x1
f0101ed8:	68 00 10 40 00       	push   $0x401000
f0101edd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ee0:	c7 c3 cc 96 11 f0    	mov    $0xf01196cc,%ebx
f0101ee6:	ff 33                	pushl  (%ebx)
f0101ee8:	e8 4a f1 ff ff       	call   f0101037 <pgdir_walk>
f0101eed:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101ef0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101ef3:	8b 1b                	mov    (%ebx),%ebx
f0101ef5:	8b 53 04             	mov    0x4(%ebx),%edx
f0101ef8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101efe:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101f01:	c7 c1 c8 96 11 f0    	mov    $0xf01196c8,%ecx
f0101f07:	8b 09                	mov    (%ecx),%ecx
f0101f09:	89 d0                	mov    %edx,%eax
f0101f0b:	c1 e8 0c             	shr    $0xc,%eax
f0101f0e:	83 c4 10             	add    $0x10,%esp
f0101f11:	39 c8                	cmp    %ecx,%eax
f0101f13:	0f 83 54 09 00 00    	jae    f010286d <mem_init+0x15ed>
	assert(ptep == ptep1 + PTX(va));
f0101f19:	81 ea fc ff ff 0f    	sub    $0xffffffc,%edx
f0101f1f:	39 55 cc             	cmp    %edx,-0x34(%ebp)
f0101f22:	0f 85 61 09 00 00    	jne    f0102889 <mem_init+0x1609>
	kern_pgdir[PDX(va)] = 0;
f0101f28:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	pp0->pp_ref = 0;
f0101f2f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0101f32:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
	return (pp - pages) << PGSHIFT;
f0101f38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f3b:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0101f41:	2b 18                	sub    (%eax),%ebx
f0101f43:	89 d8                	mov    %ebx,%eax
f0101f45:	c1 f8 03             	sar    $0x3,%eax
f0101f48:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101f4b:	89 c2                	mov    %eax,%edx
f0101f4d:	c1 ea 0c             	shr    $0xc,%edx
f0101f50:	39 d1                	cmp    %edx,%ecx
f0101f52:	0f 86 53 09 00 00    	jbe    f01028ab <mem_init+0x162b>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101f58:	83 ec 04             	sub    $0x4,%esp
f0101f5b:	68 00 10 00 00       	push   $0x1000
f0101f60:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101f65:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101f6a:	50                   	push   %eax
f0101f6b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101f6e:	e8 07 1c 00 00       	call   f0103b7a <memset>
	page_free(pp0);
f0101f73:	83 c4 04             	add    $0x4,%esp
f0101f76:	ff 75 d0             	pushl  -0x30(%ebp)
f0101f79:	e8 1e f0 ff ff       	call   f0100f9c <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101f7e:	83 c4 0c             	add    $0xc,%esp
f0101f81:	6a 01                	push   $0x1
f0101f83:	6a 00                	push   $0x0
f0101f85:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101f88:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101f8e:	ff 30                	pushl  (%eax)
f0101f90:	e8 a2 f0 ff ff       	call   f0101037 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101f95:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0101f9b:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0101f9e:	2b 10                	sub    (%eax),%edx
f0101fa0:	c1 fa 03             	sar    $0x3,%edx
f0101fa3:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101fa6:	89 d1                	mov    %edx,%ecx
f0101fa8:	c1 e9 0c             	shr    $0xc,%ecx
f0101fab:	83 c4 10             	add    $0x10,%esp
f0101fae:	c7 c0 c8 96 11 f0    	mov    $0xf01196c8,%eax
f0101fb4:	3b 08                	cmp    (%eax),%ecx
f0101fb6:	0f 83 08 09 00 00    	jae    f01028c4 <mem_init+0x1644>
	return (void *)(pa + KERNBASE);
f0101fbc:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0101fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101fc5:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0101fcb:	f6 00 01             	testb  $0x1,(%eax)
f0101fce:	0f 85 09 09 00 00    	jne    f01028dd <mem_init+0x165d>
f0101fd4:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f0101fd7:	39 d0                	cmp    %edx,%eax
f0101fd9:	75 f0                	jne    f0101fcb <mem_init+0xd4b>
	kern_pgdir[0] = 0;
f0101fdb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0101fde:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0101fe4:	8b 00                	mov    (%eax),%eax
f0101fe6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0101fec:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101fef:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0101ff5:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0101ff8:	89 93 90 1f 00 00    	mov    %edx,0x1f90(%ebx)

	// free the pages we took
	page_free(pp0);
f0101ffe:	83 ec 0c             	sub    $0xc,%esp
f0102001:	50                   	push   %eax
f0102002:	e8 95 ef ff ff       	call   f0100f9c <page_free>
	page_free(pp1);
f0102007:	89 3c 24             	mov    %edi,(%esp)
f010200a:	e8 8d ef ff ff       	call   f0100f9c <page_free>
	page_free(pp2);
f010200f:	89 34 24             	mov    %esi,(%esp)
f0102012:	e8 85 ef ff ff       	call   f0100f9c <page_free>

	cprintf("check_page() succeeded!\n");
f0102017:	8d 83 e3 d3 fe ff    	lea    -0x12c1d(%ebx),%eax
f010201d:	89 04 24             	mov    %eax,(%esp)
f0102020:	e8 f9 0f 00 00       	call   f010301e <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f0102025:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f010202b:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f010202d:	83 c4 10             	add    $0x10,%esp
f0102030:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102035:	0f 86 c4 08 00 00    	jbe    f01028ff <mem_init+0x167f>
f010203b:	83 ec 08             	sub    $0x8,%esp
f010203e:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102040:	05 00 00 00 10       	add    $0x10000000,%eax
f0102045:	50                   	push   %eax
f0102046:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010204b:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102050:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0102053:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0102059:	8b 00                	mov    (%eax),%eax
f010205b:	e8 82 f0 ff ff       	call   f01010e2 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102060:	c7 c0 00 e0 10 f0    	mov    $0xf010e000,%eax
f0102066:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0102069:	83 c4 10             	add    $0x10,%esp
f010206c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102071:	0f 86 a4 08 00 00    	jbe    f010291b <mem_init+0x169b>
	boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102077:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f010207a:	c7 c3 cc 96 11 f0    	mov    $0xf01196cc,%ebx
f0102080:	83 ec 08             	sub    $0x8,%esp
f0102083:	6a 02                	push   $0x2
	return (physaddr_t)kva - KERNBASE;
f0102085:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0102088:	05 00 00 00 10       	add    $0x10000000,%eax
f010208d:	50                   	push   %eax
f010208e:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102093:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102098:	8b 03                	mov    (%ebx),%eax
f010209a:	e8 43 f0 ff ff       	call   f01010e2 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff-KERNBASE, 0, PTE_W);
f010209f:	83 c4 08             	add    $0x8,%esp
f01020a2:	6a 02                	push   $0x2
f01020a4:	6a 00                	push   $0x0
f01020a6:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f01020ab:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01020b0:	8b 03                	mov    (%ebx),%eax
f01020b2:	e8 2b f0 ff ff       	call   f01010e2 <boot_map_region>
	pgdir = kern_pgdir;
f01020b7:	8b 33                	mov    (%ebx),%esi
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01020b9:	c7 c0 c8 96 11 f0    	mov    $0xf01196c8,%eax
f01020bf:	8b 00                	mov    (%eax),%eax
f01020c1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01020c4:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01020cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01020d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01020d3:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f01020d9:	8b 00                	mov    (%eax),%eax
f01020db:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if ((uint32_t)kva < KERNBASE)
f01020de:	89 45 cc             	mov    %eax,-0x34(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01020e1:	8d 98 00 00 00 10    	lea    0x10000000(%eax),%ebx
f01020e7:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < n; i += PGSIZE)
f01020ea:	bf 00 00 00 00       	mov    $0x0,%edi
f01020ef:	39 7d d0             	cmp    %edi,-0x30(%ebp)
f01020f2:	0f 86 84 08 00 00    	jbe    f010297c <mem_init+0x16fc>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01020f8:	8d 97 00 00 00 ef    	lea    -0x11000000(%edi),%edx
f01020fe:	89 f0                	mov    %esi,%eax
f0102100:	e8 38 e9 ff ff       	call   f0100a3d <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102105:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f010210c:	0f 86 2a 08 00 00    	jbe    f010293c <mem_init+0x16bc>
f0102112:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
f0102115:	39 c2                	cmp    %eax,%edx
f0102117:	0f 85 3d 08 00 00    	jne    f010295a <mem_init+0x16da>
	for (i = 0; i < n; i += PGSIZE)
f010211d:	81 c7 00 10 00 00    	add    $0x1000,%edi
f0102123:	eb ca                	jmp    f01020ef <mem_init+0xe6f>
	assert(nfree == 0);
f0102125:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102128:	8d 83 0c d3 fe ff    	lea    -0x12cf4(%ebx),%eax
f010212e:	50                   	push   %eax
f010212f:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102135:	50                   	push   %eax
f0102136:	68 96 02 00 00       	push   $0x296
f010213b:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102141:	50                   	push   %eax
f0102142:	e8 52 df ff ff       	call   f0100099 <_panic>
	assert((pp0 = page_alloc(0)));
f0102147:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010214a:	8d 83 1a d2 fe ff    	lea    -0x12de6(%ebx),%eax
f0102150:	50                   	push   %eax
f0102151:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102157:	50                   	push   %eax
f0102158:	68 ef 02 00 00       	push   $0x2ef
f010215d:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102163:	50                   	push   %eax
f0102164:	e8 30 df ff ff       	call   f0100099 <_panic>
	assert((pp1 = page_alloc(0)));
f0102169:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010216c:	8d 83 30 d2 fe ff    	lea    -0x12dd0(%ebx),%eax
f0102172:	50                   	push   %eax
f0102173:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102179:	50                   	push   %eax
f010217a:	68 f0 02 00 00       	push   $0x2f0
f010217f:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102185:	50                   	push   %eax
f0102186:	e8 0e df ff ff       	call   f0100099 <_panic>
	assert((pp2 = page_alloc(0)));
f010218b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010218e:	8d 83 46 d2 fe ff    	lea    -0x12dba(%ebx),%eax
f0102194:	50                   	push   %eax
f0102195:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010219b:	50                   	push   %eax
f010219c:	68 f1 02 00 00       	push   $0x2f1
f01021a1:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01021a7:	50                   	push   %eax
f01021a8:	e8 ec de ff ff       	call   f0100099 <_panic>
	assert(pp1 && pp1 != pp0);
f01021ad:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01021b0:	8d 83 5c d2 fe ff    	lea    -0x12da4(%ebx),%eax
f01021b6:	50                   	push   %eax
f01021b7:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01021bd:	50                   	push   %eax
f01021be:	68 f4 02 00 00       	push   $0x2f4
f01021c3:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01021c9:	50                   	push   %eax
f01021ca:	e8 ca de ff ff       	call   f0100099 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01021cf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01021d2:	8d 83 b8 d5 fe ff    	lea    -0x12a48(%ebx),%eax
f01021d8:	50                   	push   %eax
f01021d9:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01021df:	50                   	push   %eax
f01021e0:	68 f5 02 00 00       	push   $0x2f5
f01021e5:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01021eb:	50                   	push   %eax
f01021ec:	e8 a8 de ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f01021f1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01021f4:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01021fa:	50                   	push   %eax
f01021fb:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102201:	50                   	push   %eax
f0102202:	68 fc 02 00 00       	push   $0x2fc
f0102207:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010220d:	50                   	push   %eax
f010220e:	e8 86 de ff ff       	call   f0100099 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102213:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102216:	8d 83 f8 d5 fe ff    	lea    -0x12a08(%ebx),%eax
f010221c:	50                   	push   %eax
f010221d:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102223:	50                   	push   %eax
f0102224:	68 ff 02 00 00       	push   $0x2ff
f0102229:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010222f:	50                   	push   %eax
f0102230:	e8 64 de ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102235:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102238:	8d 83 30 d6 fe ff    	lea    -0x129d0(%ebx),%eax
f010223e:	50                   	push   %eax
f010223f:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102245:	50                   	push   %eax
f0102246:	68 02 03 00 00       	push   $0x302
f010224b:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102251:	50                   	push   %eax
f0102252:	e8 42 de ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102257:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010225a:	8d 83 60 d6 fe ff    	lea    -0x129a0(%ebx),%eax
f0102260:	50                   	push   %eax
f0102261:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102267:	50                   	push   %eax
f0102268:	68 06 03 00 00       	push   $0x306
f010226d:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102273:	50                   	push   %eax
f0102274:	e8 20 de ff ff       	call   f0100099 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102279:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010227c:	8d 83 90 d6 fe ff    	lea    -0x12970(%ebx),%eax
f0102282:	50                   	push   %eax
f0102283:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102289:	50                   	push   %eax
f010228a:	68 07 03 00 00       	push   $0x307
f010228f:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102295:	50                   	push   %eax
f0102296:	e8 fe dd ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010229b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010229e:	8d 83 b8 d6 fe ff    	lea    -0x12948(%ebx),%eax
f01022a4:	50                   	push   %eax
f01022a5:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01022ab:	50                   	push   %eax
f01022ac:	68 08 03 00 00       	push   $0x308
f01022b1:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01022b7:	50                   	push   %eax
f01022b8:	e8 dc dd ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 1);
f01022bd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01022c0:	8d 83 17 d3 fe ff    	lea    -0x12ce9(%ebx),%eax
f01022c6:	50                   	push   %eax
f01022c7:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01022cd:	50                   	push   %eax
f01022ce:	68 09 03 00 00       	push   $0x309
f01022d3:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01022d9:	50                   	push   %eax
f01022da:	e8 ba dd ff ff       	call   f0100099 <_panic>
	assert(pp0->pp_ref == 1);
f01022df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01022e2:	8d 83 28 d3 fe ff    	lea    -0x12cd8(%ebx),%eax
f01022e8:	50                   	push   %eax
f01022e9:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01022ef:	50                   	push   %eax
f01022f0:	68 0a 03 00 00       	push   $0x30a
f01022f5:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01022fb:	50                   	push   %eax
f01022fc:	e8 98 dd ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102301:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102304:	8d 83 e8 d6 fe ff    	lea    -0x12918(%ebx),%eax
f010230a:	50                   	push   %eax
f010230b:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102311:	50                   	push   %eax
f0102312:	68 0d 03 00 00       	push   $0x30d
f0102317:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010231d:	50                   	push   %eax
f010231e:	e8 76 dd ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102323:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102326:	8d 83 24 d7 fe ff    	lea    -0x128dc(%ebx),%eax
f010232c:	50                   	push   %eax
f010232d:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102333:	50                   	push   %eax
f0102334:	68 0e 03 00 00       	push   $0x30e
f0102339:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010233f:	50                   	push   %eax
f0102340:	e8 54 dd ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 1);
f0102345:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102348:	8d 83 39 d3 fe ff    	lea    -0x12cc7(%ebx),%eax
f010234e:	50                   	push   %eax
f010234f:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102355:	50                   	push   %eax
f0102356:	68 0f 03 00 00       	push   $0x30f
f010235b:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102361:	50                   	push   %eax
f0102362:	e8 32 dd ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f0102367:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010236a:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102370:	50                   	push   %eax
f0102371:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102377:	50                   	push   %eax
f0102378:	68 12 03 00 00       	push   $0x312
f010237d:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102383:	50                   	push   %eax
f0102384:	e8 10 dd ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102389:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010238c:	8d 83 e8 d6 fe ff    	lea    -0x12918(%ebx),%eax
f0102392:	50                   	push   %eax
f0102393:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102399:	50                   	push   %eax
f010239a:	68 15 03 00 00       	push   $0x315
f010239f:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01023a5:	50                   	push   %eax
f01023a6:	e8 ee dc ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01023ab:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01023ae:	8d 83 24 d7 fe ff    	lea    -0x128dc(%ebx),%eax
f01023b4:	50                   	push   %eax
f01023b5:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01023bb:	50                   	push   %eax
f01023bc:	68 16 03 00 00       	push   $0x316
f01023c1:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01023c7:	50                   	push   %eax
f01023c8:	e8 cc dc ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 1);
f01023cd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01023d0:	8d 83 39 d3 fe ff    	lea    -0x12cc7(%ebx),%eax
f01023d6:	50                   	push   %eax
f01023d7:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01023dd:	50                   	push   %eax
f01023de:	68 18 03 00 00       	push   $0x318
f01023e3:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01023e9:	50                   	push   %eax
f01023ea:	e8 aa dc ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f01023ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01023f2:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f01023f8:	50                   	push   %eax
f01023f9:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01023ff:	50                   	push   %eax
f0102400:	68 1c 03 00 00       	push   $0x31c
f0102405:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010240b:	50                   	push   %eax
f010240c:	e8 88 dc ff ff       	call   f0100099 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102411:	50                   	push   %eax
f0102412:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102415:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f010241b:	50                   	push   %eax
f010241c:	68 1f 03 00 00       	push   $0x31f
f0102421:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102427:	50                   	push   %eax
f0102428:	e8 6c dc ff ff       	call   f0100099 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f010242d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102430:	8d 83 54 d7 fe ff    	lea    -0x128ac(%ebx),%eax
f0102436:	50                   	push   %eax
f0102437:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010243d:	50                   	push   %eax
f010243e:	68 20 03 00 00       	push   $0x320
f0102443:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102449:	50                   	push   %eax
f010244a:	e8 4a dc ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f010244f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102452:	8d 83 94 d7 fe ff    	lea    -0x1286c(%ebx),%eax
f0102458:	50                   	push   %eax
f0102459:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010245f:	50                   	push   %eax
f0102460:	68 23 03 00 00       	push   $0x323
f0102465:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010246b:	50                   	push   %eax
f010246c:	e8 28 dc ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102471:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102474:	8d 83 24 d7 fe ff    	lea    -0x128dc(%ebx),%eax
f010247a:	50                   	push   %eax
f010247b:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102481:	50                   	push   %eax
f0102482:	68 24 03 00 00       	push   $0x324
f0102487:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010248d:	50                   	push   %eax
f010248e:	e8 06 dc ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 1);
f0102493:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102496:	8d 83 39 d3 fe ff    	lea    -0x12cc7(%ebx),%eax
f010249c:	50                   	push   %eax
f010249d:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01024a3:	50                   	push   %eax
f01024a4:	68 25 03 00 00       	push   $0x325
f01024a9:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01024af:	50                   	push   %eax
f01024b0:	e8 e4 db ff ff       	call   f0100099 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01024b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01024b8:	8d 83 d4 d7 fe ff    	lea    -0x1282c(%ebx),%eax
f01024be:	50                   	push   %eax
f01024bf:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01024c5:	50                   	push   %eax
f01024c6:	68 26 03 00 00       	push   $0x326
f01024cb:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01024d1:	50                   	push   %eax
f01024d2:	e8 c2 db ff ff       	call   f0100099 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01024d7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01024da:	8d 83 4a d3 fe ff    	lea    -0x12cb6(%ebx),%eax
f01024e0:	50                   	push   %eax
f01024e1:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01024e7:	50                   	push   %eax
f01024e8:	68 27 03 00 00       	push   $0x327
f01024ed:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01024f3:	50                   	push   %eax
f01024f4:	e8 a0 db ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01024f9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01024fc:	8d 83 e8 d6 fe ff    	lea    -0x12918(%ebx),%eax
f0102502:	50                   	push   %eax
f0102503:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102509:	50                   	push   %eax
f010250a:	68 2a 03 00 00       	push   $0x32a
f010250f:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102515:	50                   	push   %eax
f0102516:	e8 7e db ff ff       	call   f0100099 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f010251b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010251e:	8d 83 08 d8 fe ff    	lea    -0x127f8(%ebx),%eax
f0102524:	50                   	push   %eax
f0102525:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010252b:	50                   	push   %eax
f010252c:	68 2b 03 00 00       	push   $0x32b
f0102531:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102537:	50                   	push   %eax
f0102538:	e8 5c db ff ff       	call   f0100099 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010253d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102540:	8d 83 3c d8 fe ff    	lea    -0x127c4(%ebx),%eax
f0102546:	50                   	push   %eax
f0102547:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010254d:	50                   	push   %eax
f010254e:	68 2c 03 00 00       	push   $0x32c
f0102553:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102559:	50                   	push   %eax
f010255a:	e8 3a db ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f010255f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102562:	8d 83 74 d8 fe ff    	lea    -0x1278c(%ebx),%eax
f0102568:	50                   	push   %eax
f0102569:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010256f:	50                   	push   %eax
f0102570:	68 2f 03 00 00       	push   $0x32f
f0102575:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010257b:	50                   	push   %eax
f010257c:	e8 18 db ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102581:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102584:	8d 83 ac d8 fe ff    	lea    -0x12754(%ebx),%eax
f010258a:	50                   	push   %eax
f010258b:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102591:	50                   	push   %eax
f0102592:	68 32 03 00 00       	push   $0x332
f0102597:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010259d:	50                   	push   %eax
f010259e:	e8 f6 da ff ff       	call   f0100099 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01025a3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01025a6:	8d 83 3c d8 fe ff    	lea    -0x127c4(%ebx),%eax
f01025ac:	50                   	push   %eax
f01025ad:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01025b3:	50                   	push   %eax
f01025b4:	68 33 03 00 00       	push   $0x333
f01025b9:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01025bf:	50                   	push   %eax
f01025c0:	e8 d4 da ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01025c5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01025c8:	8d 83 e8 d8 fe ff    	lea    -0x12718(%ebx),%eax
f01025ce:	50                   	push   %eax
f01025cf:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01025d5:	50                   	push   %eax
f01025d6:	68 36 03 00 00       	push   $0x336
f01025db:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01025e1:	50                   	push   %eax
f01025e2:	e8 b2 da ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01025e7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01025ea:	8d 83 14 d9 fe ff    	lea    -0x126ec(%ebx),%eax
f01025f0:	50                   	push   %eax
f01025f1:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01025f7:	50                   	push   %eax
f01025f8:	68 37 03 00 00       	push   $0x337
f01025fd:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102603:	50                   	push   %eax
f0102604:	e8 90 da ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 2);
f0102609:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010260c:	8d 83 60 d3 fe ff    	lea    -0x12ca0(%ebx),%eax
f0102612:	50                   	push   %eax
f0102613:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102619:	50                   	push   %eax
f010261a:	68 39 03 00 00       	push   $0x339
f010261f:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102625:	50                   	push   %eax
f0102626:	e8 6e da ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 0);
f010262b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010262e:	8d 83 71 d3 fe ff    	lea    -0x12c8f(%ebx),%eax
f0102634:	50                   	push   %eax
f0102635:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010263b:	50                   	push   %eax
f010263c:	68 3a 03 00 00       	push   $0x33a
f0102641:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102647:	50                   	push   %eax
f0102648:	e8 4c da ff ff       	call   f0100099 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f010264d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102650:	8d 83 44 d9 fe ff    	lea    -0x126bc(%ebx),%eax
f0102656:	50                   	push   %eax
f0102657:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010265d:	50                   	push   %eax
f010265e:	68 3d 03 00 00       	push   $0x33d
f0102663:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102669:	50                   	push   %eax
f010266a:	e8 2a da ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010266f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102672:	8d 83 68 d9 fe ff    	lea    -0x12698(%ebx),%eax
f0102678:	50                   	push   %eax
f0102679:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010267f:	50                   	push   %eax
f0102680:	68 41 03 00 00       	push   $0x341
f0102685:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010268b:	50                   	push   %eax
f010268c:	e8 08 da ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102691:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102694:	8d 83 14 d9 fe ff    	lea    -0x126ec(%ebx),%eax
f010269a:	50                   	push   %eax
f010269b:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01026a1:	50                   	push   %eax
f01026a2:	68 42 03 00 00       	push   $0x342
f01026a7:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01026ad:	50                   	push   %eax
f01026ae:	e8 e6 d9 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 1);
f01026b3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01026b6:	8d 83 17 d3 fe ff    	lea    -0x12ce9(%ebx),%eax
f01026bc:	50                   	push   %eax
f01026bd:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01026c3:	50                   	push   %eax
f01026c4:	68 43 03 00 00       	push   $0x343
f01026c9:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01026cf:	50                   	push   %eax
f01026d0:	e8 c4 d9 ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 0);
f01026d5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01026d8:	8d 83 71 d3 fe ff    	lea    -0x12c8f(%ebx),%eax
f01026de:	50                   	push   %eax
f01026df:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01026e5:	50                   	push   %eax
f01026e6:	68 44 03 00 00       	push   $0x344
f01026eb:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01026f1:	50                   	push   %eax
f01026f2:	e8 a2 d9 ff ff       	call   f0100099 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01026f7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01026fa:	8d 83 8c d9 fe ff    	lea    -0x12674(%ebx),%eax
f0102700:	50                   	push   %eax
f0102701:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102707:	50                   	push   %eax
f0102708:	68 47 03 00 00       	push   $0x347
f010270d:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102713:	50                   	push   %eax
f0102714:	e8 80 d9 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref);
f0102719:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010271c:	8d 83 82 d3 fe ff    	lea    -0x12c7e(%ebx),%eax
f0102722:	50                   	push   %eax
f0102723:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102729:	50                   	push   %eax
f010272a:	68 48 03 00 00       	push   $0x348
f010272f:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102735:	50                   	push   %eax
f0102736:	e8 5e d9 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_link == NULL);
f010273b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010273e:	8d 83 8e d3 fe ff    	lea    -0x12c72(%ebx),%eax
f0102744:	50                   	push   %eax
f0102745:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010274b:	50                   	push   %eax
f010274c:	68 49 03 00 00       	push   $0x349
f0102751:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102757:	50                   	push   %eax
f0102758:	e8 3c d9 ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010275d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102760:	8d 83 68 d9 fe ff    	lea    -0x12698(%ebx),%eax
f0102766:	50                   	push   %eax
f0102767:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010276d:	50                   	push   %eax
f010276e:	68 4d 03 00 00       	push   $0x34d
f0102773:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102779:	50                   	push   %eax
f010277a:	e8 1a d9 ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f010277f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102782:	8d 83 c4 d9 fe ff    	lea    -0x1263c(%ebx),%eax
f0102788:	50                   	push   %eax
f0102789:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010278f:	50                   	push   %eax
f0102790:	68 4e 03 00 00       	push   $0x34e
f0102795:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f010279b:	50                   	push   %eax
f010279c:	e8 f8 d8 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 0);
f01027a1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01027a4:	8d 83 a3 d3 fe ff    	lea    -0x12c5d(%ebx),%eax
f01027aa:	50                   	push   %eax
f01027ab:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01027b1:	50                   	push   %eax
f01027b2:	68 4f 03 00 00       	push   $0x34f
f01027b7:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01027bd:	50                   	push   %eax
f01027be:	e8 d6 d8 ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 0);
f01027c3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01027c6:	8d 83 71 d3 fe ff    	lea    -0x12c8f(%ebx),%eax
f01027cc:	50                   	push   %eax
f01027cd:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01027d3:	50                   	push   %eax
f01027d4:	68 50 03 00 00       	push   $0x350
f01027d9:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01027df:	50                   	push   %eax
f01027e0:	e8 b4 d8 ff ff       	call   f0100099 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f01027e5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01027e8:	8d 83 ec d9 fe ff    	lea    -0x12614(%ebx),%eax
f01027ee:	50                   	push   %eax
f01027ef:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01027f5:	50                   	push   %eax
f01027f6:	68 53 03 00 00       	push   $0x353
f01027fb:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102801:	50                   	push   %eax
f0102802:	e8 92 d8 ff ff       	call   f0100099 <_panic>
	assert(!page_alloc(0));
f0102807:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010280a:	8d 83 c5 d2 fe ff    	lea    -0x12d3b(%ebx),%eax
f0102810:	50                   	push   %eax
f0102811:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102817:	50                   	push   %eax
f0102818:	68 56 03 00 00       	push   $0x356
f010281d:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102823:	50                   	push   %eax
f0102824:	e8 70 d8 ff ff       	call   f0100099 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102829:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010282c:	8d 83 90 d6 fe ff    	lea    -0x12970(%ebx),%eax
f0102832:	50                   	push   %eax
f0102833:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102839:	50                   	push   %eax
f010283a:	68 59 03 00 00       	push   $0x359
f010283f:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102845:	50                   	push   %eax
f0102846:	e8 4e d8 ff ff       	call   f0100099 <_panic>
	assert(pp0->pp_ref == 1);
f010284b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010284e:	8d 83 28 d3 fe ff    	lea    -0x12cd8(%ebx),%eax
f0102854:	50                   	push   %eax
f0102855:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010285b:	50                   	push   %eax
f010285c:	68 5b 03 00 00       	push   $0x35b
f0102861:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102867:	50                   	push   %eax
f0102868:	e8 2c d8 ff ff       	call   f0100099 <_panic>
f010286d:	52                   	push   %edx
f010286e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102871:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f0102877:	50                   	push   %eax
f0102878:	68 62 03 00 00       	push   $0x362
f010287d:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102883:	50                   	push   %eax
f0102884:	e8 10 d8 ff ff       	call   f0100099 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102889:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010288c:	8d 83 b4 d3 fe ff    	lea    -0x12c4c(%ebx),%eax
f0102892:	50                   	push   %eax
f0102893:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102899:	50                   	push   %eax
f010289a:	68 63 03 00 00       	push   $0x363
f010289f:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01028a5:	50                   	push   %eax
f01028a6:	e8 ee d7 ff ff       	call   f0100099 <_panic>
f01028ab:	50                   	push   %eax
f01028ac:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01028af:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f01028b5:	50                   	push   %eax
f01028b6:	6a 52                	push   $0x52
f01028b8:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f01028be:	50                   	push   %eax
f01028bf:	e8 d5 d7 ff ff       	call   f0100099 <_panic>
f01028c4:	52                   	push   %edx
f01028c5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01028c8:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f01028ce:	50                   	push   %eax
f01028cf:	6a 52                	push   $0x52
f01028d1:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f01028d7:	50                   	push   %eax
f01028d8:	e8 bc d7 ff ff       	call   f0100099 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f01028dd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01028e0:	8d 83 cc d3 fe ff    	lea    -0x12c34(%ebx),%eax
f01028e6:	50                   	push   %eax
f01028e7:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01028ed:	50                   	push   %eax
f01028ee:	68 6d 03 00 00       	push   $0x36d
f01028f3:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f01028f9:	50                   	push   %eax
f01028fa:	e8 9a d7 ff ff       	call   f0100099 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01028ff:	50                   	push   %eax
f0102900:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102903:	8d 83 94 d5 fe ff    	lea    -0x12a6c(%ebx),%eax
f0102909:	50                   	push   %eax
f010290a:	68 b1 00 00 00       	push   $0xb1
f010290f:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102915:	50                   	push   %eax
f0102916:	e8 7e d7 ff ff       	call   f0100099 <_panic>
f010291b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010291e:	ff b3 fc ff ff ff    	pushl  -0x4(%ebx)
f0102924:	8d 83 94 d5 fe ff    	lea    -0x12a6c(%ebx),%eax
f010292a:	50                   	push   %eax
f010292b:	68 be 00 00 00       	push   $0xbe
f0102930:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102936:	50                   	push   %eax
f0102937:	e8 5d d7 ff ff       	call   f0100099 <_panic>
f010293c:	ff 75 c0             	pushl  -0x40(%ebp)
f010293f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102942:	8d 83 94 d5 fe ff    	lea    -0x12a6c(%ebx),%eax
f0102948:	50                   	push   %eax
f0102949:	68 ae 02 00 00       	push   $0x2ae
f010294e:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102954:	50                   	push   %eax
f0102955:	e8 3f d7 ff ff       	call   f0100099 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010295a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010295d:	8d 83 10 da fe ff    	lea    -0x125f0(%ebx),%eax
f0102963:	50                   	push   %eax
f0102964:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f010296a:	50                   	push   %eax
f010296b:	68 ae 02 00 00       	push   $0x2ae
f0102970:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102976:	50                   	push   %eax
f0102977:	e8 1d d7 ff ff       	call   f0100099 <_panic>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f010297c:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f010297f:	c1 e7 0c             	shl    $0xc,%edi
f0102982:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102987:	eb 17                	jmp    f01029a0 <mem_init+0x1720>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102989:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f010298f:	89 f0                	mov    %esi,%eax
f0102991:	e8 a7 e0 ff ff       	call   f0100a3d <check_va2pa>
f0102996:	39 c3                	cmp    %eax,%ebx
f0102998:	75 51                	jne    f01029eb <mem_init+0x176b>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f010299a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01029a0:	39 fb                	cmp    %edi,%ebx
f01029a2:	72 e5                	jb     f0102989 <mem_init+0x1709>
f01029a4:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f01029a9:	8b 7d c8             	mov    -0x38(%ebp),%edi
f01029ac:	81 c7 00 80 00 20    	add    $0x20008000,%edi
f01029b2:	89 da                	mov    %ebx,%edx
f01029b4:	89 f0                	mov    %esi,%eax
f01029b6:	e8 82 e0 ff ff       	call   f0100a3d <check_va2pa>
f01029bb:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
f01029be:	39 c2                	cmp    %eax,%edx
f01029c0:	75 4b                	jne    f0102a0d <mem_init+0x178d>
f01029c2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f01029c8:	81 fb 00 00 00 f0    	cmp    $0xf0000000,%ebx
f01029ce:	75 e2                	jne    f01029b2 <mem_init+0x1732>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f01029d0:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f01029d5:	89 f0                	mov    %esi,%eax
f01029d7:	e8 61 e0 ff ff       	call   f0100a3d <check_va2pa>
f01029dc:	83 f8 ff             	cmp    $0xffffffff,%eax
f01029df:	75 4e                	jne    f0102a2f <mem_init+0x17af>
	for (i = 0; i < NPDENTRIES; i++) {
f01029e1:	b8 00 00 00 00       	mov    $0x0,%eax
f01029e6:	e9 8f 00 00 00       	jmp    f0102a7a <mem_init+0x17fa>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f01029eb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01029ee:	8d 83 44 da fe ff    	lea    -0x125bc(%ebx),%eax
f01029f4:	50                   	push   %eax
f01029f5:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f01029fb:	50                   	push   %eax
f01029fc:	68 b3 02 00 00       	push   $0x2b3
f0102a01:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102a07:	50                   	push   %eax
f0102a08:	e8 8c d6 ff ff       	call   f0100099 <_panic>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0102a0d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102a10:	8d 83 6c da fe ff    	lea    -0x12594(%ebx),%eax
f0102a16:	50                   	push   %eax
f0102a17:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102a1d:	50                   	push   %eax
f0102a1e:	68 b7 02 00 00       	push   $0x2b7
f0102a23:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102a29:	50                   	push   %eax
f0102a2a:	e8 6a d6 ff ff       	call   f0100099 <_panic>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0102a2f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102a32:	8d 83 b4 da fe ff    	lea    -0x1254c(%ebx),%eax
f0102a38:	50                   	push   %eax
f0102a39:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102a3f:	50                   	push   %eax
f0102a40:	68 b8 02 00 00       	push   $0x2b8
f0102a45:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102a4b:	50                   	push   %eax
f0102a4c:	e8 48 d6 ff ff       	call   f0100099 <_panic>
			assert(pgdir[i] & PTE_P);
f0102a51:	f6 04 86 01          	testb  $0x1,(%esi,%eax,4)
f0102a55:	74 52                	je     f0102aa9 <mem_init+0x1829>
	for (i = 0; i < NPDENTRIES; i++) {
f0102a57:	83 c0 01             	add    $0x1,%eax
f0102a5a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0102a5f:	0f 87 bb 00 00 00    	ja     f0102b20 <mem_init+0x18a0>
		switch (i) {
f0102a65:	3d bc 03 00 00       	cmp    $0x3bc,%eax
f0102a6a:	72 0e                	jb     f0102a7a <mem_init+0x17fa>
f0102a6c:	3d bd 03 00 00       	cmp    $0x3bd,%eax
f0102a71:	76 de                	jbe    f0102a51 <mem_init+0x17d1>
f0102a73:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0102a78:	74 d7                	je     f0102a51 <mem_init+0x17d1>
			if (i >= PDX(KERNBASE)) {
f0102a7a:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0102a7f:	77 4a                	ja     f0102acb <mem_init+0x184b>
				assert(pgdir[i] == 0);
f0102a81:	83 3c 86 00          	cmpl   $0x0,(%esi,%eax,4)
f0102a85:	74 d0                	je     f0102a57 <mem_init+0x17d7>
f0102a87:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102a8a:	8d 83 1e d4 fe ff    	lea    -0x12be2(%ebx),%eax
f0102a90:	50                   	push   %eax
f0102a91:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102a97:	50                   	push   %eax
f0102a98:	68 c7 02 00 00       	push   $0x2c7
f0102a9d:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102aa3:	50                   	push   %eax
f0102aa4:	e8 f0 d5 ff ff       	call   f0100099 <_panic>
			assert(pgdir[i] & PTE_P);
f0102aa9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102aac:	8d 83 fc d3 fe ff    	lea    -0x12c04(%ebx),%eax
f0102ab2:	50                   	push   %eax
f0102ab3:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102ab9:	50                   	push   %eax
f0102aba:	68 c0 02 00 00       	push   $0x2c0
f0102abf:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102ac5:	50                   	push   %eax
f0102ac6:	e8 ce d5 ff ff       	call   f0100099 <_panic>
				assert(pgdir[i] & PTE_P);
f0102acb:	8b 14 86             	mov    (%esi,%eax,4),%edx
f0102ace:	f6 c2 01             	test   $0x1,%dl
f0102ad1:	74 2b                	je     f0102afe <mem_init+0x187e>
				assert(pgdir[i] & PTE_W);
f0102ad3:	f6 c2 02             	test   $0x2,%dl
f0102ad6:	0f 85 7b ff ff ff    	jne    f0102a57 <mem_init+0x17d7>
f0102adc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102adf:	8d 83 0d d4 fe ff    	lea    -0x12bf3(%ebx),%eax
f0102ae5:	50                   	push   %eax
f0102ae6:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102aec:	50                   	push   %eax
f0102aed:	68 c5 02 00 00       	push   $0x2c5
f0102af2:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102af8:	50                   	push   %eax
f0102af9:	e8 9b d5 ff ff       	call   f0100099 <_panic>
				assert(pgdir[i] & PTE_P);
f0102afe:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102b01:	8d 83 fc d3 fe ff    	lea    -0x12c04(%ebx),%eax
f0102b07:	50                   	push   %eax
f0102b08:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102b0e:	50                   	push   %eax
f0102b0f:	68 c4 02 00 00       	push   $0x2c4
f0102b14:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102b1a:	50                   	push   %eax
f0102b1b:	e8 79 d5 ff ff       	call   f0100099 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102b20:	83 ec 0c             	sub    $0xc,%esp
f0102b23:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0102b26:	8d 87 e4 da fe ff    	lea    -0x1251c(%edi),%eax
f0102b2c:	50                   	push   %eax
f0102b2d:	89 fb                	mov    %edi,%ebx
f0102b2f:	e8 ea 04 00 00       	call   f010301e <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102b34:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0102b3a:	8b 00                	mov    (%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0102b3c:	83 c4 10             	add    $0x10,%esp
f0102b3f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102b44:	0f 86 44 02 00 00    	jbe    f0102d8e <mem_init+0x1b0e>
	return (physaddr_t)kva - KERNBASE;
f0102b4a:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102b4f:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102b52:	b8 00 00 00 00       	mov    $0x0,%eax
f0102b57:	e8 5e df ff ff       	call   f0100aba <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102b5c:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102b5f:	83 e0 f3             	and    $0xfffffff3,%eax
f0102b62:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102b67:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102b6a:	83 ec 0c             	sub    $0xc,%esp
f0102b6d:	6a 00                	push   $0x0
f0102b6f:	e8 a0 e3 ff ff       	call   f0100f14 <page_alloc>
f0102b74:	89 c6                	mov    %eax,%esi
f0102b76:	83 c4 10             	add    $0x10,%esp
f0102b79:	85 c0                	test   %eax,%eax
f0102b7b:	0f 84 29 02 00 00    	je     f0102daa <mem_init+0x1b2a>
	assert((pp1 = page_alloc(0)));
f0102b81:	83 ec 0c             	sub    $0xc,%esp
f0102b84:	6a 00                	push   $0x0
f0102b86:	e8 89 e3 ff ff       	call   f0100f14 <page_alloc>
f0102b8b:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102b8e:	83 c4 10             	add    $0x10,%esp
f0102b91:	85 c0                	test   %eax,%eax
f0102b93:	0f 84 33 02 00 00    	je     f0102dcc <mem_init+0x1b4c>
	assert((pp2 = page_alloc(0)));
f0102b99:	83 ec 0c             	sub    $0xc,%esp
f0102b9c:	6a 00                	push   $0x0
f0102b9e:	e8 71 e3 ff ff       	call   f0100f14 <page_alloc>
f0102ba3:	89 c7                	mov    %eax,%edi
f0102ba5:	83 c4 10             	add    $0x10,%esp
f0102ba8:	85 c0                	test   %eax,%eax
f0102baa:	0f 84 3e 02 00 00    	je     f0102dee <mem_init+0x1b6e>
	page_free(pp0);
f0102bb0:	83 ec 0c             	sub    $0xc,%esp
f0102bb3:	56                   	push   %esi
f0102bb4:	e8 e3 e3 ff ff       	call   f0100f9c <page_free>
	return (pp - pages) << PGSHIFT;
f0102bb9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102bbc:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0102bc2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0102bc5:	2b 08                	sub    (%eax),%ecx
f0102bc7:	89 c8                	mov    %ecx,%eax
f0102bc9:	c1 f8 03             	sar    $0x3,%eax
f0102bcc:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102bcf:	89 c1                	mov    %eax,%ecx
f0102bd1:	c1 e9 0c             	shr    $0xc,%ecx
f0102bd4:	83 c4 10             	add    $0x10,%esp
f0102bd7:	c7 c2 c8 96 11 f0    	mov    $0xf01196c8,%edx
f0102bdd:	3b 0a                	cmp    (%edx),%ecx
f0102bdf:	0f 83 2b 02 00 00    	jae    f0102e10 <mem_init+0x1b90>
	memset(page2kva(pp1), 1, PGSIZE);
f0102be5:	83 ec 04             	sub    $0x4,%esp
f0102be8:	68 00 10 00 00       	push   $0x1000
f0102bed:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102bef:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102bf4:	50                   	push   %eax
f0102bf5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102bf8:	e8 7d 0f 00 00       	call   f0103b7a <memset>
	return (pp - pages) << PGSHIFT;
f0102bfd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102c00:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0102c06:	89 f9                	mov    %edi,%ecx
f0102c08:	2b 08                	sub    (%eax),%ecx
f0102c0a:	89 c8                	mov    %ecx,%eax
f0102c0c:	c1 f8 03             	sar    $0x3,%eax
f0102c0f:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102c12:	89 c1                	mov    %eax,%ecx
f0102c14:	c1 e9 0c             	shr    $0xc,%ecx
f0102c17:	83 c4 10             	add    $0x10,%esp
f0102c1a:	c7 c2 c8 96 11 f0    	mov    $0xf01196c8,%edx
f0102c20:	3b 0a                	cmp    (%edx),%ecx
f0102c22:	0f 83 fe 01 00 00    	jae    f0102e26 <mem_init+0x1ba6>
	memset(page2kva(pp2), 2, PGSIZE);
f0102c28:	83 ec 04             	sub    $0x4,%esp
f0102c2b:	68 00 10 00 00       	push   $0x1000
f0102c30:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102c32:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102c37:	50                   	push   %eax
f0102c38:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102c3b:	e8 3a 0f 00 00       	call   f0103b7a <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102c40:	6a 02                	push   $0x2
f0102c42:	68 00 10 00 00       	push   $0x1000
f0102c47:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0102c4a:	53                   	push   %ebx
f0102c4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c4e:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0102c54:	ff 30                	pushl  (%eax)
f0102c56:	e8 99 e5 ff ff       	call   f01011f4 <page_insert>
	assert(pp1->pp_ref == 1);
f0102c5b:	83 c4 20             	add    $0x20,%esp
f0102c5e:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102c63:	0f 85 d3 01 00 00    	jne    f0102e3c <mem_init+0x1bbc>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102c69:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102c70:	01 01 01 
f0102c73:	0f 85 e5 01 00 00    	jne    f0102e5e <mem_init+0x1bde>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102c79:	6a 02                	push   $0x2
f0102c7b:	68 00 10 00 00       	push   $0x1000
f0102c80:	57                   	push   %edi
f0102c81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c84:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0102c8a:	ff 30                	pushl  (%eax)
f0102c8c:	e8 63 e5 ff ff       	call   f01011f4 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102c91:	83 c4 10             	add    $0x10,%esp
f0102c94:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102c9b:	02 02 02 
f0102c9e:	0f 85 dc 01 00 00    	jne    f0102e80 <mem_init+0x1c00>
	assert(pp2->pp_ref == 1);
f0102ca4:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102ca9:	0f 85 f3 01 00 00    	jne    f0102ea2 <mem_init+0x1c22>
	assert(pp1->pp_ref == 0);
f0102caf:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102cb2:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102cb7:	0f 85 07 02 00 00    	jne    f0102ec4 <mem_init+0x1c44>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102cbd:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102cc4:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102cc7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102cca:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0102cd0:	89 f9                	mov    %edi,%ecx
f0102cd2:	2b 08                	sub    (%eax),%ecx
f0102cd4:	89 c8                	mov    %ecx,%eax
f0102cd6:	c1 f8 03             	sar    $0x3,%eax
f0102cd9:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102cdc:	89 c1                	mov    %eax,%ecx
f0102cde:	c1 e9 0c             	shr    $0xc,%ecx
f0102ce1:	c7 c2 c8 96 11 f0    	mov    $0xf01196c8,%edx
f0102ce7:	3b 0a                	cmp    (%edx),%ecx
f0102ce9:	0f 83 f7 01 00 00    	jae    f0102ee6 <mem_init+0x1c66>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102cef:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0102cf6:	03 03 03 
f0102cf9:	0f 85 fd 01 00 00    	jne    f0102efc <mem_init+0x1c7c>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102cff:	83 ec 08             	sub    $0x8,%esp
f0102d02:	68 00 10 00 00       	push   $0x1000
f0102d07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d0a:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0102d10:	ff 30                	pushl  (%eax)
f0102d12:	e8 8d e4 ff ff       	call   f01011a4 <page_remove>
	assert(pp2->pp_ref == 0);
f0102d17:	83 c4 10             	add    $0x10,%esp
f0102d1a:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102d1f:	0f 85 f9 01 00 00    	jne    f0102f1e <mem_init+0x1c9e>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102d25:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0102d28:	c7 c0 cc 96 11 f0    	mov    $0xf01196cc,%eax
f0102d2e:	8b 08                	mov    (%eax),%ecx
f0102d30:	8b 11                	mov    (%ecx),%edx
f0102d32:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102d38:	c7 c0 d0 96 11 f0    	mov    $0xf01196d0,%eax
f0102d3e:	89 f7                	mov    %esi,%edi
f0102d40:	2b 38                	sub    (%eax),%edi
f0102d42:	89 f8                	mov    %edi,%eax
f0102d44:	c1 f8 03             	sar    $0x3,%eax
f0102d47:	c1 e0 0c             	shl    $0xc,%eax
f0102d4a:	39 c2                	cmp    %eax,%edx
f0102d4c:	0f 85 ee 01 00 00    	jne    f0102f40 <mem_init+0x1cc0>
	kern_pgdir[0] = 0;
f0102d52:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102d58:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102d5d:	0f 85 ff 01 00 00    	jne    f0102f62 <mem_init+0x1ce2>
	pp0->pp_ref = 0;
f0102d63:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0102d69:	83 ec 0c             	sub    $0xc,%esp
f0102d6c:	56                   	push   %esi
f0102d6d:	e8 2a e2 ff ff       	call   f0100f9c <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102d72:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102d75:	8d 83 78 db fe ff    	lea    -0x12488(%ebx),%eax
f0102d7b:	89 04 24             	mov    %eax,(%esp)
f0102d7e:	e8 9b 02 00 00       	call   f010301e <cprintf>
}
f0102d83:	83 c4 10             	add    $0x10,%esp
f0102d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102d89:	5b                   	pop    %ebx
f0102d8a:	5e                   	pop    %esi
f0102d8b:	5f                   	pop    %edi
f0102d8c:	5d                   	pop    %ebp
f0102d8d:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102d8e:	50                   	push   %eax
f0102d8f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102d92:	8d 83 94 d5 fe ff    	lea    -0x12a6c(%ebx),%eax
f0102d98:	50                   	push   %eax
f0102d99:	68 d4 00 00 00       	push   $0xd4
f0102d9e:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102da4:	50                   	push   %eax
f0102da5:	e8 ef d2 ff ff       	call   f0100099 <_panic>
	assert((pp0 = page_alloc(0)));
f0102daa:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102dad:	8d 83 1a d2 fe ff    	lea    -0x12de6(%ebx),%eax
f0102db3:	50                   	push   %eax
f0102db4:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102dba:	50                   	push   %eax
f0102dbb:	68 88 03 00 00       	push   $0x388
f0102dc0:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102dc6:	50                   	push   %eax
f0102dc7:	e8 cd d2 ff ff       	call   f0100099 <_panic>
	assert((pp1 = page_alloc(0)));
f0102dcc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102dcf:	8d 83 30 d2 fe ff    	lea    -0x12dd0(%ebx),%eax
f0102dd5:	50                   	push   %eax
f0102dd6:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102ddc:	50                   	push   %eax
f0102ddd:	68 89 03 00 00       	push   $0x389
f0102de2:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102de8:	50                   	push   %eax
f0102de9:	e8 ab d2 ff ff       	call   f0100099 <_panic>
	assert((pp2 = page_alloc(0)));
f0102dee:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102df1:	8d 83 46 d2 fe ff    	lea    -0x12dba(%ebx),%eax
f0102df7:	50                   	push   %eax
f0102df8:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102dfe:	50                   	push   %eax
f0102dff:	68 8a 03 00 00       	push   $0x38a
f0102e04:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102e0a:	50                   	push   %eax
f0102e0b:	e8 89 d2 ff ff       	call   f0100099 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102e10:	50                   	push   %eax
f0102e11:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f0102e17:	50                   	push   %eax
f0102e18:	6a 52                	push   $0x52
f0102e1a:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f0102e20:	50                   	push   %eax
f0102e21:	e8 73 d2 ff ff       	call   f0100099 <_panic>
f0102e26:	50                   	push   %eax
f0102e27:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f0102e2d:	50                   	push   %eax
f0102e2e:	6a 52                	push   $0x52
f0102e30:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f0102e36:	50                   	push   %eax
f0102e37:	e8 5d d2 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 1);
f0102e3c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102e3f:	8d 83 17 d3 fe ff    	lea    -0x12ce9(%ebx),%eax
f0102e45:	50                   	push   %eax
f0102e46:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102e4c:	50                   	push   %eax
f0102e4d:	68 8f 03 00 00       	push   $0x38f
f0102e52:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102e58:	50                   	push   %eax
f0102e59:	e8 3b d2 ff ff       	call   f0100099 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102e5e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102e61:	8d 83 04 db fe ff    	lea    -0x124fc(%ebx),%eax
f0102e67:	50                   	push   %eax
f0102e68:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102e6e:	50                   	push   %eax
f0102e6f:	68 90 03 00 00       	push   $0x390
f0102e74:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102e7a:	50                   	push   %eax
f0102e7b:	e8 19 d2 ff ff       	call   f0100099 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102e80:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102e83:	8d 83 28 db fe ff    	lea    -0x124d8(%ebx),%eax
f0102e89:	50                   	push   %eax
f0102e8a:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102e90:	50                   	push   %eax
f0102e91:	68 92 03 00 00       	push   $0x392
f0102e96:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102e9c:	50                   	push   %eax
f0102e9d:	e8 f7 d1 ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 1);
f0102ea2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102ea5:	8d 83 39 d3 fe ff    	lea    -0x12cc7(%ebx),%eax
f0102eab:	50                   	push   %eax
f0102eac:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102eb2:	50                   	push   %eax
f0102eb3:	68 93 03 00 00       	push   $0x393
f0102eb8:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102ebe:	50                   	push   %eax
f0102ebf:	e8 d5 d1 ff ff       	call   f0100099 <_panic>
	assert(pp1->pp_ref == 0);
f0102ec4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102ec7:	8d 83 a3 d3 fe ff    	lea    -0x12c5d(%ebx),%eax
f0102ecd:	50                   	push   %eax
f0102ece:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102ed4:	50                   	push   %eax
f0102ed5:	68 94 03 00 00       	push   $0x394
f0102eda:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102ee0:	50                   	push   %eax
f0102ee1:	e8 b3 d1 ff ff       	call   f0100099 <_panic>
f0102ee6:	50                   	push   %eax
f0102ee7:	8d 83 2c d4 fe ff    	lea    -0x12bd4(%ebx),%eax
f0102eed:	50                   	push   %eax
f0102eee:	6a 52                	push   $0x52
f0102ef0:	8d 83 31 d1 fe ff    	lea    -0x12ecf(%ebx),%eax
f0102ef6:	50                   	push   %eax
f0102ef7:	e8 9d d1 ff ff       	call   f0100099 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102efc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102eff:	8d 83 4c db fe ff    	lea    -0x124b4(%ebx),%eax
f0102f05:	50                   	push   %eax
f0102f06:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102f0c:	50                   	push   %eax
f0102f0d:	68 96 03 00 00       	push   $0x396
f0102f12:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102f18:	50                   	push   %eax
f0102f19:	e8 7b d1 ff ff       	call   f0100099 <_panic>
	assert(pp2->pp_ref == 0);
f0102f1e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f21:	8d 83 71 d3 fe ff    	lea    -0x12c8f(%ebx),%eax
f0102f27:	50                   	push   %eax
f0102f28:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102f2e:	50                   	push   %eax
f0102f2f:	68 98 03 00 00       	push   $0x398
f0102f34:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102f3a:	50                   	push   %eax
f0102f3b:	e8 59 d1 ff ff       	call   f0100099 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102f40:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f43:	8d 83 90 d6 fe ff    	lea    -0x12970(%ebx),%eax
f0102f49:	50                   	push   %eax
f0102f4a:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102f50:	50                   	push   %eax
f0102f51:	68 9b 03 00 00       	push   $0x39b
f0102f56:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102f5c:	50                   	push   %eax
f0102f5d:	e8 37 d1 ff ff       	call   f0100099 <_panic>
	assert(pp0->pp_ref == 1);
f0102f62:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0102f65:	8d 83 28 d3 fe ff    	lea    -0x12cd8(%ebx),%eax
f0102f6b:	50                   	push   %eax
f0102f6c:	8d 83 4b d1 fe ff    	lea    -0x12eb5(%ebx),%eax
f0102f72:	50                   	push   %eax
f0102f73:	68 9d 03 00 00       	push   $0x39d
f0102f78:	8d 83 25 d1 fe ff    	lea    -0x12edb(%ebx),%eax
f0102f7e:	50                   	push   %eax
f0102f7f:	e8 15 d1 ff ff       	call   f0100099 <_panic>

f0102f84 <tlb_invalidate>:
{
f0102f84:	55                   	push   %ebp
f0102f85:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0102f87:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102f8a:	0f 01 38             	invlpg (%eax)
}
f0102f8d:	5d                   	pop    %ebp
f0102f8e:	c3                   	ret    

f0102f8f <__x86.get_pc_thunk.cx>:
f0102f8f:	8b 0c 24             	mov    (%esp),%ecx
f0102f92:	c3                   	ret    

f0102f93 <__x86.get_pc_thunk.di>:
f0102f93:	8b 3c 24             	mov    (%esp),%edi
f0102f96:	c3                   	ret    

f0102f97 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0102f97:	55                   	push   %ebp
f0102f98:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0102f9a:	8b 45 08             	mov    0x8(%ebp),%eax
f0102f9d:	ba 70 00 00 00       	mov    $0x70,%edx
f0102fa2:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0102fa3:	ba 71 00 00 00       	mov    $0x71,%edx
f0102fa8:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0102fa9:	0f b6 c0             	movzbl %al,%eax
}
f0102fac:	5d                   	pop    %ebp
f0102fad:	c3                   	ret    

f0102fae <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0102fae:	55                   	push   %ebp
f0102faf:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0102fb1:	8b 45 08             	mov    0x8(%ebp),%eax
f0102fb4:	ba 70 00 00 00       	mov    $0x70,%edx
f0102fb9:	ee                   	out    %al,(%dx)
f0102fba:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102fbd:	ba 71 00 00 00       	mov    $0x71,%edx
f0102fc2:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0102fc3:	5d                   	pop    %ebp
f0102fc4:	c3                   	ret    

f0102fc5 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0102fc5:	55                   	push   %ebp
f0102fc6:	89 e5                	mov    %esp,%ebp
f0102fc8:	53                   	push   %ebx
f0102fc9:	83 ec 10             	sub    $0x10,%esp
f0102fcc:	e8 7e d1 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0102fd1:	81 c3 3b 43 01 00    	add    $0x1433b,%ebx
	cputchar(ch);
f0102fd7:	ff 75 08             	pushl  0x8(%ebp)
f0102fda:	e8 e7 d6 ff ff       	call   f01006c6 <cputchar>
	*cnt++;
}
f0102fdf:	83 c4 10             	add    $0x10,%esp
f0102fe2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102fe5:	c9                   	leave  
f0102fe6:	c3                   	ret    

f0102fe7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0102fe7:	55                   	push   %ebp
f0102fe8:	89 e5                	mov    %esp,%ebp
f0102fea:	53                   	push   %ebx
f0102feb:	83 ec 14             	sub    $0x14,%esp
f0102fee:	e8 5c d1 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0102ff3:	81 c3 19 43 01 00    	add    $0x14319,%ebx
	int cnt = 0;
f0102ff9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103000:	ff 75 0c             	pushl  0xc(%ebp)
f0103003:	ff 75 08             	pushl  0x8(%ebp)
f0103006:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103009:	50                   	push   %eax
f010300a:	8d 83 b9 bc fe ff    	lea    -0x14347(%ebx),%eax
f0103010:	50                   	push   %eax
f0103011:	e8 18 04 00 00       	call   f010342e <vprintfmt>
	return cnt;
}
f0103016:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010301c:	c9                   	leave  
f010301d:	c3                   	ret    

f010301e <cprintf>:

int
cprintf(const char *fmt, ...)
{
f010301e:	55                   	push   %ebp
f010301f:	89 e5                	mov    %esp,%ebp
f0103021:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103024:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103027:	50                   	push   %eax
f0103028:	ff 75 08             	pushl  0x8(%ebp)
f010302b:	e8 b7 ff ff ff       	call   f0102fe7 <vcprintf>
	va_end(ap);

	return cnt;
}
f0103030:	c9                   	leave  
f0103031:	c3                   	ret    

f0103032 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0103032:	55                   	push   %ebp
f0103033:	89 e5                	mov    %esp,%ebp
f0103035:	57                   	push   %edi
f0103036:	56                   	push   %esi
f0103037:	53                   	push   %ebx
f0103038:	83 ec 14             	sub    $0x14,%esp
f010303b:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010303e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0103041:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0103044:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f0103047:	8b 32                	mov    (%edx),%esi
f0103049:	8b 01                	mov    (%ecx),%eax
f010304b:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010304e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0103055:	eb 2f                	jmp    f0103086 <stab_binsearch+0x54>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f0103057:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f010305a:	39 c6                	cmp    %eax,%esi
f010305c:	7f 49                	jg     f01030a7 <stab_binsearch+0x75>
f010305e:	0f b6 0a             	movzbl (%edx),%ecx
f0103061:	83 ea 0c             	sub    $0xc,%edx
f0103064:	39 f9                	cmp    %edi,%ecx
f0103066:	75 ef                	jne    f0103057 <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0103068:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010306b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010306e:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0103072:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0103075:	73 35                	jae    f01030ac <stab_binsearch+0x7a>
			*region_left = m;
f0103077:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010307a:	89 06                	mov    %eax,(%esi)
			l = true_m + 1;
f010307c:	8d 73 01             	lea    0x1(%ebx),%esi
		any_matches = 1;
f010307f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0103086:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0103089:	7f 4e                	jg     f01030d9 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f010308b:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010308e:	01 f0                	add    %esi,%eax
f0103090:	89 c3                	mov    %eax,%ebx
f0103092:	c1 eb 1f             	shr    $0x1f,%ebx
f0103095:	01 c3                	add    %eax,%ebx
f0103097:	d1 fb                	sar    %ebx
f0103099:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f010309c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010309f:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f01030a3:	89 d8                	mov    %ebx,%eax
		while (m >= l && stabs[m].n_type != type)
f01030a5:	eb b3                	jmp    f010305a <stab_binsearch+0x28>
			l = true_m + 1;
f01030a7:	8d 73 01             	lea    0x1(%ebx),%esi
			continue;
f01030aa:	eb da                	jmp    f0103086 <stab_binsearch+0x54>
		} else if (stabs[m].n_value > addr) {
f01030ac:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01030af:	76 14                	jbe    f01030c5 <stab_binsearch+0x93>
			*region_right = m - 1;
f01030b1:	83 e8 01             	sub    $0x1,%eax
f01030b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01030b7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01030ba:	89 03                	mov    %eax,(%ebx)
		any_matches = 1;
f01030bc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01030c3:	eb c1                	jmp    f0103086 <stab_binsearch+0x54>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f01030c5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01030c8:	89 06                	mov    %eax,(%esi)
			l = m;
			addr++;
f01030ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f01030ce:	89 c6                	mov    %eax,%esi
		any_matches = 1;
f01030d0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01030d7:	eb ad                	jmp    f0103086 <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f01030d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f01030dd:	74 16                	je     f01030f5 <stab_binsearch+0xc3>
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01030df:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01030e2:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f01030e4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01030e7:	8b 0e                	mov    (%esi),%ecx
f01030e9:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01030ec:	8b 75 ec             	mov    -0x14(%ebp),%esi
f01030ef:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
		for (l = *region_right;
f01030f3:	eb 12                	jmp    f0103107 <stab_binsearch+0xd5>
		*region_right = *region_left - 1;
f01030f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01030f8:	8b 00                	mov    (%eax),%eax
f01030fa:	83 e8 01             	sub    $0x1,%eax
f01030fd:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0103100:	89 07                	mov    %eax,(%edi)
f0103102:	eb 16                	jmp    f010311a <stab_binsearch+0xe8>
		     l--)
f0103104:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0103107:	39 c1                	cmp    %eax,%ecx
f0103109:	7d 0a                	jge    f0103115 <stab_binsearch+0xe3>
		     l > *region_left && stabs[l].n_type != type;
f010310b:	0f b6 1a             	movzbl (%edx),%ebx
f010310e:	83 ea 0c             	sub    $0xc,%edx
f0103111:	39 fb                	cmp    %edi,%ebx
f0103113:	75 ef                	jne    f0103104 <stab_binsearch+0xd2>
			/* do nothing */;
		*region_left = l;
f0103115:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103118:	89 07                	mov    %eax,(%edi)
	}
}
f010311a:	83 c4 14             	add    $0x14,%esp
f010311d:	5b                   	pop    %ebx
f010311e:	5e                   	pop    %esi
f010311f:	5f                   	pop    %edi
f0103120:	5d                   	pop    %ebp
f0103121:	c3                   	ret    

f0103122 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0103122:	55                   	push   %ebp
f0103123:	89 e5                	mov    %esp,%ebp
f0103125:	57                   	push   %edi
f0103126:	56                   	push   %esi
f0103127:	53                   	push   %ebx
f0103128:	83 ec 2c             	sub    $0x2c,%esp
f010312b:	e8 5f fe ff ff       	call   f0102f8f <__x86.get_pc_thunk.cx>
f0103130:	81 c1 dc 41 01 00    	add    $0x141dc,%ecx
f0103136:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0103139:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010313c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f010313f:	8d 81 a4 db fe ff    	lea    -0x1245c(%ecx),%eax
f0103145:	89 07                	mov    %eax,(%edi)
	info->eip_line = 0;
f0103147:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
	info->eip_fn_name = "<unknown>";
f010314e:	89 47 08             	mov    %eax,0x8(%edi)
	info->eip_fn_namelen = 9;
f0103151:	c7 47 0c 09 00 00 00 	movl   $0x9,0xc(%edi)
	info->eip_fn_addr = addr;
f0103158:	89 5f 10             	mov    %ebx,0x10(%edi)
	info->eip_fn_narg = 0;
f010315b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0103162:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0103168:	0f 86 f4 00 00 00    	jbe    f0103262 <debuginfo_eip+0x140>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f010316e:	c7 c0 4d b7 10 f0    	mov    $0xf010b74d,%eax
f0103174:	39 81 f8 ff ff ff    	cmp    %eax,-0x8(%ecx)
f010317a:	0f 86 88 01 00 00    	jbe    f0103308 <debuginfo_eip+0x1e6>
f0103180:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0103183:	c7 c0 69 d5 10 f0    	mov    $0xf010d569,%eax
f0103189:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f010318d:	0f 85 7c 01 00 00    	jne    f010330f <debuginfo_eip+0x1ed>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0103193:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f010319a:	c7 c0 c8 50 10 f0    	mov    $0xf01050c8,%eax
f01031a0:	c7 c2 4c b7 10 f0    	mov    $0xf010b74c,%edx
f01031a6:	29 c2                	sub    %eax,%edx
f01031a8:	c1 fa 02             	sar    $0x2,%edx
f01031ab:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f01031b1:	83 ea 01             	sub    $0x1,%edx
f01031b4:	89 55 e0             	mov    %edx,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01031b7:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f01031ba:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01031bd:	83 ec 08             	sub    $0x8,%esp
f01031c0:	53                   	push   %ebx
f01031c1:	6a 64                	push   $0x64
f01031c3:	e8 6a fe ff ff       	call   f0103032 <stab_binsearch>
	if (lfile == 0)
f01031c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01031cb:	83 c4 10             	add    $0x10,%esp
f01031ce:	85 c0                	test   %eax,%eax
f01031d0:	0f 84 40 01 00 00    	je     f0103316 <debuginfo_eip+0x1f4>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f01031d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f01031d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01031dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f01031df:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f01031e2:	8d 55 dc             	lea    -0x24(%ebp),%edx
f01031e5:	83 ec 08             	sub    $0x8,%esp
f01031e8:	53                   	push   %ebx
f01031e9:	6a 24                	push   $0x24
f01031eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
f01031ee:	c7 c0 c8 50 10 f0    	mov    $0xf01050c8,%eax
f01031f4:	e8 39 fe ff ff       	call   f0103032 <stab_binsearch>

	if (lfun <= rfun) {
f01031f9:	8b 75 dc             	mov    -0x24(%ebp),%esi
f01031fc:	83 c4 10             	add    $0x10,%esp
f01031ff:	3b 75 d8             	cmp    -0x28(%ebp),%esi
f0103202:	7f 79                	jg     f010327d <debuginfo_eip+0x15b>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0103204:	8d 04 76             	lea    (%esi,%esi,2),%eax
f0103207:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010320a:	c7 c2 c8 50 10 f0    	mov    $0xf01050c8,%edx
f0103210:	8d 0c 82             	lea    (%edx,%eax,4),%ecx
f0103213:	8b 11                	mov    (%ecx),%edx
f0103215:	c7 c0 69 d5 10 f0    	mov    $0xf010d569,%eax
f010321b:	81 e8 4d b7 10 f0    	sub    $0xf010b74d,%eax
f0103221:	39 c2                	cmp    %eax,%edx
f0103223:	73 09                	jae    f010322e <debuginfo_eip+0x10c>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0103225:	81 c2 4d b7 10 f0    	add    $0xf010b74d,%edx
f010322b:	89 57 08             	mov    %edx,0x8(%edi)
		info->eip_fn_addr = stabs[lfun].n_value;
f010322e:	8b 41 08             	mov    0x8(%ecx),%eax
f0103231:	89 47 10             	mov    %eax,0x10(%edi)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0103234:	83 ec 08             	sub    $0x8,%esp
f0103237:	6a 3a                	push   $0x3a
f0103239:	ff 77 08             	pushl  0x8(%edi)
f010323c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f010323f:	e8 1a 09 00 00       	call   f0103b5e <strfind>
f0103244:	2b 47 08             	sub    0x8(%edi),%eax
f0103247:	89 47 0c             	mov    %eax,0xc(%edi)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f010324a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010324d:	8d 04 76             	lea    (%esi,%esi,2),%eax
f0103250:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103253:	c7 c2 c8 50 10 f0    	mov    $0xf01050c8,%edx
f0103259:	8d 44 82 04          	lea    0x4(%edx,%eax,4),%eax
f010325d:	83 c4 10             	add    $0x10,%esp
f0103260:	eb 29                	jmp    f010328b <debuginfo_eip+0x169>
  	        panic("User address");
f0103262:	83 ec 04             	sub    $0x4,%esp
f0103265:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0103268:	8d 83 ae db fe ff    	lea    -0x12452(%ebx),%eax
f010326e:	50                   	push   %eax
f010326f:	6a 7f                	push   $0x7f
f0103271:	8d 83 bb db fe ff    	lea    -0x12445(%ebx),%eax
f0103277:	50                   	push   %eax
f0103278:	e8 1c ce ff ff       	call   f0100099 <_panic>
		info->eip_fn_addr = addr;
f010327d:	89 5f 10             	mov    %ebx,0x10(%edi)
		lline = lfile;
f0103280:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0103283:	eb af                	jmp    f0103234 <debuginfo_eip+0x112>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0103285:	83 ee 01             	sub    $0x1,%esi
f0103288:	83 e8 0c             	sub    $0xc,%eax
	while (lline >= lfile
f010328b:	39 f3                	cmp    %esi,%ebx
f010328d:	7f 3a                	jg     f01032c9 <debuginfo_eip+0x1a7>
	       && stabs[lline].n_type != N_SOL
f010328f:	0f b6 10             	movzbl (%eax),%edx
f0103292:	80 fa 84             	cmp    $0x84,%dl
f0103295:	74 0b                	je     f01032a2 <debuginfo_eip+0x180>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0103297:	80 fa 64             	cmp    $0x64,%dl
f010329a:	75 e9                	jne    f0103285 <debuginfo_eip+0x163>
f010329c:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f01032a0:	74 e3                	je     f0103285 <debuginfo_eip+0x163>
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01032a2:	8d 14 76             	lea    (%esi,%esi,2),%edx
f01032a5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01032a8:	c7 c0 c8 50 10 f0    	mov    $0xf01050c8,%eax
f01032ae:	8b 14 90             	mov    (%eax,%edx,4),%edx
f01032b1:	c7 c0 69 d5 10 f0    	mov    $0xf010d569,%eax
f01032b7:	81 e8 4d b7 10 f0    	sub    $0xf010b74d,%eax
f01032bd:	39 c2                	cmp    %eax,%edx
f01032bf:	73 08                	jae    f01032c9 <debuginfo_eip+0x1a7>
		info->eip_file = stabstr + stabs[lline].n_strx;
f01032c1:	81 c2 4d b7 10 f0    	add    $0xf010b74d,%edx
f01032c7:	89 17                	mov    %edx,(%edi)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f01032c9:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f01032cc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f01032cf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f01032d4:	39 cb                	cmp    %ecx,%ebx
f01032d6:	7d 4a                	jge    f0103322 <debuginfo_eip+0x200>
		for (lline = lfun + 1;
f01032d8:	8d 53 01             	lea    0x1(%ebx),%edx
f01032db:	8d 1c 5b             	lea    (%ebx,%ebx,2),%ebx
f01032de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01032e1:	c7 c0 c8 50 10 f0    	mov    $0xf01050c8,%eax
f01032e7:	8d 44 98 10          	lea    0x10(%eax,%ebx,4),%eax
f01032eb:	eb 07                	jmp    f01032f4 <debuginfo_eip+0x1d2>
			info->eip_fn_narg++;
f01032ed:	83 47 14 01          	addl   $0x1,0x14(%edi)
		     lline++)
f01032f1:	83 c2 01             	add    $0x1,%edx
		for (lline = lfun + 1;
f01032f4:	39 d1                	cmp    %edx,%ecx
f01032f6:	74 25                	je     f010331d <debuginfo_eip+0x1fb>
f01032f8:	83 c0 0c             	add    $0xc,%eax
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01032fb:	80 78 f4 a0          	cmpb   $0xa0,-0xc(%eax)
f01032ff:	74 ec                	je     f01032ed <debuginfo_eip+0x1cb>
	return 0;
f0103301:	b8 00 00 00 00       	mov    $0x0,%eax
f0103306:	eb 1a                	jmp    f0103322 <debuginfo_eip+0x200>
		return -1;
f0103308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010330d:	eb 13                	jmp    f0103322 <debuginfo_eip+0x200>
f010330f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103314:	eb 0c                	jmp    f0103322 <debuginfo_eip+0x200>
		return -1;
f0103316:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010331b:	eb 05                	jmp    f0103322 <debuginfo_eip+0x200>
	return 0;
f010331d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103322:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103325:	5b                   	pop    %ebx
f0103326:	5e                   	pop    %esi
f0103327:	5f                   	pop    %edi
f0103328:	5d                   	pop    %ebp
f0103329:	c3                   	ret    

f010332a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f010332a:	55                   	push   %ebp
f010332b:	89 e5                	mov    %esp,%ebp
f010332d:	57                   	push   %edi
f010332e:	56                   	push   %esi
f010332f:	53                   	push   %ebx
f0103330:	83 ec 2c             	sub    $0x2c,%esp
f0103333:	e8 57 fc ff ff       	call   f0102f8f <__x86.get_pc_thunk.cx>
f0103338:	81 c1 d4 3f 01 00    	add    $0x13fd4,%ecx
f010333e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0103341:	89 c7                	mov    %eax,%edi
f0103343:	89 d6                	mov    %edx,%esi
f0103345:	8b 45 08             	mov    0x8(%ebp),%eax
f0103348:	8b 55 0c             	mov    0xc(%ebp),%edx
f010334b:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010334e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0103351:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0103354:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103359:	89 4d d8             	mov    %ecx,-0x28(%ebp)
f010335c:	89 5d dc             	mov    %ebx,-0x24(%ebp)
f010335f:	39 d3                	cmp    %edx,%ebx
f0103361:	72 09                	jb     f010336c <printnum+0x42>
f0103363:	39 45 10             	cmp    %eax,0x10(%ebp)
f0103366:	0f 87 83 00 00 00    	ja     f01033ef <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010336c:	83 ec 0c             	sub    $0xc,%esp
f010336f:	ff 75 18             	pushl  0x18(%ebp)
f0103372:	8b 45 14             	mov    0x14(%ebp),%eax
f0103375:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0103378:	53                   	push   %ebx
f0103379:	ff 75 10             	pushl  0x10(%ebp)
f010337c:	83 ec 08             	sub    $0x8,%esp
f010337f:	ff 75 dc             	pushl  -0x24(%ebp)
f0103382:	ff 75 d8             	pushl  -0x28(%ebp)
f0103385:	ff 75 d4             	pushl  -0x2c(%ebp)
f0103388:	ff 75 d0             	pushl  -0x30(%ebp)
f010338b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010338e:	e8 ed 09 00 00       	call   f0103d80 <__udivdi3>
f0103393:	83 c4 18             	add    $0x18,%esp
f0103396:	52                   	push   %edx
f0103397:	50                   	push   %eax
f0103398:	89 f2                	mov    %esi,%edx
f010339a:	89 f8                	mov    %edi,%eax
f010339c:	e8 89 ff ff ff       	call   f010332a <printnum>
f01033a1:	83 c4 20             	add    $0x20,%esp
f01033a4:	eb 13                	jmp    f01033b9 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01033a6:	83 ec 08             	sub    $0x8,%esp
f01033a9:	56                   	push   %esi
f01033aa:	ff 75 18             	pushl  0x18(%ebp)
f01033ad:	ff d7                	call   *%edi
f01033af:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f01033b2:	83 eb 01             	sub    $0x1,%ebx
f01033b5:	85 db                	test   %ebx,%ebx
f01033b7:	7f ed                	jg     f01033a6 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01033b9:	83 ec 08             	sub    $0x8,%esp
f01033bc:	56                   	push   %esi
f01033bd:	83 ec 04             	sub    $0x4,%esp
f01033c0:	ff 75 dc             	pushl  -0x24(%ebp)
f01033c3:	ff 75 d8             	pushl  -0x28(%ebp)
f01033c6:	ff 75 d4             	pushl  -0x2c(%ebp)
f01033c9:	ff 75 d0             	pushl  -0x30(%ebp)
f01033cc:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01033cf:	89 f3                	mov    %esi,%ebx
f01033d1:	e8 ca 0a 00 00       	call   f0103ea0 <__umoddi3>
f01033d6:	83 c4 14             	add    $0x14,%esp
f01033d9:	0f be 84 06 c9 db fe 	movsbl -0x12437(%esi,%eax,1),%eax
f01033e0:	ff 
f01033e1:	50                   	push   %eax
f01033e2:	ff d7                	call   *%edi
}
f01033e4:	83 c4 10             	add    $0x10,%esp
f01033e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01033ea:	5b                   	pop    %ebx
f01033eb:	5e                   	pop    %esi
f01033ec:	5f                   	pop    %edi
f01033ed:	5d                   	pop    %ebp
f01033ee:	c3                   	ret    
f01033ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
f01033f2:	eb be                	jmp    f01033b2 <printnum+0x88>

f01033f4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01033f4:	55                   	push   %ebp
f01033f5:	89 e5                	mov    %esp,%ebp
f01033f7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01033fa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01033fe:	8b 10                	mov    (%eax),%edx
f0103400:	3b 50 04             	cmp    0x4(%eax),%edx
f0103403:	73 0a                	jae    f010340f <sprintputch+0x1b>
		*b->buf++ = ch;
f0103405:	8d 4a 01             	lea    0x1(%edx),%ecx
f0103408:	89 08                	mov    %ecx,(%eax)
f010340a:	8b 45 08             	mov    0x8(%ebp),%eax
f010340d:	88 02                	mov    %al,(%edx)
}
f010340f:	5d                   	pop    %ebp
f0103410:	c3                   	ret    

f0103411 <printfmt>:
{
f0103411:	55                   	push   %ebp
f0103412:	89 e5                	mov    %esp,%ebp
f0103414:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0103417:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010341a:	50                   	push   %eax
f010341b:	ff 75 10             	pushl  0x10(%ebp)
f010341e:	ff 75 0c             	pushl  0xc(%ebp)
f0103421:	ff 75 08             	pushl  0x8(%ebp)
f0103424:	e8 05 00 00 00       	call   f010342e <vprintfmt>
}
f0103429:	83 c4 10             	add    $0x10,%esp
f010342c:	c9                   	leave  
f010342d:	c3                   	ret    

f010342e <vprintfmt>:
{
f010342e:	55                   	push   %ebp
f010342f:	89 e5                	mov    %esp,%ebp
f0103431:	57                   	push   %edi
f0103432:	56                   	push   %esi
f0103433:	53                   	push   %ebx
f0103434:	83 ec 2c             	sub    $0x2c,%esp
f0103437:	e8 13 cd ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f010343c:	81 c3 d0 3e 01 00    	add    $0x13ed0,%ebx
f0103442:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103445:	8b 7d 10             	mov    0x10(%ebp),%edi
f0103448:	e9 8e 03 00 00       	jmp    f01037db <.L35+0x48>
		padc = ' ';
f010344d:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f0103451:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0103458:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
f010345f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0103466:	b9 00 00 00 00       	mov    $0x0,%ecx
f010346b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010346e:	8d 47 01             	lea    0x1(%edi),%eax
f0103471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103474:	0f b6 17             	movzbl (%edi),%edx
f0103477:	8d 42 dd             	lea    -0x23(%edx),%eax
f010347a:	3c 55                	cmp    $0x55,%al
f010347c:	0f 87 e1 03 00 00    	ja     f0103863 <.L22>
f0103482:	0f b6 c0             	movzbl %al,%eax
f0103485:	89 d9                	mov    %ebx,%ecx
f0103487:	03 8c 83 54 dc fe ff 	add    -0x123ac(%ebx,%eax,4),%ecx
f010348e:	ff e1                	jmp    *%ecx

f0103490 <.L67>:
f0103490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0103493:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f0103497:	eb d5                	jmp    f010346e <vprintfmt+0x40>

f0103499 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
f0103499:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f010349c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f01034a0:	eb cc                	jmp    f010346e <vprintfmt+0x40>

f01034a2 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
f01034a2:	0f b6 d2             	movzbl %dl,%edx
f01034a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01034a8:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
f01034ad:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01034b0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01034b4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01034b7:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01034ba:	83 f9 09             	cmp    $0x9,%ecx
f01034bd:	77 55                	ja     f0103514 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
f01034bf:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f01034c2:	eb e9                	jmp    f01034ad <.L29+0xb>

f01034c4 <.L26>:
			precision = va_arg(ap, int);
f01034c4:	8b 45 14             	mov    0x14(%ebp),%eax
f01034c7:	8b 00                	mov    (%eax),%eax
f01034c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01034cc:	8b 45 14             	mov    0x14(%ebp),%eax
f01034cf:	8d 40 04             	lea    0x4(%eax),%eax
f01034d2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01034d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f01034d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01034dc:	79 90                	jns    f010346e <vprintfmt+0x40>
				width = precision, precision = -1;
f01034de:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01034e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01034e4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f01034eb:	eb 81                	jmp    f010346e <vprintfmt+0x40>

f01034ed <.L27>:
f01034ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01034f0:	85 c0                	test   %eax,%eax
f01034f2:	ba 00 00 00 00       	mov    $0x0,%edx
f01034f7:	0f 49 d0             	cmovns %eax,%edx
f01034fa:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01034fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103500:	e9 69 ff ff ff       	jmp    f010346e <vprintfmt+0x40>

f0103505 <.L23>:
f0103505:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0103508:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f010350f:	e9 5a ff ff ff       	jmp    f010346e <vprintfmt+0x40>
f0103514:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103517:	eb bf                	jmp    f01034d8 <.L26+0x14>

f0103519 <.L33>:
			lflag++;
f0103519:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010351d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0103520:	e9 49 ff ff ff       	jmp    f010346e <vprintfmt+0x40>

f0103525 <.L30>:
			putch(va_arg(ap, int), putdat);
f0103525:	8b 45 14             	mov    0x14(%ebp),%eax
f0103528:	8d 78 04             	lea    0x4(%eax),%edi
f010352b:	83 ec 08             	sub    $0x8,%esp
f010352e:	56                   	push   %esi
f010352f:	ff 30                	pushl  (%eax)
f0103531:	ff 55 08             	call   *0x8(%ebp)
			break;
f0103534:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0103537:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f010353a:	e9 99 02 00 00       	jmp    f01037d8 <.L35+0x45>

f010353f <.L32>:
			err = va_arg(ap, int);
f010353f:	8b 45 14             	mov    0x14(%ebp),%eax
f0103542:	8d 78 04             	lea    0x4(%eax),%edi
f0103545:	8b 00                	mov    (%eax),%eax
f0103547:	99                   	cltd   
f0103548:	31 d0                	xor    %edx,%eax
f010354a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010354c:	83 f8 06             	cmp    $0x6,%eax
f010354f:	7f 27                	jg     f0103578 <.L32+0x39>
f0103551:	8b 94 83 1c 1d 00 00 	mov    0x1d1c(%ebx,%eax,4),%edx
f0103558:	85 d2                	test   %edx,%edx
f010355a:	74 1c                	je     f0103578 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
f010355c:	52                   	push   %edx
f010355d:	8d 83 5d d1 fe ff    	lea    -0x12ea3(%ebx),%eax
f0103563:	50                   	push   %eax
f0103564:	56                   	push   %esi
f0103565:	ff 75 08             	pushl  0x8(%ebp)
f0103568:	e8 a4 fe ff ff       	call   f0103411 <printfmt>
f010356d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0103570:	89 7d 14             	mov    %edi,0x14(%ebp)
f0103573:	e9 60 02 00 00       	jmp    f01037d8 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
f0103578:	50                   	push   %eax
f0103579:	8d 83 e1 db fe ff    	lea    -0x1241f(%ebx),%eax
f010357f:	50                   	push   %eax
f0103580:	56                   	push   %esi
f0103581:	ff 75 08             	pushl  0x8(%ebp)
f0103584:	e8 88 fe ff ff       	call   f0103411 <printfmt>
f0103589:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010358c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f010358f:	e9 44 02 00 00       	jmp    f01037d8 <.L35+0x45>

f0103594 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
f0103594:	8b 45 14             	mov    0x14(%ebp),%eax
f0103597:	83 c0 04             	add    $0x4,%eax
f010359a:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010359d:	8b 45 14             	mov    0x14(%ebp),%eax
f01035a0:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f01035a2:	85 ff                	test   %edi,%edi
f01035a4:	8d 83 da db fe ff    	lea    -0x12426(%ebx),%eax
f01035aa:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f01035ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01035b1:	0f 8e b5 00 00 00    	jle    f010366c <.L36+0xd8>
f01035b7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f01035bb:	75 08                	jne    f01035c5 <.L36+0x31>
f01035bd:	89 75 0c             	mov    %esi,0xc(%ebp)
f01035c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
f01035c3:	eb 6d                	jmp    f0103632 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
f01035c5:	83 ec 08             	sub    $0x8,%esp
f01035c8:	ff 75 d0             	pushl  -0x30(%ebp)
f01035cb:	57                   	push   %edi
f01035cc:	e8 49 04 00 00       	call   f0103a1a <strnlen>
f01035d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01035d4:	29 c2                	sub    %eax,%edx
f01035d6:	89 55 c8             	mov    %edx,-0x38(%ebp)
f01035d9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f01035dc:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f01035e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01035e3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01035e6:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f01035e8:	eb 10                	jmp    f01035fa <.L36+0x66>
					putch(padc, putdat);
f01035ea:	83 ec 08             	sub    $0x8,%esp
f01035ed:	56                   	push   %esi
f01035ee:	ff 75 e0             	pushl  -0x20(%ebp)
f01035f1:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f01035f4:	83 ef 01             	sub    $0x1,%edi
f01035f7:	83 c4 10             	add    $0x10,%esp
f01035fa:	85 ff                	test   %edi,%edi
f01035fc:	7f ec                	jg     f01035ea <.L36+0x56>
f01035fe:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0103601:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0103604:	85 d2                	test   %edx,%edx
f0103606:	b8 00 00 00 00       	mov    $0x0,%eax
f010360b:	0f 49 c2             	cmovns %edx,%eax
f010360e:	29 c2                	sub    %eax,%edx
f0103610:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0103613:	89 75 0c             	mov    %esi,0xc(%ebp)
f0103616:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0103619:	eb 17                	jmp    f0103632 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
f010361b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f010361f:	75 30                	jne    f0103651 <.L36+0xbd>
					putch(ch, putdat);
f0103621:	83 ec 08             	sub    $0x8,%esp
f0103624:	ff 75 0c             	pushl  0xc(%ebp)
f0103627:	50                   	push   %eax
f0103628:	ff 55 08             	call   *0x8(%ebp)
f010362b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010362e:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
f0103632:	83 c7 01             	add    $0x1,%edi
f0103635:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f0103639:	0f be c2             	movsbl %dl,%eax
f010363c:	85 c0                	test   %eax,%eax
f010363e:	74 52                	je     f0103692 <.L36+0xfe>
f0103640:	85 f6                	test   %esi,%esi
f0103642:	78 d7                	js     f010361b <.L36+0x87>
f0103644:	83 ee 01             	sub    $0x1,%esi
f0103647:	79 d2                	jns    f010361b <.L36+0x87>
f0103649:	8b 75 0c             	mov    0xc(%ebp),%esi
f010364c:	8b 7d e0             	mov    -0x20(%ebp),%edi
f010364f:	eb 32                	jmp    f0103683 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
f0103651:	0f be d2             	movsbl %dl,%edx
f0103654:	83 ea 20             	sub    $0x20,%edx
f0103657:	83 fa 5e             	cmp    $0x5e,%edx
f010365a:	76 c5                	jbe    f0103621 <.L36+0x8d>
					putch('?', putdat);
f010365c:	83 ec 08             	sub    $0x8,%esp
f010365f:	ff 75 0c             	pushl  0xc(%ebp)
f0103662:	6a 3f                	push   $0x3f
f0103664:	ff 55 08             	call   *0x8(%ebp)
f0103667:	83 c4 10             	add    $0x10,%esp
f010366a:	eb c2                	jmp    f010362e <.L36+0x9a>
f010366c:	89 75 0c             	mov    %esi,0xc(%ebp)
f010366f:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0103672:	eb be                	jmp    f0103632 <.L36+0x9e>
				putch(' ', putdat);
f0103674:	83 ec 08             	sub    $0x8,%esp
f0103677:	56                   	push   %esi
f0103678:	6a 20                	push   $0x20
f010367a:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
f010367d:	83 ef 01             	sub    $0x1,%edi
f0103680:	83 c4 10             	add    $0x10,%esp
f0103683:	85 ff                	test   %edi,%edi
f0103685:	7f ed                	jg     f0103674 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
f0103687:	8b 45 cc             	mov    -0x34(%ebp),%eax
f010368a:	89 45 14             	mov    %eax,0x14(%ebp)
f010368d:	e9 46 01 00 00       	jmp    f01037d8 <.L35+0x45>
f0103692:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0103695:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103698:	eb e9                	jmp    f0103683 <.L36+0xef>

f010369a <.L31>:
f010369a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
f010369d:	83 f9 01             	cmp    $0x1,%ecx
f01036a0:	7e 40                	jle    f01036e2 <.L31+0x48>
		return va_arg(*ap, long long);
f01036a2:	8b 45 14             	mov    0x14(%ebp),%eax
f01036a5:	8b 50 04             	mov    0x4(%eax),%edx
f01036a8:	8b 00                	mov    (%eax),%eax
f01036aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01036ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01036b0:	8b 45 14             	mov    0x14(%ebp),%eax
f01036b3:	8d 40 08             	lea    0x8(%eax),%eax
f01036b6:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01036b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01036bd:	79 55                	jns    f0103714 <.L31+0x7a>
				putch('-', putdat);
f01036bf:	83 ec 08             	sub    $0x8,%esp
f01036c2:	56                   	push   %esi
f01036c3:	6a 2d                	push   $0x2d
f01036c5:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01036c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01036cb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01036ce:	f7 da                	neg    %edx
f01036d0:	83 d1 00             	adc    $0x0,%ecx
f01036d3:	f7 d9                	neg    %ecx
f01036d5:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01036d8:	b8 0a 00 00 00       	mov    $0xa,%eax
f01036dd:	e9 db 00 00 00       	jmp    f01037bd <.L35+0x2a>
	else if (lflag)
f01036e2:	85 c9                	test   %ecx,%ecx
f01036e4:	75 17                	jne    f01036fd <.L31+0x63>
		return va_arg(*ap, int);
f01036e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01036e9:	8b 00                	mov    (%eax),%eax
f01036eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01036ee:	99                   	cltd   
f01036ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01036f2:	8b 45 14             	mov    0x14(%ebp),%eax
f01036f5:	8d 40 04             	lea    0x4(%eax),%eax
f01036f8:	89 45 14             	mov    %eax,0x14(%ebp)
f01036fb:	eb bc                	jmp    f01036b9 <.L31+0x1f>
		return va_arg(*ap, long);
f01036fd:	8b 45 14             	mov    0x14(%ebp),%eax
f0103700:	8b 00                	mov    (%eax),%eax
f0103702:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103705:	99                   	cltd   
f0103706:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0103709:	8b 45 14             	mov    0x14(%ebp),%eax
f010370c:	8d 40 04             	lea    0x4(%eax),%eax
f010370f:	89 45 14             	mov    %eax,0x14(%ebp)
f0103712:	eb a5                	jmp    f01036b9 <.L31+0x1f>
			num = getint(&ap, lflag);
f0103714:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103717:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f010371a:	b8 0a 00 00 00       	mov    $0xa,%eax
f010371f:	e9 99 00 00 00       	jmp    f01037bd <.L35+0x2a>

f0103724 <.L37>:
f0103724:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
f0103727:	83 f9 01             	cmp    $0x1,%ecx
f010372a:	7e 15                	jle    f0103741 <.L37+0x1d>
		return va_arg(*ap, unsigned long long);
f010372c:	8b 45 14             	mov    0x14(%ebp),%eax
f010372f:	8b 10                	mov    (%eax),%edx
f0103731:	8b 48 04             	mov    0x4(%eax),%ecx
f0103734:	8d 40 08             	lea    0x8(%eax),%eax
f0103737:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010373a:	b8 0a 00 00 00       	mov    $0xa,%eax
f010373f:	eb 7c                	jmp    f01037bd <.L35+0x2a>
	else if (lflag)
f0103741:	85 c9                	test   %ecx,%ecx
f0103743:	75 17                	jne    f010375c <.L37+0x38>
		return va_arg(*ap, unsigned int);
f0103745:	8b 45 14             	mov    0x14(%ebp),%eax
f0103748:	8b 10                	mov    (%eax),%edx
f010374a:	b9 00 00 00 00       	mov    $0x0,%ecx
f010374f:	8d 40 04             	lea    0x4(%eax),%eax
f0103752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0103755:	b8 0a 00 00 00       	mov    $0xa,%eax
f010375a:	eb 61                	jmp    f01037bd <.L35+0x2a>
		return va_arg(*ap, unsigned long);
f010375c:	8b 45 14             	mov    0x14(%ebp),%eax
f010375f:	8b 10                	mov    (%eax),%edx
f0103761:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103766:	8d 40 04             	lea    0x4(%eax),%eax
f0103769:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010376c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0103771:	eb 4a                	jmp    f01037bd <.L35+0x2a>

f0103773 <.L34>:
			putch('X', putdat);
f0103773:	83 ec 08             	sub    $0x8,%esp
f0103776:	56                   	push   %esi
f0103777:	6a 58                	push   $0x58
f0103779:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
f010377c:	83 c4 08             	add    $0x8,%esp
f010377f:	56                   	push   %esi
f0103780:	6a 58                	push   $0x58
f0103782:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
f0103785:	83 c4 08             	add    $0x8,%esp
f0103788:	56                   	push   %esi
f0103789:	6a 58                	push   $0x58
f010378b:	ff 55 08             	call   *0x8(%ebp)
			break;
f010378e:	83 c4 10             	add    $0x10,%esp
f0103791:	eb 45                	jmp    f01037d8 <.L35+0x45>

f0103793 <.L35>:
			putch('0', putdat);
f0103793:	83 ec 08             	sub    $0x8,%esp
f0103796:	56                   	push   %esi
f0103797:	6a 30                	push   $0x30
f0103799:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f010379c:	83 c4 08             	add    $0x8,%esp
f010379f:	56                   	push   %esi
f01037a0:	6a 78                	push   $0x78
f01037a2:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f01037a5:	8b 45 14             	mov    0x14(%ebp),%eax
f01037a8:	8b 10                	mov    (%eax),%edx
f01037aa:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f01037af:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01037b2:	8d 40 04             	lea    0x4(%eax),%eax
f01037b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01037b8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01037bd:	83 ec 0c             	sub    $0xc,%esp
f01037c0:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f01037c4:	57                   	push   %edi
f01037c5:	ff 75 e0             	pushl  -0x20(%ebp)
f01037c8:	50                   	push   %eax
f01037c9:	51                   	push   %ecx
f01037ca:	52                   	push   %edx
f01037cb:	89 f2                	mov    %esi,%edx
f01037cd:	8b 45 08             	mov    0x8(%ebp),%eax
f01037d0:	e8 55 fb ff ff       	call   f010332a <printnum>
			break;
f01037d5:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f01037d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01037db:	83 c7 01             	add    $0x1,%edi
f01037de:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01037e2:	83 f8 25             	cmp    $0x25,%eax
f01037e5:	0f 84 62 fc ff ff    	je     f010344d <vprintfmt+0x1f>
			if (ch == '\0')
f01037eb:	85 c0                	test   %eax,%eax
f01037ed:	0f 84 91 00 00 00    	je     f0103884 <.L22+0x21>
			putch(ch, putdat);
f01037f3:	83 ec 08             	sub    $0x8,%esp
f01037f6:	56                   	push   %esi
f01037f7:	50                   	push   %eax
f01037f8:	ff 55 08             	call   *0x8(%ebp)
f01037fb:	83 c4 10             	add    $0x10,%esp
f01037fe:	eb db                	jmp    f01037db <.L35+0x48>

f0103800 <.L38>:
f0103800:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
f0103803:	83 f9 01             	cmp    $0x1,%ecx
f0103806:	7e 15                	jle    f010381d <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
f0103808:	8b 45 14             	mov    0x14(%ebp),%eax
f010380b:	8b 10                	mov    (%eax),%edx
f010380d:	8b 48 04             	mov    0x4(%eax),%ecx
f0103810:	8d 40 08             	lea    0x8(%eax),%eax
f0103813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0103816:	b8 10 00 00 00       	mov    $0x10,%eax
f010381b:	eb a0                	jmp    f01037bd <.L35+0x2a>
	else if (lflag)
f010381d:	85 c9                	test   %ecx,%ecx
f010381f:	75 17                	jne    f0103838 <.L38+0x38>
		return va_arg(*ap, unsigned int);
f0103821:	8b 45 14             	mov    0x14(%ebp),%eax
f0103824:	8b 10                	mov    (%eax),%edx
f0103826:	b9 00 00 00 00       	mov    $0x0,%ecx
f010382b:	8d 40 04             	lea    0x4(%eax),%eax
f010382e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0103831:	b8 10 00 00 00       	mov    $0x10,%eax
f0103836:	eb 85                	jmp    f01037bd <.L35+0x2a>
		return va_arg(*ap, unsigned long);
f0103838:	8b 45 14             	mov    0x14(%ebp),%eax
f010383b:	8b 10                	mov    (%eax),%edx
f010383d:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103842:	8d 40 04             	lea    0x4(%eax),%eax
f0103845:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0103848:	b8 10 00 00 00       	mov    $0x10,%eax
f010384d:	e9 6b ff ff ff       	jmp    f01037bd <.L35+0x2a>

f0103852 <.L25>:
			putch(ch, putdat);
f0103852:	83 ec 08             	sub    $0x8,%esp
f0103855:	56                   	push   %esi
f0103856:	6a 25                	push   $0x25
f0103858:	ff 55 08             	call   *0x8(%ebp)
			break;
f010385b:	83 c4 10             	add    $0x10,%esp
f010385e:	e9 75 ff ff ff       	jmp    f01037d8 <.L35+0x45>

f0103863 <.L22>:
			putch('%', putdat);
f0103863:	83 ec 08             	sub    $0x8,%esp
f0103866:	56                   	push   %esi
f0103867:	6a 25                	push   $0x25
f0103869:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f010386c:	83 c4 10             	add    $0x10,%esp
f010386f:	89 f8                	mov    %edi,%eax
f0103871:	eb 03                	jmp    f0103876 <.L22+0x13>
f0103873:	83 e8 01             	sub    $0x1,%eax
f0103876:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f010387a:	75 f7                	jne    f0103873 <.L22+0x10>
f010387c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010387f:	e9 54 ff ff ff       	jmp    f01037d8 <.L35+0x45>
}
f0103884:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103887:	5b                   	pop    %ebx
f0103888:	5e                   	pop    %esi
f0103889:	5f                   	pop    %edi
f010388a:	5d                   	pop    %ebp
f010388b:	c3                   	ret    

f010388c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010388c:	55                   	push   %ebp
f010388d:	89 e5                	mov    %esp,%ebp
f010388f:	53                   	push   %ebx
f0103890:	83 ec 14             	sub    $0x14,%esp
f0103893:	e8 b7 c8 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0103898:	81 c3 74 3a 01 00    	add    $0x13a74,%ebx
f010389e:	8b 45 08             	mov    0x8(%ebp),%eax
f01038a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01038a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01038a7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01038ab:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01038ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01038b5:	85 c0                	test   %eax,%eax
f01038b7:	74 2b                	je     f01038e4 <vsnprintf+0x58>
f01038b9:	85 d2                	test   %edx,%edx
f01038bb:	7e 27                	jle    f01038e4 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01038bd:	ff 75 14             	pushl  0x14(%ebp)
f01038c0:	ff 75 10             	pushl  0x10(%ebp)
f01038c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01038c6:	50                   	push   %eax
f01038c7:	8d 83 e8 c0 fe ff    	lea    -0x13f18(%ebx),%eax
f01038cd:	50                   	push   %eax
f01038ce:	e8 5b fb ff ff       	call   f010342e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01038d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01038d6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01038d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01038dc:	83 c4 10             	add    $0x10,%esp
}
f01038df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01038e2:	c9                   	leave  
f01038e3:	c3                   	ret    
		return -E_INVAL;
f01038e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01038e9:	eb f4                	jmp    f01038df <vsnprintf+0x53>

f01038eb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01038eb:	55                   	push   %ebp
f01038ec:	89 e5                	mov    %esp,%ebp
f01038ee:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f01038f1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f01038f4:	50                   	push   %eax
f01038f5:	ff 75 10             	pushl  0x10(%ebp)
f01038f8:	ff 75 0c             	pushl  0xc(%ebp)
f01038fb:	ff 75 08             	pushl  0x8(%ebp)
f01038fe:	e8 89 ff ff ff       	call   f010388c <vsnprintf>
	va_end(ap);

	return rc;
}
f0103903:	c9                   	leave  
f0103904:	c3                   	ret    

f0103905 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0103905:	55                   	push   %ebp
f0103906:	89 e5                	mov    %esp,%ebp
f0103908:	57                   	push   %edi
f0103909:	56                   	push   %esi
f010390a:	53                   	push   %ebx
f010390b:	83 ec 1c             	sub    $0x1c,%esp
f010390e:	e8 3c c8 ff ff       	call   f010014f <__x86.get_pc_thunk.bx>
f0103913:	81 c3 f9 39 01 00    	add    $0x139f9,%ebx
f0103919:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f010391c:	85 c0                	test   %eax,%eax
f010391e:	74 13                	je     f0103933 <readline+0x2e>
		cprintf("%s", prompt);
f0103920:	83 ec 08             	sub    $0x8,%esp
f0103923:	50                   	push   %eax
f0103924:	8d 83 5d d1 fe ff    	lea    -0x12ea3(%ebx),%eax
f010392a:	50                   	push   %eax
f010392b:	e8 ee f6 ff ff       	call   f010301e <cprintf>
f0103930:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0103933:	83 ec 0c             	sub    $0xc,%esp
f0103936:	6a 00                	push   $0x0
f0103938:	e8 aa cd ff ff       	call   f01006e7 <iscons>
f010393d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103940:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0103943:	bf 00 00 00 00       	mov    $0x0,%edi
f0103948:	eb 46                	jmp    f0103990 <readline+0x8b>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f010394a:	83 ec 08             	sub    $0x8,%esp
f010394d:	50                   	push   %eax
f010394e:	8d 83 ac dd fe ff    	lea    -0x12254(%ebx),%eax
f0103954:	50                   	push   %eax
f0103955:	e8 c4 f6 ff ff       	call   f010301e <cprintf>
			return NULL;
f010395a:	83 c4 10             	add    $0x10,%esp
f010395d:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0103962:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103965:	5b                   	pop    %ebx
f0103966:	5e                   	pop    %esi
f0103967:	5f                   	pop    %edi
f0103968:	5d                   	pop    %ebp
f0103969:	c3                   	ret    
			if (echoing)
f010396a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010396e:	75 05                	jne    f0103975 <readline+0x70>
			i--;
f0103970:	83 ef 01             	sub    $0x1,%edi
f0103973:	eb 1b                	jmp    f0103990 <readline+0x8b>
				cputchar('\b');
f0103975:	83 ec 0c             	sub    $0xc,%esp
f0103978:	6a 08                	push   $0x8
f010397a:	e8 47 cd ff ff       	call   f01006c6 <cputchar>
f010397f:	83 c4 10             	add    $0x10,%esp
f0103982:	eb ec                	jmp    f0103970 <readline+0x6b>
			buf[i++] = c;
f0103984:	89 f0                	mov    %esi,%eax
f0103986:	88 84 3b b4 1f 00 00 	mov    %al,0x1fb4(%ebx,%edi,1)
f010398d:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
f0103990:	e8 41 cd ff ff       	call   f01006d6 <getchar>
f0103995:	89 c6                	mov    %eax,%esi
		if (c < 0) {
f0103997:	85 c0                	test   %eax,%eax
f0103999:	78 af                	js     f010394a <readline+0x45>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f010399b:	83 f8 08             	cmp    $0x8,%eax
f010399e:	0f 94 c2             	sete   %dl
f01039a1:	83 f8 7f             	cmp    $0x7f,%eax
f01039a4:	0f 94 c0             	sete   %al
f01039a7:	08 c2                	or     %al,%dl
f01039a9:	74 04                	je     f01039af <readline+0xaa>
f01039ab:	85 ff                	test   %edi,%edi
f01039ad:	7f bb                	jg     f010396a <readline+0x65>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01039af:	83 fe 1f             	cmp    $0x1f,%esi
f01039b2:	7e 1c                	jle    f01039d0 <readline+0xcb>
f01039b4:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
f01039ba:	7f 14                	jg     f01039d0 <readline+0xcb>
			if (echoing)
f01039bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01039c0:	74 c2                	je     f0103984 <readline+0x7f>
				cputchar(c);
f01039c2:	83 ec 0c             	sub    $0xc,%esp
f01039c5:	56                   	push   %esi
f01039c6:	e8 fb cc ff ff       	call   f01006c6 <cputchar>
f01039cb:	83 c4 10             	add    $0x10,%esp
f01039ce:	eb b4                	jmp    f0103984 <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
f01039d0:	83 fe 0a             	cmp    $0xa,%esi
f01039d3:	74 05                	je     f01039da <readline+0xd5>
f01039d5:	83 fe 0d             	cmp    $0xd,%esi
f01039d8:	75 b6                	jne    f0103990 <readline+0x8b>
			if (echoing)
f01039da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01039de:	75 13                	jne    f01039f3 <readline+0xee>
			buf[i] = 0;
f01039e0:	c6 84 3b b4 1f 00 00 	movb   $0x0,0x1fb4(%ebx,%edi,1)
f01039e7:	00 
			return buf;
f01039e8:	8d 83 b4 1f 00 00    	lea    0x1fb4(%ebx),%eax
f01039ee:	e9 6f ff ff ff       	jmp    f0103962 <readline+0x5d>
				cputchar('\n');
f01039f3:	83 ec 0c             	sub    $0xc,%esp
f01039f6:	6a 0a                	push   $0xa
f01039f8:	e8 c9 cc ff ff       	call   f01006c6 <cputchar>
f01039fd:	83 c4 10             	add    $0x10,%esp
f0103a00:	eb de                	jmp    f01039e0 <readline+0xdb>

f0103a02 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0103a02:	55                   	push   %ebp
f0103a03:	89 e5                	mov    %esp,%ebp
f0103a05:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0103a08:	b8 00 00 00 00       	mov    $0x0,%eax
f0103a0d:	eb 03                	jmp    f0103a12 <strlen+0x10>
		n++;
f0103a0f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f0103a12:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0103a16:	75 f7                	jne    f0103a0f <strlen+0xd>
	return n;
}
f0103a18:	5d                   	pop    %ebp
f0103a19:	c3                   	ret    

f0103a1a <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0103a1a:	55                   	push   %ebp
f0103a1b:	89 e5                	mov    %esp,%ebp
f0103a1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103a20:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0103a23:	b8 00 00 00 00       	mov    $0x0,%eax
f0103a28:	eb 03                	jmp    f0103a2d <strnlen+0x13>
		n++;
f0103a2a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0103a2d:	39 d0                	cmp    %edx,%eax
f0103a2f:	74 06                	je     f0103a37 <strnlen+0x1d>
f0103a31:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0103a35:	75 f3                	jne    f0103a2a <strnlen+0x10>
	return n;
}
f0103a37:	5d                   	pop    %ebp
f0103a38:	c3                   	ret    

f0103a39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0103a39:	55                   	push   %ebp
f0103a3a:	89 e5                	mov    %esp,%ebp
f0103a3c:	53                   	push   %ebx
f0103a3d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103a40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0103a43:	89 c2                	mov    %eax,%edx
f0103a45:	83 c1 01             	add    $0x1,%ecx
f0103a48:	83 c2 01             	add    $0x1,%edx
f0103a4b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0103a4f:	88 5a ff             	mov    %bl,-0x1(%edx)
f0103a52:	84 db                	test   %bl,%bl
f0103a54:	75 ef                	jne    f0103a45 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0103a56:	5b                   	pop    %ebx
f0103a57:	5d                   	pop    %ebp
f0103a58:	c3                   	ret    

f0103a59 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0103a59:	55                   	push   %ebp
f0103a5a:	89 e5                	mov    %esp,%ebp
f0103a5c:	53                   	push   %ebx
f0103a5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0103a60:	53                   	push   %ebx
f0103a61:	e8 9c ff ff ff       	call   f0103a02 <strlen>
f0103a66:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f0103a69:	ff 75 0c             	pushl  0xc(%ebp)
f0103a6c:	01 d8                	add    %ebx,%eax
f0103a6e:	50                   	push   %eax
f0103a6f:	e8 c5 ff ff ff       	call   f0103a39 <strcpy>
	return dst;
}
f0103a74:	89 d8                	mov    %ebx,%eax
f0103a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103a79:	c9                   	leave  
f0103a7a:	c3                   	ret    

f0103a7b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0103a7b:	55                   	push   %ebp
f0103a7c:	89 e5                	mov    %esp,%ebp
f0103a7e:	56                   	push   %esi
f0103a7f:	53                   	push   %ebx
f0103a80:	8b 75 08             	mov    0x8(%ebp),%esi
f0103a83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103a86:	89 f3                	mov    %esi,%ebx
f0103a88:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0103a8b:	89 f2                	mov    %esi,%edx
f0103a8d:	eb 0f                	jmp    f0103a9e <strncpy+0x23>
		*dst++ = *src;
f0103a8f:	83 c2 01             	add    $0x1,%edx
f0103a92:	0f b6 01             	movzbl (%ecx),%eax
f0103a95:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0103a98:	80 39 01             	cmpb   $0x1,(%ecx)
f0103a9b:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f0103a9e:	39 da                	cmp    %ebx,%edx
f0103aa0:	75 ed                	jne    f0103a8f <strncpy+0x14>
	}
	return ret;
}
f0103aa2:	89 f0                	mov    %esi,%eax
f0103aa4:	5b                   	pop    %ebx
f0103aa5:	5e                   	pop    %esi
f0103aa6:	5d                   	pop    %ebp
f0103aa7:	c3                   	ret    

f0103aa8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0103aa8:	55                   	push   %ebp
f0103aa9:	89 e5                	mov    %esp,%ebp
f0103aab:	56                   	push   %esi
f0103aac:	53                   	push   %ebx
f0103aad:	8b 75 08             	mov    0x8(%ebp),%esi
f0103ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103ab3:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0103ab6:	89 f0                	mov    %esi,%eax
f0103ab8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0103abc:	85 c9                	test   %ecx,%ecx
f0103abe:	75 0b                	jne    f0103acb <strlcpy+0x23>
f0103ac0:	eb 17                	jmp    f0103ad9 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0103ac2:	83 c2 01             	add    $0x1,%edx
f0103ac5:	83 c0 01             	add    $0x1,%eax
f0103ac8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f0103acb:	39 d8                	cmp    %ebx,%eax
f0103acd:	74 07                	je     f0103ad6 <strlcpy+0x2e>
f0103acf:	0f b6 0a             	movzbl (%edx),%ecx
f0103ad2:	84 c9                	test   %cl,%cl
f0103ad4:	75 ec                	jne    f0103ac2 <strlcpy+0x1a>
		*dst = '\0';
f0103ad6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0103ad9:	29 f0                	sub    %esi,%eax
}
f0103adb:	5b                   	pop    %ebx
f0103adc:	5e                   	pop    %esi
f0103add:	5d                   	pop    %ebp
f0103ade:	c3                   	ret    

f0103adf <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0103adf:	55                   	push   %ebp
f0103ae0:	89 e5                	mov    %esp,%ebp
f0103ae2:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0103ae8:	eb 06                	jmp    f0103af0 <strcmp+0x11>
		p++, q++;
f0103aea:	83 c1 01             	add    $0x1,%ecx
f0103aed:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f0103af0:	0f b6 01             	movzbl (%ecx),%eax
f0103af3:	84 c0                	test   %al,%al
f0103af5:	74 04                	je     f0103afb <strcmp+0x1c>
f0103af7:	3a 02                	cmp    (%edx),%al
f0103af9:	74 ef                	je     f0103aea <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0103afb:	0f b6 c0             	movzbl %al,%eax
f0103afe:	0f b6 12             	movzbl (%edx),%edx
f0103b01:	29 d0                	sub    %edx,%eax
}
f0103b03:	5d                   	pop    %ebp
f0103b04:	c3                   	ret    

f0103b05 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0103b05:	55                   	push   %ebp
f0103b06:	89 e5                	mov    %esp,%ebp
f0103b08:	53                   	push   %ebx
f0103b09:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103b0f:	89 c3                	mov    %eax,%ebx
f0103b11:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0103b14:	eb 06                	jmp    f0103b1c <strncmp+0x17>
		n--, p++, q++;
f0103b16:	83 c0 01             	add    $0x1,%eax
f0103b19:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0103b1c:	39 d8                	cmp    %ebx,%eax
f0103b1e:	74 16                	je     f0103b36 <strncmp+0x31>
f0103b20:	0f b6 08             	movzbl (%eax),%ecx
f0103b23:	84 c9                	test   %cl,%cl
f0103b25:	74 04                	je     f0103b2b <strncmp+0x26>
f0103b27:	3a 0a                	cmp    (%edx),%cl
f0103b29:	74 eb                	je     f0103b16 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0103b2b:	0f b6 00             	movzbl (%eax),%eax
f0103b2e:	0f b6 12             	movzbl (%edx),%edx
f0103b31:	29 d0                	sub    %edx,%eax
}
f0103b33:	5b                   	pop    %ebx
f0103b34:	5d                   	pop    %ebp
f0103b35:	c3                   	ret    
		return 0;
f0103b36:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b3b:	eb f6                	jmp    f0103b33 <strncmp+0x2e>

f0103b3d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0103b3d:	55                   	push   %ebp
f0103b3e:	89 e5                	mov    %esp,%ebp
f0103b40:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b43:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0103b47:	0f b6 10             	movzbl (%eax),%edx
f0103b4a:	84 d2                	test   %dl,%dl
f0103b4c:	74 09                	je     f0103b57 <strchr+0x1a>
		if (*s == c)
f0103b4e:	38 ca                	cmp    %cl,%dl
f0103b50:	74 0a                	je     f0103b5c <strchr+0x1f>
	for (; *s; s++)
f0103b52:	83 c0 01             	add    $0x1,%eax
f0103b55:	eb f0                	jmp    f0103b47 <strchr+0xa>
			return (char *) s;
	return 0;
f0103b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103b5c:	5d                   	pop    %ebp
f0103b5d:	c3                   	ret    

f0103b5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0103b5e:	55                   	push   %ebp
f0103b5f:	89 e5                	mov    %esp,%ebp
f0103b61:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0103b68:	eb 03                	jmp    f0103b6d <strfind+0xf>
f0103b6a:	83 c0 01             	add    $0x1,%eax
f0103b6d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0103b70:	38 ca                	cmp    %cl,%dl
f0103b72:	74 04                	je     f0103b78 <strfind+0x1a>
f0103b74:	84 d2                	test   %dl,%dl
f0103b76:	75 f2                	jne    f0103b6a <strfind+0xc>
			break;
	return (char *) s;
}
f0103b78:	5d                   	pop    %ebp
f0103b79:	c3                   	ret    

f0103b7a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0103b7a:	55                   	push   %ebp
f0103b7b:	89 e5                	mov    %esp,%ebp
f0103b7d:	57                   	push   %edi
f0103b7e:	56                   	push   %esi
f0103b7f:	53                   	push   %ebx
f0103b80:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103b83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0103b86:	85 c9                	test   %ecx,%ecx
f0103b88:	74 13                	je     f0103b9d <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0103b8a:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0103b90:	75 05                	jne    f0103b97 <memset+0x1d>
f0103b92:	f6 c1 03             	test   $0x3,%cl
f0103b95:	74 0d                	je     f0103ba4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0103b97:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103b9a:	fc                   	cld    
f0103b9b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0103b9d:	89 f8                	mov    %edi,%eax
f0103b9f:	5b                   	pop    %ebx
f0103ba0:	5e                   	pop    %esi
f0103ba1:	5f                   	pop    %edi
f0103ba2:	5d                   	pop    %ebp
f0103ba3:	c3                   	ret    
		c &= 0xFF;
f0103ba4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0103ba8:	89 d3                	mov    %edx,%ebx
f0103baa:	c1 e3 08             	shl    $0x8,%ebx
f0103bad:	89 d0                	mov    %edx,%eax
f0103baf:	c1 e0 18             	shl    $0x18,%eax
f0103bb2:	89 d6                	mov    %edx,%esi
f0103bb4:	c1 e6 10             	shl    $0x10,%esi
f0103bb7:	09 f0                	or     %esi,%eax
f0103bb9:	09 c2                	or     %eax,%edx
f0103bbb:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f0103bbd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0103bc0:	89 d0                	mov    %edx,%eax
f0103bc2:	fc                   	cld    
f0103bc3:	f3 ab                	rep stos %eax,%es:(%edi)
f0103bc5:	eb d6                	jmp    f0103b9d <memset+0x23>

f0103bc7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0103bc7:	55                   	push   %ebp
f0103bc8:	89 e5                	mov    %esp,%ebp
f0103bca:	57                   	push   %edi
f0103bcb:	56                   	push   %esi
f0103bcc:	8b 45 08             	mov    0x8(%ebp),%eax
f0103bcf:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103bd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0103bd5:	39 c6                	cmp    %eax,%esi
f0103bd7:	73 35                	jae    f0103c0e <memmove+0x47>
f0103bd9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0103bdc:	39 c2                	cmp    %eax,%edx
f0103bde:	76 2e                	jbe    f0103c0e <memmove+0x47>
		s += n;
		d += n;
f0103be0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0103be3:	89 d6                	mov    %edx,%esi
f0103be5:	09 fe                	or     %edi,%esi
f0103be7:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0103bed:	74 0c                	je     f0103bfb <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0103bef:	83 ef 01             	sub    $0x1,%edi
f0103bf2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0103bf5:	fd                   	std    
f0103bf6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0103bf8:	fc                   	cld    
f0103bf9:	eb 21                	jmp    f0103c1c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0103bfb:	f6 c1 03             	test   $0x3,%cl
f0103bfe:	75 ef                	jne    f0103bef <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0103c00:	83 ef 04             	sub    $0x4,%edi
f0103c03:	8d 72 fc             	lea    -0x4(%edx),%esi
f0103c06:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0103c09:	fd                   	std    
f0103c0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0103c0c:	eb ea                	jmp    f0103bf8 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0103c0e:	89 f2                	mov    %esi,%edx
f0103c10:	09 c2                	or     %eax,%edx
f0103c12:	f6 c2 03             	test   $0x3,%dl
f0103c15:	74 09                	je     f0103c20 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0103c17:	89 c7                	mov    %eax,%edi
f0103c19:	fc                   	cld    
f0103c1a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0103c1c:	5e                   	pop    %esi
f0103c1d:	5f                   	pop    %edi
f0103c1e:	5d                   	pop    %ebp
f0103c1f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0103c20:	f6 c1 03             	test   $0x3,%cl
f0103c23:	75 f2                	jne    f0103c17 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0103c25:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0103c28:	89 c7                	mov    %eax,%edi
f0103c2a:	fc                   	cld    
f0103c2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0103c2d:	eb ed                	jmp    f0103c1c <memmove+0x55>

f0103c2f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0103c2f:	55                   	push   %ebp
f0103c30:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f0103c32:	ff 75 10             	pushl  0x10(%ebp)
f0103c35:	ff 75 0c             	pushl  0xc(%ebp)
f0103c38:	ff 75 08             	pushl  0x8(%ebp)
f0103c3b:	e8 87 ff ff ff       	call   f0103bc7 <memmove>
}
f0103c40:	c9                   	leave  
f0103c41:	c3                   	ret    

f0103c42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0103c42:	55                   	push   %ebp
f0103c43:	89 e5                	mov    %esp,%ebp
f0103c45:	56                   	push   %esi
f0103c46:	53                   	push   %ebx
f0103c47:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103c4d:	89 c6                	mov    %eax,%esi
f0103c4f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0103c52:	39 f0                	cmp    %esi,%eax
f0103c54:	74 1c                	je     f0103c72 <memcmp+0x30>
		if (*s1 != *s2)
f0103c56:	0f b6 08             	movzbl (%eax),%ecx
f0103c59:	0f b6 1a             	movzbl (%edx),%ebx
f0103c5c:	38 d9                	cmp    %bl,%cl
f0103c5e:	75 08                	jne    f0103c68 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0103c60:	83 c0 01             	add    $0x1,%eax
f0103c63:	83 c2 01             	add    $0x1,%edx
f0103c66:	eb ea                	jmp    f0103c52 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0103c68:	0f b6 c1             	movzbl %cl,%eax
f0103c6b:	0f b6 db             	movzbl %bl,%ebx
f0103c6e:	29 d8                	sub    %ebx,%eax
f0103c70:	eb 05                	jmp    f0103c77 <memcmp+0x35>
	}

	return 0;
f0103c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103c77:	5b                   	pop    %ebx
f0103c78:	5e                   	pop    %esi
f0103c79:	5d                   	pop    %ebp
f0103c7a:	c3                   	ret    

f0103c7b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0103c7b:	55                   	push   %ebp
f0103c7c:	89 e5                	mov    %esp,%ebp
f0103c7e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0103c84:	89 c2                	mov    %eax,%edx
f0103c86:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0103c89:	39 d0                	cmp    %edx,%eax
f0103c8b:	73 09                	jae    f0103c96 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0103c8d:	38 08                	cmp    %cl,(%eax)
f0103c8f:	74 05                	je     f0103c96 <memfind+0x1b>
	for (; s < ends; s++)
f0103c91:	83 c0 01             	add    $0x1,%eax
f0103c94:	eb f3                	jmp    f0103c89 <memfind+0xe>
			break;
	return (void *) s;
}
f0103c96:	5d                   	pop    %ebp
f0103c97:	c3                   	ret    

f0103c98 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0103c98:	55                   	push   %ebp
f0103c99:	89 e5                	mov    %esp,%ebp
f0103c9b:	57                   	push   %edi
f0103c9c:	56                   	push   %esi
f0103c9d:	53                   	push   %ebx
f0103c9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103ca1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0103ca4:	eb 03                	jmp    f0103ca9 <strtol+0x11>
		s++;
f0103ca6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0103ca9:	0f b6 01             	movzbl (%ecx),%eax
f0103cac:	3c 20                	cmp    $0x20,%al
f0103cae:	74 f6                	je     f0103ca6 <strtol+0xe>
f0103cb0:	3c 09                	cmp    $0x9,%al
f0103cb2:	74 f2                	je     f0103ca6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0103cb4:	3c 2b                	cmp    $0x2b,%al
f0103cb6:	74 2e                	je     f0103ce6 <strtol+0x4e>
	int neg = 0;
f0103cb8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0103cbd:	3c 2d                	cmp    $0x2d,%al
f0103cbf:	74 2f                	je     f0103cf0 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0103cc1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0103cc7:	75 05                	jne    f0103cce <strtol+0x36>
f0103cc9:	80 39 30             	cmpb   $0x30,(%ecx)
f0103ccc:	74 2c                	je     f0103cfa <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0103cce:	85 db                	test   %ebx,%ebx
f0103cd0:	75 0a                	jne    f0103cdc <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0103cd2:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f0103cd7:	80 39 30             	cmpb   $0x30,(%ecx)
f0103cda:	74 28                	je     f0103d04 <strtol+0x6c>
		base = 10;
f0103cdc:	b8 00 00 00 00       	mov    $0x0,%eax
f0103ce1:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0103ce4:	eb 50                	jmp    f0103d36 <strtol+0x9e>
		s++;
f0103ce6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0103ce9:	bf 00 00 00 00       	mov    $0x0,%edi
f0103cee:	eb d1                	jmp    f0103cc1 <strtol+0x29>
		s++, neg = 1;
f0103cf0:	83 c1 01             	add    $0x1,%ecx
f0103cf3:	bf 01 00 00 00       	mov    $0x1,%edi
f0103cf8:	eb c7                	jmp    f0103cc1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0103cfa:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0103cfe:	74 0e                	je     f0103d0e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0103d00:	85 db                	test   %ebx,%ebx
f0103d02:	75 d8                	jne    f0103cdc <strtol+0x44>
		s++, base = 8;
f0103d04:	83 c1 01             	add    $0x1,%ecx
f0103d07:	bb 08 00 00 00       	mov    $0x8,%ebx
f0103d0c:	eb ce                	jmp    f0103cdc <strtol+0x44>
		s += 2, base = 16;
f0103d0e:	83 c1 02             	add    $0x2,%ecx
f0103d11:	bb 10 00 00 00       	mov    $0x10,%ebx
f0103d16:	eb c4                	jmp    f0103cdc <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0103d18:	8d 72 9f             	lea    -0x61(%edx),%esi
f0103d1b:	89 f3                	mov    %esi,%ebx
f0103d1d:	80 fb 19             	cmp    $0x19,%bl
f0103d20:	77 29                	ja     f0103d4b <strtol+0xb3>
			dig = *s - 'a' + 10;
f0103d22:	0f be d2             	movsbl %dl,%edx
f0103d25:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0103d28:	3b 55 10             	cmp    0x10(%ebp),%edx
f0103d2b:	7d 30                	jge    f0103d5d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0103d2d:	83 c1 01             	add    $0x1,%ecx
f0103d30:	0f af 45 10          	imul   0x10(%ebp),%eax
f0103d34:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0103d36:	0f b6 11             	movzbl (%ecx),%edx
f0103d39:	8d 72 d0             	lea    -0x30(%edx),%esi
f0103d3c:	89 f3                	mov    %esi,%ebx
f0103d3e:	80 fb 09             	cmp    $0x9,%bl
f0103d41:	77 d5                	ja     f0103d18 <strtol+0x80>
			dig = *s - '0';
f0103d43:	0f be d2             	movsbl %dl,%edx
f0103d46:	83 ea 30             	sub    $0x30,%edx
f0103d49:	eb dd                	jmp    f0103d28 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f0103d4b:	8d 72 bf             	lea    -0x41(%edx),%esi
f0103d4e:	89 f3                	mov    %esi,%ebx
f0103d50:	80 fb 19             	cmp    $0x19,%bl
f0103d53:	77 08                	ja     f0103d5d <strtol+0xc5>
			dig = *s - 'A' + 10;
f0103d55:	0f be d2             	movsbl %dl,%edx
f0103d58:	83 ea 37             	sub    $0x37,%edx
f0103d5b:	eb cb                	jmp    f0103d28 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f0103d5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0103d61:	74 05                	je     f0103d68 <strtol+0xd0>
		*endptr = (char *) s;
f0103d63:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103d66:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0103d68:	89 c2                	mov    %eax,%edx
f0103d6a:	f7 da                	neg    %edx
f0103d6c:	85 ff                	test   %edi,%edi
f0103d6e:	0f 45 c2             	cmovne %edx,%eax
}
f0103d71:	5b                   	pop    %ebx
f0103d72:	5e                   	pop    %esi
f0103d73:	5f                   	pop    %edi
f0103d74:	5d                   	pop    %ebp
f0103d75:	c3                   	ret    
f0103d76:	66 90                	xchg   %ax,%ax
f0103d78:	66 90                	xchg   %ax,%ax
f0103d7a:	66 90                	xchg   %ax,%ax
f0103d7c:	66 90                	xchg   %ax,%ax
f0103d7e:	66 90                	xchg   %ax,%ax

f0103d80 <__udivdi3>:
f0103d80:	55                   	push   %ebp
f0103d81:	57                   	push   %edi
f0103d82:	56                   	push   %esi
f0103d83:	53                   	push   %ebx
f0103d84:	83 ec 1c             	sub    $0x1c,%esp
f0103d87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0103d8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0103d8f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0103d93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0103d97:	85 d2                	test   %edx,%edx
f0103d99:	75 35                	jne    f0103dd0 <__udivdi3+0x50>
f0103d9b:	39 f3                	cmp    %esi,%ebx
f0103d9d:	0f 87 bd 00 00 00    	ja     f0103e60 <__udivdi3+0xe0>
f0103da3:	85 db                	test   %ebx,%ebx
f0103da5:	89 d9                	mov    %ebx,%ecx
f0103da7:	75 0b                	jne    f0103db4 <__udivdi3+0x34>
f0103da9:	b8 01 00 00 00       	mov    $0x1,%eax
f0103dae:	31 d2                	xor    %edx,%edx
f0103db0:	f7 f3                	div    %ebx
f0103db2:	89 c1                	mov    %eax,%ecx
f0103db4:	31 d2                	xor    %edx,%edx
f0103db6:	89 f0                	mov    %esi,%eax
f0103db8:	f7 f1                	div    %ecx
f0103dba:	89 c6                	mov    %eax,%esi
f0103dbc:	89 e8                	mov    %ebp,%eax
f0103dbe:	89 f7                	mov    %esi,%edi
f0103dc0:	f7 f1                	div    %ecx
f0103dc2:	89 fa                	mov    %edi,%edx
f0103dc4:	83 c4 1c             	add    $0x1c,%esp
f0103dc7:	5b                   	pop    %ebx
f0103dc8:	5e                   	pop    %esi
f0103dc9:	5f                   	pop    %edi
f0103dca:	5d                   	pop    %ebp
f0103dcb:	c3                   	ret    
f0103dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0103dd0:	39 f2                	cmp    %esi,%edx
f0103dd2:	77 7c                	ja     f0103e50 <__udivdi3+0xd0>
f0103dd4:	0f bd fa             	bsr    %edx,%edi
f0103dd7:	83 f7 1f             	xor    $0x1f,%edi
f0103dda:	0f 84 98 00 00 00    	je     f0103e78 <__udivdi3+0xf8>
f0103de0:	89 f9                	mov    %edi,%ecx
f0103de2:	b8 20 00 00 00       	mov    $0x20,%eax
f0103de7:	29 f8                	sub    %edi,%eax
f0103de9:	d3 e2                	shl    %cl,%edx
f0103deb:	89 54 24 08          	mov    %edx,0x8(%esp)
f0103def:	89 c1                	mov    %eax,%ecx
f0103df1:	89 da                	mov    %ebx,%edx
f0103df3:	d3 ea                	shr    %cl,%edx
f0103df5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0103df9:	09 d1                	or     %edx,%ecx
f0103dfb:	89 f2                	mov    %esi,%edx
f0103dfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0103e01:	89 f9                	mov    %edi,%ecx
f0103e03:	d3 e3                	shl    %cl,%ebx
f0103e05:	89 c1                	mov    %eax,%ecx
f0103e07:	d3 ea                	shr    %cl,%edx
f0103e09:	89 f9                	mov    %edi,%ecx
f0103e0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0103e0f:	d3 e6                	shl    %cl,%esi
f0103e11:	89 eb                	mov    %ebp,%ebx
f0103e13:	89 c1                	mov    %eax,%ecx
f0103e15:	d3 eb                	shr    %cl,%ebx
f0103e17:	09 de                	or     %ebx,%esi
f0103e19:	89 f0                	mov    %esi,%eax
f0103e1b:	f7 74 24 08          	divl   0x8(%esp)
f0103e1f:	89 d6                	mov    %edx,%esi
f0103e21:	89 c3                	mov    %eax,%ebx
f0103e23:	f7 64 24 0c          	mull   0xc(%esp)
f0103e27:	39 d6                	cmp    %edx,%esi
f0103e29:	72 0c                	jb     f0103e37 <__udivdi3+0xb7>
f0103e2b:	89 f9                	mov    %edi,%ecx
f0103e2d:	d3 e5                	shl    %cl,%ebp
f0103e2f:	39 c5                	cmp    %eax,%ebp
f0103e31:	73 5d                	jae    f0103e90 <__udivdi3+0x110>
f0103e33:	39 d6                	cmp    %edx,%esi
f0103e35:	75 59                	jne    f0103e90 <__udivdi3+0x110>
f0103e37:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0103e3a:	31 ff                	xor    %edi,%edi
f0103e3c:	89 fa                	mov    %edi,%edx
f0103e3e:	83 c4 1c             	add    $0x1c,%esp
f0103e41:	5b                   	pop    %ebx
f0103e42:	5e                   	pop    %esi
f0103e43:	5f                   	pop    %edi
f0103e44:	5d                   	pop    %ebp
f0103e45:	c3                   	ret    
f0103e46:	8d 76 00             	lea    0x0(%esi),%esi
f0103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0103e50:	31 ff                	xor    %edi,%edi
f0103e52:	31 c0                	xor    %eax,%eax
f0103e54:	89 fa                	mov    %edi,%edx
f0103e56:	83 c4 1c             	add    $0x1c,%esp
f0103e59:	5b                   	pop    %ebx
f0103e5a:	5e                   	pop    %esi
f0103e5b:	5f                   	pop    %edi
f0103e5c:	5d                   	pop    %ebp
f0103e5d:	c3                   	ret    
f0103e5e:	66 90                	xchg   %ax,%ax
f0103e60:	31 ff                	xor    %edi,%edi
f0103e62:	89 e8                	mov    %ebp,%eax
f0103e64:	89 f2                	mov    %esi,%edx
f0103e66:	f7 f3                	div    %ebx
f0103e68:	89 fa                	mov    %edi,%edx
f0103e6a:	83 c4 1c             	add    $0x1c,%esp
f0103e6d:	5b                   	pop    %ebx
f0103e6e:	5e                   	pop    %esi
f0103e6f:	5f                   	pop    %edi
f0103e70:	5d                   	pop    %ebp
f0103e71:	c3                   	ret    
f0103e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0103e78:	39 f2                	cmp    %esi,%edx
f0103e7a:	72 06                	jb     f0103e82 <__udivdi3+0x102>
f0103e7c:	31 c0                	xor    %eax,%eax
f0103e7e:	39 eb                	cmp    %ebp,%ebx
f0103e80:	77 d2                	ja     f0103e54 <__udivdi3+0xd4>
f0103e82:	b8 01 00 00 00       	mov    $0x1,%eax
f0103e87:	eb cb                	jmp    f0103e54 <__udivdi3+0xd4>
f0103e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0103e90:	89 d8                	mov    %ebx,%eax
f0103e92:	31 ff                	xor    %edi,%edi
f0103e94:	eb be                	jmp    f0103e54 <__udivdi3+0xd4>
f0103e96:	66 90                	xchg   %ax,%ax
f0103e98:	66 90                	xchg   %ax,%ax
f0103e9a:	66 90                	xchg   %ax,%ax
f0103e9c:	66 90                	xchg   %ax,%ax
f0103e9e:	66 90                	xchg   %ax,%ax

f0103ea0 <__umoddi3>:
f0103ea0:	55                   	push   %ebp
f0103ea1:	57                   	push   %edi
f0103ea2:	56                   	push   %esi
f0103ea3:	53                   	push   %ebx
f0103ea4:	83 ec 1c             	sub    $0x1c,%esp
f0103ea7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f0103eab:	8b 74 24 30          	mov    0x30(%esp),%esi
f0103eaf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0103eb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0103eb7:	85 ed                	test   %ebp,%ebp
f0103eb9:	89 f0                	mov    %esi,%eax
f0103ebb:	89 da                	mov    %ebx,%edx
f0103ebd:	75 19                	jne    f0103ed8 <__umoddi3+0x38>
f0103ebf:	39 df                	cmp    %ebx,%edi
f0103ec1:	0f 86 b1 00 00 00    	jbe    f0103f78 <__umoddi3+0xd8>
f0103ec7:	f7 f7                	div    %edi
f0103ec9:	89 d0                	mov    %edx,%eax
f0103ecb:	31 d2                	xor    %edx,%edx
f0103ecd:	83 c4 1c             	add    $0x1c,%esp
f0103ed0:	5b                   	pop    %ebx
f0103ed1:	5e                   	pop    %esi
f0103ed2:	5f                   	pop    %edi
f0103ed3:	5d                   	pop    %ebp
f0103ed4:	c3                   	ret    
f0103ed5:	8d 76 00             	lea    0x0(%esi),%esi
f0103ed8:	39 dd                	cmp    %ebx,%ebp
f0103eda:	77 f1                	ja     f0103ecd <__umoddi3+0x2d>
f0103edc:	0f bd cd             	bsr    %ebp,%ecx
f0103edf:	83 f1 1f             	xor    $0x1f,%ecx
f0103ee2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0103ee6:	0f 84 b4 00 00 00    	je     f0103fa0 <__umoddi3+0x100>
f0103eec:	b8 20 00 00 00       	mov    $0x20,%eax
f0103ef1:	89 c2                	mov    %eax,%edx
f0103ef3:	8b 44 24 04          	mov    0x4(%esp),%eax
f0103ef7:	29 c2                	sub    %eax,%edx
f0103ef9:	89 c1                	mov    %eax,%ecx
f0103efb:	89 f8                	mov    %edi,%eax
f0103efd:	d3 e5                	shl    %cl,%ebp
f0103eff:	89 d1                	mov    %edx,%ecx
f0103f01:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103f05:	d3 e8                	shr    %cl,%eax
f0103f07:	09 c5                	or     %eax,%ebp
f0103f09:	8b 44 24 04          	mov    0x4(%esp),%eax
f0103f0d:	89 c1                	mov    %eax,%ecx
f0103f0f:	d3 e7                	shl    %cl,%edi
f0103f11:	89 d1                	mov    %edx,%ecx
f0103f13:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0103f17:	89 df                	mov    %ebx,%edi
f0103f19:	d3 ef                	shr    %cl,%edi
f0103f1b:	89 c1                	mov    %eax,%ecx
f0103f1d:	89 f0                	mov    %esi,%eax
f0103f1f:	d3 e3                	shl    %cl,%ebx
f0103f21:	89 d1                	mov    %edx,%ecx
f0103f23:	89 fa                	mov    %edi,%edx
f0103f25:	d3 e8                	shr    %cl,%eax
f0103f27:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0103f2c:	09 d8                	or     %ebx,%eax
f0103f2e:	f7 f5                	div    %ebp
f0103f30:	d3 e6                	shl    %cl,%esi
f0103f32:	89 d1                	mov    %edx,%ecx
f0103f34:	f7 64 24 08          	mull   0x8(%esp)
f0103f38:	39 d1                	cmp    %edx,%ecx
f0103f3a:	89 c3                	mov    %eax,%ebx
f0103f3c:	89 d7                	mov    %edx,%edi
f0103f3e:	72 06                	jb     f0103f46 <__umoddi3+0xa6>
f0103f40:	75 0e                	jne    f0103f50 <__umoddi3+0xb0>
f0103f42:	39 c6                	cmp    %eax,%esi
f0103f44:	73 0a                	jae    f0103f50 <__umoddi3+0xb0>
f0103f46:	2b 44 24 08          	sub    0x8(%esp),%eax
f0103f4a:	19 ea                	sbb    %ebp,%edx
f0103f4c:	89 d7                	mov    %edx,%edi
f0103f4e:	89 c3                	mov    %eax,%ebx
f0103f50:	89 ca                	mov    %ecx,%edx
f0103f52:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f0103f57:	29 de                	sub    %ebx,%esi
f0103f59:	19 fa                	sbb    %edi,%edx
f0103f5b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f0103f5f:	89 d0                	mov    %edx,%eax
f0103f61:	d3 e0                	shl    %cl,%eax
f0103f63:	89 d9                	mov    %ebx,%ecx
f0103f65:	d3 ee                	shr    %cl,%esi
f0103f67:	d3 ea                	shr    %cl,%edx
f0103f69:	09 f0                	or     %esi,%eax
f0103f6b:	83 c4 1c             	add    $0x1c,%esp
f0103f6e:	5b                   	pop    %ebx
f0103f6f:	5e                   	pop    %esi
f0103f70:	5f                   	pop    %edi
f0103f71:	5d                   	pop    %ebp
f0103f72:	c3                   	ret    
f0103f73:	90                   	nop
f0103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0103f78:	85 ff                	test   %edi,%edi
f0103f7a:	89 f9                	mov    %edi,%ecx
f0103f7c:	75 0b                	jne    f0103f89 <__umoddi3+0xe9>
f0103f7e:	b8 01 00 00 00       	mov    $0x1,%eax
f0103f83:	31 d2                	xor    %edx,%edx
f0103f85:	f7 f7                	div    %edi
f0103f87:	89 c1                	mov    %eax,%ecx
f0103f89:	89 d8                	mov    %ebx,%eax
f0103f8b:	31 d2                	xor    %edx,%edx
f0103f8d:	f7 f1                	div    %ecx
f0103f8f:	89 f0                	mov    %esi,%eax
f0103f91:	f7 f1                	div    %ecx
f0103f93:	e9 31 ff ff ff       	jmp    f0103ec9 <__umoddi3+0x29>
f0103f98:	90                   	nop
f0103f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0103fa0:	39 dd                	cmp    %ebx,%ebp
f0103fa2:	72 08                	jb     f0103fac <__umoddi3+0x10c>
f0103fa4:	39 f7                	cmp    %esi,%edi
f0103fa6:	0f 87 21 ff ff ff    	ja     f0103ecd <__umoddi3+0x2d>
f0103fac:	89 da                	mov    %ebx,%edx
f0103fae:	89 f0                	mov    %esi,%eax
f0103fb0:	29 f8                	sub    %edi,%eax
f0103fb2:	19 ea                	sbb    %ebp,%edx
f0103fb4:	e9 14 ff ff ff       	jmp    f0103ecd <__umoddi3+0x2d>
