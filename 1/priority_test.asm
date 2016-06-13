
_priority_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"


int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
if (fork()) {
   9:	e8 e6 02 00 00       	call   2f4 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	74 0e                	je     20 <main+0x20>
	wait(0);
  12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  19:	e8 e6 02 00 00       	call   304 <wait>
  1e:	eb 68                	jmp    88 <main+0x88>
}
else {
	int i;
	for(i=1; i<4; i++){
  20:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  27:	00 
  28:	eb 43                	jmp    6d <main+0x6d>
		int pri = set_priority(i);
  2a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 66 03 00 00       	call   39c <set_priority>
  36:	89 44 24 18          	mov    %eax,0x18(%esp)
		if(pri != i) {
  3a:	8b 44 24 18          	mov    0x18(%esp),%eax
  3e:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
  42:	74 24                	je     68 <main+0x68>
			printf(1,"YOU SUCK %d %d\n",i, pri);
  44:	8b 44 24 18          	mov    0x18(%esp),%eax
  48:	89 44 24 0c          	mov    %eax,0xc(%esp)
  4c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  50:	89 44 24 08          	mov    %eax,0x8(%esp)
  54:	c7 44 24 04 80 08 00 	movl   $0x880,0x4(%esp)
  5b:	00 
  5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  63:	e8 4c 04 00 00       	call   4b4 <printf>
if (fork()) {
	wait(0);
}
else {
	int i;
	for(i=1; i<4; i++){
  68:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  6d:	83 7c 24 1c 03       	cmpl   $0x3,0x1c(%esp)
  72:	7e b6                	jle    2a <main+0x2a>
		int pri = set_priority(i);
		if(pri != i) {
			printf(1,"YOU SUCK %d %d\n",i, pri);
		}
	}
	printf(1, "OK!\n");
  74:	c7 44 24 04 90 08 00 	movl   $0x890,0x4(%esp)
  7b:	00 
  7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  83:	e8 2c 04 00 00       	call   4b4 <printf>
}
exit(0);
  88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8f:	e8 68 02 00 00       	call   2fc <exit>

00000094 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	57                   	push   %edi
  98:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9c:	8b 55 10             	mov    0x10(%ebp),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	89 cb                	mov    %ecx,%ebx
  a4:	89 df                	mov    %ebx,%edi
  a6:	89 d1                	mov    %edx,%ecx
  a8:	fc                   	cld    
  a9:	f3 aa                	rep stos %al,%es:(%edi)
  ab:	89 ca                	mov    %ecx,%edx
  ad:	89 fb                	mov    %edi,%ebx
  af:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b5:	5b                   	pop    %ebx
  b6:	5f                   	pop    %edi
  b7:	5d                   	pop    %ebp
  b8:	c3                   	ret    

000000b9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b9:	55                   	push   %ebp
  ba:	89 e5                	mov    %esp,%ebp
  bc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bf:	8b 45 08             	mov    0x8(%ebp),%eax
  c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c5:	90                   	nop
  c6:	8b 45 08             	mov    0x8(%ebp),%eax
  c9:	8d 50 01             	lea    0x1(%eax),%edx
  cc:	89 55 08             	mov    %edx,0x8(%ebp)
  cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  d5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d8:	0f b6 12             	movzbl (%edx),%edx
  db:	88 10                	mov    %dl,(%eax)
  dd:	0f b6 00             	movzbl (%eax),%eax
  e0:	84 c0                	test   %al,%al
  e2:	75 e2                	jne    c6 <strcpy+0xd>
    ;
  return os;
  e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e7:	c9                   	leave  
  e8:	c3                   	ret    

000000e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ec:	eb 08                	jmp    f6 <strcmp+0xd>
    p++, q++;
  ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	0f b6 00             	movzbl (%eax),%eax
  fc:	84 c0                	test   %al,%al
  fe:	74 10                	je     110 <strcmp+0x27>
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	0f b6 10             	movzbl (%eax),%edx
 106:	8b 45 0c             	mov    0xc(%ebp),%eax
 109:	0f b6 00             	movzbl (%eax),%eax
 10c:	38 c2                	cmp    %al,%dl
 10e:	74 de                	je     ee <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	0f b6 d0             	movzbl %al,%edx
 119:	8b 45 0c             	mov    0xc(%ebp),%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	0f b6 c0             	movzbl %al,%eax
 122:	29 c2                	sub    %eax,%edx
 124:	89 d0                	mov    %edx,%eax
}
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    

00000128 <strlen>:

uint
strlen(char *s)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 135:	eb 04                	jmp    13b <strlen+0x13>
 137:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 13b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13e:	8b 45 08             	mov    0x8(%ebp),%eax
 141:	01 d0                	add    %edx,%eax
 143:	0f b6 00             	movzbl (%eax),%eax
 146:	84 c0                	test   %al,%al
 148:	75 ed                	jne    137 <strlen+0xf>
    ;
  return n;
 14a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14d:	c9                   	leave  
 14e:	c3                   	ret    

0000014f <memset>:

void*
memset(void *dst, int c, uint n)
{
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
 152:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 155:	8b 45 10             	mov    0x10(%ebp),%eax
 158:	89 44 24 08          	mov    %eax,0x8(%esp)
 15c:	8b 45 0c             	mov    0xc(%ebp),%eax
 15f:	89 44 24 04          	mov    %eax,0x4(%esp)
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	89 04 24             	mov    %eax,(%esp)
 169:	e8 26 ff ff ff       	call   94 <stosb>
  return dst;
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 171:	c9                   	leave  
 172:	c3                   	ret    

00000173 <strchr>:

char*
strchr(const char *s, char c)
{
 173:	55                   	push   %ebp
 174:	89 e5                	mov    %esp,%ebp
 176:	83 ec 04             	sub    $0x4,%esp
 179:	8b 45 0c             	mov    0xc(%ebp),%eax
 17c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 17f:	eb 14                	jmp    195 <strchr+0x22>
    if(*s == c)
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	3a 45 fc             	cmp    -0x4(%ebp),%al
 18a:	75 05                	jne    191 <strchr+0x1e>
      return (char*)s;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	eb 13                	jmp    1a4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 191:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	84 c0                	test   %al,%al
 19d:	75 e2                	jne    181 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 19f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a4:	c9                   	leave  
 1a5:	c3                   	ret    

000001a6 <gets>:

char*
gets(char *buf, int max)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1b3:	eb 4c                	jmp    201 <gets+0x5b>
    cc = read(0, &c, 1);
 1b5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1bc:	00 
 1bd:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1cb:	e8 54 01 00 00       	call   324 <read>
 1d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d7:	7f 02                	jg     1db <gets+0x35>
      break;
 1d9:	eb 31                	jmp    20c <gets+0x66>
    buf[i++] = c;
 1db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1de:	8d 50 01             	lea    0x1(%eax),%edx
 1e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e4:	89 c2                	mov    %eax,%edx
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	01 c2                	add    %eax,%edx
 1eb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ef:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1f1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f5:	3c 0a                	cmp    $0xa,%al
 1f7:	74 13                	je     20c <gets+0x66>
 1f9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fd:	3c 0d                	cmp    $0xd,%al
 1ff:	74 0b                	je     20c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 201:	8b 45 f4             	mov    -0xc(%ebp),%eax
 204:	83 c0 01             	add    $0x1,%eax
 207:	3b 45 0c             	cmp    0xc(%ebp),%eax
 20a:	7c a9                	jl     1b5 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 20c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	01 d0                	add    %edx,%eax
 214:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 217:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <stat>:

int
stat(char *n, struct stat *st)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 222:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 229:	00 
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	89 04 24             	mov    %eax,(%esp)
 230:	e8 17 01 00 00       	call   34c <open>
 235:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 23c:	79 07                	jns    245 <stat+0x29>
    return -1;
 23e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 243:	eb 23                	jmp    268 <stat+0x4c>
  r = fstat(fd, st);
 245:	8b 45 0c             	mov    0xc(%ebp),%eax
 248:	89 44 24 04          	mov    %eax,0x4(%esp)
 24c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24f:	89 04 24             	mov    %eax,(%esp)
 252:	e8 0d 01 00 00       	call   364 <fstat>
 257:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 25a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25d:	89 04 24             	mov    %eax,(%esp)
 260:	e8 cf 00 00 00       	call   334 <close>
  return r;
 265:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 268:	c9                   	leave  
 269:	c3                   	ret    

0000026a <atoi>:

int
atoi(const char *s)
{
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
 26d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 270:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 277:	eb 25                	jmp    29e <atoi+0x34>
    n = n*10 + *s++ - '0';
 279:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27c:	89 d0                	mov    %edx,%eax
 27e:	c1 e0 02             	shl    $0x2,%eax
 281:	01 d0                	add    %edx,%eax
 283:	01 c0                	add    %eax,%eax
 285:	89 c1                	mov    %eax,%ecx
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	8d 50 01             	lea    0x1(%eax),%edx
 28d:	89 55 08             	mov    %edx,0x8(%ebp)
 290:	0f b6 00             	movzbl (%eax),%eax
 293:	0f be c0             	movsbl %al,%eax
 296:	01 c8                	add    %ecx,%eax
 298:	83 e8 30             	sub    $0x30,%eax
 29b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	0f b6 00             	movzbl (%eax),%eax
 2a4:	3c 2f                	cmp    $0x2f,%al
 2a6:	7e 0a                	jle    2b2 <atoi+0x48>
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	3c 39                	cmp    $0x39,%al
 2b0:	7e c7                	jle    279 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b5:	c9                   	leave  
 2b6:	c3                   	ret    

000002b7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b7:	55                   	push   %ebp
 2b8:	89 e5                	mov    %esp,%ebp
 2ba:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c9:	eb 17                	jmp    2e2 <memmove+0x2b>
    *dst++ = *src++;
 2cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ce:	8d 50 01             	lea    0x1(%eax),%edx
 2d1:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2d7:	8d 4a 01             	lea    0x1(%edx),%ecx
 2da:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2dd:	0f b6 12             	movzbl (%edx),%edx
 2e0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e2:	8b 45 10             	mov    0x10(%ebp),%eax
 2e5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2e8:	89 55 10             	mov    %edx,0x10(%ebp)
 2eb:	85 c0                	test   %eax,%eax
 2ed:	7f dc                	jg     2cb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f2:	c9                   	leave  
 2f3:	c3                   	ret    

000002f4 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 2f4:	b8 01 00 00 00       	mov    $0x1,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <exit>:
SYSCALL(exit)
 2fc:	b8 02 00 00 00       	mov    $0x2,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <wait>:
SYSCALL(wait)
 304:	b8 03 00 00 00       	mov    $0x3,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <waitpid>:
SYSCALL(waitpid)
 30c:	b8 16 00 00 00       	mov    $0x16,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <wait_stat>:
SYSCALL(wait_stat)
 314:	b8 17 00 00 00       	mov    $0x17,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <pipe>:
SYSCALL(pipe)
 31c:	b8 04 00 00 00       	mov    $0x4,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <read>:
SYSCALL(read)
 324:	b8 05 00 00 00       	mov    $0x5,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <write>:
SYSCALL(write)
 32c:	b8 10 00 00 00       	mov    $0x10,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <close>:
SYSCALL(close)
 334:	b8 15 00 00 00       	mov    $0x15,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <kill>:
SYSCALL(kill)
 33c:	b8 06 00 00 00       	mov    $0x6,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <exec>:
SYSCALL(exec)
 344:	b8 07 00 00 00       	mov    $0x7,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <open>:
SYSCALL(open)
 34c:	b8 0f 00 00 00       	mov    $0xf,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <mknod>:
SYSCALL(mknod)
 354:	b8 11 00 00 00       	mov    $0x11,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <unlink>:
SYSCALL(unlink)
 35c:	b8 12 00 00 00       	mov    $0x12,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <fstat>:
SYSCALL(fstat)
 364:	b8 08 00 00 00       	mov    $0x8,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <link>:
SYSCALL(link)
 36c:	b8 13 00 00 00       	mov    $0x13,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <mkdir>:
SYSCALL(mkdir)
 374:	b8 14 00 00 00       	mov    $0x14,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <chdir>:
SYSCALL(chdir)
 37c:	b8 09 00 00 00       	mov    $0x9,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <dup>:
SYSCALL(dup)
 384:	b8 0a 00 00 00       	mov    $0xa,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <getpid>:
SYSCALL(getpid)
 38c:	b8 0b 00 00 00       	mov    $0xb,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <sbrk>:
SYSCALL(sbrk)
 394:	b8 0c 00 00 00       	mov    $0xc,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <set_priority>:
SYSCALL(set_priority)
 39c:	b8 18 00 00 00       	mov    $0x18,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <canRemoveJob>:
SYSCALL(canRemoveJob)
 3a4:	b8 19 00 00 00       	mov    $0x19,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <jobs>:
SYSCALL(jobs)
 3ac:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <sleep>:
SYSCALL(sleep)
 3b4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <uptime>:
SYSCALL(uptime)
 3bc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <gidpid>:
SYSCALL(gidpid)
 3c4:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <isShell>:
SYSCALL(isShell)
 3cc:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	83 ec 18             	sub    $0x18,%esp
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3e7:	00 
 3e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
 3f2:	89 04 24             	mov    %eax,(%esp)
 3f5:	e8 32 ff ff ff       	call   32c <write>
}
 3fa:	c9                   	leave  
 3fb:	c3                   	ret    

000003fc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	56                   	push   %esi
 400:	53                   	push   %ebx
 401:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 404:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 40b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 40f:	74 17                	je     428 <printint+0x2c>
 411:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 415:	79 11                	jns    428 <printint+0x2c>
    neg = 1;
 417:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 41e:	8b 45 0c             	mov    0xc(%ebp),%eax
 421:	f7 d8                	neg    %eax
 423:	89 45 ec             	mov    %eax,-0x14(%ebp)
 426:	eb 06                	jmp    42e <printint+0x32>
  } else {
    x = xx;
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 42e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 435:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 438:	8d 41 01             	lea    0x1(%ecx),%eax
 43b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 43e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 441:	8b 45 ec             	mov    -0x14(%ebp),%eax
 444:	ba 00 00 00 00       	mov    $0x0,%edx
 449:	f7 f3                	div    %ebx
 44b:	89 d0                	mov    %edx,%eax
 44d:	0f b6 80 e0 0a 00 00 	movzbl 0xae0(%eax),%eax
 454:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 458:	8b 75 10             	mov    0x10(%ebp),%esi
 45b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45e:	ba 00 00 00 00       	mov    $0x0,%edx
 463:	f7 f6                	div    %esi
 465:	89 45 ec             	mov    %eax,-0x14(%ebp)
 468:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46c:	75 c7                	jne    435 <printint+0x39>
  if(neg)
 46e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 472:	74 10                	je     484 <printint+0x88>
    buf[i++] = '-';
 474:	8b 45 f4             	mov    -0xc(%ebp),%eax
 477:	8d 50 01             	lea    0x1(%eax),%edx
 47a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 47d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 482:	eb 1f                	jmp    4a3 <printint+0xa7>
 484:	eb 1d                	jmp    4a3 <printint+0xa7>
    putc(fd, buf[i]);
 486:	8d 55 dc             	lea    -0x24(%ebp),%edx
 489:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48c:	01 d0                	add    %edx,%eax
 48e:	0f b6 00             	movzbl (%eax),%eax
 491:	0f be c0             	movsbl %al,%eax
 494:	89 44 24 04          	mov    %eax,0x4(%esp)
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	89 04 24             	mov    %eax,(%esp)
 49e:	e8 31 ff ff ff       	call   3d4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ab:	79 d9                	jns    486 <printint+0x8a>
    putc(fd, buf[i]);
}
 4ad:	83 c4 30             	add    $0x30,%esp
 4b0:	5b                   	pop    %ebx
 4b1:	5e                   	pop    %esi
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    

000004b4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b4:	55                   	push   %ebp
 4b5:	89 e5                	mov    %esp,%ebp
 4b7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c1:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c4:	83 c0 04             	add    $0x4,%eax
 4c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d1:	e9 7c 01 00 00       	jmp    652 <printf+0x19e>
    c = fmt[i] & 0xff;
 4d6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4dc:	01 d0                	add    %edx,%eax
 4de:	0f b6 00             	movzbl (%eax),%eax
 4e1:	0f be c0             	movsbl %al,%eax
 4e4:	25 ff 00 00 00       	and    $0xff,%eax
 4e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f0:	75 2c                	jne    51e <printf+0x6a>
      if(c == '%'){
 4f2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4f6:	75 0c                	jne    504 <printf+0x50>
        state = '%';
 4f8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ff:	e9 4a 01 00 00       	jmp    64e <printf+0x19a>
      } else {
        putc(fd, c);
 504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 507:	0f be c0             	movsbl %al,%eax
 50a:	89 44 24 04          	mov    %eax,0x4(%esp)
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	89 04 24             	mov    %eax,(%esp)
 514:	e8 bb fe ff ff       	call   3d4 <putc>
 519:	e9 30 01 00 00       	jmp    64e <printf+0x19a>
      }
    } else if(state == '%'){
 51e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 522:	0f 85 26 01 00 00    	jne    64e <printf+0x19a>
      if(c == 'd'){
 528:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 52c:	75 2d                	jne    55b <printf+0xa7>
        printint(fd, *ap, 10, 1);
 52e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 531:	8b 00                	mov    (%eax),%eax
 533:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 53a:	00 
 53b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 542:	00 
 543:	89 44 24 04          	mov    %eax,0x4(%esp)
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	89 04 24             	mov    %eax,(%esp)
 54d:	e8 aa fe ff ff       	call   3fc <printint>
        ap++;
 552:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 556:	e9 ec 00 00 00       	jmp    647 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 55b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 55f:	74 06                	je     567 <printf+0xb3>
 561:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 565:	75 2d                	jne    594 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 567:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56a:	8b 00                	mov    (%eax),%eax
 56c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 573:	00 
 574:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 57b:	00 
 57c:	89 44 24 04          	mov    %eax,0x4(%esp)
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	89 04 24             	mov    %eax,(%esp)
 586:	e8 71 fe ff ff       	call   3fc <printint>
        ap++;
 58b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58f:	e9 b3 00 00 00       	jmp    647 <printf+0x193>
      } else if(c == 's'){
 594:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 598:	75 45                	jne    5df <printf+0x12b>
        s = (char*)*ap;
 59a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59d:	8b 00                	mov    (%eax),%eax
 59f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5aa:	75 09                	jne    5b5 <printf+0x101>
          s = "(null)";
 5ac:	c7 45 f4 95 08 00 00 	movl   $0x895,-0xc(%ebp)
        while(*s != 0){
 5b3:	eb 1e                	jmp    5d3 <printf+0x11f>
 5b5:	eb 1c                	jmp    5d3 <printf+0x11f>
          putc(fd, *s);
 5b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ba:	0f b6 00             	movzbl (%eax),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	89 04 24             	mov    %eax,(%esp)
 5ca:	e8 05 fe ff ff       	call   3d4 <putc>
          s++;
 5cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d6:	0f b6 00             	movzbl (%eax),%eax
 5d9:	84 c0                	test   %al,%al
 5db:	75 da                	jne    5b7 <printf+0x103>
 5dd:	eb 68                	jmp    647 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5df:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e3:	75 1d                	jne    602 <printf+0x14e>
        putc(fd, *ap);
 5e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f1:	8b 45 08             	mov    0x8(%ebp),%eax
 5f4:	89 04 24             	mov    %eax,(%esp)
 5f7:	e8 d8 fd ff ff       	call   3d4 <putc>
        ap++;
 5fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 600:	eb 45                	jmp    647 <printf+0x193>
      } else if(c == '%'){
 602:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 606:	75 17                	jne    61f <printf+0x16b>
        putc(fd, c);
 608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	89 44 24 04          	mov    %eax,0x4(%esp)
 612:	8b 45 08             	mov    0x8(%ebp),%eax
 615:	89 04 24             	mov    %eax,(%esp)
 618:	e8 b7 fd ff ff       	call   3d4 <putc>
 61d:	eb 28                	jmp    647 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 626:	00 
 627:	8b 45 08             	mov    0x8(%ebp),%eax
 62a:	89 04 24             	mov    %eax,(%esp)
 62d:	e8 a2 fd ff ff       	call   3d4 <putc>
        putc(fd, c);
 632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	89 44 24 04          	mov    %eax,0x4(%esp)
 63c:	8b 45 08             	mov    0x8(%ebp),%eax
 63f:	89 04 24             	mov    %eax,(%esp)
 642:	e8 8d fd ff ff       	call   3d4 <putc>
      }
      state = 0;
 647:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 64e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 652:	8b 55 0c             	mov    0xc(%ebp),%edx
 655:	8b 45 f0             	mov    -0x10(%ebp),%eax
 658:	01 d0                	add    %edx,%eax
 65a:	0f b6 00             	movzbl (%eax),%eax
 65d:	84 c0                	test   %al,%al
 65f:	0f 85 71 fe ff ff    	jne    4d6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 665:	c9                   	leave  
 666:	c3                   	ret    

00000667 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	83 e8 08             	sub    $0x8,%eax
 673:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 676:	a1 fc 0a 00 00       	mov    0xafc,%eax
 67b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67e:	eb 24                	jmp    6a4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 00                	mov    (%eax),%eax
 685:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 688:	77 12                	ja     69c <free+0x35>
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 690:	77 24                	ja     6b6 <free+0x4f>
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69a:	77 1a                	ja     6b6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6aa:	76 d4                	jbe    680 <free+0x19>
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b4:	76 ca                	jbe    680 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	8b 40 04             	mov    0x4(%eax),%eax
 6bc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	01 c2                	add    %eax,%edx
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 00                	mov    (%eax),%eax
 6cd:	39 c2                	cmp    %eax,%edx
 6cf:	75 24                	jne    6f5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	8b 50 04             	mov    0x4(%eax),%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	8b 40 04             	mov    0x4(%eax),%eax
 6df:	01 c2                	add    %eax,%edx
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	8b 10                	mov    (%eax),%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	89 10                	mov    %edx,(%eax)
 6f3:	eb 0a                	jmp    6ff <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 10                	mov    (%eax),%edx
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 40 04             	mov    0x4(%eax),%eax
 705:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	01 d0                	add    %edx,%eax
 711:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 714:	75 20                	jne    736 <free+0xcf>
    p->s.size += bp->s.size;
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	8b 50 04             	mov    0x4(%eax),%edx
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	8b 40 04             	mov    0x4(%eax),%eax
 722:	01 c2                	add    %eax,%edx
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	8b 10                	mov    (%eax),%edx
 72f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 732:	89 10                	mov    %edx,(%eax)
 734:	eb 08                	jmp    73e <free+0xd7>
  } else
    p->s.ptr = bp;
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73c:	89 10                	mov    %edx,(%eax)
  freep = p;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	a3 fc 0a 00 00       	mov    %eax,0xafc
}
 746:	c9                   	leave  
 747:	c3                   	ret    

00000748 <morecore>:

static Header*
morecore(uint nu)
{
 748:	55                   	push   %ebp
 749:	89 e5                	mov    %esp,%ebp
 74b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 755:	77 07                	ja     75e <morecore+0x16>
    nu = 4096;
 757:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	c1 e0 03             	shl    $0x3,%eax
 764:	89 04 24             	mov    %eax,(%esp)
 767:	e8 28 fc ff ff       	call   394 <sbrk>
 76c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 76f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 773:	75 07                	jne    77c <morecore+0x34>
    return 0;
 775:	b8 00 00 00 00       	mov    $0x0,%eax
 77a:	eb 22                	jmp    79e <morecore+0x56>
  hp = (Header*)p;
 77c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 782:	8b 45 f0             	mov    -0x10(%ebp),%eax
 785:	8b 55 08             	mov    0x8(%ebp),%edx
 788:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78e:	83 c0 08             	add    $0x8,%eax
 791:	89 04 24             	mov    %eax,(%esp)
 794:	e8 ce fe ff ff       	call   667 <free>
  return freep;
 799:	a1 fc 0a 00 00       	mov    0xafc,%eax
}
 79e:	c9                   	leave  
 79f:	c3                   	ret    

000007a0 <malloc>:

void*
malloc(uint nbytes)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a6:	8b 45 08             	mov    0x8(%ebp),%eax
 7a9:	83 c0 07             	add    $0x7,%eax
 7ac:	c1 e8 03             	shr    $0x3,%eax
 7af:	83 c0 01             	add    $0x1,%eax
 7b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b5:	a1 fc 0a 00 00       	mov    0xafc,%eax
 7ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c1:	75 23                	jne    7e6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7c3:	c7 45 f0 f4 0a 00 00 	movl   $0xaf4,-0x10(%ebp)
 7ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cd:	a3 fc 0a 00 00       	mov    %eax,0xafc
 7d2:	a1 fc 0a 00 00       	mov    0xafc,%eax
 7d7:	a3 f4 0a 00 00       	mov    %eax,0xaf4
    base.s.size = 0;
 7dc:	c7 05 f8 0a 00 00 00 	movl   $0x0,0xaf8
 7e3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e9:	8b 00                	mov    (%eax),%eax
 7eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f7:	72 4d                	jb     846 <malloc+0xa6>
      if(p->s.size == nunits)
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	8b 40 04             	mov    0x4(%eax),%eax
 7ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 802:	75 0c                	jne    810 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 10                	mov    (%eax),%edx
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	89 10                	mov    %edx,(%eax)
 80e:	eb 26                	jmp    836 <malloc+0x96>
      else {
        p->s.size -= nunits;
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	2b 45 ec             	sub    -0x14(%ebp),%eax
 819:	89 c2                	mov    %eax,%edx
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	c1 e0 03             	shl    $0x3,%eax
 82a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 55 ec             	mov    -0x14(%ebp),%edx
 833:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 836:	8b 45 f0             	mov    -0x10(%ebp),%eax
 839:	a3 fc 0a 00 00       	mov    %eax,0xafc
      return (void*)(p + 1);
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	83 c0 08             	add    $0x8,%eax
 844:	eb 38                	jmp    87e <malloc+0xde>
    }
    if(p == freep)
 846:	a1 fc 0a 00 00       	mov    0xafc,%eax
 84b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 84e:	75 1b                	jne    86b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 850:	8b 45 ec             	mov    -0x14(%ebp),%eax
 853:	89 04 24             	mov    %eax,(%esp)
 856:	e8 ed fe ff ff       	call   748 <morecore>
 85b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 862:	75 07                	jne    86b <malloc+0xcb>
        return 0;
 864:	b8 00 00 00 00       	mov    $0x0,%eax
 869:	eb 13                	jmp    87e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	8b 00                	mov    (%eax),%eax
 876:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 879:	e9 70 ff ff ff       	jmp    7ee <malloc+0x4e>
}
 87e:	c9                   	leave  
 87f:	c3                   	ret    
