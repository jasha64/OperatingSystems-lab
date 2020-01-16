
obj/user/echo.debug：     文件格式 elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7f 07                	jg     800055 <umain+0x22>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80004e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800053:	eb 4c                	jmp    8000a1 <umain+0x6e>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	68 a0 1e 80 00       	push   $0x801ea0
  80005d:	ff 76 04             	pushl  0x4(%esi)
  800060:	e8 b4 01 00 00       	call   800219 <strcmp>
  800065:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  800068:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80006f:	85 c0                	test   %eax,%eax
  800071:	75 db                	jne    80004e <umain+0x1b>
		argc--;
  800073:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800076:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  800079:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800080:	eb cc                	jmp    80004e <umain+0x1b>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	ff 34 9e             	pushl  (%esi,%ebx,4)
  800088:	e8 af 00 00 00       	call   80013c <strlen>
  80008d:	83 c4 0c             	add    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	ff 34 9e             	pushl  (%esi,%ebx,4)
  800094:	6a 01                	push   $0x1
  800096:	e8 77 0a 00 00       	call   800b12 <write>
	for (i = 1; i < argc; i++) {
  80009b:	83 c3 01             	add    $0x1,%ebx
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	39 df                	cmp    %ebx,%edi
  8000a3:	7e 1b                	jle    8000c0 <umain+0x8d>
		if (i > 1)
  8000a5:	83 fb 01             	cmp    $0x1,%ebx
  8000a8:	7e d8                	jle    800082 <umain+0x4f>
			write(1, " ", 1);
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 01                	push   $0x1
  8000af:	68 a3 1e 80 00       	push   $0x801ea3
  8000b4:	6a 01                	push   $0x1
  8000b6:	e8 57 0a 00 00       	call   800b12 <write>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	eb c2                	jmp    800082 <umain+0x4f>
	}
	if (!nflag)
  8000c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c4:	74 08                	je     8000ce <umain+0x9b>
		write(1, "\n", 1);
}
  8000c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		write(1, "\n", 1);
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	6a 01                	push   $0x1
  8000d3:	68 b3 1f 80 00       	push   $0x801fb3
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 33 0a 00 00       	call   800b12 <write>
  8000df:	83 c4 10             	add    $0x10,%esp
}
  8000e2:	eb e2                	jmp    8000c6 <umain+0x93>

008000e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8000ef:	e8 3a 04 00 00       	call   80052e <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800101:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800106:	85 db                	test   %ebx,%ebx
  800108:	7e 07                	jle    800111 <libmain+0x2d>
		binaryname = argv[0];
  80010a:	8b 06                	mov    (%esi),%eax
  80010c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	e8 18 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011b:	e8 0a 00 00 00       	call   80012a <exit>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800130:	6a 00                	push   $0x0
  800132:	e8 b6 03 00 00       	call   8004ed <sys_env_destroy>
}
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    

0080013c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800142:	b8 00 00 00 00       	mov    $0x0,%eax
  800147:	eb 03                	jmp    80014c <strlen+0x10>
		n++;
  800149:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80014c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800150:	75 f7                	jne    800149 <strlen+0xd>
	return n;
}
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    

00800154 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	eb 03                	jmp    800167 <strnlen+0x13>
		n++;
  800164:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800167:	39 d0                	cmp    %edx,%eax
  800169:	74 06                	je     800171 <strnlen+0x1d>
  80016b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80016f:	75 f3                	jne    800164 <strnlen+0x10>
	return n;
}
  800171:	5d                   	pop    %ebp
  800172:	c3                   	ret    

00800173 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	53                   	push   %ebx
  800177:	8b 45 08             	mov    0x8(%ebp),%eax
  80017a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80017d:	89 c2                	mov    %eax,%edx
  80017f:	83 c1 01             	add    $0x1,%ecx
  800182:	83 c2 01             	add    $0x1,%edx
  800185:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800189:	88 5a ff             	mov    %bl,-0x1(%edx)
  80018c:	84 db                	test   %bl,%bl
  80018e:	75 ef                	jne    80017f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800190:	5b                   	pop    %ebx
  800191:	5d                   	pop    %ebp
  800192:	c3                   	ret    

00800193 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	53                   	push   %ebx
  800197:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80019a:	53                   	push   %ebx
  80019b:	e8 9c ff ff ff       	call   80013c <strlen>
  8001a0:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8001a3:	ff 75 0c             	pushl  0xc(%ebp)
  8001a6:	01 d8                	add    %ebx,%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 c5 ff ff ff       	call   800173 <strcpy>
	return dst;
}
  8001ae:	89 d8                	mov    %ebx,%eax
  8001b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	56                   	push   %esi
  8001b9:	53                   	push   %ebx
  8001ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8001bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c0:	89 f3                	mov    %esi,%ebx
  8001c2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001c5:	89 f2                	mov    %esi,%edx
  8001c7:	eb 0f                	jmp    8001d8 <strncpy+0x23>
		*dst++ = *src;
  8001c9:	83 c2 01             	add    $0x1,%edx
  8001cc:	0f b6 01             	movzbl (%ecx),%eax
  8001cf:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001d2:	80 39 01             	cmpb   $0x1,(%ecx)
  8001d5:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8001d8:	39 da                	cmp    %ebx,%edx
  8001da:	75 ed                	jne    8001c9 <strncpy+0x14>
	}
	return ret;
}
  8001dc:	89 f0                	mov    %esi,%eax
  8001de:	5b                   	pop    %ebx
  8001df:	5e                   	pop    %esi
  8001e0:	5d                   	pop    %ebp
  8001e1:	c3                   	ret    

008001e2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8001ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001f0:	89 f0                	mov    %esi,%eax
  8001f2:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8001f6:	85 c9                	test   %ecx,%ecx
  8001f8:	75 0b                	jne    800205 <strlcpy+0x23>
  8001fa:	eb 17                	jmp    800213 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8001fc:	83 c2 01             	add    $0x1,%edx
  8001ff:	83 c0 01             	add    $0x1,%eax
  800202:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800205:	39 d8                	cmp    %ebx,%eax
  800207:	74 07                	je     800210 <strlcpy+0x2e>
  800209:	0f b6 0a             	movzbl (%edx),%ecx
  80020c:	84 c9                	test   %cl,%cl
  80020e:	75 ec                	jne    8001fc <strlcpy+0x1a>
		*dst = '\0';
  800210:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800213:	29 f0                	sub    %esi,%eax
}
  800215:	5b                   	pop    %ebx
  800216:	5e                   	pop    %esi
  800217:	5d                   	pop    %ebp
  800218:	c3                   	ret    

00800219 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80021f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800222:	eb 06                	jmp    80022a <strcmp+0x11>
		p++, q++;
  800224:	83 c1 01             	add    $0x1,%ecx
  800227:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80022a:	0f b6 01             	movzbl (%ecx),%eax
  80022d:	84 c0                	test   %al,%al
  80022f:	74 04                	je     800235 <strcmp+0x1c>
  800231:	3a 02                	cmp    (%edx),%al
  800233:	74 ef                	je     800224 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800235:	0f b6 c0             	movzbl %al,%eax
  800238:	0f b6 12             	movzbl (%edx),%edx
  80023b:	29 d0                	sub    %edx,%eax
}
  80023d:	5d                   	pop    %ebp
  80023e:	c3                   	ret    

0080023f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	53                   	push   %ebx
  800243:	8b 45 08             	mov    0x8(%ebp),%eax
  800246:	8b 55 0c             	mov    0xc(%ebp),%edx
  800249:	89 c3                	mov    %eax,%ebx
  80024b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80024e:	eb 06                	jmp    800256 <strncmp+0x17>
		n--, p++, q++;
  800250:	83 c0 01             	add    $0x1,%eax
  800253:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800256:	39 d8                	cmp    %ebx,%eax
  800258:	74 16                	je     800270 <strncmp+0x31>
  80025a:	0f b6 08             	movzbl (%eax),%ecx
  80025d:	84 c9                	test   %cl,%cl
  80025f:	74 04                	je     800265 <strncmp+0x26>
  800261:	3a 0a                	cmp    (%edx),%cl
  800263:	74 eb                	je     800250 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800265:	0f b6 00             	movzbl (%eax),%eax
  800268:	0f b6 12             	movzbl (%edx),%edx
  80026b:	29 d0                	sub    %edx,%eax
}
  80026d:	5b                   	pop    %ebx
  80026e:	5d                   	pop    %ebp
  80026f:	c3                   	ret    
		return 0;
  800270:	b8 00 00 00 00       	mov    $0x0,%eax
  800275:	eb f6                	jmp    80026d <strncmp+0x2e>

00800277 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	8b 45 08             	mov    0x8(%ebp),%eax
  80027d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800281:	0f b6 10             	movzbl (%eax),%edx
  800284:	84 d2                	test   %dl,%dl
  800286:	74 09                	je     800291 <strchr+0x1a>
		if (*s == c)
  800288:	38 ca                	cmp    %cl,%dl
  80028a:	74 0a                	je     800296 <strchr+0x1f>
	for (; *s; s++)
  80028c:	83 c0 01             	add    $0x1,%eax
  80028f:	eb f0                	jmp    800281 <strchr+0xa>
			return (char *) s;
	return 0;
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    

00800298 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	8b 45 08             	mov    0x8(%ebp),%eax
  80029e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002a2:	eb 03                	jmp    8002a7 <strfind+0xf>
  8002a4:	83 c0 01             	add    $0x1,%eax
  8002a7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002aa:	38 ca                	cmp    %cl,%dl
  8002ac:	74 04                	je     8002b2 <strfind+0x1a>
  8002ae:	84 d2                	test   %dl,%dl
  8002b0:	75 f2                	jne    8002a4 <strfind+0xc>
			break;
	return (char *) s;
}
  8002b2:	5d                   	pop    %ebp
  8002b3:	c3                   	ret    

008002b4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	57                   	push   %edi
  8002b8:	56                   	push   %esi
  8002b9:	53                   	push   %ebx
  8002ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002c0:	85 c9                	test   %ecx,%ecx
  8002c2:	74 13                	je     8002d7 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002c4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8002ca:	75 05                	jne    8002d1 <memset+0x1d>
  8002cc:	f6 c1 03             	test   $0x3,%cl
  8002cf:	74 0d                	je     8002de <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8002d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d4:	fc                   	cld    
  8002d5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8002d7:	89 f8                	mov    %edi,%eax
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    
		c &= 0xFF;
  8002de:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8002e2:	89 d3                	mov    %edx,%ebx
  8002e4:	c1 e3 08             	shl    $0x8,%ebx
  8002e7:	89 d0                	mov    %edx,%eax
  8002e9:	c1 e0 18             	shl    $0x18,%eax
  8002ec:	89 d6                	mov    %edx,%esi
  8002ee:	c1 e6 10             	shl    $0x10,%esi
  8002f1:	09 f0                	or     %esi,%eax
  8002f3:	09 c2                	or     %eax,%edx
  8002f5:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8002f7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8002fa:	89 d0                	mov    %edx,%eax
  8002fc:	fc                   	cld    
  8002fd:	f3 ab                	rep stos %eax,%es:(%edi)
  8002ff:	eb d6                	jmp    8002d7 <memset+0x23>

00800301 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	57                   	push   %edi
  800305:	56                   	push   %esi
  800306:	8b 45 08             	mov    0x8(%ebp),%eax
  800309:	8b 75 0c             	mov    0xc(%ebp),%esi
  80030c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80030f:	39 c6                	cmp    %eax,%esi
  800311:	73 35                	jae    800348 <memmove+0x47>
  800313:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800316:	39 c2                	cmp    %eax,%edx
  800318:	76 2e                	jbe    800348 <memmove+0x47>
		s += n;
		d += n;
  80031a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80031d:	89 d6                	mov    %edx,%esi
  80031f:	09 fe                	or     %edi,%esi
  800321:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800327:	74 0c                	je     800335 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800329:	83 ef 01             	sub    $0x1,%edi
  80032c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80032f:	fd                   	std    
  800330:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800332:	fc                   	cld    
  800333:	eb 21                	jmp    800356 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800335:	f6 c1 03             	test   $0x3,%cl
  800338:	75 ef                	jne    800329 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80033a:	83 ef 04             	sub    $0x4,%edi
  80033d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800340:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800343:	fd                   	std    
  800344:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800346:	eb ea                	jmp    800332 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800348:	89 f2                	mov    %esi,%edx
  80034a:	09 c2                	or     %eax,%edx
  80034c:	f6 c2 03             	test   $0x3,%dl
  80034f:	74 09                	je     80035a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800351:	89 c7                	mov    %eax,%edi
  800353:	fc                   	cld    
  800354:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800356:	5e                   	pop    %esi
  800357:	5f                   	pop    %edi
  800358:	5d                   	pop    %ebp
  800359:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80035a:	f6 c1 03             	test   $0x3,%cl
  80035d:	75 f2                	jne    800351 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80035f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800362:	89 c7                	mov    %eax,%edi
  800364:	fc                   	cld    
  800365:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800367:	eb ed                	jmp    800356 <memmove+0x55>

00800369 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80036c:	ff 75 10             	pushl  0x10(%ebp)
  80036f:	ff 75 0c             	pushl  0xc(%ebp)
  800372:	ff 75 08             	pushl  0x8(%ebp)
  800375:	e8 87 ff ff ff       	call   800301 <memmove>
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	56                   	push   %esi
  800380:	53                   	push   %ebx
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	8b 55 0c             	mov    0xc(%ebp),%edx
  800387:	89 c6                	mov    %eax,%esi
  800389:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80038c:	39 f0                	cmp    %esi,%eax
  80038e:	74 1c                	je     8003ac <memcmp+0x30>
		if (*s1 != *s2)
  800390:	0f b6 08             	movzbl (%eax),%ecx
  800393:	0f b6 1a             	movzbl (%edx),%ebx
  800396:	38 d9                	cmp    %bl,%cl
  800398:	75 08                	jne    8003a2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80039a:	83 c0 01             	add    $0x1,%eax
  80039d:	83 c2 01             	add    $0x1,%edx
  8003a0:	eb ea                	jmp    80038c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8003a2:	0f b6 c1             	movzbl %cl,%eax
  8003a5:	0f b6 db             	movzbl %bl,%ebx
  8003a8:	29 d8                	sub    %ebx,%eax
  8003aa:	eb 05                	jmp    8003b1 <memcmp+0x35>
	}

	return 0;
  8003ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003b1:	5b                   	pop    %ebx
  8003b2:	5e                   	pop    %esi
  8003b3:	5d                   	pop    %ebp
  8003b4:	c3                   	ret    

008003b5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003be:	89 c2                	mov    %eax,%edx
  8003c0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8003c3:	39 d0                	cmp    %edx,%eax
  8003c5:	73 09                	jae    8003d0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8003c7:	38 08                	cmp    %cl,(%eax)
  8003c9:	74 05                	je     8003d0 <memfind+0x1b>
	for (; s < ends; s++)
  8003cb:	83 c0 01             	add    $0x1,%eax
  8003ce:	eb f3                	jmp    8003c3 <memfind+0xe>
			break;
	return (void *) s;
}
  8003d0:	5d                   	pop    %ebp
  8003d1:	c3                   	ret    

008003d2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8003d2:	55                   	push   %ebp
  8003d3:	89 e5                	mov    %esp,%ebp
  8003d5:	57                   	push   %edi
  8003d6:	56                   	push   %esi
  8003d7:	53                   	push   %ebx
  8003d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003db:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8003de:	eb 03                	jmp    8003e3 <strtol+0x11>
		s++;
  8003e0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8003e3:	0f b6 01             	movzbl (%ecx),%eax
  8003e6:	3c 20                	cmp    $0x20,%al
  8003e8:	74 f6                	je     8003e0 <strtol+0xe>
  8003ea:	3c 09                	cmp    $0x9,%al
  8003ec:	74 f2                	je     8003e0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8003ee:	3c 2b                	cmp    $0x2b,%al
  8003f0:	74 2e                	je     800420 <strtol+0x4e>
	int neg = 0;
  8003f2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8003f7:	3c 2d                	cmp    $0x2d,%al
  8003f9:	74 2f                	je     80042a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8003fb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800401:	75 05                	jne    800408 <strtol+0x36>
  800403:	80 39 30             	cmpb   $0x30,(%ecx)
  800406:	74 2c                	je     800434 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800408:	85 db                	test   %ebx,%ebx
  80040a:	75 0a                	jne    800416 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80040c:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800411:	80 39 30             	cmpb   $0x30,(%ecx)
  800414:	74 28                	je     80043e <strtol+0x6c>
		base = 10;
  800416:	b8 00 00 00 00       	mov    $0x0,%eax
  80041b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80041e:	eb 50                	jmp    800470 <strtol+0x9e>
		s++;
  800420:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800423:	bf 00 00 00 00       	mov    $0x0,%edi
  800428:	eb d1                	jmp    8003fb <strtol+0x29>
		s++, neg = 1;
  80042a:	83 c1 01             	add    $0x1,%ecx
  80042d:	bf 01 00 00 00       	mov    $0x1,%edi
  800432:	eb c7                	jmp    8003fb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800434:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800438:	74 0e                	je     800448 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80043a:	85 db                	test   %ebx,%ebx
  80043c:	75 d8                	jne    800416 <strtol+0x44>
		s++, base = 8;
  80043e:	83 c1 01             	add    $0x1,%ecx
  800441:	bb 08 00 00 00       	mov    $0x8,%ebx
  800446:	eb ce                	jmp    800416 <strtol+0x44>
		s += 2, base = 16;
  800448:	83 c1 02             	add    $0x2,%ecx
  80044b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800450:	eb c4                	jmp    800416 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800452:	8d 72 9f             	lea    -0x61(%edx),%esi
  800455:	89 f3                	mov    %esi,%ebx
  800457:	80 fb 19             	cmp    $0x19,%bl
  80045a:	77 29                	ja     800485 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80045c:	0f be d2             	movsbl %dl,%edx
  80045f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800462:	3b 55 10             	cmp    0x10(%ebp),%edx
  800465:	7d 30                	jge    800497 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800467:	83 c1 01             	add    $0x1,%ecx
  80046a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800470:	0f b6 11             	movzbl (%ecx),%edx
  800473:	8d 72 d0             	lea    -0x30(%edx),%esi
  800476:	89 f3                	mov    %esi,%ebx
  800478:	80 fb 09             	cmp    $0x9,%bl
  80047b:	77 d5                	ja     800452 <strtol+0x80>
			dig = *s - '0';
  80047d:	0f be d2             	movsbl %dl,%edx
  800480:	83 ea 30             	sub    $0x30,%edx
  800483:	eb dd                	jmp    800462 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800485:	8d 72 bf             	lea    -0x41(%edx),%esi
  800488:	89 f3                	mov    %esi,%ebx
  80048a:	80 fb 19             	cmp    $0x19,%bl
  80048d:	77 08                	ja     800497 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80048f:	0f be d2             	movsbl %dl,%edx
  800492:	83 ea 37             	sub    $0x37,%edx
  800495:	eb cb                	jmp    800462 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800497:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049b:	74 05                	je     8004a2 <strtol+0xd0>
		*endptr = (char *) s;
  80049d:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004a0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8004a2:	89 c2                	mov    %eax,%edx
  8004a4:	f7 da                	neg    %edx
  8004a6:	85 ff                	test   %edi,%edi
  8004a8:	0f 45 c2             	cmovne %edx,%eax
}
  8004ab:	5b                   	pop    %ebx
  8004ac:	5e                   	pop    %esi
  8004ad:	5f                   	pop    %edi
  8004ae:	5d                   	pop    %ebp
  8004af:	c3                   	ret    

008004b0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	57                   	push   %edi
  8004b4:	56                   	push   %esi
  8004b5:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8004b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8004be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c1:	89 c3                	mov    %eax,%ebx
  8004c3:	89 c7                	mov    %eax,%edi
  8004c5:	89 c6                	mov    %eax,%esi
  8004c7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004c9:	5b                   	pop    %ebx
  8004ca:	5e                   	pop    %esi
  8004cb:	5f                   	pop    %edi
  8004cc:	5d                   	pop    %ebp
  8004cd:	c3                   	ret    

008004ce <sys_cgetc>:

int
sys_cgetc(void)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	57                   	push   %edi
  8004d2:	56                   	push   %esi
  8004d3:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8004d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8004de:	89 d1                	mov    %edx,%ecx
  8004e0:	89 d3                	mov    %edx,%ebx
  8004e2:	89 d7                	mov    %edx,%edi
  8004e4:	89 d6                	mov    %edx,%esi
  8004e6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8004e8:	5b                   	pop    %ebx
  8004e9:	5e                   	pop    %esi
  8004ea:	5f                   	pop    %edi
  8004eb:	5d                   	pop    %ebp
  8004ec:	c3                   	ret    

008004ed <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	57                   	push   %edi
  8004f1:	56                   	push   %esi
  8004f2:	53                   	push   %ebx
  8004f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8004f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8004fe:	b8 03 00 00 00       	mov    $0x3,%eax
  800503:	89 cb                	mov    %ecx,%ebx
  800505:	89 cf                	mov    %ecx,%edi
  800507:	89 ce                	mov    %ecx,%esi
  800509:	cd 30                	int    $0x30
	if(check && ret > 0)
  80050b:	85 c0                	test   %eax,%eax
  80050d:	7f 08                	jg     800517 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80050f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800512:	5b                   	pop    %ebx
  800513:	5e                   	pop    %esi
  800514:	5f                   	pop    %edi
  800515:	5d                   	pop    %ebp
  800516:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800517:	83 ec 0c             	sub    $0xc,%esp
  80051a:	50                   	push   %eax
  80051b:	6a 03                	push   $0x3
  80051d:	68 af 1e 80 00       	push   $0x801eaf
  800522:	6a 23                	push   $0x23
  800524:	68 cc 1e 80 00       	push   $0x801ecc
  800529:	e8 33 0f 00 00       	call   801461 <_panic>

0080052e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80052e:	55                   	push   %ebp
  80052f:	89 e5                	mov    %esp,%ebp
  800531:	57                   	push   %edi
  800532:	56                   	push   %esi
  800533:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800534:	ba 00 00 00 00       	mov    $0x0,%edx
  800539:	b8 02 00 00 00       	mov    $0x2,%eax
  80053e:	89 d1                	mov    %edx,%ecx
  800540:	89 d3                	mov    %edx,%ebx
  800542:	89 d7                	mov    %edx,%edi
  800544:	89 d6                	mov    %edx,%esi
  800546:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800548:	5b                   	pop    %ebx
  800549:	5e                   	pop    %esi
  80054a:	5f                   	pop    %edi
  80054b:	5d                   	pop    %ebp
  80054c:	c3                   	ret    

0080054d <sys_yield>:

void
sys_yield(void)
{
  80054d:	55                   	push   %ebp
  80054e:	89 e5                	mov    %esp,%ebp
  800550:	57                   	push   %edi
  800551:	56                   	push   %esi
  800552:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800553:	ba 00 00 00 00       	mov    $0x0,%edx
  800558:	b8 0b 00 00 00       	mov    $0xb,%eax
  80055d:	89 d1                	mov    %edx,%ecx
  80055f:	89 d3                	mov    %edx,%ebx
  800561:	89 d7                	mov    %edx,%edi
  800563:	89 d6                	mov    %edx,%esi
  800565:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800567:	5b                   	pop    %ebx
  800568:	5e                   	pop    %esi
  800569:	5f                   	pop    %edi
  80056a:	5d                   	pop    %ebp
  80056b:	c3                   	ret    

0080056c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	57                   	push   %edi
  800570:	56                   	push   %esi
  800571:	53                   	push   %ebx
  800572:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800575:	be 00 00 00 00       	mov    $0x0,%esi
  80057a:	8b 55 08             	mov    0x8(%ebp),%edx
  80057d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800580:	b8 04 00 00 00       	mov    $0x4,%eax
  800585:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800588:	89 f7                	mov    %esi,%edi
  80058a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80058c:	85 c0                	test   %eax,%eax
  80058e:	7f 08                	jg     800598 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800590:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800593:	5b                   	pop    %ebx
  800594:	5e                   	pop    %esi
  800595:	5f                   	pop    %edi
  800596:	5d                   	pop    %ebp
  800597:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	50                   	push   %eax
  80059c:	6a 04                	push   $0x4
  80059e:	68 af 1e 80 00       	push   $0x801eaf
  8005a3:	6a 23                	push   $0x23
  8005a5:	68 cc 1e 80 00       	push   $0x801ecc
  8005aa:	e8 b2 0e 00 00       	call   801461 <_panic>

008005af <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	57                   	push   %edi
  8005b3:	56                   	push   %esi
  8005b4:	53                   	push   %ebx
  8005b5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8005b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8005bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005be:	b8 05 00 00 00       	mov    $0x5,%eax
  8005c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005c6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8005c9:	8b 75 18             	mov    0x18(%ebp),%esi
  8005cc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8005ce:	85 c0                	test   %eax,%eax
  8005d0:	7f 08                	jg     8005da <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8005d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d5:	5b                   	pop    %ebx
  8005d6:	5e                   	pop    %esi
  8005d7:	5f                   	pop    %edi
  8005d8:	5d                   	pop    %ebp
  8005d9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005da:	83 ec 0c             	sub    $0xc,%esp
  8005dd:	50                   	push   %eax
  8005de:	6a 05                	push   $0x5
  8005e0:	68 af 1e 80 00       	push   $0x801eaf
  8005e5:	6a 23                	push   $0x23
  8005e7:	68 cc 1e 80 00       	push   $0x801ecc
  8005ec:	e8 70 0e 00 00       	call   801461 <_panic>

008005f1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8005f1:	55                   	push   %ebp
  8005f2:	89 e5                	mov    %esp,%ebp
  8005f4:	57                   	push   %edi
  8005f5:	56                   	push   %esi
  8005f6:	53                   	push   %ebx
  8005f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8005fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800602:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800605:	b8 06 00 00 00       	mov    $0x6,%eax
  80060a:	89 df                	mov    %ebx,%edi
  80060c:	89 de                	mov    %ebx,%esi
  80060e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800610:	85 c0                	test   %eax,%eax
  800612:	7f 08                	jg     80061c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800614:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800617:	5b                   	pop    %ebx
  800618:	5e                   	pop    %esi
  800619:	5f                   	pop    %edi
  80061a:	5d                   	pop    %ebp
  80061b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80061c:	83 ec 0c             	sub    $0xc,%esp
  80061f:	50                   	push   %eax
  800620:	6a 06                	push   $0x6
  800622:	68 af 1e 80 00       	push   $0x801eaf
  800627:	6a 23                	push   $0x23
  800629:	68 cc 1e 80 00       	push   $0x801ecc
  80062e:	e8 2e 0e 00 00       	call   801461 <_panic>

00800633 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800633:	55                   	push   %ebp
  800634:	89 e5                	mov    %esp,%ebp
  800636:	57                   	push   %edi
  800637:	56                   	push   %esi
  800638:	53                   	push   %ebx
  800639:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80063c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800641:	8b 55 08             	mov    0x8(%ebp),%edx
  800644:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800647:	b8 08 00 00 00       	mov    $0x8,%eax
  80064c:	89 df                	mov    %ebx,%edi
  80064e:	89 de                	mov    %ebx,%esi
  800650:	cd 30                	int    $0x30
	if(check && ret > 0)
  800652:	85 c0                	test   %eax,%eax
  800654:	7f 08                	jg     80065e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800656:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800659:	5b                   	pop    %ebx
  80065a:	5e                   	pop    %esi
  80065b:	5f                   	pop    %edi
  80065c:	5d                   	pop    %ebp
  80065d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80065e:	83 ec 0c             	sub    $0xc,%esp
  800661:	50                   	push   %eax
  800662:	6a 08                	push   $0x8
  800664:	68 af 1e 80 00       	push   $0x801eaf
  800669:	6a 23                	push   $0x23
  80066b:	68 cc 1e 80 00       	push   $0x801ecc
  800670:	e8 ec 0d 00 00       	call   801461 <_panic>

00800675 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
  800678:	57                   	push   %edi
  800679:	56                   	push   %esi
  80067a:	53                   	push   %ebx
  80067b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80067e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800683:	8b 55 08             	mov    0x8(%ebp),%edx
  800686:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800689:	b8 09 00 00 00       	mov    $0x9,%eax
  80068e:	89 df                	mov    %ebx,%edi
  800690:	89 de                	mov    %ebx,%esi
  800692:	cd 30                	int    $0x30
	if(check && ret > 0)
  800694:	85 c0                	test   %eax,%eax
  800696:	7f 08                	jg     8006a0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800698:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80069b:	5b                   	pop    %ebx
  80069c:	5e                   	pop    %esi
  80069d:	5f                   	pop    %edi
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	50                   	push   %eax
  8006a4:	6a 09                	push   $0x9
  8006a6:	68 af 1e 80 00       	push   $0x801eaf
  8006ab:	6a 23                	push   $0x23
  8006ad:	68 cc 1e 80 00       	push   $0x801ecc
  8006b2:	e8 aa 0d 00 00       	call   801461 <_panic>

008006b7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	57                   	push   %edi
  8006bb:	56                   	push   %esi
  8006bc:	53                   	push   %ebx
  8006bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8006c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d0:	89 df                	mov    %ebx,%edi
  8006d2:	89 de                	mov    %ebx,%esi
  8006d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	7f 08                	jg     8006e2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8006da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006dd:	5b                   	pop    %ebx
  8006de:	5e                   	pop    %esi
  8006df:	5f                   	pop    %edi
  8006e0:	5d                   	pop    %ebp
  8006e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006e2:	83 ec 0c             	sub    $0xc,%esp
  8006e5:	50                   	push   %eax
  8006e6:	6a 0a                	push   $0xa
  8006e8:	68 af 1e 80 00       	push   $0x801eaf
  8006ed:	6a 23                	push   $0x23
  8006ef:	68 cc 1e 80 00       	push   $0x801ecc
  8006f4:	e8 68 0d 00 00       	call   801461 <_panic>

008006f9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8006f9:	55                   	push   %ebp
  8006fa:	89 e5                	mov    %esp,%ebp
  8006fc:	57                   	push   %edi
  8006fd:	56                   	push   %esi
  8006fe:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8006ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800702:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800705:	b8 0c 00 00 00       	mov    $0xc,%eax
  80070a:	be 00 00 00 00       	mov    $0x0,%esi
  80070f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800712:	8b 7d 14             	mov    0x14(%ebp),%edi
  800715:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800717:	5b                   	pop    %ebx
  800718:	5e                   	pop    %esi
  800719:	5f                   	pop    %edi
  80071a:	5d                   	pop    %ebp
  80071b:	c3                   	ret    

0080071c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	57                   	push   %edi
  800720:	56                   	push   %esi
  800721:	53                   	push   %ebx
  800722:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800725:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072a:	8b 55 08             	mov    0x8(%ebp),%edx
  80072d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800732:	89 cb                	mov    %ecx,%ebx
  800734:	89 cf                	mov    %ecx,%edi
  800736:	89 ce                	mov    %ecx,%esi
  800738:	cd 30                	int    $0x30
	if(check && ret > 0)
  80073a:	85 c0                	test   %eax,%eax
  80073c:	7f 08                	jg     800746 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80073e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800741:	5b                   	pop    %ebx
  800742:	5e                   	pop    %esi
  800743:	5f                   	pop    %edi
  800744:	5d                   	pop    %ebp
  800745:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800746:	83 ec 0c             	sub    $0xc,%esp
  800749:	50                   	push   %eax
  80074a:	6a 0d                	push   $0xd
  80074c:	68 af 1e 80 00       	push   $0x801eaf
  800751:	6a 23                	push   $0x23
  800753:	68 cc 1e 80 00       	push   $0x801ecc
  800758:	e8 04 0d 00 00       	call   801461 <_panic>

0080075d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	05 00 00 00 30       	add    $0x30000000,%eax
  800768:	c1 e8 0c             	shr    $0xc,%eax
}
  80076b:	5d                   	pop    %ebp
  80076c:	c3                   	ret    

0080076d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800778:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80077d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800782:	5d                   	pop    %ebp
  800783:	c3                   	ret    

00800784 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80078a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80078f:	89 c2                	mov    %eax,%edx
  800791:	c1 ea 16             	shr    $0x16,%edx
  800794:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80079b:	f6 c2 01             	test   $0x1,%dl
  80079e:	74 2a                	je     8007ca <fd_alloc+0x46>
  8007a0:	89 c2                	mov    %eax,%edx
  8007a2:	c1 ea 0c             	shr    $0xc,%edx
  8007a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007ac:	f6 c2 01             	test   $0x1,%dl
  8007af:	74 19                	je     8007ca <fd_alloc+0x46>
  8007b1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8007b6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8007bb:	75 d2                	jne    80078f <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8007bd:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8007c3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8007c8:	eb 07                	jmp    8007d1 <fd_alloc+0x4d>
			*fd_store = fd;
  8007ca:	89 01                	mov    %eax,(%ecx)
			return 0;
  8007cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d1:	5d                   	pop    %ebp
  8007d2:	c3                   	ret    

008007d3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8007d9:	83 f8 1f             	cmp    $0x1f,%eax
  8007dc:	77 36                	ja     800814 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8007de:	c1 e0 0c             	shl    $0xc,%eax
  8007e1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8007e6:	89 c2                	mov    %eax,%edx
  8007e8:	c1 ea 16             	shr    $0x16,%edx
  8007eb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8007f2:	f6 c2 01             	test   $0x1,%dl
  8007f5:	74 24                	je     80081b <fd_lookup+0x48>
  8007f7:	89 c2                	mov    %eax,%edx
  8007f9:	c1 ea 0c             	shr    $0xc,%edx
  8007fc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800803:	f6 c2 01             	test   $0x1,%dl
  800806:	74 1a                	je     800822 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080b:	89 02                	mov    %eax,(%edx)
	return 0;
  80080d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800812:	5d                   	pop    %ebp
  800813:	c3                   	ret    
		return -E_INVAL;
  800814:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800819:	eb f7                	jmp    800812 <fd_lookup+0x3f>
		return -E_INVAL;
  80081b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800820:	eb f0                	jmp    800812 <fd_lookup+0x3f>
  800822:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800827:	eb e9                	jmp    800812 <fd_lookup+0x3f>

00800829 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800832:	ba 58 1f 80 00       	mov    $0x801f58,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800837:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80083c:	39 08                	cmp    %ecx,(%eax)
  80083e:	74 33                	je     800873 <dev_lookup+0x4a>
  800840:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800843:	8b 02                	mov    (%edx),%eax
  800845:	85 c0                	test   %eax,%eax
  800847:	75 f3                	jne    80083c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800849:	a1 04 40 80 00       	mov    0x804004,%eax
  80084e:	8b 40 48             	mov    0x48(%eax),%eax
  800851:	83 ec 04             	sub    $0x4,%esp
  800854:	51                   	push   %ecx
  800855:	50                   	push   %eax
  800856:	68 dc 1e 80 00       	push   $0x801edc
  80085b:	e8 dc 0c 00 00       	call   80153c <cprintf>
	*dev = 0;
  800860:	8b 45 0c             	mov    0xc(%ebp),%eax
  800863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800871:	c9                   	leave  
  800872:	c3                   	ret    
			*dev = devtab[i];
  800873:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800876:	89 01                	mov    %eax,(%ecx)
			return 0;
  800878:	b8 00 00 00 00       	mov    $0x0,%eax
  80087d:	eb f2                	jmp    800871 <dev_lookup+0x48>

0080087f <fd_close>:
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	57                   	push   %edi
  800883:	56                   	push   %esi
  800884:	53                   	push   %ebx
  800885:	83 ec 1c             	sub    $0x1c,%esp
  800888:	8b 75 08             	mov    0x8(%ebp),%esi
  80088b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80088e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800891:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800892:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800898:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80089b:	50                   	push   %eax
  80089c:	e8 32 ff ff ff       	call   8007d3 <fd_lookup>
  8008a1:	89 c3                	mov    %eax,%ebx
  8008a3:	83 c4 08             	add    $0x8,%esp
  8008a6:	85 c0                	test   %eax,%eax
  8008a8:	78 05                	js     8008af <fd_close+0x30>
	    || fd != fd2)
  8008aa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8008ad:	74 16                	je     8008c5 <fd_close+0x46>
		return (must_exist ? r : 0);
  8008af:	89 f8                	mov    %edi,%eax
  8008b1:	84 c0                	test   %al,%al
  8008b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b8:	0f 44 d8             	cmove  %eax,%ebx
}
  8008bb:	89 d8                	mov    %ebx,%eax
  8008bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008c0:	5b                   	pop    %ebx
  8008c1:	5e                   	pop    %esi
  8008c2:	5f                   	pop    %edi
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008cb:	50                   	push   %eax
  8008cc:	ff 36                	pushl  (%esi)
  8008ce:	e8 56 ff ff ff       	call   800829 <dev_lookup>
  8008d3:	89 c3                	mov    %eax,%ebx
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	85 c0                	test   %eax,%eax
  8008da:	78 15                	js     8008f1 <fd_close+0x72>
		if (dev->dev_close)
  8008dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008df:	8b 40 10             	mov    0x10(%eax),%eax
  8008e2:	85 c0                	test   %eax,%eax
  8008e4:	74 1b                	je     800901 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8008e6:	83 ec 0c             	sub    $0xc,%esp
  8008e9:	56                   	push   %esi
  8008ea:	ff d0                	call   *%eax
  8008ec:	89 c3                	mov    %eax,%ebx
  8008ee:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	56                   	push   %esi
  8008f5:	6a 00                	push   $0x0
  8008f7:	e8 f5 fc ff ff       	call   8005f1 <sys_page_unmap>
	return r;
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	eb ba                	jmp    8008bb <fd_close+0x3c>
			r = 0;
  800901:	bb 00 00 00 00       	mov    $0x0,%ebx
  800906:	eb e9                	jmp    8008f1 <fd_close+0x72>

00800908 <close>:

int
close(int fdnum)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80090e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800911:	50                   	push   %eax
  800912:	ff 75 08             	pushl  0x8(%ebp)
  800915:	e8 b9 fe ff ff       	call   8007d3 <fd_lookup>
  80091a:	83 c4 08             	add    $0x8,%esp
  80091d:	85 c0                	test   %eax,%eax
  80091f:	78 10                	js     800931 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	6a 01                	push   $0x1
  800926:	ff 75 f4             	pushl  -0xc(%ebp)
  800929:	e8 51 ff ff ff       	call   80087f <fd_close>
  80092e:	83 c4 10             	add    $0x10,%esp
}
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <close_all>:

void
close_all(void)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	53                   	push   %ebx
  800937:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80093a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80093f:	83 ec 0c             	sub    $0xc,%esp
  800942:	53                   	push   %ebx
  800943:	e8 c0 ff ff ff       	call   800908 <close>
	for (i = 0; i < MAXFD; i++)
  800948:	83 c3 01             	add    $0x1,%ebx
  80094b:	83 c4 10             	add    $0x10,%esp
  80094e:	83 fb 20             	cmp    $0x20,%ebx
  800951:	75 ec                	jne    80093f <close_all+0xc>
}
  800953:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800956:	c9                   	leave  
  800957:	c3                   	ret    

00800958 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	57                   	push   %edi
  80095c:	56                   	push   %esi
  80095d:	53                   	push   %ebx
  80095e:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800961:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	ff 75 08             	pushl  0x8(%ebp)
  800968:	e8 66 fe ff ff       	call   8007d3 <fd_lookup>
  80096d:	89 c3                	mov    %eax,%ebx
  80096f:	83 c4 08             	add    $0x8,%esp
  800972:	85 c0                	test   %eax,%eax
  800974:	0f 88 81 00 00 00    	js     8009fb <dup+0xa3>
		return r;
	close(newfdnum);
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	e8 83 ff ff ff       	call   800908 <close>

	newfd = INDEX2FD(newfdnum);
  800985:	8b 75 0c             	mov    0xc(%ebp),%esi
  800988:	c1 e6 0c             	shl    $0xc,%esi
  80098b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800991:	83 c4 04             	add    $0x4,%esp
  800994:	ff 75 e4             	pushl  -0x1c(%ebp)
  800997:	e8 d1 fd ff ff       	call   80076d <fd2data>
  80099c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80099e:	89 34 24             	mov    %esi,(%esp)
  8009a1:	e8 c7 fd ff ff       	call   80076d <fd2data>
  8009a6:	83 c4 10             	add    $0x10,%esp
  8009a9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009ab:	89 d8                	mov    %ebx,%eax
  8009ad:	c1 e8 16             	shr    $0x16,%eax
  8009b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8009b7:	a8 01                	test   $0x1,%al
  8009b9:	74 11                	je     8009cc <dup+0x74>
  8009bb:	89 d8                	mov    %ebx,%eax
  8009bd:	c1 e8 0c             	shr    $0xc,%eax
  8009c0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8009c7:	f6 c2 01             	test   $0x1,%dl
  8009ca:	75 39                	jne    800a05 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009cf:	89 d0                	mov    %edx,%eax
  8009d1:	c1 e8 0c             	shr    $0xc,%eax
  8009d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8009db:	83 ec 0c             	sub    $0xc,%esp
  8009de:	25 07 0e 00 00       	and    $0xe07,%eax
  8009e3:	50                   	push   %eax
  8009e4:	56                   	push   %esi
  8009e5:	6a 00                	push   $0x0
  8009e7:	52                   	push   %edx
  8009e8:	6a 00                	push   $0x0
  8009ea:	e8 c0 fb ff ff       	call   8005af <sys_page_map>
  8009ef:	89 c3                	mov    %eax,%ebx
  8009f1:	83 c4 20             	add    $0x20,%esp
  8009f4:	85 c0                	test   %eax,%eax
  8009f6:	78 31                	js     800a29 <dup+0xd1>
		goto err;

	return newfdnum;
  8009f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8009fb:	89 d8                	mov    %ebx,%eax
  8009fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a00:	5b                   	pop    %ebx
  800a01:	5e                   	pop    %esi
  800a02:	5f                   	pop    %edi
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a05:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a0c:	83 ec 0c             	sub    $0xc,%esp
  800a0f:	25 07 0e 00 00       	and    $0xe07,%eax
  800a14:	50                   	push   %eax
  800a15:	57                   	push   %edi
  800a16:	6a 00                	push   $0x0
  800a18:	53                   	push   %ebx
  800a19:	6a 00                	push   $0x0
  800a1b:	e8 8f fb ff ff       	call   8005af <sys_page_map>
  800a20:	89 c3                	mov    %eax,%ebx
  800a22:	83 c4 20             	add    $0x20,%esp
  800a25:	85 c0                	test   %eax,%eax
  800a27:	79 a3                	jns    8009cc <dup+0x74>
	sys_page_unmap(0, newfd);
  800a29:	83 ec 08             	sub    $0x8,%esp
  800a2c:	56                   	push   %esi
  800a2d:	6a 00                	push   $0x0
  800a2f:	e8 bd fb ff ff       	call   8005f1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800a34:	83 c4 08             	add    $0x8,%esp
  800a37:	57                   	push   %edi
  800a38:	6a 00                	push   $0x0
  800a3a:	e8 b2 fb ff ff       	call   8005f1 <sys_page_unmap>
	return r;
  800a3f:	83 c4 10             	add    $0x10,%esp
  800a42:	eb b7                	jmp    8009fb <dup+0xa3>

00800a44 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	53                   	push   %ebx
  800a48:	83 ec 14             	sub    $0x14,%esp
  800a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a4e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a51:	50                   	push   %eax
  800a52:	53                   	push   %ebx
  800a53:	e8 7b fd ff ff       	call   8007d3 <fd_lookup>
  800a58:	83 c4 08             	add    $0x8,%esp
  800a5b:	85 c0                	test   %eax,%eax
  800a5d:	78 3f                	js     800a9e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a65:	50                   	push   %eax
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	ff 30                	pushl  (%eax)
  800a6b:	e8 b9 fd ff ff       	call   800829 <dev_lookup>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	85 c0                	test   %eax,%eax
  800a75:	78 27                	js     800a9e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a7a:	8b 42 08             	mov    0x8(%edx),%eax
  800a7d:	83 e0 03             	and    $0x3,%eax
  800a80:	83 f8 01             	cmp    $0x1,%eax
  800a83:	74 1e                	je     800aa3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a88:	8b 40 08             	mov    0x8(%eax),%eax
  800a8b:	85 c0                	test   %eax,%eax
  800a8d:	74 35                	je     800ac4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800a8f:	83 ec 04             	sub    $0x4,%esp
  800a92:	ff 75 10             	pushl  0x10(%ebp)
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	52                   	push   %edx
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
}
  800a9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa1:	c9                   	leave  
  800aa2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800aa3:	a1 04 40 80 00       	mov    0x804004,%eax
  800aa8:	8b 40 48             	mov    0x48(%eax),%eax
  800aab:	83 ec 04             	sub    $0x4,%esp
  800aae:	53                   	push   %ebx
  800aaf:	50                   	push   %eax
  800ab0:	68 1d 1f 80 00       	push   $0x801f1d
  800ab5:	e8 82 0a 00 00       	call   80153c <cprintf>
		return -E_INVAL;
  800aba:	83 c4 10             	add    $0x10,%esp
  800abd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ac2:	eb da                	jmp    800a9e <read+0x5a>
		return -E_NOT_SUPP;
  800ac4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800ac9:	eb d3                	jmp    800a9e <read+0x5a>

00800acb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	57                   	push   %edi
  800acf:	56                   	push   %esi
  800ad0:	53                   	push   %ebx
  800ad1:	83 ec 0c             	sub    $0xc,%esp
  800ad4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800ada:	bb 00 00 00 00       	mov    $0x0,%ebx
  800adf:	39 f3                	cmp    %esi,%ebx
  800ae1:	73 25                	jae    800b08 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800ae3:	83 ec 04             	sub    $0x4,%esp
  800ae6:	89 f0                	mov    %esi,%eax
  800ae8:	29 d8                	sub    %ebx,%eax
  800aea:	50                   	push   %eax
  800aeb:	89 d8                	mov    %ebx,%eax
  800aed:	03 45 0c             	add    0xc(%ebp),%eax
  800af0:	50                   	push   %eax
  800af1:	57                   	push   %edi
  800af2:	e8 4d ff ff ff       	call   800a44 <read>
		if (m < 0)
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	85 c0                	test   %eax,%eax
  800afc:	78 08                	js     800b06 <readn+0x3b>
			return m;
		if (m == 0)
  800afe:	85 c0                	test   %eax,%eax
  800b00:	74 06                	je     800b08 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800b02:	01 c3                	add    %eax,%ebx
  800b04:	eb d9                	jmp    800adf <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b06:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800b08:	89 d8                	mov    %ebx,%eax
  800b0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b0d:	5b                   	pop    %ebx
  800b0e:	5e                   	pop    %esi
  800b0f:	5f                   	pop    %edi
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	53                   	push   %ebx
  800b16:	83 ec 14             	sub    $0x14,%esp
  800b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b1f:	50                   	push   %eax
  800b20:	53                   	push   %ebx
  800b21:	e8 ad fc ff ff       	call   8007d3 <fd_lookup>
  800b26:	83 c4 08             	add    $0x8,%esp
  800b29:	85 c0                	test   %eax,%eax
  800b2b:	78 3a                	js     800b67 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b2d:	83 ec 08             	sub    $0x8,%esp
  800b30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b33:	50                   	push   %eax
  800b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b37:	ff 30                	pushl  (%eax)
  800b39:	e8 eb fc ff ff       	call   800829 <dev_lookup>
  800b3e:	83 c4 10             	add    $0x10,%esp
  800b41:	85 c0                	test   %eax,%eax
  800b43:	78 22                	js     800b67 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b48:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800b4c:	74 1e                	je     800b6c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b51:	8b 52 0c             	mov    0xc(%edx),%edx
  800b54:	85 d2                	test   %edx,%edx
  800b56:	74 35                	je     800b8d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800b58:	83 ec 04             	sub    $0x4,%esp
  800b5b:	ff 75 10             	pushl  0x10(%ebp)
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	50                   	push   %eax
  800b62:	ff d2                	call   *%edx
  800b64:	83 c4 10             	add    $0x10,%esp
}
  800b67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b6c:	a1 04 40 80 00       	mov    0x804004,%eax
  800b71:	8b 40 48             	mov    0x48(%eax),%eax
  800b74:	83 ec 04             	sub    $0x4,%esp
  800b77:	53                   	push   %ebx
  800b78:	50                   	push   %eax
  800b79:	68 39 1f 80 00       	push   $0x801f39
  800b7e:	e8 b9 09 00 00       	call   80153c <cprintf>
		return -E_INVAL;
  800b83:	83 c4 10             	add    $0x10,%esp
  800b86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b8b:	eb da                	jmp    800b67 <write+0x55>
		return -E_NOT_SUPP;
  800b8d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800b92:	eb d3                	jmp    800b67 <write+0x55>

00800b94 <seek>:

int
seek(int fdnum, off_t offset)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800b9a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800b9d:	50                   	push   %eax
  800b9e:	ff 75 08             	pushl  0x8(%ebp)
  800ba1:	e8 2d fc ff ff       	call   8007d3 <fd_lookup>
  800ba6:	83 c4 08             	add    $0x8,%esp
  800ba9:	85 c0                	test   %eax,%eax
  800bab:	78 0e                	js     800bbb <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800bb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	53                   	push   %ebx
  800bc1:	83 ec 14             	sub    $0x14,%esp
  800bc4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bc7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800bca:	50                   	push   %eax
  800bcb:	53                   	push   %ebx
  800bcc:	e8 02 fc ff ff       	call   8007d3 <fd_lookup>
  800bd1:	83 c4 08             	add    $0x8,%esp
  800bd4:	85 c0                	test   %eax,%eax
  800bd6:	78 37                	js     800c0f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bd8:	83 ec 08             	sub    $0x8,%esp
  800bdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bde:	50                   	push   %eax
  800bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be2:	ff 30                	pushl  (%eax)
  800be4:	e8 40 fc ff ff       	call   800829 <dev_lookup>
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	85 c0                	test   %eax,%eax
  800bee:	78 1f                	js     800c0f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800bf7:	74 1b                	je     800c14 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfc:	8b 52 18             	mov    0x18(%edx),%edx
  800bff:	85 d2                	test   %edx,%edx
  800c01:	74 32                	je     800c35 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	50                   	push   %eax
  800c0a:	ff d2                	call   *%edx
  800c0c:	83 c4 10             	add    $0x10,%esp
}
  800c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    
			thisenv->env_id, fdnum);
  800c14:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c19:	8b 40 48             	mov    0x48(%eax),%eax
  800c1c:	83 ec 04             	sub    $0x4,%esp
  800c1f:	53                   	push   %ebx
  800c20:	50                   	push   %eax
  800c21:	68 fc 1e 80 00       	push   $0x801efc
  800c26:	e8 11 09 00 00       	call   80153c <cprintf>
		return -E_INVAL;
  800c2b:	83 c4 10             	add    $0x10,%esp
  800c2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c33:	eb da                	jmp    800c0f <ftruncate+0x52>
		return -E_NOT_SUPP;
  800c35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c3a:	eb d3                	jmp    800c0f <ftruncate+0x52>

00800c3c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	53                   	push   %ebx
  800c40:	83 ec 14             	sub    $0x14,%esp
  800c43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c49:	50                   	push   %eax
  800c4a:	ff 75 08             	pushl  0x8(%ebp)
  800c4d:	e8 81 fb ff ff       	call   8007d3 <fd_lookup>
  800c52:	83 c4 08             	add    $0x8,%esp
  800c55:	85 c0                	test   %eax,%eax
  800c57:	78 4b                	js     800ca4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c63:	ff 30                	pushl  (%eax)
  800c65:	e8 bf fb ff ff       	call   800829 <dev_lookup>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	78 33                	js     800ca4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c74:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800c78:	74 2f                	je     800ca9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800c7a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800c7d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800c84:	00 00 00 
	stat->st_isdir = 0;
  800c87:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c8e:	00 00 00 
	stat->st_dev = dev;
  800c91:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	53                   	push   %ebx
  800c9b:	ff 75 f0             	pushl  -0x10(%ebp)
  800c9e:	ff 50 14             	call   *0x14(%eax)
  800ca1:	83 c4 10             	add    $0x10,%esp
}
  800ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    
		return -E_NOT_SUPP;
  800ca9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cae:	eb f4                	jmp    800ca4 <fstat+0x68>

00800cb0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	6a 00                	push   $0x0
  800cba:	ff 75 08             	pushl  0x8(%ebp)
  800cbd:	e8 30 02 00 00       	call   800ef2 <open>
  800cc2:	89 c3                	mov    %eax,%ebx
  800cc4:	83 c4 10             	add    $0x10,%esp
  800cc7:	85 c0                	test   %eax,%eax
  800cc9:	78 1b                	js     800ce6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	e8 65 ff ff ff       	call   800c3c <fstat>
  800cd7:	89 c6                	mov    %eax,%esi
	close(fd);
  800cd9:	89 1c 24             	mov    %ebx,(%esp)
  800cdc:	e8 27 fc ff ff       	call   800908 <close>
	return r;
  800ce1:	83 c4 10             	add    $0x10,%esp
  800ce4:	89 f3                	mov    %esi,%ebx
}
  800ce6:	89 d8                	mov    %ebx,%eax
  800ce8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
  800cf4:	89 c6                	mov    %eax,%esi
  800cf6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800cf8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800cff:	74 27                	je     800d28 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800d01:	6a 07                	push   $0x7
  800d03:	68 00 50 80 00       	push   $0x805000
  800d08:	56                   	push   %esi
  800d09:	ff 35 00 40 80 00    	pushl  0x804000
  800d0f:	e8 79 0e 00 00       	call   801b8d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800d14:	83 c4 0c             	add    $0xc,%esp
  800d17:	6a 00                	push   $0x0
  800d19:	53                   	push   %ebx
  800d1a:	6a 00                	push   $0x0
  800d1c:	e8 03 0e 00 00       	call   801b24 <ipc_recv>
}
  800d21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800d28:	83 ec 0c             	sub    $0xc,%esp
  800d2b:	6a 01                	push   $0x1
  800d2d:	e8 af 0e 00 00       	call   801be1 <ipc_find_env>
  800d32:	a3 00 40 80 00       	mov    %eax,0x804000
  800d37:	83 c4 10             	add    $0x10,%esp
  800d3a:	eb c5                	jmp    800d01 <fsipc+0x12>

00800d3c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8b 40 0c             	mov    0xc(%eax),%eax
  800d48:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800d55:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5f:	e8 8b ff ff ff       	call   800cef <fsipc>
}
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

00800d66 <devfile_flush>:
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8b 40 0c             	mov    0xc(%eax),%eax
  800d72:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800d77:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d81:	e8 69 ff ff ff       	call   800cef <fsipc>
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <devfile_stat>:
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	53                   	push   %ebx
  800d8c:	83 ec 04             	sub    $0x4,%esp
  800d8f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8b 40 0c             	mov    0xc(%eax),%eax
  800d98:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800d9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800da2:	b8 05 00 00 00       	mov    $0x5,%eax
  800da7:	e8 43 ff ff ff       	call   800cef <fsipc>
  800dac:	85 c0                	test   %eax,%eax
  800dae:	78 2c                	js     800ddc <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800db0:	83 ec 08             	sub    $0x8,%esp
  800db3:	68 00 50 80 00       	push   $0x805000
  800db8:	53                   	push   %ebx
  800db9:	e8 b5 f3 ff ff       	call   800173 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800dbe:	a1 80 50 80 00       	mov    0x805080,%eax
  800dc3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800dc9:	a1 84 50 80 00       	mov    0x805084,%eax
  800dce:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <devfile_write>:
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	53                   	push   %ebx
  800de5:	83 ec 08             	sub    $0x8,%esp
  800de8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  800deb:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800df1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  800df6:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8b 40 0c             	mov    0xc(%eax),%eax
  800dff:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800e04:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  800e0a:	53                   	push   %ebx
  800e0b:	ff 75 0c             	pushl  0xc(%ebp)
  800e0e:	68 08 50 80 00       	push   $0x805008
  800e13:	e8 e9 f4 ff ff       	call   800301 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800e18:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1d:	b8 04 00 00 00       	mov    $0x4,%eax
  800e22:	e8 c8 fe ff ff       	call   800cef <fsipc>
  800e27:	83 c4 10             	add    $0x10,%esp
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	78 0b                	js     800e39 <devfile_write+0x58>
	assert(r <= n);
  800e2e:	39 d8                	cmp    %ebx,%eax
  800e30:	77 0c                	ja     800e3e <devfile_write+0x5d>
	assert(r <= PGSIZE);
  800e32:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800e37:	7f 1e                	jg     800e57 <devfile_write+0x76>
}
  800e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    
	assert(r <= n);
  800e3e:	68 68 1f 80 00       	push   $0x801f68
  800e43:	68 6f 1f 80 00       	push   $0x801f6f
  800e48:	68 98 00 00 00       	push   $0x98
  800e4d:	68 84 1f 80 00       	push   $0x801f84
  800e52:	e8 0a 06 00 00       	call   801461 <_panic>
	assert(r <= PGSIZE);
  800e57:	68 8f 1f 80 00       	push   $0x801f8f
  800e5c:	68 6f 1f 80 00       	push   $0x801f6f
  800e61:	68 99 00 00 00       	push   $0x99
  800e66:	68 84 1f 80 00       	push   $0x801f84
  800e6b:	e8 f1 05 00 00       	call   801461 <_panic>

00800e70 <devfile_read>:
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	56                   	push   %esi
  800e74:	53                   	push   %ebx
  800e75:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  800e7e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800e83:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800e89:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8e:	b8 03 00 00 00       	mov    $0x3,%eax
  800e93:	e8 57 fe ff ff       	call   800cef <fsipc>
  800e98:	89 c3                	mov    %eax,%ebx
  800e9a:	85 c0                	test   %eax,%eax
  800e9c:	78 1f                	js     800ebd <devfile_read+0x4d>
	assert(r <= n);
  800e9e:	39 f0                	cmp    %esi,%eax
  800ea0:	77 24                	ja     800ec6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800ea2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ea7:	7f 33                	jg     800edc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ea9:	83 ec 04             	sub    $0x4,%esp
  800eac:	50                   	push   %eax
  800ead:	68 00 50 80 00       	push   $0x805000
  800eb2:	ff 75 0c             	pushl  0xc(%ebp)
  800eb5:	e8 47 f4 ff ff       	call   800301 <memmove>
	return r;
  800eba:	83 c4 10             	add    $0x10,%esp
}
  800ebd:	89 d8                	mov    %ebx,%eax
  800ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    
	assert(r <= n);
  800ec6:	68 68 1f 80 00       	push   $0x801f68
  800ecb:	68 6f 1f 80 00       	push   $0x801f6f
  800ed0:	6a 7c                	push   $0x7c
  800ed2:	68 84 1f 80 00       	push   $0x801f84
  800ed7:	e8 85 05 00 00       	call   801461 <_panic>
	assert(r <= PGSIZE);
  800edc:	68 8f 1f 80 00       	push   $0x801f8f
  800ee1:	68 6f 1f 80 00       	push   $0x801f6f
  800ee6:	6a 7d                	push   $0x7d
  800ee8:	68 84 1f 80 00       	push   $0x801f84
  800eed:	e8 6f 05 00 00       	call   801461 <_panic>

00800ef2 <open>:
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
  800ef7:	83 ec 1c             	sub    $0x1c,%esp
  800efa:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800efd:	56                   	push   %esi
  800efe:	e8 39 f2 ff ff       	call   80013c <strlen>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f0b:	7f 6c                	jg     800f79 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800f0d:	83 ec 0c             	sub    $0xc,%esp
  800f10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f13:	50                   	push   %eax
  800f14:	e8 6b f8 ff ff       	call   800784 <fd_alloc>
  800f19:	89 c3                	mov    %eax,%ebx
  800f1b:	83 c4 10             	add    $0x10,%esp
  800f1e:	85 c0                	test   %eax,%eax
  800f20:	78 3c                	js     800f5e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800f22:	83 ec 08             	sub    $0x8,%esp
  800f25:	56                   	push   %esi
  800f26:	68 00 50 80 00       	push   $0x805000
  800f2b:	e8 43 f2 ff ff       	call   800173 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3b:	b8 01 00 00 00       	mov    $0x1,%eax
  800f40:	e8 aa fd ff ff       	call   800cef <fsipc>
  800f45:	89 c3                	mov    %eax,%ebx
  800f47:	83 c4 10             	add    $0x10,%esp
  800f4a:	85 c0                	test   %eax,%eax
  800f4c:	78 19                	js     800f67 <open+0x75>
	return fd2num(fd);
  800f4e:	83 ec 0c             	sub    $0xc,%esp
  800f51:	ff 75 f4             	pushl  -0xc(%ebp)
  800f54:	e8 04 f8 ff ff       	call   80075d <fd2num>
  800f59:	89 c3                	mov    %eax,%ebx
  800f5b:	83 c4 10             	add    $0x10,%esp
}
  800f5e:	89 d8                	mov    %ebx,%eax
  800f60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f63:	5b                   	pop    %ebx
  800f64:	5e                   	pop    %esi
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    
		fd_close(fd, 0);
  800f67:	83 ec 08             	sub    $0x8,%esp
  800f6a:	6a 00                	push   $0x0
  800f6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6f:	e8 0b f9 ff ff       	call   80087f <fd_close>
		return r;
  800f74:	83 c4 10             	add    $0x10,%esp
  800f77:	eb e5                	jmp    800f5e <open+0x6c>
		return -E_BAD_PATH;
  800f79:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800f7e:	eb de                	jmp    800f5e <open+0x6c>

00800f80 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800f86:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8b:	b8 08 00 00 00       	mov    $0x8,%eax
  800f90:	e8 5a fd ff ff       	call   800cef <fsipc>
}
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
  800f9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800f9f:	83 ec 0c             	sub    $0xc,%esp
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 c3 f7 ff ff       	call   80076d <fd2data>
  800faa:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fac:	83 c4 08             	add    $0x8,%esp
  800faf:	68 9b 1f 80 00       	push   $0x801f9b
  800fb4:	53                   	push   %ebx
  800fb5:	e8 b9 f1 ff ff       	call   800173 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fba:	8b 46 04             	mov    0x4(%esi),%eax
  800fbd:	2b 06                	sub    (%esi),%eax
  800fbf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800fc5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800fcc:	00 00 00 
	stat->st_dev = &devpipe;
  800fcf:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800fd6:	30 80 00 
	return 0;
}
  800fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	53                   	push   %ebx
  800fe9:	83 ec 0c             	sub    $0xc,%esp
  800fec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800fef:	53                   	push   %ebx
  800ff0:	6a 00                	push   $0x0
  800ff2:	e8 fa f5 ff ff       	call   8005f1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800ff7:	89 1c 24             	mov    %ebx,(%esp)
  800ffa:	e8 6e f7 ff ff       	call   80076d <fd2data>
  800fff:	83 c4 08             	add    $0x8,%esp
  801002:	50                   	push   %eax
  801003:	6a 00                	push   $0x0
  801005:	e8 e7 f5 ff ff       	call   8005f1 <sys_page_unmap>
}
  80100a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <_pipeisclosed>:
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
  801015:	83 ec 1c             	sub    $0x1c,%esp
  801018:	89 c7                	mov    %eax,%edi
  80101a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80101c:	a1 04 40 80 00       	mov    0x804004,%eax
  801021:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801024:	83 ec 0c             	sub    $0xc,%esp
  801027:	57                   	push   %edi
  801028:	e8 ed 0b 00 00       	call   801c1a <pageref>
  80102d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801030:	89 34 24             	mov    %esi,(%esp)
  801033:	e8 e2 0b 00 00       	call   801c1a <pageref>
		nn = thisenv->env_runs;
  801038:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80103e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801041:	83 c4 10             	add    $0x10,%esp
  801044:	39 cb                	cmp    %ecx,%ebx
  801046:	74 1b                	je     801063 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801048:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80104b:	75 cf                	jne    80101c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80104d:	8b 42 58             	mov    0x58(%edx),%eax
  801050:	6a 01                	push   $0x1
  801052:	50                   	push   %eax
  801053:	53                   	push   %ebx
  801054:	68 a2 1f 80 00       	push   $0x801fa2
  801059:	e8 de 04 00 00       	call   80153c <cprintf>
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	eb b9                	jmp    80101c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801063:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801066:	0f 94 c0             	sete   %al
  801069:	0f b6 c0             	movzbl %al,%eax
}
  80106c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106f:	5b                   	pop    %ebx
  801070:	5e                   	pop    %esi
  801071:	5f                   	pop    %edi
  801072:	5d                   	pop    %ebp
  801073:	c3                   	ret    

00801074 <devpipe_write>:
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	57                   	push   %edi
  801078:	56                   	push   %esi
  801079:	53                   	push   %ebx
  80107a:	83 ec 28             	sub    $0x28,%esp
  80107d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801080:	56                   	push   %esi
  801081:	e8 e7 f6 ff ff       	call   80076d <fd2data>
  801086:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	bf 00 00 00 00       	mov    $0x0,%edi
  801090:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801093:	74 4f                	je     8010e4 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801095:	8b 43 04             	mov    0x4(%ebx),%eax
  801098:	8b 0b                	mov    (%ebx),%ecx
  80109a:	8d 51 20             	lea    0x20(%ecx),%edx
  80109d:	39 d0                	cmp    %edx,%eax
  80109f:	72 14                	jb     8010b5 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010a1:	89 da                	mov    %ebx,%edx
  8010a3:	89 f0                	mov    %esi,%eax
  8010a5:	e8 65 ff ff ff       	call   80100f <_pipeisclosed>
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 3a                	jne    8010e8 <devpipe_write+0x74>
			sys_yield();
  8010ae:	e8 9a f4 ff ff       	call   80054d <sys_yield>
  8010b3:	eb e0                	jmp    801095 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010bc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010bf:	89 c2                	mov    %eax,%edx
  8010c1:	c1 fa 1f             	sar    $0x1f,%edx
  8010c4:	89 d1                	mov    %edx,%ecx
  8010c6:	c1 e9 1b             	shr    $0x1b,%ecx
  8010c9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010cc:	83 e2 1f             	and    $0x1f,%edx
  8010cf:	29 ca                	sub    %ecx,%edx
  8010d1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8010d5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8010d9:	83 c0 01             	add    $0x1,%eax
  8010dc:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8010df:	83 c7 01             	add    $0x1,%edi
  8010e2:	eb ac                	jmp    801090 <devpipe_write+0x1c>
	return i;
  8010e4:	89 f8                	mov    %edi,%eax
  8010e6:	eb 05                	jmp    8010ed <devpipe_write+0x79>
				return 0;
  8010e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <devpipe_read>:
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
  8010fb:	83 ec 18             	sub    $0x18,%esp
  8010fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801101:	57                   	push   %edi
  801102:	e8 66 f6 ff ff       	call   80076d <fd2data>
  801107:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801109:	83 c4 10             	add    $0x10,%esp
  80110c:	be 00 00 00 00       	mov    $0x0,%esi
  801111:	3b 75 10             	cmp    0x10(%ebp),%esi
  801114:	74 47                	je     80115d <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801116:	8b 03                	mov    (%ebx),%eax
  801118:	3b 43 04             	cmp    0x4(%ebx),%eax
  80111b:	75 22                	jne    80113f <devpipe_read+0x4a>
			if (i > 0)
  80111d:	85 f6                	test   %esi,%esi
  80111f:	75 14                	jne    801135 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801121:	89 da                	mov    %ebx,%edx
  801123:	89 f8                	mov    %edi,%eax
  801125:	e8 e5 fe ff ff       	call   80100f <_pipeisclosed>
  80112a:	85 c0                	test   %eax,%eax
  80112c:	75 33                	jne    801161 <devpipe_read+0x6c>
			sys_yield();
  80112e:	e8 1a f4 ff ff       	call   80054d <sys_yield>
  801133:	eb e1                	jmp    801116 <devpipe_read+0x21>
				return i;
  801135:	89 f0                	mov    %esi,%eax
}
  801137:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80113f:	99                   	cltd   
  801140:	c1 ea 1b             	shr    $0x1b,%edx
  801143:	01 d0                	add    %edx,%eax
  801145:	83 e0 1f             	and    $0x1f,%eax
  801148:	29 d0                	sub    %edx,%eax
  80114a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80114f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801152:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801155:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801158:	83 c6 01             	add    $0x1,%esi
  80115b:	eb b4                	jmp    801111 <devpipe_read+0x1c>
	return i;
  80115d:	89 f0                	mov    %esi,%eax
  80115f:	eb d6                	jmp    801137 <devpipe_read+0x42>
				return 0;
  801161:	b8 00 00 00 00       	mov    $0x0,%eax
  801166:	eb cf                	jmp    801137 <devpipe_read+0x42>

00801168 <pipe>:
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	56                   	push   %esi
  80116c:	53                   	push   %ebx
  80116d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801170:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801173:	50                   	push   %eax
  801174:	e8 0b f6 ff ff       	call   800784 <fd_alloc>
  801179:	89 c3                	mov    %eax,%ebx
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	85 c0                	test   %eax,%eax
  801180:	78 5b                	js     8011dd <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801182:	83 ec 04             	sub    $0x4,%esp
  801185:	68 07 04 00 00       	push   $0x407
  80118a:	ff 75 f4             	pushl  -0xc(%ebp)
  80118d:	6a 00                	push   $0x0
  80118f:	e8 d8 f3 ff ff       	call   80056c <sys_page_alloc>
  801194:	89 c3                	mov    %eax,%ebx
  801196:	83 c4 10             	add    $0x10,%esp
  801199:	85 c0                	test   %eax,%eax
  80119b:	78 40                	js     8011dd <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80119d:	83 ec 0c             	sub    $0xc,%esp
  8011a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a3:	50                   	push   %eax
  8011a4:	e8 db f5 ff ff       	call   800784 <fd_alloc>
  8011a9:	89 c3                	mov    %eax,%ebx
  8011ab:	83 c4 10             	add    $0x10,%esp
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	78 1b                	js     8011cd <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011b2:	83 ec 04             	sub    $0x4,%esp
  8011b5:	68 07 04 00 00       	push   $0x407
  8011ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8011bd:	6a 00                	push   $0x0
  8011bf:	e8 a8 f3 ff ff       	call   80056c <sys_page_alloc>
  8011c4:	89 c3                	mov    %eax,%ebx
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	79 19                	jns    8011e6 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8011cd:	83 ec 08             	sub    $0x8,%esp
  8011d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d3:	6a 00                	push   $0x0
  8011d5:	e8 17 f4 ff ff       	call   8005f1 <sys_page_unmap>
  8011da:	83 c4 10             	add    $0x10,%esp
}
  8011dd:	89 d8                	mov    %ebx,%eax
  8011df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011e2:	5b                   	pop    %ebx
  8011e3:	5e                   	pop    %esi
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    
	va = fd2data(fd0);
  8011e6:	83 ec 0c             	sub    $0xc,%esp
  8011e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ec:	e8 7c f5 ff ff       	call   80076d <fd2data>
  8011f1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011f3:	83 c4 0c             	add    $0xc,%esp
  8011f6:	68 07 04 00 00       	push   $0x407
  8011fb:	50                   	push   %eax
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 69 f3 ff ff       	call   80056c <sys_page_alloc>
  801203:	89 c3                	mov    %eax,%ebx
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	0f 88 8c 00 00 00    	js     80129c <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801210:	83 ec 0c             	sub    $0xc,%esp
  801213:	ff 75 f0             	pushl  -0x10(%ebp)
  801216:	e8 52 f5 ff ff       	call   80076d <fd2data>
  80121b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801222:	50                   	push   %eax
  801223:	6a 00                	push   $0x0
  801225:	56                   	push   %esi
  801226:	6a 00                	push   $0x0
  801228:	e8 82 f3 ff ff       	call   8005af <sys_page_map>
  80122d:	89 c3                	mov    %eax,%ebx
  80122f:	83 c4 20             	add    $0x20,%esp
  801232:	85 c0                	test   %eax,%eax
  801234:	78 58                	js     80128e <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801239:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80123f:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801244:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80124b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801254:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801259:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	ff 75 f4             	pushl  -0xc(%ebp)
  801266:	e8 f2 f4 ff ff       	call   80075d <fd2num>
  80126b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80126e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801270:	83 c4 04             	add    $0x4,%esp
  801273:	ff 75 f0             	pushl  -0x10(%ebp)
  801276:	e8 e2 f4 ff ff       	call   80075d <fd2num>
  80127b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801281:	83 c4 10             	add    $0x10,%esp
  801284:	bb 00 00 00 00       	mov    $0x0,%ebx
  801289:	e9 4f ff ff ff       	jmp    8011dd <pipe+0x75>
	sys_page_unmap(0, va);
  80128e:	83 ec 08             	sub    $0x8,%esp
  801291:	56                   	push   %esi
  801292:	6a 00                	push   $0x0
  801294:	e8 58 f3 ff ff       	call   8005f1 <sys_page_unmap>
  801299:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80129c:	83 ec 08             	sub    $0x8,%esp
  80129f:	ff 75 f0             	pushl  -0x10(%ebp)
  8012a2:	6a 00                	push   $0x0
  8012a4:	e8 48 f3 ff ff       	call   8005f1 <sys_page_unmap>
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	e9 1c ff ff ff       	jmp    8011cd <pipe+0x65>

008012b1 <pipeisclosed>:
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ba:	50                   	push   %eax
  8012bb:	ff 75 08             	pushl  0x8(%ebp)
  8012be:	e8 10 f5 ff ff       	call   8007d3 <fd_lookup>
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	78 18                	js     8012e2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012ca:	83 ec 0c             	sub    $0xc,%esp
  8012cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d0:	e8 98 f4 ff ff       	call   80076d <fd2data>
	return _pipeisclosed(fd, p);
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012da:	e8 30 fd ff ff       	call   80100f <_pipeisclosed>
  8012df:	83 c4 10             	add    $0x10,%esp
}
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8012e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ec:	5d                   	pop    %ebp
  8012ed:	c3                   	ret    

008012ee <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8012f4:	68 ba 1f 80 00       	push   $0x801fba
  8012f9:	ff 75 0c             	pushl  0xc(%ebp)
  8012fc:	e8 72 ee ff ff       	call   800173 <strcpy>
	return 0;
}
  801301:	b8 00 00 00 00       	mov    $0x0,%eax
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <devcons_write>:
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	57                   	push   %edi
  80130c:	56                   	push   %esi
  80130d:	53                   	push   %ebx
  80130e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801314:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801319:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80131f:	eb 2f                	jmp    801350 <devcons_write+0x48>
		m = n - tot;
  801321:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801324:	29 f3                	sub    %esi,%ebx
  801326:	83 fb 7f             	cmp    $0x7f,%ebx
  801329:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80132e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	53                   	push   %ebx
  801335:	89 f0                	mov    %esi,%eax
  801337:	03 45 0c             	add    0xc(%ebp),%eax
  80133a:	50                   	push   %eax
  80133b:	57                   	push   %edi
  80133c:	e8 c0 ef ff ff       	call   800301 <memmove>
		sys_cputs(buf, m);
  801341:	83 c4 08             	add    $0x8,%esp
  801344:	53                   	push   %ebx
  801345:	57                   	push   %edi
  801346:	e8 65 f1 ff ff       	call   8004b0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80134b:	01 de                	add    %ebx,%esi
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	3b 75 10             	cmp    0x10(%ebp),%esi
  801353:	72 cc                	jb     801321 <devcons_write+0x19>
}
  801355:	89 f0                	mov    %esi,%eax
  801357:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135a:	5b                   	pop    %ebx
  80135b:	5e                   	pop    %esi
  80135c:	5f                   	pop    %edi
  80135d:	5d                   	pop    %ebp
  80135e:	c3                   	ret    

0080135f <devcons_read>:
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80136a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80136e:	75 07                	jne    801377 <devcons_read+0x18>
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    
		sys_yield();
  801372:	e8 d6 f1 ff ff       	call   80054d <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801377:	e8 52 f1 ff ff       	call   8004ce <sys_cgetc>
  80137c:	85 c0                	test   %eax,%eax
  80137e:	74 f2                	je     801372 <devcons_read+0x13>
	if (c < 0)
  801380:	85 c0                	test   %eax,%eax
  801382:	78 ec                	js     801370 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801384:	83 f8 04             	cmp    $0x4,%eax
  801387:	74 0c                	je     801395 <devcons_read+0x36>
	*(char*)vbuf = c;
  801389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138c:	88 02                	mov    %al,(%edx)
	return 1;
  80138e:	b8 01 00 00 00       	mov    $0x1,%eax
  801393:	eb db                	jmp    801370 <devcons_read+0x11>
		return 0;
  801395:	b8 00 00 00 00       	mov    $0x0,%eax
  80139a:	eb d4                	jmp    801370 <devcons_read+0x11>

0080139c <cputchar>:
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8013a8:	6a 01                	push   $0x1
  8013aa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013ad:	50                   	push   %eax
  8013ae:	e8 fd f0 ff ff       	call   8004b0 <sys_cputs>
}
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <getchar>:
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8013be:	6a 01                	push   $0x1
  8013c0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8013c3:	50                   	push   %eax
  8013c4:	6a 00                	push   $0x0
  8013c6:	e8 79 f6 ff ff       	call   800a44 <read>
	if (r < 0)
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 08                	js     8013da <getchar+0x22>
	if (r < 1)
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	7e 06                	jle    8013dc <getchar+0x24>
	return c;
  8013d6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8013da:	c9                   	leave  
  8013db:	c3                   	ret    
		return -E_EOF;
  8013dc:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8013e1:	eb f7                	jmp    8013da <getchar+0x22>

008013e3 <iscons>:
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	ff 75 08             	pushl  0x8(%ebp)
  8013f0:	e8 de f3 ff ff       	call   8007d3 <fd_lookup>
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	78 11                	js     80140d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8013fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ff:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801405:	39 10                	cmp    %edx,(%eax)
  801407:	0f 94 c0             	sete   %al
  80140a:	0f b6 c0             	movzbl %al,%eax
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <opencons>:
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801415:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801418:	50                   	push   %eax
  801419:	e8 66 f3 ff ff       	call   800784 <fd_alloc>
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 3a                	js     80145f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801425:	83 ec 04             	sub    $0x4,%esp
  801428:	68 07 04 00 00       	push   $0x407
  80142d:	ff 75 f4             	pushl  -0xc(%ebp)
  801430:	6a 00                	push   $0x0
  801432:	e8 35 f1 ff ff       	call   80056c <sys_page_alloc>
  801437:	83 c4 10             	add    $0x10,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	78 21                	js     80145f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80143e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801441:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801447:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801453:	83 ec 0c             	sub    $0xc,%esp
  801456:	50                   	push   %eax
  801457:	e8 01 f3 ff ff       	call   80075d <fd2num>
  80145c:	83 c4 10             	add    $0x10,%esp
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	56                   	push   %esi
  801465:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801466:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801469:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80146f:	e8 ba f0 ff ff       	call   80052e <sys_getenvid>
  801474:	83 ec 0c             	sub    $0xc,%esp
  801477:	ff 75 0c             	pushl  0xc(%ebp)
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	56                   	push   %esi
  80147e:	50                   	push   %eax
  80147f:	68 c8 1f 80 00       	push   $0x801fc8
  801484:	e8 b3 00 00 00       	call   80153c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801489:	83 c4 18             	add    $0x18,%esp
  80148c:	53                   	push   %ebx
  80148d:	ff 75 10             	pushl  0x10(%ebp)
  801490:	e8 56 00 00 00       	call   8014eb <vcprintf>
	cprintf("\n");
  801495:	c7 04 24 b3 1f 80 00 	movl   $0x801fb3,(%esp)
  80149c:	e8 9b 00 00 00       	call   80153c <cprintf>
  8014a1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8014a4:	cc                   	int3   
  8014a5:	eb fd                	jmp    8014a4 <_panic+0x43>

008014a7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	53                   	push   %ebx
  8014ab:	83 ec 04             	sub    $0x4,%esp
  8014ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8014b1:	8b 13                	mov    (%ebx),%edx
  8014b3:	8d 42 01             	lea    0x1(%edx),%eax
  8014b6:	89 03                	mov    %eax,(%ebx)
  8014b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014bb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8014bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014c4:	74 09                	je     8014cf <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8014c6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8014ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8014cf:	83 ec 08             	sub    $0x8,%esp
  8014d2:	68 ff 00 00 00       	push   $0xff
  8014d7:	8d 43 08             	lea    0x8(%ebx),%eax
  8014da:	50                   	push   %eax
  8014db:	e8 d0 ef ff ff       	call   8004b0 <sys_cputs>
		b->idx = 0;
  8014e0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	eb db                	jmp    8014c6 <putch+0x1f>

008014eb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8014fb:	00 00 00 
	b.cnt = 0;
  8014fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801505:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801508:	ff 75 0c             	pushl  0xc(%ebp)
  80150b:	ff 75 08             	pushl  0x8(%ebp)
  80150e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801514:	50                   	push   %eax
  801515:	68 a7 14 80 00       	push   $0x8014a7
  80151a:	e8 1a 01 00 00       	call   801639 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80151f:	83 c4 08             	add    $0x8,%esp
  801522:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801528:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80152e:	50                   	push   %eax
  80152f:	e8 7c ef ff ff       	call   8004b0 <sys_cputs>

	return b.cnt;
}
  801534:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801542:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801545:	50                   	push   %eax
  801546:	ff 75 08             	pushl  0x8(%ebp)
  801549:	e8 9d ff ff ff       	call   8014eb <vcprintf>
	va_end(ap);

	return cnt;
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	57                   	push   %edi
  801554:	56                   	push   %esi
  801555:	53                   	push   %ebx
  801556:	83 ec 1c             	sub    $0x1c,%esp
  801559:	89 c7                	mov    %eax,%edi
  80155b:	89 d6                	mov    %edx,%esi
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8b 55 0c             	mov    0xc(%ebp),%edx
  801563:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801566:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801569:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80156c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801571:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801574:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801577:	39 d3                	cmp    %edx,%ebx
  801579:	72 05                	jb     801580 <printnum+0x30>
  80157b:	39 45 10             	cmp    %eax,0x10(%ebp)
  80157e:	77 7a                	ja     8015fa <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801580:	83 ec 0c             	sub    $0xc,%esp
  801583:	ff 75 18             	pushl  0x18(%ebp)
  801586:	8b 45 14             	mov    0x14(%ebp),%eax
  801589:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80158c:	53                   	push   %ebx
  80158d:	ff 75 10             	pushl  0x10(%ebp)
  801590:	83 ec 08             	sub    $0x8,%esp
  801593:	ff 75 e4             	pushl  -0x1c(%ebp)
  801596:	ff 75 e0             	pushl  -0x20(%ebp)
  801599:	ff 75 dc             	pushl  -0x24(%ebp)
  80159c:	ff 75 d8             	pushl  -0x28(%ebp)
  80159f:	e8 bc 06 00 00       	call   801c60 <__udivdi3>
  8015a4:	83 c4 18             	add    $0x18,%esp
  8015a7:	52                   	push   %edx
  8015a8:	50                   	push   %eax
  8015a9:	89 f2                	mov    %esi,%edx
  8015ab:	89 f8                	mov    %edi,%eax
  8015ad:	e8 9e ff ff ff       	call   801550 <printnum>
  8015b2:	83 c4 20             	add    $0x20,%esp
  8015b5:	eb 13                	jmp    8015ca <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015b7:	83 ec 08             	sub    $0x8,%esp
  8015ba:	56                   	push   %esi
  8015bb:	ff 75 18             	pushl  0x18(%ebp)
  8015be:	ff d7                	call   *%edi
  8015c0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8015c3:	83 eb 01             	sub    $0x1,%ebx
  8015c6:	85 db                	test   %ebx,%ebx
  8015c8:	7f ed                	jg     8015b7 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	56                   	push   %esi
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8015d7:	ff 75 dc             	pushl  -0x24(%ebp)
  8015da:	ff 75 d8             	pushl  -0x28(%ebp)
  8015dd:	e8 9e 07 00 00       	call   801d80 <__umoddi3>
  8015e2:	83 c4 14             	add    $0x14,%esp
  8015e5:	0f be 80 eb 1f 80 00 	movsbl 0x801feb(%eax),%eax
  8015ec:	50                   	push   %eax
  8015ed:	ff d7                	call   *%edi
}
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f5:	5b                   	pop    %ebx
  8015f6:	5e                   	pop    %esi
  8015f7:	5f                   	pop    %edi
  8015f8:	5d                   	pop    %ebp
  8015f9:	c3                   	ret    
  8015fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015fd:	eb c4                	jmp    8015c3 <printnum+0x73>

008015ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801605:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801609:	8b 10                	mov    (%eax),%edx
  80160b:	3b 50 04             	cmp    0x4(%eax),%edx
  80160e:	73 0a                	jae    80161a <sprintputch+0x1b>
		*b->buf++ = ch;
  801610:	8d 4a 01             	lea    0x1(%edx),%ecx
  801613:	89 08                	mov    %ecx,(%eax)
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	88 02                	mov    %al,(%edx)
}
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <printfmt>:
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801622:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801625:	50                   	push   %eax
  801626:	ff 75 10             	pushl  0x10(%ebp)
  801629:	ff 75 0c             	pushl  0xc(%ebp)
  80162c:	ff 75 08             	pushl  0x8(%ebp)
  80162f:	e8 05 00 00 00       	call   801639 <vprintfmt>
}
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <vprintfmt>:
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	57                   	push   %edi
  80163d:	56                   	push   %esi
  80163e:	53                   	push   %ebx
  80163f:	83 ec 2c             	sub    $0x2c,%esp
  801642:	8b 75 08             	mov    0x8(%ebp),%esi
  801645:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801648:	8b 7d 10             	mov    0x10(%ebp),%edi
  80164b:	e9 c1 03 00 00       	jmp    801a11 <vprintfmt+0x3d8>
		padc = ' ';
  801650:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801654:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80165b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801662:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801669:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80166e:	8d 47 01             	lea    0x1(%edi),%eax
  801671:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801674:	0f b6 17             	movzbl (%edi),%edx
  801677:	8d 42 dd             	lea    -0x23(%edx),%eax
  80167a:	3c 55                	cmp    $0x55,%al
  80167c:	0f 87 12 04 00 00    	ja     801a94 <vprintfmt+0x45b>
  801682:	0f b6 c0             	movzbl %al,%eax
  801685:	ff 24 85 20 21 80 00 	jmp    *0x802120(,%eax,4)
  80168c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80168f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801693:	eb d9                	jmp    80166e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801695:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801698:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80169c:	eb d0                	jmp    80166e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80169e:	0f b6 d2             	movzbl %dl,%edx
  8016a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8016a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8016ac:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016af:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8016b3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8016b6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8016b9:	83 f9 09             	cmp    $0x9,%ecx
  8016bc:	77 55                	ja     801713 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8016be:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8016c1:	eb e9                	jmp    8016ac <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8016c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c6:	8b 00                	mov    (%eax),%eax
  8016c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8016cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ce:	8d 40 04             	lea    0x4(%eax),%eax
  8016d1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8016d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8016d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016db:	79 91                	jns    80166e <vprintfmt+0x35>
				width = precision, precision = -1;
  8016dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8016e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016e3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8016ea:	eb 82                	jmp    80166e <vprintfmt+0x35>
  8016ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f6:	0f 49 d0             	cmovns %eax,%edx
  8016f9:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8016fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8016ff:	e9 6a ff ff ff       	jmp    80166e <vprintfmt+0x35>
  801704:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801707:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80170e:	e9 5b ff ff ff       	jmp    80166e <vprintfmt+0x35>
  801713:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801716:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801719:	eb bc                	jmp    8016d7 <vprintfmt+0x9e>
			lflag++;
  80171b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80171e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801721:	e9 48 ff ff ff       	jmp    80166e <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801726:	8b 45 14             	mov    0x14(%ebp),%eax
  801729:	8d 78 04             	lea    0x4(%eax),%edi
  80172c:	83 ec 08             	sub    $0x8,%esp
  80172f:	53                   	push   %ebx
  801730:	ff 30                	pushl  (%eax)
  801732:	ff d6                	call   *%esi
			break;
  801734:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801737:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80173a:	e9 cf 02 00 00       	jmp    801a0e <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80173f:	8b 45 14             	mov    0x14(%ebp),%eax
  801742:	8d 78 04             	lea    0x4(%eax),%edi
  801745:	8b 00                	mov    (%eax),%eax
  801747:	99                   	cltd   
  801748:	31 d0                	xor    %edx,%eax
  80174a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80174c:	83 f8 0f             	cmp    $0xf,%eax
  80174f:	7f 23                	jg     801774 <vprintfmt+0x13b>
  801751:	8b 14 85 80 22 80 00 	mov    0x802280(,%eax,4),%edx
  801758:	85 d2                	test   %edx,%edx
  80175a:	74 18                	je     801774 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80175c:	52                   	push   %edx
  80175d:	68 81 1f 80 00       	push   $0x801f81
  801762:	53                   	push   %ebx
  801763:	56                   	push   %esi
  801764:	e8 b3 fe ff ff       	call   80161c <printfmt>
  801769:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80176c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80176f:	e9 9a 02 00 00       	jmp    801a0e <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  801774:	50                   	push   %eax
  801775:	68 03 20 80 00       	push   $0x802003
  80177a:	53                   	push   %ebx
  80177b:	56                   	push   %esi
  80177c:	e8 9b fe ff ff       	call   80161c <printfmt>
  801781:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801784:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801787:	e9 82 02 00 00       	jmp    801a0e <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80178c:	8b 45 14             	mov    0x14(%ebp),%eax
  80178f:	83 c0 04             	add    $0x4,%eax
  801792:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801795:	8b 45 14             	mov    0x14(%ebp),%eax
  801798:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80179a:	85 ff                	test   %edi,%edi
  80179c:	b8 fc 1f 80 00       	mov    $0x801ffc,%eax
  8017a1:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8017a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017a8:	0f 8e bd 00 00 00    	jle    80186b <vprintfmt+0x232>
  8017ae:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8017b2:	75 0e                	jne    8017c2 <vprintfmt+0x189>
  8017b4:	89 75 08             	mov    %esi,0x8(%ebp)
  8017b7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8017ba:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8017bd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8017c0:	eb 6d                	jmp    80182f <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	ff 75 d0             	pushl  -0x30(%ebp)
  8017c8:	57                   	push   %edi
  8017c9:	e8 86 e9 ff ff       	call   800154 <strnlen>
  8017ce:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8017d1:	29 c1                	sub    %eax,%ecx
  8017d3:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8017d6:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8017d9:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8017dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017e0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8017e3:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8017e5:	eb 0f                	jmp    8017f6 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8017e7:	83 ec 08             	sub    $0x8,%esp
  8017ea:	53                   	push   %ebx
  8017eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8017ee:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8017f0:	83 ef 01             	sub    $0x1,%edi
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	85 ff                	test   %edi,%edi
  8017f8:	7f ed                	jg     8017e7 <vprintfmt+0x1ae>
  8017fa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8017fd:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801800:	85 c9                	test   %ecx,%ecx
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
  801807:	0f 49 c1             	cmovns %ecx,%eax
  80180a:	29 c1                	sub    %eax,%ecx
  80180c:	89 75 08             	mov    %esi,0x8(%ebp)
  80180f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801812:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801815:	89 cb                	mov    %ecx,%ebx
  801817:	eb 16                	jmp    80182f <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801819:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80181d:	75 31                	jne    801850 <vprintfmt+0x217>
					putch(ch, putdat);
  80181f:	83 ec 08             	sub    $0x8,%esp
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	50                   	push   %eax
  801826:	ff 55 08             	call   *0x8(%ebp)
  801829:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80182c:	83 eb 01             	sub    $0x1,%ebx
  80182f:	83 c7 01             	add    $0x1,%edi
  801832:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801836:	0f be c2             	movsbl %dl,%eax
  801839:	85 c0                	test   %eax,%eax
  80183b:	74 59                	je     801896 <vprintfmt+0x25d>
  80183d:	85 f6                	test   %esi,%esi
  80183f:	78 d8                	js     801819 <vprintfmt+0x1e0>
  801841:	83 ee 01             	sub    $0x1,%esi
  801844:	79 d3                	jns    801819 <vprintfmt+0x1e0>
  801846:	89 df                	mov    %ebx,%edi
  801848:	8b 75 08             	mov    0x8(%ebp),%esi
  80184b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80184e:	eb 37                	jmp    801887 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801850:	0f be d2             	movsbl %dl,%edx
  801853:	83 ea 20             	sub    $0x20,%edx
  801856:	83 fa 5e             	cmp    $0x5e,%edx
  801859:	76 c4                	jbe    80181f <vprintfmt+0x1e6>
					putch('?', putdat);
  80185b:	83 ec 08             	sub    $0x8,%esp
  80185e:	ff 75 0c             	pushl  0xc(%ebp)
  801861:	6a 3f                	push   $0x3f
  801863:	ff 55 08             	call   *0x8(%ebp)
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	eb c1                	jmp    80182c <vprintfmt+0x1f3>
  80186b:	89 75 08             	mov    %esi,0x8(%ebp)
  80186e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801871:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801874:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801877:	eb b6                	jmp    80182f <vprintfmt+0x1f6>
				putch(' ', putdat);
  801879:	83 ec 08             	sub    $0x8,%esp
  80187c:	53                   	push   %ebx
  80187d:	6a 20                	push   $0x20
  80187f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801881:	83 ef 01             	sub    $0x1,%edi
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	85 ff                	test   %edi,%edi
  801889:	7f ee                	jg     801879 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80188b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80188e:	89 45 14             	mov    %eax,0x14(%ebp)
  801891:	e9 78 01 00 00       	jmp    801a0e <vprintfmt+0x3d5>
  801896:	89 df                	mov    %ebx,%edi
  801898:	8b 75 08             	mov    0x8(%ebp),%esi
  80189b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80189e:	eb e7                	jmp    801887 <vprintfmt+0x24e>
	if (lflag >= 2)
  8018a0:	83 f9 01             	cmp    $0x1,%ecx
  8018a3:	7e 3f                	jle    8018e4 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8018a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a8:	8b 50 04             	mov    0x4(%eax),%edx
  8018ab:	8b 00                	mov    (%eax),%eax
  8018ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b6:	8d 40 08             	lea    0x8(%eax),%eax
  8018b9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8018bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018c0:	79 5c                	jns    80191e <vprintfmt+0x2e5>
				putch('-', putdat);
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	53                   	push   %ebx
  8018c6:	6a 2d                	push   $0x2d
  8018c8:	ff d6                	call   *%esi
				num = -(long long) num;
  8018ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018cd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8018d0:	f7 da                	neg    %edx
  8018d2:	83 d1 00             	adc    $0x0,%ecx
  8018d5:	f7 d9                	neg    %ecx
  8018d7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8018da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8018df:	e9 10 01 00 00       	jmp    8019f4 <vprintfmt+0x3bb>
	else if (lflag)
  8018e4:	85 c9                	test   %ecx,%ecx
  8018e6:	75 1b                	jne    801903 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8018e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018eb:	8b 00                	mov    (%eax),%eax
  8018ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018f0:	89 c1                	mov    %eax,%ecx
  8018f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8018f5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8018f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fb:	8d 40 04             	lea    0x4(%eax),%eax
  8018fe:	89 45 14             	mov    %eax,0x14(%ebp)
  801901:	eb b9                	jmp    8018bc <vprintfmt+0x283>
		return va_arg(*ap, long);
  801903:	8b 45 14             	mov    0x14(%ebp),%eax
  801906:	8b 00                	mov    (%eax),%eax
  801908:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80190b:	89 c1                	mov    %eax,%ecx
  80190d:	c1 f9 1f             	sar    $0x1f,%ecx
  801910:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801913:	8b 45 14             	mov    0x14(%ebp),%eax
  801916:	8d 40 04             	lea    0x4(%eax),%eax
  801919:	89 45 14             	mov    %eax,0x14(%ebp)
  80191c:	eb 9e                	jmp    8018bc <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80191e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801921:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801924:	b8 0a 00 00 00       	mov    $0xa,%eax
  801929:	e9 c6 00 00 00       	jmp    8019f4 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80192e:	83 f9 01             	cmp    $0x1,%ecx
  801931:	7e 18                	jle    80194b <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  801933:	8b 45 14             	mov    0x14(%ebp),%eax
  801936:	8b 10                	mov    (%eax),%edx
  801938:	8b 48 04             	mov    0x4(%eax),%ecx
  80193b:	8d 40 08             	lea    0x8(%eax),%eax
  80193e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801941:	b8 0a 00 00 00       	mov    $0xa,%eax
  801946:	e9 a9 00 00 00       	jmp    8019f4 <vprintfmt+0x3bb>
	else if (lflag)
  80194b:	85 c9                	test   %ecx,%ecx
  80194d:	75 1a                	jne    801969 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80194f:	8b 45 14             	mov    0x14(%ebp),%eax
  801952:	8b 10                	mov    (%eax),%edx
  801954:	b9 00 00 00 00       	mov    $0x0,%ecx
  801959:	8d 40 04             	lea    0x4(%eax),%eax
  80195c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80195f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801964:	e9 8b 00 00 00       	jmp    8019f4 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801969:	8b 45 14             	mov    0x14(%ebp),%eax
  80196c:	8b 10                	mov    (%eax),%edx
  80196e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801973:	8d 40 04             	lea    0x4(%eax),%eax
  801976:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801979:	b8 0a 00 00 00       	mov    $0xa,%eax
  80197e:	eb 74                	jmp    8019f4 <vprintfmt+0x3bb>
	if (lflag >= 2)
  801980:	83 f9 01             	cmp    $0x1,%ecx
  801983:	7e 15                	jle    80199a <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  801985:	8b 45 14             	mov    0x14(%ebp),%eax
  801988:	8b 10                	mov    (%eax),%edx
  80198a:	8b 48 04             	mov    0x4(%eax),%ecx
  80198d:	8d 40 08             	lea    0x8(%eax),%eax
  801990:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801993:	b8 08 00 00 00       	mov    $0x8,%eax
  801998:	eb 5a                	jmp    8019f4 <vprintfmt+0x3bb>
	else if (lflag)
  80199a:	85 c9                	test   %ecx,%ecx
  80199c:	75 17                	jne    8019b5 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80199e:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a1:	8b 10                	mov    (%eax),%edx
  8019a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a8:	8d 40 04             	lea    0x4(%eax),%eax
  8019ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8019b3:	eb 3f                	jmp    8019f4 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8019b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b8:	8b 10                	mov    (%eax),%edx
  8019ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019bf:	8d 40 04             	lea    0x4(%eax),%eax
  8019c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ca:	eb 28                	jmp    8019f4 <vprintfmt+0x3bb>
			putch('0', putdat);
  8019cc:	83 ec 08             	sub    $0x8,%esp
  8019cf:	53                   	push   %ebx
  8019d0:	6a 30                	push   $0x30
  8019d2:	ff d6                	call   *%esi
			putch('x', putdat);
  8019d4:	83 c4 08             	add    $0x8,%esp
  8019d7:	53                   	push   %ebx
  8019d8:	6a 78                	push   $0x78
  8019da:	ff d6                	call   *%esi
			num = (unsigned long long)
  8019dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019df:	8b 10                	mov    (%eax),%edx
  8019e1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8019e6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8019e9:	8d 40 04             	lea    0x4(%eax),%eax
  8019ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8019ef:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8019f4:	83 ec 0c             	sub    $0xc,%esp
  8019f7:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8019fb:	57                   	push   %edi
  8019fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8019ff:	50                   	push   %eax
  801a00:	51                   	push   %ecx
  801a01:	52                   	push   %edx
  801a02:	89 da                	mov    %ebx,%edx
  801a04:	89 f0                	mov    %esi,%eax
  801a06:	e8 45 fb ff ff       	call   801550 <printnum>
			break;
  801a0b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801a0e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  801a11:	83 c7 01             	add    $0x1,%edi
  801a14:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a18:	83 f8 25             	cmp    $0x25,%eax
  801a1b:	0f 84 2f fc ff ff    	je     801650 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  801a21:	85 c0                	test   %eax,%eax
  801a23:	0f 84 8b 00 00 00    	je     801ab4 <vprintfmt+0x47b>
			putch(ch, putdat);
  801a29:	83 ec 08             	sub    $0x8,%esp
  801a2c:	53                   	push   %ebx
  801a2d:	50                   	push   %eax
  801a2e:	ff d6                	call   *%esi
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	eb dc                	jmp    801a11 <vprintfmt+0x3d8>
	if (lflag >= 2)
  801a35:	83 f9 01             	cmp    $0x1,%ecx
  801a38:	7e 15                	jle    801a4f <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  801a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3d:	8b 10                	mov    (%eax),%edx
  801a3f:	8b 48 04             	mov    0x4(%eax),%ecx
  801a42:	8d 40 08             	lea    0x8(%eax),%eax
  801a45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a48:	b8 10 00 00 00       	mov    $0x10,%eax
  801a4d:	eb a5                	jmp    8019f4 <vprintfmt+0x3bb>
	else if (lflag)
  801a4f:	85 c9                	test   %ecx,%ecx
  801a51:	75 17                	jne    801a6a <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801a53:	8b 45 14             	mov    0x14(%ebp),%eax
  801a56:	8b 10                	mov    (%eax),%edx
  801a58:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a5d:	8d 40 04             	lea    0x4(%eax),%eax
  801a60:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a63:	b8 10 00 00 00       	mov    $0x10,%eax
  801a68:	eb 8a                	jmp    8019f4 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  801a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6d:	8b 10                	mov    (%eax),%edx
  801a6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a74:	8d 40 04             	lea    0x4(%eax),%eax
  801a77:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a7a:	b8 10 00 00 00       	mov    $0x10,%eax
  801a7f:	e9 70 ff ff ff       	jmp    8019f4 <vprintfmt+0x3bb>
			putch(ch, putdat);
  801a84:	83 ec 08             	sub    $0x8,%esp
  801a87:	53                   	push   %ebx
  801a88:	6a 25                	push   $0x25
  801a8a:	ff d6                	call   *%esi
			break;
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	e9 7a ff ff ff       	jmp    801a0e <vprintfmt+0x3d5>
			putch('%', putdat);
  801a94:	83 ec 08             	sub    $0x8,%esp
  801a97:	53                   	push   %ebx
  801a98:	6a 25                	push   $0x25
  801a9a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	89 f8                	mov    %edi,%eax
  801aa1:	eb 03                	jmp    801aa6 <vprintfmt+0x46d>
  801aa3:	83 e8 01             	sub    $0x1,%eax
  801aa6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801aaa:	75 f7                	jne    801aa3 <vprintfmt+0x46a>
  801aac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aaf:	e9 5a ff ff ff       	jmp    801a0e <vprintfmt+0x3d5>
}
  801ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    

00801abc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 18             	sub    $0x18,%esp
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ac8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801acb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801acf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801ad2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	74 26                	je     801b03 <vsnprintf+0x47>
  801add:	85 d2                	test   %edx,%edx
  801adf:	7e 22                	jle    801b03 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ae1:	ff 75 14             	pushl  0x14(%ebp)
  801ae4:	ff 75 10             	pushl  0x10(%ebp)
  801ae7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801aea:	50                   	push   %eax
  801aeb:	68 ff 15 80 00       	push   $0x8015ff
  801af0:	e8 44 fb ff ff       	call   801639 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afe:	83 c4 10             	add    $0x10,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    
		return -E_INVAL;
  801b03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b08:	eb f7                	jmp    801b01 <vsnprintf+0x45>

00801b0a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b10:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b13:	50                   	push   %eax
  801b14:	ff 75 10             	pushl  0x10(%ebp)
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	e8 9a ff ff ff       	call   801abc <vsnprintf>
	va_end(ap);

	return rc;
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	56                   	push   %esi
  801b28:	53                   	push   %ebx
  801b29:	8b 75 08             	mov    0x8(%ebp),%esi
  801b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801b32:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801b34:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801b39:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801b3c:	83 ec 0c             	sub    $0xc,%esp
  801b3f:	50                   	push   %eax
  801b40:	e8 d7 eb ff ff       	call   80071c <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	85 c0                	test   %eax,%eax
  801b4a:	78 2b                	js     801b77 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801b4c:	85 f6                	test   %esi,%esi
  801b4e:	74 0a                	je     801b5a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801b50:	a1 04 40 80 00       	mov    0x804004,%eax
  801b55:	8b 40 74             	mov    0x74(%eax),%eax
  801b58:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  801b5a:	85 db                	test   %ebx,%ebx
  801b5c:	74 0a                	je     801b68 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b5e:	a1 04 40 80 00       	mov    0x804004,%eax
  801b63:	8b 40 78             	mov    0x78(%eax),%eax
  801b66:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801b68:	a1 04 40 80 00       	mov    0x804004,%eax
  801b6d:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b73:	5b                   	pop    %ebx
  801b74:	5e                   	pop    %esi
  801b75:	5d                   	pop    %ebp
  801b76:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801b77:	85 f6                	test   %esi,%esi
  801b79:	74 06                	je     801b81 <ipc_recv+0x5d>
  801b7b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801b81:	85 db                	test   %ebx,%ebx
  801b83:	74 eb                	je     801b70 <ipc_recv+0x4c>
  801b85:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b8b:	eb e3                	jmp    801b70 <ipc_recv+0x4c>

00801b8d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	57                   	push   %edi
  801b91:	56                   	push   %esi
  801b92:	53                   	push   %ebx
  801b93:	83 ec 0c             	sub    $0xc,%esp
  801b96:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b99:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801b9f:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  801ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801ba6:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801ba9:	ff 75 14             	pushl  0x14(%ebp)
  801bac:	53                   	push   %ebx
  801bad:	56                   	push   %esi
  801bae:	57                   	push   %edi
  801baf:	e8 45 eb ff ff       	call   8006f9 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	74 1e                	je     801bd9 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  801bbb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801bbe:	75 07                	jne    801bc7 <ipc_send+0x3a>
			sys_yield();
  801bc0:	e8 88 e9 ff ff       	call   80054d <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801bc5:	eb e2                	jmp    801ba9 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  801bc7:	50                   	push   %eax
  801bc8:	68 e0 22 80 00       	push   $0x8022e0
  801bcd:	6a 41                	push   $0x41
  801bcf:	68 ee 22 80 00       	push   $0x8022ee
  801bd4:	e8 88 f8 ff ff       	call   801461 <_panic>
		}
	}
}
  801bd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bdc:	5b                   	pop    %ebx
  801bdd:	5e                   	pop    %esi
  801bde:	5f                   	pop    %edi
  801bdf:	5d                   	pop    %ebp
  801be0:	c3                   	ret    

00801be1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801be7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801bec:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801bef:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801bf5:	8b 52 50             	mov    0x50(%edx),%edx
  801bf8:	39 ca                	cmp    %ecx,%edx
  801bfa:	74 11                	je     801c0d <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801bfc:	83 c0 01             	add    $0x1,%eax
  801bff:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c04:	75 e6                	jne    801bec <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c06:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0b:	eb 0b                	jmp    801c18 <ipc_find_env+0x37>
			return envs[i].env_id;
  801c0d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c10:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c15:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c18:	5d                   	pop    %ebp
  801c19:	c3                   	ret    

00801c1a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c20:	89 d0                	mov    %edx,%eax
  801c22:	c1 e8 16             	shr    $0x16,%eax
  801c25:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801c2c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801c31:	f6 c1 01             	test   $0x1,%cl
  801c34:	74 1d                	je     801c53 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801c36:	c1 ea 0c             	shr    $0xc,%edx
  801c39:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801c40:	f6 c2 01             	test   $0x1,%dl
  801c43:	74 0e                	je     801c53 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c45:	c1 ea 0c             	shr    $0xc,%edx
  801c48:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801c4f:	ef 
  801c50:	0f b7 c0             	movzwl %ax,%eax
}
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    
  801c55:	66 90                	xchg   %ax,%ax
  801c57:	66 90                	xchg   %ax,%ax
  801c59:	66 90                	xchg   %ax,%ax
  801c5b:	66 90                	xchg   %ax,%ax
  801c5d:	66 90                	xchg   %ax,%ax
  801c5f:	90                   	nop

00801c60 <__udivdi3>:
  801c60:	55                   	push   %ebp
  801c61:	57                   	push   %edi
  801c62:	56                   	push   %esi
  801c63:	53                   	push   %ebx
  801c64:	83 ec 1c             	sub    $0x1c,%esp
  801c67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801c6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801c77:	85 d2                	test   %edx,%edx
  801c79:	75 35                	jne    801cb0 <__udivdi3+0x50>
  801c7b:	39 f3                	cmp    %esi,%ebx
  801c7d:	0f 87 bd 00 00 00    	ja     801d40 <__udivdi3+0xe0>
  801c83:	85 db                	test   %ebx,%ebx
  801c85:	89 d9                	mov    %ebx,%ecx
  801c87:	75 0b                	jne    801c94 <__udivdi3+0x34>
  801c89:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8e:	31 d2                	xor    %edx,%edx
  801c90:	f7 f3                	div    %ebx
  801c92:	89 c1                	mov    %eax,%ecx
  801c94:	31 d2                	xor    %edx,%edx
  801c96:	89 f0                	mov    %esi,%eax
  801c98:	f7 f1                	div    %ecx
  801c9a:	89 c6                	mov    %eax,%esi
  801c9c:	89 e8                	mov    %ebp,%eax
  801c9e:	89 f7                	mov    %esi,%edi
  801ca0:	f7 f1                	div    %ecx
  801ca2:	89 fa                	mov    %edi,%edx
  801ca4:	83 c4 1c             	add    $0x1c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801cb0:	39 f2                	cmp    %esi,%edx
  801cb2:	77 7c                	ja     801d30 <__udivdi3+0xd0>
  801cb4:	0f bd fa             	bsr    %edx,%edi
  801cb7:	83 f7 1f             	xor    $0x1f,%edi
  801cba:	0f 84 98 00 00 00    	je     801d58 <__udivdi3+0xf8>
  801cc0:	89 f9                	mov    %edi,%ecx
  801cc2:	b8 20 00 00 00       	mov    $0x20,%eax
  801cc7:	29 f8                	sub    %edi,%eax
  801cc9:	d3 e2                	shl    %cl,%edx
  801ccb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ccf:	89 c1                	mov    %eax,%ecx
  801cd1:	89 da                	mov    %ebx,%edx
  801cd3:	d3 ea                	shr    %cl,%edx
  801cd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801cd9:	09 d1                	or     %edx,%ecx
  801cdb:	89 f2                	mov    %esi,%edx
  801cdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ce1:	89 f9                	mov    %edi,%ecx
  801ce3:	d3 e3                	shl    %cl,%ebx
  801ce5:	89 c1                	mov    %eax,%ecx
  801ce7:	d3 ea                	shr    %cl,%edx
  801ce9:	89 f9                	mov    %edi,%ecx
  801ceb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801cef:	d3 e6                	shl    %cl,%esi
  801cf1:	89 eb                	mov    %ebp,%ebx
  801cf3:	89 c1                	mov    %eax,%ecx
  801cf5:	d3 eb                	shr    %cl,%ebx
  801cf7:	09 de                	or     %ebx,%esi
  801cf9:	89 f0                	mov    %esi,%eax
  801cfb:	f7 74 24 08          	divl   0x8(%esp)
  801cff:	89 d6                	mov    %edx,%esi
  801d01:	89 c3                	mov    %eax,%ebx
  801d03:	f7 64 24 0c          	mull   0xc(%esp)
  801d07:	39 d6                	cmp    %edx,%esi
  801d09:	72 0c                	jb     801d17 <__udivdi3+0xb7>
  801d0b:	89 f9                	mov    %edi,%ecx
  801d0d:	d3 e5                	shl    %cl,%ebp
  801d0f:	39 c5                	cmp    %eax,%ebp
  801d11:	73 5d                	jae    801d70 <__udivdi3+0x110>
  801d13:	39 d6                	cmp    %edx,%esi
  801d15:	75 59                	jne    801d70 <__udivdi3+0x110>
  801d17:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d1a:	31 ff                	xor    %edi,%edi
  801d1c:	89 fa                	mov    %edi,%edx
  801d1e:	83 c4 1c             	add    $0x1c,%esp
  801d21:	5b                   	pop    %ebx
  801d22:	5e                   	pop    %esi
  801d23:	5f                   	pop    %edi
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    
  801d26:	8d 76 00             	lea    0x0(%esi),%esi
  801d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801d30:	31 ff                	xor    %edi,%edi
  801d32:	31 c0                	xor    %eax,%eax
  801d34:	89 fa                	mov    %edi,%edx
  801d36:	83 c4 1c             	add    $0x1c,%esp
  801d39:	5b                   	pop    %ebx
  801d3a:	5e                   	pop    %esi
  801d3b:	5f                   	pop    %edi
  801d3c:	5d                   	pop    %ebp
  801d3d:	c3                   	ret    
  801d3e:	66 90                	xchg   %ax,%ax
  801d40:	31 ff                	xor    %edi,%edi
  801d42:	89 e8                	mov    %ebp,%eax
  801d44:	89 f2                	mov    %esi,%edx
  801d46:	f7 f3                	div    %ebx
  801d48:	89 fa                	mov    %edi,%edx
  801d4a:	83 c4 1c             	add    $0x1c,%esp
  801d4d:	5b                   	pop    %ebx
  801d4e:	5e                   	pop    %esi
  801d4f:	5f                   	pop    %edi
  801d50:	5d                   	pop    %ebp
  801d51:	c3                   	ret    
  801d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d58:	39 f2                	cmp    %esi,%edx
  801d5a:	72 06                	jb     801d62 <__udivdi3+0x102>
  801d5c:	31 c0                	xor    %eax,%eax
  801d5e:	39 eb                	cmp    %ebp,%ebx
  801d60:	77 d2                	ja     801d34 <__udivdi3+0xd4>
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
  801d67:	eb cb                	jmp    801d34 <__udivdi3+0xd4>
  801d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d70:	89 d8                	mov    %ebx,%eax
  801d72:	31 ff                	xor    %edi,%edi
  801d74:	eb be                	jmp    801d34 <__udivdi3+0xd4>
  801d76:	66 90                	xchg   %ax,%ax
  801d78:	66 90                	xchg   %ax,%ax
  801d7a:	66 90                	xchg   %ax,%ax
  801d7c:	66 90                	xchg   %ax,%ax
  801d7e:	66 90                	xchg   %ax,%ax

00801d80 <__umoddi3>:
  801d80:	55                   	push   %ebp
  801d81:	57                   	push   %edi
  801d82:	56                   	push   %esi
  801d83:	53                   	push   %ebx
  801d84:	83 ec 1c             	sub    $0x1c,%esp
  801d87:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801d8b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801d8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801d93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d97:	85 ed                	test   %ebp,%ebp
  801d99:	89 f0                	mov    %esi,%eax
  801d9b:	89 da                	mov    %ebx,%edx
  801d9d:	75 19                	jne    801db8 <__umoddi3+0x38>
  801d9f:	39 df                	cmp    %ebx,%edi
  801da1:	0f 86 b1 00 00 00    	jbe    801e58 <__umoddi3+0xd8>
  801da7:	f7 f7                	div    %edi
  801da9:	89 d0                	mov    %edx,%eax
  801dab:	31 d2                	xor    %edx,%edx
  801dad:	83 c4 1c             	add    $0x1c,%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5f                   	pop    %edi
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    
  801db5:	8d 76 00             	lea    0x0(%esi),%esi
  801db8:	39 dd                	cmp    %ebx,%ebp
  801dba:	77 f1                	ja     801dad <__umoddi3+0x2d>
  801dbc:	0f bd cd             	bsr    %ebp,%ecx
  801dbf:	83 f1 1f             	xor    $0x1f,%ecx
  801dc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dc6:	0f 84 b4 00 00 00    	je     801e80 <__umoddi3+0x100>
  801dcc:	b8 20 00 00 00       	mov    $0x20,%eax
  801dd1:	89 c2                	mov    %eax,%edx
  801dd3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dd7:	29 c2                	sub    %eax,%edx
  801dd9:	89 c1                	mov    %eax,%ecx
  801ddb:	89 f8                	mov    %edi,%eax
  801ddd:	d3 e5                	shl    %cl,%ebp
  801ddf:	89 d1                	mov    %edx,%ecx
  801de1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801de5:	d3 e8                	shr    %cl,%eax
  801de7:	09 c5                	or     %eax,%ebp
  801de9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ded:	89 c1                	mov    %eax,%ecx
  801def:	d3 e7                	shl    %cl,%edi
  801df1:	89 d1                	mov    %edx,%ecx
  801df3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801df7:	89 df                	mov    %ebx,%edi
  801df9:	d3 ef                	shr    %cl,%edi
  801dfb:	89 c1                	mov    %eax,%ecx
  801dfd:	89 f0                	mov    %esi,%eax
  801dff:	d3 e3                	shl    %cl,%ebx
  801e01:	89 d1                	mov    %edx,%ecx
  801e03:	89 fa                	mov    %edi,%edx
  801e05:	d3 e8                	shr    %cl,%eax
  801e07:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801e0c:	09 d8                	or     %ebx,%eax
  801e0e:	f7 f5                	div    %ebp
  801e10:	d3 e6                	shl    %cl,%esi
  801e12:	89 d1                	mov    %edx,%ecx
  801e14:	f7 64 24 08          	mull   0x8(%esp)
  801e18:	39 d1                	cmp    %edx,%ecx
  801e1a:	89 c3                	mov    %eax,%ebx
  801e1c:	89 d7                	mov    %edx,%edi
  801e1e:	72 06                	jb     801e26 <__umoddi3+0xa6>
  801e20:	75 0e                	jne    801e30 <__umoddi3+0xb0>
  801e22:	39 c6                	cmp    %eax,%esi
  801e24:	73 0a                	jae    801e30 <__umoddi3+0xb0>
  801e26:	2b 44 24 08          	sub    0x8(%esp),%eax
  801e2a:	19 ea                	sbb    %ebp,%edx
  801e2c:	89 d7                	mov    %edx,%edi
  801e2e:	89 c3                	mov    %eax,%ebx
  801e30:	89 ca                	mov    %ecx,%edx
  801e32:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801e37:	29 de                	sub    %ebx,%esi
  801e39:	19 fa                	sbb    %edi,%edx
  801e3b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801e3f:	89 d0                	mov    %edx,%eax
  801e41:	d3 e0                	shl    %cl,%eax
  801e43:	89 d9                	mov    %ebx,%ecx
  801e45:	d3 ee                	shr    %cl,%esi
  801e47:	d3 ea                	shr    %cl,%edx
  801e49:	09 f0                	or     %esi,%eax
  801e4b:	83 c4 1c             	add    $0x1c,%esp
  801e4e:	5b                   	pop    %ebx
  801e4f:	5e                   	pop    %esi
  801e50:	5f                   	pop    %edi
  801e51:	5d                   	pop    %ebp
  801e52:	c3                   	ret    
  801e53:	90                   	nop
  801e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e58:	85 ff                	test   %edi,%edi
  801e5a:	89 f9                	mov    %edi,%ecx
  801e5c:	75 0b                	jne    801e69 <__umoddi3+0xe9>
  801e5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e63:	31 d2                	xor    %edx,%edx
  801e65:	f7 f7                	div    %edi
  801e67:	89 c1                	mov    %eax,%ecx
  801e69:	89 d8                	mov    %ebx,%eax
  801e6b:	31 d2                	xor    %edx,%edx
  801e6d:	f7 f1                	div    %ecx
  801e6f:	89 f0                	mov    %esi,%eax
  801e71:	f7 f1                	div    %ecx
  801e73:	e9 31 ff ff ff       	jmp    801da9 <__umoddi3+0x29>
  801e78:	90                   	nop
  801e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e80:	39 dd                	cmp    %ebx,%ebp
  801e82:	72 08                	jb     801e8c <__umoddi3+0x10c>
  801e84:	39 f7                	cmp    %esi,%edi
  801e86:	0f 87 21 ff ff ff    	ja     801dad <__umoddi3+0x2d>
  801e8c:	89 da                	mov    %ebx,%edx
  801e8e:	89 f0                	mov    %esi,%eax
  801e90:	29 f8                	sub    %edi,%eax
  801e92:	19 ea                	sbb    %ebp,%edx
  801e94:	e9 14 ff ff ff       	jmp    801dad <__umoddi3+0x2d>
