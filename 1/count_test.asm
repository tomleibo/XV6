
_count_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i,j,k=0;
   9:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  10:	00 
  for (i=0; i<80000; i++) {
  11:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  18:	00 
  19:	eb 23                	jmp    3e <main+0x3e>
	for (j=0;j<10000;j++) {
  1b:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  22:	00 
  23:	eb 0a                	jmp    2f <main+0x2f>
		k++;
  25:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
int
main(int argc, char *argv[])
{
  int i,j,k=0;
  for (i=0; i<80000; i++) {
	for (j=0;j<10000;j++) {
  2a:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
  2f:	81 7c 24 18 0f 27 00 	cmpl   $0x270f,0x18(%esp)
  36:	00 
  37:	7e ec                	jle    25 <main+0x25>

int
main(int argc, char *argv[])
{
  int i,j,k=0;
  for (i=0; i<80000; i++) {
  39:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  3e:	81 7c 24 1c 7f 38 01 	cmpl   $0x1387f,0x1c(%esp)
  45:	00 
  46:	7e d3                	jle    1b <main+0x1b>
	for (j=0;j<10000;j++) {
		k++;
	}
  }
  exit(0);
  48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  4f:	e8 68 02 00 00       	call   2bc <exit>

00000054 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	57                   	push   %edi
  58:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5c:	8b 55 10             	mov    0x10(%ebp),%edx
  5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  62:	89 cb                	mov    %ecx,%ebx
  64:	89 df                	mov    %ebx,%edi
  66:	89 d1                	mov    %edx,%ecx
  68:	fc                   	cld    
  69:	f3 aa                	rep stos %al,%es:(%edi)
  6b:	89 ca                	mov    %ecx,%edx
  6d:	89 fb                	mov    %edi,%ebx
  6f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  72:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  75:	5b                   	pop    %ebx
  76:	5f                   	pop    %edi
  77:	5d                   	pop    %ebp
  78:	c3                   	ret    

00000079 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  7f:	8b 45 08             	mov    0x8(%ebp),%eax
  82:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  85:	90                   	nop
  86:	8b 45 08             	mov    0x8(%ebp),%eax
  89:	8d 50 01             	lea    0x1(%eax),%edx
  8c:	89 55 08             	mov    %edx,0x8(%ebp)
  8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  92:	8d 4a 01             	lea    0x1(%edx),%ecx
  95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  98:	0f b6 12             	movzbl (%edx),%edx
  9b:	88 10                	mov    %dl,(%eax)
  9d:	0f b6 00             	movzbl (%eax),%eax
  a0:	84 c0                	test   %al,%al
  a2:	75 e2                	jne    86 <strcpy+0xd>
    ;
  return os;
  a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  a7:	c9                   	leave  
  a8:	c3                   	ret    

000000a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ac:	eb 08                	jmp    b6 <strcmp+0xd>
    p++, q++;
  ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	0f b6 00             	movzbl (%eax),%eax
  bc:	84 c0                	test   %al,%al
  be:	74 10                	je     d0 <strcmp+0x27>
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	0f b6 10             	movzbl (%eax),%edx
  c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  c9:	0f b6 00             	movzbl (%eax),%eax
  cc:	38 c2                	cmp    %al,%dl
  ce:	74 de                	je     ae <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d0:	8b 45 08             	mov    0x8(%ebp),%eax
  d3:	0f b6 00             	movzbl (%eax),%eax
  d6:	0f b6 d0             	movzbl %al,%edx
  d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	0f b6 c0             	movzbl %al,%eax
  e2:	29 c2                	sub    %eax,%edx
  e4:	89 d0                	mov    %edx,%eax
}
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    

000000e8 <strlen>:

uint
strlen(char *s)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  f5:	eb 04                	jmp    fb <strlen+0x13>
  f7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  fe:	8b 45 08             	mov    0x8(%ebp),%eax
 101:	01 d0                	add    %edx,%eax
 103:	0f b6 00             	movzbl (%eax),%eax
 106:	84 c0                	test   %al,%al
 108:	75 ed                	jne    f7 <strlen+0xf>
    ;
  return n;
 10a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 10d:	c9                   	leave  
 10e:	c3                   	ret    

0000010f <memset>:

void*
memset(void *dst, int c, uint n)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 115:	8b 45 10             	mov    0x10(%ebp),%eax
 118:	89 44 24 08          	mov    %eax,0x8(%esp)
 11c:	8b 45 0c             	mov    0xc(%ebp),%eax
 11f:	89 44 24 04          	mov    %eax,0x4(%esp)
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	89 04 24             	mov    %eax,(%esp)
 129:	e8 26 ff ff ff       	call   54 <stosb>
  return dst;
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 131:	c9                   	leave  
 132:	c3                   	ret    

00000133 <strchr>:

char*
strchr(const char *s, char c)
{
 133:	55                   	push   %ebp
 134:	89 e5                	mov    %esp,%ebp
 136:	83 ec 04             	sub    $0x4,%esp
 139:	8b 45 0c             	mov    0xc(%ebp),%eax
 13c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 13f:	eb 14                	jmp    155 <strchr+0x22>
    if(*s == c)
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	0f b6 00             	movzbl (%eax),%eax
 147:	3a 45 fc             	cmp    -0x4(%ebp),%al
 14a:	75 05                	jne    151 <strchr+0x1e>
      return (char*)s;
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	eb 13                	jmp    164 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 151:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	84 c0                	test   %al,%al
 15d:	75 e2                	jne    141 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 15f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 173:	eb 4c                	jmp    1c1 <gets+0x5b>
    cc = read(0, &c, 1);
 175:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 17c:	00 
 17d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 180:	89 44 24 04          	mov    %eax,0x4(%esp)
 184:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 18b:	e8 54 01 00 00       	call   2e4 <read>
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7f 02                	jg     19b <gets+0x35>
      break;
 199:	eb 31                	jmp    1cc <gets+0x66>
    buf[i++] = c;
 19b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19e:	8d 50 01             	lea    0x1(%eax),%edx
 1a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a4:	89 c2                	mov    %eax,%edx
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	01 c2                	add    %eax,%edx
 1ab:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1af:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b5:	3c 0a                	cmp    $0xa,%al
 1b7:	74 13                	je     1cc <gets+0x66>
 1b9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bd:	3c 0d                	cmp    $0xd,%al
 1bf:	74 0b                	je     1cc <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c4:	83 c0 01             	add    $0x1,%eax
 1c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ca:	7c a9                	jl     175 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 d0                	add    %edx,%eax
 1d4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <stat>:

int
stat(char *n, struct stat *st)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1e9:	00 
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	89 04 24             	mov    %eax,(%esp)
 1f0:	e8 17 01 00 00       	call   30c <open>
 1f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fc:	79 07                	jns    205 <stat+0x29>
    return -1;
 1fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 203:	eb 23                	jmp    228 <stat+0x4c>
  r = fstat(fd, st);
 205:	8b 45 0c             	mov    0xc(%ebp),%eax
 208:	89 44 24 04          	mov    %eax,0x4(%esp)
 20c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20f:	89 04 24             	mov    %eax,(%esp)
 212:	e8 0d 01 00 00       	call   324 <fstat>
 217:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21d:	89 04 24             	mov    %eax,(%esp)
 220:	e8 cf 00 00 00       	call   2f4 <close>
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 237:	eb 25                	jmp    25e <atoi+0x34>
    n = n*10 + *s++ - '0';
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	89 d0                	mov    %edx,%eax
 23e:	c1 e0 02             	shl    $0x2,%eax
 241:	01 d0                	add    %edx,%eax
 243:	01 c0                	add    %eax,%eax
 245:	89 c1                	mov    %eax,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 08             	mov    %edx,0x8(%ebp)
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 0a                	jle    272 <atoi+0x48>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 39                	cmp    $0x39,%al
 270:	7e c7                	jle    239 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 289:	eb 17                	jmp    2a2 <memmove+0x2b>
    *dst++ = *src++;
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28e:	8d 50 01             	lea    0x1(%eax),%edx
 291:	89 55 fc             	mov    %edx,-0x4(%ebp)
 294:	8b 55 f8             	mov    -0x8(%ebp),%edx
 297:	8d 4a 01             	lea    0x1(%edx),%ecx
 29a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 29d:	0f b6 12             	movzbl (%edx),%edx
 2a0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a8:	89 55 10             	mov    %edx,0x10(%ebp)
 2ab:	85 c0                	test   %eax,%eax
 2ad:	7f dc                	jg     28b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 2b4:	b8 01 00 00 00       	mov    $0x1,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <exit>:
SYSCALL(exit)
 2bc:	b8 02 00 00 00       	mov    $0x2,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <wait>:
SYSCALL(wait)
 2c4:	b8 03 00 00 00       	mov    $0x3,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <waitpid>:
SYSCALL(waitpid)
 2cc:	b8 16 00 00 00       	mov    $0x16,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <wait_stat>:
SYSCALL(wait_stat)
 2d4:	b8 17 00 00 00       	mov    $0x17,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <pipe>:
SYSCALL(pipe)
 2dc:	b8 04 00 00 00       	mov    $0x4,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <read>:
SYSCALL(read)
 2e4:	b8 05 00 00 00       	mov    $0x5,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <write>:
SYSCALL(write)
 2ec:	b8 10 00 00 00       	mov    $0x10,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <close>:
SYSCALL(close)
 2f4:	b8 15 00 00 00       	mov    $0x15,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <kill>:
SYSCALL(kill)
 2fc:	b8 06 00 00 00       	mov    $0x6,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <exec>:
SYSCALL(exec)
 304:	b8 07 00 00 00       	mov    $0x7,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <open>:
SYSCALL(open)
 30c:	b8 0f 00 00 00       	mov    $0xf,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <mknod>:
SYSCALL(mknod)
 314:	b8 11 00 00 00       	mov    $0x11,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <unlink>:
SYSCALL(unlink)
 31c:	b8 12 00 00 00       	mov    $0x12,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <fstat>:
SYSCALL(fstat)
 324:	b8 08 00 00 00       	mov    $0x8,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <link>:
SYSCALL(link)
 32c:	b8 13 00 00 00       	mov    $0x13,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <mkdir>:
SYSCALL(mkdir)
 334:	b8 14 00 00 00       	mov    $0x14,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <chdir>:
SYSCALL(chdir)
 33c:	b8 09 00 00 00       	mov    $0x9,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <dup>:
SYSCALL(dup)
 344:	b8 0a 00 00 00       	mov    $0xa,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <getpid>:
SYSCALL(getpid)
 34c:	b8 0b 00 00 00       	mov    $0xb,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <sbrk>:
SYSCALL(sbrk)
 354:	b8 0c 00 00 00       	mov    $0xc,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <set_priority>:
SYSCALL(set_priority)
 35c:	b8 18 00 00 00       	mov    $0x18,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <canRemoveJob>:
SYSCALL(canRemoveJob)
 364:	b8 19 00 00 00       	mov    $0x19,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <jobs>:
SYSCALL(jobs)
 36c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <sleep>:
SYSCALL(sleep)
 374:	b8 0d 00 00 00       	mov    $0xd,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <uptime>:
SYSCALL(uptime)
 37c:	b8 0e 00 00 00       	mov    $0xe,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <gidpid>:
SYSCALL(gidpid)
 384:	b8 1b 00 00 00       	mov    $0x1b,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <isShell>:
SYSCALL(isShell)
 38c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	83 ec 18             	sub    $0x18,%esp
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a7:	00 
 3a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	89 04 24             	mov    %eax,(%esp)
 3b5:	e8 32 ff ff ff       	call   2ec <write>
}
 3ba:	c9                   	leave  
 3bb:	c3                   	ret    

000003bc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3bc:	55                   	push   %ebp
 3bd:	89 e5                	mov    %esp,%ebp
 3bf:	56                   	push   %esi
 3c0:	53                   	push   %ebx
 3c1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3cb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3cf:	74 17                	je     3e8 <printint+0x2c>
 3d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d5:	79 11                	jns    3e8 <printint+0x2c>
    neg = 1;
 3d7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3de:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e1:	f7 d8                	neg    %eax
 3e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e6:	eb 06                	jmp    3ee <printint+0x32>
  } else {
    x = xx;
 3e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3f8:	8d 41 01             	lea    0x1(%ecx),%eax
 3fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
 401:	8b 45 ec             	mov    -0x14(%ebp),%eax
 404:	ba 00 00 00 00       	mov    $0x0,%edx
 409:	f7 f3                	div    %ebx
 40b:	89 d0                	mov    %edx,%eax
 40d:	0f b6 80 8c 0a 00 00 	movzbl 0xa8c(%eax),%eax
 414:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 418:	8b 75 10             	mov    0x10(%ebp),%esi
 41b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41e:	ba 00 00 00 00       	mov    $0x0,%edx
 423:	f7 f6                	div    %esi
 425:	89 45 ec             	mov    %eax,-0x14(%ebp)
 428:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42c:	75 c7                	jne    3f5 <printint+0x39>
  if(neg)
 42e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 432:	74 10                	je     444 <printint+0x88>
    buf[i++] = '-';
 434:	8b 45 f4             	mov    -0xc(%ebp),%eax
 437:	8d 50 01             	lea    0x1(%eax),%edx
 43a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 43d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 442:	eb 1f                	jmp    463 <printint+0xa7>
 444:	eb 1d                	jmp    463 <printint+0xa7>
    putc(fd, buf[i]);
 446:	8d 55 dc             	lea    -0x24(%ebp),%edx
 449:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44c:	01 d0                	add    %edx,%eax
 44e:	0f b6 00             	movzbl (%eax),%eax
 451:	0f be c0             	movsbl %al,%eax
 454:	89 44 24 04          	mov    %eax,0x4(%esp)
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	89 04 24             	mov    %eax,(%esp)
 45e:	e8 31 ff ff ff       	call   394 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 463:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46b:	79 d9                	jns    446 <printint+0x8a>
    putc(fd, buf[i]);
}
 46d:	83 c4 30             	add    $0x30,%esp
 470:	5b                   	pop    %ebx
 471:	5e                   	pop    %esi
 472:	5d                   	pop    %ebp
 473:	c3                   	ret    

00000474 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 481:	8d 45 0c             	lea    0xc(%ebp),%eax
 484:	83 c0 04             	add    $0x4,%eax
 487:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 48a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 491:	e9 7c 01 00 00       	jmp    612 <printf+0x19e>
    c = fmt[i] & 0xff;
 496:	8b 55 0c             	mov    0xc(%ebp),%edx
 499:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49c:	01 d0                	add    %edx,%eax
 49e:	0f b6 00             	movzbl (%eax),%eax
 4a1:	0f be c0             	movsbl %al,%eax
 4a4:	25 ff 00 00 00       	and    $0xff,%eax
 4a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b0:	75 2c                	jne    4de <printf+0x6a>
      if(c == '%'){
 4b2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b6:	75 0c                	jne    4c4 <printf+0x50>
        state = '%';
 4b8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4bf:	e9 4a 01 00 00       	jmp    60e <printf+0x19a>
      } else {
        putc(fd, c);
 4c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c7:	0f be c0             	movsbl %al,%eax
 4ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	89 04 24             	mov    %eax,(%esp)
 4d4:	e8 bb fe ff ff       	call   394 <putc>
 4d9:	e9 30 01 00 00       	jmp    60e <printf+0x19a>
      }
    } else if(state == '%'){
 4de:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e2:	0f 85 26 01 00 00    	jne    60e <printf+0x19a>
      if(c == 'd'){
 4e8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ec:	75 2d                	jne    51b <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f1:	8b 00                	mov    (%eax),%eax
 4f3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4fa:	00 
 4fb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 502:	00 
 503:	89 44 24 04          	mov    %eax,0x4(%esp)
 507:	8b 45 08             	mov    0x8(%ebp),%eax
 50a:	89 04 24             	mov    %eax,(%esp)
 50d:	e8 aa fe ff ff       	call   3bc <printint>
        ap++;
 512:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 516:	e9 ec 00 00 00       	jmp    607 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 51b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51f:	74 06                	je     527 <printf+0xb3>
 521:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 525:	75 2d                	jne    554 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 527:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52a:	8b 00                	mov    (%eax),%eax
 52c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 533:	00 
 534:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 53b:	00 
 53c:	89 44 24 04          	mov    %eax,0x4(%esp)
 540:	8b 45 08             	mov    0x8(%ebp),%eax
 543:	89 04 24             	mov    %eax,(%esp)
 546:	e8 71 fe ff ff       	call   3bc <printint>
        ap++;
 54b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54f:	e9 b3 00 00 00       	jmp    607 <printf+0x193>
      } else if(c == 's'){
 554:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 558:	75 45                	jne    59f <printf+0x12b>
        s = (char*)*ap;
 55a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55d:	8b 00                	mov    (%eax),%eax
 55f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 562:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56a:	75 09                	jne    575 <printf+0x101>
          s = "(null)";
 56c:	c7 45 f4 40 08 00 00 	movl   $0x840,-0xc(%ebp)
        while(*s != 0){
 573:	eb 1e                	jmp    593 <printf+0x11f>
 575:	eb 1c                	jmp    593 <printf+0x11f>
          putc(fd, *s);
 577:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57a:	0f b6 00             	movzbl (%eax),%eax
 57d:	0f be c0             	movsbl %al,%eax
 580:	89 44 24 04          	mov    %eax,0x4(%esp)
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	89 04 24             	mov    %eax,(%esp)
 58a:	e8 05 fe ff ff       	call   394 <putc>
          s++;
 58f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 593:	8b 45 f4             	mov    -0xc(%ebp),%eax
 596:	0f b6 00             	movzbl (%eax),%eax
 599:	84 c0                	test   %al,%al
 59b:	75 da                	jne    577 <printf+0x103>
 59d:	eb 68                	jmp    607 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a3:	75 1d                	jne    5c2 <printf+0x14e>
        putc(fd, *ap);
 5a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a8:	8b 00                	mov    (%eax),%eax
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b1:	8b 45 08             	mov    0x8(%ebp),%eax
 5b4:	89 04 24             	mov    %eax,(%esp)
 5b7:	e8 d8 fd ff ff       	call   394 <putc>
        ap++;
 5bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c0:	eb 45                	jmp    607 <printf+0x193>
      } else if(c == '%'){
 5c2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c6:	75 17                	jne    5df <printf+0x16b>
        putc(fd, c);
 5c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cb:	0f be c0             	movsbl %al,%eax
 5ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	89 04 24             	mov    %eax,(%esp)
 5d8:	e8 b7 fd ff ff       	call   394 <putc>
 5dd:	eb 28                	jmp    607 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5df:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5e6:	00 
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ea:	89 04 24             	mov    %eax,(%esp)
 5ed:	e8 a2 fd ff ff       	call   394 <putc>
        putc(fd, c);
 5f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f5:	0f be c0             	movsbl %al,%eax
 5f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fc:	8b 45 08             	mov    0x8(%ebp),%eax
 5ff:	89 04 24             	mov    %eax,(%esp)
 602:	e8 8d fd ff ff       	call   394 <putc>
      }
      state = 0;
 607:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 60e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 612:	8b 55 0c             	mov    0xc(%ebp),%edx
 615:	8b 45 f0             	mov    -0x10(%ebp),%eax
 618:	01 d0                	add    %edx,%eax
 61a:	0f b6 00             	movzbl (%eax),%eax
 61d:	84 c0                	test   %al,%al
 61f:	0f 85 71 fe ff ff    	jne    496 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 625:	c9                   	leave  
 626:	c3                   	ret    

00000627 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 627:	55                   	push   %ebp
 628:	89 e5                	mov    %esp,%ebp
 62a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
 630:	83 e8 08             	sub    $0x8,%eax
 633:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 636:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 63b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63e:	eb 24                	jmp    664 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 648:	77 12                	ja     65c <free+0x35>
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 650:	77 24                	ja     676 <free+0x4f>
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65a:	77 1a                	ja     676 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	89 45 fc             	mov    %eax,-0x4(%ebp)
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66a:	76 d4                	jbe    640 <free+0x19>
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 674:	76 ca                	jbe    640 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	8b 40 04             	mov    0x4(%eax),%eax
 67c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	01 c2                	add    %eax,%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	39 c2                	cmp    %eax,%edx
 68f:	75 24                	jne    6b5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	8b 50 04             	mov    0x4(%eax),%edx
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	8b 40 04             	mov    0x4(%eax),%eax
 69f:	01 c2                	add    %eax,%edx
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	8b 10                	mov    (%eax),%edx
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	89 10                	mov    %edx,(%eax)
 6b3:	eb 0a                	jmp    6bf <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 10                	mov    (%eax),%edx
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 40 04             	mov    0x4(%eax),%eax
 6c5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	01 d0                	add    %edx,%eax
 6d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d4:	75 20                	jne    6f6 <free+0xcf>
    p->s.size += bp->s.size;
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 50 04             	mov    0x4(%eax),%edx
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	8b 40 04             	mov    0x4(%eax),%eax
 6e2:	01 c2                	add    %eax,%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	8b 10                	mov    (%eax),%edx
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	89 10                	mov    %edx,(%eax)
 6f4:	eb 08                	jmp    6fe <free+0xd7>
  } else
    p->s.ptr = bp;
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6fc:	89 10                	mov    %edx,(%eax)
  freep = p;
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	a3 a8 0a 00 00       	mov    %eax,0xaa8
}
 706:	c9                   	leave  
 707:	c3                   	ret    

00000708 <morecore>:

static Header*
morecore(uint nu)
{
 708:	55                   	push   %ebp
 709:	89 e5                	mov    %esp,%ebp
 70b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 70e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 715:	77 07                	ja     71e <morecore+0x16>
    nu = 4096;
 717:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 71e:	8b 45 08             	mov    0x8(%ebp),%eax
 721:	c1 e0 03             	shl    $0x3,%eax
 724:	89 04 24             	mov    %eax,(%esp)
 727:	e8 28 fc ff ff       	call   354 <sbrk>
 72c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 72f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 733:	75 07                	jne    73c <morecore+0x34>
    return 0;
 735:	b8 00 00 00 00       	mov    $0x0,%eax
 73a:	eb 22                	jmp    75e <morecore+0x56>
  hp = (Header*)p;
 73c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 742:	8b 45 f0             	mov    -0x10(%ebp),%eax
 745:	8b 55 08             	mov    0x8(%ebp),%edx
 748:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 74b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74e:	83 c0 08             	add    $0x8,%eax
 751:	89 04 24             	mov    %eax,(%esp)
 754:	e8 ce fe ff ff       	call   627 <free>
  return freep;
 759:	a1 a8 0a 00 00       	mov    0xaa8,%eax
}
 75e:	c9                   	leave  
 75f:	c3                   	ret    

00000760 <malloc>:

void*
malloc(uint nbytes)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	83 c0 07             	add    $0x7,%eax
 76c:	c1 e8 03             	shr    $0x3,%eax
 76f:	83 c0 01             	add    $0x1,%eax
 772:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 775:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 77a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 781:	75 23                	jne    7a6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 783:	c7 45 f0 a0 0a 00 00 	movl   $0xaa0,-0x10(%ebp)
 78a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78d:	a3 a8 0a 00 00       	mov    %eax,0xaa8
 792:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 797:	a3 a0 0a 00 00       	mov    %eax,0xaa0
    base.s.size = 0;
 79c:	c7 05 a4 0a 00 00 00 	movl   $0x0,0xaa4
 7a3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	8b 00                	mov    (%eax),%eax
 7ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	8b 40 04             	mov    0x4(%eax),%eax
 7b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b7:	72 4d                	jb     806 <malloc+0xa6>
      if(p->s.size == nunits)
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 40 04             	mov    0x4(%eax),%eax
 7bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c2:	75 0c                	jne    7d0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 10                	mov    (%eax),%edx
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	89 10                	mov    %edx,(%eax)
 7ce:	eb 26                	jmp    7f6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8b 40 04             	mov    0x4(%eax),%eax
 7d6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d9:	89 c2                	mov    %eax,%edx
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 40 04             	mov    0x4(%eax),%eax
 7e7:	c1 e0 03             	shl    $0x3,%eax
 7ea:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f9:	a3 a8 0a 00 00       	mov    %eax,0xaa8
      return (void*)(p + 1);
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	83 c0 08             	add    $0x8,%eax
 804:	eb 38                	jmp    83e <malloc+0xde>
    }
    if(p == freep)
 806:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 80b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80e:	75 1b                	jne    82b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 810:	8b 45 ec             	mov    -0x14(%ebp),%eax
 813:	89 04 24             	mov    %eax,(%esp)
 816:	e8 ed fe ff ff       	call   708 <morecore>
 81b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 822:	75 07                	jne    82b <malloc+0xcb>
        return 0;
 824:	b8 00 00 00 00       	mov    $0x0,%eax
 829:	eb 13                	jmp    83e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	8b 00                	mov    (%eax),%eax
 836:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 839:	e9 70 ff ff ff       	jmp    7ae <malloc+0x4e>
}
 83e:	c9                   	leave  
 83f:	c3                   	ret    
