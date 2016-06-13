
_task2tests:     file format elf32-i386


Disassembly of section .text:

00000000 <forktest>:
#include "types.h"
#include "stat.h"
#include "user.h"


int forktest(int* pages) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
	int pid = fork();
   6:	e8 fd 03 00 00       	call   408 <fork>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pid==0) {
   e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  12:	75 2f                	jne    43 <forktest+0x43>
		printf(2,"forktest: value of adress 20000 in child:%d\n",pages[20000]);
  14:	8b 45 08             	mov    0x8(%ebp),%eax
  17:	05 80 38 01 00       	add    $0x13880,%eax
  1c:	8b 00                	mov    (%eax),%eax
  1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  22:	c7 44 24 04 4c 09 00 	movl   $0x94c,0x4(%esp)
  29:	00 
  2a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  31:	e8 51 05 00 00       	call   587 <printf>
		kill(getpid());
  36:	e8 55 04 00 00       	call   490 <getpid>
  3b:	89 04 24             	mov    %eax,(%esp)
  3e:	e8 fd 03 00 00       	call   440 <kill>
	}
	wait();
  43:	e8 d0 03 00 00       	call   418 <wait>
	return 0;
  48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4d:	c9                   	leave  
  4e:	c3                   	ret    

0000004f <stackoverflow>:

void stackoverflow() {
  4f:	55                   	push   %ebp
  50:	89 e5                	mov    %esp,%ebp
  52:	83 ec 08             	sub    $0x8,%esp
	stackoverflow();
  55:	e8 f5 ff ff ff       	call   4f <stackoverflow>
}
  5a:	c9                   	leave  
  5b:	c3                   	ret    

0000005c <testOF>:

void testOF() {
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	83 ec 08             	sub    $0x8,%esp
	if (fork()==0) {
  62:	e8 a1 03 00 00       	call   408 <fork>
  67:	85 c0                	test   %eax,%eax
  69:	75 0a                	jne    75 <testOF+0x19>
		stackoverflow();
  6b:	e8 df ff ff ff       	call   4f <stackoverflow>
		exit();
  70:	e8 9b 03 00 00       	call   410 <exit>
	}
	wait();
  75:	e8 9e 03 00 00       	call   418 <wait>
}
  7a:	c9                   	leave  
  7b:	c3                   	ret    

0000007c <testUpToKernel>:

void testUpToKernel() {
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	83 ec 28             	sub    $0x28,%esp
	if (fork()==0) {
  82:	e8 81 03 00 00       	call   408 <fork>
  87:	85 c0                	test   %eax,%eax
  89:	75 7d                	jne    108 <testUpToKernel+0x8c>
		printf(2,"trying to malloc up to the kernel. this should fail.\n");
  8b:	c7 44 24 04 7c 09 00 	movl   $0x97c,0x4(%esp)
  92:	00 
  93:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  9a:	e8 e8 04 00 00       	call   587 <printf>
		int* goodAlloc = (int*)malloc(200000000);
  9f:	c7 04 24 00 c2 eb 0b 	movl   $0xbebc200,(%esp)
  a6:	e8 c0 07 00 00       	call   86b <malloc>
  ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//just shutting up the compiler 
		if (goodAlloc) {
			//do nothing
		}
		int* badAlloc = (int*)malloc(2147000000);
  ae:	c7 04 24 c0 9e f8 7f 	movl   $0x7ff89ec0,(%esp)
  b5:	e8 b1 07 00 00       	call   86b <malloc>
  ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (badAlloc <= 0 ) {
  bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  c1:	75 16                	jne    d9 <testUpToKernel+0x5d>
			printf(2,"malloc failed. test SUCCESSFUL.\n");
  c3:	c7 44 24 04 b4 09 00 	movl   $0x9b4,0x4(%esp)
  ca:	00 
  cb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  d2:	e8 b0 04 00 00       	call   587 <printf>
  d7:	eb 14                	jmp    ed <testUpToKernel+0x71>
		}
		else {
			printf(2,"malloc succeeded. test FAILED.\n");	
  d9:	c7 44 24 04 d8 09 00 	movl   $0x9d8,0x4(%esp)
  e0:	00 
  e1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  e8:	e8 9a 04 00 00       	call   587 <printf>
		}
		free(goodAlloc);
  ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  f0:	89 04 24             	mov    %eax,(%esp)
  f3:	e8 44 06 00 00       	call   73c <free>
		free(badAlloc);
  f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  fb:	89 04 24             	mov    %eax,(%esp)
  fe:	e8 39 06 00 00       	call   73c <free>
		exit();
 103:	e8 08 03 00 00       	call   410 <exit>
	}
	wait();
 108:	e8 0b 03 00 00       	call   418 <wait>
}
 10d:	c9                   	leave  
 10e:	c3                   	ret    

0000010f <main>:
int main (int argc, char** argv) {
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	83 e4 f0             	and    $0xfffffff0,%esp
 115:	83 ec 20             	sub    $0x20,%esp
	int* manypages = (int*)malloc(4200000);
 118:	c7 04 24 40 16 40 00 	movl   $0x401640,(%esp)
 11f:	e8 47 07 00 00       	call   86b <malloc>
 124:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	printf(2,"malloced 1025+ pages.\nwriting to the first one.\n");
 128:	c7 44 24 04 f8 09 00 	movl   $0x9f8,0x4(%esp)
 12f:	00 
 130:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 137:	e8 4b 04 00 00       	call   587 <printf>
	manypages[4500] = 345;
 13c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 140:	05 50 46 00 00       	add    $0x4650,%eax
 145:	c7 00 59 01 00 00    	movl   $0x159,(%eax)
	printf(2,"writing to the second one.\n");
 14b:	c7 44 24 04 29 0a 00 	movl   $0xa29,0x4(%esp)
 152:	00 
 153:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 15a:	e8 28 04 00 00       	call   587 <printf>
	manypages[9100] = 345;
 15f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 163:	05 30 8e 00 00       	add    $0x8e30,%eax
 168:	c7 00 59 01 00 00    	movl   $0x159,(%eax)
	free(manypages);
 16e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 172:	89 04 24             	mov    %eax,(%esp)
 175:	e8 c2 05 00 00       	call   73c <free>

	printf(2,"fork test:  \n");
 17a:	c7 44 24 04 45 0a 00 	movl   $0xa45,0x4(%esp)
 181:	00 
 182:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 189:	e8 f9 03 00 00       	call   587 <printf>
	forktest(manypages);
 18e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 192:	89 04 24             	mov    %eax,(%esp)
 195:	e8 66 fe ff ff       	call   0 <forktest>
	
	testOF();
 19a:	e8 bd fe ff ff       	call   5c <testOF>

	testUpToKernel();
 19f:	e8 d8 fe ff ff       	call   7c <testUpToKernel>
	
	return 0;
 1a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    
 1ab:	90                   	nop

000001ac <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	57                   	push   %edi
 1b0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b4:	8b 55 10             	mov    0x10(%ebp),%edx
 1b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ba:	89 cb                	mov    %ecx,%ebx
 1bc:	89 df                	mov    %ebx,%edi
 1be:	89 d1                	mov    %edx,%ecx
 1c0:	fc                   	cld    
 1c1:	f3 aa                	rep stos %al,%es:(%edi)
 1c3:	89 ca                	mov    %ecx,%edx
 1c5:	89 fb                	mov    %edi,%ebx
 1c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1ca:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1cd:	5b                   	pop    %ebx
 1ce:	5f                   	pop    %edi
 1cf:	5d                   	pop    %ebp
 1d0:	c3                   	ret    

000001d1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1dd:	90                   	nop
 1de:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e1:	0f b6 10             	movzbl (%eax),%edx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	88 10                	mov    %dl,(%eax)
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	0f b6 00             	movzbl (%eax),%eax
 1ef:	84 c0                	test   %al,%al
 1f1:	0f 95 c0             	setne  %al
 1f4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 1fc:	84 c0                	test   %al,%al
 1fe:	75 de                	jne    1de <strcpy+0xd>
    ;
  return os;
 200:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 203:	c9                   	leave  
 204:	c3                   	ret    

00000205 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 205:	55                   	push   %ebp
 206:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 208:	eb 08                	jmp    212 <strcmp+0xd>
    p++, q++;
 20a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 212:	8b 45 08             	mov    0x8(%ebp),%eax
 215:	0f b6 00             	movzbl (%eax),%eax
 218:	84 c0                	test   %al,%al
 21a:	74 10                	je     22c <strcmp+0x27>
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	0f b6 10             	movzbl (%eax),%edx
 222:	8b 45 0c             	mov    0xc(%ebp),%eax
 225:	0f b6 00             	movzbl (%eax),%eax
 228:	38 c2                	cmp    %al,%dl
 22a:	74 de                	je     20a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
 22f:	0f b6 00             	movzbl (%eax),%eax
 232:	0f b6 d0             	movzbl %al,%edx
 235:	8b 45 0c             	mov    0xc(%ebp),%eax
 238:	0f b6 00             	movzbl (%eax),%eax
 23b:	0f b6 c0             	movzbl %al,%eax
 23e:	89 d1                	mov    %edx,%ecx
 240:	29 c1                	sub    %eax,%ecx
 242:	89 c8                	mov    %ecx,%eax
}
 244:	5d                   	pop    %ebp
 245:	c3                   	ret    

00000246 <strlen>:

uint
strlen(char *s)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
 249:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 24c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 253:	eb 04                	jmp    259 <strlen+0x13>
 255:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 259:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25c:	03 45 08             	add    0x8(%ebp),%eax
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	84 c0                	test   %al,%al
 264:	75 ef                	jne    255 <strlen+0xf>
    ;
  return n;
 266:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 269:	c9                   	leave  
 26a:	c3                   	ret    

0000026b <memset>:

void*
memset(void *dst, int c, uint n)
{
 26b:	55                   	push   %ebp
 26c:	89 e5                	mov    %esp,%ebp
 26e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 271:	8b 45 10             	mov    0x10(%ebp),%eax
 274:	89 44 24 08          	mov    %eax,0x8(%esp)
 278:	8b 45 0c             	mov    0xc(%ebp),%eax
 27b:	89 44 24 04          	mov    %eax,0x4(%esp)
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	89 04 24             	mov    %eax,(%esp)
 285:	e8 22 ff ff ff       	call   1ac <stosb>
  return dst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <strchr>:

char*
strchr(const char *s, char c)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
 292:	83 ec 04             	sub    $0x4,%esp
 295:	8b 45 0c             	mov    0xc(%ebp),%eax
 298:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29b:	eb 14                	jmp    2b1 <strchr+0x22>
    if(*s == c)
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2a6:	75 05                	jne    2ad <strchr+0x1e>
      return (char*)s;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	eb 13                	jmp    2c0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	84 c0                	test   %al,%al
 2b9:	75 e2                	jne    29d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c0:	c9                   	leave  
 2c1:	c3                   	ret    

000002c2 <gets>:

char*
gets(char *buf, int max)
{
 2c2:	55                   	push   %ebp
 2c3:	89 e5                	mov    %esp,%ebp
 2c5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2cf:	eb 44                	jmp    315 <gets+0x53>
    cc = read(0, &c, 1);
 2d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2d8:	00 
 2d9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2e7:	e8 3c 01 00 00       	call   428 <read>
 2ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2f3:	7e 2d                	jle    322 <gets+0x60>
      break;
    buf[i++] = c;
 2f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f8:	03 45 08             	add    0x8(%ebp),%eax
 2fb:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 2ff:	88 10                	mov    %dl,(%eax)
 301:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 305:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 309:	3c 0a                	cmp    $0xa,%al
 30b:	74 16                	je     323 <gets+0x61>
 30d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 311:	3c 0d                	cmp    $0xd,%al
 313:	74 0e                	je     323 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 315:	8b 45 f4             	mov    -0xc(%ebp),%eax
 318:	83 c0 01             	add    $0x1,%eax
 31b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 31e:	7c b1                	jl     2d1 <gets+0xf>
 320:	eb 01                	jmp    323 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 322:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 323:	8b 45 f4             	mov    -0xc(%ebp),%eax
 326:	03 45 08             	add    0x8(%ebp),%eax
 329:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 32f:	c9                   	leave  
 330:	c3                   	ret    

00000331 <stat>:

int
stat(char *n, struct stat *st)
{
 331:	55                   	push   %ebp
 332:	89 e5                	mov    %esp,%ebp
 334:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 337:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 33e:	00 
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	89 04 24             	mov    %eax,(%esp)
 345:	e8 06 01 00 00       	call   450 <open>
 34a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 351:	79 07                	jns    35a <stat+0x29>
    return -1;
 353:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 358:	eb 23                	jmp    37d <stat+0x4c>
  r = fstat(fd, st);
 35a:	8b 45 0c             	mov    0xc(%ebp),%eax
 35d:	89 44 24 04          	mov    %eax,0x4(%esp)
 361:	8b 45 f4             	mov    -0xc(%ebp),%eax
 364:	89 04 24             	mov    %eax,(%esp)
 367:	e8 fc 00 00 00       	call   468 <fstat>
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 372:	89 04 24             	mov    %eax,(%esp)
 375:	e8 be 00 00 00       	call   438 <close>
  return r;
 37a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 37d:	c9                   	leave  
 37e:	c3                   	ret    

0000037f <atoi>:

int
atoi(const char *s)
{
 37f:	55                   	push   %ebp
 380:	89 e5                	mov    %esp,%ebp
 382:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38c:	eb 23                	jmp    3b1 <atoi+0x32>
    n = n*10 + *s++ - '0';
 38e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 391:	89 d0                	mov    %edx,%eax
 393:	c1 e0 02             	shl    $0x2,%eax
 396:	01 d0                	add    %edx,%eax
 398:	01 c0                	add    %eax,%eax
 39a:	89 c2                	mov    %eax,%edx
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	0f b6 00             	movzbl (%eax),%eax
 3a2:	0f be c0             	movsbl %al,%eax
 3a5:	01 d0                	add    %edx,%eax
 3a7:	83 e8 30             	sub    $0x30,%eax
 3aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b1:	8b 45 08             	mov    0x8(%ebp),%eax
 3b4:	0f b6 00             	movzbl (%eax),%eax
 3b7:	3c 2f                	cmp    $0x2f,%al
 3b9:	7e 0a                	jle    3c5 <atoi+0x46>
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	0f b6 00             	movzbl (%eax),%eax
 3c1:	3c 39                	cmp    $0x39,%al
 3c3:	7e c9                	jle    38e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c8:	c9                   	leave  
 3c9:	c3                   	ret    

000003ca <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3ca:	55                   	push   %ebp
 3cb:	89 e5                	mov    %esp,%ebp
 3cd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3dc:	eb 13                	jmp    3f1 <memmove+0x27>
    *dst++ = *src++;
 3de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3e1:	0f b6 10             	movzbl (%eax),%edx
 3e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e7:	88 10                	mov    %dl,(%eax)
 3e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ed:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3f5:	0f 9f c0             	setg   %al
 3f8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 3fc:	84 c0                	test   %al,%al
 3fe:	75 de                	jne    3de <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 400:	8b 45 08             	mov    0x8(%ebp),%eax
}
 403:	c9                   	leave  
 404:	c3                   	ret    
 405:	90                   	nop
 406:	90                   	nop
 407:	90                   	nop

00000408 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 408:	b8 01 00 00 00       	mov    $0x1,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <exit>:
SYSCALL(exit)
 410:	b8 02 00 00 00       	mov    $0x2,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <wait>:
SYSCALL(wait)
 418:	b8 03 00 00 00       	mov    $0x3,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <pipe>:
SYSCALL(pipe)
 420:	b8 04 00 00 00       	mov    $0x4,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <read>:
SYSCALL(read)
 428:	b8 05 00 00 00       	mov    $0x5,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <write>:
SYSCALL(write)
 430:	b8 10 00 00 00       	mov    $0x10,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <close>:
SYSCALL(close)
 438:	b8 15 00 00 00       	mov    $0x15,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <kill>:
SYSCALL(kill)
 440:	b8 06 00 00 00       	mov    $0x6,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <exec>:
SYSCALL(exec)
 448:	b8 07 00 00 00       	mov    $0x7,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <open>:
SYSCALL(open)
 450:	b8 0f 00 00 00       	mov    $0xf,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <mknod>:
SYSCALL(mknod)
 458:	b8 11 00 00 00       	mov    $0x11,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <unlink>:
SYSCALL(unlink)
 460:	b8 12 00 00 00       	mov    $0x12,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <fstat>:
SYSCALL(fstat)
 468:	b8 08 00 00 00       	mov    $0x8,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <link>:
SYSCALL(link)
 470:	b8 13 00 00 00       	mov    $0x13,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <mkdir>:
SYSCALL(mkdir)
 478:	b8 14 00 00 00       	mov    $0x14,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <chdir>:
SYSCALL(chdir)
 480:	b8 09 00 00 00       	mov    $0x9,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <dup>:
SYSCALL(dup)
 488:	b8 0a 00 00 00       	mov    $0xa,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <getpid>:
SYSCALL(getpid)
 490:	b8 0b 00 00 00       	mov    $0xb,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <sbrk>:
SYSCALL(sbrk)
 498:	b8 0c 00 00 00       	mov    $0xc,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <sleep>:
SYSCALL(sleep)
 4a0:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <uptime>:
SYSCALL(uptime)
 4a8:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	83 ec 28             	sub    $0x28,%esp
 4b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4c3:	00 
 4c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ce:	89 04 24             	mov    %eax,(%esp)
 4d1:	e8 5a ff ff ff       	call   430 <write>
}
 4d6:	c9                   	leave  
 4d7:	c3                   	ret    

000004d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4e5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4e9:	74 17                	je     502 <printint+0x2a>
 4eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4ef:	79 11                	jns    502 <printint+0x2a>
    neg = 1;
 4f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fb:	f7 d8                	neg    %eax
 4fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 500:	eb 06                	jmp    508 <printint+0x30>
  } else {
    x = xx;
 502:	8b 45 0c             	mov    0xc(%ebp),%eax
 505:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 508:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 50f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 512:	8b 45 ec             	mov    -0x14(%ebp),%eax
 515:	ba 00 00 00 00       	mov    $0x0,%edx
 51a:	f7 f1                	div    %ecx
 51c:	89 d0                	mov    %edx,%eax
 51e:	0f b6 90 1c 0d 00 00 	movzbl 0xd1c(%eax),%edx
 525:	8d 45 dc             	lea    -0x24(%ebp),%eax
 528:	03 45 f4             	add    -0xc(%ebp),%eax
 52b:	88 10                	mov    %dl,(%eax)
 52d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 531:	8b 55 10             	mov    0x10(%ebp),%edx
 534:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 537:	8b 45 ec             	mov    -0x14(%ebp),%eax
 53a:	ba 00 00 00 00       	mov    $0x0,%edx
 53f:	f7 75 d4             	divl   -0x2c(%ebp)
 542:	89 45 ec             	mov    %eax,-0x14(%ebp)
 545:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 549:	75 c4                	jne    50f <printint+0x37>
  if(neg)
 54b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 54f:	74 2a                	je     57b <printint+0xa3>
    buf[i++] = '-';
 551:	8d 45 dc             	lea    -0x24(%ebp),%eax
 554:	03 45 f4             	add    -0xc(%ebp),%eax
 557:	c6 00 2d             	movb   $0x2d,(%eax)
 55a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 55e:	eb 1b                	jmp    57b <printint+0xa3>
    putc(fd, buf[i]);
 560:	8d 45 dc             	lea    -0x24(%ebp),%eax
 563:	03 45 f4             	add    -0xc(%ebp),%eax
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	0f be c0             	movsbl %al,%eax
 56c:	89 44 24 04          	mov    %eax,0x4(%esp)
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	89 04 24             	mov    %eax,(%esp)
 576:	e8 35 ff ff ff       	call   4b0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 57b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 57f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 583:	79 db                	jns    560 <printint+0x88>
    putc(fd, buf[i]);
}
 585:	c9                   	leave  
 586:	c3                   	ret    

00000587 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 587:	55                   	push   %ebp
 588:	89 e5                	mov    %esp,%ebp
 58a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 58d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 594:	8d 45 0c             	lea    0xc(%ebp),%eax
 597:	83 c0 04             	add    $0x4,%eax
 59a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 59d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5a4:	e9 7d 01 00 00       	jmp    726 <printf+0x19f>
    c = fmt[i] & 0xff;
 5a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5af:	01 d0                	add    %edx,%eax
 5b1:	0f b6 00             	movzbl (%eax),%eax
 5b4:	0f be c0             	movsbl %al,%eax
 5b7:	25 ff 00 00 00       	and    $0xff,%eax
 5bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c3:	75 2c                	jne    5f1 <printf+0x6a>
      if(c == '%'){
 5c5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c9:	75 0c                	jne    5d7 <printf+0x50>
        state = '%';
 5cb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5d2:	e9 4b 01 00 00       	jmp    722 <printf+0x19b>
      } else {
        putc(fd, c);
 5d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5da:	0f be c0             	movsbl %al,%eax
 5dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e1:	8b 45 08             	mov    0x8(%ebp),%eax
 5e4:	89 04 24             	mov    %eax,(%esp)
 5e7:	e8 c4 fe ff ff       	call   4b0 <putc>
 5ec:	e9 31 01 00 00       	jmp    722 <printf+0x19b>
      }
    } else if(state == '%'){
 5f1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5f5:	0f 85 27 01 00 00    	jne    722 <printf+0x19b>
      if(c == 'd'){
 5fb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ff:	75 2d                	jne    62e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 601:	8b 45 e8             	mov    -0x18(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 60d:	00 
 60e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 615:	00 
 616:	89 44 24 04          	mov    %eax,0x4(%esp)
 61a:	8b 45 08             	mov    0x8(%ebp),%eax
 61d:	89 04 24             	mov    %eax,(%esp)
 620:	e8 b3 fe ff ff       	call   4d8 <printint>
        ap++;
 625:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 629:	e9 ed 00 00 00       	jmp    71b <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 62e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 632:	74 06                	je     63a <printf+0xb3>
 634:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 638:	75 2d                	jne    667 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 63a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 646:	00 
 647:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 64e:	00 
 64f:	89 44 24 04          	mov    %eax,0x4(%esp)
 653:	8b 45 08             	mov    0x8(%ebp),%eax
 656:	89 04 24             	mov    %eax,(%esp)
 659:	e8 7a fe ff ff       	call   4d8 <printint>
        ap++;
 65e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 662:	e9 b4 00 00 00       	jmp    71b <printf+0x194>
      } else if(c == 's'){
 667:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 66b:	75 46                	jne    6b3 <printf+0x12c>
        s = (char*)*ap;
 66d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 675:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 67d:	75 27                	jne    6a6 <printf+0x11f>
          s = "(null)";
 67f:	c7 45 f4 53 0a 00 00 	movl   $0xa53,-0xc(%ebp)
        while(*s != 0){
 686:	eb 1e                	jmp    6a6 <printf+0x11f>
          putc(fd, *s);
 688:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68b:	0f b6 00             	movzbl (%eax),%eax
 68e:	0f be c0             	movsbl %al,%eax
 691:	89 44 24 04          	mov    %eax,0x4(%esp)
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	89 04 24             	mov    %eax,(%esp)
 69b:	e8 10 fe ff ff       	call   4b0 <putc>
          s++;
 6a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 6a4:	eb 01                	jmp    6a7 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6a6:	90                   	nop
 6a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6aa:	0f b6 00             	movzbl (%eax),%eax
 6ad:	84 c0                	test   %al,%al
 6af:	75 d7                	jne    688 <printf+0x101>
 6b1:	eb 68                	jmp    71b <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6b3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b7:	75 1d                	jne    6d6 <printf+0x14f>
        putc(fd, *ap);
 6b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	0f be c0             	movsbl %al,%eax
 6c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	89 04 24             	mov    %eax,(%esp)
 6cb:	e8 e0 fd ff ff       	call   4b0 <putc>
        ap++;
 6d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d4:	eb 45                	jmp    71b <printf+0x194>
      } else if(c == '%'){
 6d6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6da:	75 17                	jne    6f3 <printf+0x16c>
        putc(fd, c);
 6dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6df:	0f be c0             	movsbl %al,%eax
 6e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e6:	8b 45 08             	mov    0x8(%ebp),%eax
 6e9:	89 04 24             	mov    %eax,(%esp)
 6ec:	e8 bf fd ff ff       	call   4b0 <putc>
 6f1:	eb 28                	jmp    71b <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6f3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6fa:	00 
 6fb:	8b 45 08             	mov    0x8(%ebp),%eax
 6fe:	89 04 24             	mov    %eax,(%esp)
 701:	e8 aa fd ff ff       	call   4b0 <putc>
        putc(fd, c);
 706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 709:	0f be c0             	movsbl %al,%eax
 70c:	89 44 24 04          	mov    %eax,0x4(%esp)
 710:	8b 45 08             	mov    0x8(%ebp),%eax
 713:	89 04 24             	mov    %eax,(%esp)
 716:	e8 95 fd ff ff       	call   4b0 <putc>
      }
      state = 0;
 71b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 722:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 726:	8b 55 0c             	mov    0xc(%ebp),%edx
 729:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72c:	01 d0                	add    %edx,%eax
 72e:	0f b6 00             	movzbl (%eax),%eax
 731:	84 c0                	test   %al,%al
 733:	0f 85 70 fe ff ff    	jne    5a9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 739:	c9                   	leave  
 73a:	c3                   	ret    
 73b:	90                   	nop

0000073c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 73c:	55                   	push   %ebp
 73d:	89 e5                	mov    %esp,%ebp
 73f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 742:	8b 45 08             	mov    0x8(%ebp),%eax
 745:	83 e8 08             	sub    $0x8,%eax
 748:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74b:	a1 38 0d 00 00       	mov    0xd38,%eax
 750:	89 45 fc             	mov    %eax,-0x4(%ebp)
 753:	eb 24                	jmp    779 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75d:	77 12                	ja     771 <free+0x35>
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 765:	77 24                	ja     78b <free+0x4f>
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76f:	77 1a                	ja     78b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	89 45 fc             	mov    %eax,-0x4(%ebp)
 779:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77f:	76 d4                	jbe    755 <free+0x19>
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 789:	76 ca                	jbe    755 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	c1 e0 03             	shl    $0x3,%eax
 794:	89 c2                	mov    %eax,%edx
 796:	03 55 f8             	add    -0x8(%ebp),%edx
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	39 c2                	cmp    %eax,%edx
 7a0:	75 24                	jne    7c6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 7a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a5:	8b 50 04             	mov    0x4(%eax),%edx
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	8b 00                	mov    (%eax),%eax
 7ad:	8b 40 04             	mov    0x4(%eax),%eax
 7b0:	01 c2                	add    %eax,%edx
 7b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	8b 10                	mov    (%eax),%edx
 7bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c2:	89 10                	mov    %edx,(%eax)
 7c4:	eb 0a                	jmp    7d0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	8b 10                	mov    (%eax),%edx
 7cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ce:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	8b 40 04             	mov    0x4(%eax),%eax
 7d6:	c1 e0 03             	shl    $0x3,%eax
 7d9:	03 45 fc             	add    -0x4(%ebp),%eax
 7dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7df:	75 20                	jne    801 <free+0xc5>
    p->s.size += bp->s.size;
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 50 04             	mov    0x4(%eax),%edx
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	01 c2                	add    %eax,%edx
 7ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	8b 10                	mov    (%eax),%edx
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	89 10                	mov    %edx,(%eax)
 7ff:	eb 08                	jmp    809 <free+0xcd>
  } else
    p->s.ptr = bp;
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	8b 55 f8             	mov    -0x8(%ebp),%edx
 807:	89 10                	mov    %edx,(%eax)
  freep = p;
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	a3 38 0d 00 00       	mov    %eax,0xd38
}
 811:	c9                   	leave  
 812:	c3                   	ret    

00000813 <morecore>:

static Header*
morecore(uint nu)
{
 813:	55                   	push   %ebp
 814:	89 e5                	mov    %esp,%ebp
 816:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 819:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 820:	77 07                	ja     829 <morecore+0x16>
    nu = 4096;
 822:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 829:	8b 45 08             	mov    0x8(%ebp),%eax
 82c:	c1 e0 03             	shl    $0x3,%eax
 82f:	89 04 24             	mov    %eax,(%esp)
 832:	e8 61 fc ff ff       	call   498 <sbrk>
 837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 83a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 83e:	75 07                	jne    847 <morecore+0x34>
    return 0;
 840:	b8 00 00 00 00       	mov    $0x0,%eax
 845:	eb 22                	jmp    869 <morecore+0x56>
  hp = (Header*)p;
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 84d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 850:	8b 55 08             	mov    0x8(%ebp),%edx
 853:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 856:	8b 45 f0             	mov    -0x10(%ebp),%eax
 859:	83 c0 08             	add    $0x8,%eax
 85c:	89 04 24             	mov    %eax,(%esp)
 85f:	e8 d8 fe ff ff       	call   73c <free>
  return freep;
 864:	a1 38 0d 00 00       	mov    0xd38,%eax
}
 869:	c9                   	leave  
 86a:	c3                   	ret    

0000086b <malloc>:

void*
malloc(uint nbytes)
{
 86b:	55                   	push   %ebp
 86c:	89 e5                	mov    %esp,%ebp
 86e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 871:	8b 45 08             	mov    0x8(%ebp),%eax
 874:	83 c0 07             	add    $0x7,%eax
 877:	c1 e8 03             	shr    $0x3,%eax
 87a:	83 c0 01             	add    $0x1,%eax
 87d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 880:	a1 38 0d 00 00       	mov    0xd38,%eax
 885:	89 45 f0             	mov    %eax,-0x10(%ebp)
 888:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 88c:	75 23                	jne    8b1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 88e:	c7 45 f0 30 0d 00 00 	movl   $0xd30,-0x10(%ebp)
 895:	8b 45 f0             	mov    -0x10(%ebp),%eax
 898:	a3 38 0d 00 00       	mov    %eax,0xd38
 89d:	a1 38 0d 00 00       	mov    0xd38,%eax
 8a2:	a3 30 0d 00 00       	mov    %eax,0xd30
    base.s.size = 0;
 8a7:	c7 05 34 0d 00 00 00 	movl   $0x0,0xd34
 8ae:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	8b 00                	mov    (%eax),%eax
 8b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	8b 40 04             	mov    0x4(%eax),%eax
 8bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c2:	72 4d                	jb     911 <malloc+0xa6>
      if(p->s.size == nunits)
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cd:	75 0c                	jne    8db <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	8b 10                	mov    (%eax),%edx
 8d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d7:	89 10                	mov    %edx,(%eax)
 8d9:	eb 26                	jmp    901 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8de:	8b 40 04             	mov    0x4(%eax),%eax
 8e1:	89 c2                	mov    %eax,%edx
 8e3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 40 04             	mov    0x4(%eax),%eax
 8f2:	c1 e0 03             	shl    $0x3,%eax
 8f5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8fe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 901:	8b 45 f0             	mov    -0x10(%ebp),%eax
 904:	a3 38 0d 00 00       	mov    %eax,0xd38
      return (void*)(p + 1);
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	83 c0 08             	add    $0x8,%eax
 90f:	eb 38                	jmp    949 <malloc+0xde>
    }
    if(p == freep)
 911:	a1 38 0d 00 00       	mov    0xd38,%eax
 916:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 919:	75 1b                	jne    936 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 91b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 91e:	89 04 24             	mov    %eax,(%esp)
 921:	e8 ed fe ff ff       	call   813 <morecore>
 926:	89 45 f4             	mov    %eax,-0xc(%ebp)
 929:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 92d:	75 07                	jne    936 <malloc+0xcb>
        return 0;
 92f:	b8 00 00 00 00       	mov    $0x0,%eax
 934:	eb 13                	jmp    949 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 936:	8b 45 f4             	mov    -0xc(%ebp),%eax
 939:	89 45 f0             	mov    %eax,-0x10(%ebp)
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	8b 00                	mov    (%eax),%eax
 941:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 944:	e9 70 ff ff ff       	jmp    8b9 <malloc+0x4e>
}
 949:	c9                   	leave  
 94a:	c3                   	ret    
