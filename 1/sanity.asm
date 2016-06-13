
_sanity:     file format elf32-i386


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
   6:	81 ec a0 00 00 00    	sub    $0xa0,%esp
  int i,j,pid;
  int children[20];
  int status,wtime,rtime,iotime;
  int avgWait=0,avgRun=0,avgTa=0;
   c:	c7 84 24 94 00 00 00 	movl   $0x0,0x94(%esp)
  13:	00 00 00 00 
  17:	c7 84 24 90 00 00 00 	movl   $0x0,0x90(%esp)
  1e:	00 00 00 00 
  22:	c7 84 24 8c 00 00 00 	movl   $0x0,0x8c(%esp)
  29:	00 00 00 00 
  set_priority(1);
  2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  34:	e8 30 05 00 00       	call   569 <set_priority>
  for (i=0;i<20;i++) {
  39:	c7 84 24 9c 00 00 00 	movl   $0x0,0x9c(%esp)
  40:	00 00 00 00 
  44:	e9 98 00 00 00       	jmp    e1 <main+0xe1>
	if (!(children[i] = fork())) {
  49:	e8 73 04 00 00       	call   4c1 <fork>
  4e:	8b 94 24 9c 00 00 00 	mov    0x9c(%esp),%edx
  55:	89 44 94 38          	mov    %eax,0x38(%esp,%edx,4)
  59:	8b 84 24 9c 00 00 00 	mov    0x9c(%esp),%eax
  60:	8b 44 84 38          	mov    0x38(%esp,%eax,4),%eax
  64:	85 c0                	test   %eax,%eax
  66:	75 71                	jne    d9 <main+0xd9>
		set_priority((i+1)%3);
  68:	8b 84 24 9c 00 00 00 	mov    0x9c(%esp),%eax
  6f:	8d 48 01             	lea    0x1(%eax),%ecx
  72:	ba 56 55 55 55       	mov    $0x55555556,%edx
  77:	89 c8                	mov    %ecx,%eax
  79:	f7 ea                	imul   %edx
  7b:	89 c8                	mov    %ecx,%eax
  7d:	c1 f8 1f             	sar    $0x1f,%eax
  80:	29 c2                	sub    %eax,%edx
  82:	89 d0                	mov    %edx,%eax
  84:	01 c0                	add    %eax,%eax
  86:	01 d0                	add    %edx,%eax
  88:	29 c1                	sub    %eax,%ecx
  8a:	89 ca                	mov    %ecx,%edx
  8c:	89 14 24             	mov    %edx,(%esp)
  8f:	e8 d5 04 00 00       	call   569 <set_priority>
		for (j=0;j<70000000;j++) {
  94:	c7 84 24 98 00 00 00 	movl   $0x0,0x98(%esp)
  9b:	00 00 00 00 
  9f:	eb 10                	jmp    b1 <main+0xb1>
			j++;
  a1:	83 84 24 98 00 00 00 	addl   $0x1,0x98(%esp)
  a8:	01 
  int avgWait=0,avgRun=0,avgTa=0;
  set_priority(1);
  for (i=0;i<20;i++) {
	if (!(children[i] = fork())) {
		set_priority((i+1)%3);
		for (j=0;j<70000000;j++) {
  a9:	83 84 24 98 00 00 00 	addl   $0x1,0x98(%esp)
  b0:	01 
  b1:	81 bc 24 98 00 00 00 	cmpl   $0x42c1d7f,0x98(%esp)
  b8:	7f 1d 2c 04 
  bc:	7e e3                	jle    a1 <main+0xa1>
			j++;
		}
		pid = getpid();
  be:	e8 96 04 00 00       	call   559 <getpid>
  c3:	89 84 24 88 00 00 00 	mov    %eax,0x88(%esp)
		exit(pid);
  ca:	8b 84 24 88 00 00 00 	mov    0x88(%esp),%eax
  d1:	89 04 24             	mov    %eax,(%esp)
  d4:	e8 f0 03 00 00       	call   4c9 <exit>
  int i,j,pid;
  int children[20];
  int status,wtime,rtime,iotime;
  int avgWait=0,avgRun=0,avgTa=0;
  set_priority(1);
  for (i=0;i<20;i++) {
  d9:	83 84 24 9c 00 00 00 	addl   $0x1,0x9c(%esp)
  e0:	01 
  e1:	83 bc 24 9c 00 00 00 	cmpl   $0x13,0x9c(%esp)
  e8:	13 
  e9:	0f 8e 5a ff ff ff    	jle    49 <main+0x49>
		}
		pid = getpid();
		exit(pid);
	}
  }
  for (i=0;i<20;i++) {
  ef:	c7 84 24 9c 00 00 00 	movl   $0x0,0x9c(%esp)
  f6:	00 00 00 00 
  fa:	e9 aa 00 00 00       	jmp    1a9 <main+0x1a9>
	pid=wait_stat(&wtime,&rtime,&iotime,&status);
  ff:	8d 44 24 34          	lea    0x34(%esp),%eax
 103:	89 44 24 0c          	mov    %eax,0xc(%esp)
 107:	8d 44 24 28          	lea    0x28(%esp),%eax
 10b:	89 44 24 08          	mov    %eax,0x8(%esp)
 10f:	8d 44 24 2c          	lea    0x2c(%esp),%eax
 113:	89 44 24 04          	mov    %eax,0x4(%esp)
 117:	8d 44 24 30          	lea    0x30(%esp),%eax
 11b:	89 04 24             	mov    %eax,(%esp)
 11e:	e8 be 03 00 00       	call   4e1 <wait_stat>
 123:	89 84 24 88 00 00 00 	mov    %eax,0x88(%esp)
	if (pid==status) {
 12a:	8b 44 24 34          	mov    0x34(%esp),%eax
 12e:	39 84 24 88 00 00 00 	cmp    %eax,0x88(%esp)
 135:	75 3e                	jne    175 <main+0x175>
		printf(2,"pid %d: wait time: %d  | runtime: %d  | turn around time: %d\n",pid,wtime,rtime,(wtime+rtime));	
 137:	8b 54 24 30          	mov    0x30(%esp),%edx
 13b:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 13f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 142:	8b 54 24 2c          	mov    0x2c(%esp),%edx
 146:	8b 44 24 30          	mov    0x30(%esp),%eax
 14a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
 14e:	89 54 24 10          	mov    %edx,0x10(%esp)
 152:	89 44 24 0c          	mov    %eax,0xc(%esp)
 156:	8b 84 24 88 00 00 00 	mov    0x88(%esp),%eax
 15d:	89 44 24 08          	mov    %eax,0x8(%esp)
 161:	c7 44 24 04 50 0a 00 	movl   $0xa50,0x4(%esp)
 168:	00 
 169:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 170:	e8 0c 05 00 00       	call   681 <printf>
	}
	avgWait+=wtime;
 175:	8b 44 24 30          	mov    0x30(%esp),%eax
 179:	01 84 24 94 00 00 00 	add    %eax,0x94(%esp)
	avgRun+=rtime;
 180:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 184:	01 84 24 90 00 00 00 	add    %eax,0x90(%esp)
	avgTa+=rtime;
 18b:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 18f:	01 84 24 8c 00 00 00 	add    %eax,0x8c(%esp)
	avgTa+=wtime;
 196:	8b 44 24 30          	mov    0x30(%esp),%eax
 19a:	01 84 24 8c 00 00 00 	add    %eax,0x8c(%esp)
		}
		pid = getpid();
		exit(pid);
	}
  }
  for (i=0;i<20;i++) {
 1a1:	83 84 24 9c 00 00 00 	addl   $0x1,0x9c(%esp)
 1a8:	01 
 1a9:	83 bc 24 9c 00 00 00 	cmpl   $0x13,0x9c(%esp)
 1b0:	13 
 1b1:	0f 8e 48 ff ff ff    	jle    ff <main+0xff>
	avgWait+=wtime;
	avgRun+=rtime;
	avgTa+=rtime;
	avgTa+=wtime;
  }
  avgWait/=20;
 1b7:	8b 8c 24 94 00 00 00 	mov    0x94(%esp),%ecx
 1be:	ba 67 66 66 66       	mov    $0x66666667,%edx
 1c3:	89 c8                	mov    %ecx,%eax
 1c5:	f7 ea                	imul   %edx
 1c7:	c1 fa 03             	sar    $0x3,%edx
 1ca:	89 c8                	mov    %ecx,%eax
 1cc:	c1 f8 1f             	sar    $0x1f,%eax
 1cf:	29 c2                	sub    %eax,%edx
 1d1:	89 d0                	mov    %edx,%eax
 1d3:	89 84 24 94 00 00 00 	mov    %eax,0x94(%esp)
  avgRun/=20;
 1da:	8b 8c 24 90 00 00 00 	mov    0x90(%esp),%ecx
 1e1:	ba 67 66 66 66       	mov    $0x66666667,%edx
 1e6:	89 c8                	mov    %ecx,%eax
 1e8:	f7 ea                	imul   %edx
 1ea:	c1 fa 03             	sar    $0x3,%edx
 1ed:	89 c8                	mov    %ecx,%eax
 1ef:	c1 f8 1f             	sar    $0x1f,%eax
 1f2:	29 c2                	sub    %eax,%edx
 1f4:	89 d0                	mov    %edx,%eax
 1f6:	89 84 24 90 00 00 00 	mov    %eax,0x90(%esp)
  avgTa/=20;
 1fd:	8b 8c 24 8c 00 00 00 	mov    0x8c(%esp),%ecx
 204:	ba 67 66 66 66       	mov    $0x66666667,%edx
 209:	89 c8                	mov    %ecx,%eax
 20b:	f7 ea                	imul   %edx
 20d:	c1 fa 03             	sar    $0x3,%edx
 210:	89 c8                	mov    %ecx,%eax
 212:	c1 f8 1f             	sar    $0x1f,%eax
 215:	29 c2                	sub    %eax,%edx
 217:	89 d0                	mov    %edx,%eax
 219:	89 84 24 8c 00 00 00 	mov    %eax,0x8c(%esp)
  printf(2,"avg wait time: %d | avg run time: %d | avg TA time: %d\n",avgWait,avgRun,avgTa);
 220:	8b 84 24 8c 00 00 00 	mov    0x8c(%esp),%eax
 227:	89 44 24 10          	mov    %eax,0x10(%esp)
 22b:	8b 84 24 90 00 00 00 	mov    0x90(%esp),%eax
 232:	89 44 24 0c          	mov    %eax,0xc(%esp)
 236:	8b 84 24 94 00 00 00 	mov    0x94(%esp),%eax
 23d:	89 44 24 08          	mov    %eax,0x8(%esp)
 241:	c7 44 24 04 90 0a 00 	movl   $0xa90,0x4(%esp)
 248:	00 
 249:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 250:	e8 2c 04 00 00       	call   681 <printf>

  exit(0);
 255:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 25c:	e8 68 02 00 00       	call   4c9 <exit>

00000261 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 261:	55                   	push   %ebp
 262:	89 e5                	mov    %esp,%ebp
 264:	57                   	push   %edi
 265:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 266:	8b 4d 08             	mov    0x8(%ebp),%ecx
 269:	8b 55 10             	mov    0x10(%ebp),%edx
 26c:	8b 45 0c             	mov    0xc(%ebp),%eax
 26f:	89 cb                	mov    %ecx,%ebx
 271:	89 df                	mov    %ebx,%edi
 273:	89 d1                	mov    %edx,%ecx
 275:	fc                   	cld    
 276:	f3 aa                	rep stos %al,%es:(%edi)
 278:	89 ca                	mov    %ecx,%edx
 27a:	89 fb                	mov    %edi,%ebx
 27c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 27f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 282:	5b                   	pop    %ebx
 283:	5f                   	pop    %edi
 284:	5d                   	pop    %ebp
 285:	c3                   	ret    

00000286 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 292:	90                   	nop
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	8d 50 01             	lea    0x1(%eax),%edx
 299:	89 55 08             	mov    %edx,0x8(%ebp)
 29c:	8b 55 0c             	mov    0xc(%ebp),%edx
 29f:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2a5:	0f b6 12             	movzbl (%edx),%edx
 2a8:	88 10                	mov    %dl,(%eax)
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	84 c0                	test   %al,%al
 2af:	75 e2                	jne    293 <strcpy+0xd>
    ;
  return os;
 2b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b4:	c9                   	leave  
 2b5:	c3                   	ret    

000002b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2b6:	55                   	push   %ebp
 2b7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2b9:	eb 08                	jmp    2c3 <strcmp+0xd>
    p++, q++;
 2bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2bf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	0f b6 00             	movzbl (%eax),%eax
 2c9:	84 c0                	test   %al,%al
 2cb:	74 10                	je     2dd <strcmp+0x27>
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	0f b6 10             	movzbl (%eax),%edx
 2d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d6:	0f b6 00             	movzbl (%eax),%eax
 2d9:	38 c2                	cmp    %al,%dl
 2db:	74 de                	je     2bb <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	0f b6 00             	movzbl (%eax),%eax
 2e3:	0f b6 d0             	movzbl %al,%edx
 2e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e9:	0f b6 00             	movzbl (%eax),%eax
 2ec:	0f b6 c0             	movzbl %al,%eax
 2ef:	29 c2                	sub    %eax,%edx
 2f1:	89 d0                	mov    %edx,%eax
}
 2f3:	5d                   	pop    %ebp
 2f4:	c3                   	ret    

000002f5 <strlen>:

uint
strlen(char *s)
{
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
 2f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 302:	eb 04                	jmp    308 <strlen+0x13>
 304:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 308:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	01 d0                	add    %edx,%eax
 310:	0f b6 00             	movzbl (%eax),%eax
 313:	84 c0                	test   %al,%al
 315:	75 ed                	jne    304 <strlen+0xf>
    ;
  return n;
 317:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31a:	c9                   	leave  
 31b:	c3                   	ret    

0000031c <memset>:

void*
memset(void *dst, int c, uint n)
{
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 322:	8b 45 10             	mov    0x10(%ebp),%eax
 325:	89 44 24 08          	mov    %eax,0x8(%esp)
 329:	8b 45 0c             	mov    0xc(%ebp),%eax
 32c:	89 44 24 04          	mov    %eax,0x4(%esp)
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	89 04 24             	mov    %eax,(%esp)
 336:	e8 26 ff ff ff       	call   261 <stosb>
  return dst;
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33e:	c9                   	leave  
 33f:	c3                   	ret    

00000340 <strchr>:

char*
strchr(const char *s, char c)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 04             	sub    $0x4,%esp
 346:	8b 45 0c             	mov    0xc(%ebp),%eax
 349:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 34c:	eb 14                	jmp    362 <strchr+0x22>
    if(*s == c)
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	0f b6 00             	movzbl (%eax),%eax
 354:	3a 45 fc             	cmp    -0x4(%ebp),%al
 357:	75 05                	jne    35e <strchr+0x1e>
      return (char*)s;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	eb 13                	jmp    371 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 35e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	0f b6 00             	movzbl (%eax),%eax
 368:	84 c0                	test   %al,%al
 36a:	75 e2                	jne    34e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 36c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 371:	c9                   	leave  
 372:	c3                   	ret    

00000373 <gets>:

char*
gets(char *buf, int max)
{
 373:	55                   	push   %ebp
 374:	89 e5                	mov    %esp,%ebp
 376:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 379:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 380:	eb 4c                	jmp    3ce <gets+0x5b>
    cc = read(0, &c, 1);
 382:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 389:	00 
 38a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 38d:	89 44 24 04          	mov    %eax,0x4(%esp)
 391:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 398:	e8 54 01 00 00       	call   4f1 <read>
 39d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3a4:	7f 02                	jg     3a8 <gets+0x35>
      break;
 3a6:	eb 31                	jmp    3d9 <gets+0x66>
    buf[i++] = c;
 3a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ab:	8d 50 01             	lea    0x1(%eax),%edx
 3ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3b1:	89 c2                	mov    %eax,%edx
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	01 c2                	add    %eax,%edx
 3b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3c2:	3c 0a                	cmp    $0xa,%al
 3c4:	74 13                	je     3d9 <gets+0x66>
 3c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3ca:	3c 0d                	cmp    $0xd,%al
 3cc:	74 0b                	je     3d9 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d1:	83 c0 01             	add    $0x1,%eax
 3d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3d7:	7c a9                	jl     382 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	01 d0                	add    %edx,%eax
 3e1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e7:	c9                   	leave  
 3e8:	c3                   	ret    

000003e9 <stat>:

int
stat(char *n, struct stat *st)
{
 3e9:	55                   	push   %ebp
 3ea:	89 e5                	mov    %esp,%ebp
 3ec:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3f6:	00 
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	89 04 24             	mov    %eax,(%esp)
 3fd:	e8 17 01 00 00       	call   519 <open>
 402:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 405:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 409:	79 07                	jns    412 <stat+0x29>
    return -1;
 40b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 410:	eb 23                	jmp    435 <stat+0x4c>
  r = fstat(fd, st);
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	89 44 24 04          	mov    %eax,0x4(%esp)
 419:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41c:	89 04 24             	mov    %eax,(%esp)
 41f:	e8 0d 01 00 00       	call   531 <fstat>
 424:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 427:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42a:	89 04 24             	mov    %eax,(%esp)
 42d:	e8 cf 00 00 00       	call   501 <close>
  return r;
 432:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 435:	c9                   	leave  
 436:	c3                   	ret    

00000437 <atoi>:

int
atoi(const char *s)
{
 437:	55                   	push   %ebp
 438:	89 e5                	mov    %esp,%ebp
 43a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 43d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 444:	eb 25                	jmp    46b <atoi+0x34>
    n = n*10 + *s++ - '0';
 446:	8b 55 fc             	mov    -0x4(%ebp),%edx
 449:	89 d0                	mov    %edx,%eax
 44b:	c1 e0 02             	shl    $0x2,%eax
 44e:	01 d0                	add    %edx,%eax
 450:	01 c0                	add    %eax,%eax
 452:	89 c1                	mov    %eax,%ecx
 454:	8b 45 08             	mov    0x8(%ebp),%eax
 457:	8d 50 01             	lea    0x1(%eax),%edx
 45a:	89 55 08             	mov    %edx,0x8(%ebp)
 45d:	0f b6 00             	movzbl (%eax),%eax
 460:	0f be c0             	movsbl %al,%eax
 463:	01 c8                	add    %ecx,%eax
 465:	83 e8 30             	sub    $0x30,%eax
 468:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
 46e:	0f b6 00             	movzbl (%eax),%eax
 471:	3c 2f                	cmp    $0x2f,%al
 473:	7e 0a                	jle    47f <atoi+0x48>
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	0f b6 00             	movzbl (%eax),%eax
 47b:	3c 39                	cmp    $0x39,%al
 47d:	7e c7                	jle    446 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 47f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 482:	c9                   	leave  
 483:	c3                   	ret    

00000484 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 490:	8b 45 0c             	mov    0xc(%ebp),%eax
 493:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 496:	eb 17                	jmp    4af <memmove+0x2b>
    *dst++ = *src++;
 498:	8b 45 fc             	mov    -0x4(%ebp),%eax
 49b:	8d 50 01             	lea    0x1(%eax),%edx
 49e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 4a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4aa:	0f b6 12             	movzbl (%edx),%edx
 4ad:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4af:	8b 45 10             	mov    0x10(%ebp),%eax
 4b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 4b5:	89 55 10             	mov    %edx,0x10(%ebp)
 4b8:	85 c0                	test   %eax,%eax
 4ba:	7f dc                	jg     498 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4bf:	c9                   	leave  
 4c0:	c3                   	ret    

000004c1 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
 4c1:	b8 01 00 00 00       	mov    $0x1,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <exit>:
SYSCALL(exit)
 4c9:	b8 02 00 00 00       	mov    $0x2,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <wait>:
SYSCALL(wait)
 4d1:	b8 03 00 00 00       	mov    $0x3,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <waitpid>:
SYSCALL(waitpid)
 4d9:	b8 16 00 00 00       	mov    $0x16,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <wait_stat>:
SYSCALL(wait_stat)
 4e1:	b8 17 00 00 00       	mov    $0x17,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <pipe>:
SYSCALL(pipe)
 4e9:	b8 04 00 00 00       	mov    $0x4,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <read>:
SYSCALL(read)
 4f1:	b8 05 00 00 00       	mov    $0x5,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <write>:
SYSCALL(write)
 4f9:	b8 10 00 00 00       	mov    $0x10,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <close>:
SYSCALL(close)
 501:	b8 15 00 00 00       	mov    $0x15,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <kill>:
SYSCALL(kill)
 509:	b8 06 00 00 00       	mov    $0x6,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <exec>:
SYSCALL(exec)
 511:	b8 07 00 00 00       	mov    $0x7,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <open>:
SYSCALL(open)
 519:	b8 0f 00 00 00       	mov    $0xf,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <mknod>:
SYSCALL(mknod)
 521:	b8 11 00 00 00       	mov    $0x11,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <unlink>:
SYSCALL(unlink)
 529:	b8 12 00 00 00       	mov    $0x12,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <fstat>:
SYSCALL(fstat)
 531:	b8 08 00 00 00       	mov    $0x8,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <link>:
SYSCALL(link)
 539:	b8 13 00 00 00       	mov    $0x13,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <mkdir>:
SYSCALL(mkdir)
 541:	b8 14 00 00 00       	mov    $0x14,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <chdir>:
SYSCALL(chdir)
 549:	b8 09 00 00 00       	mov    $0x9,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <dup>:
SYSCALL(dup)
 551:	b8 0a 00 00 00       	mov    $0xa,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <getpid>:
SYSCALL(getpid)
 559:	b8 0b 00 00 00       	mov    $0xb,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <sbrk>:
SYSCALL(sbrk)
 561:	b8 0c 00 00 00       	mov    $0xc,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <set_priority>:
SYSCALL(set_priority)
 569:	b8 18 00 00 00       	mov    $0x18,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <canRemoveJob>:
SYSCALL(canRemoveJob)
 571:	b8 19 00 00 00       	mov    $0x19,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <jobs>:
SYSCALL(jobs)
 579:	b8 1a 00 00 00       	mov    $0x1a,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <sleep>:
SYSCALL(sleep)
 581:	b8 0d 00 00 00       	mov    $0xd,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <uptime>:
SYSCALL(uptime)
 589:	b8 0e 00 00 00       	mov    $0xe,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <gidpid>:
SYSCALL(gidpid)
 591:	b8 1b 00 00 00       	mov    $0x1b,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <isShell>:
SYSCALL(isShell)
 599:	b8 1c 00 00 00       	mov    $0x1c,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5a1:	55                   	push   %ebp
 5a2:	89 e5                	mov    %esp,%ebp
 5a4:	83 ec 18             	sub    $0x18,%esp
 5a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5aa:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5ad:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5b4:	00 
 5b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	89 04 24             	mov    %eax,(%esp)
 5c2:	e8 32 ff ff ff       	call   4f9 <write>
}
 5c7:	c9                   	leave  
 5c8:	c3                   	ret    

000005c9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c9:	55                   	push   %ebp
 5ca:	89 e5                	mov    %esp,%ebp
 5cc:	56                   	push   %esi
 5cd:	53                   	push   %ebx
 5ce:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5d8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5dc:	74 17                	je     5f5 <printint+0x2c>
 5de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5e2:	79 11                	jns    5f5 <printint+0x2c>
    neg = 1;
 5e4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ee:	f7 d8                	neg    %eax
 5f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5f3:	eb 06                	jmp    5fb <printint+0x32>
  } else {
    x = xx;
 5f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 602:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 605:	8d 41 01             	lea    0x1(%ecx),%eax
 608:	89 45 f4             	mov    %eax,-0xc(%ebp)
 60b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 60e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 611:	ba 00 00 00 00       	mov    $0x0,%edx
 616:	f7 f3                	div    %ebx
 618:	89 d0                	mov    %edx,%eax
 61a:	0f b6 80 14 0d 00 00 	movzbl 0xd14(%eax),%eax
 621:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 625:	8b 75 10             	mov    0x10(%ebp),%esi
 628:	8b 45 ec             	mov    -0x14(%ebp),%eax
 62b:	ba 00 00 00 00       	mov    $0x0,%edx
 630:	f7 f6                	div    %esi
 632:	89 45 ec             	mov    %eax,-0x14(%ebp)
 635:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 639:	75 c7                	jne    602 <printint+0x39>
  if(neg)
 63b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 63f:	74 10                	je     651 <printint+0x88>
    buf[i++] = '-';
 641:	8b 45 f4             	mov    -0xc(%ebp),%eax
 644:	8d 50 01             	lea    0x1(%eax),%edx
 647:	89 55 f4             	mov    %edx,-0xc(%ebp)
 64a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 64f:	eb 1f                	jmp    670 <printint+0xa7>
 651:	eb 1d                	jmp    670 <printint+0xa7>
    putc(fd, buf[i]);
 653:	8d 55 dc             	lea    -0x24(%ebp),%edx
 656:	8b 45 f4             	mov    -0xc(%ebp),%eax
 659:	01 d0                	add    %edx,%eax
 65b:	0f b6 00             	movzbl (%eax),%eax
 65e:	0f be c0             	movsbl %al,%eax
 661:	89 44 24 04          	mov    %eax,0x4(%esp)
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	89 04 24             	mov    %eax,(%esp)
 66b:	e8 31 ff ff ff       	call   5a1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 670:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 678:	79 d9                	jns    653 <printint+0x8a>
    putc(fd, buf[i]);
}
 67a:	83 c4 30             	add    $0x30,%esp
 67d:	5b                   	pop    %ebx
 67e:	5e                   	pop    %esi
 67f:	5d                   	pop    %ebp
 680:	c3                   	ret    

00000681 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 681:	55                   	push   %ebp
 682:	89 e5                	mov    %esp,%ebp
 684:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 687:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 68e:	8d 45 0c             	lea    0xc(%ebp),%eax
 691:	83 c0 04             	add    $0x4,%eax
 694:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 697:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 69e:	e9 7c 01 00 00       	jmp    81f <printf+0x19e>
    c = fmt[i] & 0xff;
 6a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a9:	01 d0                	add    %edx,%eax
 6ab:	0f b6 00             	movzbl (%eax),%eax
 6ae:	0f be c0             	movsbl %al,%eax
 6b1:	25 ff 00 00 00       	and    $0xff,%eax
 6b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6bd:	75 2c                	jne    6eb <printf+0x6a>
      if(c == '%'){
 6bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c3:	75 0c                	jne    6d1 <printf+0x50>
        state = '%';
 6c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6cc:	e9 4a 01 00 00       	jmp    81b <printf+0x19a>
      } else {
        putc(fd, c);
 6d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d4:	0f be c0             	movsbl %al,%eax
 6d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	89 04 24             	mov    %eax,(%esp)
 6e1:	e8 bb fe ff ff       	call   5a1 <putc>
 6e6:	e9 30 01 00 00       	jmp    81b <printf+0x19a>
      }
    } else if(state == '%'){
 6eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6ef:	0f 85 26 01 00 00    	jne    81b <printf+0x19a>
      if(c == 'd'){
 6f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6f9:	75 2d                	jne    728 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 707:	00 
 708:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 70f:	00 
 710:	89 44 24 04          	mov    %eax,0x4(%esp)
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	89 04 24             	mov    %eax,(%esp)
 71a:	e8 aa fe ff ff       	call   5c9 <printint>
        ap++;
 71f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 723:	e9 ec 00 00 00       	jmp    814 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 728:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 72c:	74 06                	je     734 <printf+0xb3>
 72e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 732:	75 2d                	jne    761 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 734:	8b 45 e8             	mov    -0x18(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 740:	00 
 741:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 748:	00 
 749:	89 44 24 04          	mov    %eax,0x4(%esp)
 74d:	8b 45 08             	mov    0x8(%ebp),%eax
 750:	89 04 24             	mov    %eax,(%esp)
 753:	e8 71 fe ff ff       	call   5c9 <printint>
        ap++;
 758:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 75c:	e9 b3 00 00 00       	jmp    814 <printf+0x193>
      } else if(c == 's'){
 761:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 765:	75 45                	jne    7ac <printf+0x12b>
        s = (char*)*ap;
 767:	8b 45 e8             	mov    -0x18(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 76f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 777:	75 09                	jne    782 <printf+0x101>
          s = "(null)";
 779:	c7 45 f4 c8 0a 00 00 	movl   $0xac8,-0xc(%ebp)
        while(*s != 0){
 780:	eb 1e                	jmp    7a0 <printf+0x11f>
 782:	eb 1c                	jmp    7a0 <printf+0x11f>
          putc(fd, *s);
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	0f b6 00             	movzbl (%eax),%eax
 78a:	0f be c0             	movsbl %al,%eax
 78d:	89 44 24 04          	mov    %eax,0x4(%esp)
 791:	8b 45 08             	mov    0x8(%ebp),%eax
 794:	89 04 24             	mov    %eax,(%esp)
 797:	e8 05 fe ff ff       	call   5a1 <putc>
          s++;
 79c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	0f b6 00             	movzbl (%eax),%eax
 7a6:	84 c0                	test   %al,%al
 7a8:	75 da                	jne    784 <printf+0x103>
 7aa:	eb 68                	jmp    814 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ac:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7b0:	75 1d                	jne    7cf <printf+0x14e>
        putc(fd, *ap);
 7b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b5:	8b 00                	mov    (%eax),%eax
 7b7:	0f be c0             	movsbl %al,%eax
 7ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 7be:	8b 45 08             	mov    0x8(%ebp),%eax
 7c1:	89 04 24             	mov    %eax,(%esp)
 7c4:	e8 d8 fd ff ff       	call   5a1 <putc>
        ap++;
 7c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7cd:	eb 45                	jmp    814 <printf+0x193>
      } else if(c == '%'){
 7cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7d3:	75 17                	jne    7ec <printf+0x16b>
        putc(fd, c);
 7d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d8:	0f be c0             	movsbl %al,%eax
 7db:	89 44 24 04          	mov    %eax,0x4(%esp)
 7df:	8b 45 08             	mov    0x8(%ebp),%eax
 7e2:	89 04 24             	mov    %eax,(%esp)
 7e5:	e8 b7 fd ff ff       	call   5a1 <putc>
 7ea:	eb 28                	jmp    814 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ec:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7f3:	00 
 7f4:	8b 45 08             	mov    0x8(%ebp),%eax
 7f7:	89 04 24             	mov    %eax,(%esp)
 7fa:	e8 a2 fd ff ff       	call   5a1 <putc>
        putc(fd, c);
 7ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 802:	0f be c0             	movsbl %al,%eax
 805:	89 44 24 04          	mov    %eax,0x4(%esp)
 809:	8b 45 08             	mov    0x8(%ebp),%eax
 80c:	89 04 24             	mov    %eax,(%esp)
 80f:	e8 8d fd ff ff       	call   5a1 <putc>
      }
      state = 0;
 814:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 81b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 81f:	8b 55 0c             	mov    0xc(%ebp),%edx
 822:	8b 45 f0             	mov    -0x10(%ebp),%eax
 825:	01 d0                	add    %edx,%eax
 827:	0f b6 00             	movzbl (%eax),%eax
 82a:	84 c0                	test   %al,%al
 82c:	0f 85 71 fe ff ff    	jne    6a3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 832:	c9                   	leave  
 833:	c3                   	ret    

00000834 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 834:	55                   	push   %ebp
 835:	89 e5                	mov    %esp,%ebp
 837:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83a:	8b 45 08             	mov    0x8(%ebp),%eax
 83d:	83 e8 08             	sub    $0x8,%eax
 840:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 843:	a1 30 0d 00 00       	mov    0xd30,%eax
 848:	89 45 fc             	mov    %eax,-0x4(%ebp)
 84b:	eb 24                	jmp    871 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 850:	8b 00                	mov    (%eax),%eax
 852:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 855:	77 12                	ja     869 <free+0x35>
 857:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 85d:	77 24                	ja     883 <free+0x4f>
 85f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 862:	8b 00                	mov    (%eax),%eax
 864:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 867:	77 1a                	ja     883 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	8b 00                	mov    (%eax),%eax
 86e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 871:	8b 45 f8             	mov    -0x8(%ebp),%eax
 874:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 877:	76 d4                	jbe    84d <free+0x19>
 879:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87c:	8b 00                	mov    (%eax),%eax
 87e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 881:	76 ca                	jbe    84d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 883:	8b 45 f8             	mov    -0x8(%ebp),%eax
 886:	8b 40 04             	mov    0x4(%eax),%eax
 889:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 890:	8b 45 f8             	mov    -0x8(%ebp),%eax
 893:	01 c2                	add    %eax,%edx
 895:	8b 45 fc             	mov    -0x4(%ebp),%eax
 898:	8b 00                	mov    (%eax),%eax
 89a:	39 c2                	cmp    %eax,%edx
 89c:	75 24                	jne    8c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 89e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a1:	8b 50 04             	mov    0x4(%eax),%edx
 8a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a7:	8b 00                	mov    (%eax),%eax
 8a9:	8b 40 04             	mov    0x4(%eax),%eax
 8ac:	01 c2                	add    %eax,%edx
 8ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b7:	8b 00                	mov    (%eax),%eax
 8b9:	8b 10                	mov    (%eax),%edx
 8bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8be:	89 10                	mov    %edx,(%eax)
 8c0:	eb 0a                	jmp    8cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c5:	8b 10                	mov    (%eax),%edx
 8c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	8b 40 04             	mov    0x4(%eax),%eax
 8d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dc:	01 d0                	add    %edx,%eax
 8de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e1:	75 20                	jne    903 <free+0xcf>
    p->s.size += bp->s.size;
 8e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e6:	8b 50 04             	mov    0x4(%eax),%edx
 8e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ec:	8b 40 04             	mov    0x4(%eax),%eax
 8ef:	01 c2                	add    %eax,%edx
 8f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fa:	8b 10                	mov    (%eax),%edx
 8fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ff:	89 10                	mov    %edx,(%eax)
 901:	eb 08                	jmp    90b <free+0xd7>
  } else
    p->s.ptr = bp;
 903:	8b 45 fc             	mov    -0x4(%ebp),%eax
 906:	8b 55 f8             	mov    -0x8(%ebp),%edx
 909:	89 10                	mov    %edx,(%eax)
  freep = p;
 90b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90e:	a3 30 0d 00 00       	mov    %eax,0xd30
}
 913:	c9                   	leave  
 914:	c3                   	ret    

00000915 <morecore>:

static Header*
morecore(uint nu)
{
 915:	55                   	push   %ebp
 916:	89 e5                	mov    %esp,%ebp
 918:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 91b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 922:	77 07                	ja     92b <morecore+0x16>
    nu = 4096;
 924:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 92b:	8b 45 08             	mov    0x8(%ebp),%eax
 92e:	c1 e0 03             	shl    $0x3,%eax
 931:	89 04 24             	mov    %eax,(%esp)
 934:	e8 28 fc ff ff       	call   561 <sbrk>
 939:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 93c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 940:	75 07                	jne    949 <morecore+0x34>
    return 0;
 942:	b8 00 00 00 00       	mov    $0x0,%eax
 947:	eb 22                	jmp    96b <morecore+0x56>
  hp = (Header*)p;
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 94f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 952:	8b 55 08             	mov    0x8(%ebp),%edx
 955:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 958:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95b:	83 c0 08             	add    $0x8,%eax
 95e:	89 04 24             	mov    %eax,(%esp)
 961:	e8 ce fe ff ff       	call   834 <free>
  return freep;
 966:	a1 30 0d 00 00       	mov    0xd30,%eax
}
 96b:	c9                   	leave  
 96c:	c3                   	ret    

0000096d <malloc>:

void*
malloc(uint nbytes)
{
 96d:	55                   	push   %ebp
 96e:	89 e5                	mov    %esp,%ebp
 970:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 973:	8b 45 08             	mov    0x8(%ebp),%eax
 976:	83 c0 07             	add    $0x7,%eax
 979:	c1 e8 03             	shr    $0x3,%eax
 97c:	83 c0 01             	add    $0x1,%eax
 97f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 982:	a1 30 0d 00 00       	mov    0xd30,%eax
 987:	89 45 f0             	mov    %eax,-0x10(%ebp)
 98a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 98e:	75 23                	jne    9b3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 990:	c7 45 f0 28 0d 00 00 	movl   $0xd28,-0x10(%ebp)
 997:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99a:	a3 30 0d 00 00       	mov    %eax,0xd30
 99f:	a1 30 0d 00 00       	mov    0xd30,%eax
 9a4:	a3 28 0d 00 00       	mov    %eax,0xd28
    base.s.size = 0;
 9a9:	c7 05 2c 0d 00 00 00 	movl   $0x0,0xd2c
 9b0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b6:	8b 00                	mov    (%eax),%eax
 9b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9be:	8b 40 04             	mov    0x4(%eax),%eax
 9c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9c4:	72 4d                	jb     a13 <malloc+0xa6>
      if(p->s.size == nunits)
 9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c9:	8b 40 04             	mov    0x4(%eax),%eax
 9cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9cf:	75 0c                	jne    9dd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d4:	8b 10                	mov    (%eax),%edx
 9d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d9:	89 10                	mov    %edx,(%eax)
 9db:	eb 26                	jmp    a03 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e0:	8b 40 04             	mov    0x4(%eax),%eax
 9e3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9e6:	89 c2                	mov    %eax,%edx
 9e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9eb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f1:	8b 40 04             	mov    0x4(%eax),%eax
 9f4:	c1 e0 03             	shl    $0x3,%eax
 9f7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a00:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a06:	a3 30 0d 00 00       	mov    %eax,0xd30
      return (void*)(p + 1);
 a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0e:	83 c0 08             	add    $0x8,%eax
 a11:	eb 38                	jmp    a4b <malloc+0xde>
    }
    if(p == freep)
 a13:	a1 30 0d 00 00       	mov    0xd30,%eax
 a18:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a1b:	75 1b                	jne    a38 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a20:	89 04 24             	mov    %eax,(%esp)
 a23:	e8 ed fe ff ff       	call   915 <morecore>
 a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a2f:	75 07                	jne    a38 <malloc+0xcb>
        return 0;
 a31:	b8 00 00 00 00       	mov    $0x0,%eax
 a36:	eb 13                	jmp    a4b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a41:	8b 00                	mov    (%eax),%eax
 a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a46:	e9 70 ff ff ff       	jmp    9bb <malloc+0x4e>
}
 a4b:	c9                   	leave  
 a4c:	c3                   	ret    
