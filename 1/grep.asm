
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bb 00 00 00       	jmp    cd <grep+0xcd>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 a0 0e 00 00 	movl   $0xea0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 51                	jmp    72 <grep+0x72>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 d8 01 00 00       	call   211 <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2c                	je     69 <grep+0x69>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	83 c0 01             	add    $0x1,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4e:	29 c2                	sub    %eax,%edx
  50:	89 d0                	mov    %edx,%eax
  52:	89 44 24 08          	mov    %eax,0x8(%esp)
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	89 44 24 04          	mov    %eax,0x4(%esp)
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 a0 05 00 00       	call   609 <write>
      }
      p = q+1;
  69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6c:	83 c0 01             	add    $0x1,%eax
  6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  72:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  79:	00 
  7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7d:	89 04 24             	mov    %eax,(%esp)
  80:	e8 cb 03 00 00       	call   450 <strchr>
  85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8c:	75 93                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8e:	81 7d f0 a0 0e 00 00 	cmpl   $0xea0,-0x10(%ebp)
  95:	75 07                	jne    9e <grep+0x9e>
      m = 0;
  97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	7e 29                	jle    cd <grep+0xcd>
      m -= p - buf;
  a4:	ba a0 0e 00 00       	mov    $0xea0,%edx
  a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ac:	29 c2                	sub    %eax,%edx
  ae:	89 d0                	mov    %edx,%eax
  b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  c1:	c7 04 24 a0 0e 00 00 	movl   $0xea0,(%esp)
  c8:	e8 c7 04 00 00       	call   594 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d0:	ba 00 04 00 00       	mov    $0x400,%edx
  d5:	29 c2                	sub    %eax,%edx
  d7:	89 d0                	mov    %edx,%eax
  d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  dc:	81 c2 a0 0e 00 00    	add    $0xea0,%edx
  e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	89 04 24             	mov    %eax,(%esp)
  f0:	e8 0c 05 00 00       	call   601 <read>
  f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  fc:	0f 8f 10 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 102:	c9                   	leave  
 103:	c3                   	ret    

00000104 <main>:

int
main(int argc, char *argv[])
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 e4 f0             	and    $0xfffffff0,%esp
 10a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 10d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 111:	7f 20                	jg     133 <main+0x2f>
    printf(2, "usage: grep pattern [file ...]\n");
 113:	c7 44 24 04 60 0b 00 	movl   $0xb60,0x4(%esp)
 11a:	00 
 11b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 122:	e8 6a 06 00 00       	call   791 <printf>
    exit(0);
 127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 12e:	e8 a6 04 00 00       	call   5d9 <exit>
  }
  pattern = argv[1];
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	8b 40 04             	mov    0x4(%eax),%eax
 139:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 13d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 141:	7f 20                	jg     163 <main+0x5f>
    grep(pattern, 0);
 143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14a:	00 
 14b:	8b 44 24 18          	mov    0x18(%esp),%eax
 14f:	89 04 24             	mov    %eax,(%esp)
 152:	e8 a9 fe ff ff       	call   0 <grep>
    exit(0);
 157:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15e:	e8 76 04 00 00       	call   5d9 <exit>
  }

  for(i = 2; i < argc; i++){
 163:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 16a:	00 
 16b:	e9 88 00 00 00       	jmp    1f8 <main+0xf4>
    if((fd = open(argv[i], 0)) < 0){
 170:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 17b:	8b 45 0c             	mov    0xc(%ebp),%eax
 17e:	01 d0                	add    %edx,%eax
 180:	8b 00                	mov    (%eax),%eax
 182:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 189:	00 
 18a:	89 04 24             	mov    %eax,(%esp)
 18d:	e8 97 04 00 00       	call   629 <open>
 192:	89 44 24 14          	mov    %eax,0x14(%esp)
 196:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 19b:	79 36                	jns    1d3 <main+0xcf>
      printf(1, "grep: cannot open %s\n", argv[i]);
 19d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ab:	01 d0                	add    %edx,%eax
 1ad:	8b 00                	mov    (%eax),%eax
 1af:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b3:	c7 44 24 04 80 0b 00 	movl   $0xb80,0x4(%esp)
 1ba:	00 
 1bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c2:	e8 ca 05 00 00       	call   791 <printf>
      exit(0);
 1c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1ce:	e8 06 04 00 00       	call   5d9 <exit>
    }
    grep(pattern, fd);
 1d3:	8b 44 24 14          	mov    0x14(%esp),%eax
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	8b 44 24 18          	mov    0x18(%esp),%eax
 1df:	89 04 24             	mov    %eax,(%esp)
 1e2:	e8 19 fe ff ff       	call   0 <grep>
    close(fd);
 1e7:	8b 44 24 14          	mov    0x14(%esp),%eax
 1eb:	89 04 24             	mov    %eax,(%esp)
 1ee:	e8 1e 04 00 00       	call   611 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit(0);
  }

  for(i = 2; i < argc; i++){
 1f3:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1f8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1fc:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ff:	0f 8c 6b ff ff ff    	jl     170 <main+0x6c>
      exit(0);
    }
    grep(pattern, fd);
    close(fd);
  }
  exit(0);
 205:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 20c:	e8 c8 03 00 00       	call   5d9 <exit>

00000211 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
 214:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	0f b6 00             	movzbl (%eax),%eax
 21d:	3c 5e                	cmp    $0x5e,%al
 21f:	75 17                	jne    238 <match+0x27>
    return matchhere(re+1, text);
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	8d 50 01             	lea    0x1(%eax),%edx
 227:	8b 45 0c             	mov    0xc(%ebp),%eax
 22a:	89 44 24 04          	mov    %eax,0x4(%esp)
 22e:	89 14 24             	mov    %edx,(%esp)
 231:	e8 36 00 00 00       	call   26c <matchhere>
 236:	eb 32                	jmp    26a <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	89 44 24 04          	mov    %eax,0x4(%esp)
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	89 04 24             	mov    %eax,(%esp)
 245:	e8 22 00 00 00       	call   26c <matchhere>
 24a:	85 c0                	test   %eax,%eax
 24c:	74 07                	je     255 <match+0x44>
      return 1;
 24e:	b8 01 00 00 00       	mov    $0x1,%eax
 253:	eb 15                	jmp    26a <match+0x59>
  }while(*text++ != '\0');
 255:	8b 45 0c             	mov    0xc(%ebp),%eax
 258:	8d 50 01             	lea    0x1(%eax),%edx
 25b:	89 55 0c             	mov    %edx,0xc(%ebp)
 25e:	0f b6 00             	movzbl (%eax),%eax
 261:	84 c0                	test   %al,%al
 263:	75 d3                	jne    238 <match+0x27>
  return 0;
 265:	b8 00 00 00 00       	mov    $0x0,%eax
}
 26a:	c9                   	leave  
 26b:	c3                   	ret    

0000026c <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 26c:	55                   	push   %ebp
 26d:	89 e5                	mov    %esp,%ebp
 26f:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	84 c0                	test   %al,%al
 27a:	75 0a                	jne    286 <matchhere+0x1a>
    return 1;
 27c:	b8 01 00 00 00       	mov    $0x1,%eax
 281:	e9 9b 00 00 00       	jmp    321 <matchhere+0xb5>
  if(re[1] == '*')
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2a                	cmp    $0x2a,%al
 291:	75 24                	jne    2b7 <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	8d 48 02             	lea    0x2(%eax),%ecx
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	0f be c0             	movsbl %al,%eax
 2a2:	8b 55 0c             	mov    0xc(%ebp),%edx
 2a5:	89 54 24 08          	mov    %edx,0x8(%esp)
 2a9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 2ad:	89 04 24             	mov    %eax,(%esp)
 2b0:	e8 6e 00 00 00       	call   323 <matchstar>
 2b5:	eb 6a                	jmp    321 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 00             	movzbl (%eax),%eax
 2bd:	3c 24                	cmp    $0x24,%al
 2bf:	75 1d                	jne    2de <matchhere+0x72>
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	83 c0 01             	add    $0x1,%eax
 2c7:	0f b6 00             	movzbl (%eax),%eax
 2ca:	84 c0                	test   %al,%al
 2cc:	75 10                	jne    2de <matchhere+0x72>
    return *text == '\0';
 2ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	84 c0                	test   %al,%al
 2d6:	0f 94 c0             	sete   %al
 2d9:	0f b6 c0             	movzbl %al,%eax
 2dc:	eb 43                	jmp    321 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2de:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	84 c0                	test   %al,%al
 2e6:	74 34                	je     31c <matchhere+0xb0>
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	0f b6 00             	movzbl (%eax),%eax
 2ee:	3c 2e                	cmp    $0x2e,%al
 2f0:	74 10                	je     302 <matchhere+0x96>
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	0f b6 10             	movzbl (%eax),%edx
 2f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fb:	0f b6 00             	movzbl (%eax),%eax
 2fe:	38 c2                	cmp    %al,%dl
 300:	75 1a                	jne    31c <matchhere+0xb0>
    return matchhere(re+1, text+1);
 302:	8b 45 0c             	mov    0xc(%ebp),%eax
 305:	8d 50 01             	lea    0x1(%eax),%edx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	83 c0 01             	add    $0x1,%eax
 30e:	89 54 24 04          	mov    %edx,0x4(%esp)
 312:	89 04 24             	mov    %eax,(%esp)
 315:	e8 52 ff ff ff       	call   26c <matchhere>
 31a:	eb 05                	jmp    321 <matchhere+0xb5>
  return 0;
 31c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 321:	c9                   	leave  
 322:	c3                   	ret    

00000323 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 323:	55                   	push   %ebp
 324:	89 e5                	mov    %esp,%ebp
 326:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 329:	8b 45 10             	mov    0x10(%ebp),%eax
 32c:	89 44 24 04          	mov    %eax,0x4(%esp)
 330:	8b 45 0c             	mov    0xc(%ebp),%eax
 333:	89 04 24             	mov    %eax,(%esp)
 336:	e8 31 ff ff ff       	call   26c <matchhere>
 33b:	85 c0                	test   %eax,%eax
 33d:	74 07                	je     346 <matchstar+0x23>
      return 1;
 33f:	b8 01 00 00 00       	mov    $0x1,%eax
 344:	eb 29                	jmp    36f <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 346:	8b 45 10             	mov    0x10(%ebp),%eax
 349:	0f b6 00             	movzbl (%eax),%eax
 34c:	84 c0                	test   %al,%al
 34e:	74 1a                	je     36a <matchstar+0x47>
 350:	8b 45 10             	mov    0x10(%ebp),%eax
 353:	8d 50 01             	lea    0x1(%eax),%edx
 356:	89 55 10             	mov    %edx,0x10(%ebp)
 359:	0f b6 00             	movzbl (%eax),%eax
 35c:	0f be c0             	movsbl %al,%eax
 35f:	3b 45 08             	cmp    0x8(%ebp),%eax
 362:	74 c5                	je     329 <matchstar+0x6>
 364:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 368:	74 bf                	je     329 <matchstar+0x6>
  return 0;
 36a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 36f:	c9                   	leave  
 370:	c3                   	ret    

00000371 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 371:	55                   	push   %ebp
 372:	89 e5                	mov    %esp,%ebp
 374:	57                   	push   %edi
 375:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 376:	8b 4d 08             	mov    0x8(%ebp),%ecx
 379:	8b 55 10             	mov    0x10(%ebp),%edx
 37c:	8b 45 0c             	mov    0xc(%ebp),%eax
 37f:	89 cb                	mov    %ecx,%ebx
 381:	89 df                	mov    %ebx,%edi
 383:	89 d1                	mov    %edx,%ecx
 385:	fc                   	cld    
 386:	f3 aa                	rep stos %al,%es:(%edi)
 388:	89 ca                	mov    %ecx,%edx
 38a:	89 fb                	mov    %edi,%ebx
 38c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 38f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 392:	5b                   	pop    %ebx
 393:	5f                   	pop    %edi
 394:	5d                   	pop    %ebp
 395:	c3                   	ret    

00000396 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 396:	55                   	push   %ebp
 397:	89 e5                	mov    %esp,%ebp
 399:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3a2:	90                   	nop
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	8d 50 01             	lea    0x1(%eax),%edx
 3a9:	89 55 08             	mov    %edx,0x8(%ebp)
 3ac:	8b 55 0c             	mov    0xc(%ebp),%edx
 3af:	8d 4a 01             	lea    0x1(%edx),%ecx
 3b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3b5:	0f b6 12             	movzbl (%edx),%edx
 3b8:	88 10                	mov    %dl,(%eax)
 3ba:	0f b6 00             	movzbl (%eax),%eax
 3bd:	84 c0                	test   %al,%al
 3bf:	75 e2                	jne    3a3 <strcpy+0xd>
    ;
  return os;
 3c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c4:	c9                   	leave  
 3c5:	c3                   	ret    

000003c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c6:	55                   	push   %ebp
 3c7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3c9:	eb 08                	jmp    3d3 <strcmp+0xd>
    p++, q++;
 3cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3cf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	84 c0                	test   %al,%al
 3db:	74 10                	je     3ed <strcmp+0x27>
 3dd:	8b 45 08             	mov    0x8(%ebp),%eax
 3e0:	0f b6 10             	movzbl (%eax),%edx
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	38 c2                	cmp    %al,%dl
 3eb:	74 de                	je     3cb <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	0f b6 00             	movzbl (%eax),%eax
 3f3:	0f b6 d0             	movzbl %al,%edx
 3f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f9:	0f b6 00             	movzbl (%eax),%eax
 3fc:	0f b6 c0             	movzbl %al,%eax
 3ff:	29 c2                	sub    %eax,%edx
 401:	89 d0                	mov    %edx,%eax
}
 403:	5d                   	pop    %ebp
 404:	c3                   	ret    

00000405 <strlen>:

uint
strlen(char *s)
{
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
 408:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 40b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 412:	eb 04                	jmp    418 <strlen+0x13>
 414:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 418:	8b 55 fc             	mov    -0x4(%ebp),%edx
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
 41e:	01 d0                	add    %edx,%eax
 420:	0f b6 00             	movzbl (%eax),%eax
 423:	84 c0                	test   %al,%al
 425:	75 ed                	jne    414 <strlen+0xf>
    ;
  return n;
 427:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 42a:	c9                   	leave  
 42b:	c3                   	ret    

0000042c <memset>:

void*
memset(void *dst, int c, uint n)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 432:	8b 45 10             	mov    0x10(%ebp),%eax
 435:	89 44 24 08          	mov    %eax,0x8(%esp)
 439:	8b 45 0c             	mov    0xc(%ebp),%eax
 43c:	89 44 24 04          	mov    %eax,0x4(%esp)
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	89 04 24             	mov    %eax,(%esp)
 446:	e8 26 ff ff ff       	call   371 <stosb>
  return dst;
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 44e:	c9                   	leave  
 44f:	c3                   	ret    

00000450 <strchr>:

char*
strchr(const char *s, char c)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	83 ec 04             	sub    $0x4,%esp
 456:	8b 45 0c             	mov    0xc(%ebp),%eax
 459:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 45c:	eb 14                	jmp    472 <strchr+0x22>
    if(*s == c)
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	0f b6 00             	movzbl (%eax),%eax
 464:	3a 45 fc             	cmp    -0x4(%ebp),%al
 467:	75 05                	jne    46e <strchr+0x1e>
      return (char*)s;
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	eb 13                	jmp    481 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 46e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 472:	8b 45 08             	mov    0x8(%ebp),%eax
 475:	0f b6 00             	movzbl (%eax),%eax
 478:	84 c0                	test   %al,%al
 47a:	75 e2                	jne    45e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 47c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 481:	c9                   	leave  
 482:	c3                   	ret    

00000483 <gets>:

char*
gets(char *buf, int max)
{
 483:	55                   	push   %ebp
 484:	89 e5                	mov    %esp,%ebp
 486:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 489:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 490:	eb 4c                	jmp    4de <gets+0x5b>
    cc = read(0, &c, 1);
 492:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 499:	00 
 49a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 49d:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4a8:	e8 54 01 00 00       	call   601 <read>
 4ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b4:	7f 02                	jg     4b8 <gets+0x35>
      break;
 4b6:	eb 31                	jmp    4e9 <gets+0x66>
    buf[i++] = c;
 4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bb:	8d 50 01             	lea    0x1(%eax),%edx
 4be:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c1:	89 c2                	mov    %eax,%edx
 4c3:	8b 45 08             	mov    0x8(%ebp),%eax
 4c6:	01 c2                	add    %eax,%edx
 4c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4cc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4ce:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4d2:	3c 0a                	cmp    $0xa,%al
 4d4:	74 13                	je     4e9 <gets+0x66>
 4d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4da:	3c 0d                	cmp    $0xd,%al
 4dc:	74 0b                	je     4e9 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e1:	83 c0 01             	add    $0x1,%eax
 4e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4e7:	7c a9                	jl     492 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
 4ef:	01 d0                	add    %edx,%eax
 4f1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4f7:	c9                   	leave  
 4f8:	c3                   	ret    

000004f9 <stat>:

int
stat(char *n, struct stat *st)
{
 4f9:	55                   	push   %ebp
 4fa:	89 e5                	mov    %esp,%ebp
 4fc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 506:	00 
 507:	8b 45 08             	mov    0x8(%ebp),%eax
 50a:	89 04 24             	mov    %eax,(%esp)
 50d:	e8 17 01 00 00       	call   629 <open>
 512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 519:	79 07                	jns    522 <stat+0x29>
    return -1;
 51b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 520:	eb 23                	jmp    545 <stat+0x4c>
  r = fstat(fd, st);
 522:	8b 45 0c             	mov    0xc(%ebp),%eax
 525:	89 44 24 04          	mov    %eax,0x4(%esp)
 529:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52c:	89 04 24             	mov    %eax,(%esp)
 52f:	e8 0d 01 00 00       	call   641 <fstat>
 534:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	89 04 24             	mov    %eax,(%esp)
 53d:	e8 cf 00 00 00       	call   611 <close>
  return r;
 542:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 545:	c9                   	leave  
 546:	c3                   	ret    

00000547 <atoi>:

int
atoi(const char *s)
{
 547:	55                   	push   %ebp
 548:	89 e5                	mov    %esp,%ebp
 54a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 54d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 554:	eb 25                	jmp    57b <atoi+0x34>
    n = n*10 + *s++ - '0';
 556:	8b 55 fc             	mov    -0x4(%ebp),%edx
 559:	89 d0                	mov    %edx,%eax
 55b:	c1 e0 02             	shl    $0x2,%eax
 55e:	01 d0                	add    %edx,%eax
 560:	01 c0                	add    %eax,%eax
 562:	89 c1                	mov    %eax,%ecx
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	8d 50 01             	lea    0x1(%eax),%edx
 56a:	89 55 08             	mov    %edx,0x8(%ebp)
 56d:	0f b6 00             	movzbl (%eax),%eax
 570:	0f be c0             	movsbl %al,%eax
 573:	01 c8                	add    %ecx,%eax
 575:	83 e8 30             	sub    $0x30,%eax
 578:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 57b:	8b 45 08             	mov    0x8(%ebp),%eax
 57e:	0f b6 00             	movzbl (%eax),%eax
 581:	3c 2f                	cmp    $0x2f,%al
 583:	7e 0a                	jle    58f <atoi+0x48>
 585:	8b 45 08             	mov    0x8(%ebp),%eax
 588:	0f b6 00             	movzbl (%eax),%eax
 58b:	3c 39                	cmp    $0x39,%al
 58d:	7e c7                	jle    556 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 58f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 592:	c9                   	leave  
 593:	c3                   	ret    

00000594 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 59a:	8b 45 08             	mov    0x8(%ebp),%eax
 59d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5a6:	eb 17                	jmp    5bf <memmove+0x2b>
    *dst++ = *src++;
 5a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ab:	8d 50 01             	lea    0x1(%eax),%edx
 5ae:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5b1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5b4:	8d 4a 01             	lea    0x1(%edx),%ecx
 5b7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5ba:	0f b6 12             	movzbl (%edx),%edx
 5bd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5bf:	8b 45 10             	mov    0x10(%ebp),%eax
 5c2:	8d 50 ff             	lea    -0x1(%eax),%edx
 5c5:	89 55 10             	mov    %edx,0x10(%ebp)
 5c8:	85 c0                	test   %eax,%eax
 5ca:	7f dc                	jg     5a8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5cf:	c9                   	leave  
 5d0:	c3                   	ret    

000005d1 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 5d1:	b8 01 00 00 00       	mov    $0x1,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <exit>:
SYSCALL(exit)
 5d9:	b8 02 00 00 00       	mov    $0x2,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <wait>:
SYSCALL(wait)
 5e1:	b8 03 00 00 00       	mov    $0x3,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <waitpid>:
SYSCALL(waitpid)
 5e9:	b8 16 00 00 00       	mov    $0x16,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <wait_stat>:
SYSCALL(wait_stat)
 5f1:	b8 17 00 00 00       	mov    $0x17,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <pipe>:
SYSCALL(pipe)
 5f9:	b8 04 00 00 00       	mov    $0x4,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <read>:
SYSCALL(read)
 601:	b8 05 00 00 00       	mov    $0x5,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <write>:
SYSCALL(write)
 609:	b8 10 00 00 00       	mov    $0x10,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <close>:
SYSCALL(close)
 611:	b8 15 00 00 00       	mov    $0x15,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <kill>:
SYSCALL(kill)
 619:	b8 06 00 00 00       	mov    $0x6,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <exec>:
SYSCALL(exec)
 621:	b8 07 00 00 00       	mov    $0x7,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <open>:
SYSCALL(open)
 629:	b8 0f 00 00 00       	mov    $0xf,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <mknod>:
SYSCALL(mknod)
 631:	b8 11 00 00 00       	mov    $0x11,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <unlink>:
SYSCALL(unlink)
 639:	b8 12 00 00 00       	mov    $0x12,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <fstat>:
SYSCALL(fstat)
 641:	b8 08 00 00 00       	mov    $0x8,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <link>:
SYSCALL(link)
 649:	b8 13 00 00 00       	mov    $0x13,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <mkdir>:
SYSCALL(mkdir)
 651:	b8 14 00 00 00       	mov    $0x14,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <chdir>:
SYSCALL(chdir)
 659:	b8 09 00 00 00       	mov    $0x9,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <dup>:
SYSCALL(dup)
 661:	b8 0a 00 00 00       	mov    $0xa,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <getpid>:
SYSCALL(getpid)
 669:	b8 0b 00 00 00       	mov    $0xb,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <sbrk>:
SYSCALL(sbrk)
 671:	b8 0c 00 00 00       	mov    $0xc,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <set_priority>:
SYSCALL(set_priority)
 679:	b8 18 00 00 00       	mov    $0x18,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <canRemoveJob>:
SYSCALL(canRemoveJob)
 681:	b8 19 00 00 00       	mov    $0x19,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <jobs>:
SYSCALL(jobs)
 689:	b8 1a 00 00 00       	mov    $0x1a,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <sleep>:
SYSCALL(sleep)
 691:	b8 0d 00 00 00       	mov    $0xd,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <uptime>:
SYSCALL(uptime)
 699:	b8 0e 00 00 00       	mov    $0xe,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <gidpid>:
SYSCALL(gidpid)
 6a1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6a6:	cd 40                	int    $0x40
 6a8:	c3                   	ret    

000006a9 <isShell>:
SYSCALL(isShell)
 6a9:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6ae:	cd 40                	int    $0x40
 6b0:	c3                   	ret    

000006b1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6b1:	55                   	push   %ebp
 6b2:	89 e5                	mov    %esp,%ebp
 6b4:	83 ec 18             	sub    $0x18,%esp
 6b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ba:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6bd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6c4:	00 
 6c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6cc:	8b 45 08             	mov    0x8(%ebp),%eax
 6cf:	89 04 24             	mov    %eax,(%esp)
 6d2:	e8 32 ff ff ff       	call   609 <write>
}
 6d7:	c9                   	leave  
 6d8:	c3                   	ret    

000006d9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d9:	55                   	push   %ebp
 6da:	89 e5                	mov    %esp,%ebp
 6dc:	56                   	push   %esi
 6dd:	53                   	push   %ebx
 6de:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6e8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6ec:	74 17                	je     705 <printint+0x2c>
 6ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6f2:	79 11                	jns    705 <printint+0x2c>
    neg = 1;
 6f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6fe:	f7 d8                	neg    %eax
 700:	89 45 ec             	mov    %eax,-0x14(%ebp)
 703:	eb 06                	jmp    70b <printint+0x32>
  } else {
    x = xx;
 705:	8b 45 0c             	mov    0xc(%ebp),%eax
 708:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 70b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 712:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 715:	8d 41 01             	lea    0x1(%ecx),%eax
 718:	89 45 f4             	mov    %eax,-0xc(%ebp)
 71b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 71e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 721:	ba 00 00 00 00       	mov    $0x0,%edx
 726:	f7 f3                	div    %ebx
 728:	89 d0                	mov    %edx,%eax
 72a:	0f b6 80 64 0e 00 00 	movzbl 0xe64(%eax),%eax
 731:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 735:	8b 75 10             	mov    0x10(%ebp),%esi
 738:	8b 45 ec             	mov    -0x14(%ebp),%eax
 73b:	ba 00 00 00 00       	mov    $0x0,%edx
 740:	f7 f6                	div    %esi
 742:	89 45 ec             	mov    %eax,-0x14(%ebp)
 745:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 749:	75 c7                	jne    712 <printint+0x39>
  if(neg)
 74b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74f:	74 10                	je     761 <printint+0x88>
    buf[i++] = '-';
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	8d 50 01             	lea    0x1(%eax),%edx
 757:	89 55 f4             	mov    %edx,-0xc(%ebp)
 75a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 75f:	eb 1f                	jmp    780 <printint+0xa7>
 761:	eb 1d                	jmp    780 <printint+0xa7>
    putc(fd, buf[i]);
 763:	8d 55 dc             	lea    -0x24(%ebp),%edx
 766:	8b 45 f4             	mov    -0xc(%ebp),%eax
 769:	01 d0                	add    %edx,%eax
 76b:	0f b6 00             	movzbl (%eax),%eax
 76e:	0f be c0             	movsbl %al,%eax
 771:	89 44 24 04          	mov    %eax,0x4(%esp)
 775:	8b 45 08             	mov    0x8(%ebp),%eax
 778:	89 04 24             	mov    %eax,(%esp)
 77b:	e8 31 ff ff ff       	call   6b1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 780:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 788:	79 d9                	jns    763 <printint+0x8a>
    putc(fd, buf[i]);
}
 78a:	83 c4 30             	add    $0x30,%esp
 78d:	5b                   	pop    %ebx
 78e:	5e                   	pop    %esi
 78f:	5d                   	pop    %ebp
 790:	c3                   	ret    

00000791 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 791:	55                   	push   %ebp
 792:	89 e5                	mov    %esp,%ebp
 794:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 797:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 79e:	8d 45 0c             	lea    0xc(%ebp),%eax
 7a1:	83 c0 04             	add    $0x4,%eax
 7a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7ae:	e9 7c 01 00 00       	jmp    92f <printf+0x19e>
    c = fmt[i] & 0xff;
 7b3:	8b 55 0c             	mov    0xc(%ebp),%edx
 7b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b9:	01 d0                	add    %edx,%eax
 7bb:	0f b6 00             	movzbl (%eax),%eax
 7be:	0f be c0             	movsbl %al,%eax
 7c1:	25 ff 00 00 00       	and    $0xff,%eax
 7c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7cd:	75 2c                	jne    7fb <printf+0x6a>
      if(c == '%'){
 7cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7d3:	75 0c                	jne    7e1 <printf+0x50>
        state = '%';
 7d5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7dc:	e9 4a 01 00 00       	jmp    92b <printf+0x19a>
      } else {
        putc(fd, c);
 7e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e4:	0f be c0             	movsbl %al,%eax
 7e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	89 04 24             	mov    %eax,(%esp)
 7f1:	e8 bb fe ff ff       	call   6b1 <putc>
 7f6:	e9 30 01 00 00       	jmp    92b <printf+0x19a>
      }
    } else if(state == '%'){
 7fb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7ff:	0f 85 26 01 00 00    	jne    92b <printf+0x19a>
      if(c == 'd'){
 805:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 809:	75 2d                	jne    838 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 80b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80e:	8b 00                	mov    (%eax),%eax
 810:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 817:	00 
 818:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 81f:	00 
 820:	89 44 24 04          	mov    %eax,0x4(%esp)
 824:	8b 45 08             	mov    0x8(%ebp),%eax
 827:	89 04 24             	mov    %eax,(%esp)
 82a:	e8 aa fe ff ff       	call   6d9 <printint>
        ap++;
 82f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 833:	e9 ec 00 00 00       	jmp    924 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 838:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 83c:	74 06                	je     844 <printf+0xb3>
 83e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 842:	75 2d                	jne    871 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 844:	8b 45 e8             	mov    -0x18(%ebp),%eax
 847:	8b 00                	mov    (%eax),%eax
 849:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 850:	00 
 851:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 858:	00 
 859:	89 44 24 04          	mov    %eax,0x4(%esp)
 85d:	8b 45 08             	mov    0x8(%ebp),%eax
 860:	89 04 24             	mov    %eax,(%esp)
 863:	e8 71 fe ff ff       	call   6d9 <printint>
        ap++;
 868:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 86c:	e9 b3 00 00 00       	jmp    924 <printf+0x193>
      } else if(c == 's'){
 871:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 875:	75 45                	jne    8bc <printf+0x12b>
        s = (char*)*ap;
 877:	8b 45 e8             	mov    -0x18(%ebp),%eax
 87a:	8b 00                	mov    (%eax),%eax
 87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 87f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 887:	75 09                	jne    892 <printf+0x101>
          s = "(null)";
 889:	c7 45 f4 96 0b 00 00 	movl   $0xb96,-0xc(%ebp)
        while(*s != 0){
 890:	eb 1e                	jmp    8b0 <printf+0x11f>
 892:	eb 1c                	jmp    8b0 <printf+0x11f>
          putc(fd, *s);
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	0f b6 00             	movzbl (%eax),%eax
 89a:	0f be c0             	movsbl %al,%eax
 89d:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a1:	8b 45 08             	mov    0x8(%ebp),%eax
 8a4:	89 04 24             	mov    %eax,(%esp)
 8a7:	e8 05 fe ff ff       	call   6b1 <putc>
          s++;
 8ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	0f b6 00             	movzbl (%eax),%eax
 8b6:	84 c0                	test   %al,%al
 8b8:	75 da                	jne    894 <printf+0x103>
 8ba:	eb 68                	jmp    924 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8bc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8c0:	75 1d                	jne    8df <printf+0x14e>
        putc(fd, *ap);
 8c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8c5:	8b 00                	mov    (%eax),%eax
 8c7:	0f be c0             	movsbl %al,%eax
 8ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	89 04 24             	mov    %eax,(%esp)
 8d4:	e8 d8 fd ff ff       	call   6b1 <putc>
        ap++;
 8d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8dd:	eb 45                	jmp    924 <printf+0x193>
      } else if(c == '%'){
 8df:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8e3:	75 17                	jne    8fc <printf+0x16b>
        putc(fd, c);
 8e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8e8:	0f be c0             	movsbl %al,%eax
 8eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ef:	8b 45 08             	mov    0x8(%ebp),%eax
 8f2:	89 04 24             	mov    %eax,(%esp)
 8f5:	e8 b7 fd ff ff       	call   6b1 <putc>
 8fa:	eb 28                	jmp    924 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8fc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 903:	00 
 904:	8b 45 08             	mov    0x8(%ebp),%eax
 907:	89 04 24             	mov    %eax,(%esp)
 90a:	e8 a2 fd ff ff       	call   6b1 <putc>
        putc(fd, c);
 90f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 912:	0f be c0             	movsbl %al,%eax
 915:	89 44 24 04          	mov    %eax,0x4(%esp)
 919:	8b 45 08             	mov    0x8(%ebp),%eax
 91c:	89 04 24             	mov    %eax,(%esp)
 91f:	e8 8d fd ff ff       	call   6b1 <putc>
      }
      state = 0;
 924:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 92b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 92f:	8b 55 0c             	mov    0xc(%ebp),%edx
 932:	8b 45 f0             	mov    -0x10(%ebp),%eax
 935:	01 d0                	add    %edx,%eax
 937:	0f b6 00             	movzbl (%eax),%eax
 93a:	84 c0                	test   %al,%al
 93c:	0f 85 71 fe ff ff    	jne    7b3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 942:	c9                   	leave  
 943:	c3                   	ret    

00000944 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 944:	55                   	push   %ebp
 945:	89 e5                	mov    %esp,%ebp
 947:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 94a:	8b 45 08             	mov    0x8(%ebp),%eax
 94d:	83 e8 08             	sub    $0x8,%eax
 950:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 953:	a1 88 0e 00 00       	mov    0xe88,%eax
 958:	89 45 fc             	mov    %eax,-0x4(%ebp)
 95b:	eb 24                	jmp    981 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 960:	8b 00                	mov    (%eax),%eax
 962:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 965:	77 12                	ja     979 <free+0x35>
 967:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 96d:	77 24                	ja     993 <free+0x4f>
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	8b 00                	mov    (%eax),%eax
 974:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 977:	77 1a                	ja     993 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 979:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97c:	8b 00                	mov    (%eax),%eax
 97e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 981:	8b 45 f8             	mov    -0x8(%ebp),%eax
 984:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 987:	76 d4                	jbe    95d <free+0x19>
 989:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98c:	8b 00                	mov    (%eax),%eax
 98e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 991:	76 ca                	jbe    95d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 993:	8b 45 f8             	mov    -0x8(%ebp),%eax
 996:	8b 40 04             	mov    0x4(%eax),%eax
 999:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a3:	01 c2                	add    %eax,%edx
 9a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a8:	8b 00                	mov    (%eax),%eax
 9aa:	39 c2                	cmp    %eax,%edx
 9ac:	75 24                	jne    9d2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b1:	8b 50 04             	mov    0x4(%eax),%edx
 9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b7:	8b 00                	mov    (%eax),%eax
 9b9:	8b 40 04             	mov    0x4(%eax),%eax
 9bc:	01 c2                	add    %eax,%edx
 9be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c7:	8b 00                	mov    (%eax),%eax
 9c9:	8b 10                	mov    (%eax),%edx
 9cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ce:	89 10                	mov    %edx,(%eax)
 9d0:	eb 0a                	jmp    9dc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d5:	8b 10                	mov    (%eax),%edx
 9d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9da:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9df:	8b 40 04             	mov    0x4(%eax),%eax
 9e2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ec:	01 d0                	add    %edx,%eax
 9ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9f1:	75 20                	jne    a13 <free+0xcf>
    p->s.size += bp->s.size;
 9f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f6:	8b 50 04             	mov    0x4(%eax),%edx
 9f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9fc:	8b 40 04             	mov    0x4(%eax),%eax
 9ff:	01 c2                	add    %eax,%edx
 a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a04:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a07:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0a:	8b 10                	mov    (%eax),%edx
 a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0f:	89 10                	mov    %edx,(%eax)
 a11:	eb 08                	jmp    a1b <free+0xd7>
  } else
    p->s.ptr = bp;
 a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a16:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a19:	89 10                	mov    %edx,(%eax)
  freep = p;
 a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1e:	a3 88 0e 00 00       	mov    %eax,0xe88
}
 a23:	c9                   	leave  
 a24:	c3                   	ret    

00000a25 <morecore>:

static Header*
morecore(uint nu)
{
 a25:	55                   	push   %ebp
 a26:	89 e5                	mov    %esp,%ebp
 a28:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a2b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a32:	77 07                	ja     a3b <morecore+0x16>
    nu = 4096;
 a34:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a3b:	8b 45 08             	mov    0x8(%ebp),%eax
 a3e:	c1 e0 03             	shl    $0x3,%eax
 a41:	89 04 24             	mov    %eax,(%esp)
 a44:	e8 28 fc ff ff       	call   671 <sbrk>
 a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a4c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a50:	75 07                	jne    a59 <morecore+0x34>
    return 0;
 a52:	b8 00 00 00 00       	mov    $0x0,%eax
 a57:	eb 22                	jmp    a7b <morecore+0x56>
  hp = (Header*)p;
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a62:	8b 55 08             	mov    0x8(%ebp),%edx
 a65:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6b:	83 c0 08             	add    $0x8,%eax
 a6e:	89 04 24             	mov    %eax,(%esp)
 a71:	e8 ce fe ff ff       	call   944 <free>
  return freep;
 a76:	a1 88 0e 00 00       	mov    0xe88,%eax
}
 a7b:	c9                   	leave  
 a7c:	c3                   	ret    

00000a7d <malloc>:

void*
malloc(uint nbytes)
{
 a7d:	55                   	push   %ebp
 a7e:	89 e5                	mov    %esp,%ebp
 a80:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a83:	8b 45 08             	mov    0x8(%ebp),%eax
 a86:	83 c0 07             	add    $0x7,%eax
 a89:	c1 e8 03             	shr    $0x3,%eax
 a8c:	83 c0 01             	add    $0x1,%eax
 a8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a92:	a1 88 0e 00 00       	mov    0xe88,%eax
 a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a9e:	75 23                	jne    ac3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 aa0:	c7 45 f0 80 0e 00 00 	movl   $0xe80,-0x10(%ebp)
 aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aaa:	a3 88 0e 00 00       	mov    %eax,0xe88
 aaf:	a1 88 0e 00 00       	mov    0xe88,%eax
 ab4:	a3 80 0e 00 00       	mov    %eax,0xe80
    base.s.size = 0;
 ab9:	c7 05 84 0e 00 00 00 	movl   $0x0,0xe84
 ac0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac6:	8b 00                	mov    (%eax),%eax
 ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ace:	8b 40 04             	mov    0x4(%eax),%eax
 ad1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ad4:	72 4d                	jb     b23 <malloc+0xa6>
      if(p->s.size == nunits)
 ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad9:	8b 40 04             	mov    0x4(%eax),%eax
 adc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 adf:	75 0c                	jne    aed <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae4:	8b 10                	mov    (%eax),%edx
 ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae9:	89 10                	mov    %edx,(%eax)
 aeb:	eb 26                	jmp    b13 <malloc+0x96>
      else {
        p->s.size -= nunits;
 aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af0:	8b 40 04             	mov    0x4(%eax),%eax
 af3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 af6:	89 c2                	mov    %eax,%edx
 af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b01:	8b 40 04             	mov    0x4(%eax),%eax
 b04:	c1 e0 03             	shl    $0x3,%eax
 b07:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b10:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b16:	a3 88 0e 00 00       	mov    %eax,0xe88
      return (void*)(p + 1);
 b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1e:	83 c0 08             	add    $0x8,%eax
 b21:	eb 38                	jmp    b5b <malloc+0xde>
    }
    if(p == freep)
 b23:	a1 88 0e 00 00       	mov    0xe88,%eax
 b28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b2b:	75 1b                	jne    b48 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b30:	89 04 24             	mov    %eax,(%esp)
 b33:	e8 ed fe ff ff       	call   a25 <morecore>
 b38:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b3f:	75 07                	jne    b48 <malloc+0xcb>
        return 0;
 b41:	b8 00 00 00 00       	mov    $0x0,%eax
 b46:	eb 13                	jmp    b5b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b51:	8b 00                	mov    (%eax),%eax
 b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b56:	e9 70 ff ff ff       	jmp    acb <malloc+0x4e>
}
 b5b:	c9                   	leave  
 b5c:	c3                   	ret    
