
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 00 0c 00 	movl   $0xc00,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 b1 03 00 00       	call   3d4 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 00 0c 00 	movl   $0xc00,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 8e 03 00 00       	call   3cc <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 20                	jns    6d <cat+0x6d>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 28 09 00 	movl   $0x928,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 fb 04 00 00       	call   55c <printf>
    exit(0);
  61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  68:	e8 37 03 00 00       	call   3a4 <exit>
  }
}
  6d:	c9                   	leave  
  6e:	c3                   	ret    

0000006f <main>:

int
main(int argc, char *argv[])
{
  6f:	55                   	push   %ebp
  70:	89 e5                	mov    %esp,%ebp
  72:	83 e4 f0             	and    $0xfffffff0,%esp
  75:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  78:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  7c:	7f 18                	jg     96 <main+0x27>
    cat(0);
  7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  85:	e8 76 ff ff ff       	call   0 <cat>
    exit(0);
  8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  91:	e8 0e 03 00 00       	call   3a4 <exit>
  }

  for(i = 1; i < argc; i++){
  96:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  9d:	00 
  9e:	e9 80 00 00 00       	jmp    123 <main+0xb4>
    if((fd = open(argv[i], 0)) < 0){
  a3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	01 d0                	add    %edx,%eax
  b3:	8b 00                	mov    (%eax),%eax
  b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  bc:	00 
  bd:	89 04 24             	mov    %eax,(%esp)
  c0:	e8 2f 03 00 00       	call   3f4 <open>
  c5:	89 44 24 18          	mov    %eax,0x18(%esp)
  c9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ce:	79 36                	jns    106 <main+0x97>
      printf(1, "cat: cannot open %s\n", argv[i]);
  d0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	01 d0                	add    %edx,%eax
  e0:	8b 00                	mov    (%eax),%eax
  e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  e6:	c7 44 24 04 39 09 00 	movl   $0x939,0x4(%esp)
  ed:	00 
  ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f5:	e8 62 04 00 00       	call   55c <printf>
      exit(0);
  fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 101:	e8 9e 02 00 00       	call   3a4 <exit>
    }
    cat(fd);
 106:	8b 44 24 18          	mov    0x18(%esp),%eax
 10a:	89 04 24             	mov    %eax,(%esp)
 10d:	e8 ee fe ff ff       	call   0 <cat>
    close(fd);
 112:	8b 44 24 18          	mov    0x18(%esp),%eax
 116:	89 04 24             	mov    %eax,(%esp)
 119:	e8 be 02 00 00       	call   3dc <close>
  if(argc <= 1){
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
 11e:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 123:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 127:	3b 45 08             	cmp    0x8(%ebp),%eax
 12a:	0f 8c 73 ff ff ff    	jl     a3 <main+0x34>
      exit(0);
    }
    cat(fd);
    close(fd);
  }
  exit(0);
 130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 137:	e8 68 02 00 00       	call   3a4 <exit>

0000013c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	57                   	push   %edi
 140:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 141:	8b 4d 08             	mov    0x8(%ebp),%ecx
 144:	8b 55 10             	mov    0x10(%ebp),%edx
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	89 cb                	mov    %ecx,%ebx
 14c:	89 df                	mov    %ebx,%edi
 14e:	89 d1                	mov    %edx,%ecx
 150:	fc                   	cld    
 151:	f3 aa                	rep stos %al,%es:(%edi)
 153:	89 ca                	mov    %ecx,%edx
 155:	89 fb                	mov    %edi,%ebx
 157:	89 5d 08             	mov    %ebx,0x8(%ebp)
 15a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15d:	5b                   	pop    %ebx
 15e:	5f                   	pop    %edi
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    

00000161 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 16d:	90                   	nop
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	8d 50 01             	lea    0x1(%eax),%edx
 174:	89 55 08             	mov    %edx,0x8(%ebp)
 177:	8b 55 0c             	mov    0xc(%ebp),%edx
 17a:	8d 4a 01             	lea    0x1(%edx),%ecx
 17d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 180:	0f b6 12             	movzbl (%edx),%edx
 183:	88 10                	mov    %dl,(%eax)
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	84 c0                	test   %al,%al
 18a:	75 e2                	jne    16e <strcpy+0xd>
    ;
  return os;
 18c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 194:	eb 08                	jmp    19e <strcmp+0xd>
    p++, q++;
 196:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	74 10                	je     1b8 <strcmp+0x27>
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 10             	movzbl (%eax),%edx
 1ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	38 c2                	cmp    %al,%dl
 1b6:	74 de                	je     196 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	0f b6 00             	movzbl (%eax),%eax
 1be:	0f b6 d0             	movzbl %al,%edx
 1c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	0f b6 c0             	movzbl %al,%eax
 1ca:	29 c2                	sub    %eax,%edx
 1cc:	89 d0                	mov    %edx,%eax
}
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    

000001d0 <strlen>:

uint
strlen(char *s)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1dd:	eb 04                	jmp    1e3 <strlen+0x13>
 1df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	01 d0                	add    %edx,%eax
 1eb:	0f b6 00             	movzbl (%eax),%eax
 1ee:	84 c0                	test   %al,%al
 1f0:	75 ed                	jne    1df <strlen+0xf>
    ;
  return n;
 1f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f5:	c9                   	leave  
 1f6:	c3                   	ret    

000001f7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1fd:	8b 45 10             	mov    0x10(%ebp),%eax
 200:	89 44 24 08          	mov    %eax,0x8(%esp)
 204:	8b 45 0c             	mov    0xc(%ebp),%eax
 207:	89 44 24 04          	mov    %eax,0x4(%esp)
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	89 04 24             	mov    %eax,(%esp)
 211:	e8 26 ff ff ff       	call   13c <stosb>
  return dst;
 216:	8b 45 08             	mov    0x8(%ebp),%eax
}
 219:	c9                   	leave  
 21a:	c3                   	ret    

0000021b <strchr>:

char*
strchr(const char *s, char c)
{
 21b:	55                   	push   %ebp
 21c:	89 e5                	mov    %esp,%ebp
 21e:	83 ec 04             	sub    $0x4,%esp
 221:	8b 45 0c             	mov    0xc(%ebp),%eax
 224:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 227:	eb 14                	jmp    23d <strchr+0x22>
    if(*s == c)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 232:	75 05                	jne    239 <strchr+0x1e>
      return (char*)s;
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	eb 13                	jmp    24c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 239:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	84 c0                	test   %al,%al
 245:	75 e2                	jne    229 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 247:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <gets>:

char*
gets(char *buf, int max)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 254:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 25b:	eb 4c                	jmp    2a9 <gets+0x5b>
    cc = read(0, &c, 1);
 25d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 264:	00 
 265:	8d 45 ef             	lea    -0x11(%ebp),%eax
 268:	89 44 24 04          	mov    %eax,0x4(%esp)
 26c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 273:	e8 54 01 00 00       	call   3cc <read>
 278:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 27b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27f:	7f 02                	jg     283 <gets+0x35>
      break;
 281:	eb 31                	jmp    2b4 <gets+0x66>
    buf[i++] = c;
 283:	8b 45 f4             	mov    -0xc(%ebp),%eax
 286:	8d 50 01             	lea    0x1(%eax),%edx
 289:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28c:	89 c2                	mov    %eax,%edx
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	01 c2                	add    %eax,%edx
 293:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 297:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 299:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29d:	3c 0a                	cmp    $0xa,%al
 29f:	74 13                	je     2b4 <gets+0x66>
 2a1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a5:	3c 0d                	cmp    $0xd,%al
 2a7:	74 0b                	je     2b4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ac:	83 c0 01             	add    $0x1,%eax
 2af:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b2:	7c a9                	jl     25d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	01 d0                	add    %edx,%eax
 2bc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c2:	c9                   	leave  
 2c3:	c3                   	ret    

000002c4 <stat>:

int
stat(char *n, struct stat *st)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2d1:	00 
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	89 04 24             	mov    %eax,(%esp)
 2d8:	e8 17 01 00 00       	call   3f4 <open>
 2dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e4:	79 07                	jns    2ed <stat+0x29>
    return -1;
 2e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2eb:	eb 23                	jmp    310 <stat+0x4c>
  r = fstat(fd, st);
 2ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f7:	89 04 24             	mov    %eax,(%esp)
 2fa:	e8 0d 01 00 00       	call   40c <fstat>
 2ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 302:	8b 45 f4             	mov    -0xc(%ebp),%eax
 305:	89 04 24             	mov    %eax,(%esp)
 308:	e8 cf 00 00 00       	call   3dc <close>
  return r;
 30d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 310:	c9                   	leave  
 311:	c3                   	ret    

00000312 <atoi>:

int
atoi(const char *s)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 318:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31f:	eb 25                	jmp    346 <atoi+0x34>
    n = n*10 + *s++ - '0';
 321:	8b 55 fc             	mov    -0x4(%ebp),%edx
 324:	89 d0                	mov    %edx,%eax
 326:	c1 e0 02             	shl    $0x2,%eax
 329:	01 d0                	add    %edx,%eax
 32b:	01 c0                	add    %eax,%eax
 32d:	89 c1                	mov    %eax,%ecx
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	8d 50 01             	lea    0x1(%eax),%edx
 335:	89 55 08             	mov    %edx,0x8(%ebp)
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	0f be c0             	movsbl %al,%eax
 33e:	01 c8                	add    %ecx,%eax
 340:	83 e8 30             	sub    $0x30,%eax
 343:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	0f b6 00             	movzbl (%eax),%eax
 34c:	3c 2f                	cmp    $0x2f,%al
 34e:	7e 0a                	jle    35a <atoi+0x48>
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	0f b6 00             	movzbl (%eax),%eax
 356:	3c 39                	cmp    $0x39,%al
 358:	7e c7                	jle    321 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 35a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35d:	c9                   	leave  
 35e:	c3                   	ret    

0000035f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 36b:	8b 45 0c             	mov    0xc(%ebp),%eax
 36e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 371:	eb 17                	jmp    38a <memmove+0x2b>
    *dst++ = *src++;
 373:	8b 45 fc             	mov    -0x4(%ebp),%eax
 376:	8d 50 01             	lea    0x1(%eax),%edx
 379:	89 55 fc             	mov    %edx,-0x4(%ebp)
 37c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37f:	8d 4a 01             	lea    0x1(%edx),%ecx
 382:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 385:	0f b6 12             	movzbl (%edx),%edx
 388:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38a:	8b 45 10             	mov    0x10(%ebp),%eax
 38d:	8d 50 ff             	lea    -0x1(%eax),%edx
 390:	89 55 10             	mov    %edx,0x10(%ebp)
 393:	85 c0                	test   %eax,%eax
 395:	7f dc                	jg     373 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 397:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 39c:	b8 01 00 00 00       	mov    $0x1,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <exit>:
SYSCALL(exit)
 3a4:	b8 02 00 00 00       	mov    $0x2,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <wait>:
SYSCALL(wait)
 3ac:	b8 03 00 00 00       	mov    $0x3,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <waitpid>:
SYSCALL(waitpid)
 3b4:	b8 16 00 00 00       	mov    $0x16,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <wait_stat>:
SYSCALL(wait_stat)
 3bc:	b8 17 00 00 00       	mov    $0x17,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <pipe>:
SYSCALL(pipe)
 3c4:	b8 04 00 00 00       	mov    $0x4,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <read>:
SYSCALL(read)
 3cc:	b8 05 00 00 00       	mov    $0x5,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <write>:
SYSCALL(write)
 3d4:	b8 10 00 00 00       	mov    $0x10,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <close>:
SYSCALL(close)
 3dc:	b8 15 00 00 00       	mov    $0x15,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <kill>:
SYSCALL(kill)
 3e4:	b8 06 00 00 00       	mov    $0x6,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <exec>:
SYSCALL(exec)
 3ec:	b8 07 00 00 00       	mov    $0x7,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <open>:
SYSCALL(open)
 3f4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <mknod>:
SYSCALL(mknod)
 3fc:	b8 11 00 00 00       	mov    $0x11,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <unlink>:
SYSCALL(unlink)
 404:	b8 12 00 00 00       	mov    $0x12,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <fstat>:
SYSCALL(fstat)
 40c:	b8 08 00 00 00       	mov    $0x8,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <link>:
SYSCALL(link)
 414:	b8 13 00 00 00       	mov    $0x13,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <mkdir>:
SYSCALL(mkdir)
 41c:	b8 14 00 00 00       	mov    $0x14,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <chdir>:
SYSCALL(chdir)
 424:	b8 09 00 00 00       	mov    $0x9,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <dup>:
SYSCALL(dup)
 42c:	b8 0a 00 00 00       	mov    $0xa,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <getpid>:
SYSCALL(getpid)
 434:	b8 0b 00 00 00       	mov    $0xb,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <sbrk>:
SYSCALL(sbrk)
 43c:	b8 0c 00 00 00       	mov    $0xc,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <set_priority>:
SYSCALL(set_priority)
 444:	b8 18 00 00 00       	mov    $0x18,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <canRemoveJob>:
SYSCALL(canRemoveJob)
 44c:	b8 19 00 00 00       	mov    $0x19,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <jobs>:
SYSCALL(jobs)
 454:	b8 1a 00 00 00       	mov    $0x1a,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <sleep>:
SYSCALL(sleep)
 45c:	b8 0d 00 00 00       	mov    $0xd,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <uptime>:
SYSCALL(uptime)
 464:	b8 0e 00 00 00       	mov    $0xe,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <gidpid>:
SYSCALL(gidpid)
 46c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <isShell>:
SYSCALL(isShell)
 474:	b8 1c 00 00 00       	mov    $0x1c,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 47c:	55                   	push   %ebp
 47d:	89 e5                	mov    %esp,%ebp
 47f:	83 ec 18             	sub    $0x18,%esp
 482:	8b 45 0c             	mov    0xc(%ebp),%eax
 485:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 488:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 48f:	00 
 490:	8d 45 f4             	lea    -0xc(%ebp),%eax
 493:	89 44 24 04          	mov    %eax,0x4(%esp)
 497:	8b 45 08             	mov    0x8(%ebp),%eax
 49a:	89 04 24             	mov    %eax,(%esp)
 49d:	e8 32 ff ff ff       	call   3d4 <write>
}
 4a2:	c9                   	leave  
 4a3:	c3                   	ret    

000004a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	56                   	push   %esi
 4a8:	53                   	push   %ebx
 4a9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4b3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b7:	74 17                	je     4d0 <printint+0x2c>
 4b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4bd:	79 11                	jns    4d0 <printint+0x2c>
    neg = 1;
 4bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c9:	f7 d8                	neg    %eax
 4cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ce:	eb 06                	jmp    4d6 <printint+0x32>
  } else {
    x = xx;
 4d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4dd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4e0:	8d 41 01             	lea    0x1(%ecx),%eax
 4e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ec:	ba 00 00 00 00       	mov    $0x0,%edx
 4f1:	f7 f3                	div    %ebx
 4f3:	89 d0                	mov    %edx,%eax
 4f5:	0f b6 80 bc 0b 00 00 	movzbl 0xbbc(%eax),%eax
 4fc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 500:	8b 75 10             	mov    0x10(%ebp),%esi
 503:	8b 45 ec             	mov    -0x14(%ebp),%eax
 506:	ba 00 00 00 00       	mov    $0x0,%edx
 50b:	f7 f6                	div    %esi
 50d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 510:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 514:	75 c7                	jne    4dd <printint+0x39>
  if(neg)
 516:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 51a:	74 10                	je     52c <printint+0x88>
    buf[i++] = '-';
 51c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51f:	8d 50 01             	lea    0x1(%eax),%edx
 522:	89 55 f4             	mov    %edx,-0xc(%ebp)
 525:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 52a:	eb 1f                	jmp    54b <printint+0xa7>
 52c:	eb 1d                	jmp    54b <printint+0xa7>
    putc(fd, buf[i]);
 52e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 531:	8b 45 f4             	mov    -0xc(%ebp),%eax
 534:	01 d0                	add    %edx,%eax
 536:	0f b6 00             	movzbl (%eax),%eax
 539:	0f be c0             	movsbl %al,%eax
 53c:	89 44 24 04          	mov    %eax,0x4(%esp)
 540:	8b 45 08             	mov    0x8(%ebp),%eax
 543:	89 04 24             	mov    %eax,(%esp)
 546:	e8 31 ff ff ff       	call   47c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 54b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 54f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 553:	79 d9                	jns    52e <printint+0x8a>
    putc(fd, buf[i]);
}
 555:	83 c4 30             	add    $0x30,%esp
 558:	5b                   	pop    %ebx
 559:	5e                   	pop    %esi
 55a:	5d                   	pop    %ebp
 55b:	c3                   	ret    

0000055c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 55c:	55                   	push   %ebp
 55d:	89 e5                	mov    %esp,%ebp
 55f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 562:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 569:	8d 45 0c             	lea    0xc(%ebp),%eax
 56c:	83 c0 04             	add    $0x4,%eax
 56f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 572:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 579:	e9 7c 01 00 00       	jmp    6fa <printf+0x19e>
    c = fmt[i] & 0xff;
 57e:	8b 55 0c             	mov    0xc(%ebp),%edx
 581:	8b 45 f0             	mov    -0x10(%ebp),%eax
 584:	01 d0                	add    %edx,%eax
 586:	0f b6 00             	movzbl (%eax),%eax
 589:	0f be c0             	movsbl %al,%eax
 58c:	25 ff 00 00 00       	and    $0xff,%eax
 591:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 594:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 598:	75 2c                	jne    5c6 <printf+0x6a>
      if(c == '%'){
 59a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 59e:	75 0c                	jne    5ac <printf+0x50>
        state = '%';
 5a0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a7:	e9 4a 01 00 00       	jmp    6f6 <printf+0x19a>
      } else {
        putc(fd, c);
 5ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5af:	0f be c0             	movsbl %al,%eax
 5b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	89 04 24             	mov    %eax,(%esp)
 5bc:	e8 bb fe ff ff       	call   47c <putc>
 5c1:	e9 30 01 00 00       	jmp    6f6 <printf+0x19a>
      }
    } else if(state == '%'){
 5c6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ca:	0f 85 26 01 00 00    	jne    6f6 <printf+0x19a>
      if(c == 'd'){
 5d0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5d4:	75 2d                	jne    603 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d9:	8b 00                	mov    (%eax),%eax
 5db:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5e2:	00 
 5e3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ea:	00 
 5eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	89 04 24             	mov    %eax,(%esp)
 5f5:	e8 aa fe ff ff       	call   4a4 <printint>
        ap++;
 5fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fe:	e9 ec 00 00 00       	jmp    6ef <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 603:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 607:	74 06                	je     60f <printf+0xb3>
 609:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 60d:	75 2d                	jne    63c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 60f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 612:	8b 00                	mov    (%eax),%eax
 614:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 61b:	00 
 61c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 623:	00 
 624:	89 44 24 04          	mov    %eax,0x4(%esp)
 628:	8b 45 08             	mov    0x8(%ebp),%eax
 62b:	89 04 24             	mov    %eax,(%esp)
 62e:	e8 71 fe ff ff       	call   4a4 <printint>
        ap++;
 633:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 637:	e9 b3 00 00 00       	jmp    6ef <printf+0x193>
      } else if(c == 's'){
 63c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 640:	75 45                	jne    687 <printf+0x12b>
        s = (char*)*ap;
 642:	8b 45 e8             	mov    -0x18(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 64a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 64e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 652:	75 09                	jne    65d <printf+0x101>
          s = "(null)";
 654:	c7 45 f4 4e 09 00 00 	movl   $0x94e,-0xc(%ebp)
        while(*s != 0){
 65b:	eb 1e                	jmp    67b <printf+0x11f>
 65d:	eb 1c                	jmp    67b <printf+0x11f>
          putc(fd, *s);
 65f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 662:	0f b6 00             	movzbl (%eax),%eax
 665:	0f be c0             	movsbl %al,%eax
 668:	89 44 24 04          	mov    %eax,0x4(%esp)
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	89 04 24             	mov    %eax,(%esp)
 672:	e8 05 fe ff ff       	call   47c <putc>
          s++;
 677:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 67b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67e:	0f b6 00             	movzbl (%eax),%eax
 681:	84 c0                	test   %al,%al
 683:	75 da                	jne    65f <printf+0x103>
 685:	eb 68                	jmp    6ef <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 687:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 68b:	75 1d                	jne    6aa <printf+0x14e>
        putc(fd, *ap);
 68d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	0f be c0             	movsbl %al,%eax
 695:	89 44 24 04          	mov    %eax,0x4(%esp)
 699:	8b 45 08             	mov    0x8(%ebp),%eax
 69c:	89 04 24             	mov    %eax,(%esp)
 69f:	e8 d8 fd ff ff       	call   47c <putc>
        ap++;
 6a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a8:	eb 45                	jmp    6ef <printf+0x193>
      } else if(c == '%'){
 6aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ae:	75 17                	jne    6c7 <printf+0x16b>
        putc(fd, c);
 6b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b3:	0f be c0             	movsbl %al,%eax
 6b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	89 04 24             	mov    %eax,(%esp)
 6c0:	e8 b7 fd ff ff       	call   47c <putc>
 6c5:	eb 28                	jmp    6ef <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6ce:	00 
 6cf:	8b 45 08             	mov    0x8(%ebp),%eax
 6d2:	89 04 24             	mov    %eax,(%esp)
 6d5:	e8 a2 fd ff ff       	call   47c <putc>
        putc(fd, c);
 6da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6dd:	0f be c0             	movsbl %al,%eax
 6e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e4:	8b 45 08             	mov    0x8(%ebp),%eax
 6e7:	89 04 24             	mov    %eax,(%esp)
 6ea:	e8 8d fd ff ff       	call   47c <putc>
      }
      state = 0;
 6ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 700:	01 d0                	add    %edx,%eax
 702:	0f b6 00             	movzbl (%eax),%eax
 705:	84 c0                	test   %al,%al
 707:	0f 85 71 fe ff ff    	jne    57e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 70d:	c9                   	leave  
 70e:	c3                   	ret    

0000070f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70f:	55                   	push   %ebp
 710:	89 e5                	mov    %esp,%ebp
 712:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	83 e8 08             	sub    $0x8,%eax
 71b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 723:	89 45 fc             	mov    %eax,-0x4(%ebp)
 726:	eb 24                	jmp    74c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 730:	77 12                	ja     744 <free+0x35>
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 738:	77 24                	ja     75e <free+0x4f>
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 00                	mov    (%eax),%eax
 73f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 742:	77 1a                	ja     75e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 752:	76 d4                	jbe    728 <free+0x19>
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75c:	76 ca                	jbe    728 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	8b 40 04             	mov    0x4(%eax),%eax
 764:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	01 c2                	add    %eax,%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	39 c2                	cmp    %eax,%edx
 777:	75 24                	jne    79d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 779:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77c:	8b 50 04             	mov    0x4(%eax),%edx
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	01 c2                	add    %eax,%edx
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	8b 00                	mov    (%eax),%eax
 794:	8b 10                	mov    (%eax),%edx
 796:	8b 45 f8             	mov    -0x8(%ebp),%eax
 799:	89 10                	mov    %edx,(%eax)
 79b:	eb 0a                	jmp    7a7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 10                	mov    (%eax),%edx
 7a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	01 d0                	add    %edx,%eax
 7b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7bc:	75 20                	jne    7de <free+0xcf>
    p->s.size += bp->s.size;
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 50 04             	mov    0x4(%eax),%edx
 7c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	01 c2                	add    %eax,%edx
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	8b 10                	mov    (%eax),%edx
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	89 10                	mov    %edx,(%eax)
 7dc:	eb 08                	jmp    7e6 <free+0xd7>
  } else
    p->s.ptr = bp;
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e4:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	a3 e8 0b 00 00       	mov    %eax,0xbe8
}
 7ee:	c9                   	leave  
 7ef:	c3                   	ret    

000007f0 <morecore>:

static Header*
morecore(uint nu)
{
 7f0:	55                   	push   %ebp
 7f1:	89 e5                	mov    %esp,%ebp
 7f3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7fd:	77 07                	ja     806 <morecore+0x16>
    nu = 4096;
 7ff:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 806:	8b 45 08             	mov    0x8(%ebp),%eax
 809:	c1 e0 03             	shl    $0x3,%eax
 80c:	89 04 24             	mov    %eax,(%esp)
 80f:	e8 28 fc ff ff       	call   43c <sbrk>
 814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 817:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 81b:	75 07                	jne    824 <morecore+0x34>
    return 0;
 81d:	b8 00 00 00 00       	mov    $0x0,%eax
 822:	eb 22                	jmp    846 <morecore+0x56>
  hp = (Header*)p;
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 82a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82d:	8b 55 08             	mov    0x8(%ebp),%edx
 830:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	83 c0 08             	add    $0x8,%eax
 839:	89 04 24             	mov    %eax,(%esp)
 83c:	e8 ce fe ff ff       	call   70f <free>
  return freep;
 841:	a1 e8 0b 00 00       	mov    0xbe8,%eax
}
 846:	c9                   	leave  
 847:	c3                   	ret    

00000848 <malloc>:

void*
malloc(uint nbytes)
{
 848:	55                   	push   %ebp
 849:	89 e5                	mov    %esp,%ebp
 84b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84e:	8b 45 08             	mov    0x8(%ebp),%eax
 851:	83 c0 07             	add    $0x7,%eax
 854:	c1 e8 03             	shr    $0x3,%eax
 857:	83 c0 01             	add    $0x1,%eax
 85a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 85d:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 862:	89 45 f0             	mov    %eax,-0x10(%ebp)
 865:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 869:	75 23                	jne    88e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86b:	c7 45 f0 e0 0b 00 00 	movl   $0xbe0,-0x10(%ebp)
 872:	8b 45 f0             	mov    -0x10(%ebp),%eax
 875:	a3 e8 0b 00 00       	mov    %eax,0xbe8
 87a:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 87f:	a3 e0 0b 00 00       	mov    %eax,0xbe0
    base.s.size = 0;
 884:	c7 05 e4 0b 00 00 00 	movl   $0x0,0xbe4
 88b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 891:	8b 00                	mov    (%eax),%eax
 893:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	8b 40 04             	mov    0x4(%eax),%eax
 89c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89f:	72 4d                	jb     8ee <malloc+0xa6>
      if(p->s.size == nunits)
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	8b 40 04             	mov    0x4(%eax),%eax
 8a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8aa:	75 0c                	jne    8b8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 10                	mov    (%eax),%edx
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	89 10                	mov    %edx,(%eax)
 8b6:	eb 26                	jmp    8de <malloc+0x96>
      else {
        p->s.size -= nunits;
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	8b 40 04             	mov    0x4(%eax),%eax
 8be:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c1:	89 c2                	mov    %eax,%edx
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	8b 40 04             	mov    0x4(%eax),%eax
 8cf:	c1 e0 03             	shl    $0x3,%eax
 8d2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8db:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e1:	a3 e8 0b 00 00       	mov    %eax,0xbe8
      return (void*)(p + 1);
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	83 c0 08             	add    $0x8,%eax
 8ec:	eb 38                	jmp    926 <malloc+0xde>
    }
    if(p == freep)
 8ee:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 8f3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f6:	75 1b                	jne    913 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8fb:	89 04 24             	mov    %eax,(%esp)
 8fe:	e8 ed fe ff ff       	call   7f0 <morecore>
 903:	89 45 f4             	mov    %eax,-0xc(%ebp)
 906:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90a:	75 07                	jne    913 <malloc+0xcb>
        return 0;
 90c:	b8 00 00 00 00       	mov    $0x0,%eax
 911:	eb 13                	jmp    926 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	89 45 f0             	mov    %eax,-0x10(%ebp)
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 921:	e9 70 ff ff ff       	jmp    896 <malloc+0x4e>
}
 926:	c9                   	leave  
 927:	c3                   	ret    
