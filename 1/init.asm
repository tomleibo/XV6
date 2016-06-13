
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 13 09 00 00 	movl   $0x913,(%esp)
  18:	e8 bf 03 00 00       	call   3dc <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 13 09 00 00 	movl   $0x913,(%esp)
  38:	e8 a7 03 00 00       	call   3e4 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 13 09 00 00 	movl   $0x913,(%esp)
  4c:	e8 8b 03 00 00       	call   3dc <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 b7 03 00 00       	call   414 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 ab 03 00 00       	call   414 <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  69:	c7 44 24 04 1b 09 00 	movl   $0x91b,0x4(%esp)
  70:	00 
  71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  78:	e8 c7 04 00 00       	call   544 <printf>
    pid = fork();
  7d:	e8 02 03 00 00       	call   384 <fork>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  86:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8b:	79 20                	jns    ad <main+0xad>
      printf(1, "init: fork failed\n");
  8d:	c7 44 24 04 2e 09 00 	movl   $0x92e,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 a3 04 00 00       	call   544 <printf>
      exit(0);
  a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a8:	e8 df 02 00 00       	call   38c <exit>
    }
    if(pid == 0){
  ad:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  b2:	75 34                	jne    e8 <main+0xe8>
      exec("sh", argv);
  b4:	c7 44 24 04 ac 0b 00 	movl   $0xbac,0x4(%esp)
  bb:	00 
  bc:	c7 04 24 10 09 00 00 	movl   $0x910,(%esp)
  c3:	e8 0c 03 00 00       	call   3d4 <exec>
      printf(1, "init: exec sh failed\n");
  c8:	c7 44 24 04 41 09 00 	movl   $0x941,0x4(%esp)
  cf:	00 
  d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d7:	e8 68 04 00 00       	call   544 <printf>
      exit(0);
  dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  e3:	e8 a4 02 00 00       	call   38c <exit>
    }
    while((wpid=wait(0)) >= 0 && wpid != pid) { 
  e8:	eb 14                	jmp    fe <main+0xfe>
      printf(1, "zombie!\n");
  ea:	c7 44 24 04 57 09 00 	movl   $0x957,0x4(%esp)
  f1:	00 
  f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f9:	e8 46 04 00 00       	call   544 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit(0);
    }
    while((wpid=wait(0)) >= 0 && wpid != pid) { 
  fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 105:	e8 8a 02 00 00       	call   394 <wait>
 10a:	89 44 24 18          	mov    %eax,0x18(%esp)
 10e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 113:	78 0a                	js     11f <main+0x11f>
 115:	8b 44 24 18          	mov    0x18(%esp),%eax
 119:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 11d:	75 cb                	jne    ea <main+0xea>
      printf(1, "zombie!\n");
    }
  }
 11f:	e9 45 ff ff ff       	jmp    69 <main+0x69>

00000124 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	57                   	push   %edi
 128:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 129:	8b 4d 08             	mov    0x8(%ebp),%ecx
 12c:	8b 55 10             	mov    0x10(%ebp),%edx
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	89 cb                	mov    %ecx,%ebx
 134:	89 df                	mov    %ebx,%edi
 136:	89 d1                	mov    %edx,%ecx
 138:	fc                   	cld    
 139:	f3 aa                	rep stos %al,%es:(%edi)
 13b:	89 ca                	mov    %ecx,%edx
 13d:	89 fb                	mov    %edi,%ebx
 13f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 142:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 145:	5b                   	pop    %ebx
 146:	5f                   	pop    %edi
 147:	5d                   	pop    %ebp
 148:	c3                   	ret    

00000149 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 155:	90                   	nop
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	8d 50 01             	lea    0x1(%eax),%edx
 15c:	89 55 08             	mov    %edx,0x8(%ebp)
 15f:	8b 55 0c             	mov    0xc(%ebp),%edx
 162:	8d 4a 01             	lea    0x1(%edx),%ecx
 165:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 168:	0f b6 12             	movzbl (%edx),%edx
 16b:	88 10                	mov    %dl,(%eax)
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strcpy+0xd>
    ;
  return os;
 174:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 177:	c9                   	leave  
 178:	c3                   	ret    

00000179 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 17c:	eb 08                	jmp    186 <strcmp+0xd>
    p++, q++;
 17e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 182:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	0f b6 00             	movzbl (%eax),%eax
 18c:	84 c0                	test   %al,%al
 18e:	74 10                	je     1a0 <strcmp+0x27>
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	0f b6 10             	movzbl (%eax),%edx
 196:	8b 45 0c             	mov    0xc(%ebp),%eax
 199:	0f b6 00             	movzbl (%eax),%eax
 19c:	38 c2                	cmp    %al,%dl
 19e:	74 de                	je     17e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	0f b6 d0             	movzbl %al,%edx
 1a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ac:	0f b6 00             	movzbl (%eax),%eax
 1af:	0f b6 c0             	movzbl %al,%eax
 1b2:	29 c2                	sub    %eax,%edx
 1b4:	89 d0                	mov    %edx,%eax
}
 1b6:	5d                   	pop    %ebp
 1b7:	c3                   	ret    

000001b8 <strlen>:

uint
strlen(char *s)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c5:	eb 04                	jmp    1cb <strlen+0x13>
 1c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 d0                	add    %edx,%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	84 c0                	test   %al,%al
 1d8:	75 ed                	jne    1c7 <strlen+0xf>
    ;
  return n;
 1da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1dd:	c9                   	leave  
 1de:	c3                   	ret    

000001df <memset>:

void*
memset(void *dst, int c, uint n)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1e5:	8b 45 10             	mov    0x10(%ebp),%eax
 1e8:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	89 04 24             	mov    %eax,(%esp)
 1f9:	e8 26 ff ff ff       	call   124 <stosb>
  return dst;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
 201:	c9                   	leave  
 202:	c3                   	ret    

00000203 <strchr>:

char*
strchr(const char *s, char c)
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	83 ec 04             	sub    $0x4,%esp
 209:	8b 45 0c             	mov    0xc(%ebp),%eax
 20c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20f:	eb 14                	jmp    225 <strchr+0x22>
    if(*s == c)
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	0f b6 00             	movzbl (%eax),%eax
 217:	3a 45 fc             	cmp    -0x4(%ebp),%al
 21a:	75 05                	jne    221 <strchr+0x1e>
      return (char*)s;
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	eb 13                	jmp    234 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 221:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	84 c0                	test   %al,%al
 22d:	75 e2                	jne    211 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 22f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <gets>:

char*
gets(char *buf, int max)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 243:	eb 4c                	jmp    291 <gets+0x5b>
    cc = read(0, &c, 1);
 245:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 24c:	00 
 24d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 250:	89 44 24 04          	mov    %eax,0x4(%esp)
 254:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 25b:	e8 54 01 00 00       	call   3b4 <read>
 260:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 263:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 267:	7f 02                	jg     26b <gets+0x35>
      break;
 269:	eb 31                	jmp    29c <gets+0x66>
    buf[i++] = c;
 26b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26e:	8d 50 01             	lea    0x1(%eax),%edx
 271:	89 55 f4             	mov    %edx,-0xc(%ebp)
 274:	89 c2                	mov    %eax,%edx
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	01 c2                	add    %eax,%edx
 27b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 281:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 285:	3c 0a                	cmp    $0xa,%al
 287:	74 13                	je     29c <gets+0x66>
 289:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 28d:	3c 0d                	cmp    $0xd,%al
 28f:	74 0b                	je     29c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 291:	8b 45 f4             	mov    -0xc(%ebp),%eax
 294:	83 c0 01             	add    $0x1,%eax
 297:	3b 45 0c             	cmp    0xc(%ebp),%eax
 29a:	7c a9                	jl     245 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 29c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	01 d0                	add    %edx,%eax
 2a4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <stat>:

int
stat(char *n, struct stat *st)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2b9:	00 
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	89 04 24             	mov    %eax,(%esp)
 2c0:	e8 17 01 00 00       	call   3dc <open>
 2c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2cc:	79 07                	jns    2d5 <stat+0x29>
    return -1;
 2ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2d3:	eb 23                	jmp    2f8 <stat+0x4c>
  r = fstat(fd, st);
 2d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2df:	89 04 24             	mov    %eax,(%esp)
 2e2:	e8 0d 01 00 00       	call   3f4 <fstat>
 2e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ed:	89 04 24             	mov    %eax,(%esp)
 2f0:	e8 cf 00 00 00       	call   3c4 <close>
  return r;
 2f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f8:	c9                   	leave  
 2f9:	c3                   	ret    

000002fa <atoi>:

int
atoi(const char *s)
{
 2fa:	55                   	push   %ebp
 2fb:	89 e5                	mov    %esp,%ebp
 2fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 307:	eb 25                	jmp    32e <atoi+0x34>
    n = n*10 + *s++ - '0';
 309:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30c:	89 d0                	mov    %edx,%eax
 30e:	c1 e0 02             	shl    $0x2,%eax
 311:	01 d0                	add    %edx,%eax
 313:	01 c0                	add    %eax,%eax
 315:	89 c1                	mov    %eax,%ecx
 317:	8b 45 08             	mov    0x8(%ebp),%eax
 31a:	8d 50 01             	lea    0x1(%eax),%edx
 31d:	89 55 08             	mov    %edx,0x8(%ebp)
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	0f be c0             	movsbl %al,%eax
 326:	01 c8                	add    %ecx,%eax
 328:	83 e8 30             	sub    $0x30,%eax
 32b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	0f b6 00             	movzbl (%eax),%eax
 334:	3c 2f                	cmp    $0x2f,%al
 336:	7e 0a                	jle    342 <atoi+0x48>
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	0f b6 00             	movzbl (%eax),%eax
 33e:	3c 39                	cmp    $0x39,%al
 340:	7e c7                	jle    309 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 342:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 345:	c9                   	leave  
 346:	c3                   	ret    

00000347 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 347:	55                   	push   %ebp
 348:	89 e5                	mov    %esp,%ebp
 34a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 353:	8b 45 0c             	mov    0xc(%ebp),%eax
 356:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 359:	eb 17                	jmp    372 <memmove+0x2b>
    *dst++ = *src++;
 35b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35e:	8d 50 01             	lea    0x1(%eax),%edx
 361:	89 55 fc             	mov    %edx,-0x4(%ebp)
 364:	8b 55 f8             	mov    -0x8(%ebp),%edx
 367:	8d 4a 01             	lea    0x1(%edx),%ecx
 36a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 36d:	0f b6 12             	movzbl (%edx),%edx
 370:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 372:	8b 45 10             	mov    0x10(%ebp),%eax
 375:	8d 50 ff             	lea    -0x1(%eax),%edx
 378:	89 55 10             	mov    %edx,0x10(%ebp)
 37b:	85 c0                	test   %eax,%eax
 37d:	7f dc                	jg     35b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 382:	c9                   	leave  
 383:	c3                   	ret    

00000384 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 384:	b8 01 00 00 00       	mov    $0x1,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <exit>:
SYSCALL(exit)
 38c:	b8 02 00 00 00       	mov    $0x2,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <wait>:
SYSCALL(wait)
 394:	b8 03 00 00 00       	mov    $0x3,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <waitpid>:
SYSCALL(waitpid)
 39c:	b8 16 00 00 00       	mov    $0x16,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <wait_stat>:
SYSCALL(wait_stat)
 3a4:	b8 17 00 00 00       	mov    $0x17,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <pipe>:
SYSCALL(pipe)
 3ac:	b8 04 00 00 00       	mov    $0x4,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <read>:
SYSCALL(read)
 3b4:	b8 05 00 00 00       	mov    $0x5,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <write>:
SYSCALL(write)
 3bc:	b8 10 00 00 00       	mov    $0x10,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <close>:
SYSCALL(close)
 3c4:	b8 15 00 00 00       	mov    $0x15,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <kill>:
SYSCALL(kill)
 3cc:	b8 06 00 00 00       	mov    $0x6,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <exec>:
SYSCALL(exec)
 3d4:	b8 07 00 00 00       	mov    $0x7,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <open>:
SYSCALL(open)
 3dc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <mknod>:
SYSCALL(mknod)
 3e4:	b8 11 00 00 00       	mov    $0x11,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <unlink>:
SYSCALL(unlink)
 3ec:	b8 12 00 00 00       	mov    $0x12,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <fstat>:
SYSCALL(fstat)
 3f4:	b8 08 00 00 00       	mov    $0x8,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <link>:
SYSCALL(link)
 3fc:	b8 13 00 00 00       	mov    $0x13,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <mkdir>:
SYSCALL(mkdir)
 404:	b8 14 00 00 00       	mov    $0x14,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <chdir>:
SYSCALL(chdir)
 40c:	b8 09 00 00 00       	mov    $0x9,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <dup>:
SYSCALL(dup)
 414:	b8 0a 00 00 00       	mov    $0xa,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <getpid>:
SYSCALL(getpid)
 41c:	b8 0b 00 00 00       	mov    $0xb,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <sbrk>:
SYSCALL(sbrk)
 424:	b8 0c 00 00 00       	mov    $0xc,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <set_priority>:
SYSCALL(set_priority)
 42c:	b8 18 00 00 00       	mov    $0x18,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <canRemoveJob>:
SYSCALL(canRemoveJob)
 434:	b8 19 00 00 00       	mov    $0x19,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <jobs>:
SYSCALL(jobs)
 43c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <sleep>:
SYSCALL(sleep)
 444:	b8 0d 00 00 00       	mov    $0xd,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <uptime>:
SYSCALL(uptime)
 44c:	b8 0e 00 00 00       	mov    $0xe,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <gidpid>:
SYSCALL(gidpid)
 454:	b8 1b 00 00 00       	mov    $0x1b,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <isShell>:
SYSCALL(isShell)
 45c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 18             	sub    $0x18,%esp
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 470:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 477:	00 
 478:	8d 45 f4             	lea    -0xc(%ebp),%eax
 47b:	89 44 24 04          	mov    %eax,0x4(%esp)
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	89 04 24             	mov    %eax,(%esp)
 485:	e8 32 ff ff ff       	call   3bc <write>
}
 48a:	c9                   	leave  
 48b:	c3                   	ret    

0000048c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	56                   	push   %esi
 490:	53                   	push   %ebx
 491:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 494:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 49b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 49f:	74 17                	je     4b8 <printint+0x2c>
 4a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a5:	79 11                	jns    4b8 <printint+0x2c>
    neg = 1;
 4a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b1:	f7 d8                	neg    %eax
 4b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b6:	eb 06                	jmp    4be <printint+0x32>
  } else {
    x = xx;
 4b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4c8:	8d 41 01             	lea    0x1(%ecx),%eax
 4cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d4:	ba 00 00 00 00       	mov    $0x0,%edx
 4d9:	f7 f3                	div    %ebx
 4db:	89 d0                	mov    %edx,%eax
 4dd:	0f b6 80 b4 0b 00 00 	movzbl 0xbb4(%eax),%eax
 4e4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4e8:	8b 75 10             	mov    0x10(%ebp),%esi
 4eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ee:	ba 00 00 00 00       	mov    $0x0,%edx
 4f3:	f7 f6                	div    %esi
 4f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4fc:	75 c7                	jne    4c5 <printint+0x39>
  if(neg)
 4fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 502:	74 10                	je     514 <printint+0x88>
    buf[i++] = '-';
 504:	8b 45 f4             	mov    -0xc(%ebp),%eax
 507:	8d 50 01             	lea    0x1(%eax),%edx
 50a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 50d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 512:	eb 1f                	jmp    533 <printint+0xa7>
 514:	eb 1d                	jmp    533 <printint+0xa7>
    putc(fd, buf[i]);
 516:	8d 55 dc             	lea    -0x24(%ebp),%edx
 519:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51c:	01 d0                	add    %edx,%eax
 51e:	0f b6 00             	movzbl (%eax),%eax
 521:	0f be c0             	movsbl %al,%eax
 524:	89 44 24 04          	mov    %eax,0x4(%esp)
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	89 04 24             	mov    %eax,(%esp)
 52e:	e8 31 ff ff ff       	call   464 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 533:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53b:	79 d9                	jns    516 <printint+0x8a>
    putc(fd, buf[i]);
}
 53d:	83 c4 30             	add    $0x30,%esp
 540:	5b                   	pop    %ebx
 541:	5e                   	pop    %esi
 542:	5d                   	pop    %ebp
 543:	c3                   	ret    

00000544 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 54a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 551:	8d 45 0c             	lea    0xc(%ebp),%eax
 554:	83 c0 04             	add    $0x4,%eax
 557:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 55a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 561:	e9 7c 01 00 00       	jmp    6e2 <printf+0x19e>
    c = fmt[i] & 0xff;
 566:	8b 55 0c             	mov    0xc(%ebp),%edx
 569:	8b 45 f0             	mov    -0x10(%ebp),%eax
 56c:	01 d0                	add    %edx,%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	0f be c0             	movsbl %al,%eax
 574:	25 ff 00 00 00       	and    $0xff,%eax
 579:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 57c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 580:	75 2c                	jne    5ae <printf+0x6a>
      if(c == '%'){
 582:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 586:	75 0c                	jne    594 <printf+0x50>
        state = '%';
 588:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 58f:	e9 4a 01 00 00       	jmp    6de <printf+0x19a>
      } else {
        putc(fd, c);
 594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 597:	0f be c0             	movsbl %al,%eax
 59a:	89 44 24 04          	mov    %eax,0x4(%esp)
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	89 04 24             	mov    %eax,(%esp)
 5a4:	e8 bb fe ff ff       	call   464 <putc>
 5a9:	e9 30 01 00 00       	jmp    6de <printf+0x19a>
      }
    } else if(state == '%'){
 5ae:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5b2:	0f 85 26 01 00 00    	jne    6de <printf+0x19a>
      if(c == 'd'){
 5b8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5bc:	75 2d                	jne    5eb <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c1:	8b 00                	mov    (%eax),%eax
 5c3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5ca:	00 
 5cb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5d2:	00 
 5d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	89 04 24             	mov    %eax,(%esp)
 5dd:	e8 aa fe ff ff       	call   48c <printint>
        ap++;
 5e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e6:	e9 ec 00 00 00       	jmp    6d7 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5eb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ef:	74 06                	je     5f7 <printf+0xb3>
 5f1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5f5:	75 2d                	jne    624 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 603:	00 
 604:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 60b:	00 
 60c:	89 44 24 04          	mov    %eax,0x4(%esp)
 610:	8b 45 08             	mov    0x8(%ebp),%eax
 613:	89 04 24             	mov    %eax,(%esp)
 616:	e8 71 fe ff ff       	call   48c <printint>
        ap++;
 61b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61f:	e9 b3 00 00 00       	jmp    6d7 <printf+0x193>
      } else if(c == 's'){
 624:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 628:	75 45                	jne    66f <printf+0x12b>
        s = (char*)*ap;
 62a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 632:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 636:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 63a:	75 09                	jne    645 <printf+0x101>
          s = "(null)";
 63c:	c7 45 f4 60 09 00 00 	movl   $0x960,-0xc(%ebp)
        while(*s != 0){
 643:	eb 1e                	jmp    663 <printf+0x11f>
 645:	eb 1c                	jmp    663 <printf+0x11f>
          putc(fd, *s);
 647:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64a:	0f b6 00             	movzbl (%eax),%eax
 64d:	0f be c0             	movsbl %al,%eax
 650:	89 44 24 04          	mov    %eax,0x4(%esp)
 654:	8b 45 08             	mov    0x8(%ebp),%eax
 657:	89 04 24             	mov    %eax,(%esp)
 65a:	e8 05 fe ff ff       	call   464 <putc>
          s++;
 65f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 663:	8b 45 f4             	mov    -0xc(%ebp),%eax
 666:	0f b6 00             	movzbl (%eax),%eax
 669:	84 c0                	test   %al,%al
 66b:	75 da                	jne    647 <printf+0x103>
 66d:	eb 68                	jmp    6d7 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 673:	75 1d                	jne    692 <printf+0x14e>
        putc(fd, *ap);
 675:	8b 45 e8             	mov    -0x18(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	0f be c0             	movsbl %al,%eax
 67d:	89 44 24 04          	mov    %eax,0x4(%esp)
 681:	8b 45 08             	mov    0x8(%ebp),%eax
 684:	89 04 24             	mov    %eax,(%esp)
 687:	e8 d8 fd ff ff       	call   464 <putc>
        ap++;
 68c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 690:	eb 45                	jmp    6d7 <printf+0x193>
      } else if(c == '%'){
 692:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 696:	75 17                	jne    6af <printf+0x16b>
        putc(fd, c);
 698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69b:	0f be c0             	movsbl %al,%eax
 69e:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a2:	8b 45 08             	mov    0x8(%ebp),%eax
 6a5:	89 04 24             	mov    %eax,(%esp)
 6a8:	e8 b7 fd ff ff       	call   464 <putc>
 6ad:	eb 28                	jmp    6d7 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6af:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6b6:	00 
 6b7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ba:	89 04 24             	mov    %eax,(%esp)
 6bd:	e8 a2 fd ff ff       	call   464 <putc>
        putc(fd, c);
 6c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c5:	0f be c0             	movsbl %al,%eax
 6c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6cc:	8b 45 08             	mov    0x8(%ebp),%eax
 6cf:	89 04 24             	mov    %eax,(%esp)
 6d2:	e8 8d fd ff ff       	call   464 <putc>
      }
      state = 0;
 6d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6de:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6e2:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e8:	01 d0                	add    %edx,%eax
 6ea:	0f b6 00             	movzbl (%eax),%eax
 6ed:	84 c0                	test   %al,%al
 6ef:	0f 85 71 fe ff ff    	jne    566 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f5:	c9                   	leave  
 6f6:	c3                   	ret    

000006f7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f7:	55                   	push   %ebp
 6f8:	89 e5                	mov    %esp,%ebp
 6fa:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	83 e8 08             	sub    $0x8,%eax
 703:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 706:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 70b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70e:	eb 24                	jmp    734 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 718:	77 12                	ja     72c <free+0x35>
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 720:	77 24                	ja     746 <free+0x4f>
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 00                	mov    (%eax),%eax
 727:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72a:	77 1a                	ja     746 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	89 45 fc             	mov    %eax,-0x4(%ebp)
 734:	8b 45 f8             	mov    -0x8(%ebp),%eax
 737:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73a:	76 d4                	jbe    710 <free+0x19>
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 744:	76 ca                	jbe    710 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	8b 40 04             	mov    0x4(%eax),%eax
 74c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	01 c2                	add    %eax,%edx
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	39 c2                	cmp    %eax,%edx
 75f:	75 24                	jne    785 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	8b 50 04             	mov    0x4(%eax),%edx
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	8b 40 04             	mov    0x4(%eax),%eax
 76f:	01 c2                	add    %eax,%edx
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	8b 10                	mov    (%eax),%edx
 77e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 781:	89 10                	mov    %edx,(%eax)
 783:	eb 0a                	jmp    78f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 10                	mov    (%eax),%edx
 78a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	01 d0                	add    %edx,%eax
 7a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a4:	75 20                	jne    7c6 <free+0xcf>
    p->s.size += bp->s.size;
 7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a9:	8b 50 04             	mov    0x4(%eax),%edx
 7ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	01 c2                	add    %eax,%edx
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	8b 10                	mov    (%eax),%edx
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	89 10                	mov    %edx,(%eax)
 7c4:	eb 08                	jmp    7ce <free+0xd7>
  } else
    p->s.ptr = bp;
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7cc:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	a3 d0 0b 00 00       	mov    %eax,0xbd0
}
 7d6:	c9                   	leave  
 7d7:	c3                   	ret    

000007d8 <morecore>:

static Header*
morecore(uint nu)
{
 7d8:	55                   	push   %ebp
 7d9:	89 e5                	mov    %esp,%ebp
 7db:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7de:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7e5:	77 07                	ja     7ee <morecore+0x16>
    nu = 4096;
 7e7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ee:	8b 45 08             	mov    0x8(%ebp),%eax
 7f1:	c1 e0 03             	shl    $0x3,%eax
 7f4:	89 04 24             	mov    %eax,(%esp)
 7f7:	e8 28 fc ff ff       	call   424 <sbrk>
 7fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ff:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 803:	75 07                	jne    80c <morecore+0x34>
    return 0;
 805:	b8 00 00 00 00       	mov    $0x0,%eax
 80a:	eb 22                	jmp    82e <morecore+0x56>
  hp = (Header*)p;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 812:	8b 45 f0             	mov    -0x10(%ebp),%eax
 815:	8b 55 08             	mov    0x8(%ebp),%edx
 818:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 81b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81e:	83 c0 08             	add    $0x8,%eax
 821:	89 04 24             	mov    %eax,(%esp)
 824:	e8 ce fe ff ff       	call   6f7 <free>
  return freep;
 829:	a1 d0 0b 00 00       	mov    0xbd0,%eax
}
 82e:	c9                   	leave  
 82f:	c3                   	ret    

00000830 <malloc>:

void*
malloc(uint nbytes)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 836:	8b 45 08             	mov    0x8(%ebp),%eax
 839:	83 c0 07             	add    $0x7,%eax
 83c:	c1 e8 03             	shr    $0x3,%eax
 83f:	83 c0 01             	add    $0x1,%eax
 842:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 845:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 84a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 84d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 851:	75 23                	jne    876 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 853:	c7 45 f0 c8 0b 00 00 	movl   $0xbc8,-0x10(%ebp)
 85a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85d:	a3 d0 0b 00 00       	mov    %eax,0xbd0
 862:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 867:	a3 c8 0b 00 00       	mov    %eax,0xbc8
    base.s.size = 0;
 86c:	c7 05 cc 0b 00 00 00 	movl   $0x0,0xbcc
 873:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 876:	8b 45 f0             	mov    -0x10(%ebp),%eax
 879:	8b 00                	mov    (%eax),%eax
 87b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 40 04             	mov    0x4(%eax),%eax
 884:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 887:	72 4d                	jb     8d6 <malloc+0xa6>
      if(p->s.size == nunits)
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	8b 40 04             	mov    0x4(%eax),%eax
 88f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 892:	75 0c                	jne    8a0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 10                	mov    (%eax),%edx
 899:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89c:	89 10                	mov    %edx,(%eax)
 89e:	eb 26                	jmp    8c6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	8b 40 04             	mov    0x4(%eax),%eax
 8a6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8a9:	89 c2                	mov    %eax,%edx
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	8b 40 04             	mov    0x4(%eax),%eax
 8b7:	c1 e0 03             	shl    $0x3,%eax
 8ba:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8c3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c9:	a3 d0 0b 00 00       	mov    %eax,0xbd0
      return (void*)(p + 1);
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	83 c0 08             	add    $0x8,%eax
 8d4:	eb 38                	jmp    90e <malloc+0xde>
    }
    if(p == freep)
 8d6:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 8db:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8de:	75 1b                	jne    8fb <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8e3:	89 04 24             	mov    %eax,(%esp)
 8e6:	e8 ed fe ff ff       	call   7d8 <morecore>
 8eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8f2:	75 07                	jne    8fb <malloc+0xcb>
        return 0;
 8f4:	b8 00 00 00 00       	mov    $0x0,%eax
 8f9:	eb 13                	jmp    90e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
 901:	8b 45 f4             	mov    -0xc(%ebp),%eax
 904:	8b 00                	mov    (%eax),%eax
 906:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 909:	e9 70 ff ff ff       	jmp    87e <malloc+0x4e>
}
 90e:	c9                   	leave  
 90f:	c3                   	ret    
