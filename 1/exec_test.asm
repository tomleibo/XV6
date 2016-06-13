
_exec_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp

printf(1, "I am a non exiting exec test!\n");
   9:	c7 44 24 04 10 08 00 	movl   $0x810,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 27 04 00 00       	call   444 <printf>
return 7;
  1d:	b8 07 00 00 00       	mov    $0x7,%eax

} 
  22:	c9                   	leave  
  23:	c3                   	ret    

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	5b                   	pop    %ebx
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  55:	90                   	nop
  56:	8b 45 08             	mov    0x8(%ebp),%eax
  59:	8d 50 01             	lea    0x1(%eax),%edx
  5c:	89 55 08             	mov    %edx,0x8(%ebp)
  5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  62:	8d 4a 01             	lea    0x1(%edx),%ecx
  65:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  68:	0f b6 12             	movzbl (%edx),%edx
  6b:	88 10                	mov    %dl,(%eax)
  6d:	0f b6 00             	movzbl (%eax),%eax
  70:	84 c0                	test   %al,%al
  72:	75 e2                	jne    56 <strcpy+0xd>
    ;
  return os;
  74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  77:	c9                   	leave  
  78:	c3                   	ret    

00000079 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7c:	eb 08                	jmp    86 <strcmp+0xd>
    p++, q++;
  7e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  82:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  86:	8b 45 08             	mov    0x8(%ebp),%eax
  89:	0f b6 00             	movzbl (%eax),%eax
  8c:	84 c0                	test   %al,%al
  8e:	74 10                	je     a0 <strcmp+0x27>
  90:	8b 45 08             	mov    0x8(%ebp),%eax
  93:	0f b6 10             	movzbl (%eax),%edx
  96:	8b 45 0c             	mov    0xc(%ebp),%eax
  99:	0f b6 00             	movzbl (%eax),%eax
  9c:	38 c2                	cmp    %al,%dl
  9e:	74 de                	je     7e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	0f b6 00             	movzbl (%eax),%eax
  a6:	0f b6 d0             	movzbl %al,%edx
  a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 c0             	movzbl %al,%eax
  b2:	29 c2                	sub    %eax,%edx
  b4:	89 d0                	mov    %edx,%eax
}
  b6:	5d                   	pop    %ebp
  b7:	c3                   	ret    

000000b8 <strlen>:

uint
strlen(char *s)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c5:	eb 04                	jmp    cb <strlen+0x13>
  c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	01 d0                	add    %edx,%eax
  d3:	0f b6 00             	movzbl (%eax),%eax
  d6:	84 c0                	test   %al,%al
  d8:	75 ed                	jne    c7 <strlen+0xf>
    ;
  return n;
  da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dd:	c9                   	leave  
  de:	c3                   	ret    

000000df <memset>:

void*
memset(void *dst, int c, uint n)
{
  df:	55                   	push   %ebp
  e0:	89 e5                	mov    %esp,%ebp
  e2:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  e5:	8b 45 10             	mov    0x10(%ebp),%eax
  e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	89 04 24             	mov    %eax,(%esp)
  f9:	e8 26 ff ff ff       	call   24 <stosb>
  return dst;
  fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <strchr>:

char*
strchr(const char *s, char c)
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 ec 04             	sub    $0x4,%esp
 109:	8b 45 0c             	mov    0xc(%ebp),%eax
 10c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10f:	eb 14                	jmp    125 <strchr+0x22>
    if(*s == c)
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	3a 45 fc             	cmp    -0x4(%ebp),%al
 11a:	75 05                	jne    121 <strchr+0x1e>
      return (char*)s;
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	eb 13                	jmp    134 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 121:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	84 c0                	test   %al,%al
 12d:	75 e2                	jne    111 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 134:	c9                   	leave  
 135:	c3                   	ret    

00000136 <gets>:

char*
gets(char *buf, int max)
{
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
 139:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 143:	eb 4c                	jmp    191 <gets+0x5b>
    cc = read(0, &c, 1);
 145:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14c:	00 
 14d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 150:	89 44 24 04          	mov    %eax,0x4(%esp)
 154:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15b:	e8 54 01 00 00       	call   2b4 <read>
 160:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 163:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 167:	7f 02                	jg     16b <gets+0x35>
      break;
 169:	eb 31                	jmp    19c <gets+0x66>
    buf[i++] = c;
 16b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16e:	8d 50 01             	lea    0x1(%eax),%edx
 171:	89 55 f4             	mov    %edx,-0xc(%ebp)
 174:	89 c2                	mov    %eax,%edx
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	01 c2                	add    %eax,%edx
 17b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 181:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 185:	3c 0a                	cmp    $0xa,%al
 187:	74 13                	je     19c <gets+0x66>
 189:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18d:	3c 0d                	cmp    $0xd,%al
 18f:	74 0b                	je     19c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 191:	8b 45 f4             	mov    -0xc(%ebp),%eax
 194:	83 c0 01             	add    $0x1,%eax
 197:	3b 45 0c             	cmp    0xc(%ebp),%eax
 19a:	7c a9                	jl     145 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1aa:	c9                   	leave  
 1ab:	c3                   	ret    

000001ac <stat>:

int
stat(char *n, struct stat *st)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b9:	00 
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	89 04 24             	mov    %eax,(%esp)
 1c0:	e8 17 01 00 00       	call   2dc <open>
 1c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1cc:	79 07                	jns    1d5 <stat+0x29>
    return -1;
 1ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d3:	eb 23                	jmp    1f8 <stat+0x4c>
  r = fstat(fd, st);
 1d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1df:	89 04 24             	mov    %eax,(%esp)
 1e2:	e8 0d 01 00 00       	call   2f4 <fstat>
 1e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ed:	89 04 24             	mov    %eax,(%esp)
 1f0:	e8 cf 00 00 00       	call   2c4 <close>
  return r;
 1f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <atoi>:

int
atoi(const char *s)
{
 1fa:	55                   	push   %ebp
 1fb:	89 e5                	mov    %esp,%ebp
 1fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 200:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 207:	eb 25                	jmp    22e <atoi+0x34>
    n = n*10 + *s++ - '0';
 209:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20c:	89 d0                	mov    %edx,%eax
 20e:	c1 e0 02             	shl    $0x2,%eax
 211:	01 d0                	add    %edx,%eax
 213:	01 c0                	add    %eax,%eax
 215:	89 c1                	mov    %eax,%ecx
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	8d 50 01             	lea    0x1(%eax),%edx
 21d:	89 55 08             	mov    %edx,0x8(%ebp)
 220:	0f b6 00             	movzbl (%eax),%eax
 223:	0f be c0             	movsbl %al,%eax
 226:	01 c8                	add    %ecx,%eax
 228:	83 e8 30             	sub    $0x30,%eax
 22b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	3c 2f                	cmp    $0x2f,%al
 236:	7e 0a                	jle    242 <atoi+0x48>
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	3c 39                	cmp    $0x39,%al
 240:	7e c7                	jle    209 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 242:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 245:	c9                   	leave  
 246:	c3                   	ret    

00000247 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
 24a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 259:	eb 17                	jmp    272 <memmove+0x2b>
    *dst++ = *src++;
 25b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25e:	8d 50 01             	lea    0x1(%eax),%edx
 261:	89 55 fc             	mov    %edx,-0x4(%ebp)
 264:	8b 55 f8             	mov    -0x8(%ebp),%edx
 267:	8d 4a 01             	lea    0x1(%edx),%ecx
 26a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 26d:	0f b6 12             	movzbl (%edx),%edx
 270:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 272:	8b 45 10             	mov    0x10(%ebp),%eax
 275:	8d 50 ff             	lea    -0x1(%eax),%edx
 278:	89 55 10             	mov    %edx,0x10(%ebp)
 27b:	85 c0                	test   %eax,%eax
 27d:	7f dc                	jg     25b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 284:	b8 01 00 00 00       	mov    $0x1,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <exit>:
SYSCALL(exit)
 28c:	b8 02 00 00 00       	mov    $0x2,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <wait>:
SYSCALL(wait)
 294:	b8 03 00 00 00       	mov    $0x3,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <waitpid>:
SYSCALL(waitpid)
 29c:	b8 16 00 00 00       	mov    $0x16,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <wait_stat>:
SYSCALL(wait_stat)
 2a4:	b8 17 00 00 00       	mov    $0x17,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <pipe>:
SYSCALL(pipe)
 2ac:	b8 04 00 00 00       	mov    $0x4,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <read>:
SYSCALL(read)
 2b4:	b8 05 00 00 00       	mov    $0x5,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <write>:
SYSCALL(write)
 2bc:	b8 10 00 00 00       	mov    $0x10,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <close>:
SYSCALL(close)
 2c4:	b8 15 00 00 00       	mov    $0x15,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <kill>:
SYSCALL(kill)
 2cc:	b8 06 00 00 00       	mov    $0x6,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <exec>:
SYSCALL(exec)
 2d4:	b8 07 00 00 00       	mov    $0x7,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <open>:
SYSCALL(open)
 2dc:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <mknod>:
SYSCALL(mknod)
 2e4:	b8 11 00 00 00       	mov    $0x11,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <unlink>:
SYSCALL(unlink)
 2ec:	b8 12 00 00 00       	mov    $0x12,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <fstat>:
SYSCALL(fstat)
 2f4:	b8 08 00 00 00       	mov    $0x8,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <link>:
SYSCALL(link)
 2fc:	b8 13 00 00 00       	mov    $0x13,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <mkdir>:
SYSCALL(mkdir)
 304:	b8 14 00 00 00       	mov    $0x14,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <chdir>:
SYSCALL(chdir)
 30c:	b8 09 00 00 00       	mov    $0x9,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <dup>:
SYSCALL(dup)
 314:	b8 0a 00 00 00       	mov    $0xa,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <getpid>:
SYSCALL(getpid)
 31c:	b8 0b 00 00 00       	mov    $0xb,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <sbrk>:
SYSCALL(sbrk)
 324:	b8 0c 00 00 00       	mov    $0xc,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <set_priority>:
SYSCALL(set_priority)
 32c:	b8 18 00 00 00       	mov    $0x18,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <canRemoveJob>:
SYSCALL(canRemoveJob)
 334:	b8 19 00 00 00       	mov    $0x19,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <jobs>:
SYSCALL(jobs)
 33c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <sleep>:
SYSCALL(sleep)
 344:	b8 0d 00 00 00       	mov    $0xd,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <uptime>:
SYSCALL(uptime)
 34c:	b8 0e 00 00 00       	mov    $0xe,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <gidpid>:
SYSCALL(gidpid)
 354:	b8 1b 00 00 00       	mov    $0x1b,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <isShell>:
SYSCALL(isShell)
 35c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 18             	sub    $0x18,%esp
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 370:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 377:	00 
 378:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37b:	89 44 24 04          	mov    %eax,0x4(%esp)
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	89 04 24             	mov    %eax,(%esp)
 385:	e8 32 ff ff ff       	call   2bc <write>
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
 38f:	56                   	push   %esi
 390:	53                   	push   %ebx
 391:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 394:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39f:	74 17                	je     3b8 <printint+0x2c>
 3a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a5:	79 11                	jns    3b8 <printint+0x2c>
    neg = 1;
 3a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	f7 d8                	neg    %eax
 3b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b6:	eb 06                	jmp    3be <printint+0x32>
  } else {
    x = xx;
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c8:	8d 41 01             	lea    0x1(%ecx),%eax
 3cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d4:	ba 00 00 00 00       	mov    $0x0,%edx
 3d9:	f7 f3                	div    %ebx
 3db:	89 d0                	mov    %edx,%eax
 3dd:	0f b6 80 80 0a 00 00 	movzbl 0xa80(%eax),%eax
 3e4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e8:	8b 75 10             	mov    0x10(%ebp),%esi
 3eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ee:	ba 00 00 00 00       	mov    $0x0,%edx
 3f3:	f7 f6                	div    %esi
 3f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fc:	75 c7                	jne    3c5 <printint+0x39>
  if(neg)
 3fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 402:	74 10                	je     414 <printint+0x88>
    buf[i++] = '-';
 404:	8b 45 f4             	mov    -0xc(%ebp),%eax
 407:	8d 50 01             	lea    0x1(%eax),%edx
 40a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 40d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 412:	eb 1f                	jmp    433 <printint+0xa7>
 414:	eb 1d                	jmp    433 <printint+0xa7>
    putc(fd, buf[i]);
 416:	8d 55 dc             	lea    -0x24(%ebp),%edx
 419:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41c:	01 d0                	add    %edx,%eax
 41e:	0f b6 00             	movzbl (%eax),%eax
 421:	0f be c0             	movsbl %al,%eax
 424:	89 44 24 04          	mov    %eax,0x4(%esp)
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	89 04 24             	mov    %eax,(%esp)
 42e:	e8 31 ff ff ff       	call   364 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 433:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 437:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 43b:	79 d9                	jns    416 <printint+0x8a>
    putc(fd, buf[i]);
}
 43d:	83 c4 30             	add    $0x30,%esp
 440:	5b                   	pop    %ebx
 441:	5e                   	pop    %esi
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    

00000444 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 44a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 451:	8d 45 0c             	lea    0xc(%ebp),%eax
 454:	83 c0 04             	add    $0x4,%eax
 457:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 45a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 461:	e9 7c 01 00 00       	jmp    5e2 <printf+0x19e>
    c = fmt[i] & 0xff;
 466:	8b 55 0c             	mov    0xc(%ebp),%edx
 469:	8b 45 f0             	mov    -0x10(%ebp),%eax
 46c:	01 d0                	add    %edx,%eax
 46e:	0f b6 00             	movzbl (%eax),%eax
 471:	0f be c0             	movsbl %al,%eax
 474:	25 ff 00 00 00       	and    $0xff,%eax
 479:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 47c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 480:	75 2c                	jne    4ae <printf+0x6a>
      if(c == '%'){
 482:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 486:	75 0c                	jne    494 <printf+0x50>
        state = '%';
 488:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 48f:	e9 4a 01 00 00       	jmp    5de <printf+0x19a>
      } else {
        putc(fd, c);
 494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 497:	0f be c0             	movsbl %al,%eax
 49a:	89 44 24 04          	mov    %eax,0x4(%esp)
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	89 04 24             	mov    %eax,(%esp)
 4a4:	e8 bb fe ff ff       	call   364 <putc>
 4a9:	e9 30 01 00 00       	jmp    5de <printf+0x19a>
      }
    } else if(state == '%'){
 4ae:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b2:	0f 85 26 01 00 00    	jne    5de <printf+0x19a>
      if(c == 'd'){
 4b8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4bc:	75 2d                	jne    4eb <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c1:	8b 00                	mov    (%eax),%eax
 4c3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4ca:	00 
 4cb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4d2:	00 
 4d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	89 04 24             	mov    %eax,(%esp)
 4dd:	e8 aa fe ff ff       	call   38c <printint>
        ap++;
 4e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e6:	e9 ec 00 00 00       	jmp    5d7 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4eb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ef:	74 06                	je     4f7 <printf+0xb3>
 4f1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f5:	75 2d                	jne    524 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fa:	8b 00                	mov    (%eax),%eax
 4fc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 503:	00 
 504:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 50b:	00 
 50c:	89 44 24 04          	mov    %eax,0x4(%esp)
 510:	8b 45 08             	mov    0x8(%ebp),%eax
 513:	89 04 24             	mov    %eax,(%esp)
 516:	e8 71 fe ff ff       	call   38c <printint>
        ap++;
 51b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51f:	e9 b3 00 00 00       	jmp    5d7 <printf+0x193>
      } else if(c == 's'){
 524:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 528:	75 45                	jne    56f <printf+0x12b>
        s = (char*)*ap;
 52a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52d:	8b 00                	mov    (%eax),%eax
 52f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 532:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53a:	75 09                	jne    545 <printf+0x101>
          s = "(null)";
 53c:	c7 45 f4 2f 08 00 00 	movl   $0x82f,-0xc(%ebp)
        while(*s != 0){
 543:	eb 1e                	jmp    563 <printf+0x11f>
 545:	eb 1c                	jmp    563 <printf+0x11f>
          putc(fd, *s);
 547:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54a:	0f b6 00             	movzbl (%eax),%eax
 54d:	0f be c0             	movsbl %al,%eax
 550:	89 44 24 04          	mov    %eax,0x4(%esp)
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	89 04 24             	mov    %eax,(%esp)
 55a:	e8 05 fe ff ff       	call   364 <putc>
          s++;
 55f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 563:	8b 45 f4             	mov    -0xc(%ebp),%eax
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	84 c0                	test   %al,%al
 56b:	75 da                	jne    547 <printf+0x103>
 56d:	eb 68                	jmp    5d7 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 56f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 573:	75 1d                	jne    592 <printf+0x14e>
        putc(fd, *ap);
 575:	8b 45 e8             	mov    -0x18(%ebp),%eax
 578:	8b 00                	mov    (%eax),%eax
 57a:	0f be c0             	movsbl %al,%eax
 57d:	89 44 24 04          	mov    %eax,0x4(%esp)
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	89 04 24             	mov    %eax,(%esp)
 587:	e8 d8 fd ff ff       	call   364 <putc>
        ap++;
 58c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 590:	eb 45                	jmp    5d7 <printf+0x193>
      } else if(c == '%'){
 592:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 596:	75 17                	jne    5af <printf+0x16b>
        putc(fd, c);
 598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59b:	0f be c0             	movsbl %al,%eax
 59e:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a2:	8b 45 08             	mov    0x8(%ebp),%eax
 5a5:	89 04 24             	mov    %eax,(%esp)
 5a8:	e8 b7 fd ff ff       	call   364 <putc>
 5ad:	eb 28                	jmp    5d7 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5af:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5b6:	00 
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 a2 fd ff ff       	call   364 <putc>
        putc(fd, c);
 5c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 8d fd ff ff       	call   364 <putc>
      }
      state = 0;
 5d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5de:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5e2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e8:	01 d0                	add    %edx,%eax
 5ea:	0f b6 00             	movzbl (%eax),%eax
 5ed:	84 c0                	test   %al,%al
 5ef:	0f 85 71 fe ff ff    	jne    466 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5f5:	c9                   	leave  
 5f6:	c3                   	ret    

000005f7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f7:	55                   	push   %ebp
 5f8:	89 e5                	mov    %esp,%ebp
 5fa:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fd:	8b 45 08             	mov    0x8(%ebp),%eax
 600:	83 e8 08             	sub    $0x8,%eax
 603:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 606:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 60b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60e:	eb 24                	jmp    634 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 610:	8b 45 fc             	mov    -0x4(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 618:	77 12                	ja     62c <free+0x35>
 61a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 620:	77 24                	ja     646 <free+0x4f>
 622:	8b 45 fc             	mov    -0x4(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62a:	77 1a                	ja     646 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	89 45 fc             	mov    %eax,-0x4(%ebp)
 634:	8b 45 f8             	mov    -0x8(%ebp),%eax
 637:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63a:	76 d4                	jbe    610 <free+0x19>
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 644:	76 ca                	jbe    610 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	8b 40 04             	mov    0x4(%eax),%eax
 64c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	01 c2                	add    %eax,%edx
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	39 c2                	cmp    %eax,%edx
 65f:	75 24                	jne    685 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	8b 50 04             	mov    0x4(%eax),%edx
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	8b 40 04             	mov    0x4(%eax),%eax
 66f:	01 c2                	add    %eax,%edx
 671:	8b 45 f8             	mov    -0x8(%ebp),%eax
 674:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	8b 10                	mov    (%eax),%edx
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	89 10                	mov    %edx,(%eax)
 683:	eb 0a                	jmp    68f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 10                	mov    (%eax),%edx
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 40 04             	mov    0x4(%eax),%eax
 695:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	01 d0                	add    %edx,%eax
 6a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a4:	75 20                	jne    6c6 <free+0xcf>
    p->s.size += bp->s.size;
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 50 04             	mov    0x4(%eax),%edx
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	8b 40 04             	mov    0x4(%eax),%eax
 6b2:	01 c2                	add    %eax,%edx
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	89 10                	mov    %edx,(%eax)
 6c4:	eb 08                	jmp    6ce <free+0xd7>
  } else
    p->s.ptr = bp;
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6cc:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	a3 9c 0a 00 00       	mov    %eax,0xa9c
}
 6d6:	c9                   	leave  
 6d7:	c3                   	ret    

000006d8 <morecore>:

static Header*
morecore(uint nu)
{
 6d8:	55                   	push   %ebp
 6d9:	89 e5                	mov    %esp,%ebp
 6db:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6de:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e5:	77 07                	ja     6ee <morecore+0x16>
    nu = 4096;
 6e7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ee:	8b 45 08             	mov    0x8(%ebp),%eax
 6f1:	c1 e0 03             	shl    $0x3,%eax
 6f4:	89 04 24             	mov    %eax,(%esp)
 6f7:	e8 28 fc ff ff       	call   324 <sbrk>
 6fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ff:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 703:	75 07                	jne    70c <morecore+0x34>
    return 0;
 705:	b8 00 00 00 00       	mov    $0x0,%eax
 70a:	eb 22                	jmp    72e <morecore+0x56>
  hp = (Header*)p;
 70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 712:	8b 45 f0             	mov    -0x10(%ebp),%eax
 715:	8b 55 08             	mov    0x8(%ebp),%edx
 718:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 71b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71e:	83 c0 08             	add    $0x8,%eax
 721:	89 04 24             	mov    %eax,(%esp)
 724:	e8 ce fe ff ff       	call   5f7 <free>
  return freep;
 729:	a1 9c 0a 00 00       	mov    0xa9c,%eax
}
 72e:	c9                   	leave  
 72f:	c3                   	ret    

00000730 <malloc>:

void*
malloc(uint nbytes)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 736:	8b 45 08             	mov    0x8(%ebp),%eax
 739:	83 c0 07             	add    $0x7,%eax
 73c:	c1 e8 03             	shr    $0x3,%eax
 73f:	83 c0 01             	add    $0x1,%eax
 742:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 745:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 74a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 751:	75 23                	jne    776 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 753:	c7 45 f0 94 0a 00 00 	movl   $0xa94,-0x10(%ebp)
 75a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75d:	a3 9c 0a 00 00       	mov    %eax,0xa9c
 762:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 767:	a3 94 0a 00 00       	mov    %eax,0xa94
    base.s.size = 0;
 76c:	c7 05 98 0a 00 00 00 	movl   $0x0,0xa98
 773:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 776:	8b 45 f0             	mov    -0x10(%ebp),%eax
 779:	8b 00                	mov    (%eax),%eax
 77b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	8b 40 04             	mov    0x4(%eax),%eax
 784:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 787:	72 4d                	jb     7d6 <malloc+0xa6>
      if(p->s.size == nunits)
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 40 04             	mov    0x4(%eax),%eax
 78f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 792:	75 0c                	jne    7a0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	8b 10                	mov    (%eax),%edx
 799:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79c:	89 10                	mov    %edx,(%eax)
 79e:	eb 26                	jmp    7c6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a9:	89 c2                	mov    %eax,%edx
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	8b 40 04             	mov    0x4(%eax),%eax
 7b7:	c1 e0 03             	shl    $0x3,%eax
 7ba:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c9:	a3 9c 0a 00 00       	mov    %eax,0xa9c
      return (void*)(p + 1);
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	83 c0 08             	add    $0x8,%eax
 7d4:	eb 38                	jmp    80e <malloc+0xde>
    }
    if(p == freep)
 7d6:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 7db:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7de:	75 1b                	jne    7fb <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e3:	89 04 24             	mov    %eax,(%esp)
 7e6:	e8 ed fe ff ff       	call   6d8 <morecore>
 7eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f2:	75 07                	jne    7fb <malloc+0xcb>
        return 0;
 7f4:	b8 00 00 00 00       	mov    $0x0,%eax
 7f9:	eb 13                	jmp    80e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 00                	mov    (%eax),%eax
 806:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 809:	e9 70 ff ff ff       	jmp    77e <malloc+0x4e>
}
 80e:	c9                   	leave  
 80f:	c3                   	ret    
