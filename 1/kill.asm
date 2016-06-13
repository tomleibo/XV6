
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 20                	jg     2f <main+0x2f>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 61 08 00 	movl   $0x861,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 72 04 00 00       	call   495 <printf>
    exit(0);
  23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2a:	e8 ae 02 00 00       	call   2dd <exit>
  }
  for(i=1; i<argc; i++)
  2f:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  36:	00 
  37:	eb 27                	jmp    60 <main+0x60>
    kill(atoi(argv[i]));
  39:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  44:	8b 45 0c             	mov    0xc(%ebp),%eax
  47:	01 d0                	add    %edx,%eax
  49:	8b 00                	mov    (%eax),%eax
  4b:	89 04 24             	mov    %eax,(%esp)
  4e:	e8 f8 01 00 00       	call   24b <atoi>
  53:	89 04 24             	mov    %eax,(%esp)
  56:	e8 c2 02 00 00       	call   31d <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit(0);
  }
  for(i=1; i<argc; i++)
  5b:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  60:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  64:	3b 45 08             	cmp    0x8(%ebp),%eax
  67:	7c d0                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit(0);
  69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  70:	e8 68 02 00 00       	call   2dd <exit>

00000075 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  75:	55                   	push   %ebp
  76:	89 e5                	mov    %esp,%ebp
  78:	57                   	push   %edi
  79:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7d:	8b 55 10             	mov    0x10(%ebp),%edx
  80:	8b 45 0c             	mov    0xc(%ebp),%eax
  83:	89 cb                	mov    %ecx,%ebx
  85:	89 df                	mov    %ebx,%edi
  87:	89 d1                	mov    %edx,%ecx
  89:	fc                   	cld    
  8a:	f3 aa                	rep stos %al,%es:(%edi)
  8c:	89 ca                	mov    %ecx,%edx
  8e:	89 fb                	mov    %edi,%ebx
  90:	89 5d 08             	mov    %ebx,0x8(%ebp)
  93:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	8d 50 01             	lea    0x1(%eax),%edx
  ad:	89 55 08             	mov    %edx,0x8(%ebp)
  b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 136:	8b 45 10             	mov    0x10(%ebp),%eax
 139:	89 44 24 08          	mov    %eax,0x8(%esp)
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	89 44 24 04          	mov    %eax,0x4(%esp)
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 26 ff ff ff       	call   75 <stosb>
  return dst;
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <strchr>:

char*
strchr(const char *s, char c)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 04             	sub    $0x4,%esp
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 160:	eb 14                	jmp    176 <strchr+0x22>
    if(*s == c)
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	0f b6 00             	movzbl (%eax),%eax
 168:	3a 45 fc             	cmp    -0x4(%ebp),%al
 16b:	75 05                	jne    172 <strchr+0x1e>
      return (char*)s;
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	eb 13                	jmp    185 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 172:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	84 c0                	test   %al,%al
 17e:	75 e2                	jne    162 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 180:	b8 00 00 00 00       	mov    $0x0,%eax
}
 185:	c9                   	leave  
 186:	c3                   	ret    

00000187 <gets>:

char*
gets(char *buf, int max)
{
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 194:	eb 4c                	jmp    1e2 <gets+0x5b>
    cc = read(0, &c, 1);
 196:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 19d:	00 
 19e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1ac:	e8 54 01 00 00       	call   305 <read>
 1b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b8:	7f 02                	jg     1bc <gets+0x35>
      break;
 1ba:	eb 31                	jmp    1ed <gets+0x66>
    buf[i++] = c;
 1bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1bf:	8d 50 01             	lea    0x1(%eax),%edx
 1c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c5:	89 c2                	mov    %eax,%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 c2                	add    %eax,%edx
 1cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d6:	3c 0a                	cmp    $0xa,%al
 1d8:	74 13                	je     1ed <gets+0x66>
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0d                	cmp    $0xd,%al
 1e0:	74 0b                	je     1ed <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e5:	83 c0 01             	add    $0x1,%eax
 1e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1eb:	7c a9                	jl     196 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	01 d0                	add    %edx,%eax
 1f5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    

000001fd <stat>:

int
stat(char *n, struct stat *st)
{
 1fd:	55                   	push   %ebp
 1fe:	89 e5                	mov    %esp,%ebp
 200:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 203:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20a:	00 
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	89 04 24             	mov    %eax,(%esp)
 211:	e8 17 01 00 00       	call   32d <open>
 216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 21d:	79 07                	jns    226 <stat+0x29>
    return -1;
 21f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 224:	eb 23                	jmp    249 <stat+0x4c>
  r = fstat(fd, st);
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	89 44 24 04          	mov    %eax,0x4(%esp)
 22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 230:	89 04 24             	mov    %eax,(%esp)
 233:	e8 0d 01 00 00       	call   345 <fstat>
 238:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 23b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23e:	89 04 24             	mov    %eax,(%esp)
 241:	e8 cf 00 00 00       	call   315 <close>
  return r;
 246:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 249:	c9                   	leave  
 24a:	c3                   	ret    

0000024b <atoi>:

int
atoi(const char *s)
{
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 251:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 258:	eb 25                	jmp    27f <atoi+0x34>
    n = n*10 + *s++ - '0';
 25a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25d:	89 d0                	mov    %edx,%eax
 25f:	c1 e0 02             	shl    $0x2,%eax
 262:	01 d0                	add    %edx,%eax
 264:	01 c0                	add    %eax,%eax
 266:	89 c1                	mov    %eax,%ecx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	8d 50 01             	lea    0x1(%eax),%edx
 26e:	89 55 08             	mov    %edx,0x8(%ebp)
 271:	0f b6 00             	movzbl (%eax),%eax
 274:	0f be c0             	movsbl %al,%eax
 277:	01 c8                	add    %ecx,%eax
 279:	83 e8 30             	sub    $0x30,%eax
 27c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	3c 2f                	cmp    $0x2f,%al
 287:	7e 0a                	jle    293 <atoi+0x48>
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 39                	cmp    $0x39,%al
 291:	7e c7                	jle    25a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 293:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2aa:	eb 17                	jmp    2c3 <memmove+0x2b>
    *dst++ = *src++;
 2ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2af:	8d 50 01             	lea    0x1(%eax),%edx
 2b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2b5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b8:	8d 4a 01             	lea    0x1(%edx),%ecx
 2bb:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2be:	0f b6 12             	movzbl (%edx),%edx
 2c1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c3:	8b 45 10             	mov    0x10(%ebp),%eax
 2c6:	8d 50 ff             	lea    -0x1(%eax),%edx
 2c9:	89 55 10             	mov    %edx,0x10(%ebp)
 2cc:	85 c0                	test   %eax,%eax
 2ce:	7f dc                	jg     2ac <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 2d5:	b8 01 00 00 00       	mov    $0x1,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <exit>:
SYSCALL(exit)
 2dd:	b8 02 00 00 00       	mov    $0x2,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <wait>:
SYSCALL(wait)
 2e5:	b8 03 00 00 00       	mov    $0x3,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <waitpid>:
SYSCALL(waitpid)
 2ed:	b8 16 00 00 00       	mov    $0x16,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <wait_stat>:
SYSCALL(wait_stat)
 2f5:	b8 17 00 00 00       	mov    $0x17,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <pipe>:
SYSCALL(pipe)
 2fd:	b8 04 00 00 00       	mov    $0x4,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <read>:
SYSCALL(read)
 305:	b8 05 00 00 00       	mov    $0x5,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <write>:
SYSCALL(write)
 30d:	b8 10 00 00 00       	mov    $0x10,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <close>:
SYSCALL(close)
 315:	b8 15 00 00 00       	mov    $0x15,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <kill>:
SYSCALL(kill)
 31d:	b8 06 00 00 00       	mov    $0x6,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <exec>:
SYSCALL(exec)
 325:	b8 07 00 00 00       	mov    $0x7,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <open>:
SYSCALL(open)
 32d:	b8 0f 00 00 00       	mov    $0xf,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <mknod>:
SYSCALL(mknod)
 335:	b8 11 00 00 00       	mov    $0x11,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <unlink>:
SYSCALL(unlink)
 33d:	b8 12 00 00 00       	mov    $0x12,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <fstat>:
SYSCALL(fstat)
 345:	b8 08 00 00 00       	mov    $0x8,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <link>:
SYSCALL(link)
 34d:	b8 13 00 00 00       	mov    $0x13,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <mkdir>:
SYSCALL(mkdir)
 355:	b8 14 00 00 00       	mov    $0x14,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <chdir>:
SYSCALL(chdir)
 35d:	b8 09 00 00 00       	mov    $0x9,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <dup>:
SYSCALL(dup)
 365:	b8 0a 00 00 00       	mov    $0xa,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <getpid>:
SYSCALL(getpid)
 36d:	b8 0b 00 00 00       	mov    $0xb,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <sbrk>:
SYSCALL(sbrk)
 375:	b8 0c 00 00 00       	mov    $0xc,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <set_priority>:
SYSCALL(set_priority)
 37d:	b8 18 00 00 00       	mov    $0x18,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <canRemoveJob>:
SYSCALL(canRemoveJob)
 385:	b8 19 00 00 00       	mov    $0x19,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <jobs>:
SYSCALL(jobs)
 38d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <sleep>:
SYSCALL(sleep)
 395:	b8 0d 00 00 00       	mov    $0xd,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <uptime>:
SYSCALL(uptime)
 39d:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <gidpid>:
SYSCALL(gidpid)
 3a5:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <isShell>:
SYSCALL(isShell)
 3ad:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 18             	sub    $0x18,%esp
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c8:	00 
 3c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	89 04 24             	mov    %eax,(%esp)
 3d6:	e8 32 ff ff ff       	call   30d <write>
}
 3db:	c9                   	leave  
 3dc:	c3                   	ret    

000003dd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
 3e0:	56                   	push   %esi
 3e1:	53                   	push   %ebx
 3e2:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ec:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f0:	74 17                	je     409 <printint+0x2c>
 3f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f6:	79 11                	jns    409 <printint+0x2c>
    neg = 1;
 3f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 402:	f7 d8                	neg    %eax
 404:	89 45 ec             	mov    %eax,-0x14(%ebp)
 407:	eb 06                	jmp    40f <printint+0x32>
  } else {
    x = xx;
 409:	8b 45 0c             	mov    0xc(%ebp),%eax
 40c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 40f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 416:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 419:	8d 41 01             	lea    0x1(%ecx),%eax
 41c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 41f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 422:	8b 45 ec             	mov    -0x14(%ebp),%eax
 425:	ba 00 00 00 00       	mov    $0x0,%edx
 42a:	f7 f3                	div    %ebx
 42c:	89 d0                	mov    %edx,%eax
 42e:	0f b6 80 c0 0a 00 00 	movzbl 0xac0(%eax),%eax
 435:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 439:	8b 75 10             	mov    0x10(%ebp),%esi
 43c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43f:	ba 00 00 00 00       	mov    $0x0,%edx
 444:	f7 f6                	div    %esi
 446:	89 45 ec             	mov    %eax,-0x14(%ebp)
 449:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 44d:	75 c7                	jne    416 <printint+0x39>
  if(neg)
 44f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 453:	74 10                	je     465 <printint+0x88>
    buf[i++] = '-';
 455:	8b 45 f4             	mov    -0xc(%ebp),%eax
 458:	8d 50 01             	lea    0x1(%eax),%edx
 45b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 463:	eb 1f                	jmp    484 <printint+0xa7>
 465:	eb 1d                	jmp    484 <printint+0xa7>
    putc(fd, buf[i]);
 467:	8d 55 dc             	lea    -0x24(%ebp),%edx
 46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46d:	01 d0                	add    %edx,%eax
 46f:	0f b6 00             	movzbl (%eax),%eax
 472:	0f be c0             	movsbl %al,%eax
 475:	89 44 24 04          	mov    %eax,0x4(%esp)
 479:	8b 45 08             	mov    0x8(%ebp),%eax
 47c:	89 04 24             	mov    %eax,(%esp)
 47f:	e8 31 ff ff ff       	call   3b5 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 484:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 488:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 48c:	79 d9                	jns    467 <printint+0x8a>
    putc(fd, buf[i]);
}
 48e:	83 c4 30             	add    $0x30,%esp
 491:	5b                   	pop    %ebx
 492:	5e                   	pop    %esi
 493:	5d                   	pop    %ebp
 494:	c3                   	ret    

00000495 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 495:	55                   	push   %ebp
 496:	89 e5                	mov    %esp,%ebp
 498:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 49b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a2:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a5:	83 c0 04             	add    $0x4,%eax
 4a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b2:	e9 7c 01 00 00       	jmp    633 <printf+0x19e>
    c = fmt[i] & 0xff;
 4b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4bd:	01 d0                	add    %edx,%eax
 4bf:	0f b6 00             	movzbl (%eax),%eax
 4c2:	0f be c0             	movsbl %al,%eax
 4c5:	25 ff 00 00 00       	and    $0xff,%eax
 4ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d1:	75 2c                	jne    4ff <printf+0x6a>
      if(c == '%'){
 4d3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d7:	75 0c                	jne    4e5 <printf+0x50>
        state = '%';
 4d9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e0:	e9 4a 01 00 00       	jmp    62f <printf+0x19a>
      } else {
        putc(fd, c);
 4e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e8:	0f be c0             	movsbl %al,%eax
 4eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ef:	8b 45 08             	mov    0x8(%ebp),%eax
 4f2:	89 04 24             	mov    %eax,(%esp)
 4f5:	e8 bb fe ff ff       	call   3b5 <putc>
 4fa:	e9 30 01 00 00       	jmp    62f <printf+0x19a>
      }
    } else if(state == '%'){
 4ff:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 503:	0f 85 26 01 00 00    	jne    62f <printf+0x19a>
      if(c == 'd'){
 509:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 50d:	75 2d                	jne    53c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 50f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 512:	8b 00                	mov    (%eax),%eax
 514:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 51b:	00 
 51c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 523:	00 
 524:	89 44 24 04          	mov    %eax,0x4(%esp)
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	89 04 24             	mov    %eax,(%esp)
 52e:	e8 aa fe ff ff       	call   3dd <printint>
        ap++;
 533:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 537:	e9 ec 00 00 00       	jmp    628 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 53c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 540:	74 06                	je     548 <printf+0xb3>
 542:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 546:	75 2d                	jne    575 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 548:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54b:	8b 00                	mov    (%eax),%eax
 54d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 554:	00 
 555:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 55c:	00 
 55d:	89 44 24 04          	mov    %eax,0x4(%esp)
 561:	8b 45 08             	mov    0x8(%ebp),%eax
 564:	89 04 24             	mov    %eax,(%esp)
 567:	e8 71 fe ff ff       	call   3dd <printint>
        ap++;
 56c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 570:	e9 b3 00 00 00       	jmp    628 <printf+0x193>
      } else if(c == 's'){
 575:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 579:	75 45                	jne    5c0 <printf+0x12b>
        s = (char*)*ap;
 57b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57e:	8b 00                	mov    (%eax),%eax
 580:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 583:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58b:	75 09                	jne    596 <printf+0x101>
          s = "(null)";
 58d:	c7 45 f4 75 08 00 00 	movl   $0x875,-0xc(%ebp)
        while(*s != 0){
 594:	eb 1e                	jmp    5b4 <printf+0x11f>
 596:	eb 1c                	jmp    5b4 <printf+0x11f>
          putc(fd, *s);
 598:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59b:	0f b6 00             	movzbl (%eax),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	89 04 24             	mov    %eax,(%esp)
 5ab:	e8 05 fe ff ff       	call   3b5 <putc>
          s++;
 5b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b7:	0f b6 00             	movzbl (%eax),%eax
 5ba:	84 c0                	test   %al,%al
 5bc:	75 da                	jne    598 <printf+0x103>
 5be:	eb 68                	jmp    628 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c4:	75 1d                	jne    5e3 <printf+0x14e>
        putc(fd, *ap);
 5c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c9:	8b 00                	mov    (%eax),%eax
 5cb:	0f be c0             	movsbl %al,%eax
 5ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	89 04 24             	mov    %eax,(%esp)
 5d8:	e8 d8 fd ff ff       	call   3b5 <putc>
        ap++;
 5dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e1:	eb 45                	jmp    628 <printf+0x193>
      } else if(c == '%'){
 5e3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e7:	75 17                	jne    600 <printf+0x16b>
        putc(fd, c);
 5e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ec:	0f be c0             	movsbl %al,%eax
 5ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	89 04 24             	mov    %eax,(%esp)
 5f9:	e8 b7 fd ff ff       	call   3b5 <putc>
 5fe:	eb 28                	jmp    628 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 600:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 607:	00 
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	89 04 24             	mov    %eax,(%esp)
 60e:	e8 a2 fd ff ff       	call   3b5 <putc>
        putc(fd, c);
 613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 616:	0f be c0             	movsbl %al,%eax
 619:	89 44 24 04          	mov    %eax,0x4(%esp)
 61d:	8b 45 08             	mov    0x8(%ebp),%eax
 620:	89 04 24             	mov    %eax,(%esp)
 623:	e8 8d fd ff ff       	call   3b5 <putc>
      }
      state = 0;
 628:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 62f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 633:	8b 55 0c             	mov    0xc(%ebp),%edx
 636:	8b 45 f0             	mov    -0x10(%ebp),%eax
 639:	01 d0                	add    %edx,%eax
 63b:	0f b6 00             	movzbl (%eax),%eax
 63e:	84 c0                	test   %al,%al
 640:	0f 85 71 fe ff ff    	jne    4b7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 646:	c9                   	leave  
 647:	c3                   	ret    

00000648 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 648:	55                   	push   %ebp
 649:	89 e5                	mov    %esp,%ebp
 64b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 64e:	8b 45 08             	mov    0x8(%ebp),%eax
 651:	83 e8 08             	sub    $0x8,%eax
 654:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 657:	a1 dc 0a 00 00       	mov    0xadc,%eax
 65c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65f:	eb 24                	jmp    685 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 669:	77 12                	ja     67d <free+0x35>
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 671:	77 24                	ja     697 <free+0x4f>
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	8b 00                	mov    (%eax),%eax
 678:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67b:	77 1a                	ja     697 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	89 45 fc             	mov    %eax,-0x4(%ebp)
 685:	8b 45 f8             	mov    -0x8(%ebp),%eax
 688:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68b:	76 d4                	jbe    661 <free+0x19>
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 695:	76 ca                	jbe    661 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	8b 40 04             	mov    0x4(%eax),%eax
 69d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	01 c2                	add    %eax,%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	39 c2                	cmp    %eax,%edx
 6b0:	75 24                	jne    6d6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	8b 50 04             	mov    0x4(%eax),%edx
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	8b 40 04             	mov    0x4(%eax),%eax
 6c0:	01 c2                	add    %eax,%edx
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 00                	mov    (%eax),%eax
 6cd:	8b 10                	mov    (%eax),%edx
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	89 10                	mov    %edx,(%eax)
 6d4:	eb 0a                	jmp    6e0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 10                	mov    (%eax),%edx
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 40 04             	mov    0x4(%eax),%eax
 6e6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	01 d0                	add    %edx,%eax
 6f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f5:	75 20                	jne    717 <free+0xcf>
    p->s.size += bp->s.size;
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 50 04             	mov    0x4(%eax),%edx
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	8b 40 04             	mov    0x4(%eax),%eax
 703:	01 c2                	add    %eax,%edx
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 70b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70e:	8b 10                	mov    (%eax),%edx
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	89 10                	mov    %edx,(%eax)
 715:	eb 08                	jmp    71f <free+0xd7>
  } else
    p->s.ptr = bp;
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 71d:	89 10                	mov    %edx,(%eax)
  freep = p;
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	a3 dc 0a 00 00       	mov    %eax,0xadc
}
 727:	c9                   	leave  
 728:	c3                   	ret    

00000729 <morecore>:

static Header*
morecore(uint nu)
{
 729:	55                   	push   %ebp
 72a:	89 e5                	mov    %esp,%ebp
 72c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 72f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 736:	77 07                	ja     73f <morecore+0x16>
    nu = 4096;
 738:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 73f:	8b 45 08             	mov    0x8(%ebp),%eax
 742:	c1 e0 03             	shl    $0x3,%eax
 745:	89 04 24             	mov    %eax,(%esp)
 748:	e8 28 fc ff ff       	call   375 <sbrk>
 74d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 750:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 754:	75 07                	jne    75d <morecore+0x34>
    return 0;
 756:	b8 00 00 00 00       	mov    $0x0,%eax
 75b:	eb 22                	jmp    77f <morecore+0x56>
  hp = (Header*)p;
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 763:	8b 45 f0             	mov    -0x10(%ebp),%eax
 766:	8b 55 08             	mov    0x8(%ebp),%edx
 769:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 76c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76f:	83 c0 08             	add    $0x8,%eax
 772:	89 04 24             	mov    %eax,(%esp)
 775:	e8 ce fe ff ff       	call   648 <free>
  return freep;
 77a:	a1 dc 0a 00 00       	mov    0xadc,%eax
}
 77f:	c9                   	leave  
 780:	c3                   	ret    

00000781 <malloc>:

void*
malloc(uint nbytes)
{
 781:	55                   	push   %ebp
 782:	89 e5                	mov    %esp,%ebp
 784:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 787:	8b 45 08             	mov    0x8(%ebp),%eax
 78a:	83 c0 07             	add    $0x7,%eax
 78d:	c1 e8 03             	shr    $0x3,%eax
 790:	83 c0 01             	add    $0x1,%eax
 793:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 796:	a1 dc 0a 00 00       	mov    0xadc,%eax
 79b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 79e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a2:	75 23                	jne    7c7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7a4:	c7 45 f0 d4 0a 00 00 	movl   $0xad4,-0x10(%ebp)
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	a3 dc 0a 00 00       	mov    %eax,0xadc
 7b3:	a1 dc 0a 00 00       	mov    0xadc,%eax
 7b8:	a3 d4 0a 00 00       	mov    %eax,0xad4
    base.s.size = 0;
 7bd:	c7 05 d8 0a 00 00 00 	movl   $0x0,0xad8
 7c4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d8:	72 4d                	jb     827 <malloc+0xa6>
      if(p->s.size == nunits)
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8b 40 04             	mov    0x4(%eax),%eax
 7e0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e3:	75 0c                	jne    7f1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 10                	mov    (%eax),%edx
 7ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ed:	89 10                	mov    %edx,(%eax)
 7ef:	eb 26                	jmp    817 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	8b 40 04             	mov    0x4(%eax),%eax
 7f7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7fa:	89 c2                	mov    %eax,%edx
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 40 04             	mov    0x4(%eax),%eax
 808:	c1 e0 03             	shl    $0x3,%eax
 80b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	8b 55 ec             	mov    -0x14(%ebp),%edx
 814:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 817:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81a:	a3 dc 0a 00 00       	mov    %eax,0xadc
      return (void*)(p + 1);
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	83 c0 08             	add    $0x8,%eax
 825:	eb 38                	jmp    85f <malloc+0xde>
    }
    if(p == freep)
 827:	a1 dc 0a 00 00       	mov    0xadc,%eax
 82c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 82f:	75 1b                	jne    84c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 831:	8b 45 ec             	mov    -0x14(%ebp),%eax
 834:	89 04 24             	mov    %eax,(%esp)
 837:	e8 ed fe ff ff       	call   729 <morecore>
 83c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 83f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 843:	75 07                	jne    84c <malloc+0xcb>
        return 0;
 845:	b8 00 00 00 00       	mov    $0x0,%eax
 84a:	eb 13                	jmp    85f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 00                	mov    (%eax),%eax
 857:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 85a:	e9 70 ff ff ff       	jmp    7cf <malloc+0x4e>
}
 85f:	c9                   	leave  
 860:	c3                   	ret    
