
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 3d 05 00 00       	call   54f <strlen>
  12:	8b 55 08             	mov    0x8(%ebp),%edx
  15:	01 d0                	add    %edx,%eax
  17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1a:	eb 04                	jmp    20 <fmtname+0x20>
  1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  23:	3b 45 08             	cmp    0x8(%ebp),%eax
  26:	72 0a                	jb     32 <fmtname+0x32>
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	0f b6 00             	movzbl (%eax),%eax
  2e:	3c 2f                	cmp    $0x2f,%al
  30:	75 ea                	jne    1c <fmtname+0x1c>
    ;
  p++;
  32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  39:	89 04 24             	mov    %eax,(%esp)
  3c:	e8 0e 05 00 00       	call   54f <strlen>
  41:	83 f8 0d             	cmp    $0xd,%eax
  44:	76 05                	jbe    4b <fmtname+0x4b>
    return p;
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	eb 5f                	jmp    aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
  4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4e:	89 04 24             	mov    %eax,(%esp)
  51:	e8 f9 04 00 00       	call   54f <strlen>
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  61:	c7 04 24 6c 0f 00 00 	movl   $0xf6c,(%esp)
  68:	e8 71 06 00 00       	call   6de <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 d7 04 00 00       	call   54f <strlen>
  78:	ba 0e 00 00 00       	mov    $0xe,%edx
  7d:	89 d3                	mov    %edx,%ebx
  7f:	29 c3                	sub    %eax,%ebx
  81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  84:	89 04 24             	mov    %eax,(%esp)
  87:	e8 c3 04 00 00       	call   54f <strlen>
  8c:	05 6c 0f 00 00       	add    $0xf6c,%eax
  91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  95:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9c:	00 
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 d1 04 00 00       	call   576 <memset>
  return buf;
  a5:	b8 6c 0f 00 00       	mov    $0xf6c,%eax
}
  aa:	83 c4 24             	add    $0x24,%esp
  ad:	5b                   	pop    %ebx
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <ls>:

void
ls(char *path)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c3:	00 
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 04 24             	mov    %eax,(%esp)
  ca:	e8 94 06 00 00       	call   763 <open>
  cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d6:	79 20                	jns    f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	89 44 24 08          	mov    %eax,0x8(%esp)
  df:	c7 44 24 04 6f 0c 00 	movl   $0xc6f,0x4(%esp)
  e6:	00 
  e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ee:	e8 b0 07 00 00       	call   8a3 <printf>
    return;
  f3:	e9 61 03 00 00       	jmp    459 <ls+0x3a9>
  }

  if(fstat(fd, &st) < 0){
  f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 105:	89 04 24             	mov    %eax,(%esp)
 108:	e8 6e 06 00 00       	call   77b <fstat>
 10d:	85 c0                	test   %eax,%eax
 10f:	79 2b                	jns    13c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 44 24 08          	mov    %eax,0x8(%esp)
 118:	c7 44 24 04 83 0c 00 	movl   $0xc83,0x4(%esp)
 11f:	00 
 120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 127:	e8 77 07 00 00       	call   8a3 <printf>
    close(fd);
 12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12f:	89 04 24             	mov    %eax,(%esp)
 132:	e8 14 06 00 00       	call   74b <close>
    return;
 137:	e9 1d 03 00 00       	jmp    459 <ls+0x3a9>
  }

  switch(st.type){
 13c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 143:	98                   	cwtl   
 144:	83 f8 02             	cmp    $0x2,%eax
 147:	74 13                	je     15c <ls+0xac>
 149:	83 f8 03             	cmp    $0x3,%eax
 14c:	0f 84 aa 01 00 00    	je     2fc <ls+0x24c>
 152:	83 f8 01             	cmp    $0x1,%eax
 155:	74 4f                	je     1a6 <ls+0xf6>
 157:	e9 f2 02 00 00       	jmp    44e <ls+0x39e>
  case T_FILE:
//    printf(1, "IN ls.c: printing file\n");
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 15c:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 162:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 168:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 16f:	0f bf d8             	movswl %ax,%ebx
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	89 04 24             	mov    %eax,(%esp)
 178:	e8 83 fe ff ff       	call   0 <fmtname>
 17d:	89 7c 24 14          	mov    %edi,0x14(%esp)
 181:	89 74 24 10          	mov    %esi,0x10(%esp)
 185:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 189:	89 44 24 08          	mov    %eax,0x8(%esp)
 18d:	c7 44 24 04 97 0c 00 	movl   $0xc97,0x4(%esp)
 194:	00 
 195:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 19c:	e8 02 07 00 00       	call   8a3 <printf>
    break;
 1a1:	e9 a8 02 00 00       	jmp    44e <ls+0x39e>

  case T_DIR:
  if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	89 04 24             	mov    %eax,(%esp)
 1ac:	e8 9e 03 00 00       	call   54f <strlen>
 1b1:	83 c0 10             	add    $0x10,%eax
 1b4:	3d 00 02 00 00       	cmp    $0x200,%eax
 1b9:	76 19                	jbe    1d4 <ls+0x124>
    printf(1, "ls: path too long\n");
 1bb:	c7 44 24 04 a4 0c 00 	movl   $0xca4,0x4(%esp)
 1c2:	00 
 1c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ca:	e8 d4 06 00 00       	call   8a3 <printf>
    break;
 1cf:	e9 7a 02 00 00       	jmp    44e <ls+0x39e>
  }
    strcpy(buf, path);
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 f7 02 00 00       	call   4e0 <strcpy>
    p = buf+strlen(buf);
 1e9:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1ef:	89 04 24             	mov    %eax,(%esp)
 1f2:	e8 58 03 00 00       	call   54f <strlen>
 1f7:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1fd:	01 d0                	add    %edx,%eax
 1ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 202:	8b 45 e0             	mov    -0x20(%ebp),%eax
 205:	8d 50 01             	lea    0x1(%eax),%edx
 208:	89 55 e0             	mov    %edx,-0x20(%ebp)
 20b:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)) {
 20e:	e9 be 00 00 00       	jmp    2d1 <ls+0x221>
      if (de.inum == 0)
 213:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 21a:	66 85 c0             	test   %ax,%ax
 21d:	75 05                	jne    224 <ls+0x174>
        continue;
 21f:	e9 ad 00 00 00       	jmp    2d1 <ls+0x221>
      memmove(p, de.name, DIRSIZ);
 224:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 22b:	00 
 22c:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 232:	83 c0 02             	add    $0x2,%eax
 235:	89 44 24 04          	mov    %eax,0x4(%esp)
 239:	8b 45 e0             	mov    -0x20(%ebp),%eax
 23c:	89 04 24             	mov    %eax,(%esp)
 23f:	e8 9a 04 00 00       	call   6de <memmove>
      p[DIRSIZ] = 0;
 244:	8b 45 e0             	mov    -0x20(%ebp),%eax
 247:	83 c0 0e             	add    $0xe,%eax
 24a:	c6 00 00             	movb   $0x0,(%eax)
      if (stat(buf, &st) < 0) {
 24d:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 253:	89 44 24 04          	mov    %eax,0x4(%esp)
 257:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25d:	89 04 24             	mov    %eax,(%esp)
 260:	e8 de 03 00 00       	call   643 <stat>
 265:	85 c0                	test   %eax,%eax
 267:	79 20                	jns    289 <ls+0x1d9>
        printf(1, "ls: cannot stat %s\n", buf);
 269:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 26f:	89 44 24 08          	mov    %eax,0x8(%esp)
 273:	c7 44 24 04 83 0c 00 	movl   $0xc83,0x4(%esp)
 27a:	00 
 27b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 282:	e8 1c 06 00 00       	call   8a3 <printf>
        continue;
 287:	eb 48                	jmp    2d1 <ls+0x221>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 289:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 28f:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 295:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 29c:	0f bf d8             	movswl %ax,%ebx
 29f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 2a5:	89 04 24             	mov    %eax,(%esp)
 2a8:	e8 53 fd ff ff       	call   0 <fmtname>
 2ad:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2b1:	89 74 24 10          	mov    %esi,0x10(%esp)
 2b5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2b9:	89 44 24 08          	mov    %eax,0x8(%esp)
 2bd:	c7 44 24 04 97 0c 00 	movl   $0xc97,0x4(%esp)
 2c4:	00 
 2c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2cc:	e8 d2 05 00 00       	call   8a3 <printf>
    break;
  }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)) {
 2d1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2d8:	00 
 2d9:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2df:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2e6:	89 04 24             	mov    %eax,(%esp)
 2e9:	e8 4d 04 00 00       	call   73b <read>
 2ee:	83 f8 10             	cmp    $0x10,%eax
 2f1:	0f 84 1c ff ff ff    	je     213 <ls+0x163>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2f7:	e9 52 01 00 00       	jmp    44e <ls+0x39e>
    case T_DEV:
//      printf(1, "ls T_DEV\nde.inum\t de.name\n");
//      while(read(fd, &de, sizeof(de)) == sizeof(de)) {
//        printf(1, "%d\t%s\n", de.inum, de.name);
//      }
      if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	89 04 24             	mov    %eax,(%esp)
 302:	e8 48 02 00 00       	call   54f <strlen>
 307:	83 c0 10             	add    $0x10,%eax
 30a:	3d 00 02 00 00       	cmp    $0x200,%eax
 30f:	76 19                	jbe    32a <ls+0x27a>
        printf(1, "ls: path too long\n");
 311:	c7 44 24 04 a4 0c 00 	movl   $0xca4,0x4(%esp)
 318:	00 
 319:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 320:	e8 7e 05 00 00       	call   8a3 <printf>
        break;
 325:	e9 24 01 00 00       	jmp    44e <ls+0x39e>
      }

      strcpy(buf, path);
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	89 44 24 04          	mov    %eax,0x4(%esp)
 331:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 337:	89 04 24             	mov    %eax,(%esp)
 33a:	e8 a1 01 00 00       	call   4e0 <strcpy>
      p = buf+strlen(buf);
 33f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 345:	89 04 24             	mov    %eax,(%esp)
 348:	e8 02 02 00 00       	call   54f <strlen>
 34d:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 353:	01 d0                	add    %edx,%eax
 355:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *p++ = '/';
 358:	8b 45 e0             	mov    -0x20(%ebp),%eax
 35b:	8d 50 01             	lea    0x1(%eax),%edx
 35e:	89 55 e0             	mov    %edx,-0x20(%ebp)
 361:	c6 00 2f             	movb   $0x2f,(%eax)
      while(read(fd, &de, sizeof(de)) == sizeof(de)) {
 364:	e9 be 00 00 00       	jmp    427 <ls+0x377>
        if (de.inum == 0)
 369:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 370:	66 85 c0             	test   %ax,%ax
 373:	75 05                	jne    37a <ls+0x2ca>
          continue;
 375:	e9 ad 00 00 00       	jmp    427 <ls+0x377>
        memmove(p, de.name, DIRSIZ);
 37a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 381:	00 
 382:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 388:	83 c0 02             	add    $0x2,%eax
 38b:	89 44 24 04          	mov    %eax,0x4(%esp)
 38f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 392:	89 04 24             	mov    %eax,(%esp)
 395:	e8 44 03 00 00       	call   6de <memmove>
        p[DIRSIZ] = 0;
 39a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 39d:	83 c0 0e             	add    $0xe,%eax
 3a0:	c6 00 00             	movb   $0x0,(%eax)
        if (stat(buf, &st) < 0) {
 3a3:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 3a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ad:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 3b3:	89 04 24             	mov    %eax,(%esp)
 3b6:	e8 88 02 00 00       	call   643 <stat>
 3bb:	85 c0                	test   %eax,%eax
 3bd:	79 20                	jns    3df <ls+0x32f>
          printf(1, "ls: cannot stat %s\n", buf);
 3bf:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 3c5:	89 44 24 08          	mov    %eax,0x8(%esp)
 3c9:	c7 44 24 04 83 0c 00 	movl   $0xc83,0x4(%esp)
 3d0:	00 
 3d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3d8:	e8 c6 04 00 00       	call   8a3 <printf>
          continue;
 3dd:	eb 48                	jmp    427 <ls+0x377>
        }
        printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 3df:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 3e5:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 3eb:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 3f2:	0f bf d8             	movswl %ax,%ebx
 3f5:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 3fb:	89 04 24             	mov    %eax,(%esp)
 3fe:	e8 fd fb ff ff       	call   0 <fmtname>
 403:	89 7c 24 14          	mov    %edi,0x14(%esp)
 407:	89 74 24 10          	mov    %esi,0x10(%esp)
 40b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 40f:	89 44 24 08          	mov    %eax,0x8(%esp)
 413:	c7 44 24 04 97 0c 00 	movl   $0xc97,0x4(%esp)
 41a:	00 
 41b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 422:	e8 7c 04 00 00       	call   8a3 <printf>
      }

      strcpy(buf, path);
      p = buf+strlen(buf);
      *p++ = '/';
      while(read(fd, &de, sizeof(de)) == sizeof(de)) {
 427:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 42e:	00 
 42f:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 435:	89 44 24 04          	mov    %eax,0x4(%esp)
 439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 43c:	89 04 24             	mov    %eax,(%esp)
 43f:	e8 f7 02 00 00       	call   73b <read>
 444:	83 f8 10             	cmp    $0x10,%eax
 447:	0f 84 1c ff ff ff    	je     369 <ls+0x2b9>
          continue;
        }
        printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
      }

      break;
 44d:	90                   	nop
  }
  close(fd);
 44e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 451:	89 04 24             	mov    %eax,(%esp)
 454:	e8 f2 02 00 00       	call   74b <close>
}
 459:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 45f:	5b                   	pop    %ebx
 460:	5e                   	pop    %esi
 461:	5f                   	pop    %edi
 462:	5d                   	pop    %ebp
 463:	c3                   	ret    

00000464 <main>:

int
main(int argc, char *argv[])
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 e4 f0             	and    $0xfffffff0,%esp
 46a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 46d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 471:	7f 11                	jg     484 <main+0x20>
    ls(".");
 473:	c7 04 24 b7 0c 00 00 	movl   $0xcb7,(%esp)
 47a:	e8 31 fc ff ff       	call   b0 <ls>
    exit();
 47f:	e8 9f 02 00 00       	call   723 <exit>
  }
  for(i=1; i<argc; i++)
 484:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 48b:	00 
 48c:	eb 1f                	jmp    4ad <main+0x49>
    ls(argv[i]);
 48e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 499:	8b 45 0c             	mov    0xc(%ebp),%eax
 49c:	01 d0                	add    %edx,%eax
 49e:	8b 00                	mov    (%eax),%eax
 4a0:	89 04 24             	mov    %eax,(%esp)
 4a3:	e8 08 fc ff ff       	call   b0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 4a8:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 4ad:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 4b1:	3b 45 08             	cmp    0x8(%ebp),%eax
 4b4:	7c d8                	jl     48e <main+0x2a>
    ls(argv[i]);
  exit();
 4b6:	e8 68 02 00 00       	call   723 <exit>

000004bb <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 4bb:	55                   	push   %ebp
 4bc:	89 e5                	mov    %esp,%ebp
 4be:	57                   	push   %edi
 4bf:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 4c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4c3:	8b 55 10             	mov    0x10(%ebp),%edx
 4c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c9:	89 cb                	mov    %ecx,%ebx
 4cb:	89 df                	mov    %ebx,%edi
 4cd:	89 d1                	mov    %edx,%ecx
 4cf:	fc                   	cld    
 4d0:	f3 aa                	rep stos %al,%es:(%edi)
 4d2:	89 ca                	mov    %ecx,%edx
 4d4:	89 fb                	mov    %edi,%ebx
 4d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
 4d9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 4dc:	5b                   	pop    %ebx
 4dd:	5f                   	pop    %edi
 4de:	5d                   	pop    %ebp
 4df:	c3                   	ret    

000004e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 4ec:	90                   	nop
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
 4f0:	8d 50 01             	lea    0x1(%eax),%edx
 4f3:	89 55 08             	mov    %edx,0x8(%ebp)
 4f6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f9:	8d 4a 01             	lea    0x1(%edx),%ecx
 4fc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 4ff:	0f b6 12             	movzbl (%edx),%edx
 502:	88 10                	mov    %dl,(%eax)
 504:	0f b6 00             	movzbl (%eax),%eax
 507:	84 c0                	test   %al,%al
 509:	75 e2                	jne    4ed <strcpy+0xd>
    ;
  return os;
 50b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 50e:	c9                   	leave  
 50f:	c3                   	ret    

00000510 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 513:	eb 08                	jmp    51d <strcmp+0xd>
    p++, q++;
 515:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 519:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 51d:	8b 45 08             	mov    0x8(%ebp),%eax
 520:	0f b6 00             	movzbl (%eax),%eax
 523:	84 c0                	test   %al,%al
 525:	74 10                	je     537 <strcmp+0x27>
 527:	8b 45 08             	mov    0x8(%ebp),%eax
 52a:	0f b6 10             	movzbl (%eax),%edx
 52d:	8b 45 0c             	mov    0xc(%ebp),%eax
 530:	0f b6 00             	movzbl (%eax),%eax
 533:	38 c2                	cmp    %al,%dl
 535:	74 de                	je     515 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	0f b6 00             	movzbl (%eax),%eax
 53d:	0f b6 d0             	movzbl %al,%edx
 540:	8b 45 0c             	mov    0xc(%ebp),%eax
 543:	0f b6 00             	movzbl (%eax),%eax
 546:	0f b6 c0             	movzbl %al,%eax
 549:	29 c2                	sub    %eax,%edx
 54b:	89 d0                	mov    %edx,%eax
}
 54d:	5d                   	pop    %ebp
 54e:	c3                   	ret    

0000054f <strlen>:

uint
strlen(char *s)
{
 54f:	55                   	push   %ebp
 550:	89 e5                	mov    %esp,%ebp
 552:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 555:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 55c:	eb 04                	jmp    562 <strlen+0x13>
 55e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 562:	8b 55 fc             	mov    -0x4(%ebp),%edx
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	01 d0                	add    %edx,%eax
 56a:	0f b6 00             	movzbl (%eax),%eax
 56d:	84 c0                	test   %al,%al
 56f:	75 ed                	jne    55e <strlen+0xf>
    ;
  return n;
 571:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 574:	c9                   	leave  
 575:	c3                   	ret    

00000576 <memset>:

void*
memset(void *dst, int c, uint n)
{
 576:	55                   	push   %ebp
 577:	89 e5                	mov    %esp,%ebp
 579:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 57c:	8b 45 10             	mov    0x10(%ebp),%eax
 57f:	89 44 24 08          	mov    %eax,0x8(%esp)
 583:	8b 45 0c             	mov    0xc(%ebp),%eax
 586:	89 44 24 04          	mov    %eax,0x4(%esp)
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	89 04 24             	mov    %eax,(%esp)
 590:	e8 26 ff ff ff       	call   4bb <stosb>
  return dst;
 595:	8b 45 08             	mov    0x8(%ebp),%eax
}
 598:	c9                   	leave  
 599:	c3                   	ret    

0000059a <strchr>:

char*
strchr(const char *s, char c)
{
 59a:	55                   	push   %ebp
 59b:	89 e5                	mov    %esp,%ebp
 59d:	83 ec 04             	sub    $0x4,%esp
 5a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 5a6:	eb 14                	jmp    5bc <strchr+0x22>
    if(*s == c)
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	0f b6 00             	movzbl (%eax),%eax
 5ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
 5b1:	75 05                	jne    5b8 <strchr+0x1e>
      return (char*)s;
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
 5b6:	eb 13                	jmp    5cb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 5b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	0f b6 00             	movzbl (%eax),%eax
 5c2:	84 c0                	test   %al,%al
 5c4:	75 e2                	jne    5a8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 5c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5cb:	c9                   	leave  
 5cc:	c3                   	ret    

000005cd <gets>:

char*
gets(char *buf, int max)
{
 5cd:	55                   	push   %ebp
 5ce:	89 e5                	mov    %esp,%ebp
 5d0:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5da:	eb 4c                	jmp    628 <gets+0x5b>
    cc = read(0, &c, 1);
 5dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e3:	00 
 5e4:	8d 45 ef             	lea    -0x11(%ebp),%eax
 5e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5f2:	e8 44 01 00 00       	call   73b <read>
 5f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 5fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5fe:	7f 02                	jg     602 <gets+0x35>
      break;
 600:	eb 31                	jmp    633 <gets+0x66>
    buf[i++] = c;
 602:	8b 45 f4             	mov    -0xc(%ebp),%eax
 605:	8d 50 01             	lea    0x1(%eax),%edx
 608:	89 55 f4             	mov    %edx,-0xc(%ebp)
 60b:	89 c2                	mov    %eax,%edx
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	01 c2                	add    %eax,%edx
 612:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 616:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 618:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 61c:	3c 0a                	cmp    $0xa,%al
 61e:	74 13                	je     633 <gets+0x66>
 620:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 624:	3c 0d                	cmp    $0xd,%al
 626:	74 0b                	je     633 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 628:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62b:	83 c0 01             	add    $0x1,%eax
 62e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 631:	7c a9                	jl     5dc <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 633:	8b 55 f4             	mov    -0xc(%ebp),%edx
 636:	8b 45 08             	mov    0x8(%ebp),%eax
 639:	01 d0                	add    %edx,%eax
 63b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 641:	c9                   	leave  
 642:	c3                   	ret    

00000643 <stat>:

int
stat(char *n, struct stat *st)
{
 643:	55                   	push   %ebp
 644:	89 e5                	mov    %esp,%ebp
 646:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 649:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 650:	00 
 651:	8b 45 08             	mov    0x8(%ebp),%eax
 654:	89 04 24             	mov    %eax,(%esp)
 657:	e8 07 01 00 00       	call   763 <open>
 65c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 65f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 663:	79 07                	jns    66c <stat+0x29>
    return -1;
 665:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 66a:	eb 23                	jmp    68f <stat+0x4c>
  r = fstat(fd, st);
 66c:	8b 45 0c             	mov    0xc(%ebp),%eax
 66f:	89 44 24 04          	mov    %eax,0x4(%esp)
 673:	8b 45 f4             	mov    -0xc(%ebp),%eax
 676:	89 04 24             	mov    %eax,(%esp)
 679:	e8 fd 00 00 00       	call   77b <fstat>
 67e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 681:	8b 45 f4             	mov    -0xc(%ebp),%eax
 684:	89 04 24             	mov    %eax,(%esp)
 687:	e8 bf 00 00 00       	call   74b <close>
  return r;
 68c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 68f:	c9                   	leave  
 690:	c3                   	ret    

00000691 <atoi>:

int
atoi(const char *s)
{
 691:	55                   	push   %ebp
 692:	89 e5                	mov    %esp,%ebp
 694:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 697:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 69e:	eb 25                	jmp    6c5 <atoi+0x34>
    n = n*10 + *s++ - '0';
 6a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6a3:	89 d0                	mov    %edx,%eax
 6a5:	c1 e0 02             	shl    $0x2,%eax
 6a8:	01 d0                	add    %edx,%eax
 6aa:	01 c0                	add    %eax,%eax
 6ac:	89 c1                	mov    %eax,%ecx
 6ae:	8b 45 08             	mov    0x8(%ebp),%eax
 6b1:	8d 50 01             	lea    0x1(%eax),%edx
 6b4:	89 55 08             	mov    %edx,0x8(%ebp)
 6b7:	0f b6 00             	movzbl (%eax),%eax
 6ba:	0f be c0             	movsbl %al,%eax
 6bd:	01 c8                	add    %ecx,%eax
 6bf:	83 e8 30             	sub    $0x30,%eax
 6c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	0f b6 00             	movzbl (%eax),%eax
 6cb:	3c 2f                	cmp    $0x2f,%al
 6cd:	7e 0a                	jle    6d9 <atoi+0x48>
 6cf:	8b 45 08             	mov    0x8(%ebp),%eax
 6d2:	0f b6 00             	movzbl (%eax),%eax
 6d5:	3c 39                	cmp    $0x39,%al
 6d7:	7e c7                	jle    6a0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6dc:	c9                   	leave  
 6dd:	c3                   	ret    

000006de <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 6de:	55                   	push   %ebp
 6df:	89 e5                	mov    %esp,%ebp
 6e1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 6e4:	8b 45 08             	mov    0x8(%ebp),%eax
 6e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 6ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 6f0:	eb 17                	jmp    709 <memmove+0x2b>
    *dst++ = *src++;
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8d 50 01             	lea    0x1(%eax),%edx
 6f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
 6fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6fe:	8d 4a 01             	lea    0x1(%edx),%ecx
 701:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 704:	0f b6 12             	movzbl (%edx),%edx
 707:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 709:	8b 45 10             	mov    0x10(%ebp),%eax
 70c:	8d 50 ff             	lea    -0x1(%eax),%edx
 70f:	89 55 10             	mov    %edx,0x10(%ebp)
 712:	85 c0                	test   %eax,%eax
 714:	7f dc                	jg     6f2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 716:	8b 45 08             	mov    0x8(%ebp),%eax
}
 719:	c9                   	leave  
 71a:	c3                   	ret    

0000071b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 71b:	b8 01 00 00 00       	mov    $0x1,%eax
 720:	cd 40                	int    $0x40
 722:	c3                   	ret    

00000723 <exit>:
SYSCALL(exit)
 723:	b8 02 00 00 00       	mov    $0x2,%eax
 728:	cd 40                	int    $0x40
 72a:	c3                   	ret    

0000072b <wait>:
SYSCALL(wait)
 72b:	b8 03 00 00 00       	mov    $0x3,%eax
 730:	cd 40                	int    $0x40
 732:	c3                   	ret    

00000733 <pipe>:
SYSCALL(pipe)
 733:	b8 04 00 00 00       	mov    $0x4,%eax
 738:	cd 40                	int    $0x40
 73a:	c3                   	ret    

0000073b <read>:
SYSCALL(read)
 73b:	b8 05 00 00 00       	mov    $0x5,%eax
 740:	cd 40                	int    $0x40
 742:	c3                   	ret    

00000743 <write>:
SYSCALL(write)
 743:	b8 10 00 00 00       	mov    $0x10,%eax
 748:	cd 40                	int    $0x40
 74a:	c3                   	ret    

0000074b <close>:
SYSCALL(close)
 74b:	b8 15 00 00 00       	mov    $0x15,%eax
 750:	cd 40                	int    $0x40
 752:	c3                   	ret    

00000753 <kill>:
SYSCALL(kill)
 753:	b8 06 00 00 00       	mov    $0x6,%eax
 758:	cd 40                	int    $0x40
 75a:	c3                   	ret    

0000075b <exec>:
SYSCALL(exec)
 75b:	b8 07 00 00 00       	mov    $0x7,%eax
 760:	cd 40                	int    $0x40
 762:	c3                   	ret    

00000763 <open>:
SYSCALL(open)
 763:	b8 0f 00 00 00       	mov    $0xf,%eax
 768:	cd 40                	int    $0x40
 76a:	c3                   	ret    

0000076b <mknod>:
SYSCALL(mknod)
 76b:	b8 11 00 00 00       	mov    $0x11,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret    

00000773 <unlink>:
SYSCALL(unlink)
 773:	b8 12 00 00 00       	mov    $0x12,%eax
 778:	cd 40                	int    $0x40
 77a:	c3                   	ret    

0000077b <fstat>:
SYSCALL(fstat)
 77b:	b8 08 00 00 00       	mov    $0x8,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret    

00000783 <link>:
SYSCALL(link)
 783:	b8 13 00 00 00       	mov    $0x13,%eax
 788:	cd 40                	int    $0x40
 78a:	c3                   	ret    

0000078b <mkdir>:
SYSCALL(mkdir)
 78b:	b8 14 00 00 00       	mov    $0x14,%eax
 790:	cd 40                	int    $0x40
 792:	c3                   	ret    

00000793 <chdir>:
SYSCALL(chdir)
 793:	b8 09 00 00 00       	mov    $0x9,%eax
 798:	cd 40                	int    $0x40
 79a:	c3                   	ret    

0000079b <dup>:
SYSCALL(dup)
 79b:	b8 0a 00 00 00       	mov    $0xa,%eax
 7a0:	cd 40                	int    $0x40
 7a2:	c3                   	ret    

000007a3 <getpid>:
SYSCALL(getpid)
 7a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 7a8:	cd 40                	int    $0x40
 7aa:	c3                   	ret    

000007ab <sbrk>:
SYSCALL(sbrk)
 7ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 7b0:	cd 40                	int    $0x40
 7b2:	c3                   	ret    

000007b3 <sleep>:
SYSCALL(sleep)
 7b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 7b8:	cd 40                	int    $0x40
 7ba:	c3                   	ret    

000007bb <uptime>:
SYSCALL(uptime)
 7bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret    

000007c3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7c3:	55                   	push   %ebp
 7c4:	89 e5                	mov    %esp,%ebp
 7c6:	83 ec 18             	sub    $0x18,%esp
 7c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 7cc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7cf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7d6:	00 
 7d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7da:	89 44 24 04          	mov    %eax,0x4(%esp)
 7de:	8b 45 08             	mov    0x8(%ebp),%eax
 7e1:	89 04 24             	mov    %eax,(%esp)
 7e4:	e8 5a ff ff ff       	call   743 <write>
}
 7e9:	c9                   	leave  
 7ea:	c3                   	ret    

000007eb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7eb:	55                   	push   %ebp
 7ec:	89 e5                	mov    %esp,%ebp
 7ee:	56                   	push   %esi
 7ef:	53                   	push   %ebx
 7f0:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7fa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7fe:	74 17                	je     817 <printint+0x2c>
 800:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 804:	79 11                	jns    817 <printint+0x2c>
    neg = 1;
 806:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 80d:	8b 45 0c             	mov    0xc(%ebp),%eax
 810:	f7 d8                	neg    %eax
 812:	89 45 ec             	mov    %eax,-0x14(%ebp)
 815:	eb 06                	jmp    81d <printint+0x32>
  } else {
    x = xx;
 817:	8b 45 0c             	mov    0xc(%ebp),%eax
 81a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 81d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 824:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 827:	8d 41 01             	lea    0x1(%ecx),%eax
 82a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 830:	8b 45 ec             	mov    -0x14(%ebp),%eax
 833:	ba 00 00 00 00       	mov    $0x0,%edx
 838:	f7 f3                	div    %ebx
 83a:	89 d0                	mov    %edx,%eax
 83c:	0f b6 80 58 0f 00 00 	movzbl 0xf58(%eax),%eax
 843:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 847:	8b 75 10             	mov    0x10(%ebp),%esi
 84a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 84d:	ba 00 00 00 00       	mov    $0x0,%edx
 852:	f7 f6                	div    %esi
 854:	89 45 ec             	mov    %eax,-0x14(%ebp)
 857:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 85b:	75 c7                	jne    824 <printint+0x39>
  if(neg)
 85d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 861:	74 10                	je     873 <printint+0x88>
    buf[i++] = '-';
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	8d 50 01             	lea    0x1(%eax),%edx
 869:	89 55 f4             	mov    %edx,-0xc(%ebp)
 86c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 871:	eb 1f                	jmp    892 <printint+0xa7>
 873:	eb 1d                	jmp    892 <printint+0xa7>
    putc(fd, buf[i]);
 875:	8d 55 dc             	lea    -0x24(%ebp),%edx
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	01 d0                	add    %edx,%eax
 87d:	0f b6 00             	movzbl (%eax),%eax
 880:	0f be c0             	movsbl %al,%eax
 883:	89 44 24 04          	mov    %eax,0x4(%esp)
 887:	8b 45 08             	mov    0x8(%ebp),%eax
 88a:	89 04 24             	mov    %eax,(%esp)
 88d:	e8 31 ff ff ff       	call   7c3 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 892:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89a:	79 d9                	jns    875 <printint+0x8a>
    putc(fd, buf[i]);
}
 89c:	83 c4 30             	add    $0x30,%esp
 89f:	5b                   	pop    %ebx
 8a0:	5e                   	pop    %esi
 8a1:	5d                   	pop    %ebp
 8a2:	c3                   	ret    

000008a3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 8a3:	55                   	push   %ebp
 8a4:	89 e5                	mov    %esp,%ebp
 8a6:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8b0:	8d 45 0c             	lea    0xc(%ebp),%eax
 8b3:	83 c0 04             	add    $0x4,%eax
 8b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8c0:	e9 7c 01 00 00       	jmp    a41 <printf+0x19e>
    c = fmt[i] & 0xff;
 8c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 8c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cb:	01 d0                	add    %edx,%eax
 8cd:	0f b6 00             	movzbl (%eax),%eax
 8d0:	0f be c0             	movsbl %al,%eax
 8d3:	25 ff 00 00 00       	and    $0xff,%eax
 8d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8df:	75 2c                	jne    90d <printf+0x6a>
      if(c == '%'){
 8e1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8e5:	75 0c                	jne    8f3 <printf+0x50>
        state = '%';
 8e7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8ee:	e9 4a 01 00 00       	jmp    a3d <printf+0x19a>
      } else {
        putc(fd, c);
 8f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8f6:	0f be c0             	movsbl %al,%eax
 8f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8fd:	8b 45 08             	mov    0x8(%ebp),%eax
 900:	89 04 24             	mov    %eax,(%esp)
 903:	e8 bb fe ff ff       	call   7c3 <putc>
 908:	e9 30 01 00 00       	jmp    a3d <printf+0x19a>
      }
    } else if(state == '%'){
 90d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 911:	0f 85 26 01 00 00    	jne    a3d <printf+0x19a>
      if(c == 'd'){
 917:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 91b:	75 2d                	jne    94a <printf+0xa7>
        printint(fd, *ap, 10, 1);
 91d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 920:	8b 00                	mov    (%eax),%eax
 922:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 929:	00 
 92a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 931:	00 
 932:	89 44 24 04          	mov    %eax,0x4(%esp)
 936:	8b 45 08             	mov    0x8(%ebp),%eax
 939:	89 04 24             	mov    %eax,(%esp)
 93c:	e8 aa fe ff ff       	call   7eb <printint>
        ap++;
 941:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 945:	e9 ec 00 00 00       	jmp    a36 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 94a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 94e:	74 06                	je     956 <printf+0xb3>
 950:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 954:	75 2d                	jne    983 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 956:	8b 45 e8             	mov    -0x18(%ebp),%eax
 959:	8b 00                	mov    (%eax),%eax
 95b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 962:	00 
 963:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 96a:	00 
 96b:	89 44 24 04          	mov    %eax,0x4(%esp)
 96f:	8b 45 08             	mov    0x8(%ebp),%eax
 972:	89 04 24             	mov    %eax,(%esp)
 975:	e8 71 fe ff ff       	call   7eb <printint>
        ap++;
 97a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 97e:	e9 b3 00 00 00       	jmp    a36 <printf+0x193>
      } else if(c == 's'){
 983:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 987:	75 45                	jne    9ce <printf+0x12b>
        s = (char*)*ap;
 989:	8b 45 e8             	mov    -0x18(%ebp),%eax
 98c:	8b 00                	mov    (%eax),%eax
 98e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 991:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 995:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 999:	75 09                	jne    9a4 <printf+0x101>
          s = "(null)";
 99b:	c7 45 f4 b9 0c 00 00 	movl   $0xcb9,-0xc(%ebp)
        while(*s != 0){
 9a2:	eb 1e                	jmp    9c2 <printf+0x11f>
 9a4:	eb 1c                	jmp    9c2 <printf+0x11f>
          putc(fd, *s);
 9a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a9:	0f b6 00             	movzbl (%eax),%eax
 9ac:	0f be c0             	movsbl %al,%eax
 9af:	89 44 24 04          	mov    %eax,0x4(%esp)
 9b3:	8b 45 08             	mov    0x8(%ebp),%eax
 9b6:	89 04 24             	mov    %eax,(%esp)
 9b9:	e8 05 fe ff ff       	call   7c3 <putc>
          s++;
 9be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c5:	0f b6 00             	movzbl (%eax),%eax
 9c8:	84 c0                	test   %al,%al
 9ca:	75 da                	jne    9a6 <printf+0x103>
 9cc:	eb 68                	jmp    a36 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9ce:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9d2:	75 1d                	jne    9f1 <printf+0x14e>
        putc(fd, *ap);
 9d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9d7:	8b 00                	mov    (%eax),%eax
 9d9:	0f be c0             	movsbl %al,%eax
 9dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 9e0:	8b 45 08             	mov    0x8(%ebp),%eax
 9e3:	89 04 24             	mov    %eax,(%esp)
 9e6:	e8 d8 fd ff ff       	call   7c3 <putc>
        ap++;
 9eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9ef:	eb 45                	jmp    a36 <printf+0x193>
      } else if(c == '%'){
 9f1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9f5:	75 17                	jne    a0e <printf+0x16b>
        putc(fd, c);
 9f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9fa:	0f be c0             	movsbl %al,%eax
 9fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 a01:	8b 45 08             	mov    0x8(%ebp),%eax
 a04:	89 04 24             	mov    %eax,(%esp)
 a07:	e8 b7 fd ff ff       	call   7c3 <putc>
 a0c:	eb 28                	jmp    a36 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a0e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a15:	00 
 a16:	8b 45 08             	mov    0x8(%ebp),%eax
 a19:	89 04 24             	mov    %eax,(%esp)
 a1c:	e8 a2 fd ff ff       	call   7c3 <putc>
        putc(fd, c);
 a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a24:	0f be c0             	movsbl %al,%eax
 a27:	89 44 24 04          	mov    %eax,0x4(%esp)
 a2b:	8b 45 08             	mov    0x8(%ebp),%eax
 a2e:	89 04 24             	mov    %eax,(%esp)
 a31:	e8 8d fd ff ff       	call   7c3 <putc>
      }
      state = 0;
 a36:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a3d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a41:	8b 55 0c             	mov    0xc(%ebp),%edx
 a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a47:	01 d0                	add    %edx,%eax
 a49:	0f b6 00             	movzbl (%eax),%eax
 a4c:	84 c0                	test   %al,%al
 a4e:	0f 85 71 fe ff ff    	jne    8c5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a54:	c9                   	leave  
 a55:	c3                   	ret    

00000a56 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a56:	55                   	push   %ebp
 a57:	89 e5                	mov    %esp,%ebp
 a59:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a5c:	8b 45 08             	mov    0x8(%ebp),%eax
 a5f:	83 e8 08             	sub    $0x8,%eax
 a62:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a65:	a1 84 0f 00 00       	mov    0xf84,%eax
 a6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a6d:	eb 24                	jmp    a93 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a72:	8b 00                	mov    (%eax),%eax
 a74:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a77:	77 12                	ja     a8b <free+0x35>
 a79:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a7f:	77 24                	ja     aa5 <free+0x4f>
 a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a84:	8b 00                	mov    (%eax),%eax
 a86:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a89:	77 1a                	ja     aa5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8e:	8b 00                	mov    (%eax),%eax
 a90:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a93:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a96:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a99:	76 d4                	jbe    a6f <free+0x19>
 a9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9e:	8b 00                	mov    (%eax),%eax
 aa0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 aa3:	76 ca                	jbe    a6f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 aa5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa8:	8b 40 04             	mov    0x4(%eax),%eax
 aab:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ab2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab5:	01 c2                	add    %eax,%edx
 ab7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aba:	8b 00                	mov    (%eax),%eax
 abc:	39 c2                	cmp    %eax,%edx
 abe:	75 24                	jne    ae4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ac0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac3:	8b 50 04             	mov    0x4(%eax),%edx
 ac6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac9:	8b 00                	mov    (%eax),%eax
 acb:	8b 40 04             	mov    0x4(%eax),%eax
 ace:	01 c2                	add    %eax,%edx
 ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad9:	8b 00                	mov    (%eax),%eax
 adb:	8b 10                	mov    (%eax),%edx
 add:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae0:	89 10                	mov    %edx,(%eax)
 ae2:	eb 0a                	jmp    aee <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ae4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae7:	8b 10                	mov    (%eax),%edx
 ae9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aec:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 aee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af1:	8b 40 04             	mov    0x4(%eax),%eax
 af4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 afb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 afe:	01 d0                	add    %edx,%eax
 b00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b03:	75 20                	jne    b25 <free+0xcf>
    p->s.size += bp->s.size;
 b05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b08:	8b 50 04             	mov    0x4(%eax),%edx
 b0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b0e:	8b 40 04             	mov    0x4(%eax),%eax
 b11:	01 c2                	add    %eax,%edx
 b13:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b16:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b19:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b1c:	8b 10                	mov    (%eax),%edx
 b1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b21:	89 10                	mov    %edx,(%eax)
 b23:	eb 08                	jmp    b2d <free+0xd7>
  } else
    p->s.ptr = bp;
 b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b28:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b2b:	89 10                	mov    %edx,(%eax)
  freep = p;
 b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b30:	a3 84 0f 00 00       	mov    %eax,0xf84
}
 b35:	c9                   	leave  
 b36:	c3                   	ret    

00000b37 <morecore>:

static Header*
morecore(uint nu)
{
 b37:	55                   	push   %ebp
 b38:	89 e5                	mov    %esp,%ebp
 b3a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b3d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b44:	77 07                	ja     b4d <morecore+0x16>
    nu = 4096;
 b46:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b4d:	8b 45 08             	mov    0x8(%ebp),%eax
 b50:	c1 e0 03             	shl    $0x3,%eax
 b53:	89 04 24             	mov    %eax,(%esp)
 b56:	e8 50 fc ff ff       	call   7ab <sbrk>
 b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b5e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b62:	75 07                	jne    b6b <morecore+0x34>
    return 0;
 b64:	b8 00 00 00 00       	mov    $0x0,%eax
 b69:	eb 22                	jmp    b8d <morecore+0x56>
  hp = (Header*)p;
 b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b74:	8b 55 08             	mov    0x8(%ebp),%edx
 b77:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b7d:	83 c0 08             	add    $0x8,%eax
 b80:	89 04 24             	mov    %eax,(%esp)
 b83:	e8 ce fe ff ff       	call   a56 <free>
  return freep;
 b88:	a1 84 0f 00 00       	mov    0xf84,%eax
}
 b8d:	c9                   	leave  
 b8e:	c3                   	ret    

00000b8f <malloc>:

void*
malloc(uint nbytes)
{
 b8f:	55                   	push   %ebp
 b90:	89 e5                	mov    %esp,%ebp
 b92:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b95:	8b 45 08             	mov    0x8(%ebp),%eax
 b98:	83 c0 07             	add    $0x7,%eax
 b9b:	c1 e8 03             	shr    $0x3,%eax
 b9e:	83 c0 01             	add    $0x1,%eax
 ba1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ba4:	a1 84 0f 00 00       	mov    0xf84,%eax
 ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 bb0:	75 23                	jne    bd5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 bb2:	c7 45 f0 7c 0f 00 00 	movl   $0xf7c,-0x10(%ebp)
 bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bbc:	a3 84 0f 00 00       	mov    %eax,0xf84
 bc1:	a1 84 0f 00 00       	mov    0xf84,%eax
 bc6:	a3 7c 0f 00 00       	mov    %eax,0xf7c
    base.s.size = 0;
 bcb:	c7 05 80 0f 00 00 00 	movl   $0x0,0xf80
 bd2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bd8:	8b 00                	mov    (%eax),%eax
 bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be0:	8b 40 04             	mov    0x4(%eax),%eax
 be3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 be6:	72 4d                	jb     c35 <malloc+0xa6>
      if(p->s.size == nunits)
 be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 beb:	8b 40 04             	mov    0x4(%eax),%eax
 bee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bf1:	75 0c                	jne    bff <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf6:	8b 10                	mov    (%eax),%edx
 bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bfb:	89 10                	mov    %edx,(%eax)
 bfd:	eb 26                	jmp    c25 <malloc+0x96>
      else {
        p->s.size -= nunits;
 bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c02:	8b 40 04             	mov    0x4(%eax),%eax
 c05:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c08:	89 c2                	mov    %eax,%edx
 c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c0d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c13:	8b 40 04             	mov    0x4(%eax),%eax
 c16:	c1 e0 03             	shl    $0x3,%eax
 c19:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c22:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c28:	a3 84 0f 00 00       	mov    %eax,0xf84
      return (void*)(p + 1);
 c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c30:	83 c0 08             	add    $0x8,%eax
 c33:	eb 38                	jmp    c6d <malloc+0xde>
    }
    if(p == freep)
 c35:	a1 84 0f 00 00       	mov    0xf84,%eax
 c3a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c3d:	75 1b                	jne    c5a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c42:	89 04 24             	mov    %eax,(%esp)
 c45:	e8 ed fe ff ff       	call   b37 <morecore>
 c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c51:	75 07                	jne    c5a <malloc+0xcb>
        return 0;
 c53:	b8 00 00 00 00       	mov    $0x0,%eax
 c58:	eb 13                	jmp    c6d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c63:	8b 00                	mov    (%eax),%eax
 c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c68:	e9 70 ff ff ff       	jmp    bdd <malloc+0x4e>
}
 c6d:	c9                   	leave  
 c6e:	c3                   	ret    
