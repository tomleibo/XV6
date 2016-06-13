
_echo:     file format elf32-i386


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
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 5f 08 00 00       	mov    $0x85f,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 61 08 00 00       	mov    $0x861,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 63 08 00 	movl   $0x863,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 3a 04 00 00       	call   493 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit(0);
  67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  6e:	e8 68 02 00 00       	call   2db <exit>

00000073 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  73:	55                   	push   %ebp
  74:	89 e5                	mov    %esp,%ebp
  76:	57                   	push   %edi
  77:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7b:	8b 55 10             	mov    0x10(%ebp),%edx
  7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  81:	89 cb                	mov    %ecx,%ebx
  83:	89 df                	mov    %ebx,%edi
  85:	89 d1                	mov    %edx,%ecx
  87:	fc                   	cld    
  88:	f3 aa                	rep stos %al,%es:(%edi)
  8a:	89 ca                	mov    %ecx,%edx
  8c:	89 fb                	mov    %edi,%ebx
  8e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  91:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	8d 50 01             	lea    0x1(%eax),%edx
  ab:	89 55 08             	mov    %edx,0x8(%ebp)
  ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
 131:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 134:	8b 45 10             	mov    0x10(%ebp),%eax
 137:	89 44 24 08          	mov    %eax,0x8(%esp)
 13b:	8b 45 0c             	mov    0xc(%ebp),%eax
 13e:	89 44 24 04          	mov    %eax,0x4(%esp)
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	89 04 24             	mov    %eax,(%esp)
 148:	e8 26 ff ff ff       	call   73 <stosb>
  return dst;
 14d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 150:	c9                   	leave  
 151:	c3                   	ret    

00000152 <strchr>:

char*
strchr(const char *s, char c)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	83 ec 04             	sub    $0x4,%esp
 158:	8b 45 0c             	mov    0xc(%ebp),%eax
 15b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15e:	eb 14                	jmp    174 <strchr+0x22>
    if(*s == c)
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	0f b6 00             	movzbl (%eax),%eax
 166:	3a 45 fc             	cmp    -0x4(%ebp),%al
 169:	75 05                	jne    170 <strchr+0x1e>
      return (char*)s;
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	eb 13                	jmp    183 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 170:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	84 c0                	test   %al,%al
 17c:	75 e2                	jne    160 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 17e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 183:	c9                   	leave  
 184:	c3                   	ret    

00000185 <gets>:

char*
gets(char *buf, int max)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 192:	eb 4c                	jmp    1e0 <gets+0x5b>
    cc = read(0, &c, 1);
 194:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 19b:	00 
 19c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 19f:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1aa:	e8 54 01 00 00       	call   303 <read>
 1af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b6:	7f 02                	jg     1ba <gets+0x35>
      break;
 1b8:	eb 31                	jmp    1eb <gets+0x66>
    buf[i++] = c;
 1ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1bd:	8d 50 01             	lea    0x1(%eax),%edx
 1c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c3:	89 c2                	mov    %eax,%edx
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
 1c8:	01 c2                	add    %eax,%edx
 1ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ce:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d4:	3c 0a                	cmp    $0xa,%al
 1d6:	74 13                	je     1eb <gets+0x66>
 1d8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1dc:	3c 0d                	cmp    $0xd,%al
 1de:	74 0b                	je     1eb <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e3:	83 c0 01             	add    $0x1,%eax
 1e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e9:	7c a9                	jl     194 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	01 d0                	add    %edx,%eax
 1f3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <stat>:

int
stat(char *n, struct stat *st)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 201:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 208:	00 
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	89 04 24             	mov    %eax,(%esp)
 20f:	e8 17 01 00 00       	call   32b <open>
 214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 217:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 21b:	79 07                	jns    224 <stat+0x29>
    return -1;
 21d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 222:	eb 23                	jmp    247 <stat+0x4c>
  r = fstat(fd, st);
 224:	8b 45 0c             	mov    0xc(%ebp),%eax
 227:	89 44 24 04          	mov    %eax,0x4(%esp)
 22b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22e:	89 04 24             	mov    %eax,(%esp)
 231:	e8 0d 01 00 00       	call   343 <fstat>
 236:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 239:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23c:	89 04 24             	mov    %eax,(%esp)
 23f:	e8 cf 00 00 00       	call   313 <close>
  return r;
 244:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 247:	c9                   	leave  
 248:	c3                   	ret    

00000249 <atoi>:

int
atoi(const char *s)
{
 249:	55                   	push   %ebp
 24a:	89 e5                	mov    %esp,%ebp
 24c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 24f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 256:	eb 25                	jmp    27d <atoi+0x34>
    n = n*10 + *s++ - '0';
 258:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25b:	89 d0                	mov    %edx,%eax
 25d:	c1 e0 02             	shl    $0x2,%eax
 260:	01 d0                	add    %edx,%eax
 262:	01 c0                	add    %eax,%eax
 264:	89 c1                	mov    %eax,%ecx
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	8d 50 01             	lea    0x1(%eax),%edx
 26c:	89 55 08             	mov    %edx,0x8(%ebp)
 26f:	0f b6 00             	movzbl (%eax),%eax
 272:	0f be c0             	movsbl %al,%eax
 275:	01 c8                	add    %ecx,%eax
 277:	83 e8 30             	sub    $0x30,%eax
 27a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	0f b6 00             	movzbl (%eax),%eax
 283:	3c 2f                	cmp    $0x2f,%al
 285:	7e 0a                	jle    291 <atoi+0x48>
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	0f b6 00             	movzbl (%eax),%eax
 28d:	3c 39                	cmp    $0x39,%al
 28f:	7e c7                	jle    258 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 291:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 294:	c9                   	leave  
 295:	c3                   	ret    

00000296 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 296:	55                   	push   %ebp
 297:	89 e5                	mov    %esp,%ebp
 299:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a8:	eb 17                	jmp    2c1 <memmove+0x2b>
    *dst++ = *src++;
 2aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ad:	8d 50 01             	lea    0x1(%eax),%edx
 2b0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2b3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b6:	8d 4a 01             	lea    0x1(%edx),%ecx
 2b9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2bc:	0f b6 12             	movzbl (%edx),%edx
 2bf:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c1:	8b 45 10             	mov    0x10(%ebp),%eax
 2c4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2c7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ca:	85 c0                	test   %eax,%eax
 2cc:	7f dc                	jg     2aa <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d1:	c9                   	leave  
 2d2:	c3                   	ret    

000002d3 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 2d3:	b8 01 00 00 00       	mov    $0x1,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <exit>:
SYSCALL(exit)
 2db:	b8 02 00 00 00       	mov    $0x2,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <wait>:
SYSCALL(wait)
 2e3:	b8 03 00 00 00       	mov    $0x3,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <waitpid>:
SYSCALL(waitpid)
 2eb:	b8 16 00 00 00       	mov    $0x16,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <wait_stat>:
SYSCALL(wait_stat)
 2f3:	b8 17 00 00 00       	mov    $0x17,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <pipe>:
SYSCALL(pipe)
 2fb:	b8 04 00 00 00       	mov    $0x4,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <read>:
SYSCALL(read)
 303:	b8 05 00 00 00       	mov    $0x5,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <write>:
SYSCALL(write)
 30b:	b8 10 00 00 00       	mov    $0x10,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <close>:
SYSCALL(close)
 313:	b8 15 00 00 00       	mov    $0x15,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <kill>:
SYSCALL(kill)
 31b:	b8 06 00 00 00       	mov    $0x6,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <exec>:
SYSCALL(exec)
 323:	b8 07 00 00 00       	mov    $0x7,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <open>:
SYSCALL(open)
 32b:	b8 0f 00 00 00       	mov    $0xf,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <mknod>:
SYSCALL(mknod)
 333:	b8 11 00 00 00       	mov    $0x11,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <unlink>:
SYSCALL(unlink)
 33b:	b8 12 00 00 00       	mov    $0x12,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <fstat>:
SYSCALL(fstat)
 343:	b8 08 00 00 00       	mov    $0x8,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <link>:
SYSCALL(link)
 34b:	b8 13 00 00 00       	mov    $0x13,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <mkdir>:
SYSCALL(mkdir)
 353:	b8 14 00 00 00       	mov    $0x14,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <chdir>:
SYSCALL(chdir)
 35b:	b8 09 00 00 00       	mov    $0x9,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <dup>:
SYSCALL(dup)
 363:	b8 0a 00 00 00       	mov    $0xa,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <getpid>:
SYSCALL(getpid)
 36b:	b8 0b 00 00 00       	mov    $0xb,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <sbrk>:
SYSCALL(sbrk)
 373:	b8 0c 00 00 00       	mov    $0xc,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <set_priority>:
SYSCALL(set_priority)
 37b:	b8 18 00 00 00       	mov    $0x18,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <canRemoveJob>:
SYSCALL(canRemoveJob)
 383:	b8 19 00 00 00       	mov    $0x19,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <jobs>:
SYSCALL(jobs)
 38b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <sleep>:
SYSCALL(sleep)
 393:	b8 0d 00 00 00       	mov    $0xd,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <uptime>:
SYSCALL(uptime)
 39b:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <gidpid>:
SYSCALL(gidpid)
 3a3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <isShell>:
SYSCALL(isShell)
 3ab:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b3:	55                   	push   %ebp
 3b4:	89 e5                	mov    %esp,%ebp
 3b6:	83 ec 18             	sub    $0x18,%esp
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3bf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c6:	00 
 3c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ce:	8b 45 08             	mov    0x8(%ebp),%eax
 3d1:	89 04 24             	mov    %eax,(%esp)
 3d4:	e8 32 ff ff ff       	call   30b <write>
}
 3d9:	c9                   	leave  
 3da:	c3                   	ret    

000003db <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	56                   	push   %esi
 3df:	53                   	push   %ebx
 3e0:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ea:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ee:	74 17                	je     407 <printint+0x2c>
 3f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f4:	79 11                	jns    407 <printint+0x2c>
    neg = 1;
 3f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 400:	f7 d8                	neg    %eax
 402:	89 45 ec             	mov    %eax,-0x14(%ebp)
 405:	eb 06                	jmp    40d <printint+0x32>
  } else {
    x = xx;
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 40d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 414:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 417:	8d 41 01             	lea    0x1(%ecx),%eax
 41a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 41d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 420:	8b 45 ec             	mov    -0x14(%ebp),%eax
 423:	ba 00 00 00 00       	mov    $0x0,%edx
 428:	f7 f3                	div    %ebx
 42a:	89 d0                	mov    %edx,%eax
 42c:	0f b6 80 b4 0a 00 00 	movzbl 0xab4(%eax),%eax
 433:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 437:	8b 75 10             	mov    0x10(%ebp),%esi
 43a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43d:	ba 00 00 00 00       	mov    $0x0,%edx
 442:	f7 f6                	div    %esi
 444:	89 45 ec             	mov    %eax,-0x14(%ebp)
 447:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 44b:	75 c7                	jne    414 <printint+0x39>
  if(neg)
 44d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 451:	74 10                	je     463 <printint+0x88>
    buf[i++] = '-';
 453:	8b 45 f4             	mov    -0xc(%ebp),%eax
 456:	8d 50 01             	lea    0x1(%eax),%edx
 459:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 461:	eb 1f                	jmp    482 <printint+0xa7>
 463:	eb 1d                	jmp    482 <printint+0xa7>
    putc(fd, buf[i]);
 465:	8d 55 dc             	lea    -0x24(%ebp),%edx
 468:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46b:	01 d0                	add    %edx,%eax
 46d:	0f b6 00             	movzbl (%eax),%eax
 470:	0f be c0             	movsbl %al,%eax
 473:	89 44 24 04          	mov    %eax,0x4(%esp)
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	89 04 24             	mov    %eax,(%esp)
 47d:	e8 31 ff ff ff       	call   3b3 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 482:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 48a:	79 d9                	jns    465 <printint+0x8a>
    putc(fd, buf[i]);
}
 48c:	83 c4 30             	add    $0x30,%esp
 48f:	5b                   	pop    %ebx
 490:	5e                   	pop    %esi
 491:	5d                   	pop    %ebp
 492:	c3                   	ret    

00000493 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 493:	55                   	push   %ebp
 494:	89 e5                	mov    %esp,%ebp
 496:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 499:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a0:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a3:	83 c0 04             	add    $0x4,%eax
 4a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b0:	e9 7c 01 00 00       	jmp    631 <printf+0x19e>
    c = fmt[i] & 0xff;
 4b5:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4bb:	01 d0                	add    %edx,%eax
 4bd:	0f b6 00             	movzbl (%eax),%eax
 4c0:	0f be c0             	movsbl %al,%eax
 4c3:	25 ff 00 00 00       	and    $0xff,%eax
 4c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4cf:	75 2c                	jne    4fd <printf+0x6a>
      if(c == '%'){
 4d1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d5:	75 0c                	jne    4e3 <printf+0x50>
        state = '%';
 4d7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4de:	e9 4a 01 00 00       	jmp    62d <printf+0x19a>
      } else {
        putc(fd, c);
 4e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e6:	0f be c0             	movsbl %al,%eax
 4e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
 4f0:	89 04 24             	mov    %eax,(%esp)
 4f3:	e8 bb fe ff ff       	call   3b3 <putc>
 4f8:	e9 30 01 00 00       	jmp    62d <printf+0x19a>
      }
    } else if(state == '%'){
 4fd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 501:	0f 85 26 01 00 00    	jne    62d <printf+0x19a>
      if(c == 'd'){
 507:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 50b:	75 2d                	jne    53a <printf+0xa7>
        printint(fd, *ap, 10, 1);
 50d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 510:	8b 00                	mov    (%eax),%eax
 512:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 519:	00 
 51a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 521:	00 
 522:	89 44 24 04          	mov    %eax,0x4(%esp)
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	89 04 24             	mov    %eax,(%esp)
 52c:	e8 aa fe ff ff       	call   3db <printint>
        ap++;
 531:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 535:	e9 ec 00 00 00       	jmp    626 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 53a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 53e:	74 06                	je     546 <printf+0xb3>
 540:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 544:	75 2d                	jne    573 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 546:	8b 45 e8             	mov    -0x18(%ebp),%eax
 549:	8b 00                	mov    (%eax),%eax
 54b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 552:	00 
 553:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 55a:	00 
 55b:	89 44 24 04          	mov    %eax,0x4(%esp)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 71 fe ff ff       	call   3db <printint>
        ap++;
 56a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56e:	e9 b3 00 00 00       	jmp    626 <printf+0x193>
      } else if(c == 's'){
 573:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 577:	75 45                	jne    5be <printf+0x12b>
        s = (char*)*ap;
 579:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57c:	8b 00                	mov    (%eax),%eax
 57e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 581:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 585:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 589:	75 09                	jne    594 <printf+0x101>
          s = "(null)";
 58b:	c7 45 f4 68 08 00 00 	movl   $0x868,-0xc(%ebp)
        while(*s != 0){
 592:	eb 1e                	jmp    5b2 <printf+0x11f>
 594:	eb 1c                	jmp    5b2 <printf+0x11f>
          putc(fd, *s);
 596:	8b 45 f4             	mov    -0xc(%ebp),%eax
 599:	0f b6 00             	movzbl (%eax),%eax
 59c:	0f be c0             	movsbl %al,%eax
 59f:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a3:	8b 45 08             	mov    0x8(%ebp),%eax
 5a6:	89 04 24             	mov    %eax,(%esp)
 5a9:	e8 05 fe ff ff       	call   3b3 <putc>
          s++;
 5ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b5:	0f b6 00             	movzbl (%eax),%eax
 5b8:	84 c0                	test   %al,%al
 5ba:	75 da                	jne    596 <printf+0x103>
 5bc:	eb 68                	jmp    626 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5be:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c2:	75 1d                	jne    5e1 <printf+0x14e>
        putc(fd, *ap);
 5c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c7:	8b 00                	mov    (%eax),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	89 04 24             	mov    %eax,(%esp)
 5d6:	e8 d8 fd ff ff       	call   3b3 <putc>
        ap++;
 5db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5df:	eb 45                	jmp    626 <printf+0x193>
      } else if(c == '%'){
 5e1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e5:	75 17                	jne    5fe <printf+0x16b>
        putc(fd, c);
 5e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f1:	8b 45 08             	mov    0x8(%ebp),%eax
 5f4:	89 04 24             	mov    %eax,(%esp)
 5f7:	e8 b7 fd ff ff       	call   3b3 <putc>
 5fc:	eb 28                	jmp    626 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fe:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 605:	00 
 606:	8b 45 08             	mov    0x8(%ebp),%eax
 609:	89 04 24             	mov    %eax,(%esp)
 60c:	e8 a2 fd ff ff       	call   3b3 <putc>
        putc(fd, c);
 611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 614:	0f be c0             	movsbl %al,%eax
 617:	89 44 24 04          	mov    %eax,0x4(%esp)
 61b:	8b 45 08             	mov    0x8(%ebp),%eax
 61e:	89 04 24             	mov    %eax,(%esp)
 621:	e8 8d fd ff ff       	call   3b3 <putc>
      }
      state = 0;
 626:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 62d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 631:	8b 55 0c             	mov    0xc(%ebp),%edx
 634:	8b 45 f0             	mov    -0x10(%ebp),%eax
 637:	01 d0                	add    %edx,%eax
 639:	0f b6 00             	movzbl (%eax),%eax
 63c:	84 c0                	test   %al,%al
 63e:	0f 85 71 fe ff ff    	jne    4b5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 644:	c9                   	leave  
 645:	c3                   	ret    

00000646 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 646:	55                   	push   %ebp
 647:	89 e5                	mov    %esp,%ebp
 649:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 64c:	8b 45 08             	mov    0x8(%ebp),%eax
 64f:	83 e8 08             	sub    $0x8,%eax
 652:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 655:	a1 d0 0a 00 00       	mov    0xad0,%eax
 65a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65d:	eb 24                	jmp    683 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 667:	77 12                	ja     67b <free+0x35>
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66f:	77 24                	ja     695 <free+0x4f>
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 00                	mov    (%eax),%eax
 676:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 679:	77 1a                	ja     695 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	89 45 fc             	mov    %eax,-0x4(%ebp)
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 689:	76 d4                	jbe    65f <free+0x19>
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	8b 00                	mov    (%eax),%eax
 690:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 693:	76 ca                	jbe    65f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	8b 40 04             	mov    0x4(%eax),%eax
 69b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	01 c2                	add    %eax,%edx
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	39 c2                	cmp    %eax,%edx
 6ae:	75 24                	jne    6d4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	8b 50 04             	mov    0x4(%eax),%edx
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 00                	mov    (%eax),%eax
 6bb:	8b 40 04             	mov    0x4(%eax),%eax
 6be:	01 c2                	add    %eax,%edx
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 00                	mov    (%eax),%eax
 6cb:	8b 10                	mov    (%eax),%edx
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	89 10                	mov    %edx,(%eax)
 6d2:	eb 0a                	jmp    6de <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 10                	mov    (%eax),%edx
 6d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 40 04             	mov    0x4(%eax),%eax
 6e4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	01 d0                	add    %edx,%eax
 6f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f3:	75 20                	jne    715 <free+0xcf>
    p->s.size += bp->s.size;
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 50 04             	mov    0x4(%eax),%edx
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	8b 40 04             	mov    0x4(%eax),%eax
 701:	01 c2                	add    %eax,%edx
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	8b 10                	mov    (%eax),%edx
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	89 10                	mov    %edx,(%eax)
 713:	eb 08                	jmp    71d <free+0xd7>
  } else
    p->s.ptr = bp;
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 55 f8             	mov    -0x8(%ebp),%edx
 71b:	89 10                	mov    %edx,(%eax)
  freep = p;
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	a3 d0 0a 00 00       	mov    %eax,0xad0
}
 725:	c9                   	leave  
 726:	c3                   	ret    

00000727 <morecore>:

static Header*
morecore(uint nu)
{
 727:	55                   	push   %ebp
 728:	89 e5                	mov    %esp,%ebp
 72a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 72d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 734:	77 07                	ja     73d <morecore+0x16>
    nu = 4096;
 736:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 73d:	8b 45 08             	mov    0x8(%ebp),%eax
 740:	c1 e0 03             	shl    $0x3,%eax
 743:	89 04 24             	mov    %eax,(%esp)
 746:	e8 28 fc ff ff       	call   373 <sbrk>
 74b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 74e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 752:	75 07                	jne    75b <morecore+0x34>
    return 0;
 754:	b8 00 00 00 00       	mov    $0x0,%eax
 759:	eb 22                	jmp    77d <morecore+0x56>
  hp = (Header*)p;
 75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 761:	8b 45 f0             	mov    -0x10(%ebp),%eax
 764:	8b 55 08             	mov    0x8(%ebp),%edx
 767:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76d:	83 c0 08             	add    $0x8,%eax
 770:	89 04 24             	mov    %eax,(%esp)
 773:	e8 ce fe ff ff       	call   646 <free>
  return freep;
 778:	a1 d0 0a 00 00       	mov    0xad0,%eax
}
 77d:	c9                   	leave  
 77e:	c3                   	ret    

0000077f <malloc>:

void*
malloc(uint nbytes)
{
 77f:	55                   	push   %ebp
 780:	89 e5                	mov    %esp,%ebp
 782:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 785:	8b 45 08             	mov    0x8(%ebp),%eax
 788:	83 c0 07             	add    $0x7,%eax
 78b:	c1 e8 03             	shr    $0x3,%eax
 78e:	83 c0 01             	add    $0x1,%eax
 791:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 794:	a1 d0 0a 00 00       	mov    0xad0,%eax
 799:	89 45 f0             	mov    %eax,-0x10(%ebp)
 79c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a0:	75 23                	jne    7c5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7a2:	c7 45 f0 c8 0a 00 00 	movl   $0xac8,-0x10(%ebp)
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	a3 d0 0a 00 00       	mov    %eax,0xad0
 7b1:	a1 d0 0a 00 00       	mov    0xad0,%eax
 7b6:	a3 c8 0a 00 00       	mov    %eax,0xac8
    base.s.size = 0;
 7bb:	c7 05 cc 0a 00 00 00 	movl   $0x0,0xacc
 7c2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	8b 00                	mov    (%eax),%eax
 7ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	8b 40 04             	mov    0x4(%eax),%eax
 7d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d6:	72 4d                	jb     825 <malloc+0xa6>
      if(p->s.size == nunits)
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	8b 40 04             	mov    0x4(%eax),%eax
 7de:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e1:	75 0c                	jne    7ef <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	8b 10                	mov    (%eax),%edx
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	89 10                	mov    %edx,(%eax)
 7ed:	eb 26                	jmp    815 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	8b 40 04             	mov    0x4(%eax),%eax
 7f5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7f8:	89 c2                	mov    %eax,%edx
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	c1 e0 03             	shl    $0x3,%eax
 809:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 812:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 815:	8b 45 f0             	mov    -0x10(%ebp),%eax
 818:	a3 d0 0a 00 00       	mov    %eax,0xad0
      return (void*)(p + 1);
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	83 c0 08             	add    $0x8,%eax
 823:	eb 38                	jmp    85d <malloc+0xde>
    }
    if(p == freep)
 825:	a1 d0 0a 00 00       	mov    0xad0,%eax
 82a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 82d:	75 1b                	jne    84a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 82f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 832:	89 04 24             	mov    %eax,(%esp)
 835:	e8 ed fe ff ff       	call   727 <morecore>
 83a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 83d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 841:	75 07                	jne    84a <malloc+0xcb>
        return 0;
 843:	b8 00 00 00 00       	mov    $0x0,%eax
 848:	eb 13                	jmp    85d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	8b 00                	mov    (%eax),%eax
 855:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 858:	e9 70 ff ff ff       	jmp    7cd <malloc+0x4e>
}
 85d:	c9                   	leave  
 85e:	c3                   	ret    
