
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 ad 09 00 	movl   $0x9ad,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 a1 05 00 00       	call   5e1 <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 20 02 00 00       	call   27c <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 13                	jmp    7c <main+0x7c>
    if(fork() > 0)
  69:	e8 b3 03 00 00       	call   421 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7e 02                	jle    74 <main+0x74>
      break;
  72:	eb 12                	jmp    86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  74:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  7b:	01 
  7c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  83:	03 
  84:	7e e3                	jle    69 <main+0x69>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  86:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 c0 09 00 	movl   $0x9c0,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 3c 05 00 00       	call   5e1 <printf>

  path[8] += i;
  a5:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ac:	00 
  ad:	89 c2                	mov    %eax,%edx
  af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c6:	00 
  c7:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 a3 03 00 00       	call   479 <open>
  d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e4:	00 00 00 00 
  e8:	eb 27                	jmp    111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f1:	00 
  f2:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 101:	89 04 24             	mov    %eax,(%esp)
 104:	e8 50 03 00 00       	call   459 <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 110:	01 
 111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 118:	13 
 119:	7e cf                	jle    ea <main+0xea>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 122:	89 04 24             	mov    %eax,(%esp)
 125:	e8 37 03 00 00       	call   461 <close>

  printf(1, "read\n");
 12a:	c7 44 24 04 ca 09 00 	movl   $0x9ca,0x4(%esp)
 131:	00 
 132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 139:	e8 a3 04 00 00       	call   5e1 <printf>

  fd = open(path, O_RDONLY);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14d:	89 04 24             	mov    %eax,(%esp)
 150:	e8 24 03 00 00       	call   479 <open>
 155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 163:	00 00 00 00 
 167:	eb 27                	jmp    190 <main+0x190>
    read(fd, data, sizeof(data));
 169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 170:	00 
 171:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 175:	89 44 24 04          	mov    %eax,0x4(%esp)
 179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 180:	89 04 24             	mov    %eax,(%esp)
 183:	e8 c9 02 00 00       	call   451 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 18f:	01 
 190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 197:	13 
 198:	7e cf                	jle    169 <main+0x169>
    read(fd, data, sizeof(data));
  close(fd);
 19a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 b8 02 00 00       	call   461 <close>

  wait(0);
 1a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b0:	e8 7c 02 00 00       	call   431 <wait>
  
  exit(0);
 1b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bc:	e8 68 02 00 00       	call   429 <exit>

000001c1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c1:	55                   	push   %ebp
 1c2:	89 e5                	mov    %esp,%ebp
 1c4:	57                   	push   %edi
 1c5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c9:	8b 55 10             	mov    0x10(%ebp),%edx
 1cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cf:	89 cb                	mov    %ecx,%ebx
 1d1:	89 df                	mov    %ebx,%edi
 1d3:	89 d1                	mov    %edx,%ecx
 1d5:	fc                   	cld    
 1d6:	f3 aa                	rep stos %al,%es:(%edi)
 1d8:	89 ca                	mov    %ecx,%edx
 1da:	89 fb                	mov    %edi,%ebx
 1dc:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1df:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e2:	5b                   	pop    %ebx
 1e3:	5f                   	pop    %edi
 1e4:	5d                   	pop    %ebp
 1e5:	c3                   	ret    

000001e6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e6:	55                   	push   %ebp
 1e7:	89 e5                	mov    %esp,%ebp
 1e9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f2:	90                   	nop
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	8d 50 01             	lea    0x1(%eax),%edx
 1f9:	89 55 08             	mov    %edx,0x8(%ebp)
 1fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ff:	8d 4a 01             	lea    0x1(%edx),%ecx
 202:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 205:	0f b6 12             	movzbl (%edx),%edx
 208:	88 10                	mov    %dl,(%eax)
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strcpy+0xd>
    ;
  return os;
 211:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 214:	c9                   	leave  
 215:	c3                   	ret    

00000216 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 216:	55                   	push   %ebp
 217:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 219:	eb 08                	jmp    223 <strcmp+0xd>
    p++, q++;
 21b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	74 10                	je     23d <strcmp+0x27>
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 10             	movzbl (%eax),%edx
 233:	8b 45 0c             	mov    0xc(%ebp),%eax
 236:	0f b6 00             	movzbl (%eax),%eax
 239:	38 c2                	cmp    %al,%dl
 23b:	74 de                	je     21b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	0f b6 d0             	movzbl %al,%edx
 246:	8b 45 0c             	mov    0xc(%ebp),%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	0f b6 c0             	movzbl %al,%eax
 24f:	29 c2                	sub    %eax,%edx
 251:	89 d0                	mov    %edx,%eax
}
 253:	5d                   	pop    %ebp
 254:	c3                   	ret    

00000255 <strlen>:

uint
strlen(char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 262:	eb 04                	jmp    268 <strlen+0x13>
 264:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 268:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	01 d0                	add    %edx,%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	84 c0                	test   %al,%al
 275:	75 ed                	jne    264 <strlen+0xf>
    ;
  return n;
 277:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27a:	c9                   	leave  
 27b:	c3                   	ret    

0000027c <memset>:

void*
memset(void *dst, int c, uint n)
{
 27c:	55                   	push   %ebp
 27d:	89 e5                	mov    %esp,%ebp
 27f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 282:	8b 45 10             	mov    0x10(%ebp),%eax
 285:	89 44 24 08          	mov    %eax,0x8(%esp)
 289:	8b 45 0c             	mov    0xc(%ebp),%eax
 28c:	89 44 24 04          	mov    %eax,0x4(%esp)
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	89 04 24             	mov    %eax,(%esp)
 296:	e8 26 ff ff ff       	call   1c1 <stosb>
  return dst;
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29e:	c9                   	leave  
 29f:	c3                   	ret    

000002a0 <strchr>:

char*
strchr(const char *s, char c)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 04             	sub    $0x4,%esp
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ac:	eb 14                	jmp    2c2 <strchr+0x22>
    if(*s == c)
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b7:	75 05                	jne    2be <strchr+0x1e>
      return (char*)s;
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	eb 13                	jmp    2d1 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2be:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	0f b6 00             	movzbl (%eax),%eax
 2c8:	84 c0                	test   %al,%al
 2ca:	75 e2                	jne    2ae <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d1:	c9                   	leave  
 2d2:	c3                   	ret    

000002d3 <gets>:

char*
gets(char *buf, int max)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2e0:	eb 4c                	jmp    32e <gets+0x5b>
    cc = read(0, &c, 1);
 2e2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e9:	00 
 2ea:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f8:	e8 54 01 00 00       	call   451 <read>
 2fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 300:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 304:	7f 02                	jg     308 <gets+0x35>
      break;
 306:	eb 31                	jmp    339 <gets+0x66>
    buf[i++] = c;
 308:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30b:	8d 50 01             	lea    0x1(%eax),%edx
 30e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 311:	89 c2                	mov    %eax,%edx
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	01 c2                	add    %eax,%edx
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 31e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 322:	3c 0a                	cmp    $0xa,%al
 324:	74 13                	je     339 <gets+0x66>
 326:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32a:	3c 0d                	cmp    $0xd,%al
 32c:	74 0b                	je     339 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 331:	83 c0 01             	add    $0x1,%eax
 334:	3b 45 0c             	cmp    0xc(%ebp),%eax
 337:	7c a9                	jl     2e2 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 339:	8b 55 f4             	mov    -0xc(%ebp),%edx
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	01 d0                	add    %edx,%eax
 341:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <stat>:

int
stat(char *n, struct stat *st)
{
 349:	55                   	push   %ebp
 34a:	89 e5                	mov    %esp,%ebp
 34c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 356:	00 
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 04 24             	mov    %eax,(%esp)
 35d:	e8 17 01 00 00       	call   479 <open>
 362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 369:	79 07                	jns    372 <stat+0x29>
    return -1;
 36b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 370:	eb 23                	jmp    395 <stat+0x4c>
  r = fstat(fd, st);
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	89 44 24 04          	mov    %eax,0x4(%esp)
 379:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 0d 01 00 00       	call   491 <fstat>
 384:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 387:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38a:	89 04 24             	mov    %eax,(%esp)
 38d:	e8 cf 00 00 00       	call   461 <close>
  return r;
 392:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <atoi>:

int
atoi(const char *s)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 39d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a4:	eb 25                	jmp    3cb <atoi+0x34>
    n = n*10 + *s++ - '0';
 3a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a9:	89 d0                	mov    %edx,%eax
 3ab:	c1 e0 02             	shl    $0x2,%eax
 3ae:	01 d0                	add    %edx,%eax
 3b0:	01 c0                	add    %eax,%eax
 3b2:	89 c1                	mov    %eax,%ecx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	8d 50 01             	lea    0x1(%eax),%edx
 3ba:	89 55 08             	mov    %edx,0x8(%ebp)
 3bd:	0f b6 00             	movzbl (%eax),%eax
 3c0:	0f be c0             	movsbl %al,%eax
 3c3:	01 c8                	add    %ecx,%eax
 3c5:	83 e8 30             	sub    $0x30,%eax
 3c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	0f b6 00             	movzbl (%eax),%eax
 3d1:	3c 2f                	cmp    $0x2f,%al
 3d3:	7e 0a                	jle    3df <atoi+0x48>
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	0f b6 00             	movzbl (%eax),%eax
 3db:	3c 39                	cmp    $0x39,%al
 3dd:	7e c7                	jle    3a6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e2:	c9                   	leave  
 3e3:	c3                   	ret    

000003e4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f6:	eb 17                	jmp    40f <memmove+0x2b>
    *dst++ = *src++;
 3f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fb:	8d 50 01             	lea    0x1(%eax),%edx
 3fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
 401:	8b 55 f8             	mov    -0x8(%ebp),%edx
 404:	8d 4a 01             	lea    0x1(%edx),%ecx
 407:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 40a:	0f b6 12             	movzbl (%edx),%edx
 40d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 40f:	8b 45 10             	mov    0x10(%ebp),%eax
 412:	8d 50 ff             	lea    -0x1(%eax),%edx
 415:	89 55 10             	mov    %edx,0x10(%ebp)
 418:	85 c0                	test   %eax,%eax
 41a:	7f dc                	jg     3f8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41f:	c9                   	leave  
 420:	c3                   	ret    

00000421 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 421:	b8 01 00 00 00       	mov    $0x1,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <exit>:
SYSCALL(exit)
 429:	b8 02 00 00 00       	mov    $0x2,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <wait>:
SYSCALL(wait)
 431:	b8 03 00 00 00       	mov    $0x3,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <waitpid>:
SYSCALL(waitpid)
 439:	b8 16 00 00 00       	mov    $0x16,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <wait_stat>:
SYSCALL(wait_stat)
 441:	b8 17 00 00 00       	mov    $0x17,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <pipe>:
SYSCALL(pipe)
 449:	b8 04 00 00 00       	mov    $0x4,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <read>:
SYSCALL(read)
 451:	b8 05 00 00 00       	mov    $0x5,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <write>:
SYSCALL(write)
 459:	b8 10 00 00 00       	mov    $0x10,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <close>:
SYSCALL(close)
 461:	b8 15 00 00 00       	mov    $0x15,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <kill>:
SYSCALL(kill)
 469:	b8 06 00 00 00       	mov    $0x6,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <exec>:
SYSCALL(exec)
 471:	b8 07 00 00 00       	mov    $0x7,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <open>:
SYSCALL(open)
 479:	b8 0f 00 00 00       	mov    $0xf,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <mknod>:
SYSCALL(mknod)
 481:	b8 11 00 00 00       	mov    $0x11,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <unlink>:
SYSCALL(unlink)
 489:	b8 12 00 00 00       	mov    $0x12,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <fstat>:
SYSCALL(fstat)
 491:	b8 08 00 00 00       	mov    $0x8,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <link>:
SYSCALL(link)
 499:	b8 13 00 00 00       	mov    $0x13,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <mkdir>:
SYSCALL(mkdir)
 4a1:	b8 14 00 00 00       	mov    $0x14,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <chdir>:
SYSCALL(chdir)
 4a9:	b8 09 00 00 00       	mov    $0x9,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <dup>:
SYSCALL(dup)
 4b1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <getpid>:
SYSCALL(getpid)
 4b9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <sbrk>:
SYSCALL(sbrk)
 4c1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <set_priority>:
SYSCALL(set_priority)
 4c9:	b8 18 00 00 00       	mov    $0x18,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <canRemoveJob>:
SYSCALL(canRemoveJob)
 4d1:	b8 19 00 00 00       	mov    $0x19,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <jobs>:
SYSCALL(jobs)
 4d9:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <sleep>:
SYSCALL(sleep)
 4e1:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <uptime>:
SYSCALL(uptime)
 4e9:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <gidpid>:
SYSCALL(gidpid)
 4f1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <isShell>:
SYSCALL(isShell)
 4f9:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 501:	55                   	push   %ebp
 502:	89 e5                	mov    %esp,%ebp
 504:	83 ec 18             	sub    $0x18,%esp
 507:	8b 45 0c             	mov    0xc(%ebp),%eax
 50a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 50d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 514:	00 
 515:	8d 45 f4             	lea    -0xc(%ebp),%eax
 518:	89 44 24 04          	mov    %eax,0x4(%esp)
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	89 04 24             	mov    %eax,(%esp)
 522:	e8 32 ff ff ff       	call   459 <write>
}
 527:	c9                   	leave  
 528:	c3                   	ret    

00000529 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 529:	55                   	push   %ebp
 52a:	89 e5                	mov    %esp,%ebp
 52c:	56                   	push   %esi
 52d:	53                   	push   %ebx
 52e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 531:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 538:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 53c:	74 17                	je     555 <printint+0x2c>
 53e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 542:	79 11                	jns    555 <printint+0x2c>
    neg = 1;
 544:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 54b:	8b 45 0c             	mov    0xc(%ebp),%eax
 54e:	f7 d8                	neg    %eax
 550:	89 45 ec             	mov    %eax,-0x14(%ebp)
 553:	eb 06                	jmp    55b <printint+0x32>
  } else {
    x = xx;
 555:	8b 45 0c             	mov    0xc(%ebp),%eax
 558:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 55b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 562:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 565:	8d 41 01             	lea    0x1(%ecx),%eax
 568:	89 45 f4             	mov    %eax,-0xc(%ebp)
 56b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 56e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 571:	ba 00 00 00 00       	mov    $0x0,%edx
 576:	f7 f3                	div    %ebx
 578:	89 d0                	mov    %edx,%eax
 57a:	0f b6 80 1c 0c 00 00 	movzbl 0xc1c(%eax),%eax
 581:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 585:	8b 75 10             	mov    0x10(%ebp),%esi
 588:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58b:	ba 00 00 00 00       	mov    $0x0,%edx
 590:	f7 f6                	div    %esi
 592:	89 45 ec             	mov    %eax,-0x14(%ebp)
 595:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 599:	75 c7                	jne    562 <printint+0x39>
  if(neg)
 59b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 59f:	74 10                	je     5b1 <printint+0x88>
    buf[i++] = '-';
 5a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a4:	8d 50 01             	lea    0x1(%eax),%edx
 5a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5aa:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5af:	eb 1f                	jmp    5d0 <printint+0xa7>
 5b1:	eb 1d                	jmp    5d0 <printint+0xa7>
    putc(fd, buf[i]);
 5b3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b9:	01 d0                	add    %edx,%eax
 5bb:	0f b6 00             	movzbl (%eax),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	89 04 24             	mov    %eax,(%esp)
 5cb:	e8 31 ff ff ff       	call   501 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5d0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d8:	79 d9                	jns    5b3 <printint+0x8a>
    putc(fd, buf[i]);
}
 5da:	83 c4 30             	add    $0x30,%esp
 5dd:	5b                   	pop    %ebx
 5de:	5e                   	pop    %esi
 5df:	5d                   	pop    %ebp
 5e0:	c3                   	ret    

000005e1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5e1:	55                   	push   %ebp
 5e2:	89 e5                	mov    %esp,%ebp
 5e4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ee:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f1:	83 c0 04             	add    $0x4,%eax
 5f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5fe:	e9 7c 01 00 00       	jmp    77f <printf+0x19e>
    c = fmt[i] & 0xff;
 603:	8b 55 0c             	mov    0xc(%ebp),%edx
 606:	8b 45 f0             	mov    -0x10(%ebp),%eax
 609:	01 d0                	add    %edx,%eax
 60b:	0f b6 00             	movzbl (%eax),%eax
 60e:	0f be c0             	movsbl %al,%eax
 611:	25 ff 00 00 00       	and    $0xff,%eax
 616:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 619:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 61d:	75 2c                	jne    64b <printf+0x6a>
      if(c == '%'){
 61f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 623:	75 0c                	jne    631 <printf+0x50>
        state = '%';
 625:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 62c:	e9 4a 01 00 00       	jmp    77b <printf+0x19a>
      } else {
        putc(fd, c);
 631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 634:	0f be c0             	movsbl %al,%eax
 637:	89 44 24 04          	mov    %eax,0x4(%esp)
 63b:	8b 45 08             	mov    0x8(%ebp),%eax
 63e:	89 04 24             	mov    %eax,(%esp)
 641:	e8 bb fe ff ff       	call   501 <putc>
 646:	e9 30 01 00 00       	jmp    77b <printf+0x19a>
      }
    } else if(state == '%'){
 64b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 64f:	0f 85 26 01 00 00    	jne    77b <printf+0x19a>
      if(c == 'd'){
 655:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 659:	75 2d                	jne    688 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 65b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65e:	8b 00                	mov    (%eax),%eax
 660:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 667:	00 
 668:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 66f:	00 
 670:	89 44 24 04          	mov    %eax,0x4(%esp)
 674:	8b 45 08             	mov    0x8(%ebp),%eax
 677:	89 04 24             	mov    %eax,(%esp)
 67a:	e8 aa fe ff ff       	call   529 <printint>
        ap++;
 67f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 683:	e9 ec 00 00 00       	jmp    774 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 688:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 68c:	74 06                	je     694 <printf+0xb3>
 68e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 692:	75 2d                	jne    6c1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 694:	8b 45 e8             	mov    -0x18(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6a0:	00 
 6a1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6a8:	00 
 6a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ad:	8b 45 08             	mov    0x8(%ebp),%eax
 6b0:	89 04 24             	mov    %eax,(%esp)
 6b3:	e8 71 fe ff ff       	call   529 <printint>
        ap++;
 6b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6bc:	e9 b3 00 00 00       	jmp    774 <printf+0x193>
      } else if(c == 's'){
 6c1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6c5:	75 45                	jne    70c <printf+0x12b>
        s = (char*)*ap;
 6c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d7:	75 09                	jne    6e2 <printf+0x101>
          s = "(null)";
 6d9:	c7 45 f4 d0 09 00 00 	movl   $0x9d0,-0xc(%ebp)
        while(*s != 0){
 6e0:	eb 1e                	jmp    700 <printf+0x11f>
 6e2:	eb 1c                	jmp    700 <printf+0x11f>
          putc(fd, *s);
 6e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e7:	0f b6 00             	movzbl (%eax),%eax
 6ea:	0f be c0             	movsbl %al,%eax
 6ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	89 04 24             	mov    %eax,(%esp)
 6f7:	e8 05 fe ff ff       	call   501 <putc>
          s++;
 6fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 700:	8b 45 f4             	mov    -0xc(%ebp),%eax
 703:	0f b6 00             	movzbl (%eax),%eax
 706:	84 c0                	test   %al,%al
 708:	75 da                	jne    6e4 <printf+0x103>
 70a:	eb 68                	jmp    774 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 70c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 710:	75 1d                	jne    72f <printf+0x14e>
        putc(fd, *ap);
 712:	8b 45 e8             	mov    -0x18(%ebp),%eax
 715:	8b 00                	mov    (%eax),%eax
 717:	0f be c0             	movsbl %al,%eax
 71a:	89 44 24 04          	mov    %eax,0x4(%esp)
 71e:	8b 45 08             	mov    0x8(%ebp),%eax
 721:	89 04 24             	mov    %eax,(%esp)
 724:	e8 d8 fd ff ff       	call   501 <putc>
        ap++;
 729:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72d:	eb 45                	jmp    774 <printf+0x193>
      } else if(c == '%'){
 72f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 733:	75 17                	jne    74c <printf+0x16b>
        putc(fd, c);
 735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 738:	0f be c0             	movsbl %al,%eax
 73b:	89 44 24 04          	mov    %eax,0x4(%esp)
 73f:	8b 45 08             	mov    0x8(%ebp),%eax
 742:	89 04 24             	mov    %eax,(%esp)
 745:	e8 b7 fd ff ff       	call   501 <putc>
 74a:	eb 28                	jmp    774 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 74c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 753:	00 
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	89 04 24             	mov    %eax,(%esp)
 75a:	e8 a2 fd ff ff       	call   501 <putc>
        putc(fd, c);
 75f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 762:	0f be c0             	movsbl %al,%eax
 765:	89 44 24 04          	mov    %eax,0x4(%esp)
 769:	8b 45 08             	mov    0x8(%ebp),%eax
 76c:	89 04 24             	mov    %eax,(%esp)
 76f:	e8 8d fd ff ff       	call   501 <putc>
      }
      state = 0;
 774:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 77b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 77f:	8b 55 0c             	mov    0xc(%ebp),%edx
 782:	8b 45 f0             	mov    -0x10(%ebp),%eax
 785:	01 d0                	add    %edx,%eax
 787:	0f b6 00             	movzbl (%eax),%eax
 78a:	84 c0                	test   %al,%al
 78c:	0f 85 71 fe ff ff    	jne    603 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 792:	c9                   	leave  
 793:	c3                   	ret    

00000794 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 794:	55                   	push   %ebp
 795:	89 e5                	mov    %esp,%ebp
 797:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79a:	8b 45 08             	mov    0x8(%ebp),%eax
 79d:	83 e8 08             	sub    $0x8,%eax
 7a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a3:	a1 38 0c 00 00       	mov    0xc38,%eax
 7a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ab:	eb 24                	jmp    7d1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b5:	77 12                	ja     7c9 <free+0x35>
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bd:	77 24                	ja     7e3 <free+0x4f>
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	8b 00                	mov    (%eax),%eax
 7c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c7:	77 1a                	ja     7e3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d7:	76 d4                	jbe    7ad <free+0x19>
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e1:	76 ca                	jbe    7ad <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	8b 40 04             	mov    0x4(%eax),%eax
 7e9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f3:	01 c2                	add    %eax,%edx
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	8b 00                	mov    (%eax),%eax
 7fa:	39 c2                	cmp    %eax,%edx
 7fc:	75 24                	jne    822 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 801:	8b 50 04             	mov    0x4(%eax),%edx
 804:	8b 45 fc             	mov    -0x4(%ebp),%eax
 807:	8b 00                	mov    (%eax),%eax
 809:	8b 40 04             	mov    0x4(%eax),%eax
 80c:	01 c2                	add    %eax,%edx
 80e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 811:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 814:	8b 45 fc             	mov    -0x4(%ebp),%eax
 817:	8b 00                	mov    (%eax),%eax
 819:	8b 10                	mov    (%eax),%edx
 81b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81e:	89 10                	mov    %edx,(%eax)
 820:	eb 0a                	jmp    82c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 822:	8b 45 fc             	mov    -0x4(%ebp),%eax
 825:	8b 10                	mov    (%eax),%edx
 827:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 82c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82f:	8b 40 04             	mov    0x4(%eax),%eax
 832:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	01 d0                	add    %edx,%eax
 83e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 841:	75 20                	jne    863 <free+0xcf>
    p->s.size += bp->s.size;
 843:	8b 45 fc             	mov    -0x4(%ebp),%eax
 846:	8b 50 04             	mov    0x4(%eax),%edx
 849:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84c:	8b 40 04             	mov    0x4(%eax),%eax
 84f:	01 c2                	add    %eax,%edx
 851:	8b 45 fc             	mov    -0x4(%ebp),%eax
 854:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 857:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85a:	8b 10                	mov    (%eax),%edx
 85c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85f:	89 10                	mov    %edx,(%eax)
 861:	eb 08                	jmp    86b <free+0xd7>
  } else
    p->s.ptr = bp;
 863:	8b 45 fc             	mov    -0x4(%ebp),%eax
 866:	8b 55 f8             	mov    -0x8(%ebp),%edx
 869:	89 10                	mov    %edx,(%eax)
  freep = p;
 86b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86e:	a3 38 0c 00 00       	mov    %eax,0xc38
}
 873:	c9                   	leave  
 874:	c3                   	ret    

00000875 <morecore>:

static Header*
morecore(uint nu)
{
 875:	55                   	push   %ebp
 876:	89 e5                	mov    %esp,%ebp
 878:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 87b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 882:	77 07                	ja     88b <morecore+0x16>
    nu = 4096;
 884:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 88b:	8b 45 08             	mov    0x8(%ebp),%eax
 88e:	c1 e0 03             	shl    $0x3,%eax
 891:	89 04 24             	mov    %eax,(%esp)
 894:	e8 28 fc ff ff       	call   4c1 <sbrk>
 899:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 89c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8a0:	75 07                	jne    8a9 <morecore+0x34>
    return 0;
 8a2:	b8 00 00 00 00       	mov    $0x0,%eax
 8a7:	eb 22                	jmp    8cb <morecore+0x56>
  hp = (Header*)p;
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b2:	8b 55 08             	mov    0x8(%ebp),%edx
 8b5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bb:	83 c0 08             	add    $0x8,%eax
 8be:	89 04 24             	mov    %eax,(%esp)
 8c1:	e8 ce fe ff ff       	call   794 <free>
  return freep;
 8c6:	a1 38 0c 00 00       	mov    0xc38,%eax
}
 8cb:	c9                   	leave  
 8cc:	c3                   	ret    

000008cd <malloc>:

void*
malloc(uint nbytes)
{
 8cd:	55                   	push   %ebp
 8ce:	89 e5                	mov    %esp,%ebp
 8d0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d3:	8b 45 08             	mov    0x8(%ebp),%eax
 8d6:	83 c0 07             	add    $0x7,%eax
 8d9:	c1 e8 03             	shr    $0x3,%eax
 8dc:	83 c0 01             	add    $0x1,%eax
 8df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8e2:	a1 38 0c 00 00       	mov    0xc38,%eax
 8e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ee:	75 23                	jne    913 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8f0:	c7 45 f0 30 0c 00 00 	movl   $0xc30,-0x10(%ebp)
 8f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fa:	a3 38 0c 00 00       	mov    %eax,0xc38
 8ff:	a1 38 0c 00 00       	mov    0xc38,%eax
 904:	a3 30 0c 00 00       	mov    %eax,0xc30
    base.s.size = 0;
 909:	c7 05 34 0c 00 00 00 	movl   $0x0,0xc34
 910:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 913:	8b 45 f0             	mov    -0x10(%ebp),%eax
 916:	8b 00                	mov    (%eax),%eax
 918:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 91b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91e:	8b 40 04             	mov    0x4(%eax),%eax
 921:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 924:	72 4d                	jb     973 <malloc+0xa6>
      if(p->s.size == nunits)
 926:	8b 45 f4             	mov    -0xc(%ebp),%eax
 929:	8b 40 04             	mov    0x4(%eax),%eax
 92c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 92f:	75 0c                	jne    93d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	8b 10                	mov    (%eax),%edx
 936:	8b 45 f0             	mov    -0x10(%ebp),%eax
 939:	89 10                	mov    %edx,(%eax)
 93b:	eb 26                	jmp    963 <malloc+0x96>
      else {
        p->s.size -= nunits;
 93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 940:	8b 40 04             	mov    0x4(%eax),%eax
 943:	2b 45 ec             	sub    -0x14(%ebp),%eax
 946:	89 c2                	mov    %eax,%edx
 948:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 94e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 951:	8b 40 04             	mov    0x4(%eax),%eax
 954:	c1 e0 03             	shl    $0x3,%eax
 957:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 95a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 960:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 963:	8b 45 f0             	mov    -0x10(%ebp),%eax
 966:	a3 38 0c 00 00       	mov    %eax,0xc38
      return (void*)(p + 1);
 96b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96e:	83 c0 08             	add    $0x8,%eax
 971:	eb 38                	jmp    9ab <malloc+0xde>
    }
    if(p == freep)
 973:	a1 38 0c 00 00       	mov    0xc38,%eax
 978:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 97b:	75 1b                	jne    998 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 97d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 980:	89 04 24             	mov    %eax,(%esp)
 983:	e8 ed fe ff ff       	call   875 <morecore>
 988:	89 45 f4             	mov    %eax,-0xc(%ebp)
 98b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 98f:	75 07                	jne    998 <malloc+0xcb>
        return 0;
 991:	b8 00 00 00 00       	mov    $0x0,%eax
 996:	eb 13                	jmp    9ab <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 99e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a1:	8b 00                	mov    (%eax),%eax
 9a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9a6:	e9 70 ff ff ff       	jmp    91b <malloc+0x4e>
}
 9ab:	c9                   	leave  
 9ac:	c3                   	ret    
