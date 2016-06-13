
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	89 04 24             	mov    %eax,(%esp)
   c:	e8 cc 01 00 00       	call   1dd <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 ba 03 00 00       	call   3e1 <write>
}
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	55                   	push   %ebp
  2a:	89 e5                	mov    %esp,%ebp
  2c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
  2f:	c7 44 24 04 8c 04 00 	movl   $0x48c,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4a:	eb 26                	jmp    72 <forktest+0x49>
    pid = fork();
  4c:	e8 58 03 00 00       	call   3a9 <fork>
  51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  58:	79 02                	jns    5c <forktest+0x33>
      break;
  5a:	eb 1f                	jmp    7b <forktest+0x52>
    if(pid == 0)
  5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  60:	75 0c                	jne    6e <forktest+0x45>
      exit(0);
  62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  69:	e8 43 03 00 00       	call   3b1 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  72:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  79:	7e d1                	jle    4c <forktest+0x23>
      break;
    if(pid == 0)
      exit(0);
  }
  
  if(n == N){
  7b:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  82:	75 28                	jne    ac <forktest+0x83>
    printf(1, "fork claimed to work N times!\n", N);
  84:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  8b:	00 
  8c:	c7 44 24 04 98 04 00 	movl   $0x498,0x4(%esp)
  93:	00 
  94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9b:	e8 60 ff ff ff       	call   0 <printf>
    exit(0);
  a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a7:	e8 05 03 00 00       	call   3b1 <exit>
  }
  
  for(; n > 0; n--){
  ac:	eb 34                	jmp    e2 <forktest+0xb9>
    if(wait(0) < 0){
  ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  b5:	e8 ff 02 00 00       	call   3b9 <wait>
  ba:	85 c0                	test   %eax,%eax
  bc:	79 20                	jns    de <forktest+0xb5>
      printf(1, "wait stopped early\n");
  be:	c7 44 24 04 b7 04 00 	movl   $0x4b7,0x4(%esp)
  c5:	00 
  c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cd:	e8 2e ff ff ff       	call   0 <printf>
      exit(0);
  d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  d9:	e8 d3 02 00 00       	call   3b1 <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit(0);
  }
  
  for(; n > 0; n--){
  de:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  e6:	7f c6                	jg     ae <forktest+0x85>
      printf(1, "wait stopped early\n");
      exit(0);
    }
  }
  
  if(wait(0) != -1){
  e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ef:	e8 c5 02 00 00       	call   3b9 <wait>
  f4:	83 f8 ff             	cmp    $0xffffffff,%eax
  f7:	74 20                	je     119 <forktest+0xf0>
    printf(1, "wait got too many\n");
  f9:	c7 44 24 04 cb 04 00 	movl   $0x4cb,0x4(%esp)
 100:	00 
 101:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 108:	e8 f3 fe ff ff       	call   0 <printf>
    exit(0);
 10d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 114:	e8 98 02 00 00       	call   3b1 <exit>
  }
  
  printf(1, "fork test OK\n");
 119:	c7 44 24 04 de 04 00 	movl   $0x4de,0x4(%esp)
 120:	00 
 121:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 128:	e8 d3 fe ff ff       	call   0 <printf>
}
 12d:	c9                   	leave  
 12e:	c3                   	ret    

0000012f <main>:

int
main(void)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 e4 f0             	and    $0xfffffff0,%esp
 135:	83 ec 10             	sub    $0x10,%esp
  forktest();
 138:	e8 ec fe ff ff       	call   29 <forktest>
  exit(0);
 13d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 144:	e8 68 02 00 00       	call   3b1 <exit>

00000149 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	57                   	push   %edi
 14d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 14e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 151:	8b 55 10             	mov    0x10(%ebp),%edx
 154:	8b 45 0c             	mov    0xc(%ebp),%eax
 157:	89 cb                	mov    %ecx,%ebx
 159:	89 df                	mov    %ebx,%edi
 15b:	89 d1                	mov    %edx,%ecx
 15d:	fc                   	cld    
 15e:	f3 aa                	rep stos %al,%es:(%edi)
 160:	89 ca                	mov    %ecx,%edx
 162:	89 fb                	mov    %edi,%ebx
 164:	89 5d 08             	mov    %ebx,0x8(%ebp)
 167:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 16a:	5b                   	pop    %ebx
 16b:	5f                   	pop    %edi
 16c:	5d                   	pop    %ebp
 16d:	c3                   	ret    

0000016e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 17a:	90                   	nop
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	8d 50 01             	lea    0x1(%eax),%edx
 181:	89 55 08             	mov    %edx,0x8(%ebp)
 184:	8b 55 0c             	mov    0xc(%ebp),%edx
 187:	8d 4a 01             	lea    0x1(%edx),%ecx
 18a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 18d:	0f b6 12             	movzbl (%edx),%edx
 190:	88 10                	mov    %dl,(%eax)
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	84 c0                	test   %al,%al
 197:	75 e2                	jne    17b <strcpy+0xd>
    ;
  return os;
 199:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19c:	c9                   	leave  
 19d:	c3                   	ret    

0000019e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1a1:	eb 08                	jmp    1ab <strcmp+0xd>
    p++, q++;
 1a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ab:	8b 45 08             	mov    0x8(%ebp),%eax
 1ae:	0f b6 00             	movzbl (%eax),%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	74 10                	je     1c5 <strcmp+0x27>
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 10             	movzbl (%eax),%edx
 1bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1be:	0f b6 00             	movzbl (%eax),%eax
 1c1:	38 c2                	cmp    %al,%dl
 1c3:	74 de                	je     1a3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	0f b6 d0             	movzbl %al,%edx
 1ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d1:	0f b6 00             	movzbl (%eax),%eax
 1d4:	0f b6 c0             	movzbl %al,%eax
 1d7:	29 c2                	sub    %eax,%edx
 1d9:	89 d0                	mov    %edx,%eax
}
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    

000001dd <strlen>:

uint
strlen(char *s)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ea:	eb 04                	jmp    1f0 <strlen+0x13>
 1ec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	01 d0                	add    %edx,%eax
 1f8:	0f b6 00             	movzbl (%eax),%eax
 1fb:	84 c0                	test   %al,%al
 1fd:	75 ed                	jne    1ec <strlen+0xf>
    ;
  return n;
 1ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 202:	c9                   	leave  
 203:	c3                   	ret    

00000204 <memset>:

void*
memset(void *dst, int c, uint n)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 20a:	8b 45 10             	mov    0x10(%ebp),%eax
 20d:	89 44 24 08          	mov    %eax,0x8(%esp)
 211:	8b 45 0c             	mov    0xc(%ebp),%eax
 214:	89 44 24 04          	mov    %eax,0x4(%esp)
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	89 04 24             	mov    %eax,(%esp)
 21e:	e8 26 ff ff ff       	call   149 <stosb>
  return dst;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <strchr>:

char*
strchr(const char *s, char c)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 234:	eb 14                	jmp    24a <strchr+0x22>
    if(*s == c)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 23f:	75 05                	jne    246 <strchr+0x1e>
      return (char*)s;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	eb 13                	jmp    259 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 e2                	jne    236 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <gets>:

char*
gets(char *buf, int max)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 268:	eb 4c                	jmp    2b6 <gets+0x5b>
    cc = read(0, &c, 1);
 26a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 271:	00 
 272:	8d 45 ef             	lea    -0x11(%ebp),%eax
 275:	89 44 24 04          	mov    %eax,0x4(%esp)
 279:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 280:	e8 54 01 00 00       	call   3d9 <read>
 285:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 28c:	7f 02                	jg     290 <gets+0x35>
      break;
 28e:	eb 31                	jmp    2c1 <gets+0x66>
    buf[i++] = c;
 290:	8b 45 f4             	mov    -0xc(%ebp),%eax
 293:	8d 50 01             	lea    0x1(%eax),%edx
 296:	89 55 f4             	mov    %edx,-0xc(%ebp)
 299:	89 c2                	mov    %eax,%edx
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	01 c2                	add    %eax,%edx
 2a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2aa:	3c 0a                	cmp    $0xa,%al
 2ac:	74 13                	je     2c1 <gets+0x66>
 2ae:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b2:	3c 0d                	cmp    $0xd,%al
 2b4:	74 0b                	je     2c1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b9:	83 c0 01             	add    $0x1,%eax
 2bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2bf:	7c a9                	jl     26a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	01 d0                	add    %edx,%eax
 2c9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2cf:	c9                   	leave  
 2d0:	c3                   	ret    

000002d1 <stat>:

int
stat(char *n, struct stat *st)
{
 2d1:	55                   	push   %ebp
 2d2:	89 e5                	mov    %esp,%ebp
 2d4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2de:	00 
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	89 04 24             	mov    %eax,(%esp)
 2e5:	e8 17 01 00 00       	call   401 <open>
 2ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f1:	79 07                	jns    2fa <stat+0x29>
    return -1;
 2f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f8:	eb 23                	jmp    31d <stat+0x4c>
  r = fstat(fd, st);
 2fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 301:	8b 45 f4             	mov    -0xc(%ebp),%eax
 304:	89 04 24             	mov    %eax,(%esp)
 307:	e8 0d 01 00 00       	call   419 <fstat>
 30c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 312:	89 04 24             	mov    %eax,(%esp)
 315:	e8 cf 00 00 00       	call   3e9 <close>
  return r;
 31a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 31d:	c9                   	leave  
 31e:	c3                   	ret    

0000031f <atoi>:

int
atoi(const char *s)
{
 31f:	55                   	push   %ebp
 320:	89 e5                	mov    %esp,%ebp
 322:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 325:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32c:	eb 25                	jmp    353 <atoi+0x34>
    n = n*10 + *s++ - '0';
 32e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 331:	89 d0                	mov    %edx,%eax
 333:	c1 e0 02             	shl    $0x2,%eax
 336:	01 d0                	add    %edx,%eax
 338:	01 c0                	add    %eax,%eax
 33a:	89 c1                	mov    %eax,%ecx
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	8d 50 01             	lea    0x1(%eax),%edx
 342:	89 55 08             	mov    %edx,0x8(%ebp)
 345:	0f b6 00             	movzbl (%eax),%eax
 348:	0f be c0             	movsbl %al,%eax
 34b:	01 c8                	add    %ecx,%eax
 34d:	83 e8 30             	sub    $0x30,%eax
 350:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	0f b6 00             	movzbl (%eax),%eax
 359:	3c 2f                	cmp    $0x2f,%al
 35b:	7e 0a                	jle    367 <atoi+0x48>
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
 360:	0f b6 00             	movzbl (%eax),%eax
 363:	3c 39                	cmp    $0x39,%al
 365:	7e c7                	jle    32e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 367:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 36a:	c9                   	leave  
 36b:	c3                   	ret    

0000036c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 378:	8b 45 0c             	mov    0xc(%ebp),%eax
 37b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 37e:	eb 17                	jmp    397 <memmove+0x2b>
    *dst++ = *src++;
 380:	8b 45 fc             	mov    -0x4(%ebp),%eax
 383:	8d 50 01             	lea    0x1(%eax),%edx
 386:	89 55 fc             	mov    %edx,-0x4(%ebp)
 389:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38c:	8d 4a 01             	lea    0x1(%edx),%ecx
 38f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 392:	0f b6 12             	movzbl (%edx),%edx
 395:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 397:	8b 45 10             	mov    0x10(%ebp),%eax
 39a:	8d 50 ff             	lea    -0x1(%eax),%edx
 39d:	89 55 10             	mov    %edx,0x10(%ebp)
 3a0:	85 c0                	test   %eax,%eax
 3a2:	7f dc                	jg     380 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a7:	c9                   	leave  
 3a8:	c3                   	ret    

000003a9 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 3a9:	b8 01 00 00 00       	mov    $0x1,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <exit>:
SYSCALL(exit)
 3b1:	b8 02 00 00 00       	mov    $0x2,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <wait>:
SYSCALL(wait)
 3b9:	b8 03 00 00 00       	mov    $0x3,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <waitpid>:
SYSCALL(waitpid)
 3c1:	b8 16 00 00 00       	mov    $0x16,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <wait_stat>:
SYSCALL(wait_stat)
 3c9:	b8 17 00 00 00       	mov    $0x17,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <pipe>:
SYSCALL(pipe)
 3d1:	b8 04 00 00 00       	mov    $0x4,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <read>:
SYSCALL(read)
 3d9:	b8 05 00 00 00       	mov    $0x5,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <write>:
SYSCALL(write)
 3e1:	b8 10 00 00 00       	mov    $0x10,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <close>:
SYSCALL(close)
 3e9:	b8 15 00 00 00       	mov    $0x15,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <kill>:
SYSCALL(kill)
 3f1:	b8 06 00 00 00       	mov    $0x6,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <exec>:
SYSCALL(exec)
 3f9:	b8 07 00 00 00       	mov    $0x7,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <open>:
SYSCALL(open)
 401:	b8 0f 00 00 00       	mov    $0xf,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <mknod>:
SYSCALL(mknod)
 409:	b8 11 00 00 00       	mov    $0x11,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <unlink>:
SYSCALL(unlink)
 411:	b8 12 00 00 00       	mov    $0x12,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <fstat>:
SYSCALL(fstat)
 419:	b8 08 00 00 00       	mov    $0x8,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <link>:
SYSCALL(link)
 421:	b8 13 00 00 00       	mov    $0x13,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <mkdir>:
SYSCALL(mkdir)
 429:	b8 14 00 00 00       	mov    $0x14,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <chdir>:
SYSCALL(chdir)
 431:	b8 09 00 00 00       	mov    $0x9,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <dup>:
SYSCALL(dup)
 439:	b8 0a 00 00 00       	mov    $0xa,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <getpid>:
SYSCALL(getpid)
 441:	b8 0b 00 00 00       	mov    $0xb,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <sbrk>:
SYSCALL(sbrk)
 449:	b8 0c 00 00 00       	mov    $0xc,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <set_priority>:
SYSCALL(set_priority)
 451:	b8 18 00 00 00       	mov    $0x18,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <canRemoveJob>:
SYSCALL(canRemoveJob)
 459:	b8 19 00 00 00       	mov    $0x19,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <jobs>:
SYSCALL(jobs)
 461:	b8 1a 00 00 00       	mov    $0x1a,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <sleep>:
SYSCALL(sleep)
 469:	b8 0d 00 00 00       	mov    $0xd,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <uptime>:
SYSCALL(uptime)
 471:	b8 0e 00 00 00       	mov    $0xe,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <gidpid>:
SYSCALL(gidpid)
 479:	b8 1b 00 00 00       	mov    $0x1b,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <isShell>:
SYSCALL(isShell)
 481:	b8 1c 00 00 00       	mov    $0x1c,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    
