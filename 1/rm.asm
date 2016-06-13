
_rm:     file format elf32-i386


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

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 20                	jg     2f <main+0x2f>
    printf(2, "Usage: rm files...\n");
   f:	c7 44 24 04 89 08 00 	movl   $0x889,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 9a 04 00 00       	call   4bd <printf>
    exit(0);
  23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2a:	e8 d6 02 00 00       	call   305 <exit>
  }

  for(i = 1; i < argc; i++){
  2f:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  36:	00 
  37:	eb 4f                	jmp    88 <main+0x88>
    if(unlink(argv[i]) < 0){
  39:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  44:	8b 45 0c             	mov    0xc(%ebp),%eax
  47:	01 d0                	add    %edx,%eax
  49:	8b 00                	mov    (%eax),%eax
  4b:	89 04 24             	mov    %eax,(%esp)
  4e:	e8 12 03 00 00       	call   365 <unlink>
  53:	85 c0                	test   %eax,%eax
  55:	79 2c                	jns    83 <main+0x83>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  57:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  62:	8b 45 0c             	mov    0xc(%ebp),%eax
  65:	01 d0                	add    %edx,%eax
  67:	8b 00                	mov    (%eax),%eax
  69:	89 44 24 08          	mov    %eax,0x8(%esp)
  6d:	c7 44 24 04 9d 08 00 	movl   $0x89d,0x4(%esp)
  74:	00 
  75:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  7c:	e8 3c 04 00 00       	call   4bd <printf>
      break;
  81:	eb 0e                	jmp    91 <main+0x91>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit(0);
  }

  for(i = 1; i < argc; i++){
  83:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  88:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  8f:	7c a8                	jl     39 <main+0x39>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit(0);
  91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  98:	e8 68 02 00 00       	call   305 <exit>

0000009d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  a0:	57                   	push   %edi
  a1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a5:	8b 55 10             	mov    0x10(%ebp),%edx
  a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  ab:	89 cb                	mov    %ecx,%ebx
  ad:	89 df                	mov    %ebx,%edi
  af:	89 d1                	mov    %edx,%ecx
  b1:	fc                   	cld    
  b2:	f3 aa                	rep stos %al,%es:(%edi)
  b4:	89 ca                	mov    %ecx,%edx
  b6:	89 fb                	mov    %edi,%ebx
  b8:	89 5d 08             	mov    %ebx,0x8(%ebp)
  bb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  be:	5b                   	pop    %ebx
  bf:	5f                   	pop    %edi
  c0:	5d                   	pop    %ebp
  c1:	c3                   	ret    

000000c2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  c2:	55                   	push   %ebp
  c3:	89 e5                	mov    %esp,%ebp
  c5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ce:	90                   	nop
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	8d 50 01             	lea    0x1(%eax),%edx
  d5:	89 55 08             	mov    %edx,0x8(%ebp)
  d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  db:	8d 4a 01             	lea    0x1(%edx),%ecx
  de:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  e1:	0f b6 12             	movzbl (%edx),%edx
  e4:	88 10                	mov    %dl,(%eax)
  e6:	0f b6 00             	movzbl (%eax),%eax
  e9:	84 c0                	test   %al,%al
  eb:	75 e2                	jne    cf <strcpy+0xd>
    ;
  return os;
  ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f0:	c9                   	leave  
  f1:	c3                   	ret    

000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	55                   	push   %ebp
  f3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  f5:	eb 08                	jmp    ff <strcmp+0xd>
    p++, q++;
  f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  fb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	84 c0                	test   %al,%al
 107:	74 10                	je     119 <strcmp+0x27>
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	0f b6 10             	movzbl (%eax),%edx
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	38 c2                	cmp    %al,%dl
 117:	74 de                	je     f7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 119:	8b 45 08             	mov    0x8(%ebp),%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	0f b6 d0             	movzbl %al,%edx
 122:	8b 45 0c             	mov    0xc(%ebp),%eax
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	0f b6 c0             	movzbl %al,%eax
 12b:	29 c2                	sub    %eax,%edx
 12d:	89 d0                	mov    %edx,%eax
}
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    

00000131 <strlen>:

uint
strlen(char *s)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 137:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 13e:	eb 04                	jmp    144 <strlen+0x13>
 140:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 144:	8b 55 fc             	mov    -0x4(%ebp),%edx
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	01 d0                	add    %edx,%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	84 c0                	test   %al,%al
 151:	75 ed                	jne    140 <strlen+0xf>
    ;
  return n;
 153:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 156:	c9                   	leave  
 157:	c3                   	ret    

00000158 <memset>:

void*
memset(void *dst, int c, uint n)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 15e:	8b 45 10             	mov    0x10(%ebp),%eax
 161:	89 44 24 08          	mov    %eax,0x8(%esp)
 165:	8b 45 0c             	mov    0xc(%ebp),%eax
 168:	89 44 24 04          	mov    %eax,0x4(%esp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	89 04 24             	mov    %eax,(%esp)
 172:	e8 26 ff ff ff       	call   9d <stosb>
  return dst;
 177:	8b 45 08             	mov    0x8(%ebp),%eax
}
 17a:	c9                   	leave  
 17b:	c3                   	ret    

0000017c <strchr>:

char*
strchr(const char *s, char c)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	83 ec 04             	sub    $0x4,%esp
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 188:	eb 14                	jmp    19e <strchr+0x22>
    if(*s == c)
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	3a 45 fc             	cmp    -0x4(%ebp),%al
 193:	75 05                	jne    19a <strchr+0x1e>
      return (char*)s;
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	eb 13                	jmp    1ad <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 19a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	75 e2                	jne    18a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ad:	c9                   	leave  
 1ae:	c3                   	ret    

000001af <gets>:

char*
gets(char *buf, int max)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1bc:	eb 4c                	jmp    20a <gets+0x5b>
    cc = read(0, &c, 1);
 1be:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1c5:	00 
 1c6:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1d4:	e8 54 01 00 00       	call   32d <read>
 1d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e0:	7f 02                	jg     1e4 <gets+0x35>
      break;
 1e2:	eb 31                	jmp    215 <gets+0x66>
    buf[i++] = c;
 1e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e7:	8d 50 01             	lea    0x1(%eax),%edx
 1ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ed:	89 c2                	mov    %eax,%edx
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	01 c2                	add    %eax,%edx
 1f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1fa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fe:	3c 0a                	cmp    $0xa,%al
 200:	74 13                	je     215 <gets+0x66>
 202:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 206:	3c 0d                	cmp    $0xd,%al
 208:	74 0b                	je     215 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20d:	83 c0 01             	add    $0x1,%eax
 210:	3b 45 0c             	cmp    0xc(%ebp),%eax
 213:	7c a9                	jl     1be <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 215:	8b 55 f4             	mov    -0xc(%ebp),%edx
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	01 d0                	add    %edx,%eax
 21d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 220:	8b 45 08             	mov    0x8(%ebp),%eax
}
 223:	c9                   	leave  
 224:	c3                   	ret    

00000225 <stat>:

int
stat(char *n, struct stat *st)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 232:	00 
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	89 04 24             	mov    %eax,(%esp)
 239:	e8 17 01 00 00       	call   355 <open>
 23e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 245:	79 07                	jns    24e <stat+0x29>
    return -1;
 247:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 24c:	eb 23                	jmp    271 <stat+0x4c>
  r = fstat(fd, st);
 24e:	8b 45 0c             	mov    0xc(%ebp),%eax
 251:	89 44 24 04          	mov    %eax,0x4(%esp)
 255:	8b 45 f4             	mov    -0xc(%ebp),%eax
 258:	89 04 24             	mov    %eax,(%esp)
 25b:	e8 0d 01 00 00       	call   36d <fstat>
 260:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 263:	8b 45 f4             	mov    -0xc(%ebp),%eax
 266:	89 04 24             	mov    %eax,(%esp)
 269:	e8 cf 00 00 00       	call   33d <close>
  return r;
 26e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <atoi>:

int
atoi(const char *s)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 279:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 280:	eb 25                	jmp    2a7 <atoi+0x34>
    n = n*10 + *s++ - '0';
 282:	8b 55 fc             	mov    -0x4(%ebp),%edx
 285:	89 d0                	mov    %edx,%eax
 287:	c1 e0 02             	shl    $0x2,%eax
 28a:	01 d0                	add    %edx,%eax
 28c:	01 c0                	add    %eax,%eax
 28e:	89 c1                	mov    %eax,%ecx
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	8d 50 01             	lea    0x1(%eax),%edx
 296:	89 55 08             	mov    %edx,0x8(%ebp)
 299:	0f b6 00             	movzbl (%eax),%eax
 29c:	0f be c0             	movsbl %al,%eax
 29f:	01 c8                	add    %ecx,%eax
 2a1:	83 e8 30             	sub    $0x30,%eax
 2a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3c 2f                	cmp    $0x2f,%al
 2af:	7e 0a                	jle    2bb <atoi+0x48>
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	3c 39                	cmp    $0x39,%al
 2b9:	7e c7                	jle    282 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2be:	c9                   	leave  
 2bf:	c3                   	ret    

000002c0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2d2:	eb 17                	jmp    2eb <memmove+0x2b>
    *dst++ = *src++;
 2d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d7:	8d 50 01             	lea    0x1(%eax),%edx
 2da:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2dd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e0:	8d 4a 01             	lea    0x1(%edx),%ecx
 2e3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2e6:	0f b6 12             	movzbl (%edx),%edx
 2e9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2eb:	8b 45 10             	mov    0x10(%ebp),%eax
 2ee:	8d 50 ff             	lea    -0x1(%eax),%edx
 2f1:	89 55 10             	mov    %edx,0x10(%ebp)
 2f4:	85 c0                	test   %eax,%eax
 2f6:	7f dc                	jg     2d4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2fb:	c9                   	leave  
 2fc:	c3                   	ret    

000002fd <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 2fd:	b8 01 00 00 00       	mov    $0x1,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <exit>:
SYSCALL(exit)
 305:	b8 02 00 00 00       	mov    $0x2,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <wait>:
SYSCALL(wait)
 30d:	b8 03 00 00 00       	mov    $0x3,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <waitpid>:
SYSCALL(waitpid)
 315:	b8 16 00 00 00       	mov    $0x16,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <wait_stat>:
SYSCALL(wait_stat)
 31d:	b8 17 00 00 00       	mov    $0x17,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <pipe>:
SYSCALL(pipe)
 325:	b8 04 00 00 00       	mov    $0x4,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <read>:
SYSCALL(read)
 32d:	b8 05 00 00 00       	mov    $0x5,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <write>:
SYSCALL(write)
 335:	b8 10 00 00 00       	mov    $0x10,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <close>:
SYSCALL(close)
 33d:	b8 15 00 00 00       	mov    $0x15,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <kill>:
SYSCALL(kill)
 345:	b8 06 00 00 00       	mov    $0x6,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <exec>:
SYSCALL(exec)
 34d:	b8 07 00 00 00       	mov    $0x7,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <open>:
SYSCALL(open)
 355:	b8 0f 00 00 00       	mov    $0xf,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <mknod>:
SYSCALL(mknod)
 35d:	b8 11 00 00 00       	mov    $0x11,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <unlink>:
SYSCALL(unlink)
 365:	b8 12 00 00 00       	mov    $0x12,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <fstat>:
SYSCALL(fstat)
 36d:	b8 08 00 00 00       	mov    $0x8,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <link>:
SYSCALL(link)
 375:	b8 13 00 00 00       	mov    $0x13,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <mkdir>:
SYSCALL(mkdir)
 37d:	b8 14 00 00 00       	mov    $0x14,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <chdir>:
SYSCALL(chdir)
 385:	b8 09 00 00 00       	mov    $0x9,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <dup>:
SYSCALL(dup)
 38d:	b8 0a 00 00 00       	mov    $0xa,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <getpid>:
SYSCALL(getpid)
 395:	b8 0b 00 00 00       	mov    $0xb,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <sbrk>:
SYSCALL(sbrk)
 39d:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <set_priority>:
SYSCALL(set_priority)
 3a5:	b8 18 00 00 00       	mov    $0x18,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <canRemoveJob>:
SYSCALL(canRemoveJob)
 3ad:	b8 19 00 00 00       	mov    $0x19,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <jobs>:
SYSCALL(jobs)
 3b5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <sleep>:
SYSCALL(sleep)
 3bd:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <uptime>:
SYSCALL(uptime)
 3c5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <gidpid>:
SYSCALL(gidpid)
 3cd:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <isShell>:
SYSCALL(isShell)
 3d5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
 3e0:	83 ec 18             	sub    $0x18,%esp
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3f0:	00 
 3f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	89 04 24             	mov    %eax,(%esp)
 3fe:	e8 32 ff ff ff       	call   335 <write>
}
 403:	c9                   	leave  
 404:	c3                   	ret    

00000405 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
 408:	56                   	push   %esi
 409:	53                   	push   %ebx
 40a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 40d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 414:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 418:	74 17                	je     431 <printint+0x2c>
 41a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 41e:	79 11                	jns    431 <printint+0x2c>
    neg = 1;
 420:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 427:	8b 45 0c             	mov    0xc(%ebp),%eax
 42a:	f7 d8                	neg    %eax
 42c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42f:	eb 06                	jmp    437 <printint+0x32>
  } else {
    x = xx;
 431:	8b 45 0c             	mov    0xc(%ebp),%eax
 434:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 437:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 43e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 441:	8d 41 01             	lea    0x1(%ecx),%eax
 444:	89 45 f4             	mov    %eax,-0xc(%ebp)
 447:	8b 5d 10             	mov    0x10(%ebp),%ebx
 44a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44d:	ba 00 00 00 00       	mov    $0x0,%edx
 452:	f7 f3                	div    %ebx
 454:	89 d0                	mov    %edx,%eax
 456:	0f b6 80 04 0b 00 00 	movzbl 0xb04(%eax),%eax
 45d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 461:	8b 75 10             	mov    0x10(%ebp),%esi
 464:	8b 45 ec             	mov    -0x14(%ebp),%eax
 467:	ba 00 00 00 00       	mov    $0x0,%edx
 46c:	f7 f6                	div    %esi
 46e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 471:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 475:	75 c7                	jne    43e <printint+0x39>
  if(neg)
 477:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47b:	74 10                	je     48d <printint+0x88>
    buf[i++] = '-';
 47d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 480:	8d 50 01             	lea    0x1(%eax),%edx
 483:	89 55 f4             	mov    %edx,-0xc(%ebp)
 486:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 48b:	eb 1f                	jmp    4ac <printint+0xa7>
 48d:	eb 1d                	jmp    4ac <printint+0xa7>
    putc(fd, buf[i]);
 48f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 492:	8b 45 f4             	mov    -0xc(%ebp),%eax
 495:	01 d0                	add    %edx,%eax
 497:	0f b6 00             	movzbl (%eax),%eax
 49a:	0f be c0             	movsbl %al,%eax
 49d:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	89 04 24             	mov    %eax,(%esp)
 4a7:	e8 31 ff ff ff       	call   3dd <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ac:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b4:	79 d9                	jns    48f <printint+0x8a>
    putc(fd, buf[i]);
}
 4b6:	83 c4 30             	add    $0x30,%esp
 4b9:	5b                   	pop    %ebx
 4ba:	5e                   	pop    %esi
 4bb:	5d                   	pop    %ebp
 4bc:	c3                   	ret    

000004bd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4bd:	55                   	push   %ebp
 4be:	89 e5                	mov    %esp,%ebp
 4c0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ca:	8d 45 0c             	lea    0xc(%ebp),%eax
 4cd:	83 c0 04             	add    $0x4,%eax
 4d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4da:	e9 7c 01 00 00       	jmp    65b <printf+0x19e>
    c = fmt[i] & 0xff;
 4df:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e5:	01 d0                	add    %edx,%eax
 4e7:	0f b6 00             	movzbl (%eax),%eax
 4ea:	0f be c0             	movsbl %al,%eax
 4ed:	25 ff 00 00 00       	and    $0xff,%eax
 4f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f9:	75 2c                	jne    527 <printf+0x6a>
      if(c == '%'){
 4fb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ff:	75 0c                	jne    50d <printf+0x50>
        state = '%';
 501:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 508:	e9 4a 01 00 00       	jmp    657 <printf+0x19a>
      } else {
        putc(fd, c);
 50d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 510:	0f be c0             	movsbl %al,%eax
 513:	89 44 24 04          	mov    %eax,0x4(%esp)
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	89 04 24             	mov    %eax,(%esp)
 51d:	e8 bb fe ff ff       	call   3dd <putc>
 522:	e9 30 01 00 00       	jmp    657 <printf+0x19a>
      }
    } else if(state == '%'){
 527:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 52b:	0f 85 26 01 00 00    	jne    657 <printf+0x19a>
      if(c == 'd'){
 531:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 535:	75 2d                	jne    564 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 537:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53a:	8b 00                	mov    (%eax),%eax
 53c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 543:	00 
 544:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 54b:	00 
 54c:	89 44 24 04          	mov    %eax,0x4(%esp)
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	89 04 24             	mov    %eax,(%esp)
 556:	e8 aa fe ff ff       	call   405 <printint>
        ap++;
 55b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55f:	e9 ec 00 00 00       	jmp    650 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 564:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 568:	74 06                	je     570 <printf+0xb3>
 56a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 56e:	75 2d                	jne    59d <printf+0xe0>
        printint(fd, *ap, 16, 0);
 570:	8b 45 e8             	mov    -0x18(%ebp),%eax
 573:	8b 00                	mov    (%eax),%eax
 575:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 57c:	00 
 57d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 584:	00 
 585:	89 44 24 04          	mov    %eax,0x4(%esp)
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 71 fe ff ff       	call   405 <printint>
        ap++;
 594:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 598:	e9 b3 00 00 00       	jmp    650 <printf+0x193>
      } else if(c == 's'){
 59d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a1:	75 45                	jne    5e8 <printf+0x12b>
        s = (char*)*ap;
 5a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a6:	8b 00                	mov    (%eax),%eax
 5a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b3:	75 09                	jne    5be <printf+0x101>
          s = "(null)";
 5b5:	c7 45 f4 b6 08 00 00 	movl   $0x8b6,-0xc(%ebp)
        while(*s != 0){
 5bc:	eb 1e                	jmp    5dc <printf+0x11f>
 5be:	eb 1c                	jmp    5dc <printf+0x11f>
          putc(fd, *s);
 5c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c3:	0f b6 00             	movzbl (%eax),%eax
 5c6:	0f be c0             	movsbl %al,%eax
 5c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cd:	8b 45 08             	mov    0x8(%ebp),%eax
 5d0:	89 04 24             	mov    %eax,(%esp)
 5d3:	e8 05 fe ff ff       	call   3dd <putc>
          s++;
 5d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5df:	0f b6 00             	movzbl (%eax),%eax
 5e2:	84 c0                	test   %al,%al
 5e4:	75 da                	jne    5c0 <printf+0x103>
 5e6:	eb 68                	jmp    650 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ec:	75 1d                	jne    60b <printf+0x14e>
        putc(fd, *ap);
 5ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f1:	8b 00                	mov    (%eax),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fa:	8b 45 08             	mov    0x8(%ebp),%eax
 5fd:	89 04 24             	mov    %eax,(%esp)
 600:	e8 d8 fd ff ff       	call   3dd <putc>
        ap++;
 605:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 609:	eb 45                	jmp    650 <printf+0x193>
      } else if(c == '%'){
 60b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60f:	75 17                	jne    628 <printf+0x16b>
        putc(fd, c);
 611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 614:	0f be c0             	movsbl %al,%eax
 617:	89 44 24 04          	mov    %eax,0x4(%esp)
 61b:	8b 45 08             	mov    0x8(%ebp),%eax
 61e:	89 04 24             	mov    %eax,(%esp)
 621:	e8 b7 fd ff ff       	call   3dd <putc>
 626:	eb 28                	jmp    650 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 628:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 62f:	00 
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	89 04 24             	mov    %eax,(%esp)
 636:	e8 a2 fd ff ff       	call   3dd <putc>
        putc(fd, c);
 63b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63e:	0f be c0             	movsbl %al,%eax
 641:	89 44 24 04          	mov    %eax,0x4(%esp)
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	89 04 24             	mov    %eax,(%esp)
 64b:	e8 8d fd ff ff       	call   3dd <putc>
      }
      state = 0;
 650:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 657:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65b:	8b 55 0c             	mov    0xc(%ebp),%edx
 65e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 661:	01 d0                	add    %edx,%eax
 663:	0f b6 00             	movzbl (%eax),%eax
 666:	84 c0                	test   %al,%al
 668:	0f 85 71 fe ff ff    	jne    4df <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 66e:	c9                   	leave  
 66f:	c3                   	ret    

00000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 676:	8b 45 08             	mov    0x8(%ebp),%eax
 679:	83 e8 08             	sub    $0x8,%eax
 67c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67f:	a1 20 0b 00 00       	mov    0xb20,%eax
 684:	89 45 fc             	mov    %eax,-0x4(%ebp)
 687:	eb 24                	jmp    6ad <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 691:	77 12                	ja     6a5 <free+0x35>
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 699:	77 24                	ja     6bf <free+0x4f>
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a3:	77 1a                	ja     6bf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 00                	mov    (%eax),%eax
 6aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b3:	76 d4                	jbe    689 <free+0x19>
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bd:	76 ca                	jbe    689 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	8b 40 04             	mov    0x4(%eax),%eax
 6c5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	01 c2                	add    %eax,%edx
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	39 c2                	cmp    %eax,%edx
 6d8:	75 24                	jne    6fe <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dd:	8b 50 04             	mov    0x4(%eax),%edx
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	8b 40 04             	mov    0x4(%eax),%eax
 6e8:	01 c2                	add    %eax,%edx
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	8b 10                	mov    (%eax),%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	89 10                	mov    %edx,(%eax)
 6fc:	eb 0a                	jmp    708 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	8b 10                	mov    (%eax),%edx
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 40 04             	mov    0x4(%eax),%eax
 70e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	01 d0                	add    %edx,%eax
 71a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71d:	75 20                	jne    73f <free+0xcf>
    p->s.size += bp->s.size;
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 50 04             	mov    0x4(%eax),%edx
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	8b 40 04             	mov    0x4(%eax),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	8b 10                	mov    (%eax),%edx
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	89 10                	mov    %edx,(%eax)
 73d:	eb 08                	jmp    747 <free+0xd7>
  } else
    p->s.ptr = bp;
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	8b 55 f8             	mov    -0x8(%ebp),%edx
 745:	89 10                	mov    %edx,(%eax)
  freep = p;
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 74f:	c9                   	leave  
 750:	c3                   	ret    

00000751 <morecore>:

static Header*
morecore(uint nu)
{
 751:	55                   	push   %ebp
 752:	89 e5                	mov    %esp,%ebp
 754:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 757:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 75e:	77 07                	ja     767 <morecore+0x16>
    nu = 4096;
 760:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 767:	8b 45 08             	mov    0x8(%ebp),%eax
 76a:	c1 e0 03             	shl    $0x3,%eax
 76d:	89 04 24             	mov    %eax,(%esp)
 770:	e8 28 fc ff ff       	call   39d <sbrk>
 775:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 778:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 77c:	75 07                	jne    785 <morecore+0x34>
    return 0;
 77e:	b8 00 00 00 00       	mov    $0x0,%eax
 783:	eb 22                	jmp    7a7 <morecore+0x56>
  hp = (Header*)p;
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 78b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78e:	8b 55 08             	mov    0x8(%ebp),%edx
 791:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	83 c0 08             	add    $0x8,%eax
 79a:	89 04 24             	mov    %eax,(%esp)
 79d:	e8 ce fe ff ff       	call   670 <free>
  return freep;
 7a2:	a1 20 0b 00 00       	mov    0xb20,%eax
}
 7a7:	c9                   	leave  
 7a8:	c3                   	ret    

000007a9 <malloc>:

void*
malloc(uint nbytes)
{
 7a9:	55                   	push   %ebp
 7aa:	89 e5                	mov    %esp,%ebp
 7ac:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7af:	8b 45 08             	mov    0x8(%ebp),%eax
 7b2:	83 c0 07             	add    $0x7,%eax
 7b5:	c1 e8 03             	shr    $0x3,%eax
 7b8:	83 c0 01             	add    $0x1,%eax
 7bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7be:	a1 20 0b 00 00       	mov    0xb20,%eax
 7c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ca:	75 23                	jne    7ef <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7cc:	c7 45 f0 18 0b 00 00 	movl   $0xb18,-0x10(%ebp)
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	a3 20 0b 00 00       	mov    %eax,0xb20
 7db:	a1 20 0b 00 00       	mov    0xb20,%eax
 7e0:	a3 18 0b 00 00       	mov    %eax,0xb18
    base.s.size = 0;
 7e5:	c7 05 1c 0b 00 00 00 	movl   $0x0,0xb1c
 7ec:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	8b 00                	mov    (%eax),%eax
 7f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 800:	72 4d                	jb     84f <malloc+0xa6>
      if(p->s.size == nunits)
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 40 04             	mov    0x4(%eax),%eax
 808:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80b:	75 0c                	jne    819 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	8b 10                	mov    (%eax),%edx
 812:	8b 45 f0             	mov    -0x10(%ebp),%eax
 815:	89 10                	mov    %edx,(%eax)
 817:	eb 26                	jmp    83f <malloc+0x96>
      else {
        p->s.size -= nunits;
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	8b 40 04             	mov    0x4(%eax),%eax
 81f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 822:	89 c2                	mov    %eax,%edx
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	8b 40 04             	mov    0x4(%eax),%eax
 830:	c1 e0 03             	shl    $0x3,%eax
 833:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 842:	a3 20 0b 00 00       	mov    %eax,0xb20
      return (void*)(p + 1);
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	83 c0 08             	add    $0x8,%eax
 84d:	eb 38                	jmp    887 <malloc+0xde>
    }
    if(p == freep)
 84f:	a1 20 0b 00 00       	mov    0xb20,%eax
 854:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 857:	75 1b                	jne    874 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 859:	8b 45 ec             	mov    -0x14(%ebp),%eax
 85c:	89 04 24             	mov    %eax,(%esp)
 85f:	e8 ed fe ff ff       	call   751 <morecore>
 864:	89 45 f4             	mov    %eax,-0xc(%ebp)
 867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86b:	75 07                	jne    874 <malloc+0xcb>
        return 0;
 86d:	b8 00 00 00 00       	mov    $0x0,%eax
 872:	eb 13                	jmp    887 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	8b 00                	mov    (%eax),%eax
 87f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 882:	e9 70 ff ff ff       	jmp    7f7 <malloc+0x4e>
}
 887:	c9                   	leave  
 888:	c3                   	ret    
