
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
static struct job * jobsAr[64];

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 0c                	jne    18 <runcmd+0x18>
    exit(0);
       c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      13:	e8 f8 13 00 00       	call   1410 <exit>
  
  switch(cmd->type){
      18:	8b 45 08             	mov    0x8(%ebp),%eax
      1b:	8b 00                	mov    (%eax),%eax
      1d:	83 f8 05             	cmp    $0x5,%eax
      20:	77 09                	ja     2b <runcmd+0x2b>
      22:	8b 04 85 c0 19 00 00 	mov    0x19c0(,%eax,4),%eax
      29:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      2b:	c7 04 24 94 19 00 00 	movl   $0x1994,(%esp)
      32:	e8 4a 06 00 00       	call   681 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      37:	8b 45 08             	mov    0x8(%ebp),%eax
      3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      40:	8b 40 04             	mov    0x4(%eax),%eax
      43:	85 c0                	test   %eax,%eax
      45:	75 0c                	jne    53 <runcmd+0x53>
      exit(0);
      47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      4e:	e8 bd 13 00 00       	call   1410 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      53:	8b 45 f4             	mov    -0xc(%ebp),%eax
      56:	8d 50 04             	lea    0x4(%eax),%edx
      59:	8b 45 f4             	mov    -0xc(%ebp),%eax
      5c:	8b 40 04             	mov    0x4(%eax),%eax
      5f:	89 54 24 04          	mov    %edx,0x4(%esp)
      63:	89 04 24             	mov    %eax,(%esp)
      66:	e8 ed 13 00 00       	call   1458 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      6e:	8b 40 04             	mov    0x4(%eax),%eax
      71:	89 44 24 08          	mov    %eax,0x8(%esp)
      75:	c7 44 24 04 9b 19 00 	movl   $0x199b,0x4(%esp)
      7c:	00 
      7d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      84:	e8 3f 15 00 00       	call   15c8 <printf>
    break;
      89:	e9 a2 01 00 00       	jmp    230 <runcmd+0x230>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      8e:	8b 45 08             	mov    0x8(%ebp),%eax
      91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      94:	8b 45 f0             	mov    -0x10(%ebp),%eax
      97:	8b 40 14             	mov    0x14(%eax),%eax
      9a:	89 04 24             	mov    %eax,(%esp)
      9d:	e8 a6 13 00 00       	call   1448 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a5:	8b 50 10             	mov    0x10(%eax),%edx
      a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
      ab:	8b 40 08             	mov    0x8(%eax),%eax
      ae:	89 54 24 04          	mov    %edx,0x4(%esp)
      b2:	89 04 24             	mov    %eax,(%esp)
      b5:	e8 a6 13 00 00       	call   1460 <open>
      ba:	85 c0                	test   %eax,%eax
      bc:	79 2a                	jns    e8 <runcmd+0xe8>
      printf(2, "open %s failed\n", rcmd->file);
      be:	8b 45 f0             	mov    -0x10(%ebp),%eax
      c1:	8b 40 08             	mov    0x8(%eax),%eax
      c4:	89 44 24 08          	mov    %eax,0x8(%esp)
      c8:	c7 44 24 04 ab 19 00 	movl   $0x19ab,0x4(%esp)
      cf:	00 
      d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      d7:	e8 ec 14 00 00       	call   15c8 <printf>
      exit(0);
      dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      e3:	e8 28 13 00 00       	call   1410 <exit>
    }
    runcmd(rcmd->cmd);
      e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
      eb:	8b 40 04             	mov    0x4(%eax),%eax
      ee:	89 04 24             	mov    %eax,(%esp)
      f1:	e8 0a ff ff ff       	call   0 <runcmd>
    break;
      f6:	e9 35 01 00 00       	jmp    230 <runcmd+0x230>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      fb:	8b 45 08             	mov    0x8(%ebp),%eax
      fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
     101:	e8 a8 05 00 00       	call   6ae <fork1>
     106:	85 c0                	test   %eax,%eax
     108:	75 0e                	jne    118 <runcmd+0x118>
      runcmd(lcmd->left);
     10a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     10d:	8b 40 04             	mov    0x4(%eax),%eax
     110:	89 04 24             	mov    %eax,(%esp)
     113:	e8 e8 fe ff ff       	call   0 <runcmd>
    wait(0);
     118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     11f:	e8 f4 12 00 00       	call   1418 <wait>
    runcmd(lcmd->right);
     124:	8b 45 ec             	mov    -0x14(%ebp),%eax
     127:	8b 40 08             	mov    0x8(%eax),%eax
     12a:	89 04 24             	mov    %eax,(%esp)
     12d:	e8 ce fe ff ff       	call   0 <runcmd>
    break;
     132:	e9 f9 00 00 00       	jmp    230 <runcmd+0x230>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     137:	8b 45 08             	mov    0x8(%ebp),%eax
     13a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     13d:	8d 45 dc             	lea    -0x24(%ebp),%eax
     140:	89 04 24             	mov    %eax,(%esp)
     143:	e8 e8 12 00 00       	call   1430 <pipe>
     148:	85 c0                	test   %eax,%eax
     14a:	79 0c                	jns    158 <runcmd+0x158>
      panic("pipe");
     14c:	c7 04 24 bb 19 00 00 	movl   $0x19bb,(%esp)
     153:	e8 29 05 00 00       	call   681 <panic>
    if(fork1() == 0){
     158:	e8 51 05 00 00       	call   6ae <fork1>
     15d:	85 c0                	test   %eax,%eax
     15f:	75 3b                	jne    19c <runcmd+0x19c>
      close(1);
     161:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     168:	e8 db 12 00 00       	call   1448 <close>
      dup(p[1]);
     16d:	8b 45 e0             	mov    -0x20(%ebp),%eax
     170:	89 04 24             	mov    %eax,(%esp)
     173:	e8 20 13 00 00       	call   1498 <dup>
      close(p[0]);
     178:	8b 45 dc             	mov    -0x24(%ebp),%eax
     17b:	89 04 24             	mov    %eax,(%esp)
     17e:	e8 c5 12 00 00       	call   1448 <close>
      close(p[1]);
     183:	8b 45 e0             	mov    -0x20(%ebp),%eax
     186:	89 04 24             	mov    %eax,(%esp)
     189:	e8 ba 12 00 00       	call   1448 <close>
      runcmd(pcmd->left);
     18e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     191:	8b 40 04             	mov    0x4(%eax),%eax
     194:	89 04 24             	mov    %eax,(%esp)
     197:	e8 64 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     19c:	e8 0d 05 00 00       	call   6ae <fork1>
     1a1:	85 c0                	test   %eax,%eax
     1a3:	75 3b                	jne    1e0 <runcmd+0x1e0>
      close(0);
     1a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1ac:	e8 97 12 00 00       	call   1448 <close>
      dup(p[0]);
     1b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1b4:	89 04 24             	mov    %eax,(%esp)
     1b7:	e8 dc 12 00 00       	call   1498 <dup>
      close(p[0]);
     1bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1bf:	89 04 24             	mov    %eax,(%esp)
     1c2:	e8 81 12 00 00       	call   1448 <close>
      close(p[1]);
     1c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ca:	89 04 24             	mov    %eax,(%esp)
     1cd:	e8 76 12 00 00       	call   1448 <close>
      runcmd(pcmd->right);
     1d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1d5:	8b 40 08             	mov    0x8(%eax),%eax
     1d8:	89 04 24             	mov    %eax,(%esp)
     1db:	e8 20 fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1e3:	89 04 24             	mov    %eax,(%esp)
     1e6:	e8 5d 12 00 00       	call   1448 <close>
    close(p[1]);
     1eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ee:	89 04 24             	mov    %eax,(%esp)
     1f1:	e8 52 12 00 00       	call   1448 <close>
    wait(0);
     1f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1fd:	e8 16 12 00 00       	call   1418 <wait>
    wait(0);
     202:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     209:	e8 0a 12 00 00       	call   1418 <wait>
    break;
     20e:	eb 20                	jmp    230 <runcmd+0x230>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     210:	8b 45 08             	mov    0x8(%ebp),%eax
     213:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     216:	e8 93 04 00 00       	call   6ae <fork1>
     21b:	85 c0                	test   %eax,%eax
     21d:	75 10                	jne    22f <runcmd+0x22f>
      runcmd(bcmd->cmd);
     21f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     222:	8b 40 04             	mov    0x4(%eax),%eax
     225:	89 04 24             	mov    %eax,(%esp)
     228:	e8 d3 fd ff ff       	call   0 <runcmd>
    break;
     22d:	eb 00                	jmp    22f <runcmd+0x22f>
     22f:	90                   	nop
  }
  exit(0);
     230:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     237:	e8 d4 11 00 00       	call   1410 <exit>

0000023c <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     23c:	55                   	push   %ebp
     23d:	89 e5                	mov    %esp,%ebp
     23f:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     242:	c7 44 24 04 d8 19 00 	movl   $0x19d8,0x4(%esp)
     249:	00 
     24a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     251:	e8 72 13 00 00       	call   15c8 <printf>
  memset(buf, 0, nbuf);
     256:	8b 45 0c             	mov    0xc(%ebp),%eax
     259:	89 44 24 08          	mov    %eax,0x8(%esp)
     25d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     264:	00 
     265:	8b 45 08             	mov    0x8(%ebp),%eax
     268:	89 04 24             	mov    %eax,(%esp)
     26b:	e8 f3 0f 00 00       	call   1263 <memset>
  gets(buf, nbuf);
     270:	8b 45 0c             	mov    0xc(%ebp),%eax
     273:	89 44 24 04          	mov    %eax,0x4(%esp)
     277:	8b 45 08             	mov    0x8(%ebp),%eax
     27a:	89 04 24             	mov    %eax,(%esp)
     27d:	e8 38 10 00 00       	call   12ba <gets>
  if(buf[0] == 0) // EOF
     282:	8b 45 08             	mov    0x8(%ebp),%eax
     285:	0f b6 00             	movzbl (%eax),%eax
     288:	84 c0                	test   %al,%al
     28a:	75 07                	jne    293 <getcmd+0x57>
    return -1;
     28c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     291:	eb 05                	jmp    298 <getcmd+0x5c>
  return 0;
     293:	b8 00 00 00 00       	mov    $0x0,%eax
}
     298:	c9                   	leave  
     299:	c3                   	ret    

0000029a <main>:

int
main(void)
{
     29a:	55                   	push   %ebp
     29b:	89 e5                	mov    %esp,%ebp
     29d:	83 e4 f0             	and    $0xfffffff0,%esp
     2a0:	81 ec 40 01 00 00    	sub    $0x140,%esp
  static char buf[100];
  int fd;
  int i, jobIndex, gid;
  for (i=0;i<64;i++){
     2a6:	c7 84 24 3c 01 00 00 	movl   $0x0,0x13c(%esp)
     2ad:	00 00 00 00 
     2b1:	eb 1a                	jmp    2cd <main+0x33>
	jobsAr[i]=0;
     2b3:	8b 84 24 3c 01 00 00 	mov    0x13c(%esp),%eax
     2ba:	c7 04 85 e0 1f 00 00 	movl   $0x0,0x1fe0(,%eax,4)
     2c1:	00 00 00 00 
main(void)
{
  static char buf[100];
  int fd;
  int i, jobIndex, gid;
  for (i=0;i<64;i++){
     2c5:	83 84 24 3c 01 00 00 	addl   $0x1,0x13c(%esp)
     2cc:	01 
     2cd:	83 bc 24 3c 01 00 00 	cmpl   $0x3f,0x13c(%esp)
     2d4:	3f 
     2d5:	7e dc                	jle    2b3 <main+0x19>
	jobsAr[i]=0;
  }
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2d7:	eb 1b                	jmp    2f4 <main+0x5a>
    if(fd >= 3){
     2d9:	83 bc 24 2c 01 00 00 	cmpl   $0x2,0x12c(%esp)
     2e0:	02 
     2e1:	7e 11                	jle    2f4 <main+0x5a>
      close(fd);
     2e3:	8b 84 24 2c 01 00 00 	mov    0x12c(%esp),%eax
     2ea:	89 04 24             	mov    %eax,(%esp)
     2ed:	e8 56 11 00 00       	call   1448 <close>
      break;
     2f2:	eb 25                	jmp    319 <main+0x7f>
  int i, jobIndex, gid;
  for (i=0;i<64;i++){
	jobsAr[i]=0;
  }
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2f4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     2fb:	00 
     2fc:	c7 04 24 db 19 00 00 	movl   $0x19db,(%esp)
     303:	e8 58 11 00 00       	call   1460 <open>
     308:	89 84 24 2c 01 00 00 	mov    %eax,0x12c(%esp)
     30f:	83 bc 24 2c 01 00 00 	cmpl   $0x0,0x12c(%esp)
     316:	00 
     317:	79 c0                	jns    2d9 <main+0x3f>
      close(fd);
      break;
    }
  }
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     319:	e9 3b 03 00 00       	jmp    659 <main+0x3bf>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     31e:	0f b6 05 e0 20 00 00 	movzbl 0x20e0,%eax
     325:	3c 63                	cmp    $0x63,%al
     327:	75 62                	jne    38b <main+0xf1>
     329:	0f b6 05 e1 20 00 00 	movzbl 0x20e1,%eax
     330:	3c 64                	cmp    $0x64,%al
     332:	75 57                	jne    38b <main+0xf1>
     334:	0f b6 05 e2 20 00 00 	movzbl 0x20e2,%eax
     33b:	3c 20                	cmp    $0x20,%al
     33d:	75 4c                	jne    38b <main+0xf1>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     33f:	c7 04 24 e0 20 00 00 	movl   $0x20e0,(%esp)
     346:	e8 f1 0e 00 00       	call   123c <strlen>
     34b:	83 e8 01             	sub    $0x1,%eax
     34e:	c6 80 e0 20 00 00 00 	movb   $0x0,0x20e0(%eax)
      if(chdir(buf+3) < 0)
     355:	c7 04 24 e3 20 00 00 	movl   $0x20e3,(%esp)
     35c:	e8 2f 11 00 00       	call   1490 <chdir>
     361:	85 c0                	test   %eax,%eax
     363:	79 21                	jns    386 <main+0xec>
        printf(2, "cannot cd %s\n", buf+3);
     365:	c7 44 24 08 e3 20 00 	movl   $0x20e3,0x8(%esp)
     36c:	00 
     36d:	c7 44 24 04 e3 19 00 	movl   $0x19e3,0x4(%esp)
     374:	00 
     375:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     37c:	e8 47 12 00 00       	call   15c8 <printf>
      continue;
     381:	e9 d3 02 00 00       	jmp    659 <main+0x3bf>
     386:	e9 ce 02 00 00       	jmp    659 <main+0x3bf>
    }
    else if (buf[0] == 'j' && buf[1] == 'o' && buf[2] == 'b' && buf[3] == 's'){
     38b:	0f b6 05 e0 20 00 00 	movzbl 0x20e0,%eax
     392:	3c 6a                	cmp    $0x6a,%al
     394:	75 2b                	jne    3c1 <main+0x127>
     396:	0f b6 05 e1 20 00 00 	movzbl 0x20e1,%eax
     39d:	3c 6f                	cmp    $0x6f,%al
     39f:	75 20                	jne    3c1 <main+0x127>
     3a1:	0f b6 05 e2 20 00 00 	movzbl 0x20e2,%eax
     3a8:	3c 62                	cmp    $0x62,%al
     3aa:	75 15                	jne    3c1 <main+0x127>
     3ac:	0f b6 05 e3 20 00 00 	movzbl 0x20e3,%eax
     3b3:	3c 73                	cmp    $0x73,%al
     3b5:	75 0a                	jne    3c1 <main+0x127>
	jobsPrint();
     3b7:	e8 0c 0d 00 00       	call   10c8 <jobsPrint>
	continue;
     3bc:	e9 98 02 00 00       	jmp    659 <main+0x3bf>
    }
	if (buf[0] == 'f' && buf[1] == 'g') { 
     3c1:	0f b6 05 e0 20 00 00 	movzbl 0x20e0,%eax
     3c8:	3c 66                	cmp    $0x66,%al
     3ca:	0f 85 c8 01 00 00    	jne    598 <main+0x2fe>
     3d0:	0f b6 05 e1 20 00 00 	movzbl 0x20e1,%eax
     3d7:	3c 67                	cmp    $0x67,%al
     3d9:	0f 85 b9 01 00 00    	jne    598 <main+0x2fe>
		int gid,i,jobIndex = atoi(((struct execcmd*)parsecmd(buf))->argv[1]);
     3df:	c7 04 24 e0 20 00 00 	movl   $0x20e0,(%esp)
     3e6:	e8 38 06 00 00       	call   a23 <parsecmd>
     3eb:	8b 40 08             	mov    0x8(%eax),%eax
     3ee:	89 04 24             	mov    %eax,(%esp)
     3f1:	e8 88 0f 00 00       	call   137e <atoi>
     3f6:	89 84 24 28 01 00 00 	mov    %eax,0x128(%esp)
		if (jobIndex < 1) {
     3fd:	83 bc 24 28 01 00 00 	cmpl   $0x0,0x128(%esp)
     404:	00 
     405:	7f 4e                	jg     455 <main+0x1bb>
			for (i=0;i<64;i++) {
     407:	c7 84 24 34 01 00 00 	movl   $0x0,0x134(%esp)
     40e:	00 00 00 00 
     412:	eb 35                	jmp    449 <main+0x1af>
				if (jobsAr[i]) {
     414:	8b 84 24 34 01 00 00 	mov    0x134(%esp),%eax
     41b:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
     422:	85 c0                	test   %eax,%eax
     424:	74 1b                	je     441 <main+0x1a7>
					gid = jobsAr[i]->gid;
     426:	8b 84 24 34 01 00 00 	mov    0x134(%esp),%eax
     42d:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
     434:	8b 40 04             	mov    0x4(%eax),%eax
     437:	89 84 24 38 01 00 00 	mov    %eax,0x138(%esp)
					break;		
     43e:	90                   	nop
     43f:	eb 2f                	jmp    470 <main+0x1d6>
	continue;
    }
	if (buf[0] == 'f' && buf[1] == 'g') { 
		int gid,i,jobIndex = atoi(((struct execcmd*)parsecmd(buf))->argv[1]);
		if (jobIndex < 1) {
			for (i=0;i<64;i++) {
     441:	83 84 24 34 01 00 00 	addl   $0x1,0x134(%esp)
     448:	01 
     449:	83 bc 24 34 01 00 00 	cmpl   $0x3f,0x134(%esp)
     450:	3f 
     451:	7e c1                	jle    414 <main+0x17a>
     453:	eb 1b                	jmp    470 <main+0x1d6>
					break;		
				}
			}
		}
		else {
			gid = jobsAr[jobIndex-1]->gid;
     455:	8b 84 24 28 01 00 00 	mov    0x128(%esp),%eax
     45c:	83 e8 01             	sub    $0x1,%eax
     45f:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
     466:	8b 40 04             	mov    0x4(%eax),%eax
     469:	89 84 24 38 01 00 00 	mov    %eax,0x138(%esp)
		}
		if (gid ==0) {
     470:	83 bc 24 38 01 00 00 	cmpl   $0x0,0x138(%esp)
     477:	00 
     478:	75 19                	jne    493 <main+0x1f9>
			printf(2,"no jobs to move to foreground.\n");
     47a:	c7 44 24 04 f4 19 00 	movl   $0x19f4,0x4(%esp)
     481:	00 
     482:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     489:	e8 3a 11 00 00       	call   15c8 <printf>
			continue;
     48e:	e9 c6 01 00 00       	jmp    659 <main+0x3bf>
		}
		int pid,min=0;
     493:	c7 84 24 30 01 00 00 	movl   $0x0,0x130(%esp)
     49a:	00 00 00 00 
		int procs[64];
		for (i=0;i<64;i++) {
     49e:	c7 84 24 34 01 00 00 	movl   $0x0,0x134(%esp)
     4a5:	00 00 00 00 
     4a9:	eb 17                	jmp    4c2 <main+0x228>
			procs[i]=0;
     4ab:	8b 84 24 34 01 00 00 	mov    0x134(%esp),%eax
     4b2:	c7 44 84 18 00 00 00 	movl   $0x0,0x18(%esp,%eax,4)
     4b9:	00 
			printf(2,"no jobs to move to foreground.\n");
			continue;
		}
		int pid,min=0;
		int procs[64];
		for (i=0;i<64;i++) {
     4ba:	83 84 24 34 01 00 00 	addl   $0x1,0x134(%esp)
     4c1:	01 
     4c2:	83 bc 24 34 01 00 00 	cmpl   $0x3f,0x134(%esp)
     4c9:	3f 
     4ca:	7e df                	jle    4ab <main+0x211>
			procs[i]=0;
		}
		i=0;
     4cc:	c7 84 24 34 01 00 00 	movl   $0x0,0x134(%esp)
     4d3:	00 00 00 00 
		while ((pid = gidpid(gid,min)) != 0) {		
     4d7:	eb 47                	jmp    520 <main+0x286>
			min=pid;
     4d9:	8b 84 24 24 01 00 00 	mov    0x124(%esp),%eax
     4e0:	89 84 24 30 01 00 00 	mov    %eax,0x130(%esp)
			if (min == -1) 
     4e7:	83 bc 24 30 01 00 00 	cmpl   $0xffffffff,0x130(%esp)
     4ee:	ff 
     4ef:	75 02                	jne    4f3 <main+0x259>
				break;			
     4f1:	eb 58                	jmp    54b <main+0x2b1>
			if(!isShell(pid)) {
     4f3:	8b 84 24 24 01 00 00 	mov    0x124(%esp),%eax
     4fa:	89 04 24             	mov    %eax,(%esp)
     4fd:	e8 de 0f 00 00       	call   14e0 <isShell>
     502:	85 c0                	test   %eax,%eax
     504:	75 1a                	jne    520 <main+0x286>
				procs[i]=pid;
     506:	8b 84 24 34 01 00 00 	mov    0x134(%esp),%eax
     50d:	8b 94 24 24 01 00 00 	mov    0x124(%esp),%edx
     514:	89 54 84 18          	mov    %edx,0x18(%esp,%eax,4)
				i++;
     518:	83 84 24 34 01 00 00 	addl   $0x1,0x134(%esp)
     51f:	01 
		int procs[64];
		for (i=0;i<64;i++) {
			procs[i]=0;
		}
		i=0;
		while ((pid = gidpid(gid,min)) != 0) {		
     520:	8b 84 24 30 01 00 00 	mov    0x130(%esp),%eax
     527:	89 44 24 04          	mov    %eax,0x4(%esp)
     52b:	8b 84 24 38 01 00 00 	mov    0x138(%esp),%eax
     532:	89 04 24             	mov    %eax,(%esp)
     535:	e8 9e 0f 00 00       	call   14d8 <gidpid>
     53a:	89 84 24 24 01 00 00 	mov    %eax,0x124(%esp)
     541:	83 bc 24 24 01 00 00 	cmpl   $0x0,0x124(%esp)
     548:	00 
     549:	75 8e                	jne    4d9 <main+0x23f>
			if(!isShell(pid)) {
				procs[i]=pid;
				i++;
			}			
		}
		i=0;
     54b:	c7 84 24 34 01 00 00 	movl   $0x0,0x134(%esp)
     552:	00 00 00 00 
		while (procs[i]) {
     556:	eb 2b                	jmp    583 <main+0x2e9>
			//debug: printf(2,"waiting for process %d\n",procs[i]);		
			waitpid(procs[i], 0, 1);
     558:	8b 84 24 34 01 00 00 	mov    0x134(%esp),%eax
     55f:	8b 44 84 18          	mov    0x18(%esp,%eax,4),%eax
     563:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     56a:	00 
     56b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     572:	00 
     573:	89 04 24             	mov    %eax,(%esp)
     576:	e8 a5 0e 00 00       	call   1420 <waitpid>
			i++;
     57b:	83 84 24 34 01 00 00 	addl   $0x1,0x134(%esp)
     582:	01 
				procs[i]=pid;
				i++;
			}			
		}
		i=0;
		while (procs[i]) {
     583:	8b 84 24 34 01 00 00 	mov    0x134(%esp),%eax
     58a:	8b 44 84 18          	mov    0x18(%esp,%eax,4),%eax
     58e:	85 c0                	test   %eax,%eax
     590:	75 c6                	jne    558 <main+0x2be>
			//debug: printf(2,"waiting for process %d\n",procs[i]);		
			waitpid(procs[i], 0, 1);
			i++;
		}
		continue;
     592:	90                   	nop
     593:	e9 c1 00 00 00       	jmp    659 <main+0x3bf>
	}
   char* command = (char*)(malloc(100)); 
     598:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     59f:	e8 10 13 00 00       	call   18b4 <malloc>
     5a4:	89 84 24 20 01 00 00 	mov    %eax,0x120(%esp)
   for (i=0;i<100;i++) {
     5ab:	c7 84 24 3c 01 00 00 	movl   $0x0,0x13c(%esp)
     5b2:	00 00 00 00 
     5b6:	eb 29                	jmp    5e1 <main+0x347>
	command[i] = buf[i];
     5b8:	8b 94 24 3c 01 00 00 	mov    0x13c(%esp),%edx
     5bf:	8b 84 24 20 01 00 00 	mov    0x120(%esp),%eax
     5c6:	01 c2                	add    %eax,%edx
     5c8:	8b 84 24 3c 01 00 00 	mov    0x13c(%esp),%eax
     5cf:	05 e0 20 00 00       	add    $0x20e0,%eax
     5d4:	0f b6 00             	movzbl (%eax),%eax
     5d7:	88 02                	mov    %al,(%edx)
			i++;
		}
		continue;
	}
   char* command = (char*)(malloc(100)); 
   for (i=0;i<100;i++) {
     5d9:	83 84 24 3c 01 00 00 	addl   $0x1,0x13c(%esp)
     5e0:	01 
     5e1:	83 bc 24 3c 01 00 00 	cmpl   $0x63,0x13c(%esp)
     5e8:	63 
     5e9:	7e cd                	jle    5b8 <main+0x31e>
	command[i] = buf[i];
   }
   jobIndex = addJob(command,0);
     5eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     5f2:	00 
     5f3:	8b 84 24 20 01 00 00 	mov    0x120(%esp),%eax
     5fa:	89 04 24             	mov    %eax,(%esp)
     5fd:	e8 63 0a 00 00       	call   1065 <addJob>
     602:	89 84 24 1c 01 00 00 	mov    %eax,0x11c(%esp)
   if((gid = fork1()) == 0)
     609:	e8 a0 00 00 00       	call   6ae <fork1>
     60e:	89 84 24 18 01 00 00 	mov    %eax,0x118(%esp)
     615:	83 bc 24 18 01 00 00 	cmpl   $0x0,0x118(%esp)
     61c:	00 
     61d:	75 16                	jne    635 <main+0x39b>
      runcmd(parsecmd(buf));
     61f:	c7 04 24 e0 20 00 00 	movl   $0x20e0,(%esp)
     626:	e8 f8 03 00 00       	call   a23 <parsecmd>
     62b:	89 04 24             	mov    %eax,(%esp)
     62e:	e8 cd f9 ff ff       	call   0 <runcmd>
     633:	eb 18                	jmp    64d <main+0x3b3>
   else {
	jobsAr[jobIndex]->gid = gid;
     635:	8b 84 24 1c 01 00 00 	mov    0x11c(%esp),%eax
     63c:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
     643:	8b 94 24 18 01 00 00 	mov    0x118(%esp),%edx
     64a:	89 50 04             	mov    %edx,0x4(%eax)
   }
   wait(0);
     64d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     654:	e8 bf 0d 00 00       	call   1418 <wait>
      close(fd);
      break;
    }
  }
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     659:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     660:	00 
     661:	c7 04 24 e0 20 00 00 	movl   $0x20e0,(%esp)
     668:	e8 cf fb ff ff       	call   23c <getcmd>
     66d:	85 c0                	test   %eax,%eax
     66f:	0f 89 a9 fc ff ff    	jns    31e <main+0x84>
   else {
	jobsAr[jobIndex]->gid = gid;
   }
   wait(0);
  }
  exit(0);
     675:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     67c:	e8 8f 0d 00 00       	call   1410 <exit>

00000681 <panic>:
}

void
panic(char *s)
{
     681:	55                   	push   %ebp
     682:	89 e5                	mov    %esp,%ebp
     684:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     687:	8b 45 08             	mov    0x8(%ebp),%eax
     68a:	89 44 24 08          	mov    %eax,0x8(%esp)
     68e:	c7 44 24 04 14 1a 00 	movl   $0x1a14,0x4(%esp)
     695:	00 
     696:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     69d:	e8 26 0f 00 00       	call   15c8 <printf>
  exit(0);
     6a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6a9:	e8 62 0d 00 00       	call   1410 <exit>

000006ae <fork1>:
}

int
fork1(void)
{
     6ae:	55                   	push   %ebp
     6af:	89 e5                	mov    %esp,%ebp
     6b1:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     6b4:	e8 4f 0d 00 00       	call   1408 <fork>
     6b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     6bc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     6c0:	75 0c                	jne    6ce <fork1+0x20>
    panic("fork");
     6c2:	c7 04 24 18 1a 00 00 	movl   $0x1a18,(%esp)
     6c9:	e8 b3 ff ff ff       	call   681 <panic>
  return pid;
     6ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     6d1:	c9                   	leave  
     6d2:	c3                   	ret    

000006d3 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     6d3:	55                   	push   %ebp
     6d4:	89 e5                	mov    %esp,%ebp
     6d6:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6d9:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     6e0:	e8 cf 11 00 00       	call   18b4 <malloc>
     6e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     6e8:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     6ef:	00 
     6f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     6f7:	00 
     6f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6fb:	89 04 24             	mov    %eax,(%esp)
     6fe:	e8 60 0b 00 00       	call   1263 <memset>
  cmd->type = EXEC;
     703:	8b 45 f4             	mov    -0xc(%ebp),%eax
     706:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     70f:	c9                   	leave  
     710:	c3                   	ret    

00000711 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     711:	55                   	push   %ebp
     712:	89 e5                	mov    %esp,%ebp
     714:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     717:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     71e:	e8 91 11 00 00       	call   18b4 <malloc>
     723:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     726:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     72d:	00 
     72e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     735:	00 
     736:	8b 45 f4             	mov    -0xc(%ebp),%eax
     739:	89 04 24             	mov    %eax,(%esp)
     73c:	e8 22 0b 00 00       	call   1263 <memset>
  cmd->type = REDIR;
     741:	8b 45 f4             	mov    -0xc(%ebp),%eax
     744:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     74a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     74d:	8b 55 08             	mov    0x8(%ebp),%edx
     750:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     753:	8b 45 f4             	mov    -0xc(%ebp),%eax
     756:	8b 55 0c             	mov    0xc(%ebp),%edx
     759:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     75f:	8b 55 10             	mov    0x10(%ebp),%edx
     762:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     765:	8b 45 f4             	mov    -0xc(%ebp),%eax
     768:	8b 55 14             	mov    0x14(%ebp),%edx
     76b:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     771:	8b 55 18             	mov    0x18(%ebp),%edx
     774:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     777:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     77a:	c9                   	leave  
     77b:	c3                   	ret    

0000077c <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     77c:	55                   	push   %ebp
     77d:	89 e5                	mov    %esp,%ebp
     77f:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     782:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     789:	e8 26 11 00 00       	call   18b4 <malloc>
     78e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     791:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     798:	00 
     799:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     7a0:	00 
     7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7a4:	89 04 24             	mov    %eax,(%esp)
     7a7:	e8 b7 0a 00 00       	call   1263 <memset>
  cmd->type = PIPE;
     7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7af:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7b8:	8b 55 08             	mov    0x8(%ebp),%edx
     7bb:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c1:	8b 55 0c             	mov    0xc(%ebp),%edx
     7c4:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7ca:	c9                   	leave  
     7cb:	c3                   	ret    

000007cc <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     7cc:	55                   	push   %ebp
     7cd:	89 e5                	mov    %esp,%ebp
     7cf:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7d2:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     7d9:	e8 d6 10 00 00       	call   18b4 <malloc>
     7de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     7e1:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     7e8:	00 
     7e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     7f0:	00 
     7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f4:	89 04 24             	mov    %eax,(%esp)
     7f7:	e8 67 0a 00 00       	call   1263 <memset>
  cmd->type = LIST;
     7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ff:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     805:	8b 45 f4             	mov    -0xc(%ebp),%eax
     808:	8b 55 08             	mov    0x8(%ebp),%edx
     80b:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     811:	8b 55 0c             	mov    0xc(%ebp),%edx
     814:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     817:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     81a:	c9                   	leave  
     81b:	c3                   	ret    

0000081c <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     81c:	55                   	push   %ebp
     81d:	89 e5                	mov    %esp,%ebp
     81f:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     822:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     829:	e8 86 10 00 00       	call   18b4 <malloc>
     82e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     831:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     838:	00 
     839:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     840:	00 
     841:	8b 45 f4             	mov    -0xc(%ebp),%eax
     844:	89 04 24             	mov    %eax,(%esp)
     847:	e8 17 0a 00 00       	call   1263 <memset>
  cmd->type = BACK;
     84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     84f:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     855:	8b 45 f4             	mov    -0xc(%ebp),%eax
     858:	8b 55 08             	mov    0x8(%ebp),%edx
     85b:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     861:	c9                   	leave  
     862:	c3                   	ret    

00000863 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     863:	55                   	push   %ebp
     864:	89 e5                	mov    %esp,%ebp
     866:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     869:	8b 45 08             	mov    0x8(%ebp),%eax
     86c:	8b 00                	mov    (%eax),%eax
     86e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     871:	eb 04                	jmp    877 <gettoken+0x14>
    s++;
     873:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     877:	8b 45 f4             	mov    -0xc(%ebp),%eax
     87a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     87d:	73 1d                	jae    89c <gettoken+0x39>
     87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     882:	0f b6 00             	movzbl (%eax),%eax
     885:	0f be c0             	movsbl %al,%eax
     888:	89 44 24 04          	mov    %eax,0x4(%esp)
     88c:	c7 04 24 b4 1f 00 00 	movl   $0x1fb4,(%esp)
     893:	e8 ef 09 00 00       	call   1287 <strchr>
     898:	85 c0                	test   %eax,%eax
     89a:	75 d7                	jne    873 <gettoken+0x10>
    s++;
  if(q)
     89c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     8a0:	74 08                	je     8aa <gettoken+0x47>
    *q = s;
     8a2:	8b 45 10             	mov    0x10(%ebp),%eax
     8a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8a8:	89 10                	mov    %edx,(%eax)
  ret = *s;
     8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ad:	0f b6 00             	movzbl (%eax),%eax
     8b0:	0f be c0             	movsbl %al,%eax
     8b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8b9:	0f b6 00             	movzbl (%eax),%eax
     8bc:	0f be c0             	movsbl %al,%eax
     8bf:	83 f8 29             	cmp    $0x29,%eax
     8c2:	7f 14                	jg     8d8 <gettoken+0x75>
     8c4:	83 f8 28             	cmp    $0x28,%eax
     8c7:	7d 28                	jge    8f1 <gettoken+0x8e>
     8c9:	85 c0                	test   %eax,%eax
     8cb:	0f 84 94 00 00 00    	je     965 <gettoken+0x102>
     8d1:	83 f8 26             	cmp    $0x26,%eax
     8d4:	74 1b                	je     8f1 <gettoken+0x8e>
     8d6:	eb 3c                	jmp    914 <gettoken+0xb1>
     8d8:	83 f8 3e             	cmp    $0x3e,%eax
     8db:	74 1a                	je     8f7 <gettoken+0x94>
     8dd:	83 f8 3e             	cmp    $0x3e,%eax
     8e0:	7f 0a                	jg     8ec <gettoken+0x89>
     8e2:	83 e8 3b             	sub    $0x3b,%eax
     8e5:	83 f8 01             	cmp    $0x1,%eax
     8e8:	77 2a                	ja     914 <gettoken+0xb1>
     8ea:	eb 05                	jmp    8f1 <gettoken+0x8e>
     8ec:	83 f8 7c             	cmp    $0x7c,%eax
     8ef:	75 23                	jne    914 <gettoken+0xb1>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     8f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     8f5:	eb 6f                	jmp    966 <gettoken+0x103>
  case '>':
    s++;
     8f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     8fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8fe:	0f b6 00             	movzbl (%eax),%eax
     901:	3c 3e                	cmp    $0x3e,%al
     903:	75 0d                	jne    912 <gettoken+0xaf>
      ret = '+';
     905:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     90c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     910:	eb 54                	jmp    966 <gettoken+0x103>
     912:	eb 52                	jmp    966 <gettoken+0x103>
  default:
    ret = 'a';
     914:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     91b:	eb 04                	jmp    921 <gettoken+0xbe>
      s++;
     91d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     921:	8b 45 f4             	mov    -0xc(%ebp),%eax
     924:	3b 45 0c             	cmp    0xc(%ebp),%eax
     927:	73 3a                	jae    963 <gettoken+0x100>
     929:	8b 45 f4             	mov    -0xc(%ebp),%eax
     92c:	0f b6 00             	movzbl (%eax),%eax
     92f:	0f be c0             	movsbl %al,%eax
     932:	89 44 24 04          	mov    %eax,0x4(%esp)
     936:	c7 04 24 b4 1f 00 00 	movl   $0x1fb4,(%esp)
     93d:	e8 45 09 00 00       	call   1287 <strchr>
     942:	85 c0                	test   %eax,%eax
     944:	75 1d                	jne    963 <gettoken+0x100>
     946:	8b 45 f4             	mov    -0xc(%ebp),%eax
     949:	0f b6 00             	movzbl (%eax),%eax
     94c:	0f be c0             	movsbl %al,%eax
     94f:	89 44 24 04          	mov    %eax,0x4(%esp)
     953:	c7 04 24 ba 1f 00 00 	movl   $0x1fba,(%esp)
     95a:	e8 28 09 00 00       	call   1287 <strchr>
     95f:	85 c0                	test   %eax,%eax
     961:	74 ba                	je     91d <gettoken+0xba>
      s++;
    break;
     963:	eb 01                	jmp    966 <gettoken+0x103>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     965:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     966:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     96a:	74 0a                	je     976 <gettoken+0x113>
    *eq = s;
     96c:	8b 45 14             	mov    0x14(%ebp),%eax
     96f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     972:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     974:	eb 06                	jmp    97c <gettoken+0x119>
     976:	eb 04                	jmp    97c <gettoken+0x119>
    s++;
     978:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     97c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     97f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     982:	73 1d                	jae    9a1 <gettoken+0x13e>
     984:	8b 45 f4             	mov    -0xc(%ebp),%eax
     987:	0f b6 00             	movzbl (%eax),%eax
     98a:	0f be c0             	movsbl %al,%eax
     98d:	89 44 24 04          	mov    %eax,0x4(%esp)
     991:	c7 04 24 b4 1f 00 00 	movl   $0x1fb4,(%esp)
     998:	e8 ea 08 00 00       	call   1287 <strchr>
     99d:	85 c0                	test   %eax,%eax
     99f:	75 d7                	jne    978 <gettoken+0x115>
    s++;
  *ps = s;
     9a1:	8b 45 08             	mov    0x8(%ebp),%eax
     9a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9a7:	89 10                	mov    %edx,(%eax)
  return ret;
     9a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     9ac:	c9                   	leave  
     9ad:	c3                   	ret    

000009ae <peek>:

int
peek(char **ps, char *es, char *toks)
{
     9ae:	55                   	push   %ebp
     9af:	89 e5                	mov    %esp,%ebp
     9b1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     9b4:	8b 45 08             	mov    0x8(%ebp),%eax
     9b7:	8b 00                	mov    (%eax),%eax
     9b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     9bc:	eb 04                	jmp    9c2 <peek+0x14>
    s++;
     9be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     9c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
     9c8:	73 1d                	jae    9e7 <peek+0x39>
     9ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9cd:	0f b6 00             	movzbl (%eax),%eax
     9d0:	0f be c0             	movsbl %al,%eax
     9d3:	89 44 24 04          	mov    %eax,0x4(%esp)
     9d7:	c7 04 24 b4 1f 00 00 	movl   $0x1fb4,(%esp)
     9de:	e8 a4 08 00 00       	call   1287 <strchr>
     9e3:	85 c0                	test   %eax,%eax
     9e5:	75 d7                	jne    9be <peek+0x10>
    s++;
  *ps = s;
     9e7:	8b 45 08             	mov    0x8(%ebp),%eax
     9ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9ed:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9f2:	0f b6 00             	movzbl (%eax),%eax
     9f5:	84 c0                	test   %al,%al
     9f7:	74 23                	je     a1c <peek+0x6e>
     9f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9fc:	0f b6 00             	movzbl (%eax),%eax
     9ff:	0f be c0             	movsbl %al,%eax
     a02:	89 44 24 04          	mov    %eax,0x4(%esp)
     a06:	8b 45 10             	mov    0x10(%ebp),%eax
     a09:	89 04 24             	mov    %eax,(%esp)
     a0c:	e8 76 08 00 00       	call   1287 <strchr>
     a11:	85 c0                	test   %eax,%eax
     a13:	74 07                	je     a1c <peek+0x6e>
     a15:	b8 01 00 00 00       	mov    $0x1,%eax
     a1a:	eb 05                	jmp    a21 <peek+0x73>
     a1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a21:	c9                   	leave  
     a22:	c3                   	ret    

00000a23 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     a23:	55                   	push   %ebp
     a24:	89 e5                	mov    %esp,%ebp
     a26:	53                   	push   %ebx
     a27:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     a2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a2d:	8b 45 08             	mov    0x8(%ebp),%eax
     a30:	89 04 24             	mov    %eax,(%esp)
     a33:	e8 04 08 00 00       	call   123c <strlen>
     a38:	01 d8                	add    %ebx,%eax
     a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a40:	89 44 24 04          	mov    %eax,0x4(%esp)
     a44:	8d 45 08             	lea    0x8(%ebp),%eax
     a47:	89 04 24             	mov    %eax,(%esp)
     a4a:	e8 60 00 00 00       	call   aaf <parseline>
     a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     a52:	c7 44 24 08 1d 1a 00 	movl   $0x1a1d,0x8(%esp)
     a59:	00 
     a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
     a61:	8d 45 08             	lea    0x8(%ebp),%eax
     a64:	89 04 24             	mov    %eax,(%esp)
     a67:	e8 42 ff ff ff       	call   9ae <peek>
  if(s != es){
     a6c:	8b 45 08             	mov    0x8(%ebp),%eax
     a6f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     a72:	74 27                	je     a9b <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     a74:	8b 45 08             	mov    0x8(%ebp),%eax
     a77:	89 44 24 08          	mov    %eax,0x8(%esp)
     a7b:	c7 44 24 04 1e 1a 00 	movl   $0x1a1e,0x4(%esp)
     a82:	00 
     a83:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     a8a:	e8 39 0b 00 00       	call   15c8 <printf>
    panic("syntax");
     a8f:	c7 04 24 2d 1a 00 00 	movl   $0x1a2d,(%esp)
     a96:	e8 e6 fb ff ff       	call   681 <panic>
  }
  nulterminate(cmd);
     a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a9e:	89 04 24             	mov    %eax,(%esp)
     aa1:	e8 a3 04 00 00       	call   f49 <nulterminate>
  return cmd;
     aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     aa9:	83 c4 24             	add    $0x24,%esp
     aac:	5b                   	pop    %ebx
     aad:	5d                   	pop    %ebp
     aae:	c3                   	ret    

00000aaf <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     aaf:	55                   	push   %ebp
     ab0:	89 e5                	mov    %esp,%ebp
     ab2:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
     abc:	8b 45 08             	mov    0x8(%ebp),%eax
     abf:	89 04 24             	mov    %eax,(%esp)
     ac2:	e8 bc 00 00 00       	call   b83 <parsepipe>
     ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     aca:	eb 30                	jmp    afc <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     acc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     ad3:	00 
     ad4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     adb:	00 
     adc:	8b 45 0c             	mov    0xc(%ebp),%eax
     adf:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae3:	8b 45 08             	mov    0x8(%ebp),%eax
     ae6:	89 04 24             	mov    %eax,(%esp)
     ae9:	e8 75 fd ff ff       	call   863 <gettoken>
    cmd = backcmd(cmd);
     aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     af1:	89 04 24             	mov    %eax,(%esp)
     af4:	e8 23 fd ff ff       	call   81c <backcmd>
     af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     afc:	c7 44 24 08 34 1a 00 	movl   $0x1a34,0x8(%esp)
     b03:	00 
     b04:	8b 45 0c             	mov    0xc(%ebp),%eax
     b07:	89 44 24 04          	mov    %eax,0x4(%esp)
     b0b:	8b 45 08             	mov    0x8(%ebp),%eax
     b0e:	89 04 24             	mov    %eax,(%esp)
     b11:	e8 98 fe ff ff       	call   9ae <peek>
     b16:	85 c0                	test   %eax,%eax
     b18:	75 b2                	jne    acc <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     b1a:	c7 44 24 08 36 1a 00 	movl   $0x1a36,0x8(%esp)
     b21:	00 
     b22:	8b 45 0c             	mov    0xc(%ebp),%eax
     b25:	89 44 24 04          	mov    %eax,0x4(%esp)
     b29:	8b 45 08             	mov    0x8(%ebp),%eax
     b2c:	89 04 24             	mov    %eax,(%esp)
     b2f:	e8 7a fe ff ff       	call   9ae <peek>
     b34:	85 c0                	test   %eax,%eax
     b36:	74 46                	je     b7e <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     b38:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     b3f:	00 
     b40:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     b47:	00 
     b48:	8b 45 0c             	mov    0xc(%ebp),%eax
     b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
     b4f:	8b 45 08             	mov    0x8(%ebp),%eax
     b52:	89 04 24             	mov    %eax,(%esp)
     b55:	e8 09 fd ff ff       	call   863 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
     b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
     b61:	8b 45 08             	mov    0x8(%ebp),%eax
     b64:	89 04 24             	mov    %eax,(%esp)
     b67:	e8 43 ff ff ff       	call   aaf <parseline>
     b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
     b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b73:	89 04 24             	mov    %eax,(%esp)
     b76:	e8 51 fc ff ff       	call   7cc <listcmd>
     b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b81:	c9                   	leave  
     b82:	c3                   	ret    

00000b83 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     b83:	55                   	push   %ebp
     b84:	89 e5                	mov    %esp,%ebp
     b86:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     b89:	8b 45 0c             	mov    0xc(%ebp),%eax
     b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
     b90:	8b 45 08             	mov    0x8(%ebp),%eax
     b93:	89 04 24             	mov    %eax,(%esp)
     b96:	e8 68 02 00 00       	call   e03 <parseexec>
     b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     b9e:	c7 44 24 08 38 1a 00 	movl   $0x1a38,0x8(%esp)
     ba5:	00 
     ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
     bad:	8b 45 08             	mov    0x8(%ebp),%eax
     bb0:	89 04 24             	mov    %eax,(%esp)
     bb3:	e8 f6 fd ff ff       	call   9ae <peek>
     bb8:	85 c0                	test   %eax,%eax
     bba:	74 46                	je     c02 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     bbc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     bc3:	00 
     bc4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     bcb:	00 
     bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
     bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
     bd3:	8b 45 08             	mov    0x8(%ebp),%eax
     bd6:	89 04 24             	mov    %eax,(%esp)
     bd9:	e8 85 fc ff ff       	call   863 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     bde:	8b 45 0c             	mov    0xc(%ebp),%eax
     be1:	89 44 24 04          	mov    %eax,0x4(%esp)
     be5:	8b 45 08             	mov    0x8(%ebp),%eax
     be8:	89 04 24             	mov    %eax,(%esp)
     beb:	e8 93 ff ff ff       	call   b83 <parsepipe>
     bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
     bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bf7:	89 04 24             	mov    %eax,(%esp)
     bfa:	e8 7d fb ff ff       	call   77c <pipecmd>
     bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     c05:	c9                   	leave  
     c06:	c3                   	ret    

00000c07 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     c07:	55                   	push   %ebp
     c08:	89 e5                	mov    %esp,%ebp
     c0a:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     c0d:	e9 f6 00 00 00       	jmp    d08 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     c12:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     c19:	00 
     c1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     c21:	00 
     c22:	8b 45 10             	mov    0x10(%ebp),%eax
     c25:	89 44 24 04          	mov    %eax,0x4(%esp)
     c29:	8b 45 0c             	mov    0xc(%ebp),%eax
     c2c:	89 04 24             	mov    %eax,(%esp)
     c2f:	e8 2f fc ff ff       	call   863 <gettoken>
     c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     c37:	8d 45 ec             	lea    -0x14(%ebp),%eax
     c3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
     c3e:	8d 45 f0             	lea    -0x10(%ebp),%eax
     c41:	89 44 24 08          	mov    %eax,0x8(%esp)
     c45:	8b 45 10             	mov    0x10(%ebp),%eax
     c48:	89 44 24 04          	mov    %eax,0x4(%esp)
     c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
     c4f:	89 04 24             	mov    %eax,(%esp)
     c52:	e8 0c fc ff ff       	call   863 <gettoken>
     c57:	83 f8 61             	cmp    $0x61,%eax
     c5a:	74 0c                	je     c68 <parseredirs+0x61>
      panic("missing file for redirection");
     c5c:	c7 04 24 3a 1a 00 00 	movl   $0x1a3a,(%esp)
     c63:	e8 19 fa ff ff       	call   681 <panic>
    switch(tok){
     c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c6b:	83 f8 3c             	cmp    $0x3c,%eax
     c6e:	74 0f                	je     c7f <parseredirs+0x78>
     c70:	83 f8 3e             	cmp    $0x3e,%eax
     c73:	74 38                	je     cad <parseredirs+0xa6>
     c75:	83 f8 2b             	cmp    $0x2b,%eax
     c78:	74 61                	je     cdb <parseredirs+0xd4>
     c7a:	e9 89 00 00 00       	jmp    d08 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     c7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c85:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     c8c:	00 
     c8d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     c94:	00 
     c95:	89 54 24 08          	mov    %edx,0x8(%esp)
     c99:	89 44 24 04          	mov    %eax,0x4(%esp)
     c9d:	8b 45 08             	mov    0x8(%ebp),%eax
     ca0:	89 04 24             	mov    %eax,(%esp)
     ca3:	e8 69 fa ff ff       	call   711 <redircmd>
     ca8:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     cab:	eb 5b                	jmp    d08 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     cad:	8b 55 ec             	mov    -0x14(%ebp),%edx
     cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cb3:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     cba:	00 
     cbb:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     cc2:	00 
     cc3:	89 54 24 08          	mov    %edx,0x8(%esp)
     cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
     ccb:	8b 45 08             	mov    0x8(%ebp),%eax
     cce:	89 04 24             	mov    %eax,(%esp)
     cd1:	e8 3b fa ff ff       	call   711 <redircmd>
     cd6:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     cd9:	eb 2d                	jmp    d08 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     cdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
     cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ce1:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     ce8:	00 
     ce9:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     cf0:	00 
     cf1:	89 54 24 08          	mov    %edx,0x8(%esp)
     cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
     cf9:	8b 45 08             	mov    0x8(%ebp),%eax
     cfc:	89 04 24             	mov    %eax,(%esp)
     cff:	e8 0d fa ff ff       	call   711 <redircmd>
     d04:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     d07:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     d08:	c7 44 24 08 57 1a 00 	movl   $0x1a57,0x8(%esp)
     d0f:	00 
     d10:	8b 45 10             	mov    0x10(%ebp),%eax
     d13:	89 44 24 04          	mov    %eax,0x4(%esp)
     d17:	8b 45 0c             	mov    0xc(%ebp),%eax
     d1a:	89 04 24             	mov    %eax,(%esp)
     d1d:	e8 8c fc ff ff       	call   9ae <peek>
     d22:	85 c0                	test   %eax,%eax
     d24:	0f 85 e8 fe ff ff    	jne    c12 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     d2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d2d:	c9                   	leave  
     d2e:	c3                   	ret    

00000d2f <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     d2f:	55                   	push   %ebp
     d30:	89 e5                	mov    %esp,%ebp
     d32:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     d35:	c7 44 24 08 5a 1a 00 	movl   $0x1a5a,0x8(%esp)
     d3c:	00 
     d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
     d40:	89 44 24 04          	mov    %eax,0x4(%esp)
     d44:	8b 45 08             	mov    0x8(%ebp),%eax
     d47:	89 04 24             	mov    %eax,(%esp)
     d4a:	e8 5f fc ff ff       	call   9ae <peek>
     d4f:	85 c0                	test   %eax,%eax
     d51:	75 0c                	jne    d5f <parseblock+0x30>
    panic("parseblock");
     d53:	c7 04 24 5c 1a 00 00 	movl   $0x1a5c,(%esp)
     d5a:	e8 22 f9 ff ff       	call   681 <panic>
  gettoken(ps, es, 0, 0);
     d5f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     d66:	00 
     d67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     d6e:	00 
     d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
     d72:	89 44 24 04          	mov    %eax,0x4(%esp)
     d76:	8b 45 08             	mov    0x8(%ebp),%eax
     d79:	89 04 24             	mov    %eax,(%esp)
     d7c:	e8 e2 fa ff ff       	call   863 <gettoken>
  cmd = parseline(ps, es);
     d81:	8b 45 0c             	mov    0xc(%ebp),%eax
     d84:	89 44 24 04          	mov    %eax,0x4(%esp)
     d88:	8b 45 08             	mov    0x8(%ebp),%eax
     d8b:	89 04 24             	mov    %eax,(%esp)
     d8e:	e8 1c fd ff ff       	call   aaf <parseline>
     d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     d96:	c7 44 24 08 67 1a 00 	movl   $0x1a67,0x8(%esp)
     d9d:	00 
     d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
     da1:	89 44 24 04          	mov    %eax,0x4(%esp)
     da5:	8b 45 08             	mov    0x8(%ebp),%eax
     da8:	89 04 24             	mov    %eax,(%esp)
     dab:	e8 fe fb ff ff       	call   9ae <peek>
     db0:	85 c0                	test   %eax,%eax
     db2:	75 0c                	jne    dc0 <parseblock+0x91>
    panic("syntax - missing )");
     db4:	c7 04 24 69 1a 00 00 	movl   $0x1a69,(%esp)
     dbb:	e8 c1 f8 ff ff       	call   681 <panic>
  gettoken(ps, es, 0, 0);
     dc0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     dc7:	00 
     dc8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     dcf:	00 
     dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
     dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
     dd7:	8b 45 08             	mov    0x8(%ebp),%eax
     dda:	89 04 24             	mov    %eax,(%esp)
     ddd:	e8 81 fa ff ff       	call   863 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     de2:	8b 45 0c             	mov    0xc(%ebp),%eax
     de5:	89 44 24 08          	mov    %eax,0x8(%esp)
     de9:	8b 45 08             	mov    0x8(%ebp),%eax
     dec:	89 44 24 04          	mov    %eax,0x4(%esp)
     df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df3:	89 04 24             	mov    %eax,(%esp)
     df6:	e8 0c fe ff ff       	call   c07 <parseredirs>
     dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     e01:	c9                   	leave  
     e02:	c3                   	ret    

00000e03 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     e03:	55                   	push   %ebp
     e04:	89 e5                	mov    %esp,%ebp
     e06:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     e09:	c7 44 24 08 5a 1a 00 	movl   $0x1a5a,0x8(%esp)
     e10:	00 
     e11:	8b 45 0c             	mov    0xc(%ebp),%eax
     e14:	89 44 24 04          	mov    %eax,0x4(%esp)
     e18:	8b 45 08             	mov    0x8(%ebp),%eax
     e1b:	89 04 24             	mov    %eax,(%esp)
     e1e:	e8 8b fb ff ff       	call   9ae <peek>
     e23:	85 c0                	test   %eax,%eax
     e25:	74 17                	je     e3e <parseexec+0x3b>
    return parseblock(ps, es);
     e27:	8b 45 0c             	mov    0xc(%ebp),%eax
     e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
     e2e:	8b 45 08             	mov    0x8(%ebp),%eax
     e31:	89 04 24             	mov    %eax,(%esp)
     e34:	e8 f6 fe ff ff       	call   d2f <parseblock>
     e39:	e9 09 01 00 00       	jmp    f47 <parseexec+0x144>

  ret = execcmd();
     e3e:	e8 90 f8 ff ff       	call   6d3 <execcmd>
     e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e49:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     e4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     e53:	8b 45 0c             	mov    0xc(%ebp),%eax
     e56:	89 44 24 08          	mov    %eax,0x8(%esp)
     e5a:	8b 45 08             	mov    0x8(%ebp),%eax
     e5d:	89 44 24 04          	mov    %eax,0x4(%esp)
     e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e64:	89 04 24             	mov    %eax,(%esp)
     e67:	e8 9b fd ff ff       	call   c07 <parseredirs>
     e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     e6f:	e9 8f 00 00 00       	jmp    f03 <parseexec+0x100>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     e74:	8d 45 e0             	lea    -0x20(%ebp),%eax
     e77:	89 44 24 0c          	mov    %eax,0xc(%esp)
     e7b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
     e82:	8b 45 0c             	mov    0xc(%ebp),%eax
     e85:	89 44 24 04          	mov    %eax,0x4(%esp)
     e89:	8b 45 08             	mov    0x8(%ebp),%eax
     e8c:	89 04 24             	mov    %eax,(%esp)
     e8f:	e8 cf f9 ff ff       	call   863 <gettoken>
     e94:	89 45 e8             	mov    %eax,-0x18(%ebp)
     e97:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e9b:	75 05                	jne    ea2 <parseexec+0x9f>
      break;
     e9d:	e9 83 00 00 00       	jmp    f25 <parseexec+0x122>
    if(tok != 'a')
     ea2:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     ea6:	74 0c                	je     eb4 <parseexec+0xb1>
      panic("syntax");
     ea8:	c7 04 24 2d 1a 00 00 	movl   $0x1a2d,(%esp)
     eaf:	e8 cd f7 ff ff       	call   681 <panic>
    cmd->argv[argc] = q;
     eb4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ebd:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     ec1:	8b 55 e0             	mov    -0x20(%ebp),%edx
     ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ec7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     eca:	83 c1 08             	add    $0x8,%ecx
     ecd:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     ed1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     ed5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     ed9:	7e 0c                	jle    ee7 <parseexec+0xe4>
      panic("too many args");
     edb:	c7 04 24 7c 1a 00 00 	movl   $0x1a7c,(%esp)
     ee2:	e8 9a f7 ff ff       	call   681 <panic>
    ret = parseredirs(ret, ps, es);
     ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
     eea:	89 44 24 08          	mov    %eax,0x8(%esp)
     eee:	8b 45 08             	mov    0x8(%ebp),%eax
     ef1:	89 44 24 04          	mov    %eax,0x4(%esp)
     ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ef8:	89 04 24             	mov    %eax,(%esp)
     efb:	e8 07 fd ff ff       	call   c07 <parseredirs>
     f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     f03:	c7 44 24 08 8a 1a 00 	movl   $0x1a8a,0x8(%esp)
     f0a:	00 
     f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
     f12:	8b 45 08             	mov    0x8(%ebp),%eax
     f15:	89 04 24             	mov    %eax,(%esp)
     f18:	e8 91 fa ff ff       	call   9ae <peek>
     f1d:	85 c0                	test   %eax,%eax
     f1f:	0f 84 4f ff ff ff    	je     e74 <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f2b:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     f32:	00 
  cmd->eargv[argc] = 0;
     f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f36:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f39:	83 c2 08             	add    $0x8,%edx
     f3c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     f43:	00 
  return ret;
     f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f47:	c9                   	leave  
     f48:	c3                   	ret    

00000f49 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     f49:	55                   	push   %ebp
     f4a:	89 e5                	mov    %esp,%ebp
     f4c:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     f4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f53:	75 0a                	jne    f5f <nulterminate+0x16>
    return 0;
     f55:	b8 00 00 00 00       	mov    $0x0,%eax
     f5a:	e9 c9 00 00 00       	jmp    1028 <nulterminate+0xdf>
  
  switch(cmd->type){
     f5f:	8b 45 08             	mov    0x8(%ebp),%eax
     f62:	8b 00                	mov    (%eax),%eax
     f64:	83 f8 05             	cmp    $0x5,%eax
     f67:	0f 87 b8 00 00 00    	ja     1025 <nulterminate+0xdc>
     f6d:	8b 04 85 90 1a 00 00 	mov    0x1a90(,%eax,4),%eax
     f74:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     f76:	8b 45 08             	mov    0x8(%ebp),%eax
     f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     f7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f83:	eb 14                	jmp    f99 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f88:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f8b:	83 c2 08             	add    $0x8,%edx
     f8e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     f92:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     f95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f9f:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     fa3:	85 c0                	test   %eax,%eax
     fa5:	75 de                	jne    f85 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     fa7:	eb 7c                	jmp    1025 <nulterminate+0xdc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     fa9:	8b 45 08             	mov    0x8(%ebp),%eax
     fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     faf:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fb2:	8b 40 04             	mov    0x4(%eax),%eax
     fb5:	89 04 24             	mov    %eax,(%esp)
     fb8:	e8 8c ff ff ff       	call   f49 <nulterminate>
    *rcmd->efile = 0;
     fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fc0:	8b 40 0c             	mov    0xc(%eax),%eax
     fc3:	c6 00 00             	movb   $0x0,(%eax)
    break;
     fc6:	eb 5d                	jmp    1025 <nulterminate+0xdc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     fc8:	8b 45 08             	mov    0x8(%ebp),%eax
     fcb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     fce:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fd1:	8b 40 04             	mov    0x4(%eax),%eax
     fd4:	89 04 24             	mov    %eax,(%esp)
     fd7:	e8 6d ff ff ff       	call   f49 <nulterminate>
    nulterminate(pcmd->right);
     fdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fdf:	8b 40 08             	mov    0x8(%eax),%eax
     fe2:	89 04 24             	mov    %eax,(%esp)
     fe5:	e8 5f ff ff ff       	call   f49 <nulterminate>
    break;
     fea:	eb 39                	jmp    1025 <nulterminate+0xdc>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     fec:	8b 45 08             	mov    0x8(%ebp),%eax
     fef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ff5:	8b 40 04             	mov    0x4(%eax),%eax
     ff8:	89 04 24             	mov    %eax,(%esp)
     ffb:	e8 49 ff ff ff       	call   f49 <nulterminate>
    nulterminate(lcmd->right);
    1000:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1003:	8b 40 08             	mov    0x8(%eax),%eax
    1006:	89 04 24             	mov    %eax,(%esp)
    1009:	e8 3b ff ff ff       	call   f49 <nulterminate>
    break;
    100e:	eb 15                	jmp    1025 <nulterminate+0xdc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    1010:	8b 45 08             	mov    0x8(%ebp),%eax
    1013:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
    1016:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1019:	8b 40 04             	mov    0x4(%eax),%eax
    101c:	89 04 24             	mov    %eax,(%esp)
    101f:	e8 25 ff ff ff       	call   f49 <nulterminate>
    break;
    1024:	90                   	nop
  }
  return cmd;
    1025:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1028:	c9                   	leave  
    1029:	c3                   	ret    

0000102a <removeJob>:




void removeJob(int gid) {
    102a:	55                   	push   %ebp
    102b:	89 e5                	mov    %esp,%ebp
    102d:	83 ec 10             	sub    $0x10,%esp
  int i;
  for (i=0;i<64;i++){
    1030:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1037:	eb 24                	jmp    105d <removeJob+0x33>
	if (jobsAr[i]->gid == gid) {
    1039:	8b 45 fc             	mov    -0x4(%ebp),%eax
    103c:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
    1043:	8b 40 04             	mov    0x4(%eax),%eax
    1046:	3b 45 08             	cmp    0x8(%ebp),%eax
    1049:	75 0e                	jne    1059 <removeJob+0x2f>
		jobsAr[i]=0;
    104b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    104e:	c7 04 85 e0 1f 00 00 	movl   $0x0,0x1fe0(,%eax,4)
    1055:	00 00 00 00 



void removeJob(int gid) {
  int i;
  for (i=0;i<64;i++){
    1059:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    105d:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
    1061:	7e d6                	jle    1039 <removeJob+0xf>
	if (jobsAr[i]->gid == gid) {
		jobsAr[i]=0;
	}
  }
}
    1063:	c9                   	leave  
    1064:	c3                   	ret    

00001065 <addJob>:

int addJob(char * command, int gid) {
    1065:	55                   	push   %ebp
    1066:	89 e5                	mov    %esp,%ebp
    1068:	83 ec 28             	sub    $0x28,%esp
  int i;
  for (i=0;i<64;i++){
    106b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1072:	eb 14                	jmp    1088 <addJob+0x23>
	if (!(jobsAr[i])) {
    1074:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1077:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
    107e:	85 c0                	test   %eax,%eax
    1080:	75 02                	jne    1084 <addJob+0x1f>
		break;
    1082:	eb 0a                	jmp    108e <addJob+0x29>
  }
}

int addJob(char * command, int gid) {
  int i;
  for (i=0;i<64;i++){
    1084:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1088:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
    108c:	7e e6                	jle    1074 <addJob+0xf>
	if (!(jobsAr[i])) {
		break;
	}
  }
  jobsAr[i]=(struct job *)(malloc(sizeof(struct job)));
    108e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1095:	e8 1a 08 00 00       	call   18b4 <malloc>
    109a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    109d:	89 04 95 e0 1f 00 00 	mov    %eax,0x1fe0(,%edx,4)
  jobsAr[i]->command=command;
    10a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10a7:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
    10ae:	8b 55 08             	mov    0x8(%ebp),%edx
    10b1:	89 10                	mov    %edx,(%eax)
  jobsAr[i]->gid=gid;
    10b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10b6:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
    10bd:	8b 55 0c             	mov    0xc(%ebp),%edx
    10c0:	89 50 04             	mov    %edx,0x4(%eax)
  return i;
    10c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    10c6:	c9                   	leave  
    10c7:	c3                   	ret    

000010c8 <jobsPrint>:

void jobsPrint(){
    10c8:	55                   	push   %ebp
    10c9:	89 e5                	mov    %esp,%ebp
    10cb:	83 ec 28             	sub    $0x28,%esp
	int i,j=0;
    10ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	
	for(i=0;i<64;i++) {
    10d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10dc:	e9 a1 00 00 00       	jmp    1182 <jobsPrint+0xba>
		if (jobsAr[i]) {
    10e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10e4:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
    10eb:	85 c0                	test   %eax,%eax
    10ed:	0f 84 8b 00 00 00    	je     117e <jobsPrint+0xb6>
			if(canRemoveJob(jobsAr[i]->gid)) {
    10f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10f6:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
    10fd:	8b 40 04             	mov    0x4(%eax),%eax
    1100:	89 04 24             	mov    %eax,(%esp)
    1103:	e8 b0 03 00 00       	call   14b8 <canRemoveJob>
    1108:	85 c0                	test   %eax,%eax
    110a:	74 17                	je     1123 <jobsPrint+0x5b>
				removeJob(jobsAr[i]->gid);
    110c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    110f:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
    1116:	8b 40 04             	mov    0x4(%eax),%eax
    1119:	89 04 24             	mov    %eax,(%esp)
    111c:	e8 09 ff ff ff       	call   102a <removeJob>
    1121:	eb 5b                	jmp    117e <jobsPrint+0xb6>
			}
			else {
				printf(2,"Job %d: %s",(i+1),jobsAr[i]->command);
    1123:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1126:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
    112d:	8b 00                	mov    (%eax),%eax
    112f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1132:	83 c2 01             	add    $0x1,%edx
    1135:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1139:	89 54 24 08          	mov    %edx,0x8(%esp)
    113d:	c7 44 24 04 a8 1a 00 	movl   $0x1aa8,0x4(%esp)
    1144:	00 
    1145:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    114c:	e8 77 04 00 00       	call   15c8 <printf>
				jobs(jobsAr[i]->gid);
    1151:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1154:	8b 04 85 e0 1f 00 00 	mov    0x1fe0(,%eax,4),%eax
    115b:	8b 40 04             	mov    0x4(%eax),%eax
    115e:	89 04 24             	mov    %eax,(%esp)
    1161:	e8 5a 03 00 00       	call   14c0 <jobs>
				printf(2,"\n");
    1166:	c7 44 24 04 b3 1a 00 	movl   $0x1ab3,0x4(%esp)
    116d:	00 
    116e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1175:	e8 4e 04 00 00       	call   15c8 <printf>
				j++;
    117a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
}

void jobsPrint(){
	int i,j=0;
	
	for(i=0;i<64;i++) {
    117e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1182:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
    1186:	0f 8e 55 ff ff ff    	jle    10e1 <jobsPrint+0x19>
				printf(2,"\n");
				j++;
			}
		}
	}
	if (j==0){
    118c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1190:	75 14                	jne    11a6 <jobsPrint+0xde>
		printf(2,"There are no jobs left\n");
    1192:	c7 44 24 04 b5 1a 00 	movl   $0x1ab5,0x4(%esp)
    1199:	00 
    119a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    11a1:	e8 22 04 00 00       	call   15c8 <printf>
	}
}
    11a6:	c9                   	leave  
    11a7:	c3                   	ret    

000011a8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11a8:	55                   	push   %ebp
    11a9:	89 e5                	mov    %esp,%ebp
    11ab:	57                   	push   %edi
    11ac:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    11ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11b0:	8b 55 10             	mov    0x10(%ebp),%edx
    11b3:	8b 45 0c             	mov    0xc(%ebp),%eax
    11b6:	89 cb                	mov    %ecx,%ebx
    11b8:	89 df                	mov    %ebx,%edi
    11ba:	89 d1                	mov    %edx,%ecx
    11bc:	fc                   	cld    
    11bd:	f3 aa                	rep stos %al,%es:(%edi)
    11bf:	89 ca                	mov    %ecx,%edx
    11c1:	89 fb                	mov    %edi,%ebx
    11c3:	89 5d 08             	mov    %ebx,0x8(%ebp)
    11c6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11c9:	5b                   	pop    %ebx
    11ca:	5f                   	pop    %edi
    11cb:	5d                   	pop    %ebp
    11cc:	c3                   	ret    

000011cd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11cd:	55                   	push   %ebp
    11ce:	89 e5                	mov    %esp,%ebp
    11d0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    11d3:	8b 45 08             	mov    0x8(%ebp),%eax
    11d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    11d9:	90                   	nop
    11da:	8b 45 08             	mov    0x8(%ebp),%eax
    11dd:	8d 50 01             	lea    0x1(%eax),%edx
    11e0:	89 55 08             	mov    %edx,0x8(%ebp)
    11e3:	8b 55 0c             	mov    0xc(%ebp),%edx
    11e6:	8d 4a 01             	lea    0x1(%edx),%ecx
    11e9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    11ec:	0f b6 12             	movzbl (%edx),%edx
    11ef:	88 10                	mov    %dl,(%eax)
    11f1:	0f b6 00             	movzbl (%eax),%eax
    11f4:	84 c0                	test   %al,%al
    11f6:	75 e2                	jne    11da <strcpy+0xd>
    ;
  return os;
    11f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11fb:	c9                   	leave  
    11fc:	c3                   	ret    

000011fd <strcmp>:

int
strcmp(const char *p, const char *q)
{
    11fd:	55                   	push   %ebp
    11fe:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1200:	eb 08                	jmp    120a <strcmp+0xd>
    p++, q++;
    1202:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1206:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    120a:	8b 45 08             	mov    0x8(%ebp),%eax
    120d:	0f b6 00             	movzbl (%eax),%eax
    1210:	84 c0                	test   %al,%al
    1212:	74 10                	je     1224 <strcmp+0x27>
    1214:	8b 45 08             	mov    0x8(%ebp),%eax
    1217:	0f b6 10             	movzbl (%eax),%edx
    121a:	8b 45 0c             	mov    0xc(%ebp),%eax
    121d:	0f b6 00             	movzbl (%eax),%eax
    1220:	38 c2                	cmp    %al,%dl
    1222:	74 de                	je     1202 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1224:	8b 45 08             	mov    0x8(%ebp),%eax
    1227:	0f b6 00             	movzbl (%eax),%eax
    122a:	0f b6 d0             	movzbl %al,%edx
    122d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1230:	0f b6 00             	movzbl (%eax),%eax
    1233:	0f b6 c0             	movzbl %al,%eax
    1236:	29 c2                	sub    %eax,%edx
    1238:	89 d0                	mov    %edx,%eax
}
    123a:	5d                   	pop    %ebp
    123b:	c3                   	ret    

0000123c <strlen>:

uint
strlen(char *s)
{
    123c:	55                   	push   %ebp
    123d:	89 e5                	mov    %esp,%ebp
    123f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1242:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1249:	eb 04                	jmp    124f <strlen+0x13>
    124b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    124f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1252:	8b 45 08             	mov    0x8(%ebp),%eax
    1255:	01 d0                	add    %edx,%eax
    1257:	0f b6 00             	movzbl (%eax),%eax
    125a:	84 c0                	test   %al,%al
    125c:	75 ed                	jne    124b <strlen+0xf>
    ;
  return n;
    125e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1261:	c9                   	leave  
    1262:	c3                   	ret    

00001263 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1263:	55                   	push   %ebp
    1264:	89 e5                	mov    %esp,%ebp
    1266:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1269:	8b 45 10             	mov    0x10(%ebp),%eax
    126c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1270:	8b 45 0c             	mov    0xc(%ebp),%eax
    1273:	89 44 24 04          	mov    %eax,0x4(%esp)
    1277:	8b 45 08             	mov    0x8(%ebp),%eax
    127a:	89 04 24             	mov    %eax,(%esp)
    127d:	e8 26 ff ff ff       	call   11a8 <stosb>
  return dst;
    1282:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1285:	c9                   	leave  
    1286:	c3                   	ret    

00001287 <strchr>:

char*
strchr(const char *s, char c)
{
    1287:	55                   	push   %ebp
    1288:	89 e5                	mov    %esp,%ebp
    128a:	83 ec 04             	sub    $0x4,%esp
    128d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1290:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1293:	eb 14                	jmp    12a9 <strchr+0x22>
    if(*s == c)
    1295:	8b 45 08             	mov    0x8(%ebp),%eax
    1298:	0f b6 00             	movzbl (%eax),%eax
    129b:	3a 45 fc             	cmp    -0x4(%ebp),%al
    129e:	75 05                	jne    12a5 <strchr+0x1e>
      return (char*)s;
    12a0:	8b 45 08             	mov    0x8(%ebp),%eax
    12a3:	eb 13                	jmp    12b8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    12a5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12a9:	8b 45 08             	mov    0x8(%ebp),%eax
    12ac:	0f b6 00             	movzbl (%eax),%eax
    12af:	84 c0                	test   %al,%al
    12b1:	75 e2                	jne    1295 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    12b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12b8:	c9                   	leave  
    12b9:	c3                   	ret    

000012ba <gets>:

char*
gets(char *buf, int max)
{
    12ba:	55                   	push   %ebp
    12bb:	89 e5                	mov    %esp,%ebp
    12bd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12c7:	eb 4c                	jmp    1315 <gets+0x5b>
    cc = read(0, &c, 1);
    12c9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    12d0:	00 
    12d1:	8d 45 ef             	lea    -0x11(%ebp),%eax
    12d4:	89 44 24 04          	mov    %eax,0x4(%esp)
    12d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    12df:	e8 54 01 00 00       	call   1438 <read>
    12e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    12e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12eb:	7f 02                	jg     12ef <gets+0x35>
      break;
    12ed:	eb 31                	jmp    1320 <gets+0x66>
    buf[i++] = c;
    12ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f2:	8d 50 01             	lea    0x1(%eax),%edx
    12f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
    12f8:	89 c2                	mov    %eax,%edx
    12fa:	8b 45 08             	mov    0x8(%ebp),%eax
    12fd:	01 c2                	add    %eax,%edx
    12ff:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1303:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1305:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1309:	3c 0a                	cmp    $0xa,%al
    130b:	74 13                	je     1320 <gets+0x66>
    130d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1311:	3c 0d                	cmp    $0xd,%al
    1313:	74 0b                	je     1320 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1315:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1318:	83 c0 01             	add    $0x1,%eax
    131b:	3b 45 0c             	cmp    0xc(%ebp),%eax
    131e:	7c a9                	jl     12c9 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1320:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1323:	8b 45 08             	mov    0x8(%ebp),%eax
    1326:	01 d0                	add    %edx,%eax
    1328:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    132b:	8b 45 08             	mov    0x8(%ebp),%eax
}
    132e:	c9                   	leave  
    132f:	c3                   	ret    

00001330 <stat>:

int
stat(char *n, struct stat *st)
{
    1330:	55                   	push   %ebp
    1331:	89 e5                	mov    %esp,%ebp
    1333:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1336:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    133d:	00 
    133e:	8b 45 08             	mov    0x8(%ebp),%eax
    1341:	89 04 24             	mov    %eax,(%esp)
    1344:	e8 17 01 00 00       	call   1460 <open>
    1349:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    134c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1350:	79 07                	jns    1359 <stat+0x29>
    return -1;
    1352:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1357:	eb 23                	jmp    137c <stat+0x4c>
  r = fstat(fd, st);
    1359:	8b 45 0c             	mov    0xc(%ebp),%eax
    135c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1360:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1363:	89 04 24             	mov    %eax,(%esp)
    1366:	e8 0d 01 00 00       	call   1478 <fstat>
    136b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    136e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1371:	89 04 24             	mov    %eax,(%esp)
    1374:	e8 cf 00 00 00       	call   1448 <close>
  return r;
    1379:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    137c:	c9                   	leave  
    137d:	c3                   	ret    

0000137e <atoi>:

int
atoi(const char *s)
{
    137e:	55                   	push   %ebp
    137f:	89 e5                	mov    %esp,%ebp
    1381:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1384:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    138b:	eb 25                	jmp    13b2 <atoi+0x34>
    n = n*10 + *s++ - '0';
    138d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1390:	89 d0                	mov    %edx,%eax
    1392:	c1 e0 02             	shl    $0x2,%eax
    1395:	01 d0                	add    %edx,%eax
    1397:	01 c0                	add    %eax,%eax
    1399:	89 c1                	mov    %eax,%ecx
    139b:	8b 45 08             	mov    0x8(%ebp),%eax
    139e:	8d 50 01             	lea    0x1(%eax),%edx
    13a1:	89 55 08             	mov    %edx,0x8(%ebp)
    13a4:	0f b6 00             	movzbl (%eax),%eax
    13a7:	0f be c0             	movsbl %al,%eax
    13aa:	01 c8                	add    %ecx,%eax
    13ac:	83 e8 30             	sub    $0x30,%eax
    13af:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13b2:	8b 45 08             	mov    0x8(%ebp),%eax
    13b5:	0f b6 00             	movzbl (%eax),%eax
    13b8:	3c 2f                	cmp    $0x2f,%al
    13ba:	7e 0a                	jle    13c6 <atoi+0x48>
    13bc:	8b 45 08             	mov    0x8(%ebp),%eax
    13bf:	0f b6 00             	movzbl (%eax),%eax
    13c2:	3c 39                	cmp    $0x39,%al
    13c4:	7e c7                	jle    138d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    13c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13c9:	c9                   	leave  
    13ca:	c3                   	ret    

000013cb <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13cb:	55                   	push   %ebp
    13cc:	89 e5                	mov    %esp,%ebp
    13ce:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    13d1:	8b 45 08             	mov    0x8(%ebp),%eax
    13d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    13d7:	8b 45 0c             	mov    0xc(%ebp),%eax
    13da:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    13dd:	eb 17                	jmp    13f6 <memmove+0x2b>
    *dst++ = *src++;
    13df:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13e2:	8d 50 01             	lea    0x1(%eax),%edx
    13e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
    13e8:	8b 55 f8             	mov    -0x8(%ebp),%edx
    13eb:	8d 4a 01             	lea    0x1(%edx),%ecx
    13ee:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    13f1:	0f b6 12             	movzbl (%edx),%edx
    13f4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    13f6:	8b 45 10             	mov    0x10(%ebp),%eax
    13f9:	8d 50 ff             	lea    -0x1(%eax),%edx
    13fc:	89 55 10             	mov    %edx,0x10(%ebp)
    13ff:	85 c0                	test   %eax,%eax
    1401:	7f dc                	jg     13df <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1403:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1406:	c9                   	leave  
    1407:	c3                   	ret    

00001408 <fork>:
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret


SYSCALL(fork)
    1408:	b8 01 00 00 00       	mov    $0x1,%eax
    140d:	cd 40                	int    $0x40
    140f:	c3                   	ret    

00001410 <exit>:
SYSCALL(exit)
    1410:	b8 02 00 00 00       	mov    $0x2,%eax
    1415:	cd 40                	int    $0x40
    1417:	c3                   	ret    

00001418 <wait>:
SYSCALL(wait)
    1418:	b8 03 00 00 00       	mov    $0x3,%eax
    141d:	cd 40                	int    $0x40
    141f:	c3                   	ret    

00001420 <waitpid>:
SYSCALL(waitpid)
    1420:	b8 16 00 00 00       	mov    $0x16,%eax
    1425:	cd 40                	int    $0x40
    1427:	c3                   	ret    

00001428 <wait_stat>:
SYSCALL(wait_stat)
    1428:	b8 17 00 00 00       	mov    $0x17,%eax
    142d:	cd 40                	int    $0x40
    142f:	c3                   	ret    

00001430 <pipe>:
SYSCALL(pipe)
    1430:	b8 04 00 00 00       	mov    $0x4,%eax
    1435:	cd 40                	int    $0x40
    1437:	c3                   	ret    

00001438 <read>:
SYSCALL(read)
    1438:	b8 05 00 00 00       	mov    $0x5,%eax
    143d:	cd 40                	int    $0x40
    143f:	c3                   	ret    

00001440 <write>:
SYSCALL(write)
    1440:	b8 10 00 00 00       	mov    $0x10,%eax
    1445:	cd 40                	int    $0x40
    1447:	c3                   	ret    

00001448 <close>:
SYSCALL(close)
    1448:	b8 15 00 00 00       	mov    $0x15,%eax
    144d:	cd 40                	int    $0x40
    144f:	c3                   	ret    

00001450 <kill>:
SYSCALL(kill)
    1450:	b8 06 00 00 00       	mov    $0x6,%eax
    1455:	cd 40                	int    $0x40
    1457:	c3                   	ret    

00001458 <exec>:
SYSCALL(exec)
    1458:	b8 07 00 00 00       	mov    $0x7,%eax
    145d:	cd 40                	int    $0x40
    145f:	c3                   	ret    

00001460 <open>:
SYSCALL(open)
    1460:	b8 0f 00 00 00       	mov    $0xf,%eax
    1465:	cd 40                	int    $0x40
    1467:	c3                   	ret    

00001468 <mknod>:
SYSCALL(mknod)
    1468:	b8 11 00 00 00       	mov    $0x11,%eax
    146d:	cd 40                	int    $0x40
    146f:	c3                   	ret    

00001470 <unlink>:
SYSCALL(unlink)
    1470:	b8 12 00 00 00       	mov    $0x12,%eax
    1475:	cd 40                	int    $0x40
    1477:	c3                   	ret    

00001478 <fstat>:
SYSCALL(fstat)
    1478:	b8 08 00 00 00       	mov    $0x8,%eax
    147d:	cd 40                	int    $0x40
    147f:	c3                   	ret    

00001480 <link>:
SYSCALL(link)
    1480:	b8 13 00 00 00       	mov    $0x13,%eax
    1485:	cd 40                	int    $0x40
    1487:	c3                   	ret    

00001488 <mkdir>:
SYSCALL(mkdir)
    1488:	b8 14 00 00 00       	mov    $0x14,%eax
    148d:	cd 40                	int    $0x40
    148f:	c3                   	ret    

00001490 <chdir>:
SYSCALL(chdir)
    1490:	b8 09 00 00 00       	mov    $0x9,%eax
    1495:	cd 40                	int    $0x40
    1497:	c3                   	ret    

00001498 <dup>:
SYSCALL(dup)
    1498:	b8 0a 00 00 00       	mov    $0xa,%eax
    149d:	cd 40                	int    $0x40
    149f:	c3                   	ret    

000014a0 <getpid>:
SYSCALL(getpid)
    14a0:	b8 0b 00 00 00       	mov    $0xb,%eax
    14a5:	cd 40                	int    $0x40
    14a7:	c3                   	ret    

000014a8 <sbrk>:
SYSCALL(sbrk)
    14a8:	b8 0c 00 00 00       	mov    $0xc,%eax
    14ad:	cd 40                	int    $0x40
    14af:	c3                   	ret    

000014b0 <set_priority>:
SYSCALL(set_priority)
    14b0:	b8 18 00 00 00       	mov    $0x18,%eax
    14b5:	cd 40                	int    $0x40
    14b7:	c3                   	ret    

000014b8 <canRemoveJob>:
SYSCALL(canRemoveJob)
    14b8:	b8 19 00 00 00       	mov    $0x19,%eax
    14bd:	cd 40                	int    $0x40
    14bf:	c3                   	ret    

000014c0 <jobs>:
SYSCALL(jobs)
    14c0:	b8 1a 00 00 00       	mov    $0x1a,%eax
    14c5:	cd 40                	int    $0x40
    14c7:	c3                   	ret    

000014c8 <sleep>:
SYSCALL(sleep)
    14c8:	b8 0d 00 00 00       	mov    $0xd,%eax
    14cd:	cd 40                	int    $0x40
    14cf:	c3                   	ret    

000014d0 <uptime>:
SYSCALL(uptime)
    14d0:	b8 0e 00 00 00       	mov    $0xe,%eax
    14d5:	cd 40                	int    $0x40
    14d7:	c3                   	ret    

000014d8 <gidpid>:
SYSCALL(gidpid)
    14d8:	b8 1b 00 00 00       	mov    $0x1b,%eax
    14dd:	cd 40                	int    $0x40
    14df:	c3                   	ret    

000014e0 <isShell>:
SYSCALL(isShell)
    14e0:	b8 1c 00 00 00       	mov    $0x1c,%eax
    14e5:	cd 40                	int    $0x40
    14e7:	c3                   	ret    

000014e8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14e8:	55                   	push   %ebp
    14e9:	89 e5                	mov    %esp,%ebp
    14eb:	83 ec 18             	sub    $0x18,%esp
    14ee:	8b 45 0c             	mov    0xc(%ebp),%eax
    14f1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14fb:	00 
    14fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
    14ff:	89 44 24 04          	mov    %eax,0x4(%esp)
    1503:	8b 45 08             	mov    0x8(%ebp),%eax
    1506:	89 04 24             	mov    %eax,(%esp)
    1509:	e8 32 ff ff ff       	call   1440 <write>
}
    150e:	c9                   	leave  
    150f:	c3                   	ret    

00001510 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1510:	55                   	push   %ebp
    1511:	89 e5                	mov    %esp,%ebp
    1513:	56                   	push   %esi
    1514:	53                   	push   %ebx
    1515:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1518:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    151f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1523:	74 17                	je     153c <printint+0x2c>
    1525:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1529:	79 11                	jns    153c <printint+0x2c>
    neg = 1;
    152b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1532:	8b 45 0c             	mov    0xc(%ebp),%eax
    1535:	f7 d8                	neg    %eax
    1537:	89 45 ec             	mov    %eax,-0x14(%ebp)
    153a:	eb 06                	jmp    1542 <printint+0x32>
  } else {
    x = xx;
    153c:	8b 45 0c             	mov    0xc(%ebp),%eax
    153f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1549:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    154c:	8d 41 01             	lea    0x1(%ecx),%eax
    154f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1552:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1555:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1558:	ba 00 00 00 00       	mov    $0x0,%edx
    155d:	f7 f3                	div    %ebx
    155f:	89 d0                	mov    %edx,%eax
    1561:	0f b6 80 c2 1f 00 00 	movzbl 0x1fc2(%eax),%eax
    1568:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    156c:	8b 75 10             	mov    0x10(%ebp),%esi
    156f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1572:	ba 00 00 00 00       	mov    $0x0,%edx
    1577:	f7 f6                	div    %esi
    1579:	89 45 ec             	mov    %eax,-0x14(%ebp)
    157c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1580:	75 c7                	jne    1549 <printint+0x39>
  if(neg)
    1582:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1586:	74 10                	je     1598 <printint+0x88>
    buf[i++] = '-';
    1588:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158b:	8d 50 01             	lea    0x1(%eax),%edx
    158e:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1591:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1596:	eb 1f                	jmp    15b7 <printint+0xa7>
    1598:	eb 1d                	jmp    15b7 <printint+0xa7>
    putc(fd, buf[i]);
    159a:	8d 55 dc             	lea    -0x24(%ebp),%edx
    159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a0:	01 d0                	add    %edx,%eax
    15a2:	0f b6 00             	movzbl (%eax),%eax
    15a5:	0f be c0             	movsbl %al,%eax
    15a8:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ac:	8b 45 08             	mov    0x8(%ebp),%eax
    15af:	89 04 24             	mov    %eax,(%esp)
    15b2:	e8 31 ff ff ff       	call   14e8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    15b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    15bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15bf:	79 d9                	jns    159a <printint+0x8a>
    putc(fd, buf[i]);
}
    15c1:	83 c4 30             	add    $0x30,%esp
    15c4:	5b                   	pop    %ebx
    15c5:	5e                   	pop    %esi
    15c6:	5d                   	pop    %ebp
    15c7:	c3                   	ret    

000015c8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15c8:	55                   	push   %ebp
    15c9:	89 e5                	mov    %esp,%ebp
    15cb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15d5:	8d 45 0c             	lea    0xc(%ebp),%eax
    15d8:	83 c0 04             	add    $0x4,%eax
    15db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    15de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15e5:	e9 7c 01 00 00       	jmp    1766 <printf+0x19e>
    c = fmt[i] & 0xff;
    15ea:	8b 55 0c             	mov    0xc(%ebp),%edx
    15ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f0:	01 d0                	add    %edx,%eax
    15f2:	0f b6 00             	movzbl (%eax),%eax
    15f5:	0f be c0             	movsbl %al,%eax
    15f8:	25 ff 00 00 00       	and    $0xff,%eax
    15fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1600:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1604:	75 2c                	jne    1632 <printf+0x6a>
      if(c == '%'){
    1606:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    160a:	75 0c                	jne    1618 <printf+0x50>
        state = '%';
    160c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1613:	e9 4a 01 00 00       	jmp    1762 <printf+0x19a>
      } else {
        putc(fd, c);
    1618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    161b:	0f be c0             	movsbl %al,%eax
    161e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1622:	8b 45 08             	mov    0x8(%ebp),%eax
    1625:	89 04 24             	mov    %eax,(%esp)
    1628:	e8 bb fe ff ff       	call   14e8 <putc>
    162d:	e9 30 01 00 00       	jmp    1762 <printf+0x19a>
      }
    } else if(state == '%'){
    1632:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1636:	0f 85 26 01 00 00    	jne    1762 <printf+0x19a>
      if(c == 'd'){
    163c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1640:	75 2d                	jne    166f <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1642:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1645:	8b 00                	mov    (%eax),%eax
    1647:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    164e:	00 
    164f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1656:	00 
    1657:	89 44 24 04          	mov    %eax,0x4(%esp)
    165b:	8b 45 08             	mov    0x8(%ebp),%eax
    165e:	89 04 24             	mov    %eax,(%esp)
    1661:	e8 aa fe ff ff       	call   1510 <printint>
        ap++;
    1666:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    166a:	e9 ec 00 00 00       	jmp    175b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    166f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1673:	74 06                	je     167b <printf+0xb3>
    1675:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1679:	75 2d                	jne    16a8 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    167b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    167e:	8b 00                	mov    (%eax),%eax
    1680:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1687:	00 
    1688:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    168f:	00 
    1690:	89 44 24 04          	mov    %eax,0x4(%esp)
    1694:	8b 45 08             	mov    0x8(%ebp),%eax
    1697:	89 04 24             	mov    %eax,(%esp)
    169a:	e8 71 fe ff ff       	call   1510 <printint>
        ap++;
    169f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16a3:	e9 b3 00 00 00       	jmp    175b <printf+0x193>
      } else if(c == 's'){
    16a8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    16ac:	75 45                	jne    16f3 <printf+0x12b>
        s = (char*)*ap;
    16ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16b1:	8b 00                	mov    (%eax),%eax
    16b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    16b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    16ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16be:	75 09                	jne    16c9 <printf+0x101>
          s = "(null)";
    16c0:	c7 45 f4 cd 1a 00 00 	movl   $0x1acd,-0xc(%ebp)
        while(*s != 0){
    16c7:	eb 1e                	jmp    16e7 <printf+0x11f>
    16c9:	eb 1c                	jmp    16e7 <printf+0x11f>
          putc(fd, *s);
    16cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ce:	0f b6 00             	movzbl (%eax),%eax
    16d1:	0f be c0             	movsbl %al,%eax
    16d4:	89 44 24 04          	mov    %eax,0x4(%esp)
    16d8:	8b 45 08             	mov    0x8(%ebp),%eax
    16db:	89 04 24             	mov    %eax,(%esp)
    16de:	e8 05 fe ff ff       	call   14e8 <putc>
          s++;
    16e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    16e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ea:	0f b6 00             	movzbl (%eax),%eax
    16ed:	84 c0                	test   %al,%al
    16ef:	75 da                	jne    16cb <printf+0x103>
    16f1:	eb 68                	jmp    175b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16f3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    16f7:	75 1d                	jne    1716 <printf+0x14e>
        putc(fd, *ap);
    16f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16fc:	8b 00                	mov    (%eax),%eax
    16fe:	0f be c0             	movsbl %al,%eax
    1701:	89 44 24 04          	mov    %eax,0x4(%esp)
    1705:	8b 45 08             	mov    0x8(%ebp),%eax
    1708:	89 04 24             	mov    %eax,(%esp)
    170b:	e8 d8 fd ff ff       	call   14e8 <putc>
        ap++;
    1710:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1714:	eb 45                	jmp    175b <printf+0x193>
      } else if(c == '%'){
    1716:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    171a:	75 17                	jne    1733 <printf+0x16b>
        putc(fd, c);
    171c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    171f:	0f be c0             	movsbl %al,%eax
    1722:	89 44 24 04          	mov    %eax,0x4(%esp)
    1726:	8b 45 08             	mov    0x8(%ebp),%eax
    1729:	89 04 24             	mov    %eax,(%esp)
    172c:	e8 b7 fd ff ff       	call   14e8 <putc>
    1731:	eb 28                	jmp    175b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1733:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    173a:	00 
    173b:	8b 45 08             	mov    0x8(%ebp),%eax
    173e:	89 04 24             	mov    %eax,(%esp)
    1741:	e8 a2 fd ff ff       	call   14e8 <putc>
        putc(fd, c);
    1746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1749:	0f be c0             	movsbl %al,%eax
    174c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1750:	8b 45 08             	mov    0x8(%ebp),%eax
    1753:	89 04 24             	mov    %eax,(%esp)
    1756:	e8 8d fd ff ff       	call   14e8 <putc>
      }
      state = 0;
    175b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1762:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1766:	8b 55 0c             	mov    0xc(%ebp),%edx
    1769:	8b 45 f0             	mov    -0x10(%ebp),%eax
    176c:	01 d0                	add    %edx,%eax
    176e:	0f b6 00             	movzbl (%eax),%eax
    1771:	84 c0                	test   %al,%al
    1773:	0f 85 71 fe ff ff    	jne    15ea <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1779:	c9                   	leave  
    177a:	c3                   	ret    

0000177b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    177b:	55                   	push   %ebp
    177c:	89 e5                	mov    %esp,%ebp
    177e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1781:	8b 45 08             	mov    0x8(%ebp),%eax
    1784:	83 e8 08             	sub    $0x8,%eax
    1787:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    178a:	a1 4c 21 00 00       	mov    0x214c,%eax
    178f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1792:	eb 24                	jmp    17b8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1794:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1797:	8b 00                	mov    (%eax),%eax
    1799:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    179c:	77 12                	ja     17b0 <free+0x35>
    179e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17a4:	77 24                	ja     17ca <free+0x4f>
    17a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a9:	8b 00                	mov    (%eax),%eax
    17ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17ae:	77 1a                	ja     17ca <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b3:	8b 00                	mov    (%eax),%eax
    17b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17be:	76 d4                	jbe    1794 <free+0x19>
    17c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c3:	8b 00                	mov    (%eax),%eax
    17c5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17c8:	76 ca                	jbe    1794 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17cd:	8b 40 04             	mov    0x4(%eax),%eax
    17d0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17da:	01 c2                	add    %eax,%edx
    17dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17df:	8b 00                	mov    (%eax),%eax
    17e1:	39 c2                	cmp    %eax,%edx
    17e3:	75 24                	jne    1809 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    17e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17e8:	8b 50 04             	mov    0x4(%eax),%edx
    17eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ee:	8b 00                	mov    (%eax),%eax
    17f0:	8b 40 04             	mov    0x4(%eax),%eax
    17f3:	01 c2                	add    %eax,%edx
    17f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17f8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    17fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17fe:	8b 00                	mov    (%eax),%eax
    1800:	8b 10                	mov    (%eax),%edx
    1802:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1805:	89 10                	mov    %edx,(%eax)
    1807:	eb 0a                	jmp    1813 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1809:	8b 45 fc             	mov    -0x4(%ebp),%eax
    180c:	8b 10                	mov    (%eax),%edx
    180e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1811:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1813:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1816:	8b 40 04             	mov    0x4(%eax),%eax
    1819:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1820:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1823:	01 d0                	add    %edx,%eax
    1825:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1828:	75 20                	jne    184a <free+0xcf>
    p->s.size += bp->s.size;
    182a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    182d:	8b 50 04             	mov    0x4(%eax),%edx
    1830:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1833:	8b 40 04             	mov    0x4(%eax),%eax
    1836:	01 c2                	add    %eax,%edx
    1838:	8b 45 fc             	mov    -0x4(%ebp),%eax
    183b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    183e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1841:	8b 10                	mov    (%eax),%edx
    1843:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1846:	89 10                	mov    %edx,(%eax)
    1848:	eb 08                	jmp    1852 <free+0xd7>
  } else
    p->s.ptr = bp;
    184a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    184d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1850:	89 10                	mov    %edx,(%eax)
  freep = p;
    1852:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1855:	a3 4c 21 00 00       	mov    %eax,0x214c
}
    185a:	c9                   	leave  
    185b:	c3                   	ret    

0000185c <morecore>:

static Header*
morecore(uint nu)
{
    185c:	55                   	push   %ebp
    185d:	89 e5                	mov    %esp,%ebp
    185f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1862:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1869:	77 07                	ja     1872 <morecore+0x16>
    nu = 4096;
    186b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1872:	8b 45 08             	mov    0x8(%ebp),%eax
    1875:	c1 e0 03             	shl    $0x3,%eax
    1878:	89 04 24             	mov    %eax,(%esp)
    187b:	e8 28 fc ff ff       	call   14a8 <sbrk>
    1880:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1883:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1887:	75 07                	jne    1890 <morecore+0x34>
    return 0;
    1889:	b8 00 00 00 00       	mov    $0x0,%eax
    188e:	eb 22                	jmp    18b2 <morecore+0x56>
  hp = (Header*)p;
    1890:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1893:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1896:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1899:	8b 55 08             	mov    0x8(%ebp),%edx
    189c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18a2:	83 c0 08             	add    $0x8,%eax
    18a5:	89 04 24             	mov    %eax,(%esp)
    18a8:	e8 ce fe ff ff       	call   177b <free>
  return freep;
    18ad:	a1 4c 21 00 00       	mov    0x214c,%eax
}
    18b2:	c9                   	leave  
    18b3:	c3                   	ret    

000018b4 <malloc>:

void*
malloc(uint nbytes)
{
    18b4:	55                   	push   %ebp
    18b5:	89 e5                	mov    %esp,%ebp
    18b7:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18ba:	8b 45 08             	mov    0x8(%ebp),%eax
    18bd:	83 c0 07             	add    $0x7,%eax
    18c0:	c1 e8 03             	shr    $0x3,%eax
    18c3:	83 c0 01             	add    $0x1,%eax
    18c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18c9:	a1 4c 21 00 00       	mov    0x214c,%eax
    18ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18d5:	75 23                	jne    18fa <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    18d7:	c7 45 f0 44 21 00 00 	movl   $0x2144,-0x10(%ebp)
    18de:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e1:	a3 4c 21 00 00       	mov    %eax,0x214c
    18e6:	a1 4c 21 00 00       	mov    0x214c,%eax
    18eb:	a3 44 21 00 00       	mov    %eax,0x2144
    base.s.size = 0;
    18f0:	c7 05 48 21 00 00 00 	movl   $0x0,0x2148
    18f7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18fd:	8b 00                	mov    (%eax),%eax
    18ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1902:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1905:	8b 40 04             	mov    0x4(%eax),%eax
    1908:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    190b:	72 4d                	jb     195a <malloc+0xa6>
      if(p->s.size == nunits)
    190d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1910:	8b 40 04             	mov    0x4(%eax),%eax
    1913:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1916:	75 0c                	jne    1924 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1918:	8b 45 f4             	mov    -0xc(%ebp),%eax
    191b:	8b 10                	mov    (%eax),%edx
    191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1920:	89 10                	mov    %edx,(%eax)
    1922:	eb 26                	jmp    194a <malloc+0x96>
      else {
        p->s.size -= nunits;
    1924:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1927:	8b 40 04             	mov    0x4(%eax),%eax
    192a:	2b 45 ec             	sub    -0x14(%ebp),%eax
    192d:	89 c2                	mov    %eax,%edx
    192f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1932:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1935:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1938:	8b 40 04             	mov    0x4(%eax),%eax
    193b:	c1 e0 03             	shl    $0x3,%eax
    193e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1941:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1944:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1947:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    194a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    194d:	a3 4c 21 00 00       	mov    %eax,0x214c
      return (void*)(p + 1);
    1952:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1955:	83 c0 08             	add    $0x8,%eax
    1958:	eb 38                	jmp    1992 <malloc+0xde>
    }
    if(p == freep)
    195a:	a1 4c 21 00 00       	mov    0x214c,%eax
    195f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1962:	75 1b                	jne    197f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1964:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1967:	89 04 24             	mov    %eax,(%esp)
    196a:	e8 ed fe ff ff       	call   185c <morecore>
    196f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1976:	75 07                	jne    197f <malloc+0xcb>
        return 0;
    1978:	b8 00 00 00 00       	mov    $0x0,%eax
    197d:	eb 13                	jmp    1992 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1982:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1985:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1988:	8b 00                	mov    (%eax),%eax
    198a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    198d:	e9 70 ff ff ff       	jmp    1902 <malloc+0x4e>
}
    1992:	c9                   	leave  
    1993:	c3                   	ret    
