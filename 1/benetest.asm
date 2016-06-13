
_benetest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"


int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 60             	sub    $0x60,%esp
}
else
{
printf(1, "FAILED\n");
}*/
if (fork()) {
   9:	e8 4a 03 00 00       	call   358 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	74 74                	je     86 <main+0x86>
	int i,j;
	for(j=0;j<20;j++){
  12:	c7 44 24 58 00 00 00 	movl   $0x0,0x58(%esp)
  19:	00 
  1a:	eb 55                	jmp    71 <main+0x71>
		for (i=0;i<10000000;i++){
  1c:	c7 44 24 5c 00 00 00 	movl   $0x0,0x5c(%esp)
  23:	00 
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	83 44 24 5c 01       	addl   $0x1,0x5c(%esp)
  2b:	81 7c 24 5c 7f 96 98 	cmpl   $0x98967f,0x5c(%esp)
  32:	00 
  33:	7e f1                	jle    26 <main+0x26>
		
		}
		printf(1,"1");
  35:	c7 44 24 04 e4 08 00 	movl   $0x8e4,0x4(%esp)
  3c:	00 
  3d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  44:	e8 cf 04 00 00       	call   518 <printf>
		char buf[50];
		if (j==10) read(0,buf,5);
  49:	83 7c 24 58 0a       	cmpl   $0xa,0x58(%esp)
  4e:	75 1c                	jne    6c <main+0x6c>
  50:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  57:	00 
  58:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  67:	e8 1c 03 00 00       	call   388 <read>
{
printf(1, "FAILED\n");
}*/
if (fork()) {
	int i,j;
	for(j=0;j<20;j++){
  6c:	83 44 24 58 01       	addl   $0x1,0x58(%esp)
  71:	83 7c 24 58 13       	cmpl   $0x13,0x58(%esp)
  76:	7e a4                	jle    1c <main+0x1c>
		}
		printf(1,"1");
		char buf[50];
		if (j==10) read(0,buf,5);
	}
wait(0);
  78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7f:	e8 e4 02 00 00       	call   368 <wait>
  84:	eb 66                	jmp    ec <main+0xec>
}
else {
	int i,j;
	for(j=0;j<20;j++){
  86:	c7 44 24 50 00 00 00 	movl   $0x0,0x50(%esp)
  8d:	00 
  8e:	eb 55                	jmp    e5 <main+0xe5>
		for (i=0;i<10000000;i++){
  90:	c7 44 24 54 00 00 00 	movl   $0x0,0x54(%esp)
  97:	00 
  98:	eb 05                	jmp    9f <main+0x9f>
  9a:	83 44 24 54 01       	addl   $0x1,0x54(%esp)
  9f:	81 7c 24 54 7f 96 98 	cmpl   $0x98967f,0x54(%esp)
  a6:	00 
  a7:	7e f1                	jle    9a <main+0x9a>
		
		}
		printf(1,"2");
  a9:	c7 44 24 04 e6 08 00 	movl   $0x8e6,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 5b 04 00 00       	call   518 <printf>
		char buf[50];
		if (j==10) read(0,buf,5);
  bd:	83 7c 24 50 0a       	cmpl   $0xa,0x50(%esp)
  c2:	75 1c                	jne    e0 <main+0xe0>
  c4:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  cb:	00 
  cc:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  db:	e8 a8 02 00 00       	call   388 <read>
	}
wait(0);
}
else {
	int i,j;
	for(j=0;j<20;j++){
  e0:	83 44 24 50 01       	addl   $0x1,0x50(%esp)
  e5:	83 7c 24 50 13       	cmpl   $0x13,0x50(%esp)
  ea:	7e a4                	jle    90 <main+0x90>
		printf(1,"2");
		char buf[50];
		if (j==10) read(0,buf,5);
	}
}
exit(0);
  ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  f3:	e8 68 02 00 00       	call   360 <exit>

000000f8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	57                   	push   %edi
  fc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 100:	8b 55 10             	mov    0x10(%ebp),%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	89 cb                	mov    %ecx,%ebx
 108:	89 df                	mov    %ebx,%edi
 10a:	89 d1                	mov    %edx,%ecx
 10c:	fc                   	cld    
 10d:	f3 aa                	rep stos %al,%es:(%edi)
 10f:	89 ca                	mov    %ecx,%edx
 111:	89 fb                	mov    %edi,%ebx
 113:	89 5d 08             	mov    %ebx,0x8(%ebp)
 116:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 119:	5b                   	pop    %ebx
 11a:	5f                   	pop    %edi
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    

0000011d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 129:	90                   	nop
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	8d 50 01             	lea    0x1(%eax),%edx
 130:	89 55 08             	mov    %edx,0x8(%ebp)
 133:	8b 55 0c             	mov    0xc(%ebp),%edx
 136:	8d 4a 01             	lea    0x1(%edx),%ecx
 139:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 13c:	0f b6 12             	movzbl (%edx),%edx
 13f:	88 10                	mov    %dl,(%eax)
 141:	0f b6 00             	movzbl (%eax),%eax
 144:	84 c0                	test   %al,%al
 146:	75 e2                	jne    12a <strcpy+0xd>
    ;
  return os;
 148:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14b:	c9                   	leave  
 14c:	c3                   	ret    

0000014d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14d:	55                   	push   %ebp
 14e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 150:	eb 08                	jmp    15a <strcmp+0xd>
    p++, q++;
 152:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 156:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	0f b6 00             	movzbl (%eax),%eax
 160:	84 c0                	test   %al,%al
 162:	74 10                	je     174 <strcmp+0x27>
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 10             	movzbl (%eax),%edx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	38 c2                	cmp    %al,%dl
 172:	74 de                	je     152 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	0f b6 d0             	movzbl %al,%edx
 17d:	8b 45 0c             	mov    0xc(%ebp),%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	0f b6 c0             	movzbl %al,%eax
 186:	29 c2                	sub    %eax,%edx
 188:	89 d0                	mov    %edx,%eax
}
 18a:	5d                   	pop    %ebp
 18b:	c3                   	ret    

0000018c <strlen>:

uint
strlen(char *s)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 192:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 199:	eb 04                	jmp    19f <strlen+0x13>
 19b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 19f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	01 d0                	add    %edx,%eax
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	84 c0                	test   %al,%al
 1ac:	75 ed                	jne    19b <strlen+0xf>
    ;
  return n;
 1ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b1:	c9                   	leave  
 1b2:	c3                   	ret    

000001b3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1b9:	8b 45 10             	mov    0x10(%ebp),%eax
 1bc:	89 44 24 08          	mov    %eax,0x8(%esp)
 1c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	89 04 24             	mov    %eax,(%esp)
 1cd:	e8 26 ff ff ff       	call   f8 <stosb>
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <strchr>:

char*
strchr(const char *s, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 14                	jmp    1f9 <strchr+0x22>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ee:	75 05                	jne    1f5 <strchr+0x1e>
      return (char*)s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	eb 13                	jmp    208 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 4c                	jmp    265 <gets+0x5b>
    cc = read(0, &c, 1);
 219:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 220:	00 
 221:	8d 45 ef             	lea    -0x11(%ebp),%eax
 224:	89 44 24 04          	mov    %eax,0x4(%esp)
 228:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 22f:	e8 54 01 00 00       	call   388 <read>
 234:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 23b:	7f 02                	jg     23f <gets+0x35>
      break;
 23d:	eb 31                	jmp    270 <gets+0x66>
    buf[i++] = c;
 23f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 242:	8d 50 01             	lea    0x1(%eax),%edx
 245:	89 55 f4             	mov    %edx,-0xc(%ebp)
 248:	89 c2                	mov    %eax,%edx
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	01 c2                	add    %eax,%edx
 24f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 253:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 255:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 259:	3c 0a                	cmp    $0xa,%al
 25b:	74 13                	je     270 <gets+0x66>
 25d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 261:	3c 0d                	cmp    $0xd,%al
 263:	74 0b                	je     270 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 265:	8b 45 f4             	mov    -0xc(%ebp),%eax
 268:	83 c0 01             	add    $0x1,%eax
 26b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 26e:	7c a9                	jl     219 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 270:	8b 55 f4             	mov    -0xc(%ebp),%edx
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	01 d0                	add    %edx,%eax
 278:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27e:	c9                   	leave  
 27f:	c3                   	ret    

00000280 <stat>:

int
stat(char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 286:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 28d:	00 
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	89 04 24             	mov    %eax,(%esp)
 294:	e8 17 01 00 00       	call   3b0 <open>
 299:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 29c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a0:	79 07                	jns    2a9 <stat+0x29>
    return -1;
 2a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a7:	eb 23                	jmp    2cc <stat+0x4c>
  r = fstat(fd, st);
 2a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b3:	89 04 24             	mov    %eax,(%esp)
 2b6:	e8 0d 01 00 00       	call   3c8 <fstat>
 2bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c1:	89 04 24             	mov    %eax,(%esp)
 2c4:	e8 cf 00 00 00       	call   398 <close>
  return r;
 2c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2cc:	c9                   	leave  
 2cd:	c3                   	ret    

000002ce <atoi>:

int
atoi(const char *s)
{
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2db:	eb 25                	jmp    302 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e0:	89 d0                	mov    %edx,%eax
 2e2:	c1 e0 02             	shl    $0x2,%eax
 2e5:	01 d0                	add    %edx,%eax
 2e7:	01 c0                	add    %eax,%eax
 2e9:	89 c1                	mov    %eax,%ecx
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	8d 50 01             	lea    0x1(%eax),%edx
 2f1:	89 55 08             	mov    %edx,0x8(%ebp)
 2f4:	0f b6 00             	movzbl (%eax),%eax
 2f7:	0f be c0             	movsbl %al,%eax
 2fa:	01 c8                	add    %ecx,%eax
 2fc:	83 e8 30             	sub    $0x30,%eax
 2ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	0f b6 00             	movzbl (%eax),%eax
 308:	3c 2f                	cmp    $0x2f,%al
 30a:	7e 0a                	jle    316 <atoi+0x48>
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	0f b6 00             	movzbl (%eax),%eax
 312:	3c 39                	cmp    $0x39,%al
 314:	7e c7                	jle    2dd <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 319:	c9                   	leave  
 31a:	c3                   	ret    

0000031b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 31b:	55                   	push   %ebp
 31c:	89 e5                	mov    %esp,%ebp
 31e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 327:	8b 45 0c             	mov    0xc(%ebp),%eax
 32a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 32d:	eb 17                	jmp    346 <memmove+0x2b>
    *dst++ = *src++;
 32f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 332:	8d 50 01             	lea    0x1(%eax),%edx
 335:	89 55 fc             	mov    %edx,-0x4(%ebp)
 338:	8b 55 f8             	mov    -0x8(%ebp),%edx
 33b:	8d 4a 01             	lea    0x1(%edx),%ecx
 33e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 341:	0f b6 12             	movzbl (%edx),%edx
 344:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 346:	8b 45 10             	mov    0x10(%ebp),%eax
 349:	8d 50 ff             	lea    -0x1(%eax),%edx
 34c:	89 55 10             	mov    %edx,0x10(%ebp)
 34f:	85 c0                	test   %eax,%eax
 351:	7f dc                	jg     32f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 353:	8b 45 08             	mov    0x8(%ebp),%eax
}
 356:	c9                   	leave  
 357:	c3                   	ret    

00000358 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 358:	b8 01 00 00 00       	mov    $0x1,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <exit>:
SYSCALL(exit)
 360:	b8 02 00 00 00       	mov    $0x2,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <wait>:
SYSCALL(wait)
 368:	b8 03 00 00 00       	mov    $0x3,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <waitpid>:
SYSCALL(waitpid)
 370:	b8 16 00 00 00       	mov    $0x16,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <wait_stat>:
SYSCALL(wait_stat)
 378:	b8 17 00 00 00       	mov    $0x17,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <pipe>:
SYSCALL(pipe)
 380:	b8 04 00 00 00       	mov    $0x4,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <read>:
SYSCALL(read)
 388:	b8 05 00 00 00       	mov    $0x5,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <write>:
SYSCALL(write)
 390:	b8 10 00 00 00       	mov    $0x10,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <close>:
SYSCALL(close)
 398:	b8 15 00 00 00       	mov    $0x15,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <kill>:
SYSCALL(kill)
 3a0:	b8 06 00 00 00       	mov    $0x6,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <exec>:
SYSCALL(exec)
 3a8:	b8 07 00 00 00       	mov    $0x7,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <open>:
SYSCALL(open)
 3b0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <mknod>:
SYSCALL(mknod)
 3b8:	b8 11 00 00 00       	mov    $0x11,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <unlink>:
SYSCALL(unlink)
 3c0:	b8 12 00 00 00       	mov    $0x12,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <fstat>:
SYSCALL(fstat)
 3c8:	b8 08 00 00 00       	mov    $0x8,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <link>:
SYSCALL(link)
 3d0:	b8 13 00 00 00       	mov    $0x13,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <mkdir>:
SYSCALL(mkdir)
 3d8:	b8 14 00 00 00       	mov    $0x14,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <chdir>:
SYSCALL(chdir)
 3e0:	b8 09 00 00 00       	mov    $0x9,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <dup>:
SYSCALL(dup)
 3e8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <getpid>:
SYSCALL(getpid)
 3f0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <sbrk>:
SYSCALL(sbrk)
 3f8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <set_priority>:
SYSCALL(set_priority)
 400:	b8 18 00 00 00       	mov    $0x18,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <canRemoveJob>:
SYSCALL(canRemoveJob)
 408:	b8 19 00 00 00       	mov    $0x19,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <jobs>:
SYSCALL(jobs)
 410:	b8 1a 00 00 00       	mov    $0x1a,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sleep>:
SYSCALL(sleep)
 418:	b8 0d 00 00 00       	mov    $0xd,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <uptime>:
SYSCALL(uptime)
 420:	b8 0e 00 00 00       	mov    $0xe,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <gidpid>:
SYSCALL(gidpid)
 428:	b8 1b 00 00 00       	mov    $0x1b,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <isShell>:
SYSCALL(isShell)
 430:	b8 1c 00 00 00       	mov    $0x1c,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	83 ec 18             	sub    $0x18,%esp
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 444:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 44b:	00 
 44c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 44f:	89 44 24 04          	mov    %eax,0x4(%esp)
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	89 04 24             	mov    %eax,(%esp)
 459:	e8 32 ff ff ff       	call   390 <write>
}
 45e:	c9                   	leave  
 45f:	c3                   	ret    

00000460 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	56                   	push   %esi
 464:	53                   	push   %ebx
 465:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 468:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 46f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 473:	74 17                	je     48c <printint+0x2c>
 475:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 479:	79 11                	jns    48c <printint+0x2c>
    neg = 1;
 47b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 482:	8b 45 0c             	mov    0xc(%ebp),%eax
 485:	f7 d8                	neg    %eax
 487:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48a:	eb 06                	jmp    492 <printint+0x32>
  } else {
    x = xx;
 48c:	8b 45 0c             	mov    0xc(%ebp),%eax
 48f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 492:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 499:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 49c:	8d 41 01             	lea    0x1(%ecx),%eax
 49f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a8:	ba 00 00 00 00       	mov    $0x0,%edx
 4ad:	f7 f3                	div    %ebx
 4af:	89 d0                	mov    %edx,%eax
 4b1:	0f b6 80 34 0b 00 00 	movzbl 0xb34(%eax),%eax
 4b8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4bc:	8b 75 10             	mov    0x10(%ebp),%esi
 4bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c2:	ba 00 00 00 00       	mov    $0x0,%edx
 4c7:	f7 f6                	div    %esi
 4c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d0:	75 c7                	jne    499 <printint+0x39>
  if(neg)
 4d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d6:	74 10                	je     4e8 <printint+0x88>
    buf[i++] = '-';
 4d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4db:	8d 50 01             	lea    0x1(%eax),%edx
 4de:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4e6:	eb 1f                	jmp    507 <printint+0xa7>
 4e8:	eb 1d                	jmp    507 <printint+0xa7>
    putc(fd, buf[i]);
 4ea:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f0:	01 d0                	add    %edx,%eax
 4f2:	0f b6 00             	movzbl (%eax),%eax
 4f5:	0f be c0             	movsbl %al,%eax
 4f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fc:	8b 45 08             	mov    0x8(%ebp),%eax
 4ff:	89 04 24             	mov    %eax,(%esp)
 502:	e8 31 ff ff ff       	call   438 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 507:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 50b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50f:	79 d9                	jns    4ea <printint+0x8a>
    putc(fd, buf[i]);
}
 511:	83 c4 30             	add    $0x30,%esp
 514:	5b                   	pop    %ebx
 515:	5e                   	pop    %esi
 516:	5d                   	pop    %ebp
 517:	c3                   	ret    

00000518 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 518:	55                   	push   %ebp
 519:	89 e5                	mov    %esp,%ebp
 51b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 51e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 525:	8d 45 0c             	lea    0xc(%ebp),%eax
 528:	83 c0 04             	add    $0x4,%eax
 52b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 52e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 535:	e9 7c 01 00 00       	jmp    6b6 <printf+0x19e>
    c = fmt[i] & 0xff;
 53a:	8b 55 0c             	mov    0xc(%ebp),%edx
 53d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 540:	01 d0                	add    %edx,%eax
 542:	0f b6 00             	movzbl (%eax),%eax
 545:	0f be c0             	movsbl %al,%eax
 548:	25 ff 00 00 00       	and    $0xff,%eax
 54d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 550:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 554:	75 2c                	jne    582 <printf+0x6a>
      if(c == '%'){
 556:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55a:	75 0c                	jne    568 <printf+0x50>
        state = '%';
 55c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 563:	e9 4a 01 00 00       	jmp    6b2 <printf+0x19a>
      } else {
        putc(fd, c);
 568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56b:	0f be c0             	movsbl %al,%eax
 56e:	89 44 24 04          	mov    %eax,0x4(%esp)
 572:	8b 45 08             	mov    0x8(%ebp),%eax
 575:	89 04 24             	mov    %eax,(%esp)
 578:	e8 bb fe ff ff       	call   438 <putc>
 57d:	e9 30 01 00 00       	jmp    6b2 <printf+0x19a>
      }
    } else if(state == '%'){
 582:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 586:	0f 85 26 01 00 00    	jne    6b2 <printf+0x19a>
      if(c == 'd'){
 58c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 590:	75 2d                	jne    5bf <printf+0xa7>
        printint(fd, *ap, 10, 1);
 592:	8b 45 e8             	mov    -0x18(%ebp),%eax
 595:	8b 00                	mov    (%eax),%eax
 597:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 59e:	00 
 59f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5a6:	00 
 5a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	89 04 24             	mov    %eax,(%esp)
 5b1:	e8 aa fe ff ff       	call   460 <printint>
        ap++;
 5b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ba:	e9 ec 00 00 00       	jmp    6ab <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5bf:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5c3:	74 06                	je     5cb <printf+0xb3>
 5c5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c9:	75 2d                	jne    5f8 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ce:	8b 00                	mov    (%eax),%eax
 5d0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5d7:	00 
 5d8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5df:	00 
 5e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	89 04 24             	mov    %eax,(%esp)
 5ea:	e8 71 fe ff ff       	call   460 <printint>
        ap++;
 5ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f3:	e9 b3 00 00 00       	jmp    6ab <printf+0x193>
      } else if(c == 's'){
 5f8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5fc:	75 45                	jne    643 <printf+0x12b>
        s = (char*)*ap;
 5fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 601:	8b 00                	mov    (%eax),%eax
 603:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 606:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 60a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60e:	75 09                	jne    619 <printf+0x101>
          s = "(null)";
 610:	c7 45 f4 e8 08 00 00 	movl   $0x8e8,-0xc(%ebp)
        while(*s != 0){
 617:	eb 1e                	jmp    637 <printf+0x11f>
 619:	eb 1c                	jmp    637 <printf+0x11f>
          putc(fd, *s);
 61b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61e:	0f b6 00             	movzbl (%eax),%eax
 621:	0f be c0             	movsbl %al,%eax
 624:	89 44 24 04          	mov    %eax,0x4(%esp)
 628:	8b 45 08             	mov    0x8(%ebp),%eax
 62b:	89 04 24             	mov    %eax,(%esp)
 62e:	e8 05 fe ff ff       	call   438 <putc>
          s++;
 633:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 637:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63a:	0f b6 00             	movzbl (%eax),%eax
 63d:	84 c0                	test   %al,%al
 63f:	75 da                	jne    61b <printf+0x103>
 641:	eb 68                	jmp    6ab <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 643:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 647:	75 1d                	jne    666 <printf+0x14e>
        putc(fd, *ap);
 649:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	0f be c0             	movsbl %al,%eax
 651:	89 44 24 04          	mov    %eax,0x4(%esp)
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	89 04 24             	mov    %eax,(%esp)
 65b:	e8 d8 fd ff ff       	call   438 <putc>
        ap++;
 660:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 664:	eb 45                	jmp    6ab <printf+0x193>
      } else if(c == '%'){
 666:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66a:	75 17                	jne    683 <printf+0x16b>
        putc(fd, c);
 66c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66f:	0f be c0             	movsbl %al,%eax
 672:	89 44 24 04          	mov    %eax,0x4(%esp)
 676:	8b 45 08             	mov    0x8(%ebp),%eax
 679:	89 04 24             	mov    %eax,(%esp)
 67c:	e8 b7 fd ff ff       	call   438 <putc>
 681:	eb 28                	jmp    6ab <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 683:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 68a:	00 
 68b:	8b 45 08             	mov    0x8(%ebp),%eax
 68e:	89 04 24             	mov    %eax,(%esp)
 691:	e8 a2 fd ff ff       	call   438 <putc>
        putc(fd, c);
 696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 699:	0f be c0             	movsbl %al,%eax
 69c:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a0:	8b 45 08             	mov    0x8(%ebp),%eax
 6a3:	89 04 24             	mov    %eax,(%esp)
 6a6:	e8 8d fd ff ff       	call   438 <putc>
      }
      state = 0;
 6ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bc:	01 d0                	add    %edx,%eax
 6be:	0f b6 00             	movzbl (%eax),%eax
 6c1:	84 c0                	test   %al,%al
 6c3:	0f 85 71 fe ff ff    	jne    53a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c9:	c9                   	leave  
 6ca:	c3                   	ret    

000006cb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cb:	55                   	push   %ebp
 6cc:	89 e5                	mov    %esp,%ebp
 6ce:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d1:	8b 45 08             	mov    0x8(%ebp),%eax
 6d4:	83 e8 08             	sub    $0x8,%eax
 6d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6da:	a1 50 0b 00 00       	mov    0xb50,%eax
 6df:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e2:	eb 24                	jmp    708 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ec:	77 12                	ja     700 <free+0x35>
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f4:	77 24                	ja     71a <free+0x4f>
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 00                	mov    (%eax),%eax
 6fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fe:	77 1a                	ja     71a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	89 45 fc             	mov    %eax,-0x4(%ebp)
 708:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70e:	76 d4                	jbe    6e4 <free+0x19>
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 718:	76 ca                	jbe    6e4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	01 c2                	add    %eax,%edx
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	39 c2                	cmp    %eax,%edx
 733:	75 24                	jne    759 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	8b 50 04             	mov    0x4(%eax),%edx
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	8b 40 04             	mov    0x4(%eax),%eax
 743:	01 c2                	add    %eax,%edx
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 00                	mov    (%eax),%eax
 750:	8b 10                	mov    (%eax),%edx
 752:	8b 45 f8             	mov    -0x8(%ebp),%eax
 755:	89 10                	mov    %edx,(%eax)
 757:	eb 0a                	jmp    763 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 10                	mov    (%eax),%edx
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	01 d0                	add    %edx,%eax
 775:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 778:	75 20                	jne    79a <free+0xcf>
    p->s.size += bp->s.size;
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 50 04             	mov    0x4(%eax),%edx
 780:	8b 45 f8             	mov    -0x8(%ebp),%eax
 783:	8b 40 04             	mov    0x4(%eax),%eax
 786:	01 c2                	add    %eax,%edx
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	8b 10                	mov    (%eax),%edx
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	89 10                	mov    %edx,(%eax)
 798:	eb 08                	jmp    7a2 <free+0xd7>
  } else
    p->s.ptr = bp;
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a0:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	a3 50 0b 00 00       	mov    %eax,0xb50
}
 7aa:	c9                   	leave  
 7ab:	c3                   	ret    

000007ac <morecore>:

static Header*
morecore(uint nu)
{
 7ac:	55                   	push   %ebp
 7ad:	89 e5                	mov    %esp,%ebp
 7af:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b9:	77 07                	ja     7c2 <morecore+0x16>
    nu = 4096;
 7bb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c2:	8b 45 08             	mov    0x8(%ebp),%eax
 7c5:	c1 e0 03             	shl    $0x3,%eax
 7c8:	89 04 24             	mov    %eax,(%esp)
 7cb:	e8 28 fc ff ff       	call   3f8 <sbrk>
 7d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d7:	75 07                	jne    7e0 <morecore+0x34>
    return 0;
 7d9:	b8 00 00 00 00       	mov    $0x0,%eax
 7de:	eb 22                	jmp    802 <morecore+0x56>
  hp = (Header*)p;
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e9:	8b 55 08             	mov    0x8(%ebp),%edx
 7ec:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	83 c0 08             	add    $0x8,%eax
 7f5:	89 04 24             	mov    %eax,(%esp)
 7f8:	e8 ce fe ff ff       	call   6cb <free>
  return freep;
 7fd:	a1 50 0b 00 00       	mov    0xb50,%eax
}
 802:	c9                   	leave  
 803:	c3                   	ret    

00000804 <malloc>:

void*
malloc(uint nbytes)
{
 804:	55                   	push   %ebp
 805:	89 e5                	mov    %esp,%ebp
 807:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80a:	8b 45 08             	mov    0x8(%ebp),%eax
 80d:	83 c0 07             	add    $0x7,%eax
 810:	c1 e8 03             	shr    $0x3,%eax
 813:	83 c0 01             	add    $0x1,%eax
 816:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 819:	a1 50 0b 00 00       	mov    0xb50,%eax
 81e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 821:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 825:	75 23                	jne    84a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 827:	c7 45 f0 48 0b 00 00 	movl   $0xb48,-0x10(%ebp)
 82e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 831:	a3 50 0b 00 00       	mov    %eax,0xb50
 836:	a1 50 0b 00 00       	mov    0xb50,%eax
 83b:	a3 48 0b 00 00       	mov    %eax,0xb48
    base.s.size = 0;
 840:	c7 05 4c 0b 00 00 00 	movl   $0x0,0xb4c
 847:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84d:	8b 00                	mov    (%eax),%eax
 84f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 40 04             	mov    0x4(%eax),%eax
 858:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85b:	72 4d                	jb     8aa <malloc+0xa6>
      if(p->s.size == nunits)
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	8b 40 04             	mov    0x4(%eax),%eax
 863:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 866:	75 0c                	jne    874 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	8b 10                	mov    (%eax),%edx
 86d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 870:	89 10                	mov    %edx,(%eax)
 872:	eb 26                	jmp    89a <malloc+0x96>
      else {
        p->s.size -= nunits;
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 87d:	89 c2                	mov    %eax,%edx
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 885:	8b 45 f4             	mov    -0xc(%ebp),%eax
 888:	8b 40 04             	mov    0x4(%eax),%eax
 88b:	c1 e0 03             	shl    $0x3,%eax
 88e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 891:	8b 45 f4             	mov    -0xc(%ebp),%eax
 894:	8b 55 ec             	mov    -0x14(%ebp),%edx
 897:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89d:	a3 50 0b 00 00       	mov    %eax,0xb50
      return (void*)(p + 1);
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	83 c0 08             	add    $0x8,%eax
 8a8:	eb 38                	jmp    8e2 <malloc+0xde>
    }
    if(p == freep)
 8aa:	a1 50 0b 00 00       	mov    0xb50,%eax
 8af:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b2:	75 1b                	jne    8cf <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b7:	89 04 24             	mov    %eax,(%esp)
 8ba:	e8 ed fe ff ff       	call   7ac <morecore>
 8bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c6:	75 07                	jne    8cf <malloc+0xcb>
        return 0;
 8c8:	b8 00 00 00 00       	mov    $0x0,%eax
 8cd:	eb 13                	jmp    8e2 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 00                	mov    (%eax),%eax
 8da:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8dd:	e9 70 ff ff ff       	jmp    852 <malloc+0x4e>
}
 8e2:	c9                   	leave  
 8e3:	c3                   	ret    
