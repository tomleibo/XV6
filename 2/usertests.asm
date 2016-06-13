
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "iput test\n");
       6:	a1 18 63 00 00       	mov    0x6318,%eax
       b:	c7 44 24 04 42 44 00 	movl   $0x4442,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 4c 40 00 00       	call   4067 <printf>

  if(mkdir("iputdir") < 0){
      1b:	c7 04 24 4d 44 00 00 	movl   $0x444d,(%esp)
      22:	e8 31 3f 00 00       	call   3f58 <mkdir>
      27:	85 c0                	test   %eax,%eax
      29:	79 1a                	jns    45 <iputtest+0x45>
    printf(stdout, "mkdir failed\n");
      2b:	a1 18 63 00 00       	mov    0x6318,%eax
      30:	c7 44 24 04 55 44 00 	movl   $0x4455,0x4(%esp)
      37:	00 
      38:	89 04 24             	mov    %eax,(%esp)
      3b:	e8 27 40 00 00       	call   4067 <printf>
    exit();
      40:	e8 ab 3e 00 00       	call   3ef0 <exit>
  }
  if(chdir("iputdir") < 0){
      45:	c7 04 24 4d 44 00 00 	movl   $0x444d,(%esp)
      4c:	e8 0f 3f 00 00       	call   3f60 <chdir>
      51:	85 c0                	test   %eax,%eax
      53:	79 1a                	jns    6f <iputtest+0x6f>
    printf(stdout, "chdir iputdir failed\n");
      55:	a1 18 63 00 00       	mov    0x6318,%eax
      5a:	c7 44 24 04 63 44 00 	movl   $0x4463,0x4(%esp)
      61:	00 
      62:	89 04 24             	mov    %eax,(%esp)
      65:	e8 fd 3f 00 00       	call   4067 <printf>
    exit();
      6a:	e8 81 3e 00 00       	call   3ef0 <exit>
  }
  if(unlink("../iputdir") < 0){
      6f:	c7 04 24 79 44 00 00 	movl   $0x4479,(%esp)
      76:	e8 c5 3e 00 00       	call   3f40 <unlink>
      7b:	85 c0                	test   %eax,%eax
      7d:	79 1a                	jns    99 <iputtest+0x99>
    printf(stdout, "unlink ../iputdir failed\n");
      7f:	a1 18 63 00 00       	mov    0x6318,%eax
      84:	c7 44 24 04 84 44 00 	movl   $0x4484,0x4(%esp)
      8b:	00 
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 d3 3f 00 00       	call   4067 <printf>
    exit();
      94:	e8 57 3e 00 00       	call   3ef0 <exit>
  }
  if(chdir("/") < 0){
      99:	c7 04 24 9e 44 00 00 	movl   $0x449e,(%esp)
      a0:	e8 bb 3e 00 00       	call   3f60 <chdir>
      a5:	85 c0                	test   %eax,%eax
      a7:	79 1a                	jns    c3 <iputtest+0xc3>
    printf(stdout, "chdir / failed\n");
      a9:	a1 18 63 00 00       	mov    0x6318,%eax
      ae:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
      b5:	00 
      b6:	89 04 24             	mov    %eax,(%esp)
      b9:	e8 a9 3f 00 00       	call   4067 <printf>
    exit();
      be:	e8 2d 3e 00 00       	call   3ef0 <exit>
  }
  printf(stdout, "iput test ok\n");
      c3:	a1 18 63 00 00       	mov    0x6318,%eax
      c8:	c7 44 24 04 b0 44 00 	movl   $0x44b0,0x4(%esp)
      cf:	00 
      d0:	89 04 24             	mov    %eax,(%esp)
      d3:	e8 8f 3f 00 00       	call   4067 <printf>
}
      d8:	c9                   	leave  
      d9:	c3                   	ret    

000000da <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      da:	55                   	push   %ebp
      db:	89 e5                	mov    %esp,%ebp
      dd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e0:	a1 18 63 00 00       	mov    0x6318,%eax
      e5:	c7 44 24 04 be 44 00 	movl   $0x44be,0x4(%esp)
      ec:	00 
      ed:	89 04 24             	mov    %eax,(%esp)
      f0:	e8 72 3f 00 00       	call   4067 <printf>

  pid = fork();
      f5:	e8 ee 3d 00 00       	call   3ee8 <fork>
      fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
      fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     101:	79 1a                	jns    11d <exitiputtest+0x43>
    printf(stdout, "fork failed\n");
     103:	a1 18 63 00 00       	mov    0x6318,%eax
     108:	c7 44 24 04 cd 44 00 	movl   $0x44cd,0x4(%esp)
     10f:	00 
     110:	89 04 24             	mov    %eax,(%esp)
     113:	e8 4f 3f 00 00       	call   4067 <printf>
    exit();
     118:	e8 d3 3d 00 00       	call   3ef0 <exit>
  }
  if(pid == 0){
     11d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     121:	0f 85 83 00 00 00    	jne    1aa <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     127:	c7 04 24 4d 44 00 00 	movl   $0x444d,(%esp)
     12e:	e8 25 3e 00 00       	call   3f58 <mkdir>
     133:	85 c0                	test   %eax,%eax
     135:	79 1a                	jns    151 <exitiputtest+0x77>
      printf(stdout, "mkdir failed\n");
     137:	a1 18 63 00 00       	mov    0x6318,%eax
     13c:	c7 44 24 04 55 44 00 	movl   $0x4455,0x4(%esp)
     143:	00 
     144:	89 04 24             	mov    %eax,(%esp)
     147:	e8 1b 3f 00 00       	call   4067 <printf>
      exit();
     14c:	e8 9f 3d 00 00       	call   3ef0 <exit>
    }
    if(chdir("iputdir") < 0){
     151:	c7 04 24 4d 44 00 00 	movl   $0x444d,(%esp)
     158:	e8 03 3e 00 00       	call   3f60 <chdir>
     15d:	85 c0                	test   %eax,%eax
     15f:	79 1a                	jns    17b <exitiputtest+0xa1>
      printf(stdout, "child chdir failed\n");
     161:	a1 18 63 00 00       	mov    0x6318,%eax
     166:	c7 44 24 04 da 44 00 	movl   $0x44da,0x4(%esp)
     16d:	00 
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 f1 3e 00 00       	call   4067 <printf>
      exit();
     176:	e8 75 3d 00 00       	call   3ef0 <exit>
    }
    if(unlink("../iputdir") < 0){
     17b:	c7 04 24 79 44 00 00 	movl   $0x4479,(%esp)
     182:	e8 b9 3d 00 00       	call   3f40 <unlink>
     187:	85 c0                	test   %eax,%eax
     189:	79 1a                	jns    1a5 <exitiputtest+0xcb>
      printf(stdout, "unlink ../iputdir failed\n");
     18b:	a1 18 63 00 00       	mov    0x6318,%eax
     190:	c7 44 24 04 84 44 00 	movl   $0x4484,0x4(%esp)
     197:	00 
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 c7 3e 00 00       	call   4067 <printf>
      exit();
     1a0:	e8 4b 3d 00 00       	call   3ef0 <exit>
    }
    exit();
     1a5:	e8 46 3d 00 00       	call   3ef0 <exit>
  }
  wait();
     1aa:	e8 49 3d 00 00       	call   3ef8 <wait>
  printf(stdout, "exitiput test ok\n");
     1af:	a1 18 63 00 00       	mov    0x6318,%eax
     1b4:	c7 44 24 04 ee 44 00 	movl   $0x44ee,0x4(%esp)
     1bb:	00 
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 a3 3e 00 00       	call   4067 <printf>
}
     1c4:	c9                   	leave  
     1c5:	c3                   	ret    

000001c6 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c6:	55                   	push   %ebp
     1c7:	89 e5                	mov    %esp,%ebp
     1c9:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1cc:	a1 18 63 00 00       	mov    0x6318,%eax
     1d1:	c7 44 24 04 00 45 00 	movl   $0x4500,0x4(%esp)
     1d8:	00 
     1d9:	89 04 24             	mov    %eax,(%esp)
     1dc:	e8 86 3e 00 00       	call   4067 <printf>
  if(mkdir("oidir") < 0){
     1e1:	c7 04 24 0f 45 00 00 	movl   $0x450f,(%esp)
     1e8:	e8 6b 3d 00 00       	call   3f58 <mkdir>
     1ed:	85 c0                	test   %eax,%eax
     1ef:	79 1a                	jns    20b <openiputtest+0x45>
    printf(stdout, "mkdir oidir failed\n");
     1f1:	a1 18 63 00 00       	mov    0x6318,%eax
     1f6:	c7 44 24 04 15 45 00 	movl   $0x4515,0x4(%esp)
     1fd:	00 
     1fe:	89 04 24             	mov    %eax,(%esp)
     201:	e8 61 3e 00 00       	call   4067 <printf>
    exit();
     206:	e8 e5 3c 00 00       	call   3ef0 <exit>
  }
  pid = fork();
     20b:	e8 d8 3c 00 00       	call   3ee8 <fork>
     210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     217:	79 1a                	jns    233 <openiputtest+0x6d>
    printf(stdout, "fork failed\n");
     219:	a1 18 63 00 00       	mov    0x6318,%eax
     21e:	c7 44 24 04 cd 44 00 	movl   $0x44cd,0x4(%esp)
     225:	00 
     226:	89 04 24             	mov    %eax,(%esp)
     229:	e8 39 3e 00 00       	call   4067 <printf>
    exit();
     22e:	e8 bd 3c 00 00       	call   3ef0 <exit>
  }
  if(pid == 0){
     233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     237:	75 3c                	jne    275 <openiputtest+0xaf>
    int fd = open("oidir", O_RDWR);
     239:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     240:	00 
     241:	c7 04 24 0f 45 00 00 	movl   $0x450f,(%esp)
     248:	e8 e3 3c 00 00       	call   3f30 <open>
     24d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     254:	78 1a                	js     270 <openiputtest+0xaa>
      printf(stdout, "open directory for write succeeded\n");
     256:	a1 18 63 00 00       	mov    0x6318,%eax
     25b:	c7 44 24 04 2c 45 00 	movl   $0x452c,0x4(%esp)
     262:	00 
     263:	89 04 24             	mov    %eax,(%esp)
     266:	e8 fc 3d 00 00       	call   4067 <printf>
      exit();
     26b:	e8 80 3c 00 00       	call   3ef0 <exit>
    }
    exit();
     270:	e8 7b 3c 00 00       	call   3ef0 <exit>
  }
  sleep(1);
     275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     27c:	e8 ff 3c 00 00       	call   3f80 <sleep>
  if(unlink("oidir") != 0){
     281:	c7 04 24 0f 45 00 00 	movl   $0x450f,(%esp)
     288:	e8 b3 3c 00 00       	call   3f40 <unlink>
     28d:	85 c0                	test   %eax,%eax
     28f:	74 1a                	je     2ab <openiputtest+0xe5>
    printf(stdout, "unlink failed\n");
     291:	a1 18 63 00 00       	mov    0x6318,%eax
     296:	c7 44 24 04 50 45 00 	movl   $0x4550,0x4(%esp)
     29d:	00 
     29e:	89 04 24             	mov    %eax,(%esp)
     2a1:	e8 c1 3d 00 00       	call   4067 <printf>
    exit();
     2a6:	e8 45 3c 00 00       	call   3ef0 <exit>
  }
  wait();
     2ab:	e8 48 3c 00 00       	call   3ef8 <wait>
  printf(stdout, "openiput test ok\n");
     2b0:	a1 18 63 00 00       	mov    0x6318,%eax
     2b5:	c7 44 24 04 5f 45 00 	movl   $0x455f,0x4(%esp)
     2bc:	00 
     2bd:	89 04 24             	mov    %eax,(%esp)
     2c0:	e8 a2 3d 00 00       	call   4067 <printf>
}
     2c5:	c9                   	leave  
     2c6:	c3                   	ret    

000002c7 <opentest>:

// simple file system tests

void
opentest(void)
{
     2c7:	55                   	push   %ebp
     2c8:	89 e5                	mov    %esp,%ebp
     2ca:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
     2cd:	a1 18 63 00 00       	mov    0x6318,%eax
     2d2:	c7 44 24 04 71 45 00 	movl   $0x4571,0x4(%esp)
     2d9:	00 
     2da:	89 04 24             	mov    %eax,(%esp)
     2dd:	e8 85 3d 00 00       	call   4067 <printf>
  fd = open("echo", 0);
     2e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2e9:	00 
     2ea:	c7 04 24 2c 44 00 00 	movl   $0x442c,(%esp)
     2f1:	e8 3a 3c 00 00       	call   3f30 <open>
     2f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     2f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2fd:	79 1a                	jns    319 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     2ff:	a1 18 63 00 00       	mov    0x6318,%eax
     304:	c7 44 24 04 7c 45 00 	movl   $0x457c,0x4(%esp)
     30b:	00 
     30c:	89 04 24             	mov    %eax,(%esp)
     30f:	e8 53 3d 00 00       	call   4067 <printf>
    exit();
     314:	e8 d7 3b 00 00       	call   3ef0 <exit>
  }
  close(fd);
     319:	8b 45 f4             	mov    -0xc(%ebp),%eax
     31c:	89 04 24             	mov    %eax,(%esp)
     31f:	e8 f4 3b 00 00       	call   3f18 <close>
  fd = open("doesnotexist", 0);
     324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     32b:	00 
     32c:	c7 04 24 8f 45 00 00 	movl   $0x458f,(%esp)
     333:	e8 f8 3b 00 00       	call   3f30 <open>
     338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     33b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     33f:	78 1a                	js     35b <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
     341:	a1 18 63 00 00       	mov    0x6318,%eax
     346:	c7 44 24 04 9c 45 00 	movl   $0x459c,0x4(%esp)
     34d:	00 
     34e:	89 04 24             	mov    %eax,(%esp)
     351:	e8 11 3d 00 00       	call   4067 <printf>
    exit();
     356:	e8 95 3b 00 00       	call   3ef0 <exit>
  }
  printf(stdout, "open test ok\n");
     35b:	a1 18 63 00 00       	mov    0x6318,%eax
     360:	c7 44 24 04 ba 45 00 	movl   $0x45ba,0x4(%esp)
     367:	00 
     368:	89 04 24             	mov    %eax,(%esp)
     36b:	e8 f7 3c 00 00       	call   4067 <printf>
}
     370:	c9                   	leave  
     371:	c3                   	ret    

00000372 <writetest>:

void
writetest(void)
{
     372:	55                   	push   %ebp
     373:	89 e5                	mov    %esp,%ebp
     375:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     378:	a1 18 63 00 00       	mov    0x6318,%eax
     37d:	c7 44 24 04 c8 45 00 	movl   $0x45c8,0x4(%esp)
     384:	00 
     385:	89 04 24             	mov    %eax,(%esp)
     388:	e8 da 3c 00 00       	call   4067 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     38d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     394:	00 
     395:	c7 04 24 d9 45 00 00 	movl   $0x45d9,(%esp)
     39c:	e8 8f 3b 00 00       	call   3f30 <open>
     3a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3a8:	78 21                	js     3cb <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
     3aa:	a1 18 63 00 00       	mov    0x6318,%eax
     3af:	c7 44 24 04 df 45 00 	movl   $0x45df,0x4(%esp)
     3b6:	00 
     3b7:	89 04 24             	mov    %eax,(%esp)
     3ba:	e8 a8 3c 00 00       	call   4067 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3c6:	e9 a0 00 00 00       	jmp    46b <writetest+0xf9>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     3cb:	a1 18 63 00 00       	mov    0x6318,%eax
     3d0:	c7 44 24 04 fa 45 00 	movl   $0x45fa,0x4(%esp)
     3d7:	00 
     3d8:	89 04 24             	mov    %eax,(%esp)
     3db:	e8 87 3c 00 00       	call   4067 <printf>
    exit();
     3e0:	e8 0b 3b 00 00       	call   3ef0 <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     3ec:	00 
     3ed:	c7 44 24 04 16 46 00 	movl   $0x4616,0x4(%esp)
     3f4:	00 
     3f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3f8:	89 04 24             	mov    %eax,(%esp)
     3fb:	e8 10 3b 00 00       	call   3f10 <write>
     400:	83 f8 0a             	cmp    $0xa,%eax
     403:	74 21                	je     426 <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
     405:	a1 18 63 00 00       	mov    0x6318,%eax
     40a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     40d:	89 54 24 08          	mov    %edx,0x8(%esp)
     411:	c7 44 24 04 24 46 00 	movl   $0x4624,0x4(%esp)
     418:	00 
     419:	89 04 24             	mov    %eax,(%esp)
     41c:	e8 46 3c 00 00       	call   4067 <printf>
      exit();
     421:	e8 ca 3a 00 00       	call   3ef0 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     426:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     42d:	00 
     42e:	c7 44 24 04 48 46 00 	movl   $0x4648,0x4(%esp)
     435:	00 
     436:	8b 45 f0             	mov    -0x10(%ebp),%eax
     439:	89 04 24             	mov    %eax,(%esp)
     43c:	e8 cf 3a 00 00       	call   3f10 <write>
     441:	83 f8 0a             	cmp    $0xa,%eax
     444:	74 21                	je     467 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
     446:	a1 18 63 00 00       	mov    0x6318,%eax
     44b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     44e:	89 54 24 08          	mov    %edx,0x8(%esp)
     452:	c7 44 24 04 54 46 00 	movl   $0x4654,0x4(%esp)
     459:	00 
     45a:	89 04 24             	mov    %eax,(%esp)
     45d:	e8 05 3c 00 00       	call   4067 <printf>
      exit();
     462:	e8 89 3a 00 00       	call   3ef0 <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     467:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     46b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     46f:	0f 8e 70 ff ff ff    	jle    3e5 <writetest+0x73>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     475:	a1 18 63 00 00       	mov    0x6318,%eax
     47a:	c7 44 24 04 78 46 00 	movl   $0x4678,0x4(%esp)
     481:	00 
     482:	89 04 24             	mov    %eax,(%esp)
     485:	e8 dd 3b 00 00       	call   4067 <printf>
  close(fd);
     48a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     48d:	89 04 24             	mov    %eax,(%esp)
     490:	e8 83 3a 00 00       	call   3f18 <close>
  fd = open("small", O_RDONLY);
     495:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     49c:	00 
     49d:	c7 04 24 d9 45 00 00 	movl   $0x45d9,(%esp)
     4a4:	e8 87 3a 00 00       	call   3f30 <open>
     4a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4b0:	78 3e                	js     4f0 <writetest+0x17e>
    printf(stdout, "open small succeeded ok\n");
     4b2:	a1 18 63 00 00       	mov    0x6318,%eax
     4b7:	c7 44 24 04 83 46 00 	movl   $0x4683,0x4(%esp)
     4be:	00 
     4bf:	89 04 24             	mov    %eax,(%esp)
     4c2:	e8 a0 3b 00 00       	call   4067 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4c7:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     4ce:	00 
     4cf:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
     4d6:	00 
     4d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4da:	89 04 24             	mov    %eax,(%esp)
     4dd:	e8 26 3a 00 00       	call   3f08 <read>
     4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     4e5:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     4ec:	74 1c                	je     50a <writetest+0x198>
     4ee:	eb 4c                	jmp    53c <writetest+0x1ca>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     4f0:	a1 18 63 00 00       	mov    0x6318,%eax
     4f5:	c7 44 24 04 9c 46 00 	movl   $0x469c,0x4(%esp)
     4fc:	00 
     4fd:	89 04 24             	mov    %eax,(%esp)
     500:	e8 62 3b 00 00       	call   4067 <printf>
    exit();
     505:	e8 e6 39 00 00       	call   3ef0 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     50a:	a1 18 63 00 00       	mov    0x6318,%eax
     50f:	c7 44 24 04 b7 46 00 	movl   $0x46b7,0x4(%esp)
     516:	00 
     517:	89 04 24             	mov    %eax,(%esp)
     51a:	e8 48 3b 00 00       	call   4067 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     51f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     522:	89 04 24             	mov    %eax,(%esp)
     525:	e8 ee 39 00 00       	call   3f18 <close>

  if(unlink("small") < 0){
     52a:	c7 04 24 d9 45 00 00 	movl   $0x45d9,(%esp)
     531:	e8 0a 3a 00 00       	call   3f40 <unlink>
     536:	85 c0                	test   %eax,%eax
     538:	78 1c                	js     556 <writetest+0x1e4>
     53a:	eb 34                	jmp    570 <writetest+0x1fe>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     53c:	a1 18 63 00 00       	mov    0x6318,%eax
     541:	c7 44 24 04 ca 46 00 	movl   $0x46ca,0x4(%esp)
     548:	00 
     549:	89 04 24             	mov    %eax,(%esp)
     54c:	e8 16 3b 00 00       	call   4067 <printf>
    exit();
     551:	e8 9a 39 00 00       	call   3ef0 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     556:	a1 18 63 00 00       	mov    0x6318,%eax
     55b:	c7 44 24 04 d7 46 00 	movl   $0x46d7,0x4(%esp)
     562:	00 
     563:	89 04 24             	mov    %eax,(%esp)
     566:	e8 fc 3a 00 00       	call   4067 <printf>
    exit();
     56b:	e8 80 39 00 00       	call   3ef0 <exit>
  }
  printf(stdout, "small file test ok\n");
     570:	a1 18 63 00 00       	mov    0x6318,%eax
     575:	c7 44 24 04 ec 46 00 	movl   $0x46ec,0x4(%esp)
     57c:	00 
     57d:	89 04 24             	mov    %eax,(%esp)
     580:	e8 e2 3a 00 00       	call   4067 <printf>
}
     585:	c9                   	leave  
     586:	c3                   	ret    

00000587 <writetest1>:

void
writetest1(void)
{
     587:	55                   	push   %ebp
     588:	89 e5                	mov    %esp,%ebp
     58a:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     58d:	a1 18 63 00 00       	mov    0x6318,%eax
     592:	c7 44 24 04 00 47 00 	movl   $0x4700,0x4(%esp)
     599:	00 
     59a:	89 04 24             	mov    %eax,(%esp)
     59d:	e8 c5 3a 00 00       	call   4067 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     5a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     5a9:	00 
     5aa:	c7 04 24 10 47 00 00 	movl   $0x4710,(%esp)
     5b1:	e8 7a 39 00 00       	call   3f30 <open>
     5b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5bd:	79 1a                	jns    5d9 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
     5bf:	a1 18 63 00 00       	mov    0x6318,%eax
     5c4:	c7 44 24 04 14 47 00 	movl   $0x4714,0x4(%esp)
     5cb:	00 
     5cc:	89 04 24             	mov    %eax,(%esp)
     5cf:	e8 93 3a 00 00       	call   4067 <printf>
    exit();
     5d4:	e8 17 39 00 00       	call   3ef0 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     5d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     5e0:	eb 51                	jmp    633 <writetest1+0xac>
    ((int*)buf)[0] = i;
     5e2:	b8 00 8b 00 00       	mov    $0x8b00,%eax
     5e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     5ea:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     5ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     5f3:	00 
     5f4:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
     5fb:	00 
     5fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ff:	89 04 24             	mov    %eax,(%esp)
     602:	e8 09 39 00 00       	call   3f10 <write>
     607:	3d 00 02 00 00       	cmp    $0x200,%eax
     60c:	74 21                	je     62f <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
     60e:	a1 18 63 00 00       	mov    0x6318,%eax
     613:	8b 55 f4             	mov    -0xc(%ebp),%edx
     616:	89 54 24 08          	mov    %edx,0x8(%esp)
     61a:	c7 44 24 04 2e 47 00 	movl   $0x472e,0x4(%esp)
     621:	00 
     622:	89 04 24             	mov    %eax,(%esp)
     625:	e8 3d 3a 00 00       	call   4067 <printf>
      exit();
     62a:	e8 c1 38 00 00       	call   3ef0 <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     62f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     633:	8b 45 f4             	mov    -0xc(%ebp),%eax
     636:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     63b:	76 a5                	jbe    5e2 <writetest1+0x5b>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     63d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     640:	89 04 24             	mov    %eax,(%esp)
     643:	e8 d0 38 00 00       	call   3f18 <close>

  fd = open("big", O_RDONLY);
     648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     64f:	00 
     650:	c7 04 24 10 47 00 00 	movl   $0x4710,(%esp)
     657:	e8 d4 38 00 00       	call   3f30 <open>
     65c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     65f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     663:	79 1a                	jns    67f <writetest1+0xf8>
    printf(stdout, "error: open big failed!\n");
     665:	a1 18 63 00 00       	mov    0x6318,%eax
     66a:	c7 44 24 04 4c 47 00 	movl   $0x474c,0x4(%esp)
     671:	00 
     672:	89 04 24             	mov    %eax,(%esp)
     675:	e8 ed 39 00 00       	call   4067 <printf>
    exit();
     67a:	e8 71 38 00 00       	call   3ef0 <exit>
  }

  n = 0;
     67f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     686:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     68d:	00 
     68e:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
     695:	00 
     696:	8b 45 ec             	mov    -0x14(%ebp),%eax
     699:	89 04 24             	mov    %eax,(%esp)
     69c:	e8 67 38 00 00       	call   3f08 <read>
     6a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6a8:	75 2e                	jne    6d8 <writetest1+0x151>
      if(n == MAXFILE - 1){
     6aa:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6b1:	0f 85 8c 00 00 00    	jne    743 <writetest1+0x1bc>
        printf(stdout, "read only %d blocks from big", n);
     6b7:	a1 18 63 00 00       	mov    0x6318,%eax
     6bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
     6bf:	89 54 24 08          	mov    %edx,0x8(%esp)
     6c3:	c7 44 24 04 65 47 00 	movl   $0x4765,0x4(%esp)
     6ca:	00 
     6cb:	89 04 24             	mov    %eax,(%esp)
     6ce:	e8 94 39 00 00       	call   4067 <printf>
        exit();
     6d3:	e8 18 38 00 00       	call   3ef0 <exit>
      }
      break;
    } else if(i != 512){
     6d8:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     6df:	74 21                	je     702 <writetest1+0x17b>
      printf(stdout, "read failed %d\n", i);
     6e1:	a1 18 63 00 00       	mov    0x6318,%eax
     6e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6e9:	89 54 24 08          	mov    %edx,0x8(%esp)
     6ed:	c7 44 24 04 82 47 00 	movl   $0x4782,0x4(%esp)
     6f4:	00 
     6f5:	89 04 24             	mov    %eax,(%esp)
     6f8:	e8 6a 39 00 00       	call   4067 <printf>
      exit();
     6fd:	e8 ee 37 00 00       	call   3ef0 <exit>
    }
    if(((int*)buf)[0] != n){
     702:	b8 00 8b 00 00       	mov    $0x8b00,%eax
     707:	8b 00                	mov    (%eax),%eax
     709:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     70c:	74 2c                	je     73a <writetest1+0x1b3>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     70e:	b8 00 8b 00 00       	mov    $0x8b00,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     713:	8b 10                	mov    (%eax),%edx
     715:	a1 18 63 00 00       	mov    0x6318,%eax
     71a:	89 54 24 0c          	mov    %edx,0xc(%esp)
     71e:	8b 55 f0             	mov    -0x10(%ebp),%edx
     721:	89 54 24 08          	mov    %edx,0x8(%esp)
     725:	c7 44 24 04 94 47 00 	movl   $0x4794,0x4(%esp)
     72c:	00 
     72d:	89 04 24             	mov    %eax,(%esp)
     730:	e8 32 39 00 00       	call   4067 <printf>
             n, ((int*)buf)[0]);
      exit();
     735:	e8 b6 37 00 00       	call   3ef0 <exit>
    }
    n++;
     73a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
     73e:	e9 43 ff ff ff       	jmp    686 <writetest1+0xff>
    if(i == 0){
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
     743:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     744:	8b 45 ec             	mov    -0x14(%ebp),%eax
     747:	89 04 24             	mov    %eax,(%esp)
     74a:	e8 c9 37 00 00       	call   3f18 <close>
  if(unlink("big") < 0){
     74f:	c7 04 24 10 47 00 00 	movl   $0x4710,(%esp)
     756:	e8 e5 37 00 00       	call   3f40 <unlink>
     75b:	85 c0                	test   %eax,%eax
     75d:	79 1a                	jns    779 <writetest1+0x1f2>
    printf(stdout, "unlink big failed\n");
     75f:	a1 18 63 00 00       	mov    0x6318,%eax
     764:	c7 44 24 04 b4 47 00 	movl   $0x47b4,0x4(%esp)
     76b:	00 
     76c:	89 04 24             	mov    %eax,(%esp)
     76f:	e8 f3 38 00 00       	call   4067 <printf>
    exit();
     774:	e8 77 37 00 00       	call   3ef0 <exit>
  }
  printf(stdout, "big files ok\n");
     779:	a1 18 63 00 00       	mov    0x6318,%eax
     77e:	c7 44 24 04 c7 47 00 	movl   $0x47c7,0x4(%esp)
     785:	00 
     786:	89 04 24             	mov    %eax,(%esp)
     789:	e8 d9 38 00 00       	call   4067 <printf>
}
     78e:	c9                   	leave  
     78f:	c3                   	ret    

00000790 <createtest>:

void
createtest(void)
{
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     796:	a1 18 63 00 00       	mov    0x6318,%eax
     79b:	c7 44 24 04 d8 47 00 	movl   $0x47d8,0x4(%esp)
     7a2:	00 
     7a3:	89 04 24             	mov    %eax,(%esp)
     7a6:	e8 bc 38 00 00       	call   4067 <printf>

  name[0] = 'a';
     7ab:	c6 05 00 ab 00 00 61 	movb   $0x61,0xab00
  name[2] = '\0';
     7b2:	c6 05 02 ab 00 00 00 	movb   $0x0,0xab02
  for(i = 0; i < 52; i++){
     7b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7c0:	eb 31                	jmp    7f3 <createtest+0x63>
    name[1] = '0' + i;
     7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c5:	83 c0 30             	add    $0x30,%eax
     7c8:	a2 01 ab 00 00       	mov    %al,0xab01
    fd = open(name, O_CREATE|O_RDWR);
     7cd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7d4:	00 
     7d5:	c7 04 24 00 ab 00 00 	movl   $0xab00,(%esp)
     7dc:	e8 4f 37 00 00       	call   3f30 <open>
     7e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     7e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7e7:	89 04 24             	mov    %eax,(%esp)
     7ea:	e8 29 37 00 00       	call   3f18 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     7ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7f3:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     7f7:	7e c9                	jle    7c2 <createtest+0x32>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     7f9:	c6 05 00 ab 00 00 61 	movb   $0x61,0xab00
  name[2] = '\0';
     800:	c6 05 02 ab 00 00 00 	movb   $0x0,0xab02
  for(i = 0; i < 52; i++){
     807:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     80e:	eb 1b                	jmp    82b <createtest+0x9b>
    name[1] = '0' + i;
     810:	8b 45 f4             	mov    -0xc(%ebp),%eax
     813:	83 c0 30             	add    $0x30,%eax
     816:	a2 01 ab 00 00       	mov    %al,0xab01
    unlink(name);
     81b:	c7 04 24 00 ab 00 00 	movl   $0xab00,(%esp)
     822:	e8 19 37 00 00       	call   3f40 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     827:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     82b:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     82f:	7e df                	jle    810 <createtest+0x80>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     831:	a1 18 63 00 00       	mov    0x6318,%eax
     836:	c7 44 24 04 00 48 00 	movl   $0x4800,0x4(%esp)
     83d:	00 
     83e:	89 04 24             	mov    %eax,(%esp)
     841:	e8 21 38 00 00       	call   4067 <printf>
}
     846:	c9                   	leave  
     847:	c3                   	ret    

00000848 <dirtest>:

void dirtest(void)
{
     848:	55                   	push   %ebp
     849:	89 e5                	mov    %esp,%ebp
     84b:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     84e:	a1 18 63 00 00       	mov    0x6318,%eax
     853:	c7 44 24 04 26 48 00 	movl   $0x4826,0x4(%esp)
     85a:	00 
     85b:	89 04 24             	mov    %eax,(%esp)
     85e:	e8 04 38 00 00       	call   4067 <printf>

  if(mkdir("dir0") < 0){
     863:	c7 04 24 32 48 00 00 	movl   $0x4832,(%esp)
     86a:	e8 e9 36 00 00       	call   3f58 <mkdir>
     86f:	85 c0                	test   %eax,%eax
     871:	79 1a                	jns    88d <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
     873:	a1 18 63 00 00       	mov    0x6318,%eax
     878:	c7 44 24 04 55 44 00 	movl   $0x4455,0x4(%esp)
     87f:	00 
     880:	89 04 24             	mov    %eax,(%esp)
     883:	e8 df 37 00 00       	call   4067 <printf>
    exit();
     888:	e8 63 36 00 00       	call   3ef0 <exit>
  }

  if(chdir("dir0") < 0){
     88d:	c7 04 24 32 48 00 00 	movl   $0x4832,(%esp)
     894:	e8 c7 36 00 00       	call   3f60 <chdir>
     899:	85 c0                	test   %eax,%eax
     89b:	79 1a                	jns    8b7 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
     89d:	a1 18 63 00 00       	mov    0x6318,%eax
     8a2:	c7 44 24 04 37 48 00 	movl   $0x4837,0x4(%esp)
     8a9:	00 
     8aa:	89 04 24             	mov    %eax,(%esp)
     8ad:	e8 b5 37 00 00       	call   4067 <printf>
    exit();
     8b2:	e8 39 36 00 00       	call   3ef0 <exit>
  }

  if(chdir("..") < 0){
     8b7:	c7 04 24 4a 48 00 00 	movl   $0x484a,(%esp)
     8be:	e8 9d 36 00 00       	call   3f60 <chdir>
     8c3:	85 c0                	test   %eax,%eax
     8c5:	79 1a                	jns    8e1 <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     8c7:	a1 18 63 00 00       	mov    0x6318,%eax
     8cc:	c7 44 24 04 4d 48 00 	movl   $0x484d,0x4(%esp)
     8d3:	00 
     8d4:	89 04 24             	mov    %eax,(%esp)
     8d7:	e8 8b 37 00 00       	call   4067 <printf>
    exit();
     8dc:	e8 0f 36 00 00       	call   3ef0 <exit>
  }

  if(unlink("dir0") < 0){
     8e1:	c7 04 24 32 48 00 00 	movl   $0x4832,(%esp)
     8e8:	e8 53 36 00 00       	call   3f40 <unlink>
     8ed:	85 c0                	test   %eax,%eax
     8ef:	79 1a                	jns    90b <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
     8f1:	a1 18 63 00 00       	mov    0x6318,%eax
     8f6:	c7 44 24 04 5e 48 00 	movl   $0x485e,0x4(%esp)
     8fd:	00 
     8fe:	89 04 24             	mov    %eax,(%esp)
     901:	e8 61 37 00 00       	call   4067 <printf>
    exit();
     906:	e8 e5 35 00 00       	call   3ef0 <exit>
  }
  printf(stdout, "mkdir test ok\n");
     90b:	a1 18 63 00 00       	mov    0x6318,%eax
     910:	c7 44 24 04 72 48 00 	movl   $0x4872,0x4(%esp)
     917:	00 
     918:	89 04 24             	mov    %eax,(%esp)
     91b:	e8 47 37 00 00       	call   4067 <printf>
}
     920:	c9                   	leave  
     921:	c3                   	ret    

00000922 <exectest>:

void
exectest(void)
{
     922:	55                   	push   %ebp
     923:	89 e5                	mov    %esp,%ebp
     925:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     928:	a1 18 63 00 00       	mov    0x6318,%eax
     92d:	c7 44 24 04 81 48 00 	movl   $0x4881,0x4(%esp)
     934:	00 
     935:	89 04 24             	mov    %eax,(%esp)
     938:	e8 2a 37 00 00       	call   4067 <printf>
  if(exec("echo", echoargv) < 0){
     93d:	c7 44 24 04 04 63 00 	movl   $0x6304,0x4(%esp)
     944:	00 
     945:	c7 04 24 2c 44 00 00 	movl   $0x442c,(%esp)
     94c:	e8 d7 35 00 00       	call   3f28 <exec>
     951:	85 c0                	test   %eax,%eax
     953:	79 1a                	jns    96f <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     955:	a1 18 63 00 00       	mov    0x6318,%eax
     95a:	c7 44 24 04 8c 48 00 	movl   $0x488c,0x4(%esp)
     961:	00 
     962:	89 04 24             	mov    %eax,(%esp)
     965:	e8 fd 36 00 00       	call   4067 <printf>
    exit();
     96a:	e8 81 35 00 00       	call   3ef0 <exit>
  }
}
     96f:	c9                   	leave  
     970:	c3                   	ret    

00000971 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     971:	55                   	push   %ebp
     972:	89 e5                	mov    %esp,%ebp
     974:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     977:	8d 45 d8             	lea    -0x28(%ebp),%eax
     97a:	89 04 24             	mov    %eax,(%esp)
     97d:	e8 7e 35 00 00       	call   3f00 <pipe>
     982:	85 c0                	test   %eax,%eax
     984:	74 19                	je     99f <pipe1+0x2e>
    printf(1, "pipe() failed\n");
     986:	c7 44 24 04 9e 48 00 	movl   $0x489e,0x4(%esp)
     98d:	00 
     98e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     995:	e8 cd 36 00 00       	call   4067 <printf>
    exit();
     99a:	e8 51 35 00 00       	call   3ef0 <exit>
  }
  pid = fork();
     99f:	e8 44 35 00 00       	call   3ee8 <fork>
     9a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     9ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     9b2:	0f 85 86 00 00 00    	jne    a3e <pipe1+0xcd>
    close(fds[0]);
     9b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
     9bb:	89 04 24             	mov    %eax,(%esp)
     9be:	e8 55 35 00 00       	call   3f18 <close>
    for(n = 0; n < 5; n++){
     9c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     9ca:	eb 67                	jmp    a33 <pipe1+0xc2>
      for(i = 0; i < 1033; i++)
     9cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     9d3:	eb 16                	jmp    9eb <pipe1+0x7a>
        buf[i] = seq++;
     9d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
     9db:	81 c2 00 8b 00 00    	add    $0x8b00,%edx
     9e1:	88 02                	mov    %al,(%edx)
     9e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     9e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     9eb:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     9f2:	7e e1                	jle    9d5 <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     9f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     9f7:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     9fe:	00 
     9ff:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
     a06:	00 
     a07:	89 04 24             	mov    %eax,(%esp)
     a0a:	e8 01 35 00 00       	call   3f10 <write>
     a0f:	3d 09 04 00 00       	cmp    $0x409,%eax
     a14:	74 19                	je     a2f <pipe1+0xbe>
        printf(1, "pipe1 oops 1\n");
     a16:	c7 44 24 04 ad 48 00 	movl   $0x48ad,0x4(%esp)
     a1d:	00 
     a1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a25:	e8 3d 36 00 00       	call   4067 <printf>
        exit();
     a2a:	e8 c1 34 00 00       	call   3ef0 <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a2f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a33:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a37:	7e 93                	jle    9cc <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a39:	e8 b2 34 00 00       	call   3ef0 <exit>
  } else if(pid > 0){
     a3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a42:	0f 8e fc 00 00 00    	jle    b44 <pipe1+0x1d3>
    close(fds[1]);
     a48:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a4b:	89 04 24             	mov    %eax,(%esp)
     a4e:	e8 c5 34 00 00       	call   3f18 <close>
    total = 0;
     a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     a5a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a61:	eb 6b                	jmp    ace <pipe1+0x15d>
      for(i = 0; i < n; i++){
     a63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a6a:	eb 40                	jmp    aac <pipe1+0x13b>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a6f:	05 00 8b 00 00       	add    $0x8b00,%eax
     a74:	0f b6 00             	movzbl (%eax),%eax
     a77:	0f be c0             	movsbl %al,%eax
     a7a:	33 45 f4             	xor    -0xc(%ebp),%eax
     a7d:	25 ff 00 00 00       	and    $0xff,%eax
     a82:	85 c0                	test   %eax,%eax
     a84:	0f 95 c0             	setne  %al
     a87:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a8b:	84 c0                	test   %al,%al
     a8d:	74 19                	je     aa8 <pipe1+0x137>
          printf(1, "pipe1 oops 2\n");
     a8f:	c7 44 24 04 bb 48 00 	movl   $0x48bb,0x4(%esp)
     a96:	00 
     a97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a9e:	e8 c4 35 00 00       	call   4067 <printf>
          return;
     aa3:	e9 b5 00 00 00       	jmp    b5d <pipe1+0x1ec>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     aa8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aaf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     ab2:	7c b8                	jl     a6c <pipe1+0xfb>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ab7:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     aba:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ac0:	3d 00 20 00 00       	cmp    $0x2000,%eax
     ac5:	76 07                	jbe    ace <pipe1+0x15d>
        cc = sizeof(buf);
     ac7:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     ace:	8b 45 d8             	mov    -0x28(%ebp),%eax
     ad1:	8b 55 e8             	mov    -0x18(%ebp),%edx
     ad4:	89 54 24 08          	mov    %edx,0x8(%esp)
     ad8:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
     adf:	00 
     ae0:	89 04 24             	mov    %eax,(%esp)
     ae3:	e8 20 34 00 00       	call   3f08 <read>
     ae8:	89 45 ec             	mov    %eax,-0x14(%ebp)
     aeb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     aef:	0f 8f 6e ff ff ff    	jg     a63 <pipe1+0xf2>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     af5:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     afc:	74 20                	je     b1e <pipe1+0x1ad>
      printf(1, "pipe1 oops 3 total %d\n", total);
     afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b01:	89 44 24 08          	mov    %eax,0x8(%esp)
     b05:	c7 44 24 04 c9 48 00 	movl   $0x48c9,0x4(%esp)
     b0c:	00 
     b0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b14:	e8 4e 35 00 00       	call   4067 <printf>
      exit();
     b19:	e8 d2 33 00 00       	call   3ef0 <exit>
    }
    close(fds[0]);
     b1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b21:	89 04 24             	mov    %eax,(%esp)
     b24:	e8 ef 33 00 00       	call   3f18 <close>
    wait();
     b29:	e8 ca 33 00 00       	call   3ef8 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b2e:	c7 44 24 04 e0 48 00 	movl   $0x48e0,0x4(%esp)
     b35:	00 
     b36:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b3d:	e8 25 35 00 00       	call   4067 <printf>
     b42:	eb 19                	jmp    b5d <pipe1+0x1ec>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b44:	c7 44 24 04 ea 48 00 	movl   $0x48ea,0x4(%esp)
     b4b:	00 
     b4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b53:	e8 0f 35 00 00       	call   4067 <printf>
    exit();
     b58:	e8 93 33 00 00       	call   3ef0 <exit>
  }
  printf(1, "pipe1 ok\n");
}
     b5d:	c9                   	leave  
     b5e:	c3                   	ret    

00000b5f <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     b5f:	55                   	push   %ebp
     b60:	89 e5                	mov    %esp,%ebp
     b62:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     b65:	c7 44 24 04 f9 48 00 	movl   $0x48f9,0x4(%esp)
     b6c:	00 
     b6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b74:	e8 ee 34 00 00       	call   4067 <printf>
  pid1 = fork();
     b79:	e8 6a 33 00 00       	call   3ee8 <fork>
     b7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     b81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b85:	75 02                	jne    b89 <preempt+0x2a>
    for(;;)
      ;
     b87:	eb fe                	jmp    b87 <preempt+0x28>

  pid2 = fork();
     b89:	e8 5a 33 00 00       	call   3ee8 <fork>
     b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     b91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b95:	75 02                	jne    b99 <preempt+0x3a>
    for(;;)
      ;
     b97:	eb fe                	jmp    b97 <preempt+0x38>

  pipe(pfds);
     b99:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b9c:	89 04 24             	mov    %eax,(%esp)
     b9f:	e8 5c 33 00 00       	call   3f00 <pipe>
  pid3 = fork();
     ba4:	e8 3f 33 00 00       	call   3ee8 <fork>
     ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bb0:	75 4c                	jne    bfe <preempt+0x9f>
    close(pfds[0]);
     bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bb5:	89 04 24             	mov    %eax,(%esp)
     bb8:	e8 5b 33 00 00       	call   3f18 <close>
    if(write(pfds[1], "x", 1) != 1)
     bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bc0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bc7:	00 
     bc8:	c7 44 24 04 03 49 00 	movl   $0x4903,0x4(%esp)
     bcf:	00 
     bd0:	89 04 24             	mov    %eax,(%esp)
     bd3:	e8 38 33 00 00       	call   3f10 <write>
     bd8:	83 f8 01             	cmp    $0x1,%eax
     bdb:	74 14                	je     bf1 <preempt+0x92>
      printf(1, "preempt write error");
     bdd:	c7 44 24 04 05 49 00 	movl   $0x4905,0x4(%esp)
     be4:	00 
     be5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bec:	e8 76 34 00 00       	call   4067 <printf>
    close(pfds[1]);
     bf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf4:	89 04 24             	mov    %eax,(%esp)
     bf7:	e8 1c 33 00 00       	call   3f18 <close>
    for(;;)
      ;
     bfc:	eb fe                	jmp    bfc <preempt+0x9d>
  }

  close(pfds[1]);
     bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c01:	89 04 24             	mov    %eax,(%esp)
     c04:	e8 0f 33 00 00       	call   3f18 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c0c:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     c13:	00 
     c14:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
     c1b:	00 
     c1c:	89 04 24             	mov    %eax,(%esp)
     c1f:	e8 e4 32 00 00       	call   3f08 <read>
     c24:	83 f8 01             	cmp    $0x1,%eax
     c27:	74 16                	je     c3f <preempt+0xe0>
    printf(1, "preempt read error");
     c29:	c7 44 24 04 19 49 00 	movl   $0x4919,0x4(%esp)
     c30:	00 
     c31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c38:	e8 2a 34 00 00       	call   4067 <printf>
    return;
     c3d:	eb 77                	jmp    cb6 <preempt+0x157>
  }
  close(pfds[0]);
     c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c42:	89 04 24             	mov    %eax,(%esp)
     c45:	e8 ce 32 00 00       	call   3f18 <close>
  printf(1, "kill... ");
     c4a:	c7 44 24 04 2c 49 00 	movl   $0x492c,0x4(%esp)
     c51:	00 
     c52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c59:	e8 09 34 00 00       	call   4067 <printf>
  kill(pid1);
     c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c61:	89 04 24             	mov    %eax,(%esp)
     c64:	e8 b7 32 00 00       	call   3f20 <kill>
  kill(pid2);
     c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6c:	89 04 24             	mov    %eax,(%esp)
     c6f:	e8 ac 32 00 00       	call   3f20 <kill>
  kill(pid3);
     c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c77:	89 04 24             	mov    %eax,(%esp)
     c7a:	e8 a1 32 00 00       	call   3f20 <kill>
  printf(1, "wait... ");
     c7f:	c7 44 24 04 35 49 00 	movl   $0x4935,0x4(%esp)
     c86:	00 
     c87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c8e:	e8 d4 33 00 00       	call   4067 <printf>
  wait();
     c93:	e8 60 32 00 00       	call   3ef8 <wait>
  wait();
     c98:	e8 5b 32 00 00       	call   3ef8 <wait>
  wait();
     c9d:	e8 56 32 00 00       	call   3ef8 <wait>
  printf(1, "preempt ok\n");
     ca2:	c7 44 24 04 3e 49 00 	movl   $0x493e,0x4(%esp)
     ca9:	00 
     caa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cb1:	e8 b1 33 00 00       	call   4067 <printf>
}
     cb6:	c9                   	leave  
     cb7:	c3                   	ret    

00000cb8 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     cb8:	55                   	push   %ebp
     cb9:	89 e5                	mov    %esp,%ebp
     cbb:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cc5:	eb 53                	jmp    d1a <exitwait+0x62>
    pid = fork();
     cc7:	e8 1c 32 00 00       	call   3ee8 <fork>
     ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     ccf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cd3:	79 16                	jns    ceb <exitwait+0x33>
      printf(1, "fork failed\n");
     cd5:	c7 44 24 04 cd 44 00 	movl   $0x44cd,0x4(%esp)
     cdc:	00 
     cdd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ce4:	e8 7e 33 00 00       	call   4067 <printf>
      return;
     ce9:	eb 49                	jmp    d34 <exitwait+0x7c>
    }
    if(pid){
     ceb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cef:	74 20                	je     d11 <exitwait+0x59>
      if(wait() != pid){
     cf1:	e8 02 32 00 00       	call   3ef8 <wait>
     cf6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     cf9:	74 1b                	je     d16 <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     cfb:	c7 44 24 04 4a 49 00 	movl   $0x494a,0x4(%esp)
     d02:	00 
     d03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d0a:	e8 58 33 00 00       	call   4067 <printf>
        return;
     d0f:	eb 23                	jmp    d34 <exitwait+0x7c>
      }
    } else {
      exit();
     d11:	e8 da 31 00 00       	call   3ef0 <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d16:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d1a:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d1e:	7e a7                	jle    cc7 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d20:	c7 44 24 04 5a 49 00 	movl   $0x495a,0x4(%esp)
     d27:	00 
     d28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d2f:	e8 33 33 00 00       	call   4067 <printf>
}
     d34:	c9                   	leave  
     d35:	c3                   	ret    

00000d36 <mem>:

void
mem(void)
{
     d36:	55                   	push   %ebp
     d37:	89 e5                	mov    %esp,%ebp
     d39:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d3c:	c7 44 24 04 67 49 00 	movl   $0x4967,0x4(%esp)
     d43:	00 
     d44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d4b:	e8 17 33 00 00       	call   4067 <printf>
  ppid = getpid();
     d50:	e8 1b 32 00 00       	call   3f70 <getpid>
     d55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     d58:	e8 8b 31 00 00       	call   3ee8 <fork>
     d5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d64:	0f 85 aa 00 00 00    	jne    e14 <mem+0xde>
    m1 = 0;
     d6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10000001)) != 0){
     d71:	eb 0e                	jmp    d81 <mem+0x4b>
      *(char**)m2 = m1;
     d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d79:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     d7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10000001)) != 0){
     d81:	c7 04 24 81 96 98 00 	movl   $0x989681,(%esp)
     d88:	e8 be 35 00 00       	call   434b <malloc>
     d8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
     d90:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d94:	75 dd                	jne    d73 <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     d96:	eb 19                	jmp    db1 <mem+0x7b>
      m2 = *(char**)m1;
     d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d9b:	8b 00                	mov    (%eax),%eax
     d9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     da3:	89 04 24             	mov    %eax,(%esp)
     da6:	e8 71 34 00 00       	call   421c <free>
      m1 = m2;
     dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10000001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     db5:	75 e1                	jne    d98 <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     db7:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     dbe:	e8 88 35 00 00       	call   434b <malloc>
     dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     dca:	75 24                	jne    df0 <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     dcc:	c7 44 24 04 71 49 00 	movl   $0x4971,0x4(%esp)
     dd3:	00 
     dd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ddb:	e8 87 32 00 00       	call   4067 <printf>
      kill(ppid);
     de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     de3:	89 04 24             	mov    %eax,(%esp)
     de6:	e8 35 31 00 00       	call   3f20 <kill>
      exit();
     deb:	e8 00 31 00 00       	call   3ef0 <exit>
    }
    free(m1);
     df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df3:	89 04 24             	mov    %eax,(%esp)
     df6:	e8 21 34 00 00       	call   421c <free>
    printf(1, "mem ok\n");
     dfb:	c7 44 24 04 8b 49 00 	movl   $0x498b,0x4(%esp)
     e02:	00 
     e03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e0a:	e8 58 32 00 00       	call   4067 <printf>
    exit();
     e0f:	e8 dc 30 00 00       	call   3ef0 <exit>
  } else {
    wait();
     e14:	e8 df 30 00 00       	call   3ef8 <wait>
  }
}
     e19:	c9                   	leave  
     e1a:	c3                   	ret    

00000e1b <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e1b:	55                   	push   %ebp
     e1c:	89 e5                	mov    %esp,%ebp
     e1e:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e21:	c7 44 24 04 93 49 00 	movl   $0x4993,0x4(%esp)
     e28:	00 
     e29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e30:	e8 32 32 00 00       	call   4067 <printf>

  unlink("sharedfd");
     e35:	c7 04 24 a2 49 00 00 	movl   $0x49a2,(%esp)
     e3c:	e8 ff 30 00 00       	call   3f40 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e41:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     e48:	00 
     e49:	c7 04 24 a2 49 00 00 	movl   $0x49a2,(%esp)
     e50:	e8 db 30 00 00       	call   3f30 <open>
     e55:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     e58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e5c:	79 19                	jns    e77 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
     e5e:	c7 44 24 04 ac 49 00 	movl   $0x49ac,0x4(%esp)
     e65:	00 
     e66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e6d:	e8 f5 31 00 00       	call   4067 <printf>
    return;
     e72:	e9 9c 01 00 00       	jmp    1013 <sharedfd+0x1f8>
  }
  pid = fork();
     e77:	e8 6c 30 00 00       	call   3ee8 <fork>
     e7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     e83:	75 07                	jne    e8c <sharedfd+0x71>
     e85:	b8 63 00 00 00       	mov    $0x63,%eax
     e8a:	eb 05                	jmp    e91 <sharedfd+0x76>
     e8c:	b8 70 00 00 00       	mov    $0x70,%eax
     e91:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     e98:	00 
     e99:	89 44 24 04          	mov    %eax,0x4(%esp)
     e9d:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ea0:	89 04 24             	mov    %eax,(%esp)
     ea3:	e8 a3 2e 00 00       	call   3d4b <memset>
  for(i = 0; i < 1000; i++){
     ea8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eaf:	eb 39                	jmp    eea <sharedfd+0xcf>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     eb1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     eb8:	00 
     eb9:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ebc:	89 44 24 04          	mov    %eax,0x4(%esp)
     ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ec3:	89 04 24             	mov    %eax,(%esp)
     ec6:	e8 45 30 00 00       	call   3f10 <write>
     ecb:	83 f8 0a             	cmp    $0xa,%eax
     ece:	74 16                	je     ee6 <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
     ed0:	c7 44 24 04 d8 49 00 	movl   $0x49d8,0x4(%esp)
     ed7:	00 
     ed8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     edf:	e8 83 31 00 00       	call   4067 <printf>
      break;
     ee4:	eb 0d                	jmp    ef3 <sharedfd+0xd8>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     ee6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     eea:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     ef1:	7e be                	jle    eb1 <sharedfd+0x96>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     ef3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ef7:	75 05                	jne    efe <sharedfd+0xe3>
    exit();
     ef9:	e8 f2 2f 00 00       	call   3ef0 <exit>
  else
    wait();
     efe:	e8 f5 2f 00 00       	call   3ef8 <wait>
  close(fd);
     f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f06:	89 04 24             	mov    %eax,(%esp)
     f09:	e8 0a 30 00 00       	call   3f18 <close>
  fd = open("sharedfd", 0);
     f0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     f15:	00 
     f16:	c7 04 24 a2 49 00 00 	movl   $0x49a2,(%esp)
     f1d:	e8 0e 30 00 00       	call   3f30 <open>
     f22:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f25:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f29:	79 19                	jns    f44 <sharedfd+0x129>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f2b:	c7 44 24 04 f8 49 00 	movl   $0x49f8,0x4(%esp)
     f32:	00 
     f33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f3a:	e8 28 31 00 00       	call   4067 <printf>
    return;
     f3f:	e9 cf 00 00 00       	jmp    1013 <sharedfd+0x1f8>
  }
  nc = np = 0;
     f44:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f51:	eb 37                	jmp    f8a <sharedfd+0x16f>
    for(i = 0; i < sizeof(buf); i++){
     f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f5a:	eb 26                	jmp    f82 <sharedfd+0x167>
      if(buf[i] == 'c')
     f5c:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f5f:	03 45 f4             	add    -0xc(%ebp),%eax
     f62:	0f b6 00             	movzbl (%eax),%eax
     f65:	3c 63                	cmp    $0x63,%al
     f67:	75 04                	jne    f6d <sharedfd+0x152>
        nc++;
     f69:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     f6d:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f70:	03 45 f4             	add    -0xc(%ebp),%eax
     f73:	0f b6 00             	movzbl (%eax),%eax
     f76:	3c 70                	cmp    $0x70,%al
     f78:	75 04                	jne    f7e <sharedfd+0x163>
        np++;
     f7a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     f7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f85:	83 f8 09             	cmp    $0x9,%eax
     f88:	76 d2                	jbe    f5c <sharedfd+0x141>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f8a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f91:	00 
     f92:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f95:	89 44 24 04          	mov    %eax,0x4(%esp)
     f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f9c:	89 04 24             	mov    %eax,(%esp)
     f9f:	e8 64 2f 00 00       	call   3f08 <read>
     fa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
     fa7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     fab:	7f a6                	jg     f53 <sharedfd+0x138>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fb0:	89 04 24             	mov    %eax,(%esp)
     fb3:	e8 60 2f 00 00       	call   3f18 <close>
  unlink("sharedfd");
     fb8:	c7 04 24 a2 49 00 00 	movl   $0x49a2,(%esp)
     fbf:	e8 7c 2f 00 00       	call   3f40 <unlink>
  if(nc == 10000 && np == 10000){
     fc4:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     fcb:	75 1f                	jne    fec <sharedfd+0x1d1>
     fcd:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     fd4:	75 16                	jne    fec <sharedfd+0x1d1>
    printf(1, "sharedfd ok\n");
     fd6:	c7 44 24 04 23 4a 00 	movl   $0x4a23,0x4(%esp)
     fdd:	00 
     fde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fe5:	e8 7d 30 00 00       	call   4067 <printf>
     fea:	eb 27                	jmp    1013 <sharedfd+0x1f8>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     fec:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fef:	89 44 24 0c          	mov    %eax,0xc(%esp)
     ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ff6:	89 44 24 08          	mov    %eax,0x8(%esp)
     ffa:	c7 44 24 04 30 4a 00 	movl   $0x4a30,0x4(%esp)
    1001:	00 
    1002:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1009:	e8 59 30 00 00       	call   4067 <printf>
    exit();
    100e:	e8 dd 2e 00 00       	call   3ef0 <exit>
  }
}
    1013:	c9                   	leave  
    1014:	c3                   	ret    

00001015 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1015:	55                   	push   %ebp
    1016:	89 e5                	mov    %esp,%ebp
    1018:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    101b:	c7 45 c8 45 4a 00 00 	movl   $0x4a45,-0x38(%ebp)
    1022:	c7 45 cc 48 4a 00 00 	movl   $0x4a48,-0x34(%ebp)
    1029:	c7 45 d0 4b 4a 00 00 	movl   $0x4a4b,-0x30(%ebp)
    1030:	c7 45 d4 4e 4a 00 00 	movl   $0x4a4e,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    1037:	c7 44 24 04 51 4a 00 	movl   $0x4a51,0x4(%esp)
    103e:	00 
    103f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1046:	e8 1c 30 00 00       	call   4067 <printf>

  for(pi = 0; pi < 4; pi++){
    104b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1052:	e9 fc 00 00 00       	jmp    1153 <fourfiles+0x13e>
    fname = names[pi];
    1057:	8b 45 e8             	mov    -0x18(%ebp),%eax
    105a:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    105e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    1061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1064:	89 04 24             	mov    %eax,(%esp)
    1067:	e8 d4 2e 00 00       	call   3f40 <unlink>

    pid = fork();
    106c:	e8 77 2e 00 00       	call   3ee8 <fork>
    1071:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(pid < 0){
    1074:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1078:	79 19                	jns    1093 <fourfiles+0x7e>
      printf(1, "fork failed\n");
    107a:	c7 44 24 04 cd 44 00 	movl   $0x44cd,0x4(%esp)
    1081:	00 
    1082:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1089:	e8 d9 2f 00 00       	call   4067 <printf>
      exit();
    108e:	e8 5d 2e 00 00       	call   3ef0 <exit>
    }

    if(pid == 0){
    1093:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1097:	0f 85 b2 00 00 00    	jne    114f <fourfiles+0x13a>
      fd = open(fname, O_CREATE | O_RDWR);
    109d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    10a4:	00 
    10a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10a8:	89 04 24             	mov    %eax,(%esp)
    10ab:	e8 80 2e 00 00       	call   3f30 <open>
    10b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
      if(fd < 0){
    10b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    10b7:	79 19                	jns    10d2 <fourfiles+0xbd>
        printf(1, "create failed\n");
    10b9:	c7 44 24 04 61 4a 00 	movl   $0x4a61,0x4(%esp)
    10c0:	00 
    10c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10c8:	e8 9a 2f 00 00       	call   4067 <printf>
        exit();
    10cd:	e8 1e 2e 00 00       	call   3ef0 <exit>
      }
      
      memset(buf, '0'+pi, 512);
    10d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10d5:	83 c0 30             	add    $0x30,%eax
    10d8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    10df:	00 
    10e0:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e4:	c7 04 24 00 8b 00 00 	movl   $0x8b00,(%esp)
    10eb:	e8 5b 2c 00 00       	call   3d4b <memset>
      for(i = 0; i < 12; i++){
    10f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10f7:	eb 4b                	jmp    1144 <fourfiles+0x12f>
        if((n = write(fd, buf, 500)) != 500){
    10f9:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    1100:	00 
    1101:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    1108:	00 
    1109:	8b 45 dc             	mov    -0x24(%ebp),%eax
    110c:	89 04 24             	mov    %eax,(%esp)
    110f:	e8 fc 2d 00 00       	call   3f10 <write>
    1114:	89 45 d8             	mov    %eax,-0x28(%ebp)
    1117:	81 7d d8 f4 01 00 00 	cmpl   $0x1f4,-0x28(%ebp)
    111e:	74 20                	je     1140 <fourfiles+0x12b>
          printf(1, "write failed %d\n", n);
    1120:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1123:	89 44 24 08          	mov    %eax,0x8(%esp)
    1127:	c7 44 24 04 70 4a 00 	movl   $0x4a70,0x4(%esp)
    112e:	00 
    112f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1136:	e8 2c 2f 00 00       	call   4067 <printf>
          exit();
    113b:	e8 b0 2d 00 00       	call   3ef0 <exit>
        printf(1, "create failed\n");
        exit();
      }
      
      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
    1140:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1144:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    1148:	7e af                	jle    10f9 <fourfiles+0xe4>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
    114a:	e8 a1 2d 00 00       	call   3ef0 <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    114f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1153:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    1157:	0f 8e fa fe ff ff    	jle    1057 <fourfiles+0x42>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    115d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1164:	eb 09                	jmp    116f <fourfiles+0x15a>
    wait();
    1166:	e8 8d 2d 00 00       	call   3ef8 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    116b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    116f:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    1173:	7e f1                	jle    1166 <fourfiles+0x151>
    wait();
  }

  for(i = 0; i < 2; i++){
    1175:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    117c:	e9 dc 00 00 00       	jmp    125d <fourfiles+0x248>
    fname = names[i];
    1181:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1184:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    1188:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    118b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1192:	00 
    1193:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1196:	89 04 24             	mov    %eax,(%esp)
    1199:	e8 92 2d 00 00       	call   3f30 <open>
    119e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    total = 0;
    11a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11a8:	eb 4c                	jmp    11f6 <fourfiles+0x1e1>
      for(j = 0; j < n; j++){
    11aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11b1:	eb 35                	jmp    11e8 <fourfiles+0x1d3>
        if(buf[j] != '0'+i){
    11b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11b6:	05 00 8b 00 00       	add    $0x8b00,%eax
    11bb:	0f b6 00             	movzbl (%eax),%eax
    11be:	0f be c0             	movsbl %al,%eax
    11c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11c4:	83 c2 30             	add    $0x30,%edx
    11c7:	39 d0                	cmp    %edx,%eax
    11c9:	74 19                	je     11e4 <fourfiles+0x1cf>
          printf(1, "wrong char\n");
    11cb:	c7 44 24 04 81 4a 00 	movl   $0x4a81,0x4(%esp)
    11d2:	00 
    11d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11da:	e8 88 2e 00 00       	call   4067 <printf>
          exit();
    11df:	e8 0c 2d 00 00       	call   3ef0 <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    11e4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    11e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11eb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    11ee:	7c c3                	jl     11b3 <fourfiles+0x19e>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    11f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
    11f3:	01 45 ec             	add    %eax,-0x14(%ebp)

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11f6:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    11fd:	00 
    11fe:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    1205:	00 
    1206:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1209:	89 04 24             	mov    %eax,(%esp)
    120c:	e8 f7 2c 00 00       	call   3f08 <read>
    1211:	89 45 d8             	mov    %eax,-0x28(%ebp)
    1214:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    1218:	7f 90                	jg     11aa <fourfiles+0x195>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    121a:	8b 45 dc             	mov    -0x24(%ebp),%eax
    121d:	89 04 24             	mov    %eax,(%esp)
    1220:	e8 f3 2c 00 00       	call   3f18 <close>
    if(total != 12*500){
    1225:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    122c:	74 20                	je     124e <fourfiles+0x239>
      printf(1, "wrong length %d\n", total);
    122e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1231:	89 44 24 08          	mov    %eax,0x8(%esp)
    1235:	c7 44 24 04 8d 4a 00 	movl   $0x4a8d,0x4(%esp)
    123c:	00 
    123d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1244:	e8 1e 2e 00 00       	call   4067 <printf>
      exit();
    1249:	e8 a2 2c 00 00       	call   3ef0 <exit>
    }
    unlink(fname);
    124e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1251:	89 04 24             	mov    %eax,(%esp)
    1254:	e8 e7 2c 00 00       	call   3f40 <unlink>

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    1259:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    125d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    1261:	0f 8e 1a ff ff ff    	jle    1181 <fourfiles+0x16c>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    1267:	c7 44 24 04 9e 4a 00 	movl   $0x4a9e,0x4(%esp)
    126e:	00 
    126f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1276:	e8 ec 2d 00 00       	call   4067 <printf>
}
    127b:	c9                   	leave  
    127c:	c3                   	ret    

0000127d <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    127d:	55                   	push   %ebp
    127e:	89 e5                	mov    %esp,%ebp
    1280:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    1283:	c7 44 24 04 ac 4a 00 	movl   $0x4aac,0x4(%esp)
    128a:	00 
    128b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1292:	e8 d0 2d 00 00       	call   4067 <printf>

  for(pi = 0; pi < 4; pi++){
    1297:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    129e:	e9 f4 00 00 00       	jmp    1397 <createdelete+0x11a>
    pid = fork();
    12a3:	e8 40 2c 00 00       	call   3ee8 <fork>
    12a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    12ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12af:	79 19                	jns    12ca <createdelete+0x4d>
      printf(1, "fork failed\n");
    12b1:	c7 44 24 04 cd 44 00 	movl   $0x44cd,0x4(%esp)
    12b8:	00 
    12b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c0:	e8 a2 2d 00 00       	call   4067 <printf>
      exit();
    12c5:	e8 26 2c 00 00       	call   3ef0 <exit>
    }

    if(pid == 0){
    12ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12ce:	0f 85 bf 00 00 00    	jne    1393 <createdelete+0x116>
      name[0] = 'p' + pi;
    12d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12d7:	83 c0 70             	add    $0x70,%eax
    12da:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    12dd:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    12e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12e8:	e9 97 00 00 00       	jmp    1384 <createdelete+0x107>
        name[1] = '0' + i;
    12ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f0:	83 c0 30             	add    $0x30,%eax
    12f3:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    12f6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    12fd:	00 
    12fe:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1301:	89 04 24             	mov    %eax,(%esp)
    1304:	e8 27 2c 00 00       	call   3f30 <open>
    1309:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    130c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1310:	79 19                	jns    132b <createdelete+0xae>
          printf(1, "create failed\n");
    1312:	c7 44 24 04 61 4a 00 	movl   $0x4a61,0x4(%esp)
    1319:	00 
    131a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1321:	e8 41 2d 00 00       	call   4067 <printf>
          exit();
    1326:	e8 c5 2b 00 00       	call   3ef0 <exit>
        }
        close(fd);
    132b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    132e:	89 04 24             	mov    %eax,(%esp)
    1331:	e8 e2 2b 00 00       	call   3f18 <close>
        if(i > 0 && (i % 2 ) == 0){
    1336:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    133a:	7e 44                	jle    1380 <createdelete+0x103>
    133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    133f:	83 e0 01             	and    $0x1,%eax
    1342:	85 c0                	test   %eax,%eax
    1344:	75 3a                	jne    1380 <createdelete+0x103>
          name[1] = '0' + (i / 2);
    1346:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1349:	89 c2                	mov    %eax,%edx
    134b:	c1 ea 1f             	shr    $0x1f,%edx
    134e:	01 d0                	add    %edx,%eax
    1350:	d1 f8                	sar    %eax
    1352:	83 c0 30             	add    $0x30,%eax
    1355:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1358:	8d 45 c8             	lea    -0x38(%ebp),%eax
    135b:	89 04 24             	mov    %eax,(%esp)
    135e:	e8 dd 2b 00 00       	call   3f40 <unlink>
    1363:	85 c0                	test   %eax,%eax
    1365:	79 19                	jns    1380 <createdelete+0x103>
            printf(1, "unlink failed\n");
    1367:	c7 44 24 04 50 45 00 	movl   $0x4550,0x4(%esp)
    136e:	00 
    136f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1376:	e8 ec 2c 00 00       	call   4067 <printf>
            exit();
    137b:	e8 70 2b 00 00       	call   3ef0 <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    1380:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1384:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1388:	0f 8e 5f ff ff ff    	jle    12ed <createdelete+0x70>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    138e:	e8 5d 2b 00 00       	call   3ef0 <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    1393:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1397:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    139b:	0f 8e 02 ff ff ff    	jle    12a3 <createdelete+0x26>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13a8:	eb 09                	jmp    13b3 <createdelete+0x136>
    wait();
    13aa:	e8 49 2b 00 00       	call   3ef8 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13af:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13b3:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13b7:	7e f1                	jle    13aa <createdelete+0x12d>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
    13b9:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13bd:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13c1:	88 45 c9             	mov    %al,-0x37(%ebp)
    13c4:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    13c8:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13d2:	e9 bb 00 00 00       	jmp    1492 <createdelete+0x215>
    for(pi = 0; pi < 4; pi++){
    13d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13de:	e9 a1 00 00 00       	jmp    1484 <createdelete+0x207>
      name[0] = 'p' + pi;
    13e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13e6:	83 c0 70             	add    $0x70,%eax
    13e9:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    13ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ef:	83 c0 30             	add    $0x30,%eax
    13f2:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    13f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13fc:	00 
    13fd:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1400:	89 04 24             	mov    %eax,(%esp)
    1403:	e8 28 2b 00 00       	call   3f30 <open>
    1408:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    140b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    140f:	74 06                	je     1417 <createdelete+0x19a>
    1411:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1415:	7e 26                	jle    143d <createdelete+0x1c0>
    1417:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    141b:	79 20                	jns    143d <createdelete+0x1c0>
        printf(1, "oops createdelete %s didn't exist\n", name);
    141d:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1420:	89 44 24 08          	mov    %eax,0x8(%esp)
    1424:	c7 44 24 04 c0 4a 00 	movl   $0x4ac0,0x4(%esp)
    142b:	00 
    142c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1433:	e8 2f 2c 00 00       	call   4067 <printf>
        exit();
    1438:	e8 b3 2a 00 00       	call   3ef0 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    143d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1441:	7e 2c                	jle    146f <createdelete+0x1f2>
    1443:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1447:	7f 26                	jg     146f <createdelete+0x1f2>
    1449:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    144d:	78 20                	js     146f <createdelete+0x1f2>
        printf(1, "oops createdelete %s did exist\n", name);
    144f:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1452:	89 44 24 08          	mov    %eax,0x8(%esp)
    1456:	c7 44 24 04 e4 4a 00 	movl   $0x4ae4,0x4(%esp)
    145d:	00 
    145e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1465:	e8 fd 2b 00 00       	call   4067 <printf>
        exit();
    146a:	e8 81 2a 00 00       	call   3ef0 <exit>
      }
      if(fd >= 0)
    146f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1473:	78 0b                	js     1480 <createdelete+0x203>
        close(fd);
    1475:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1478:	89 04 24             	mov    %eax,(%esp)
    147b:	e8 98 2a 00 00       	call   3f18 <close>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    1480:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1484:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1488:	0f 8e 55 ff ff ff    	jle    13e3 <createdelete+0x166>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    148e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1492:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1496:	0f 8e 3b ff ff ff    	jle    13d7 <createdelete+0x15a>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    149c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14a3:	eb 34                	jmp    14d9 <createdelete+0x25c>
    for(pi = 0; pi < 4; pi++){
    14a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14ac:	eb 21                	jmp    14cf <createdelete+0x252>
      name[0] = 'p' + i;
    14ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b1:	83 c0 70             	add    $0x70,%eax
    14b4:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ba:	83 c0 30             	add    $0x30,%eax
    14bd:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14c0:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14c3:	89 04 24             	mov    %eax,(%esp)
    14c6:	e8 75 2a 00 00       	call   3f40 <unlink>
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14cb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14cf:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14d3:	7e d9                	jle    14ae <createdelete+0x231>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14d9:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14dd:	7e c6                	jle    14a5 <createdelete+0x228>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    14df:	c7 44 24 04 04 4b 00 	movl   $0x4b04,0x4(%esp)
    14e6:	00 
    14e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14ee:	e8 74 2b 00 00       	call   4067 <printf>
}
    14f3:	c9                   	leave  
    14f4:	c3                   	ret    

000014f5 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    14f5:	55                   	push   %ebp
    14f6:	89 e5                	mov    %esp,%ebp
    14f8:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    14fb:	c7 44 24 04 15 4b 00 	movl   $0x4b15,0x4(%esp)
    1502:	00 
    1503:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    150a:	e8 58 2b 00 00       	call   4067 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    150f:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1516:	00 
    1517:	c7 04 24 26 4b 00 00 	movl   $0x4b26,(%esp)
    151e:	e8 0d 2a 00 00       	call   3f30 <open>
    1523:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    152a:	79 19                	jns    1545 <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    152c:	c7 44 24 04 31 4b 00 	movl   $0x4b31,0x4(%esp)
    1533:	00 
    1534:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    153b:	e8 27 2b 00 00       	call   4067 <printf>
    exit();
    1540:	e8 ab 29 00 00       	call   3ef0 <exit>
  }
  write(fd, "hello", 5);
    1545:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    154c:	00 
    154d:	c7 44 24 04 4b 4b 00 	movl   $0x4b4b,0x4(%esp)
    1554:	00 
    1555:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1558:	89 04 24             	mov    %eax,(%esp)
    155b:	e8 b0 29 00 00       	call   3f10 <write>
  close(fd);
    1560:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1563:	89 04 24             	mov    %eax,(%esp)
    1566:	e8 ad 29 00 00       	call   3f18 <close>

  fd = open("unlinkread", O_RDWR);
    156b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1572:	00 
    1573:	c7 04 24 26 4b 00 00 	movl   $0x4b26,(%esp)
    157a:	e8 b1 29 00 00       	call   3f30 <open>
    157f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1586:	79 19                	jns    15a1 <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    1588:	c7 44 24 04 51 4b 00 	movl   $0x4b51,0x4(%esp)
    158f:	00 
    1590:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1597:	e8 cb 2a 00 00       	call   4067 <printf>
    exit();
    159c:	e8 4f 29 00 00       	call   3ef0 <exit>
  }
  if(unlink("unlinkread") != 0){
    15a1:	c7 04 24 26 4b 00 00 	movl   $0x4b26,(%esp)
    15a8:	e8 93 29 00 00       	call   3f40 <unlink>
    15ad:	85 c0                	test   %eax,%eax
    15af:	74 19                	je     15ca <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    15b1:	c7 44 24 04 69 4b 00 	movl   $0x4b69,0x4(%esp)
    15b8:	00 
    15b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c0:	e8 a2 2a 00 00       	call   4067 <printf>
    exit();
    15c5:	e8 26 29 00 00       	call   3ef0 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15ca:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    15d1:	00 
    15d2:	c7 04 24 26 4b 00 00 	movl   $0x4b26,(%esp)
    15d9:	e8 52 29 00 00       	call   3f30 <open>
    15de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    15e1:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    15e8:	00 
    15e9:	c7 44 24 04 83 4b 00 	movl   $0x4b83,0x4(%esp)
    15f0:	00 
    15f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f4:	89 04 24             	mov    %eax,(%esp)
    15f7:	e8 14 29 00 00       	call   3f10 <write>
  close(fd1);
    15fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15ff:	89 04 24             	mov    %eax,(%esp)
    1602:	e8 11 29 00 00       	call   3f18 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    1607:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    160e:	00 
    160f:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    1616:	00 
    1617:	8b 45 f4             	mov    -0xc(%ebp),%eax
    161a:	89 04 24             	mov    %eax,(%esp)
    161d:	e8 e6 28 00 00       	call   3f08 <read>
    1622:	83 f8 05             	cmp    $0x5,%eax
    1625:	74 19                	je     1640 <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    1627:	c7 44 24 04 87 4b 00 	movl   $0x4b87,0x4(%esp)
    162e:	00 
    162f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1636:	e8 2c 2a 00 00       	call   4067 <printf>
    exit();
    163b:	e8 b0 28 00 00       	call   3ef0 <exit>
  }
  if(buf[0] != 'h'){
    1640:	0f b6 05 00 8b 00 00 	movzbl 0x8b00,%eax
    1647:	3c 68                	cmp    $0x68,%al
    1649:	74 19                	je     1664 <unlinkread+0x16f>
    printf(1, "unlinkread wrong data\n");
    164b:	c7 44 24 04 9e 4b 00 	movl   $0x4b9e,0x4(%esp)
    1652:	00 
    1653:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    165a:	e8 08 2a 00 00       	call   4067 <printf>
    exit();
    165f:	e8 8c 28 00 00       	call   3ef0 <exit>
  }
  if(write(fd, buf, 10) != 10){
    1664:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    166b:	00 
    166c:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    1673:	00 
    1674:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1677:	89 04 24             	mov    %eax,(%esp)
    167a:	e8 91 28 00 00       	call   3f10 <write>
    167f:	83 f8 0a             	cmp    $0xa,%eax
    1682:	74 19                	je     169d <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    1684:	c7 44 24 04 b5 4b 00 	movl   $0x4bb5,0x4(%esp)
    168b:	00 
    168c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1693:	e8 cf 29 00 00       	call   4067 <printf>
    exit();
    1698:	e8 53 28 00 00       	call   3ef0 <exit>
  }
  close(fd);
    169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16a0:	89 04 24             	mov    %eax,(%esp)
    16a3:	e8 70 28 00 00       	call   3f18 <close>
  unlink("unlinkread");
    16a8:	c7 04 24 26 4b 00 00 	movl   $0x4b26,(%esp)
    16af:	e8 8c 28 00 00       	call   3f40 <unlink>
  printf(1, "unlinkread ok\n");
    16b4:	c7 44 24 04 ce 4b 00 	movl   $0x4bce,0x4(%esp)
    16bb:	00 
    16bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16c3:	e8 9f 29 00 00       	call   4067 <printf>
}
    16c8:	c9                   	leave  
    16c9:	c3                   	ret    

000016ca <linktest>:

void
linktest(void)
{
    16ca:	55                   	push   %ebp
    16cb:	89 e5                	mov    %esp,%ebp
    16cd:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    16d0:	c7 44 24 04 dd 4b 00 	movl   $0x4bdd,0x4(%esp)
    16d7:	00 
    16d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16df:	e8 83 29 00 00       	call   4067 <printf>

  unlink("lf1");
    16e4:	c7 04 24 e7 4b 00 00 	movl   $0x4be7,(%esp)
    16eb:	e8 50 28 00 00       	call   3f40 <unlink>
  unlink("lf2");
    16f0:	c7 04 24 eb 4b 00 00 	movl   $0x4beb,(%esp)
    16f7:	e8 44 28 00 00       	call   3f40 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    16fc:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1703:	00 
    1704:	c7 04 24 e7 4b 00 00 	movl   $0x4be7,(%esp)
    170b:	e8 20 28 00 00       	call   3f30 <open>
    1710:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1713:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1717:	79 19                	jns    1732 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    1719:	c7 44 24 04 ef 4b 00 	movl   $0x4bef,0x4(%esp)
    1720:	00 
    1721:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1728:	e8 3a 29 00 00       	call   4067 <printf>
    exit();
    172d:	e8 be 27 00 00       	call   3ef0 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1732:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1739:	00 
    173a:	c7 44 24 04 4b 4b 00 	movl   $0x4b4b,0x4(%esp)
    1741:	00 
    1742:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1745:	89 04 24             	mov    %eax,(%esp)
    1748:	e8 c3 27 00 00       	call   3f10 <write>
    174d:	83 f8 05             	cmp    $0x5,%eax
    1750:	74 19                	je     176b <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    1752:	c7 44 24 04 02 4c 00 	movl   $0x4c02,0x4(%esp)
    1759:	00 
    175a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1761:	e8 01 29 00 00       	call   4067 <printf>
    exit();
    1766:	e8 85 27 00 00       	call   3ef0 <exit>
  }
  close(fd);
    176b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    176e:	89 04 24             	mov    %eax,(%esp)
    1771:	e8 a2 27 00 00       	call   3f18 <close>

  if(link("lf1", "lf2") < 0){
    1776:	c7 44 24 04 eb 4b 00 	movl   $0x4beb,0x4(%esp)
    177d:	00 
    177e:	c7 04 24 e7 4b 00 00 	movl   $0x4be7,(%esp)
    1785:	e8 c6 27 00 00       	call   3f50 <link>
    178a:	85 c0                	test   %eax,%eax
    178c:	79 19                	jns    17a7 <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    178e:	c7 44 24 04 14 4c 00 	movl   $0x4c14,0x4(%esp)
    1795:	00 
    1796:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    179d:	e8 c5 28 00 00       	call   4067 <printf>
    exit();
    17a2:	e8 49 27 00 00       	call   3ef0 <exit>
  }
  unlink("lf1");
    17a7:	c7 04 24 e7 4b 00 00 	movl   $0x4be7,(%esp)
    17ae:	e8 8d 27 00 00       	call   3f40 <unlink>

  if(open("lf1", 0) >= 0){
    17b3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17ba:	00 
    17bb:	c7 04 24 e7 4b 00 00 	movl   $0x4be7,(%esp)
    17c2:	e8 69 27 00 00       	call   3f30 <open>
    17c7:	85 c0                	test   %eax,%eax
    17c9:	78 19                	js     17e4 <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    17cb:	c7 44 24 04 2c 4c 00 	movl   $0x4c2c,0x4(%esp)
    17d2:	00 
    17d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17da:	e8 88 28 00 00       	call   4067 <printf>
    exit();
    17df:	e8 0c 27 00 00       	call   3ef0 <exit>
  }

  fd = open("lf2", 0);
    17e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17eb:	00 
    17ec:	c7 04 24 eb 4b 00 00 	movl   $0x4beb,(%esp)
    17f3:	e8 38 27 00 00       	call   3f30 <open>
    17f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    17fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17ff:	79 19                	jns    181a <linktest+0x150>
    printf(1, "open lf2 failed\n");
    1801:	c7 44 24 04 51 4c 00 	movl   $0x4c51,0x4(%esp)
    1808:	00 
    1809:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1810:	e8 52 28 00 00       	call   4067 <printf>
    exit();
    1815:	e8 d6 26 00 00       	call   3ef0 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    181a:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1821:	00 
    1822:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    1829:	00 
    182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    182d:	89 04 24             	mov    %eax,(%esp)
    1830:	e8 d3 26 00 00       	call   3f08 <read>
    1835:	83 f8 05             	cmp    $0x5,%eax
    1838:	74 19                	je     1853 <linktest+0x189>
    printf(1, "read lf2 failed\n");
    183a:	c7 44 24 04 62 4c 00 	movl   $0x4c62,0x4(%esp)
    1841:	00 
    1842:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1849:	e8 19 28 00 00       	call   4067 <printf>
    exit();
    184e:	e8 9d 26 00 00       	call   3ef0 <exit>
  }
  close(fd);
    1853:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1856:	89 04 24             	mov    %eax,(%esp)
    1859:	e8 ba 26 00 00       	call   3f18 <close>

  if(link("lf2", "lf2") >= 0){
    185e:	c7 44 24 04 eb 4b 00 	movl   $0x4beb,0x4(%esp)
    1865:	00 
    1866:	c7 04 24 eb 4b 00 00 	movl   $0x4beb,(%esp)
    186d:	e8 de 26 00 00       	call   3f50 <link>
    1872:	85 c0                	test   %eax,%eax
    1874:	78 19                	js     188f <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1876:	c7 44 24 04 73 4c 00 	movl   $0x4c73,0x4(%esp)
    187d:	00 
    187e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1885:	e8 dd 27 00 00       	call   4067 <printf>
    exit();
    188a:	e8 61 26 00 00       	call   3ef0 <exit>
  }

  unlink("lf2");
    188f:	c7 04 24 eb 4b 00 00 	movl   $0x4beb,(%esp)
    1896:	e8 a5 26 00 00       	call   3f40 <unlink>
  if(link("lf2", "lf1") >= 0){
    189b:	c7 44 24 04 e7 4b 00 	movl   $0x4be7,0x4(%esp)
    18a2:	00 
    18a3:	c7 04 24 eb 4b 00 00 	movl   $0x4beb,(%esp)
    18aa:	e8 a1 26 00 00       	call   3f50 <link>
    18af:	85 c0                	test   %eax,%eax
    18b1:	78 19                	js     18cc <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    18b3:	c7 44 24 04 94 4c 00 	movl   $0x4c94,0x4(%esp)
    18ba:	00 
    18bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18c2:	e8 a0 27 00 00       	call   4067 <printf>
    exit();
    18c7:	e8 24 26 00 00       	call   3ef0 <exit>
  }

  if(link(".", "lf1") >= 0){
    18cc:	c7 44 24 04 e7 4b 00 	movl   $0x4be7,0x4(%esp)
    18d3:	00 
    18d4:	c7 04 24 b7 4c 00 00 	movl   $0x4cb7,(%esp)
    18db:	e8 70 26 00 00       	call   3f50 <link>
    18e0:	85 c0                	test   %eax,%eax
    18e2:	78 19                	js     18fd <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    18e4:	c7 44 24 04 b9 4c 00 	movl   $0x4cb9,0x4(%esp)
    18eb:	00 
    18ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18f3:	e8 6f 27 00 00       	call   4067 <printf>
    exit();
    18f8:	e8 f3 25 00 00       	call   3ef0 <exit>
  }

  printf(1, "linktest ok\n");
    18fd:	c7 44 24 04 d5 4c 00 	movl   $0x4cd5,0x4(%esp)
    1904:	00 
    1905:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    190c:	e8 56 27 00 00       	call   4067 <printf>
}
    1911:	c9                   	leave  
    1912:	c3                   	ret    

00001913 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1913:	55                   	push   %ebp
    1914:	89 e5                	mov    %esp,%ebp
    1916:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1919:	c7 44 24 04 e2 4c 00 	movl   $0x4ce2,0x4(%esp)
    1920:	00 
    1921:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1928:	e8 3a 27 00 00       	call   4067 <printf>
  file[0] = 'C';
    192d:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1931:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1935:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    193c:	e9 f7 00 00 00       	jmp    1a38 <concreate+0x125>
    file[1] = '0' + i;
    1941:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1944:	83 c0 30             	add    $0x30,%eax
    1947:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    194a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    194d:	89 04 24             	mov    %eax,(%esp)
    1950:	e8 eb 25 00 00       	call   3f40 <unlink>
    pid = fork();
    1955:	e8 8e 25 00 00       	call   3ee8 <fork>
    195a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    195d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1961:	74 3a                	je     199d <concreate+0x8a>
    1963:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1966:	ba 56 55 55 55       	mov    $0x55555556,%edx
    196b:	89 c8                	mov    %ecx,%eax
    196d:	f7 ea                	imul   %edx
    196f:	89 c8                	mov    %ecx,%eax
    1971:	c1 f8 1f             	sar    $0x1f,%eax
    1974:	29 c2                	sub    %eax,%edx
    1976:	89 d0                	mov    %edx,%eax
    1978:	01 c0                	add    %eax,%eax
    197a:	01 d0                	add    %edx,%eax
    197c:	89 ca                	mov    %ecx,%edx
    197e:	29 c2                	sub    %eax,%edx
    1980:	83 fa 01             	cmp    $0x1,%edx
    1983:	75 18                	jne    199d <concreate+0x8a>
      link("C0", file);
    1985:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1988:	89 44 24 04          	mov    %eax,0x4(%esp)
    198c:	c7 04 24 f2 4c 00 00 	movl   $0x4cf2,(%esp)
    1993:	e8 b8 25 00 00       	call   3f50 <link>
    1998:	e9 87 00 00 00       	jmp    1a24 <concreate+0x111>
    } else if(pid == 0 && (i % 5) == 1){
    199d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19a1:	75 3a                	jne    19dd <concreate+0xca>
    19a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19a6:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19ab:	89 c8                	mov    %ecx,%eax
    19ad:	f7 ea                	imul   %edx
    19af:	d1 fa                	sar    %edx
    19b1:	89 c8                	mov    %ecx,%eax
    19b3:	c1 f8 1f             	sar    $0x1f,%eax
    19b6:	29 c2                	sub    %eax,%edx
    19b8:	89 d0                	mov    %edx,%eax
    19ba:	c1 e0 02             	shl    $0x2,%eax
    19bd:	01 d0                	add    %edx,%eax
    19bf:	89 ca                	mov    %ecx,%edx
    19c1:	29 c2                	sub    %eax,%edx
    19c3:	83 fa 01             	cmp    $0x1,%edx
    19c6:	75 15                	jne    19dd <concreate+0xca>
      link("C0", file);
    19c8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19cb:	89 44 24 04          	mov    %eax,0x4(%esp)
    19cf:	c7 04 24 f2 4c 00 00 	movl   $0x4cf2,(%esp)
    19d6:	e8 75 25 00 00       	call   3f50 <link>
    19db:	eb 47                	jmp    1a24 <concreate+0x111>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19dd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    19e4:	00 
    19e5:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19e8:	89 04 24             	mov    %eax,(%esp)
    19eb:	e8 40 25 00 00       	call   3f30 <open>
    19f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    19f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19f7:	79 20                	jns    1a19 <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    19f9:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19fc:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a00:	c7 44 24 04 f5 4c 00 	movl   $0x4cf5,0x4(%esp)
    1a07:	00 
    1a08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a0f:	e8 53 26 00 00       	call   4067 <printf>
        exit();
    1a14:	e8 d7 24 00 00       	call   3ef0 <exit>
      }
      close(fd);
    1a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1a1c:	89 04 24             	mov    %eax,(%esp)
    1a1f:	e8 f4 24 00 00       	call   3f18 <close>
    }
    if(pid == 0)
    1a24:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a28:	75 05                	jne    1a2f <concreate+0x11c>
      exit();
    1a2a:	e8 c1 24 00 00       	call   3ef0 <exit>
    else
      wait();
    1a2f:	e8 c4 24 00 00       	call   3ef8 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1a34:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a38:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a3c:	0f 8e ff fe ff ff    	jle    1941 <concreate+0x2e>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1a42:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    1a49:	00 
    1a4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a51:	00 
    1a52:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a55:	89 04 24             	mov    %eax,(%esp)
    1a58:	e8 ee 22 00 00       	call   3d4b <memset>
  fd = open(".", 0);
    1a5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a64:	00 
    1a65:	c7 04 24 b7 4c 00 00 	movl   $0x4cb7,(%esp)
    1a6c:	e8 bf 24 00 00       	call   3f30 <open>
    1a71:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1a74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a7b:	e9 9f 00 00 00       	jmp    1b1f <concreate+0x20c>
    if(de.inum == 0)
    1a80:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a84:	66 85 c0             	test   %ax,%ax
    1a87:	0f 84 91 00 00 00    	je     1b1e <concreate+0x20b>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a8d:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1a91:	3c 43                	cmp    $0x43,%al
    1a93:	0f 85 86 00 00 00    	jne    1b1f <concreate+0x20c>
    1a99:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1a9d:	84 c0                	test   %al,%al
    1a9f:	75 7e                	jne    1b1f <concreate+0x20c>
      i = de.name[1] - '0';
    1aa1:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1aa5:	0f be c0             	movsbl %al,%eax
    1aa8:	83 e8 30             	sub    $0x30,%eax
    1aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1aae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ab2:	78 08                	js     1abc <concreate+0x1a9>
    1ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab7:	83 f8 27             	cmp    $0x27,%eax
    1aba:	76 23                	jbe    1adf <concreate+0x1cc>
        printf(1, "concreate weird file %s\n", de.name);
    1abc:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1abf:	83 c0 02             	add    $0x2,%eax
    1ac2:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ac6:	c7 44 24 04 11 4d 00 	movl   $0x4d11,0x4(%esp)
    1acd:	00 
    1ace:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ad5:	e8 8d 25 00 00       	call   4067 <printf>
        exit();
    1ada:	e8 11 24 00 00       	call   3ef0 <exit>
      }
      if(fa[i]){
    1adf:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1ae2:	03 45 f4             	add    -0xc(%ebp),%eax
    1ae5:	0f b6 00             	movzbl (%eax),%eax
    1ae8:	84 c0                	test   %al,%al
    1aea:	74 23                	je     1b0f <concreate+0x1fc>
        printf(1, "concreate duplicate file %s\n", de.name);
    1aec:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1aef:	83 c0 02             	add    $0x2,%eax
    1af2:	89 44 24 08          	mov    %eax,0x8(%esp)
    1af6:	c7 44 24 04 2a 4d 00 	movl   $0x4d2a,0x4(%esp)
    1afd:	00 
    1afe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b05:	e8 5d 25 00 00       	call   4067 <printf>
        exit();
    1b0a:	e8 e1 23 00 00       	call   3ef0 <exit>
      }
      fa[i] = 1;
    1b0f:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1b12:	03 45 f4             	add    -0xc(%ebp),%eax
    1b15:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b18:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1b1c:	eb 01                	jmp    1b1f <concreate+0x20c>
  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    1b1e:	90                   	nop
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1b1f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1b26:	00 
    1b27:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
    1b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b31:	89 04 24             	mov    %eax,(%esp)
    1b34:	e8 cf 23 00 00       	call   3f08 <read>
    1b39:	85 c0                	test   %eax,%eax
    1b3b:	0f 8f 3f ff ff ff    	jg     1a80 <concreate+0x16d>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b44:	89 04 24             	mov    %eax,(%esp)
    1b47:	e8 cc 23 00 00       	call   3f18 <close>

  if(n != 40){
    1b4c:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b50:	74 19                	je     1b6b <concreate+0x258>
    printf(1, "concreate not enough files in directory listing\n");
    1b52:	c7 44 24 04 48 4d 00 	movl   $0x4d48,0x4(%esp)
    1b59:	00 
    1b5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b61:	e8 01 25 00 00       	call   4067 <printf>
    exit();
    1b66:	e8 85 23 00 00       	call   3ef0 <exit>
  }

  for(i = 0; i < 40; i++){
    1b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b72:	e9 2d 01 00 00       	jmp    1ca4 <concreate+0x391>
    file[1] = '0' + i;
    1b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b7a:	83 c0 30             	add    $0x30,%eax
    1b7d:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b80:	e8 63 23 00 00       	call   3ee8 <fork>
    1b85:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1b88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b8c:	79 19                	jns    1ba7 <concreate+0x294>
      printf(1, "fork failed\n");
    1b8e:	c7 44 24 04 cd 44 00 	movl   $0x44cd,0x4(%esp)
    1b95:	00 
    1b96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b9d:	e8 c5 24 00 00       	call   4067 <printf>
      exit();
    1ba2:	e8 49 23 00 00       	call   3ef0 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1ba7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1baa:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1baf:	89 c8                	mov    %ecx,%eax
    1bb1:	f7 ea                	imul   %edx
    1bb3:	89 c8                	mov    %ecx,%eax
    1bb5:	c1 f8 1f             	sar    $0x1f,%eax
    1bb8:	29 c2                	sub    %eax,%edx
    1bba:	89 d0                	mov    %edx,%eax
    1bbc:	01 c0                	add    %eax,%eax
    1bbe:	01 d0                	add    %edx,%eax
    1bc0:	89 ca                	mov    %ecx,%edx
    1bc2:	29 c2                	sub    %eax,%edx
    1bc4:	85 d2                	test   %edx,%edx
    1bc6:	75 06                	jne    1bce <concreate+0x2bb>
    1bc8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bcc:	74 28                	je     1bf6 <concreate+0x2e3>
       ((i % 3) == 1 && pid != 0)){
    1bce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bd1:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bd6:	89 c8                	mov    %ecx,%eax
    1bd8:	f7 ea                	imul   %edx
    1bda:	89 c8                	mov    %ecx,%eax
    1bdc:	c1 f8 1f             	sar    $0x1f,%eax
    1bdf:	29 c2                	sub    %eax,%edx
    1be1:	89 d0                	mov    %edx,%eax
    1be3:	01 c0                	add    %eax,%eax
    1be5:	01 d0                	add    %edx,%eax
    1be7:	89 ca                	mov    %ecx,%edx
    1be9:	29 c2                	sub    %eax,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1beb:	83 fa 01             	cmp    $0x1,%edx
    1bee:	75 74                	jne    1c64 <concreate+0x351>
       ((i % 3) == 1 && pid != 0)){
    1bf0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bf4:	74 6e                	je     1c64 <concreate+0x351>
      close(open(file, 0));
    1bf6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1bfd:	00 
    1bfe:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c01:	89 04 24             	mov    %eax,(%esp)
    1c04:	e8 27 23 00 00       	call   3f30 <open>
    1c09:	89 04 24             	mov    %eax,(%esp)
    1c0c:	e8 07 23 00 00       	call   3f18 <close>
      close(open(file, 0));
    1c11:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c18:	00 
    1c19:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c1c:	89 04 24             	mov    %eax,(%esp)
    1c1f:	e8 0c 23 00 00       	call   3f30 <open>
    1c24:	89 04 24             	mov    %eax,(%esp)
    1c27:	e8 ec 22 00 00       	call   3f18 <close>
      close(open(file, 0));
    1c2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c33:	00 
    1c34:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c37:	89 04 24             	mov    %eax,(%esp)
    1c3a:	e8 f1 22 00 00       	call   3f30 <open>
    1c3f:	89 04 24             	mov    %eax,(%esp)
    1c42:	e8 d1 22 00 00       	call   3f18 <close>
      close(open(file, 0));
    1c47:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c4e:	00 
    1c4f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c52:	89 04 24             	mov    %eax,(%esp)
    1c55:	e8 d6 22 00 00       	call   3f30 <open>
    1c5a:	89 04 24             	mov    %eax,(%esp)
    1c5d:	e8 b6 22 00 00       	call   3f18 <close>
    1c62:	eb 2c                	jmp    1c90 <concreate+0x37d>
    } else {
      unlink(file);
    1c64:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c67:	89 04 24             	mov    %eax,(%esp)
    1c6a:	e8 d1 22 00 00       	call   3f40 <unlink>
      unlink(file);
    1c6f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c72:	89 04 24             	mov    %eax,(%esp)
    1c75:	e8 c6 22 00 00       	call   3f40 <unlink>
      unlink(file);
    1c7a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c7d:	89 04 24             	mov    %eax,(%esp)
    1c80:	e8 bb 22 00 00       	call   3f40 <unlink>
      unlink(file);
    1c85:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c88:	89 04 24             	mov    %eax,(%esp)
    1c8b:	e8 b0 22 00 00       	call   3f40 <unlink>
    }
    if(pid == 0)
    1c90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c94:	75 05                	jne    1c9b <concreate+0x388>
      exit();
    1c96:	e8 55 22 00 00       	call   3ef0 <exit>
    else
      wait();
    1c9b:	e8 58 22 00 00       	call   3ef8 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1ca0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ca4:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1ca8:	0f 8e c9 fe ff ff    	jle    1b77 <concreate+0x264>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1cae:	c7 44 24 04 79 4d 00 	movl   $0x4d79,0x4(%esp)
    1cb5:	00 
    1cb6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cbd:	e8 a5 23 00 00       	call   4067 <printf>
}
    1cc2:	c9                   	leave  
    1cc3:	c3                   	ret    

00001cc4 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1cc4:	55                   	push   %ebp
    1cc5:	89 e5                	mov    %esp,%ebp
    1cc7:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1cca:	c7 44 24 04 87 4d 00 	movl   $0x4d87,0x4(%esp)
    1cd1:	00 
    1cd2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cd9:	e8 89 23 00 00       	call   4067 <printf>

  unlink("x");
    1cde:	c7 04 24 03 49 00 00 	movl   $0x4903,(%esp)
    1ce5:	e8 56 22 00 00       	call   3f40 <unlink>
  pid = fork();
    1cea:	e8 f9 21 00 00       	call   3ee8 <fork>
    1cef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1cf2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1cf6:	79 19                	jns    1d11 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1cf8:	c7 44 24 04 cd 44 00 	movl   $0x44cd,0x4(%esp)
    1cff:	00 
    1d00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d07:	e8 5b 23 00 00       	call   4067 <printf>
    exit();
    1d0c:	e8 df 21 00 00       	call   3ef0 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d11:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d15:	74 07                	je     1d1e <linkunlink+0x5a>
    1d17:	b8 01 00 00 00       	mov    $0x1,%eax
    1d1c:	eb 05                	jmp    1d23 <linkunlink+0x5f>
    1d1e:	b8 61 00 00 00       	mov    $0x61,%eax
    1d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d2d:	e9 8e 00 00 00       	jmp    1dc0 <linkunlink+0xfc>
    x = x * 1103515245 + 12345;
    1d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d35:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d3b:	05 39 30 00 00       	add    $0x3039,%eax
    1d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d43:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d46:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d4b:	89 c8                	mov    %ecx,%eax
    1d4d:	f7 e2                	mul    %edx
    1d4f:	d1 ea                	shr    %edx
    1d51:	89 d0                	mov    %edx,%eax
    1d53:	01 c0                	add    %eax,%eax
    1d55:	01 d0                	add    %edx,%eax
    1d57:	89 ca                	mov    %ecx,%edx
    1d59:	29 c2                	sub    %eax,%edx
    1d5b:	85 d2                	test   %edx,%edx
    1d5d:	75 1e                	jne    1d7d <linkunlink+0xb9>
      close(open("x", O_RDWR | O_CREATE));
    1d5f:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d66:	00 
    1d67:	c7 04 24 03 49 00 00 	movl   $0x4903,(%esp)
    1d6e:	e8 bd 21 00 00       	call   3f30 <open>
    1d73:	89 04 24             	mov    %eax,(%esp)
    1d76:	e8 9d 21 00 00       	call   3f18 <close>
    1d7b:	eb 3f                	jmp    1dbc <linkunlink+0xf8>
    } else if((x % 3) == 1){
    1d7d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d80:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d85:	89 c8                	mov    %ecx,%eax
    1d87:	f7 e2                	mul    %edx
    1d89:	d1 ea                	shr    %edx
    1d8b:	89 d0                	mov    %edx,%eax
    1d8d:	01 c0                	add    %eax,%eax
    1d8f:	01 d0                	add    %edx,%eax
    1d91:	89 ca                	mov    %ecx,%edx
    1d93:	29 c2                	sub    %eax,%edx
    1d95:	83 fa 01             	cmp    $0x1,%edx
    1d98:	75 16                	jne    1db0 <linkunlink+0xec>
      link("cat", "x");
    1d9a:	c7 44 24 04 03 49 00 	movl   $0x4903,0x4(%esp)
    1da1:	00 
    1da2:	c7 04 24 98 4d 00 00 	movl   $0x4d98,(%esp)
    1da9:	e8 a2 21 00 00       	call   3f50 <link>
    1dae:	eb 0c                	jmp    1dbc <linkunlink+0xf8>
    } else {
      unlink("x");
    1db0:	c7 04 24 03 49 00 00 	movl   $0x4903,(%esp)
    1db7:	e8 84 21 00 00       	call   3f40 <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1dbc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1dc0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1dc4:	0f 8e 68 ff ff ff    	jle    1d32 <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1dca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1dce:	74 1b                	je     1deb <linkunlink+0x127>
    wait();
    1dd0:	e8 23 21 00 00       	call   3ef8 <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
    1dd5:	c7 44 24 04 9c 4d 00 	movl   $0x4d9c,0x4(%esp)
    1ddc:	00 
    1ddd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1de4:	e8 7e 22 00 00       	call   4067 <printf>
}
    1de9:	c9                   	leave  
    1dea:	c3                   	ret    
  }

  if(pid)
    wait();
  else 
    exit();
    1deb:	e8 00 21 00 00       	call   3ef0 <exit>

00001df0 <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(void)
{
    1df0:	55                   	push   %ebp
    1df1:	89 e5                	mov    %esp,%ebp
    1df3:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1df6:	c7 44 24 04 ab 4d 00 	movl   $0x4dab,0x4(%esp)
    1dfd:	00 
    1dfe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e05:	e8 5d 22 00 00       	call   4067 <printf>
  unlink("bd");
    1e0a:	c7 04 24 b8 4d 00 00 	movl   $0x4db8,(%esp)
    1e11:	e8 2a 21 00 00       	call   3f40 <unlink>

  fd = open("bd", O_CREATE);
    1e16:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1e1d:	00 
    1e1e:	c7 04 24 b8 4d 00 00 	movl   $0x4db8,(%esp)
    1e25:	e8 06 21 00 00       	call   3f30 <open>
    1e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e31:	79 19                	jns    1e4c <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    1e33:	c7 44 24 04 bb 4d 00 	movl   $0x4dbb,0x4(%esp)
    1e3a:	00 
    1e3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e42:	e8 20 22 00 00       	call   4067 <printf>
    exit();
    1e47:	e8 a4 20 00 00       	call   3ef0 <exit>
  }
  close(fd);
    1e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e4f:	89 04 24             	mov    %eax,(%esp)
    1e52:	e8 c1 20 00 00       	call   3f18 <close>

  for(i = 0; i < 500; i++){
    1e57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e5e:	eb 68                	jmp    1ec8 <bigdir+0xd8>
    name[0] = 'x';
    1e60:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e67:	8d 50 3f             	lea    0x3f(%eax),%edx
    1e6a:	85 c0                	test   %eax,%eax
    1e6c:	0f 48 c2             	cmovs  %edx,%eax
    1e6f:	c1 f8 06             	sar    $0x6,%eax
    1e72:	83 c0 30             	add    $0x30,%eax
    1e75:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e7b:	89 c2                	mov    %eax,%edx
    1e7d:	c1 fa 1f             	sar    $0x1f,%edx
    1e80:	c1 ea 1a             	shr    $0x1a,%edx
    1e83:	01 d0                	add    %edx,%eax
    1e85:	83 e0 3f             	and    $0x3f,%eax
    1e88:	29 d0                	sub    %edx,%eax
    1e8a:	83 c0 30             	add    $0x30,%eax
    1e8d:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1e90:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1e94:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1e97:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e9b:	c7 04 24 b8 4d 00 00 	movl   $0x4db8,(%esp)
    1ea2:	e8 a9 20 00 00       	call   3f50 <link>
    1ea7:	85 c0                	test   %eax,%eax
    1ea9:	74 19                	je     1ec4 <bigdir+0xd4>
      printf(1, "bigdir link failed\n");
    1eab:	c7 44 24 04 d1 4d 00 	movl   $0x4dd1,0x4(%esp)
    1eb2:	00 
    1eb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eba:	e8 a8 21 00 00       	call   4067 <printf>
      exit();
    1ebf:	e8 2c 20 00 00       	call   3ef0 <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1ec4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ec8:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ecf:	7e 8f                	jle    1e60 <bigdir+0x70>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1ed1:	c7 04 24 b8 4d 00 00 	movl   $0x4db8,(%esp)
    1ed8:	e8 63 20 00 00       	call   3f40 <unlink>
  for(i = 0; i < 500; i++){
    1edd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1ee4:	eb 60                	jmp    1f46 <bigdir+0x156>
    name[0] = 'x';
    1ee6:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1eed:	8d 50 3f             	lea    0x3f(%eax),%edx
    1ef0:	85 c0                	test   %eax,%eax
    1ef2:	0f 48 c2             	cmovs  %edx,%eax
    1ef5:	c1 f8 06             	sar    $0x6,%eax
    1ef8:	83 c0 30             	add    $0x30,%eax
    1efb:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f01:	89 c2                	mov    %eax,%edx
    1f03:	c1 fa 1f             	sar    $0x1f,%edx
    1f06:	c1 ea 1a             	shr    $0x1a,%edx
    1f09:	01 d0                	add    %edx,%eax
    1f0b:	83 e0 3f             	and    $0x3f,%eax
    1f0e:	29 d0                	sub    %edx,%eax
    1f10:	83 c0 30             	add    $0x30,%eax
    1f13:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f16:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f1a:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f1d:	89 04 24             	mov    %eax,(%esp)
    1f20:	e8 1b 20 00 00       	call   3f40 <unlink>
    1f25:	85 c0                	test   %eax,%eax
    1f27:	74 19                	je     1f42 <bigdir+0x152>
      printf(1, "bigdir unlink failed");
    1f29:	c7 44 24 04 e5 4d 00 	movl   $0x4de5,0x4(%esp)
    1f30:	00 
    1f31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f38:	e8 2a 21 00 00       	call   4067 <printf>
      exit();
    1f3d:	e8 ae 1f 00 00       	call   3ef0 <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1f42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f46:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f4d:	7e 97                	jle    1ee6 <bigdir+0xf6>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1f4f:	c7 44 24 04 fa 4d 00 	movl   $0x4dfa,0x4(%esp)
    1f56:	00 
    1f57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f5e:	e8 04 21 00 00       	call   4067 <printf>
}
    1f63:	c9                   	leave  
    1f64:	c3                   	ret    

00001f65 <subdir>:

void
subdir(void)
{
    1f65:	55                   	push   %ebp
    1f66:	89 e5                	mov    %esp,%ebp
    1f68:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f6b:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
    1f72:	00 
    1f73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f7a:	e8 e8 20 00 00       	call   4067 <printf>

  unlink("ff");
    1f7f:	c7 04 24 12 4e 00 00 	movl   $0x4e12,(%esp)
    1f86:	e8 b5 1f 00 00       	call   3f40 <unlink>
  if(mkdir("dd") != 0){
    1f8b:	c7 04 24 15 4e 00 00 	movl   $0x4e15,(%esp)
    1f92:	e8 c1 1f 00 00       	call   3f58 <mkdir>
    1f97:	85 c0                	test   %eax,%eax
    1f99:	74 19                	je     1fb4 <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    1f9b:	c7 44 24 04 18 4e 00 	movl   $0x4e18,0x4(%esp)
    1fa2:	00 
    1fa3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1faa:	e8 b8 20 00 00       	call   4067 <printf>
    exit();
    1faf:	e8 3c 1f 00 00       	call   3ef0 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fb4:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1fbb:	00 
    1fbc:	c7 04 24 30 4e 00 00 	movl   $0x4e30,(%esp)
    1fc3:	e8 68 1f 00 00       	call   3f30 <open>
    1fc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1fcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1fcf:	79 19                	jns    1fea <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    1fd1:	c7 44 24 04 36 4e 00 	movl   $0x4e36,0x4(%esp)
    1fd8:	00 
    1fd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fe0:	e8 82 20 00 00       	call   4067 <printf>
    exit();
    1fe5:	e8 06 1f 00 00       	call   3ef0 <exit>
  }
  write(fd, "ff", 2);
    1fea:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1ff1:	00 
    1ff2:	c7 44 24 04 12 4e 00 	movl   $0x4e12,0x4(%esp)
    1ff9:	00 
    1ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ffd:	89 04 24             	mov    %eax,(%esp)
    2000:	e8 0b 1f 00 00       	call   3f10 <write>
  close(fd);
    2005:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2008:	89 04 24             	mov    %eax,(%esp)
    200b:	e8 08 1f 00 00       	call   3f18 <close>
  
  if(unlink("dd") >= 0){
    2010:	c7 04 24 15 4e 00 00 	movl   $0x4e15,(%esp)
    2017:	e8 24 1f 00 00       	call   3f40 <unlink>
    201c:	85 c0                	test   %eax,%eax
    201e:	78 19                	js     2039 <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2020:	c7 44 24 04 4c 4e 00 	movl   $0x4e4c,0x4(%esp)
    2027:	00 
    2028:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    202f:	e8 33 20 00 00       	call   4067 <printf>
    exit();
    2034:	e8 b7 1e 00 00       	call   3ef0 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2039:	c7 04 24 72 4e 00 00 	movl   $0x4e72,(%esp)
    2040:	e8 13 1f 00 00       	call   3f58 <mkdir>
    2045:	85 c0                	test   %eax,%eax
    2047:	74 19                	je     2062 <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    2049:	c7 44 24 04 79 4e 00 	movl   $0x4e79,0x4(%esp)
    2050:	00 
    2051:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2058:	e8 0a 20 00 00       	call   4067 <printf>
    exit();
    205d:	e8 8e 1e 00 00       	call   3ef0 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2062:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2069:	00 
    206a:	c7 04 24 94 4e 00 00 	movl   $0x4e94,(%esp)
    2071:	e8 ba 1e 00 00       	call   3f30 <open>
    2076:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    207d:	79 19                	jns    2098 <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    207f:	c7 44 24 04 9d 4e 00 	movl   $0x4e9d,0x4(%esp)
    2086:	00 
    2087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    208e:	e8 d4 1f 00 00       	call   4067 <printf>
    exit();
    2093:	e8 58 1e 00 00       	call   3ef0 <exit>
  }
  write(fd, "FF", 2);
    2098:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    209f:	00 
    20a0:	c7 44 24 04 b5 4e 00 	movl   $0x4eb5,0x4(%esp)
    20a7:	00 
    20a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20ab:	89 04 24             	mov    %eax,(%esp)
    20ae:	e8 5d 1e 00 00       	call   3f10 <write>
  close(fd);
    20b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20b6:	89 04 24             	mov    %eax,(%esp)
    20b9:	e8 5a 1e 00 00       	call   3f18 <close>

  fd = open("dd/dd/../ff", 0);
    20be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    20c5:	00 
    20c6:	c7 04 24 b8 4e 00 00 	movl   $0x4eb8,(%esp)
    20cd:	e8 5e 1e 00 00       	call   3f30 <open>
    20d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20d9:	79 19                	jns    20f4 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    20db:	c7 44 24 04 c4 4e 00 	movl   $0x4ec4,0x4(%esp)
    20e2:	00 
    20e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20ea:	e8 78 1f 00 00       	call   4067 <printf>
    exit();
    20ef:	e8 fc 1d 00 00       	call   3ef0 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    20f4:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    20fb:	00 
    20fc:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    2103:	00 
    2104:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2107:	89 04 24             	mov    %eax,(%esp)
    210a:	e8 f9 1d 00 00       	call   3f08 <read>
    210f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    2112:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2116:	75 0b                	jne    2123 <subdir+0x1be>
    2118:	0f b6 05 00 8b 00 00 	movzbl 0x8b00,%eax
    211f:	3c 66                	cmp    $0x66,%al
    2121:	74 19                	je     213c <subdir+0x1d7>
    printf(1, "dd/dd/../ff wrong content\n");
    2123:	c7 44 24 04 dd 4e 00 	movl   $0x4edd,0x4(%esp)
    212a:	00 
    212b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2132:	e8 30 1f 00 00       	call   4067 <printf>
    exit();
    2137:	e8 b4 1d 00 00       	call   3ef0 <exit>
  }
  close(fd);
    213c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    213f:	89 04 24             	mov    %eax,(%esp)
    2142:	e8 d1 1d 00 00       	call   3f18 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2147:	c7 44 24 04 f8 4e 00 	movl   $0x4ef8,0x4(%esp)
    214e:	00 
    214f:	c7 04 24 94 4e 00 00 	movl   $0x4e94,(%esp)
    2156:	e8 f5 1d 00 00       	call   3f50 <link>
    215b:	85 c0                	test   %eax,%eax
    215d:	74 19                	je     2178 <subdir+0x213>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    215f:	c7 44 24 04 04 4f 00 	movl   $0x4f04,0x4(%esp)
    2166:	00 
    2167:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    216e:	e8 f4 1e 00 00       	call   4067 <printf>
    exit();
    2173:	e8 78 1d 00 00       	call   3ef0 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    2178:	c7 04 24 94 4e 00 00 	movl   $0x4e94,(%esp)
    217f:	e8 bc 1d 00 00       	call   3f40 <unlink>
    2184:	85 c0                	test   %eax,%eax
    2186:	74 19                	je     21a1 <subdir+0x23c>
    printf(1, "unlink dd/dd/ff failed\n");
    2188:	c7 44 24 04 25 4f 00 	movl   $0x4f25,0x4(%esp)
    218f:	00 
    2190:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2197:	e8 cb 1e 00 00       	call   4067 <printf>
    exit();
    219c:	e8 4f 1d 00 00       	call   3ef0 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    21a8:	00 
    21a9:	c7 04 24 94 4e 00 00 	movl   $0x4e94,(%esp)
    21b0:	e8 7b 1d 00 00       	call   3f30 <open>
    21b5:	85 c0                	test   %eax,%eax
    21b7:	78 19                	js     21d2 <subdir+0x26d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21b9:	c7 44 24 04 40 4f 00 	movl   $0x4f40,0x4(%esp)
    21c0:	00 
    21c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21c8:	e8 9a 1e 00 00       	call   4067 <printf>
    exit();
    21cd:	e8 1e 1d 00 00       	call   3ef0 <exit>
  }

  if(chdir("dd") != 0){
    21d2:	c7 04 24 15 4e 00 00 	movl   $0x4e15,(%esp)
    21d9:	e8 82 1d 00 00       	call   3f60 <chdir>
    21de:	85 c0                	test   %eax,%eax
    21e0:	74 19                	je     21fb <subdir+0x296>
    printf(1, "chdir dd failed\n");
    21e2:	c7 44 24 04 64 4f 00 	movl   $0x4f64,0x4(%esp)
    21e9:	00 
    21ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21f1:	e8 71 1e 00 00       	call   4067 <printf>
    exit();
    21f6:	e8 f5 1c 00 00       	call   3ef0 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    21fb:	c7 04 24 75 4f 00 00 	movl   $0x4f75,(%esp)
    2202:	e8 59 1d 00 00       	call   3f60 <chdir>
    2207:	85 c0                	test   %eax,%eax
    2209:	74 19                	je     2224 <subdir+0x2bf>
    printf(1, "chdir dd/../../dd failed\n");
    220b:	c7 44 24 04 81 4f 00 	movl   $0x4f81,0x4(%esp)
    2212:	00 
    2213:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    221a:	e8 48 1e 00 00       	call   4067 <printf>
    exit();
    221f:	e8 cc 1c 00 00       	call   3ef0 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2224:	c7 04 24 9b 4f 00 00 	movl   $0x4f9b,(%esp)
    222b:	e8 30 1d 00 00       	call   3f60 <chdir>
    2230:	85 c0                	test   %eax,%eax
    2232:	74 19                	je     224d <subdir+0x2e8>
    printf(1, "chdir dd/../../dd failed\n");
    2234:	c7 44 24 04 81 4f 00 	movl   $0x4f81,0x4(%esp)
    223b:	00 
    223c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2243:	e8 1f 1e 00 00       	call   4067 <printf>
    exit();
    2248:	e8 a3 1c 00 00       	call   3ef0 <exit>
  }
  if(chdir("./..") != 0){
    224d:	c7 04 24 aa 4f 00 00 	movl   $0x4faa,(%esp)
    2254:	e8 07 1d 00 00       	call   3f60 <chdir>
    2259:	85 c0                	test   %eax,%eax
    225b:	74 19                	je     2276 <subdir+0x311>
    printf(1, "chdir ./.. failed\n");
    225d:	c7 44 24 04 af 4f 00 	movl   $0x4faf,0x4(%esp)
    2264:	00 
    2265:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    226c:	e8 f6 1d 00 00       	call   4067 <printf>
    exit();
    2271:	e8 7a 1c 00 00       	call   3ef0 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    2276:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    227d:	00 
    227e:	c7 04 24 f8 4e 00 00 	movl   $0x4ef8,(%esp)
    2285:	e8 a6 1c 00 00       	call   3f30 <open>
    228a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    228d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2291:	79 19                	jns    22ac <subdir+0x347>
    printf(1, "open dd/dd/ffff failed\n");
    2293:	c7 44 24 04 c2 4f 00 	movl   $0x4fc2,0x4(%esp)
    229a:	00 
    229b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22a2:	e8 c0 1d 00 00       	call   4067 <printf>
    exit();
    22a7:	e8 44 1c 00 00       	call   3ef0 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22ac:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    22b3:	00 
    22b4:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    22bb:	00 
    22bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22bf:	89 04 24             	mov    %eax,(%esp)
    22c2:	e8 41 1c 00 00       	call   3f08 <read>
    22c7:	83 f8 02             	cmp    $0x2,%eax
    22ca:	74 19                	je     22e5 <subdir+0x380>
    printf(1, "read dd/dd/ffff wrong len\n");
    22cc:	c7 44 24 04 da 4f 00 	movl   $0x4fda,0x4(%esp)
    22d3:	00 
    22d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22db:	e8 87 1d 00 00       	call   4067 <printf>
    exit();
    22e0:	e8 0b 1c 00 00       	call   3ef0 <exit>
  }
  close(fd);
    22e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22e8:	89 04 24             	mov    %eax,(%esp)
    22eb:	e8 28 1c 00 00       	call   3f18 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    22f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    22f7:	00 
    22f8:	c7 04 24 94 4e 00 00 	movl   $0x4e94,(%esp)
    22ff:	e8 2c 1c 00 00       	call   3f30 <open>
    2304:	85 c0                	test   %eax,%eax
    2306:	78 19                	js     2321 <subdir+0x3bc>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2308:	c7 44 24 04 f8 4f 00 	movl   $0x4ff8,0x4(%esp)
    230f:	00 
    2310:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2317:	e8 4b 1d 00 00       	call   4067 <printf>
    exit();
    231c:	e8 cf 1b 00 00       	call   3ef0 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2321:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2328:	00 
    2329:	c7 04 24 1d 50 00 00 	movl   $0x501d,(%esp)
    2330:	e8 fb 1b 00 00       	call   3f30 <open>
    2335:	85 c0                	test   %eax,%eax
    2337:	78 19                	js     2352 <subdir+0x3ed>
    printf(1, "create dd/ff/ff succeeded!\n");
    2339:	c7 44 24 04 26 50 00 	movl   $0x5026,0x4(%esp)
    2340:	00 
    2341:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2348:	e8 1a 1d 00 00       	call   4067 <printf>
    exit();
    234d:	e8 9e 1b 00 00       	call   3ef0 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2352:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2359:	00 
    235a:	c7 04 24 42 50 00 00 	movl   $0x5042,(%esp)
    2361:	e8 ca 1b 00 00       	call   3f30 <open>
    2366:	85 c0                	test   %eax,%eax
    2368:	78 19                	js     2383 <subdir+0x41e>
    printf(1, "create dd/xx/ff succeeded!\n");
    236a:	c7 44 24 04 4b 50 00 	movl   $0x504b,0x4(%esp)
    2371:	00 
    2372:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2379:	e8 e9 1c 00 00       	call   4067 <printf>
    exit();
    237e:	e8 6d 1b 00 00       	call   3ef0 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    2383:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    238a:	00 
    238b:	c7 04 24 15 4e 00 00 	movl   $0x4e15,(%esp)
    2392:	e8 99 1b 00 00       	call   3f30 <open>
    2397:	85 c0                	test   %eax,%eax
    2399:	78 19                	js     23b4 <subdir+0x44f>
    printf(1, "create dd succeeded!\n");
    239b:	c7 44 24 04 67 50 00 	movl   $0x5067,0x4(%esp)
    23a2:	00 
    23a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23aa:	e8 b8 1c 00 00       	call   4067 <printf>
    exit();
    23af:	e8 3c 1b 00 00       	call   3ef0 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23b4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    23bb:	00 
    23bc:	c7 04 24 15 4e 00 00 	movl   $0x4e15,(%esp)
    23c3:	e8 68 1b 00 00       	call   3f30 <open>
    23c8:	85 c0                	test   %eax,%eax
    23ca:	78 19                	js     23e5 <subdir+0x480>
    printf(1, "open dd rdwr succeeded!\n");
    23cc:	c7 44 24 04 7d 50 00 	movl   $0x507d,0x4(%esp)
    23d3:	00 
    23d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23db:	e8 87 1c 00 00       	call   4067 <printf>
    exit();
    23e0:	e8 0b 1b 00 00       	call   3ef0 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    23e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    23ec:	00 
    23ed:	c7 04 24 15 4e 00 00 	movl   $0x4e15,(%esp)
    23f4:	e8 37 1b 00 00       	call   3f30 <open>
    23f9:	85 c0                	test   %eax,%eax
    23fb:	78 19                	js     2416 <subdir+0x4b1>
    printf(1, "open dd wronly succeeded!\n");
    23fd:	c7 44 24 04 96 50 00 	movl   $0x5096,0x4(%esp)
    2404:	00 
    2405:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    240c:	e8 56 1c 00 00       	call   4067 <printf>
    exit();
    2411:	e8 da 1a 00 00       	call   3ef0 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2416:	c7 44 24 04 b1 50 00 	movl   $0x50b1,0x4(%esp)
    241d:	00 
    241e:	c7 04 24 1d 50 00 00 	movl   $0x501d,(%esp)
    2425:	e8 26 1b 00 00       	call   3f50 <link>
    242a:	85 c0                	test   %eax,%eax
    242c:	75 19                	jne    2447 <subdir+0x4e2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    242e:	c7 44 24 04 bc 50 00 	movl   $0x50bc,0x4(%esp)
    2435:	00 
    2436:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    243d:	e8 25 1c 00 00       	call   4067 <printf>
    exit();
    2442:	e8 a9 1a 00 00       	call   3ef0 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2447:	c7 44 24 04 b1 50 00 	movl   $0x50b1,0x4(%esp)
    244e:	00 
    244f:	c7 04 24 42 50 00 00 	movl   $0x5042,(%esp)
    2456:	e8 f5 1a 00 00       	call   3f50 <link>
    245b:	85 c0                	test   %eax,%eax
    245d:	75 19                	jne    2478 <subdir+0x513>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    245f:	c7 44 24 04 e0 50 00 	movl   $0x50e0,0x4(%esp)
    2466:	00 
    2467:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    246e:	e8 f4 1b 00 00       	call   4067 <printf>
    exit();
    2473:	e8 78 1a 00 00       	call   3ef0 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2478:	c7 44 24 04 f8 4e 00 	movl   $0x4ef8,0x4(%esp)
    247f:	00 
    2480:	c7 04 24 30 4e 00 00 	movl   $0x4e30,(%esp)
    2487:	e8 c4 1a 00 00       	call   3f50 <link>
    248c:	85 c0                	test   %eax,%eax
    248e:	75 19                	jne    24a9 <subdir+0x544>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2490:	c7 44 24 04 04 51 00 	movl   $0x5104,0x4(%esp)
    2497:	00 
    2498:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    249f:	e8 c3 1b 00 00       	call   4067 <printf>
    exit();
    24a4:	e8 47 1a 00 00       	call   3ef0 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    24a9:	c7 04 24 1d 50 00 00 	movl   $0x501d,(%esp)
    24b0:	e8 a3 1a 00 00       	call   3f58 <mkdir>
    24b5:	85 c0                	test   %eax,%eax
    24b7:	75 19                	jne    24d2 <subdir+0x56d>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24b9:	c7 44 24 04 26 51 00 	movl   $0x5126,0x4(%esp)
    24c0:	00 
    24c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24c8:	e8 9a 1b 00 00       	call   4067 <printf>
    exit();
    24cd:	e8 1e 1a 00 00       	call   3ef0 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    24d2:	c7 04 24 42 50 00 00 	movl   $0x5042,(%esp)
    24d9:	e8 7a 1a 00 00       	call   3f58 <mkdir>
    24de:	85 c0                	test   %eax,%eax
    24e0:	75 19                	jne    24fb <subdir+0x596>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    24e2:	c7 44 24 04 41 51 00 	movl   $0x5141,0x4(%esp)
    24e9:	00 
    24ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24f1:	e8 71 1b 00 00       	call   4067 <printf>
    exit();
    24f6:	e8 f5 19 00 00       	call   3ef0 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    24fb:	c7 04 24 f8 4e 00 00 	movl   $0x4ef8,(%esp)
    2502:	e8 51 1a 00 00       	call   3f58 <mkdir>
    2507:	85 c0                	test   %eax,%eax
    2509:	75 19                	jne    2524 <subdir+0x5bf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    250b:	c7 44 24 04 5c 51 00 	movl   $0x515c,0x4(%esp)
    2512:	00 
    2513:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    251a:	e8 48 1b 00 00       	call   4067 <printf>
    exit();
    251f:	e8 cc 19 00 00       	call   3ef0 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    2524:	c7 04 24 42 50 00 00 	movl   $0x5042,(%esp)
    252b:	e8 10 1a 00 00       	call   3f40 <unlink>
    2530:	85 c0                	test   %eax,%eax
    2532:	75 19                	jne    254d <subdir+0x5e8>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2534:	c7 44 24 04 79 51 00 	movl   $0x5179,0x4(%esp)
    253b:	00 
    253c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2543:	e8 1f 1b 00 00       	call   4067 <printf>
    exit();
    2548:	e8 a3 19 00 00       	call   3ef0 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    254d:	c7 04 24 1d 50 00 00 	movl   $0x501d,(%esp)
    2554:	e8 e7 19 00 00       	call   3f40 <unlink>
    2559:	85 c0                	test   %eax,%eax
    255b:	75 19                	jne    2576 <subdir+0x611>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    255d:	c7 44 24 04 95 51 00 	movl   $0x5195,0x4(%esp)
    2564:	00 
    2565:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    256c:	e8 f6 1a 00 00       	call   4067 <printf>
    exit();
    2571:	e8 7a 19 00 00       	call   3ef0 <exit>
  }
  if(chdir("dd/ff") == 0){
    2576:	c7 04 24 30 4e 00 00 	movl   $0x4e30,(%esp)
    257d:	e8 de 19 00 00       	call   3f60 <chdir>
    2582:	85 c0                	test   %eax,%eax
    2584:	75 19                	jne    259f <subdir+0x63a>
    printf(1, "chdir dd/ff succeeded!\n");
    2586:	c7 44 24 04 b1 51 00 	movl   $0x51b1,0x4(%esp)
    258d:	00 
    258e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2595:	e8 cd 1a 00 00       	call   4067 <printf>
    exit();
    259a:	e8 51 19 00 00       	call   3ef0 <exit>
  }
  if(chdir("dd/xx") == 0){
    259f:	c7 04 24 c9 51 00 00 	movl   $0x51c9,(%esp)
    25a6:	e8 b5 19 00 00       	call   3f60 <chdir>
    25ab:	85 c0                	test   %eax,%eax
    25ad:	75 19                	jne    25c8 <subdir+0x663>
    printf(1, "chdir dd/xx succeeded!\n");
    25af:	c7 44 24 04 cf 51 00 	movl   $0x51cf,0x4(%esp)
    25b6:	00 
    25b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25be:	e8 a4 1a 00 00       	call   4067 <printf>
    exit();
    25c3:	e8 28 19 00 00       	call   3ef0 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    25c8:	c7 04 24 f8 4e 00 00 	movl   $0x4ef8,(%esp)
    25cf:	e8 6c 19 00 00       	call   3f40 <unlink>
    25d4:	85 c0                	test   %eax,%eax
    25d6:	74 19                	je     25f1 <subdir+0x68c>
    printf(1, "unlink dd/dd/ff failed\n");
    25d8:	c7 44 24 04 25 4f 00 	movl   $0x4f25,0x4(%esp)
    25df:	00 
    25e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25e7:	e8 7b 1a 00 00       	call   4067 <printf>
    exit();
    25ec:	e8 ff 18 00 00       	call   3ef0 <exit>
  }
  if(unlink("dd/ff") != 0){
    25f1:	c7 04 24 30 4e 00 00 	movl   $0x4e30,(%esp)
    25f8:	e8 43 19 00 00       	call   3f40 <unlink>
    25fd:	85 c0                	test   %eax,%eax
    25ff:	74 19                	je     261a <subdir+0x6b5>
    printf(1, "unlink dd/ff failed\n");
    2601:	c7 44 24 04 e7 51 00 	movl   $0x51e7,0x4(%esp)
    2608:	00 
    2609:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2610:	e8 52 1a 00 00       	call   4067 <printf>
    exit();
    2615:	e8 d6 18 00 00       	call   3ef0 <exit>
  }
  if(unlink("dd") == 0){
    261a:	c7 04 24 15 4e 00 00 	movl   $0x4e15,(%esp)
    2621:	e8 1a 19 00 00       	call   3f40 <unlink>
    2626:	85 c0                	test   %eax,%eax
    2628:	75 19                	jne    2643 <subdir+0x6de>
    printf(1, "unlink non-empty dd succeeded!\n");
    262a:	c7 44 24 04 fc 51 00 	movl   $0x51fc,0x4(%esp)
    2631:	00 
    2632:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2639:	e8 29 1a 00 00       	call   4067 <printf>
    exit();
    263e:	e8 ad 18 00 00       	call   3ef0 <exit>
  }
  if(unlink("dd/dd") < 0){
    2643:	c7 04 24 1c 52 00 00 	movl   $0x521c,(%esp)
    264a:	e8 f1 18 00 00       	call   3f40 <unlink>
    264f:	85 c0                	test   %eax,%eax
    2651:	79 19                	jns    266c <subdir+0x707>
    printf(1, "unlink dd/dd failed\n");
    2653:	c7 44 24 04 22 52 00 	movl   $0x5222,0x4(%esp)
    265a:	00 
    265b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2662:	e8 00 1a 00 00       	call   4067 <printf>
    exit();
    2667:	e8 84 18 00 00       	call   3ef0 <exit>
  }
  if(unlink("dd") < 0){
    266c:	c7 04 24 15 4e 00 00 	movl   $0x4e15,(%esp)
    2673:	e8 c8 18 00 00       	call   3f40 <unlink>
    2678:	85 c0                	test   %eax,%eax
    267a:	79 19                	jns    2695 <subdir+0x730>
    printf(1, "unlink dd failed\n");
    267c:	c7 44 24 04 37 52 00 	movl   $0x5237,0x4(%esp)
    2683:	00 
    2684:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    268b:	e8 d7 19 00 00       	call   4067 <printf>
    exit();
    2690:	e8 5b 18 00 00       	call   3ef0 <exit>
  }

  printf(1, "subdir ok\n");
    2695:	c7 44 24 04 49 52 00 	movl   $0x5249,0x4(%esp)
    269c:	00 
    269d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26a4:	e8 be 19 00 00       	call   4067 <printf>
}
    26a9:	c9                   	leave  
    26aa:	c3                   	ret    

000026ab <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26ab:	55                   	push   %ebp
    26ac:	89 e5                	mov    %esp,%ebp
    26ae:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26b1:	c7 44 24 04 54 52 00 	movl   $0x5254,0x4(%esp)
    26b8:	00 
    26b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26c0:	e8 a2 19 00 00       	call   4067 <printf>

  unlink("bigwrite");
    26c5:	c7 04 24 63 52 00 00 	movl   $0x5263,(%esp)
    26cc:	e8 6f 18 00 00       	call   3f40 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    26d1:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    26d8:	e9 b3 00 00 00       	jmp    2790 <bigwrite+0xe5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    26dd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    26e4:	00 
    26e5:	c7 04 24 63 52 00 00 	movl   $0x5263,(%esp)
    26ec:	e8 3f 18 00 00       	call   3f30 <open>
    26f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    26f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    26f8:	79 19                	jns    2713 <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    26fa:	c7 44 24 04 6c 52 00 	movl   $0x526c,0x4(%esp)
    2701:	00 
    2702:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2709:	e8 59 19 00 00       	call   4067 <printf>
      exit();
    270e:	e8 dd 17 00 00       	call   3ef0 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    2713:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    271a:	eb 50                	jmp    276c <bigwrite+0xc1>
      int cc = write(fd, buf, sz);
    271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    271f:	89 44 24 08          	mov    %eax,0x8(%esp)
    2723:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    272a:	00 
    272b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    272e:	89 04 24             	mov    %eax,(%esp)
    2731:	e8 da 17 00 00       	call   3f10 <write>
    2736:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    2739:	8b 45 e8             	mov    -0x18(%ebp),%eax
    273c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    273f:	74 27                	je     2768 <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    2741:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2744:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2748:	8b 45 f4             	mov    -0xc(%ebp),%eax
    274b:	89 44 24 08          	mov    %eax,0x8(%esp)
    274f:	c7 44 24 04 84 52 00 	movl   $0x5284,0x4(%esp)
    2756:	00 
    2757:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    275e:	e8 04 19 00 00       	call   4067 <printf>
        exit();
    2763:	e8 88 17 00 00       	call   3ef0 <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    2768:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    276c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2770:	7e aa                	jle    271c <bigwrite+0x71>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2772:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2775:	89 04 24             	mov    %eax,(%esp)
    2778:	e8 9b 17 00 00       	call   3f18 <close>
    unlink("bigwrite");
    277d:	c7 04 24 63 52 00 00 	movl   $0x5263,(%esp)
    2784:	e8 b7 17 00 00       	call   3f40 <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    2789:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    2790:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    2797:	0f 8e 40 ff ff ff    	jle    26dd <bigwrite+0x32>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    279d:	c7 44 24 04 96 52 00 	movl   $0x5296,0x4(%esp)
    27a4:	00 
    27a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27ac:	e8 b6 18 00 00       	call   4067 <printf>
}
    27b1:	c9                   	leave  
    27b2:	c3                   	ret    

000027b3 <bigfile>:

void
bigfile(void)
{
    27b3:	55                   	push   %ebp
    27b4:	89 e5                	mov    %esp,%ebp
    27b6:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27b9:	c7 44 24 04 a3 52 00 	movl   $0x52a3,0x4(%esp)
    27c0:	00 
    27c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27c8:	e8 9a 18 00 00       	call   4067 <printf>

  unlink("bigfile");
    27cd:	c7 04 24 b1 52 00 00 	movl   $0x52b1,(%esp)
    27d4:	e8 67 17 00 00       	call   3f40 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    27d9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    27e0:	00 
    27e1:	c7 04 24 b1 52 00 00 	movl   $0x52b1,(%esp)
    27e8:	e8 43 17 00 00       	call   3f30 <open>
    27ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    27f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    27f4:	79 19                	jns    280f <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    27f6:	c7 44 24 04 b9 52 00 	movl   $0x52b9,0x4(%esp)
    27fd:	00 
    27fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2805:	e8 5d 18 00 00       	call   4067 <printf>
    exit();
    280a:	e8 e1 16 00 00       	call   3ef0 <exit>
  }
  for(i = 0; i < 20; i++){
    280f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2816:	eb 5a                	jmp    2872 <bigfile+0xbf>
    memset(buf, i, 600);
    2818:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    281f:	00 
    2820:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2823:	89 44 24 04          	mov    %eax,0x4(%esp)
    2827:	c7 04 24 00 8b 00 00 	movl   $0x8b00,(%esp)
    282e:	e8 18 15 00 00       	call   3d4b <memset>
    if(write(fd, buf, 600) != 600){
    2833:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    283a:	00 
    283b:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    2842:	00 
    2843:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2846:	89 04 24             	mov    %eax,(%esp)
    2849:	e8 c2 16 00 00       	call   3f10 <write>
    284e:	3d 58 02 00 00       	cmp    $0x258,%eax
    2853:	74 19                	je     286e <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    2855:	c7 44 24 04 cf 52 00 	movl   $0x52cf,0x4(%esp)
    285c:	00 
    285d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2864:	e8 fe 17 00 00       	call   4067 <printf>
      exit();
    2869:	e8 82 16 00 00       	call   3ef0 <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    286e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2872:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2876:	7e a0                	jle    2818 <bigfile+0x65>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2878:	8b 45 ec             	mov    -0x14(%ebp),%eax
    287b:	89 04 24             	mov    %eax,(%esp)
    287e:	e8 95 16 00 00       	call   3f18 <close>

  fd = open("bigfile", 0);
    2883:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    288a:	00 
    288b:	c7 04 24 b1 52 00 00 	movl   $0x52b1,(%esp)
    2892:	e8 99 16 00 00       	call   3f30 <open>
    2897:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    289a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    289e:	79 19                	jns    28b9 <bigfile+0x106>
    printf(1, "cannot open bigfile\n");
    28a0:	c7 44 24 04 e5 52 00 	movl   $0x52e5,0x4(%esp)
    28a7:	00 
    28a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28af:	e8 b3 17 00 00       	call   4067 <printf>
    exit();
    28b4:	e8 37 16 00 00       	call   3ef0 <exit>
  }
  total = 0;
    28b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    28c7:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    28ce:	00 
    28cf:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    28d6:	00 
    28d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    28da:	89 04 24             	mov    %eax,(%esp)
    28dd:	e8 26 16 00 00       	call   3f08 <read>
    28e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    28e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28e9:	79 19                	jns    2904 <bigfile+0x151>
      printf(1, "read bigfile failed\n");
    28eb:	c7 44 24 04 fa 52 00 	movl   $0x52fa,0x4(%esp)
    28f2:	00 
    28f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28fa:	e8 68 17 00 00       	call   4067 <printf>
      exit();
    28ff:	e8 ec 15 00 00       	call   3ef0 <exit>
    }
    if(cc == 0)
    2904:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2908:	74 7e                	je     2988 <bigfile+0x1d5>
      break;
    if(cc != 300){
    290a:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    2911:	74 19                	je     292c <bigfile+0x179>
      printf(1, "short read bigfile\n");
    2913:	c7 44 24 04 0f 53 00 	movl   $0x530f,0x4(%esp)
    291a:	00 
    291b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2922:	e8 40 17 00 00       	call   4067 <printf>
      exit();
    2927:	e8 c4 15 00 00       	call   3ef0 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    292c:	0f b6 05 00 8b 00 00 	movzbl 0x8b00,%eax
    2933:	0f be d0             	movsbl %al,%edx
    2936:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2939:	89 c1                	mov    %eax,%ecx
    293b:	c1 e9 1f             	shr    $0x1f,%ecx
    293e:	01 c8                	add    %ecx,%eax
    2940:	d1 f8                	sar    %eax
    2942:	39 c2                	cmp    %eax,%edx
    2944:	75 1a                	jne    2960 <bigfile+0x1ad>
    2946:	0f b6 05 2b 8c 00 00 	movzbl 0x8c2b,%eax
    294d:	0f be d0             	movsbl %al,%edx
    2950:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2953:	89 c1                	mov    %eax,%ecx
    2955:	c1 e9 1f             	shr    $0x1f,%ecx
    2958:	01 c8                	add    %ecx,%eax
    295a:	d1 f8                	sar    %eax
    295c:	39 c2                	cmp    %eax,%edx
    295e:	74 19                	je     2979 <bigfile+0x1c6>
      printf(1, "read bigfile wrong data\n");
    2960:	c7 44 24 04 23 53 00 	movl   $0x5323,0x4(%esp)
    2967:	00 
    2968:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    296f:	e8 f3 16 00 00       	call   4067 <printf>
      exit();
    2974:	e8 77 15 00 00       	call   3ef0 <exit>
    }
    total += cc;
    2979:	8b 45 e8             	mov    -0x18(%ebp),%eax
    297c:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    297f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    2983:	e9 3f ff ff ff       	jmp    28c7 <bigfile+0x114>
    if(cc < 0){
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    2988:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    2989:	8b 45 ec             	mov    -0x14(%ebp),%eax
    298c:	89 04 24             	mov    %eax,(%esp)
    298f:	e8 84 15 00 00       	call   3f18 <close>
  if(total != 20*600){
    2994:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    299b:	74 19                	je     29b6 <bigfile+0x203>
    printf(1, "read bigfile wrong total\n");
    299d:	c7 44 24 04 3c 53 00 	movl   $0x533c,0x4(%esp)
    29a4:	00 
    29a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29ac:	e8 b6 16 00 00       	call   4067 <printf>
    exit();
    29b1:	e8 3a 15 00 00       	call   3ef0 <exit>
  }
  unlink("bigfile");
    29b6:	c7 04 24 b1 52 00 00 	movl   $0x52b1,(%esp)
    29bd:	e8 7e 15 00 00       	call   3f40 <unlink>

  printf(1, "bigfile test ok\n");
    29c2:	c7 44 24 04 56 53 00 	movl   $0x5356,0x4(%esp)
    29c9:	00 
    29ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29d1:	e8 91 16 00 00       	call   4067 <printf>
}
    29d6:	c9                   	leave  
    29d7:	c3                   	ret    

000029d8 <fourteen>:

void
fourteen(void)
{
    29d8:	55                   	push   %ebp
    29d9:	89 e5                	mov    %esp,%ebp
    29db:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    29de:	c7 44 24 04 67 53 00 	movl   $0x5367,0x4(%esp)
    29e5:	00 
    29e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29ed:	e8 75 16 00 00       	call   4067 <printf>

  if(mkdir("12345678901234") != 0){
    29f2:	c7 04 24 76 53 00 00 	movl   $0x5376,(%esp)
    29f9:	e8 5a 15 00 00       	call   3f58 <mkdir>
    29fe:	85 c0                	test   %eax,%eax
    2a00:	74 19                	je     2a1b <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a02:	c7 44 24 04 85 53 00 	movl   $0x5385,0x4(%esp)
    2a09:	00 
    2a0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a11:	e8 51 16 00 00       	call   4067 <printf>
    exit();
    2a16:	e8 d5 14 00 00       	call   3ef0 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a1b:	c7 04 24 a4 53 00 00 	movl   $0x53a4,(%esp)
    2a22:	e8 31 15 00 00       	call   3f58 <mkdir>
    2a27:	85 c0                	test   %eax,%eax
    2a29:	74 19                	je     2a44 <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a2b:	c7 44 24 04 c4 53 00 	movl   $0x53c4,0x4(%esp)
    2a32:	00 
    2a33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a3a:	e8 28 16 00 00       	call   4067 <printf>
    exit();
    2a3f:	e8 ac 14 00 00       	call   3ef0 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a44:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a4b:	00 
    2a4c:	c7 04 24 f4 53 00 00 	movl   $0x53f4,(%esp)
    2a53:	e8 d8 14 00 00       	call   3f30 <open>
    2a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a5f:	79 19                	jns    2a7a <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a61:	c7 44 24 04 24 54 00 	movl   $0x5424,0x4(%esp)
    2a68:	00 
    2a69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a70:	e8 f2 15 00 00       	call   4067 <printf>
    exit();
    2a75:	e8 76 14 00 00       	call   3ef0 <exit>
  }
  close(fd);
    2a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a7d:	89 04 24             	mov    %eax,(%esp)
    2a80:	e8 93 14 00 00       	call   3f18 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2a8c:	00 
    2a8d:	c7 04 24 64 54 00 00 	movl   $0x5464,(%esp)
    2a94:	e8 97 14 00 00       	call   3f30 <open>
    2a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2aa0:	79 19                	jns    2abb <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2aa2:	c7 44 24 04 94 54 00 	movl   $0x5494,0x4(%esp)
    2aa9:	00 
    2aaa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ab1:	e8 b1 15 00 00       	call   4067 <printf>
    exit();
    2ab6:	e8 35 14 00 00       	call   3ef0 <exit>
  }
  close(fd);
    2abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2abe:	89 04 24             	mov    %eax,(%esp)
    2ac1:	e8 52 14 00 00       	call   3f18 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2ac6:	c7 04 24 ce 54 00 00 	movl   $0x54ce,(%esp)
    2acd:	e8 86 14 00 00       	call   3f58 <mkdir>
    2ad2:	85 c0                	test   %eax,%eax
    2ad4:	75 19                	jne    2aef <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2ad6:	c7 44 24 04 ec 54 00 	movl   $0x54ec,0x4(%esp)
    2add:	00 
    2ade:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ae5:	e8 7d 15 00 00       	call   4067 <printf>
    exit();
    2aea:	e8 01 14 00 00       	call   3ef0 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2aef:	c7 04 24 1c 55 00 00 	movl   $0x551c,(%esp)
    2af6:	e8 5d 14 00 00       	call   3f58 <mkdir>
    2afb:	85 c0                	test   %eax,%eax
    2afd:	75 19                	jne    2b18 <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2aff:	c7 44 24 04 3c 55 00 	movl   $0x553c,0x4(%esp)
    2b06:	00 
    2b07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b0e:	e8 54 15 00 00       	call   4067 <printf>
    exit();
    2b13:	e8 d8 13 00 00       	call   3ef0 <exit>
  }

  printf(1, "fourteen ok\n");
    2b18:	c7 44 24 04 6d 55 00 	movl   $0x556d,0x4(%esp)
    2b1f:	00 
    2b20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b27:	e8 3b 15 00 00       	call   4067 <printf>
}
    2b2c:	c9                   	leave  
    2b2d:	c3                   	ret    

00002b2e <rmdot>:

void
rmdot(void)
{
    2b2e:	55                   	push   %ebp
    2b2f:	89 e5                	mov    %esp,%ebp
    2b31:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    2b34:	c7 44 24 04 7a 55 00 	movl   $0x557a,0x4(%esp)
    2b3b:	00 
    2b3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b43:	e8 1f 15 00 00       	call   4067 <printf>
  if(mkdir("dots") != 0){
    2b48:	c7 04 24 86 55 00 00 	movl   $0x5586,(%esp)
    2b4f:	e8 04 14 00 00       	call   3f58 <mkdir>
    2b54:	85 c0                	test   %eax,%eax
    2b56:	74 19                	je     2b71 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b58:	c7 44 24 04 8b 55 00 	movl   $0x558b,0x4(%esp)
    2b5f:	00 
    2b60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b67:	e8 fb 14 00 00       	call   4067 <printf>
    exit();
    2b6c:	e8 7f 13 00 00       	call   3ef0 <exit>
  }
  if(chdir("dots") != 0){
    2b71:	c7 04 24 86 55 00 00 	movl   $0x5586,(%esp)
    2b78:	e8 e3 13 00 00       	call   3f60 <chdir>
    2b7d:	85 c0                	test   %eax,%eax
    2b7f:	74 19                	je     2b9a <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    2b81:	c7 44 24 04 9e 55 00 	movl   $0x559e,0x4(%esp)
    2b88:	00 
    2b89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b90:	e8 d2 14 00 00       	call   4067 <printf>
    exit();
    2b95:	e8 56 13 00 00       	call   3ef0 <exit>
  }
  if(unlink(".") == 0){
    2b9a:	c7 04 24 b7 4c 00 00 	movl   $0x4cb7,(%esp)
    2ba1:	e8 9a 13 00 00       	call   3f40 <unlink>
    2ba6:	85 c0                	test   %eax,%eax
    2ba8:	75 19                	jne    2bc3 <rmdot+0x95>
    printf(1, "rm . worked!\n");
    2baa:	c7 44 24 04 b1 55 00 	movl   $0x55b1,0x4(%esp)
    2bb1:	00 
    2bb2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bb9:	e8 a9 14 00 00       	call   4067 <printf>
    exit();
    2bbe:	e8 2d 13 00 00       	call   3ef0 <exit>
  }
  if(unlink("..") == 0){
    2bc3:	c7 04 24 4a 48 00 00 	movl   $0x484a,(%esp)
    2bca:	e8 71 13 00 00       	call   3f40 <unlink>
    2bcf:	85 c0                	test   %eax,%eax
    2bd1:	75 19                	jne    2bec <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    2bd3:	c7 44 24 04 bf 55 00 	movl   $0x55bf,0x4(%esp)
    2bda:	00 
    2bdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2be2:	e8 80 14 00 00       	call   4067 <printf>
    exit();
    2be7:	e8 04 13 00 00       	call   3ef0 <exit>
  }
  if(chdir("/") != 0){
    2bec:	c7 04 24 9e 44 00 00 	movl   $0x449e,(%esp)
    2bf3:	e8 68 13 00 00       	call   3f60 <chdir>
    2bf8:	85 c0                	test   %eax,%eax
    2bfa:	74 19                	je     2c15 <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    2bfc:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    2c03:	00 
    2c04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c0b:	e8 57 14 00 00       	call   4067 <printf>
    exit();
    2c10:	e8 db 12 00 00       	call   3ef0 <exit>
  }
  if(unlink("dots/.") == 0){
    2c15:	c7 04 24 ce 55 00 00 	movl   $0x55ce,(%esp)
    2c1c:	e8 1f 13 00 00       	call   3f40 <unlink>
    2c21:	85 c0                	test   %eax,%eax
    2c23:	75 19                	jne    2c3e <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    2c25:	c7 44 24 04 d5 55 00 	movl   $0x55d5,0x4(%esp)
    2c2c:	00 
    2c2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c34:	e8 2e 14 00 00       	call   4067 <printf>
    exit();
    2c39:	e8 b2 12 00 00       	call   3ef0 <exit>
  }
  if(unlink("dots/..") == 0){
    2c3e:	c7 04 24 ec 55 00 00 	movl   $0x55ec,(%esp)
    2c45:	e8 f6 12 00 00       	call   3f40 <unlink>
    2c4a:	85 c0                	test   %eax,%eax
    2c4c:	75 19                	jne    2c67 <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    2c4e:	c7 44 24 04 f4 55 00 	movl   $0x55f4,0x4(%esp)
    2c55:	00 
    2c56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c5d:	e8 05 14 00 00       	call   4067 <printf>
    exit();
    2c62:	e8 89 12 00 00       	call   3ef0 <exit>
  }
  if(unlink("dots") != 0){
    2c67:	c7 04 24 86 55 00 00 	movl   $0x5586,(%esp)
    2c6e:	e8 cd 12 00 00       	call   3f40 <unlink>
    2c73:	85 c0                	test   %eax,%eax
    2c75:	74 19                	je     2c90 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    2c77:	c7 44 24 04 0c 56 00 	movl   $0x560c,0x4(%esp)
    2c7e:	00 
    2c7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c86:	e8 dc 13 00 00       	call   4067 <printf>
    exit();
    2c8b:	e8 60 12 00 00       	call   3ef0 <exit>
  }
  printf(1, "rmdot ok\n");
    2c90:	c7 44 24 04 21 56 00 	movl   $0x5621,0x4(%esp)
    2c97:	00 
    2c98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c9f:	e8 c3 13 00 00       	call   4067 <printf>
}
    2ca4:	c9                   	leave  
    2ca5:	c3                   	ret    

00002ca6 <dirfile>:

void
dirfile(void)
{
    2ca6:	55                   	push   %ebp
    2ca7:	89 e5                	mov    %esp,%ebp
    2ca9:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cac:	c7 44 24 04 2b 56 00 	movl   $0x562b,0x4(%esp)
    2cb3:	00 
    2cb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cbb:	e8 a7 13 00 00       	call   4067 <printf>

  fd = open("dirfile", O_CREATE);
    2cc0:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2cc7:	00 
    2cc8:	c7 04 24 38 56 00 00 	movl   $0x5638,(%esp)
    2ccf:	e8 5c 12 00 00       	call   3f30 <open>
    2cd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2cd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2cdb:	79 19                	jns    2cf6 <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    2cdd:	c7 44 24 04 40 56 00 	movl   $0x5640,0x4(%esp)
    2ce4:	00 
    2ce5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cec:	e8 76 13 00 00       	call   4067 <printf>
    exit();
    2cf1:	e8 fa 11 00 00       	call   3ef0 <exit>
  }
  close(fd);
    2cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2cf9:	89 04 24             	mov    %eax,(%esp)
    2cfc:	e8 17 12 00 00       	call   3f18 <close>
  if(chdir("dirfile") == 0){
    2d01:	c7 04 24 38 56 00 00 	movl   $0x5638,(%esp)
    2d08:	e8 53 12 00 00       	call   3f60 <chdir>
    2d0d:	85 c0                	test   %eax,%eax
    2d0f:	75 19                	jne    2d2a <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    2d11:	c7 44 24 04 57 56 00 	movl   $0x5657,0x4(%esp)
    2d18:	00 
    2d19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d20:	e8 42 13 00 00       	call   4067 <printf>
    exit();
    2d25:	e8 c6 11 00 00       	call   3ef0 <exit>
  }
  fd = open("dirfile/xx", 0);
    2d2a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2d31:	00 
    2d32:	c7 04 24 71 56 00 00 	movl   $0x5671,(%esp)
    2d39:	e8 f2 11 00 00       	call   3f30 <open>
    2d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d45:	78 19                	js     2d60 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    2d47:	c7 44 24 04 7c 56 00 	movl   $0x567c,0x4(%esp)
    2d4e:	00 
    2d4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d56:	e8 0c 13 00 00       	call   4067 <printf>
    exit();
    2d5b:	e8 90 11 00 00       	call   3ef0 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d60:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d67:	00 
    2d68:	c7 04 24 71 56 00 00 	movl   $0x5671,(%esp)
    2d6f:	e8 bc 11 00 00       	call   3f30 <open>
    2d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d7b:	78 19                	js     2d96 <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    2d7d:	c7 44 24 04 7c 56 00 	movl   $0x567c,0x4(%esp)
    2d84:	00 
    2d85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d8c:	e8 d6 12 00 00       	call   4067 <printf>
    exit();
    2d91:	e8 5a 11 00 00       	call   3ef0 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2d96:	c7 04 24 71 56 00 00 	movl   $0x5671,(%esp)
    2d9d:	e8 b6 11 00 00       	call   3f58 <mkdir>
    2da2:	85 c0                	test   %eax,%eax
    2da4:	75 19                	jne    2dbf <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2da6:	c7 44 24 04 9a 56 00 	movl   $0x569a,0x4(%esp)
    2dad:	00 
    2dae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2db5:	e8 ad 12 00 00       	call   4067 <printf>
    exit();
    2dba:	e8 31 11 00 00       	call   3ef0 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2dbf:	c7 04 24 71 56 00 00 	movl   $0x5671,(%esp)
    2dc6:	e8 75 11 00 00       	call   3f40 <unlink>
    2dcb:	85 c0                	test   %eax,%eax
    2dcd:	75 19                	jne    2de8 <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2dcf:	c7 44 24 04 b7 56 00 	movl   $0x56b7,0x4(%esp)
    2dd6:	00 
    2dd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dde:	e8 84 12 00 00       	call   4067 <printf>
    exit();
    2de3:	e8 08 11 00 00       	call   3ef0 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2de8:	c7 44 24 04 71 56 00 	movl   $0x5671,0x4(%esp)
    2def:	00 
    2df0:	c7 04 24 d5 56 00 00 	movl   $0x56d5,(%esp)
    2df7:	e8 54 11 00 00       	call   3f50 <link>
    2dfc:	85 c0                	test   %eax,%eax
    2dfe:	75 19                	jne    2e19 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e00:	c7 44 24 04 dc 56 00 	movl   $0x56dc,0x4(%esp)
    2e07:	00 
    2e08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e0f:	e8 53 12 00 00       	call   4067 <printf>
    exit();
    2e14:	e8 d7 10 00 00       	call   3ef0 <exit>
  }
  if(unlink("dirfile") != 0){
    2e19:	c7 04 24 38 56 00 00 	movl   $0x5638,(%esp)
    2e20:	e8 1b 11 00 00       	call   3f40 <unlink>
    2e25:	85 c0                	test   %eax,%eax
    2e27:	74 19                	je     2e42 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    2e29:	c7 44 24 04 fb 56 00 	movl   $0x56fb,0x4(%esp)
    2e30:	00 
    2e31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e38:	e8 2a 12 00 00       	call   4067 <printf>
    exit();
    2e3d:	e8 ae 10 00 00       	call   3ef0 <exit>
  }

  fd = open(".", O_RDWR);
    2e42:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2e49:	00 
    2e4a:	c7 04 24 b7 4c 00 00 	movl   $0x4cb7,(%esp)
    2e51:	e8 da 10 00 00       	call   3f30 <open>
    2e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e5d:	78 19                	js     2e78 <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    2e5f:	c7 44 24 04 14 57 00 	movl   $0x5714,0x4(%esp)
    2e66:	00 
    2e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e6e:	e8 f4 11 00 00       	call   4067 <printf>
    exit();
    2e73:	e8 78 10 00 00       	call   3ef0 <exit>
  }
  fd = open(".", 0);
    2e78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2e7f:	00 
    2e80:	c7 04 24 b7 4c 00 00 	movl   $0x4cb7,(%esp)
    2e87:	e8 a4 10 00 00       	call   3f30 <open>
    2e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2e8f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2e96:	00 
    2e97:	c7 44 24 04 03 49 00 	movl   $0x4903,0x4(%esp)
    2e9e:	00 
    2e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ea2:	89 04 24             	mov    %eax,(%esp)
    2ea5:	e8 66 10 00 00       	call   3f10 <write>
    2eaa:	85 c0                	test   %eax,%eax
    2eac:	7e 19                	jle    2ec7 <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    2eae:	c7 44 24 04 33 57 00 	movl   $0x5733,0x4(%esp)
    2eb5:	00 
    2eb6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ebd:	e8 a5 11 00 00       	call   4067 <printf>
    exit();
    2ec2:	e8 29 10 00 00       	call   3ef0 <exit>
  }
  close(fd);
    2ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2eca:	89 04 24             	mov    %eax,(%esp)
    2ecd:	e8 46 10 00 00       	call   3f18 <close>

  printf(1, "dir vs file OK\n");
    2ed2:	c7 44 24 04 47 57 00 	movl   $0x5747,0x4(%esp)
    2ed9:	00 
    2eda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ee1:	e8 81 11 00 00       	call   4067 <printf>
}
    2ee6:	c9                   	leave  
    2ee7:	c3                   	ret    

00002ee8 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2ee8:	55                   	push   %ebp
    2ee9:	89 e5                	mov    %esp,%ebp
    2eeb:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2eee:	c7 44 24 04 57 57 00 	movl   $0x5757,0x4(%esp)
    2ef5:	00 
    2ef6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2efd:	e8 65 11 00 00       	call   4067 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f09:	e9 d2 00 00 00       	jmp    2fe0 <iref+0xf8>
    if(mkdir("irefd") != 0){
    2f0e:	c7 04 24 68 57 00 00 	movl   $0x5768,(%esp)
    2f15:	e8 3e 10 00 00       	call   3f58 <mkdir>
    2f1a:	85 c0                	test   %eax,%eax
    2f1c:	74 19                	je     2f37 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f1e:	c7 44 24 04 6e 57 00 	movl   $0x576e,0x4(%esp)
    2f25:	00 
    2f26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f2d:	e8 35 11 00 00       	call   4067 <printf>
      exit();
    2f32:	e8 b9 0f 00 00       	call   3ef0 <exit>
    }
    if(chdir("irefd") != 0){
    2f37:	c7 04 24 68 57 00 00 	movl   $0x5768,(%esp)
    2f3e:	e8 1d 10 00 00       	call   3f60 <chdir>
    2f43:	85 c0                	test   %eax,%eax
    2f45:	74 19                	je     2f60 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    2f47:	c7 44 24 04 82 57 00 	movl   $0x5782,0x4(%esp)
    2f4e:	00 
    2f4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f56:	e8 0c 11 00 00       	call   4067 <printf>
      exit();
    2f5b:	e8 90 0f 00 00       	call   3ef0 <exit>
    }

    mkdir("");
    2f60:	c7 04 24 96 57 00 00 	movl   $0x5796,(%esp)
    2f67:	e8 ec 0f 00 00       	call   3f58 <mkdir>
    link("README", "");
    2f6c:	c7 44 24 04 96 57 00 	movl   $0x5796,0x4(%esp)
    2f73:	00 
    2f74:	c7 04 24 d5 56 00 00 	movl   $0x56d5,(%esp)
    2f7b:	e8 d0 0f 00 00       	call   3f50 <link>
    fd = open("", O_CREATE);
    2f80:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2f87:	00 
    2f88:	c7 04 24 96 57 00 00 	movl   $0x5796,(%esp)
    2f8f:	e8 9c 0f 00 00       	call   3f30 <open>
    2f94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2f97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2f9b:	78 0b                	js     2fa8 <iref+0xc0>
      close(fd);
    2f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2fa0:	89 04 24             	mov    %eax,(%esp)
    2fa3:	e8 70 0f 00 00       	call   3f18 <close>
    fd = open("xx", O_CREATE);
    2fa8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2faf:	00 
    2fb0:	c7 04 24 97 57 00 00 	movl   $0x5797,(%esp)
    2fb7:	e8 74 0f 00 00       	call   3f30 <open>
    2fbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fc3:	78 0b                	js     2fd0 <iref+0xe8>
      close(fd);
    2fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2fc8:	89 04 24             	mov    %eax,(%esp)
    2fcb:	e8 48 0f 00 00       	call   3f18 <close>
    unlink("xx");
    2fd0:	c7 04 24 97 57 00 00 	movl   $0x5797,(%esp)
    2fd7:	e8 64 0f 00 00       	call   3f40 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2fdc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2fe0:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2fe4:	0f 8e 24 ff ff ff    	jle    2f0e <iref+0x26>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2fea:	c7 04 24 9e 44 00 00 	movl   $0x449e,(%esp)
    2ff1:	e8 6a 0f 00 00       	call   3f60 <chdir>
  printf(1, "empty file name OK\n");
    2ff6:	c7 44 24 04 9a 57 00 	movl   $0x579a,0x4(%esp)
    2ffd:	00 
    2ffe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3005:	e8 5d 10 00 00       	call   4067 <printf>
}
    300a:	c9                   	leave  
    300b:	c3                   	ret    

0000300c <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    300c:	55                   	push   %ebp
    300d:	89 e5                	mov    %esp,%ebp
    300f:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    3012:	c7 44 24 04 ae 57 00 	movl   $0x57ae,0x4(%esp)
    3019:	00 
    301a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3021:	e8 41 10 00 00       	call   4067 <printf>

  for(n=0; n<1000; n++){
    3026:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    302d:	eb 1d                	jmp    304c <forktest+0x40>
    pid = fork();
    302f:	e8 b4 0e 00 00       	call   3ee8 <fork>
    3034:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    3037:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    303b:	78 1a                	js     3057 <forktest+0x4b>
      break;
    if(pid == 0)
    303d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3041:	75 05                	jne    3048 <forktest+0x3c>
      exit();
    3043:	e8 a8 0e 00 00       	call   3ef0 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    3048:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    304c:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    3053:	7e da                	jle    302f <forktest+0x23>
    3055:	eb 01                	jmp    3058 <forktest+0x4c>
    pid = fork();
    if(pid < 0)
      break;
    3057:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    3058:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    305f:	75 3f                	jne    30a0 <forktest+0x94>
    printf(1, "fork claimed to work 1000 times!\n");
    3061:	c7 44 24 04 bc 57 00 	movl   $0x57bc,0x4(%esp)
    3068:	00 
    3069:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3070:	e8 f2 0f 00 00       	call   4067 <printf>
    exit();
    3075:	e8 76 0e 00 00       	call   3ef0 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    307a:	e8 79 0e 00 00       	call   3ef8 <wait>
    307f:	85 c0                	test   %eax,%eax
    3081:	79 19                	jns    309c <forktest+0x90>
      printf(1, "wait stopped early\n");
    3083:	c7 44 24 04 de 57 00 	movl   $0x57de,0x4(%esp)
    308a:	00 
    308b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3092:	e8 d0 0f 00 00       	call   4067 <printf>
      exit();
    3097:	e8 54 0e 00 00       	call   3ef0 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    309c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30a4:	7f d4                	jg     307a <forktest+0x6e>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    30a6:	e8 4d 0e 00 00       	call   3ef8 <wait>
    30ab:	83 f8 ff             	cmp    $0xffffffff,%eax
    30ae:	74 19                	je     30c9 <forktest+0xbd>
    printf(1, "wait got too many\n");
    30b0:	c7 44 24 04 f2 57 00 	movl   $0x57f2,0x4(%esp)
    30b7:	00 
    30b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30bf:	e8 a3 0f 00 00       	call   4067 <printf>
    exit();
    30c4:	e8 27 0e 00 00       	call   3ef0 <exit>
  }
  
  printf(1, "fork test OK\n");
    30c9:	c7 44 24 04 05 58 00 	movl   $0x5805,0x4(%esp)
    30d0:	00 
    30d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30d8:	e8 8a 0f 00 00       	call   4067 <printf>
}
    30dd:	c9                   	leave  
    30de:	c3                   	ret    

000030df <sbrktest>:

void
sbrktest(void)
{
    30df:	55                   	push   %ebp
    30e0:	89 e5                	mov    %esp,%ebp
    30e2:	53                   	push   %ebx
    30e3:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    30e9:	a1 18 63 00 00       	mov    0x6318,%eax
    30ee:	c7 44 24 04 13 58 00 	movl   $0x5813,0x4(%esp)
    30f5:	00 
    30f6:	89 04 24             	mov    %eax,(%esp)
    30f9:	e8 69 0f 00 00       	call   4067 <printf>
  oldbrk = sbrk(0);
    30fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3105:	e8 6e 0e 00 00       	call   3f78 <sbrk>
    310a:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  printf(2,"sbrking once with size 0.\n");
    310d:	c7 44 24 04 1e 58 00 	movl   $0x581e,0x4(%esp)
    3114:	00 
    3115:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    311c:	e8 46 0f 00 00       	call   4067 <printf>
  a = sbrk(0);
    3121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3128:	e8 4b 0e 00 00       	call   3f78 <sbrk>
    312d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 50; i++){ 
    3130:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3137:	eb 74                	jmp    31ad <sbrktest+0xce>
    printf(2,"sbrk number %d.\n",i);
    3139:	8b 45 f0             	mov    -0x10(%ebp),%eax
    313c:	89 44 24 08          	mov    %eax,0x8(%esp)
    3140:	c7 44 24 04 39 58 00 	movl   $0x5839,0x4(%esp)
    3147:	00 
    3148:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    314f:	e8 13 0f 00 00       	call   4067 <printf>
    b = sbrk(1);
    3154:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    315b:	e8 18 0e 00 00       	call   3f78 <sbrk>
    3160:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    3163:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3166:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3169:	74 2f                	je     319a <sbrktest+0xbb>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    316b:	a1 18 63 00 00       	mov    0x6318,%eax
    3170:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3173:	89 54 24 10          	mov    %edx,0x10(%esp)
    3177:	8b 55 f4             	mov    -0xc(%ebp),%edx
    317a:	89 54 24 0c          	mov    %edx,0xc(%esp)
    317e:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3181:	89 54 24 08          	mov    %edx,0x8(%esp)
    3185:	c7 44 24 04 4a 58 00 	movl   $0x584a,0x4(%esp)
    318c:	00 
    318d:	89 04 24             	mov    %eax,(%esp)
    3190:	e8 d2 0e 00 00       	call   4067 <printf>
      exit();
    3195:	e8 56 0d 00 00       	call   3ef0 <exit>
    }
    *b = 1;
    319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    319d:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    31a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    31a3:	83 c0 01             	add    $0x1,%eax
    31a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // can one sbrk() less than a page?
  printf(2,"sbrking once with size 0.\n");
  a = sbrk(0);
  int i;
  for(i = 0; i < 50; i++){ 
    31a9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    31ad:	83 7d f0 31          	cmpl   $0x31,-0x10(%ebp)
    31b1:	7e 86                	jle    3139 <sbrktest+0x5a>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    31b3:	e8 30 0d 00 00       	call   3ee8 <fork>
    31b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    31bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    31bf:	79 1a                	jns    31db <sbrktest+0xfc>
    printf(stdout, "sbrk test fork failed\n");
    31c1:	a1 18 63 00 00       	mov    0x6318,%eax
    31c6:	c7 44 24 04 65 58 00 	movl   $0x5865,0x4(%esp)
    31cd:	00 
    31ce:	89 04 24             	mov    %eax,(%esp)
    31d1:	e8 91 0e 00 00       	call   4067 <printf>
    exit();
    31d6:	e8 15 0d 00 00       	call   3ef0 <exit>
  }
  c = sbrk(1);
    31db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31e2:	e8 91 0d 00 00       	call   3f78 <sbrk>
    31e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    31ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31f1:	e8 82 0d 00 00       	call   3f78 <sbrk>
    31f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    31f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31fc:	83 c0 01             	add    $0x1,%eax
    31ff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3202:	74 1a                	je     321e <sbrktest+0x13f>
    printf(stdout, "sbrk test failed post-fork\n");
    3204:	a1 18 63 00 00       	mov    0x6318,%eax
    3209:	c7 44 24 04 7c 58 00 	movl   $0x587c,0x4(%esp)
    3210:	00 
    3211:	89 04 24             	mov    %eax,(%esp)
    3214:	e8 4e 0e 00 00       	call   4067 <printf>
    exit();
    3219:	e8 d2 0c 00 00       	call   3ef0 <exit>
  }
  if(pid == 0)
    321e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3222:	75 05                	jne    3229 <sbrktest+0x14a>
    exit();
    3224:	e8 c7 0c 00 00       	call   3ef0 <exit>
  wait();
    3229:	e8 ca 0c 00 00       	call   3ef8 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    322e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3235:	e8 3e 0d 00 00       	call   3f78 <sbrk>
    323a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3240:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3245:	89 d1                	mov    %edx,%ecx
    3247:	29 c1                	sub    %eax,%ecx
    3249:	89 c8                	mov    %ecx,%eax
    324b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    324e:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3251:	89 04 24             	mov    %eax,(%esp)
    3254:	e8 1f 0d 00 00       	call   3f78 <sbrk>
    3259:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    325c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    325f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3262:	74 1a                	je     327e <sbrktest+0x19f>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3264:	a1 18 63 00 00       	mov    0x6318,%eax
    3269:	c7 44 24 04 98 58 00 	movl   $0x5898,0x4(%esp)
    3270:	00 
    3271:	89 04 24             	mov    %eax,(%esp)
    3274:	e8 ee 0d 00 00       	call   4067 <printf>
    exit();
    3279:	e8 72 0c 00 00       	call   3ef0 <exit>
  }
  lastaddr = (char*) (BIG-1);
    327e:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    3285:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3288:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    328b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3292:	e8 e1 0c 00 00       	call   3f78 <sbrk>
    3297:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    329a:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    32a1:	e8 d2 0c 00 00       	call   3f78 <sbrk>
    32a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    32a9:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    32ad:	75 1a                	jne    32c9 <sbrktest+0x1ea>
    printf(stdout, "sbrk could not deallocate\n");
    32af:	a1 18 63 00 00       	mov    0x6318,%eax
    32b4:	c7 44 24 04 d6 58 00 	movl   $0x58d6,0x4(%esp)
    32bb:	00 
    32bc:	89 04 24             	mov    %eax,(%esp)
    32bf:	e8 a3 0d 00 00       	call   4067 <printf>
    exit();
    32c4:	e8 27 0c 00 00       	call   3ef0 <exit>
  }
  c = sbrk(0);
    32c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32d0:	e8 a3 0c 00 00       	call   3f78 <sbrk>
    32d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    32d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32db:	2d 00 10 00 00       	sub    $0x1000,%eax
    32e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    32e3:	74 28                	je     330d <sbrktest+0x22e>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32e5:	a1 18 63 00 00       	mov    0x6318,%eax
    32ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
    32ed:	89 54 24 0c          	mov    %edx,0xc(%esp)
    32f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    32f4:	89 54 24 08          	mov    %edx,0x8(%esp)
    32f8:	c7 44 24 04 f4 58 00 	movl   $0x58f4,0x4(%esp)
    32ff:	00 
    3300:	89 04 24             	mov    %eax,(%esp)
    3303:	e8 5f 0d 00 00       	call   4067 <printf>
    exit();
    3308:	e8 e3 0b 00 00       	call   3ef0 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    330d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3314:	e8 5f 0c 00 00       	call   3f78 <sbrk>
    3319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    331c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3323:	e8 50 0c 00 00       	call   3f78 <sbrk>
    3328:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    332b:	8b 45 e0             	mov    -0x20(%ebp),%eax
    332e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3331:	75 19                	jne    334c <sbrktest+0x26d>
    3333:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    333a:	e8 39 0c 00 00       	call   3f78 <sbrk>
    333f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3342:	81 c2 00 10 00 00    	add    $0x1000,%edx
    3348:	39 d0                	cmp    %edx,%eax
    334a:	74 28                	je     3374 <sbrktest+0x295>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    334c:	a1 18 63 00 00       	mov    0x6318,%eax
    3351:	8b 55 e0             	mov    -0x20(%ebp),%edx
    3354:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3358:	8b 55 f4             	mov    -0xc(%ebp),%edx
    335b:	89 54 24 08          	mov    %edx,0x8(%esp)
    335f:	c7 44 24 04 2c 59 00 	movl   $0x592c,0x4(%esp)
    3366:	00 
    3367:	89 04 24             	mov    %eax,(%esp)
    336a:	e8 f8 0c 00 00       	call   4067 <printf>
    exit();
    336f:	e8 7c 0b 00 00       	call   3ef0 <exit>
  }
  if(*lastaddr == 99){
    3374:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3377:	0f b6 00             	movzbl (%eax),%eax
    337a:	3c 63                	cmp    $0x63,%al
    337c:	75 1a                	jne    3398 <sbrktest+0x2b9>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    337e:	a1 18 63 00 00       	mov    0x6318,%eax
    3383:	c7 44 24 04 54 59 00 	movl   $0x5954,0x4(%esp)
    338a:	00 
    338b:	89 04 24             	mov    %eax,(%esp)
    338e:	e8 d4 0c 00 00       	call   4067 <printf>
    exit();
    3393:	e8 58 0b 00 00       	call   3ef0 <exit>
  }

  a = sbrk(0);
    3398:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    339f:	e8 d4 0b 00 00       	call   3f78 <sbrk>
    33a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    33a7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    33aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33b1:	e8 c2 0b 00 00       	call   3f78 <sbrk>
    33b6:	89 da                	mov    %ebx,%edx
    33b8:	29 c2                	sub    %eax,%edx
    33ba:	89 d0                	mov    %edx,%eax
    33bc:	89 04 24             	mov    %eax,(%esp)
    33bf:	e8 b4 0b 00 00       	call   3f78 <sbrk>
    33c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    33c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
    33ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33cd:	74 28                	je     33f7 <sbrktest+0x318>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33cf:	a1 18 63 00 00       	mov    0x6318,%eax
    33d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
    33d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
    33db:	8b 55 f4             	mov    -0xc(%ebp),%edx
    33de:	89 54 24 08          	mov    %edx,0x8(%esp)
    33e2:	c7 44 24 04 84 59 00 	movl   $0x5984,0x4(%esp)
    33e9:	00 
    33ea:	89 04 24             	mov    %eax,(%esp)
    33ed:	e8 75 0c 00 00       	call   4067 <printf>
    exit();
    33f2:	e8 f9 0a 00 00       	call   3ef0 <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33f7:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    33fe:	eb 7b                	jmp    347b <sbrktest+0x39c>
    ppid = getpid();
    3400:	e8 6b 0b 00 00       	call   3f70 <getpid>
    3405:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    3408:	e8 db 0a 00 00       	call   3ee8 <fork>
    340d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    3410:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3414:	79 1a                	jns    3430 <sbrktest+0x351>
      printf(stdout, "fork failed\n");
    3416:	a1 18 63 00 00       	mov    0x6318,%eax
    341b:	c7 44 24 04 cd 44 00 	movl   $0x44cd,0x4(%esp)
    3422:	00 
    3423:	89 04 24             	mov    %eax,(%esp)
    3426:	e8 3c 0c 00 00       	call   4067 <printf>
      exit();
    342b:	e8 c0 0a 00 00       	call   3ef0 <exit>
    }
    if(pid == 0){
    3430:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3434:	75 39                	jne    346f <sbrktest+0x390>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3436:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3439:	0f b6 00             	movzbl (%eax),%eax
    343c:	0f be d0             	movsbl %al,%edx
    343f:	a1 18 63 00 00       	mov    0x6318,%eax
    3444:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3448:	8b 55 f4             	mov    -0xc(%ebp),%edx
    344b:	89 54 24 08          	mov    %edx,0x8(%esp)
    344f:	c7 44 24 04 a5 59 00 	movl   $0x59a5,0x4(%esp)
    3456:	00 
    3457:	89 04 24             	mov    %eax,(%esp)
    345a:	e8 08 0c 00 00       	call   4067 <printf>
      kill(ppid);
    345f:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3462:	89 04 24             	mov    %eax,(%esp)
    3465:	e8 b6 0a 00 00       	call   3f20 <kill>
      exit();
    346a:	e8 81 0a 00 00       	call   3ef0 <exit>
    }
    wait();
    346f:	e8 84 0a 00 00       	call   3ef8 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3474:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    347b:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    3482:	0f 86 78 ff ff ff    	jbe    3400 <sbrktest+0x321>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    3488:	8d 45 c8             	lea    -0x38(%ebp),%eax
    348b:	89 04 24             	mov    %eax,(%esp)
    348e:	e8 6d 0a 00 00       	call   3f00 <pipe>
    3493:	85 c0                	test   %eax,%eax
    3495:	74 19                	je     34b0 <sbrktest+0x3d1>
    printf(1, "pipe() failed\n");
    3497:	c7 44 24 04 9e 48 00 	movl   $0x489e,0x4(%esp)
    349e:	00 
    349f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34a6:	e8 bc 0b 00 00       	call   4067 <printf>
    exit();
    34ab:	e8 40 0a 00 00       	call   3ef0 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    34b7:	e9 89 00 00 00       	jmp    3545 <sbrktest+0x466>
    if((pids[i] = fork()) == 0){
    34bc:	e8 27 0a 00 00       	call   3ee8 <fork>
    34c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    34c4:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    34c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34cb:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34cf:	85 c0                	test   %eax,%eax
    34d1:	75 48                	jne    351b <sbrktest+0x43c>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    34d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    34da:	e8 99 0a 00 00       	call   3f78 <sbrk>
    34df:	ba 00 00 40 06       	mov    $0x6400000,%edx
    34e4:	89 d1                	mov    %edx,%ecx
    34e6:	29 c1                	sub    %eax,%ecx
    34e8:	89 c8                	mov    %ecx,%eax
    34ea:	89 04 24             	mov    %eax,(%esp)
    34ed:	e8 86 0a 00 00       	call   3f78 <sbrk>
      write(fds[1], "x", 1);
    34f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
    34f5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    34fc:	00 
    34fd:	c7 44 24 04 03 49 00 	movl   $0x4903,0x4(%esp)
    3504:	00 
    3505:	89 04 24             	mov    %eax,(%esp)
    3508:	e8 03 0a 00 00       	call   3f10 <write>
      // sit around until killed
      for(;;) sleep(1000);
    350d:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    3514:	e8 67 0a 00 00       	call   3f80 <sleep>
    3519:	eb f2                	jmp    350d <sbrktest+0x42e>
    }
    if(pids[i] != -1)
    351b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    351e:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3522:	83 f8 ff             	cmp    $0xffffffff,%eax
    3525:	74 1a                	je     3541 <sbrktest+0x462>
      read(fds[0], &scratch, 1);
    3527:	8b 45 c8             	mov    -0x38(%ebp),%eax
    352a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3531:	00 
    3532:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3535:	89 54 24 04          	mov    %edx,0x4(%esp)
    3539:	89 04 24             	mov    %eax,(%esp)
    353c:	e8 c7 09 00 00       	call   3f08 <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3541:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3545:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3548:	83 f8 09             	cmp    $0x9,%eax
    354b:	0f 86 6b ff ff ff    	jbe    34bc <sbrktest+0x3dd>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3551:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3558:	e8 1b 0a 00 00       	call   3f78 <sbrk>
    355d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3567:	eb 27                	jmp    3590 <sbrktest+0x4b1>
    if(pids[i] == -1)
    3569:	8b 45 f0             	mov    -0x10(%ebp),%eax
    356c:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3570:	83 f8 ff             	cmp    $0xffffffff,%eax
    3573:	74 16                	je     358b <sbrktest+0x4ac>
      continue;
    kill(pids[i]);
    3575:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3578:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    357c:	89 04 24             	mov    %eax,(%esp)
    357f:	e8 9c 09 00 00       	call   3f20 <kill>
    wait();
    3584:	e8 6f 09 00 00       	call   3ef8 <wait>
    3589:	eb 01                	jmp    358c <sbrktest+0x4ad>
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
      continue;
    358b:	90                   	nop
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    358c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3590:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3593:	83 f8 09             	cmp    $0x9,%eax
    3596:	76 d1                	jbe    3569 <sbrktest+0x48a>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    3598:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    359c:	75 1a                	jne    35b8 <sbrktest+0x4d9>
    printf(stdout, "failed sbrk leaked memory\n");
    359e:	a1 18 63 00 00       	mov    0x6318,%eax
    35a3:	c7 44 24 04 be 59 00 	movl   $0x59be,0x4(%esp)
    35aa:	00 
    35ab:	89 04 24             	mov    %eax,(%esp)
    35ae:	e8 b4 0a 00 00       	call   4067 <printf>
    exit();
    35b3:	e8 38 09 00 00       	call   3ef0 <exit>
  }

  if(sbrk(0) > oldbrk)
    35b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35bf:	e8 b4 09 00 00       	call   3f78 <sbrk>
    35c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    35c7:	76 1d                	jbe    35e6 <sbrktest+0x507>
    sbrk(-(sbrk(0) - oldbrk));
    35c9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    35cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35d3:	e8 a0 09 00 00       	call   3f78 <sbrk>
    35d8:	89 da                	mov    %ebx,%edx
    35da:	29 c2                	sub    %eax,%edx
    35dc:	89 d0                	mov    %edx,%eax
    35de:	89 04 24             	mov    %eax,(%esp)
    35e1:	e8 92 09 00 00       	call   3f78 <sbrk>

  printf(stdout, "sbrk test OK\n");
    35e6:	a1 18 63 00 00       	mov    0x6318,%eax
    35eb:	c7 44 24 04 d9 59 00 	movl   $0x59d9,0x4(%esp)
    35f2:	00 
    35f3:	89 04 24             	mov    %eax,(%esp)
    35f6:	e8 6c 0a 00 00       	call   4067 <printf>
}
    35fb:	81 c4 84 00 00 00    	add    $0x84,%esp
    3601:	5b                   	pop    %ebx
    3602:	5d                   	pop    %ebp
    3603:	c3                   	ret    

00003604 <validateint>:

void
validateint(int *p)
{
    3604:	55                   	push   %ebp
    3605:	89 e5                	mov    %esp,%ebp
    3607:	56                   	push   %esi
    3608:	53                   	push   %ebx
    3609:	83 ec 14             	sub    $0x14,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    360c:	c7 45 e4 0d 00 00 00 	movl   $0xd,-0x1c(%ebp)
    3613:	8b 55 08             	mov    0x8(%ebp),%edx
    3616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3619:	89 d1                	mov    %edx,%ecx
    361b:	89 e3                	mov    %esp,%ebx
    361d:	89 cc                	mov    %ecx,%esp
    361f:	cd 40                	int    $0x40
    3621:	89 dc                	mov    %ebx,%esp
    3623:	89 c6                	mov    %eax,%esi
    3625:	89 75 f4             	mov    %esi,-0xc(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3628:	83 c4 14             	add    $0x14,%esp
    362b:	5b                   	pop    %ebx
    362c:	5e                   	pop    %esi
    362d:	5d                   	pop    %ebp
    362e:	c3                   	ret    

0000362f <validatetest>:

void
validatetest(void)
{
    362f:	55                   	push   %ebp
    3630:	89 e5                	mov    %esp,%ebp
    3632:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3635:	a1 18 63 00 00       	mov    0x6318,%eax
    363a:	c7 44 24 04 e7 59 00 	movl   $0x59e7,0x4(%esp)
    3641:	00 
    3642:	89 04 24             	mov    %eax,(%esp)
    3645:	e8 1d 0a 00 00       	call   4067 <printf>
  hi = 1100*1024;
    364a:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    3651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3658:	eb 7f                	jmp    36d9 <validatetest+0xaa>
    if((pid = fork()) == 0){
    365a:	e8 89 08 00 00       	call   3ee8 <fork>
    365f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3662:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3666:	75 10                	jne    3678 <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3668:	8b 45 f4             	mov    -0xc(%ebp),%eax
    366b:	89 04 24             	mov    %eax,(%esp)
    366e:	e8 91 ff ff ff       	call   3604 <validateint>
      exit();
    3673:	e8 78 08 00 00       	call   3ef0 <exit>
    }
    sleep(0);
    3678:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    367f:	e8 fc 08 00 00       	call   3f80 <sleep>
    sleep(0);
    3684:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    368b:	e8 f0 08 00 00       	call   3f80 <sleep>
    kill(pid);
    3690:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3693:	89 04 24             	mov    %eax,(%esp)
    3696:	e8 85 08 00 00       	call   3f20 <kill>
    wait();
    369b:	e8 58 08 00 00       	call   3ef8 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    36a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36a3:	89 44 24 04          	mov    %eax,0x4(%esp)
    36a7:	c7 04 24 f6 59 00 00 	movl   $0x59f6,(%esp)
    36ae:	e8 9d 08 00 00       	call   3f50 <link>
    36b3:	83 f8 ff             	cmp    $0xffffffff,%eax
    36b6:	74 1a                	je     36d2 <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    36b8:	a1 18 63 00 00       	mov    0x6318,%eax
    36bd:	c7 44 24 04 01 5a 00 	movl   $0x5a01,0x4(%esp)
    36c4:	00 
    36c5:	89 04 24             	mov    %eax,(%esp)
    36c8:	e8 9a 09 00 00       	call   4067 <printf>
      exit();
    36cd:	e8 1e 08 00 00       	call   3ef0 <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    36d2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    36dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    36df:	0f 83 75 ff ff ff    	jae    365a <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    36e5:	a1 18 63 00 00       	mov    0x6318,%eax
    36ea:	c7 44 24 04 1a 5a 00 	movl   $0x5a1a,0x4(%esp)
    36f1:	00 
    36f2:	89 04 24             	mov    %eax,(%esp)
    36f5:	e8 6d 09 00 00       	call   4067 <printf>
}
    36fa:	c9                   	leave  
    36fb:	c3                   	ret    

000036fc <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36fc:	55                   	push   %ebp
    36fd:	89 e5                	mov    %esp,%ebp
    36ff:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    3702:	a1 18 63 00 00       	mov    0x6318,%eax
    3707:	c7 44 24 04 27 5a 00 	movl   $0x5a27,0x4(%esp)
    370e:	00 
    370f:	89 04 24             	mov    %eax,(%esp)
    3712:	e8 50 09 00 00       	call   4067 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    3717:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    371e:	eb 2d                	jmp    374d <bsstest+0x51>
    if(uninit[i] != '\0'){
    3720:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3723:	05 e0 63 00 00       	add    $0x63e0,%eax
    3728:	0f b6 00             	movzbl (%eax),%eax
    372b:	84 c0                	test   %al,%al
    372d:	74 1a                	je     3749 <bsstest+0x4d>
      printf(stdout, "bss test failed\n");
    372f:	a1 18 63 00 00       	mov    0x6318,%eax
    3734:	c7 44 24 04 31 5a 00 	movl   $0x5a31,0x4(%esp)
    373b:	00 
    373c:	89 04 24             	mov    %eax,(%esp)
    373f:	e8 23 09 00 00       	call   4067 <printf>
      exit();
    3744:	e8 a7 07 00 00       	call   3ef0 <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    3749:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    374d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3750:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3755:	76 c9                	jbe    3720 <bsstest+0x24>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    3757:	a1 18 63 00 00       	mov    0x6318,%eax
    375c:	c7 44 24 04 42 5a 00 	movl   $0x5a42,0x4(%esp)
    3763:	00 
    3764:	89 04 24             	mov    %eax,(%esp)
    3767:	e8 fb 08 00 00       	call   4067 <printf>
}
    376c:	c9                   	leave  
    376d:	c3                   	ret    

0000376e <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    376e:	55                   	push   %ebp
    376f:	89 e5                	mov    %esp,%ebp
    3771:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3774:	c7 04 24 4f 5a 00 00 	movl   $0x5a4f,(%esp)
    377b:	e8 c0 07 00 00       	call   3f40 <unlink>
  pid = fork();
    3780:	e8 63 07 00 00       	call   3ee8 <fork>
    3785:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    378c:	0f 85 90 00 00 00    	jne    3822 <bigargtest+0xb4>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3792:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3799:	eb 12                	jmp    37ad <bigargtest+0x3f>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    379b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    379e:	c7 04 85 40 63 00 00 	movl   $0x5a5c,0x6340(,%eax,4)
    37a5:	5c 5a 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    37a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    37ad:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    37b1:	7e e8                	jle    379b <bigargtest+0x2d>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    37b3:	c7 05 bc 63 00 00 00 	movl   $0x0,0x63bc
    37ba:	00 00 00 
    printf(stdout, "bigarg test\n");
    37bd:	a1 18 63 00 00       	mov    0x6318,%eax
    37c2:	c7 44 24 04 39 5b 00 	movl   $0x5b39,0x4(%esp)
    37c9:	00 
    37ca:	89 04 24             	mov    %eax,(%esp)
    37cd:	e8 95 08 00 00       	call   4067 <printf>
    exec("echo", args);
    37d2:	c7 44 24 04 40 63 00 	movl   $0x6340,0x4(%esp)
    37d9:	00 
    37da:	c7 04 24 2c 44 00 00 	movl   $0x442c,(%esp)
    37e1:	e8 42 07 00 00       	call   3f28 <exec>
    printf(stdout, "bigarg test ok\n");
    37e6:	a1 18 63 00 00       	mov    0x6318,%eax
    37eb:	c7 44 24 04 46 5b 00 	movl   $0x5b46,0x4(%esp)
    37f2:	00 
    37f3:	89 04 24             	mov    %eax,(%esp)
    37f6:	e8 6c 08 00 00       	call   4067 <printf>
    fd = open("bigarg-ok", O_CREATE);
    37fb:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3802:	00 
    3803:	c7 04 24 4f 5a 00 00 	movl   $0x5a4f,(%esp)
    380a:	e8 21 07 00 00       	call   3f30 <open>
    380f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    3812:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3815:	89 04 24             	mov    %eax,(%esp)
    3818:	e8 fb 06 00 00       	call   3f18 <close>
    exit();
    381d:	e8 ce 06 00 00       	call   3ef0 <exit>
  } else if(pid < 0){
    3822:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3826:	79 1a                	jns    3842 <bigargtest+0xd4>
    printf(stdout, "bigargtest: fork failed\n");
    3828:	a1 18 63 00 00       	mov    0x6318,%eax
    382d:	c7 44 24 04 56 5b 00 	movl   $0x5b56,0x4(%esp)
    3834:	00 
    3835:	89 04 24             	mov    %eax,(%esp)
    3838:	e8 2a 08 00 00       	call   4067 <printf>
    exit();
    383d:	e8 ae 06 00 00       	call   3ef0 <exit>
  }
  wait();
    3842:	e8 b1 06 00 00       	call   3ef8 <wait>
  fd = open("bigarg-ok", 0);
    3847:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    384e:	00 
    384f:	c7 04 24 4f 5a 00 00 	movl   $0x5a4f,(%esp)
    3856:	e8 d5 06 00 00       	call   3f30 <open>
    385b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    385e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3862:	79 1a                	jns    387e <bigargtest+0x110>
    printf(stdout, "bigarg test failed!\n");
    3864:	a1 18 63 00 00       	mov    0x6318,%eax
    3869:	c7 44 24 04 6f 5b 00 	movl   $0x5b6f,0x4(%esp)
    3870:	00 
    3871:	89 04 24             	mov    %eax,(%esp)
    3874:	e8 ee 07 00 00       	call   4067 <printf>
    exit();
    3879:	e8 72 06 00 00       	call   3ef0 <exit>
  }
  close(fd);
    387e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3881:	89 04 24             	mov    %eax,(%esp)
    3884:	e8 8f 06 00 00       	call   3f18 <close>
  unlink("bigarg-ok");
    3889:	c7 04 24 4f 5a 00 00 	movl   $0x5a4f,(%esp)
    3890:	e8 ab 06 00 00       	call   3f40 <unlink>
}
    3895:	c9                   	leave  
    3896:	c3                   	ret    

00003897 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3897:	55                   	push   %ebp
    3898:	89 e5                	mov    %esp,%ebp
    389a:	53                   	push   %ebx
    389b:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    389e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    38a5:	c7 44 24 04 84 5b 00 	movl   $0x5b84,0x4(%esp)
    38ac:	00 
    38ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38b4:	e8 ae 07 00 00       	call   4067 <printf>

  for(nfiles = 0; ; nfiles++){
    38b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    38c0:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    38c4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38c7:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38cc:	89 c8                	mov    %ecx,%eax
    38ce:	f7 ea                	imul   %edx
    38d0:	c1 fa 06             	sar    $0x6,%edx
    38d3:	89 c8                	mov    %ecx,%eax
    38d5:	c1 f8 1f             	sar    $0x1f,%eax
    38d8:	89 d1                	mov    %edx,%ecx
    38da:	29 c1                	sub    %eax,%ecx
    38dc:	89 c8                	mov    %ecx,%eax
    38de:	83 c0 30             	add    $0x30,%eax
    38e1:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38e4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38e7:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38ec:	89 d8                	mov    %ebx,%eax
    38ee:	f7 ea                	imul   %edx
    38f0:	c1 fa 06             	sar    $0x6,%edx
    38f3:	89 d8                	mov    %ebx,%eax
    38f5:	c1 f8 1f             	sar    $0x1f,%eax
    38f8:	89 d1                	mov    %edx,%ecx
    38fa:	29 c1                	sub    %eax,%ecx
    38fc:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3902:	89 d9                	mov    %ebx,%ecx
    3904:	29 c1                	sub    %eax,%ecx
    3906:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    390b:	89 c8                	mov    %ecx,%eax
    390d:	f7 ea                	imul   %edx
    390f:	c1 fa 05             	sar    $0x5,%edx
    3912:	89 c8                	mov    %ecx,%eax
    3914:	c1 f8 1f             	sar    $0x1f,%eax
    3917:	89 d1                	mov    %edx,%ecx
    3919:	29 c1                	sub    %eax,%ecx
    391b:	89 c8                	mov    %ecx,%eax
    391d:	83 c0 30             	add    $0x30,%eax
    3920:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3923:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3926:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    392b:	89 d8                	mov    %ebx,%eax
    392d:	f7 ea                	imul   %edx
    392f:	c1 fa 05             	sar    $0x5,%edx
    3932:	89 d8                	mov    %ebx,%eax
    3934:	c1 f8 1f             	sar    $0x1f,%eax
    3937:	89 d1                	mov    %edx,%ecx
    3939:	29 c1                	sub    %eax,%ecx
    393b:	6b c1 64             	imul   $0x64,%ecx,%eax
    393e:	89 d9                	mov    %ebx,%ecx
    3940:	29 c1                	sub    %eax,%ecx
    3942:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3947:	89 c8                	mov    %ecx,%eax
    3949:	f7 ea                	imul   %edx
    394b:	c1 fa 02             	sar    $0x2,%edx
    394e:	89 c8                	mov    %ecx,%eax
    3950:	c1 f8 1f             	sar    $0x1f,%eax
    3953:	89 d1                	mov    %edx,%ecx
    3955:	29 c1                	sub    %eax,%ecx
    3957:	89 c8                	mov    %ecx,%eax
    3959:	83 c0 30             	add    $0x30,%eax
    395c:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    395f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3962:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3967:	89 c8                	mov    %ecx,%eax
    3969:	f7 ea                	imul   %edx
    396b:	c1 fa 02             	sar    $0x2,%edx
    396e:	89 c8                	mov    %ecx,%eax
    3970:	c1 f8 1f             	sar    $0x1f,%eax
    3973:	29 c2                	sub    %eax,%edx
    3975:	89 d0                	mov    %edx,%eax
    3977:	c1 e0 02             	shl    $0x2,%eax
    397a:	01 d0                	add    %edx,%eax
    397c:	01 c0                	add    %eax,%eax
    397e:	89 ca                	mov    %ecx,%edx
    3980:	29 c2                	sub    %eax,%edx
    3982:	89 d0                	mov    %edx,%eax
    3984:	83 c0 30             	add    $0x30,%eax
    3987:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    398a:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    398e:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3991:	89 44 24 08          	mov    %eax,0x8(%esp)
    3995:	c7 44 24 04 91 5b 00 	movl   $0x5b91,0x4(%esp)
    399c:	00 
    399d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39a4:	e8 be 06 00 00       	call   4067 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    39a9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    39b0:	00 
    39b1:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39b4:	89 04 24             	mov    %eax,(%esp)
    39b7:	e8 74 05 00 00       	call   3f30 <open>
    39bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    39bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    39c3:	79 1d                	jns    39e2 <fsfull+0x14b>
      printf(1, "open %s failed\n", name);
    39c5:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39c8:	89 44 24 08          	mov    %eax,0x8(%esp)
    39cc:	c7 44 24 04 9d 5b 00 	movl   $0x5b9d,0x4(%esp)
    39d3:	00 
    39d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39db:	e8 87 06 00 00       	call   4067 <printf>
      break;
    39e0:	eb 71                	jmp    3a53 <fsfull+0x1bc>
    }
    int total = 0;
    39e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39e9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    39f0:	00 
    39f1:	c7 44 24 04 00 8b 00 	movl   $0x8b00,0x4(%esp)
    39f8:	00 
    39f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    39fc:	89 04 24             	mov    %eax,(%esp)
    39ff:	e8 0c 05 00 00       	call   3f10 <write>
    3a04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3a07:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3a0e:	7e 0c                	jle    3a1c <fsfull+0x185>
        break;
      total += cc;
    3a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3a13:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3a16:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    3a1a:	eb cd                	jmp    39e9 <fsfull+0x152>
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
    3a1c:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    3a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3a20:	89 44 24 08          	mov    %eax,0x8(%esp)
    3a24:	c7 44 24 04 ad 5b 00 	movl   $0x5bad,0x4(%esp)
    3a2b:	00 
    3a2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a33:	e8 2f 06 00 00       	call   4067 <printf>
    close(fd);
    3a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3a3b:	89 04 24             	mov    %eax,(%esp)
    3a3e:	e8 d5 04 00 00       	call   3f18 <close>
    if(total == 0)
    3a43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3a47:	74 09                	je     3a52 <fsfull+0x1bb>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3a49:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3a4d:	e9 6e fe ff ff       	jmp    38c0 <fsfull+0x29>
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
    3a52:	90                   	nop
  }

  while(nfiles >= 0){
    3a53:	e9 dd 00 00 00       	jmp    3b35 <fsfull+0x29e>
    char name[64];
    name[0] = 'f';
    3a58:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a5c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a5f:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a64:	89 c8                	mov    %ecx,%eax
    3a66:	f7 ea                	imul   %edx
    3a68:	c1 fa 06             	sar    $0x6,%edx
    3a6b:	89 c8                	mov    %ecx,%eax
    3a6d:	c1 f8 1f             	sar    $0x1f,%eax
    3a70:	89 d1                	mov    %edx,%ecx
    3a72:	29 c1                	sub    %eax,%ecx
    3a74:	89 c8                	mov    %ecx,%eax
    3a76:	83 c0 30             	add    $0x30,%eax
    3a79:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a7c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a7f:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a84:	89 d8                	mov    %ebx,%eax
    3a86:	f7 ea                	imul   %edx
    3a88:	c1 fa 06             	sar    $0x6,%edx
    3a8b:	89 d8                	mov    %ebx,%eax
    3a8d:	c1 f8 1f             	sar    $0x1f,%eax
    3a90:	89 d1                	mov    %edx,%ecx
    3a92:	29 c1                	sub    %eax,%ecx
    3a94:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a9a:	89 d9                	mov    %ebx,%ecx
    3a9c:	29 c1                	sub    %eax,%ecx
    3a9e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3aa3:	89 c8                	mov    %ecx,%eax
    3aa5:	f7 ea                	imul   %edx
    3aa7:	c1 fa 05             	sar    $0x5,%edx
    3aaa:	89 c8                	mov    %ecx,%eax
    3aac:	c1 f8 1f             	sar    $0x1f,%eax
    3aaf:	89 d1                	mov    %edx,%ecx
    3ab1:	29 c1                	sub    %eax,%ecx
    3ab3:	89 c8                	mov    %ecx,%eax
    3ab5:	83 c0 30             	add    $0x30,%eax
    3ab8:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3abb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3abe:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3ac3:	89 d8                	mov    %ebx,%eax
    3ac5:	f7 ea                	imul   %edx
    3ac7:	c1 fa 05             	sar    $0x5,%edx
    3aca:	89 d8                	mov    %ebx,%eax
    3acc:	c1 f8 1f             	sar    $0x1f,%eax
    3acf:	89 d1                	mov    %edx,%ecx
    3ad1:	29 c1                	sub    %eax,%ecx
    3ad3:	6b c1 64             	imul   $0x64,%ecx,%eax
    3ad6:	89 d9                	mov    %ebx,%ecx
    3ad8:	29 c1                	sub    %eax,%ecx
    3ada:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3adf:	89 c8                	mov    %ecx,%eax
    3ae1:	f7 ea                	imul   %edx
    3ae3:	c1 fa 02             	sar    $0x2,%edx
    3ae6:	89 c8                	mov    %ecx,%eax
    3ae8:	c1 f8 1f             	sar    $0x1f,%eax
    3aeb:	89 d1                	mov    %edx,%ecx
    3aed:	29 c1                	sub    %eax,%ecx
    3aef:	89 c8                	mov    %ecx,%eax
    3af1:	83 c0 30             	add    $0x30,%eax
    3af4:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3af7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3afa:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3aff:	89 c8                	mov    %ecx,%eax
    3b01:	f7 ea                	imul   %edx
    3b03:	c1 fa 02             	sar    $0x2,%edx
    3b06:	89 c8                	mov    %ecx,%eax
    3b08:	c1 f8 1f             	sar    $0x1f,%eax
    3b0b:	29 c2                	sub    %eax,%edx
    3b0d:	89 d0                	mov    %edx,%eax
    3b0f:	c1 e0 02             	shl    $0x2,%eax
    3b12:	01 d0                	add    %edx,%eax
    3b14:	01 c0                	add    %eax,%eax
    3b16:	89 ca                	mov    %ecx,%edx
    3b18:	29 c2                	sub    %eax,%edx
    3b1a:	89 d0                	mov    %edx,%eax
    3b1c:	83 c0 30             	add    $0x30,%eax
    3b1f:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3b22:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3b26:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3b29:	89 04 24             	mov    %eax,(%esp)
    3b2c:	e8 0f 04 00 00       	call   3f40 <unlink>
    nfiles--;
    3b31:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b39:	0f 89 19 ff ff ff    	jns    3a58 <fsfull+0x1c1>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3b3f:	c7 44 24 04 bd 5b 00 	movl   $0x5bbd,0x4(%esp)
    3b46:	00 
    3b47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b4e:	e8 14 05 00 00       	call   4067 <printf>
}
    3b53:	83 c4 74             	add    $0x74,%esp
    3b56:	5b                   	pop    %ebx
    3b57:	5d                   	pop    %ebp
    3b58:	c3                   	ret    

00003b59 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3b59:	55                   	push   %ebp
    3b5a:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3b5c:	a1 1c 63 00 00       	mov    0x631c,%eax
    3b61:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3b67:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3b6c:	a3 1c 63 00 00       	mov    %eax,0x631c
  return randstate;
    3b71:	a1 1c 63 00 00       	mov    0x631c,%eax
}
    3b76:	5d                   	pop    %ebp
    3b77:	c3                   	ret    

00003b78 <main>:

int
main(int argc, char *argv[])
{
    3b78:	55                   	push   %ebp
    3b79:	89 e5                	mov    %esp,%ebp
    3b7b:	83 e4 f0             	and    $0xfffffff0,%esp
    3b7e:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    3b81:	c7 44 24 04 d3 5b 00 	movl   $0x5bd3,0x4(%esp)
    3b88:	00 
    3b89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b90:	e8 d2 04 00 00       	call   4067 <printf>

  if(open("usertests.ran", 0) >= 0){
    3b95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3b9c:	00 
    3b9d:	c7 04 24 e7 5b 00 00 	movl   $0x5be7,(%esp)
    3ba4:	e8 87 03 00 00       	call   3f30 <open>
    3ba9:	85 c0                	test   %eax,%eax
    3bab:	78 19                	js     3bc6 <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3bad:	c7 44 24 04 f8 5b 00 	movl   $0x5bf8,0x4(%esp)
    3bb4:	00 
    3bb5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3bbc:	e8 a6 04 00 00       	call   4067 <printf>
    exit();
    3bc1:	e8 2a 03 00 00       	call   3ef0 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3bc6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3bcd:	00 
    3bce:	c7 04 24 e7 5b 00 00 	movl   $0x5be7,(%esp)
    3bd5:	e8 56 03 00 00       	call   3f30 <open>
    3bda:	89 04 24             	mov    %eax,(%esp)
    3bdd:	e8 36 03 00 00       	call   3f18 <close>

  createdelete();
    3be2:	e8 96 d6 ff ff       	call   127d <createdelete>
  linkunlink();
    3be7:	e8 d8 e0 ff ff       	call   1cc4 <linkunlink>
  concreate();
    3bec:	e8 22 dd ff ff       	call   1913 <concreate>
  fourfiles();
    3bf1:	e8 1f d4 ff ff       	call   1015 <fourfiles>
  sharedfd();
    3bf6:	e8 20 d2 ff ff       	call   e1b <sharedfd>

  bigargtest();
    3bfb:	e8 6e fb ff ff       	call   376e <bigargtest>
  bigwrite();
    3c00:	e8 a6 ea ff ff       	call   26ab <bigwrite>
  bigargtest();
    3c05:	e8 64 fb ff ff       	call   376e <bigargtest>
  bsstest();
    3c0a:	e8 ed fa ff ff       	call   36fc <bsstest>
  sbrktest();
    3c0f:	e8 cb f4 ff ff       	call   30df <sbrktest>
  validatetest();
    3c14:	e8 16 fa ff ff       	call   362f <validatetest>

  opentest();
    3c19:	e8 a9 c6 ff ff       	call   2c7 <opentest>
  writetest();
    3c1e:	e8 4f c7 ff ff       	call   372 <writetest>
  writetest1();
    3c23:	e8 5f c9 ff ff       	call   587 <writetest1>
  createtest();
    3c28:	e8 63 cb ff ff       	call   790 <createtest>

  openiputtest();
    3c2d:	e8 94 c5 ff ff       	call   1c6 <openiputtest>
  exitiputtest();
    3c32:	e8 a3 c4 ff ff       	call   da <exitiputtest>
  iputtest();
    3c37:	e8 c4 c3 ff ff       	call   0 <iputtest>

  mem();
    3c3c:	e8 f5 d0 ff ff       	call   d36 <mem>
  pipe1();
    3c41:	e8 2b cd ff ff       	call   971 <pipe1>
  preempt();
    3c46:	e8 14 cf ff ff       	call   b5f <preempt>
  exitwait();
    3c4b:	e8 68 d0 ff ff       	call   cb8 <exitwait>

  rmdot();
    3c50:	e8 d9 ee ff ff       	call   2b2e <rmdot>
  fourteen();
    3c55:	e8 7e ed ff ff       	call   29d8 <fourteen>
  bigfile();
    3c5a:	e8 54 eb ff ff       	call   27b3 <bigfile>
  subdir();
    3c5f:	e8 01 e3 ff ff       	call   1f65 <subdir>
  linktest();
    3c64:	e8 61 da ff ff       	call   16ca <linktest>
  unlinkread();
    3c69:	e8 87 d8 ff ff       	call   14f5 <unlinkread>
  dirfile();
    3c6e:	e8 33 f0 ff ff       	call   2ca6 <dirfile>
  iref();
    3c73:	e8 70 f2 ff ff       	call   2ee8 <iref>
  forktest();
    3c78:	e8 8f f3 ff ff       	call   300c <forktest>
  bigdir(); // slow
    3c7d:	e8 6e e1 ff ff       	call   1df0 <bigdir>
  exectest();
    3c82:	e8 9b cc ff ff       	call   922 <exectest>

  exit();
    3c87:	e8 64 02 00 00       	call   3ef0 <exit>

00003c8c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3c8c:	55                   	push   %ebp
    3c8d:	89 e5                	mov    %esp,%ebp
    3c8f:	57                   	push   %edi
    3c90:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3c91:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3c94:	8b 55 10             	mov    0x10(%ebp),%edx
    3c97:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c9a:	89 cb                	mov    %ecx,%ebx
    3c9c:	89 df                	mov    %ebx,%edi
    3c9e:	89 d1                	mov    %edx,%ecx
    3ca0:	fc                   	cld    
    3ca1:	f3 aa                	rep stos %al,%es:(%edi)
    3ca3:	89 ca                	mov    %ecx,%edx
    3ca5:	89 fb                	mov    %edi,%ebx
    3ca7:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3caa:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3cad:	5b                   	pop    %ebx
    3cae:	5f                   	pop    %edi
    3caf:	5d                   	pop    %ebp
    3cb0:	c3                   	ret    

00003cb1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3cb1:	55                   	push   %ebp
    3cb2:	89 e5                	mov    %esp,%ebp
    3cb4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3cb7:	8b 45 08             	mov    0x8(%ebp),%eax
    3cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3cbd:	90                   	nop
    3cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cc1:	0f b6 10             	movzbl (%eax),%edx
    3cc4:	8b 45 08             	mov    0x8(%ebp),%eax
    3cc7:	88 10                	mov    %dl,(%eax)
    3cc9:	8b 45 08             	mov    0x8(%ebp),%eax
    3ccc:	0f b6 00             	movzbl (%eax),%eax
    3ccf:	84 c0                	test   %al,%al
    3cd1:	0f 95 c0             	setne  %al
    3cd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3cd8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    3cdc:	84 c0                	test   %al,%al
    3cde:	75 de                	jne    3cbe <strcpy+0xd>
    ;
  return os;
    3ce0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3ce3:	c9                   	leave  
    3ce4:	c3                   	ret    

00003ce5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3ce5:	55                   	push   %ebp
    3ce6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3ce8:	eb 08                	jmp    3cf2 <strcmp+0xd>
    p++, q++;
    3cea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3cee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3cf2:	8b 45 08             	mov    0x8(%ebp),%eax
    3cf5:	0f b6 00             	movzbl (%eax),%eax
    3cf8:	84 c0                	test   %al,%al
    3cfa:	74 10                	je     3d0c <strcmp+0x27>
    3cfc:	8b 45 08             	mov    0x8(%ebp),%eax
    3cff:	0f b6 10             	movzbl (%eax),%edx
    3d02:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d05:	0f b6 00             	movzbl (%eax),%eax
    3d08:	38 c2                	cmp    %al,%dl
    3d0a:	74 de                	je     3cea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3d0c:	8b 45 08             	mov    0x8(%ebp),%eax
    3d0f:	0f b6 00             	movzbl (%eax),%eax
    3d12:	0f b6 d0             	movzbl %al,%edx
    3d15:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d18:	0f b6 00             	movzbl (%eax),%eax
    3d1b:	0f b6 c0             	movzbl %al,%eax
    3d1e:	89 d1                	mov    %edx,%ecx
    3d20:	29 c1                	sub    %eax,%ecx
    3d22:	89 c8                	mov    %ecx,%eax
}
    3d24:	5d                   	pop    %ebp
    3d25:	c3                   	ret    

00003d26 <strlen>:

uint
strlen(char *s)
{
    3d26:	55                   	push   %ebp
    3d27:	89 e5                	mov    %esp,%ebp
    3d29:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3d2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3d33:	eb 04                	jmp    3d39 <strlen+0x13>
    3d35:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3d3c:	03 45 08             	add    0x8(%ebp),%eax
    3d3f:	0f b6 00             	movzbl (%eax),%eax
    3d42:	84 c0                	test   %al,%al
    3d44:	75 ef                	jne    3d35 <strlen+0xf>
    ;
  return n;
    3d46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3d49:	c9                   	leave  
    3d4a:	c3                   	ret    

00003d4b <memset>:

void*
memset(void *dst, int c, uint n)
{
    3d4b:	55                   	push   %ebp
    3d4c:	89 e5                	mov    %esp,%ebp
    3d4e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3d51:	8b 45 10             	mov    0x10(%ebp),%eax
    3d54:	89 44 24 08          	mov    %eax,0x8(%esp)
    3d58:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d5f:	8b 45 08             	mov    0x8(%ebp),%eax
    3d62:	89 04 24             	mov    %eax,(%esp)
    3d65:	e8 22 ff ff ff       	call   3c8c <stosb>
  return dst;
    3d6a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3d6d:	c9                   	leave  
    3d6e:	c3                   	ret    

00003d6f <strchr>:

char*
strchr(const char *s, char c)
{
    3d6f:	55                   	push   %ebp
    3d70:	89 e5                	mov    %esp,%ebp
    3d72:	83 ec 04             	sub    $0x4,%esp
    3d75:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d78:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3d7b:	eb 14                	jmp    3d91 <strchr+0x22>
    if(*s == c)
    3d7d:	8b 45 08             	mov    0x8(%ebp),%eax
    3d80:	0f b6 00             	movzbl (%eax),%eax
    3d83:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3d86:	75 05                	jne    3d8d <strchr+0x1e>
      return (char*)s;
    3d88:	8b 45 08             	mov    0x8(%ebp),%eax
    3d8b:	eb 13                	jmp    3da0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3d8d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3d91:	8b 45 08             	mov    0x8(%ebp),%eax
    3d94:	0f b6 00             	movzbl (%eax),%eax
    3d97:	84 c0                	test   %al,%al
    3d99:	75 e2                	jne    3d7d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3da0:	c9                   	leave  
    3da1:	c3                   	ret    

00003da2 <gets>:

char*
gets(char *buf, int max)
{
    3da2:	55                   	push   %ebp
    3da3:	89 e5                	mov    %esp,%ebp
    3da5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3da8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3daf:	eb 44                	jmp    3df5 <gets+0x53>
    cc = read(0, &c, 1);
    3db1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3db8:	00 
    3db9:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3dbc:	89 44 24 04          	mov    %eax,0x4(%esp)
    3dc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3dc7:	e8 3c 01 00 00       	call   3f08 <read>
    3dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3dcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3dd3:	7e 2d                	jle    3e02 <gets+0x60>
      break;
    buf[i++] = c;
    3dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dd8:	03 45 08             	add    0x8(%ebp),%eax
    3ddb:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
    3ddf:	88 10                	mov    %dl,(%eax)
    3de1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
    3de5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3de9:	3c 0a                	cmp    $0xa,%al
    3deb:	74 16                	je     3e03 <gets+0x61>
    3ded:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3df1:	3c 0d                	cmp    $0xd,%al
    3df3:	74 0e                	je     3e03 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3df8:	83 c0 01             	add    $0x1,%eax
    3dfb:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3dfe:	7c b1                	jl     3db1 <gets+0xf>
    3e00:	eb 01                	jmp    3e03 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    3e02:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e06:	03 45 08             	add    0x8(%ebp),%eax
    3e09:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3e0f:	c9                   	leave  
    3e10:	c3                   	ret    

00003e11 <stat>:

int
stat(char *n, struct stat *st)
{
    3e11:	55                   	push   %ebp
    3e12:	89 e5                	mov    %esp,%ebp
    3e14:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3e17:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3e1e:	00 
    3e1f:	8b 45 08             	mov    0x8(%ebp),%eax
    3e22:	89 04 24             	mov    %eax,(%esp)
    3e25:	e8 06 01 00 00       	call   3f30 <open>
    3e2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3e2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3e31:	79 07                	jns    3e3a <stat+0x29>
    return -1;
    3e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3e38:	eb 23                	jmp    3e5d <stat+0x4c>
  r = fstat(fd, st);
    3e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e44:	89 04 24             	mov    %eax,(%esp)
    3e47:	e8 fc 00 00 00       	call   3f48 <fstat>
    3e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e52:	89 04 24             	mov    %eax,(%esp)
    3e55:	e8 be 00 00 00       	call   3f18 <close>
  return r;
    3e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3e5d:	c9                   	leave  
    3e5e:	c3                   	ret    

00003e5f <atoi>:

int
atoi(const char *s)
{
    3e5f:	55                   	push   %ebp
    3e60:	89 e5                	mov    %esp,%ebp
    3e62:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e6c:	eb 23                	jmp    3e91 <atoi+0x32>
    n = n*10 + *s++ - '0';
    3e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e71:	89 d0                	mov    %edx,%eax
    3e73:	c1 e0 02             	shl    $0x2,%eax
    3e76:	01 d0                	add    %edx,%eax
    3e78:	01 c0                	add    %eax,%eax
    3e7a:	89 c2                	mov    %eax,%edx
    3e7c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e7f:	0f b6 00             	movzbl (%eax),%eax
    3e82:	0f be c0             	movsbl %al,%eax
    3e85:	01 d0                	add    %edx,%eax
    3e87:	83 e8 30             	sub    $0x30,%eax
    3e8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3e8d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3e91:	8b 45 08             	mov    0x8(%ebp),%eax
    3e94:	0f b6 00             	movzbl (%eax),%eax
    3e97:	3c 2f                	cmp    $0x2f,%al
    3e99:	7e 0a                	jle    3ea5 <atoi+0x46>
    3e9b:	8b 45 08             	mov    0x8(%ebp),%eax
    3e9e:	0f b6 00             	movzbl (%eax),%eax
    3ea1:	3c 39                	cmp    $0x39,%al
    3ea3:	7e c9                	jle    3e6e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3ea8:	c9                   	leave  
    3ea9:	c3                   	ret    

00003eaa <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3eaa:	55                   	push   %ebp
    3eab:	89 e5                	mov    %esp,%ebp
    3ead:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3eb0:	8b 45 08             	mov    0x8(%ebp),%eax
    3eb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
    3eb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3ebc:	eb 13                	jmp    3ed1 <memmove+0x27>
    *dst++ = *src++;
    3ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3ec1:	0f b6 10             	movzbl (%eax),%edx
    3ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ec7:	88 10                	mov    %dl,(%eax)
    3ec9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3ecd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3ed1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    3ed5:	0f 9f c0             	setg   %al
    3ed8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    3edc:	84 c0                	test   %al,%al
    3ede:	75 de                	jne    3ebe <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3ee0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3ee3:	c9                   	leave  
    3ee4:	c3                   	ret    
    3ee5:	90                   	nop
    3ee6:	90                   	nop
    3ee7:	90                   	nop

00003ee8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3ee8:	b8 01 00 00 00       	mov    $0x1,%eax
    3eed:	cd 40                	int    $0x40
    3eef:	c3                   	ret    

00003ef0 <exit>:
SYSCALL(exit)
    3ef0:	b8 02 00 00 00       	mov    $0x2,%eax
    3ef5:	cd 40                	int    $0x40
    3ef7:	c3                   	ret    

00003ef8 <wait>:
SYSCALL(wait)
    3ef8:	b8 03 00 00 00       	mov    $0x3,%eax
    3efd:	cd 40                	int    $0x40
    3eff:	c3                   	ret    

00003f00 <pipe>:
SYSCALL(pipe)
    3f00:	b8 04 00 00 00       	mov    $0x4,%eax
    3f05:	cd 40                	int    $0x40
    3f07:	c3                   	ret    

00003f08 <read>:
SYSCALL(read)
    3f08:	b8 05 00 00 00       	mov    $0x5,%eax
    3f0d:	cd 40                	int    $0x40
    3f0f:	c3                   	ret    

00003f10 <write>:
SYSCALL(write)
    3f10:	b8 10 00 00 00       	mov    $0x10,%eax
    3f15:	cd 40                	int    $0x40
    3f17:	c3                   	ret    

00003f18 <close>:
SYSCALL(close)
    3f18:	b8 15 00 00 00       	mov    $0x15,%eax
    3f1d:	cd 40                	int    $0x40
    3f1f:	c3                   	ret    

00003f20 <kill>:
SYSCALL(kill)
    3f20:	b8 06 00 00 00       	mov    $0x6,%eax
    3f25:	cd 40                	int    $0x40
    3f27:	c3                   	ret    

00003f28 <exec>:
SYSCALL(exec)
    3f28:	b8 07 00 00 00       	mov    $0x7,%eax
    3f2d:	cd 40                	int    $0x40
    3f2f:	c3                   	ret    

00003f30 <open>:
SYSCALL(open)
    3f30:	b8 0f 00 00 00       	mov    $0xf,%eax
    3f35:	cd 40                	int    $0x40
    3f37:	c3                   	ret    

00003f38 <mknod>:
SYSCALL(mknod)
    3f38:	b8 11 00 00 00       	mov    $0x11,%eax
    3f3d:	cd 40                	int    $0x40
    3f3f:	c3                   	ret    

00003f40 <unlink>:
SYSCALL(unlink)
    3f40:	b8 12 00 00 00       	mov    $0x12,%eax
    3f45:	cd 40                	int    $0x40
    3f47:	c3                   	ret    

00003f48 <fstat>:
SYSCALL(fstat)
    3f48:	b8 08 00 00 00       	mov    $0x8,%eax
    3f4d:	cd 40                	int    $0x40
    3f4f:	c3                   	ret    

00003f50 <link>:
SYSCALL(link)
    3f50:	b8 13 00 00 00       	mov    $0x13,%eax
    3f55:	cd 40                	int    $0x40
    3f57:	c3                   	ret    

00003f58 <mkdir>:
SYSCALL(mkdir)
    3f58:	b8 14 00 00 00       	mov    $0x14,%eax
    3f5d:	cd 40                	int    $0x40
    3f5f:	c3                   	ret    

00003f60 <chdir>:
SYSCALL(chdir)
    3f60:	b8 09 00 00 00       	mov    $0x9,%eax
    3f65:	cd 40                	int    $0x40
    3f67:	c3                   	ret    

00003f68 <dup>:
SYSCALL(dup)
    3f68:	b8 0a 00 00 00       	mov    $0xa,%eax
    3f6d:	cd 40                	int    $0x40
    3f6f:	c3                   	ret    

00003f70 <getpid>:
SYSCALL(getpid)
    3f70:	b8 0b 00 00 00       	mov    $0xb,%eax
    3f75:	cd 40                	int    $0x40
    3f77:	c3                   	ret    

00003f78 <sbrk>:
SYSCALL(sbrk)
    3f78:	b8 0c 00 00 00       	mov    $0xc,%eax
    3f7d:	cd 40                	int    $0x40
    3f7f:	c3                   	ret    

00003f80 <sleep>:
SYSCALL(sleep)
    3f80:	b8 0d 00 00 00       	mov    $0xd,%eax
    3f85:	cd 40                	int    $0x40
    3f87:	c3                   	ret    

00003f88 <uptime>:
SYSCALL(uptime)
    3f88:	b8 0e 00 00 00       	mov    $0xe,%eax
    3f8d:	cd 40                	int    $0x40
    3f8f:	c3                   	ret    

00003f90 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3f90:	55                   	push   %ebp
    3f91:	89 e5                	mov    %esp,%ebp
    3f93:	83 ec 28             	sub    $0x28,%esp
    3f96:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f99:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3f9c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3fa3:	00 
    3fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
    3fab:	8b 45 08             	mov    0x8(%ebp),%eax
    3fae:	89 04 24             	mov    %eax,(%esp)
    3fb1:	e8 5a ff ff ff       	call   3f10 <write>
}
    3fb6:	c9                   	leave  
    3fb7:	c3                   	ret    

00003fb8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3fb8:	55                   	push   %ebp
    3fb9:	89 e5                	mov    %esp,%ebp
    3fbb:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3fbe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3fc5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3fc9:	74 17                	je     3fe2 <printint+0x2a>
    3fcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3fcf:	79 11                	jns    3fe2 <printint+0x2a>
    neg = 1;
    3fd1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fdb:	f7 d8                	neg    %eax
    3fdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fe0:	eb 06                	jmp    3fe8 <printint+0x30>
  } else {
    x = xx;
    3fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fe5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3fe8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3fef:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3ff5:	ba 00 00 00 00       	mov    $0x0,%edx
    3ffa:	f7 f1                	div    %ecx
    3ffc:	89 d0                	mov    %edx,%eax
    3ffe:	0f b6 90 20 63 00 00 	movzbl 0x6320(%eax),%edx
    4005:	8d 45 dc             	lea    -0x24(%ebp),%eax
    4008:	03 45 f4             	add    -0xc(%ebp),%eax
    400b:	88 10                	mov    %dl,(%eax)
    400d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
    4011:	8b 55 10             	mov    0x10(%ebp),%edx
    4014:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    4017:	8b 45 ec             	mov    -0x14(%ebp),%eax
    401a:	ba 00 00 00 00       	mov    $0x0,%edx
    401f:	f7 75 d4             	divl   -0x2c(%ebp)
    4022:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4025:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4029:	75 c4                	jne    3fef <printint+0x37>
  if(neg)
    402b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    402f:	74 2a                	je     405b <printint+0xa3>
    buf[i++] = '-';
    4031:	8d 45 dc             	lea    -0x24(%ebp),%eax
    4034:	03 45 f4             	add    -0xc(%ebp),%eax
    4037:	c6 00 2d             	movb   $0x2d,(%eax)
    403a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
    403e:	eb 1b                	jmp    405b <printint+0xa3>
    putc(fd, buf[i]);
    4040:	8d 45 dc             	lea    -0x24(%ebp),%eax
    4043:	03 45 f4             	add    -0xc(%ebp),%eax
    4046:	0f b6 00             	movzbl (%eax),%eax
    4049:	0f be c0             	movsbl %al,%eax
    404c:	89 44 24 04          	mov    %eax,0x4(%esp)
    4050:	8b 45 08             	mov    0x8(%ebp),%eax
    4053:	89 04 24             	mov    %eax,(%esp)
    4056:	e8 35 ff ff ff       	call   3f90 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    405b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    405f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4063:	79 db                	jns    4040 <printint+0x88>
    putc(fd, buf[i]);
}
    4065:	c9                   	leave  
    4066:	c3                   	ret    

00004067 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4067:	55                   	push   %ebp
    4068:	89 e5                	mov    %esp,%ebp
    406a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    406d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4074:	8d 45 0c             	lea    0xc(%ebp),%eax
    4077:	83 c0 04             	add    $0x4,%eax
    407a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    407d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4084:	e9 7d 01 00 00       	jmp    4206 <printf+0x19f>
    c = fmt[i] & 0xff;
    4089:	8b 55 0c             	mov    0xc(%ebp),%edx
    408c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    408f:	01 d0                	add    %edx,%eax
    4091:	0f b6 00             	movzbl (%eax),%eax
    4094:	0f be c0             	movsbl %al,%eax
    4097:	25 ff 00 00 00       	and    $0xff,%eax
    409c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    409f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    40a3:	75 2c                	jne    40d1 <printf+0x6a>
      if(c == '%'){
    40a5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    40a9:	75 0c                	jne    40b7 <printf+0x50>
        state = '%';
    40ab:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    40b2:	e9 4b 01 00 00       	jmp    4202 <printf+0x19b>
      } else {
        putc(fd, c);
    40b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    40ba:	0f be c0             	movsbl %al,%eax
    40bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    40c1:	8b 45 08             	mov    0x8(%ebp),%eax
    40c4:	89 04 24             	mov    %eax,(%esp)
    40c7:	e8 c4 fe ff ff       	call   3f90 <putc>
    40cc:	e9 31 01 00 00       	jmp    4202 <printf+0x19b>
      }
    } else if(state == '%'){
    40d1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    40d5:	0f 85 27 01 00 00    	jne    4202 <printf+0x19b>
      if(c == 'd'){
    40db:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    40df:	75 2d                	jne    410e <printf+0xa7>
        printint(fd, *ap, 10, 1);
    40e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40e4:	8b 00                	mov    (%eax),%eax
    40e6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    40ed:	00 
    40ee:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    40f5:	00 
    40f6:	89 44 24 04          	mov    %eax,0x4(%esp)
    40fa:	8b 45 08             	mov    0x8(%ebp),%eax
    40fd:	89 04 24             	mov    %eax,(%esp)
    4100:	e8 b3 fe ff ff       	call   3fb8 <printint>
        ap++;
    4105:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4109:	e9 ed 00 00 00       	jmp    41fb <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    410e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    4112:	74 06                	je     411a <printf+0xb3>
    4114:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    4118:	75 2d                	jne    4147 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    411a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    411d:	8b 00                	mov    (%eax),%eax
    411f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    4126:	00 
    4127:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    412e:	00 
    412f:	89 44 24 04          	mov    %eax,0x4(%esp)
    4133:	8b 45 08             	mov    0x8(%ebp),%eax
    4136:	89 04 24             	mov    %eax,(%esp)
    4139:	e8 7a fe ff ff       	call   3fb8 <printint>
        ap++;
    413e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4142:	e9 b4 00 00 00       	jmp    41fb <printf+0x194>
      } else if(c == 's'){
    4147:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    414b:	75 46                	jne    4193 <printf+0x12c>
        s = (char*)*ap;
    414d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4150:	8b 00                	mov    (%eax),%eax
    4152:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4155:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    4159:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    415d:	75 27                	jne    4186 <printf+0x11f>
          s = "(null)";
    415f:	c7 45 f4 22 5c 00 00 	movl   $0x5c22,-0xc(%ebp)
        while(*s != 0){
    4166:	eb 1e                	jmp    4186 <printf+0x11f>
          putc(fd, *s);
    4168:	8b 45 f4             	mov    -0xc(%ebp),%eax
    416b:	0f b6 00             	movzbl (%eax),%eax
    416e:	0f be c0             	movsbl %al,%eax
    4171:	89 44 24 04          	mov    %eax,0x4(%esp)
    4175:	8b 45 08             	mov    0x8(%ebp),%eax
    4178:	89 04 24             	mov    %eax,(%esp)
    417b:	e8 10 fe ff ff       	call   3f90 <putc>
          s++;
    4180:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    4184:	eb 01                	jmp    4187 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4186:	90                   	nop
    4187:	8b 45 f4             	mov    -0xc(%ebp),%eax
    418a:	0f b6 00             	movzbl (%eax),%eax
    418d:	84 c0                	test   %al,%al
    418f:	75 d7                	jne    4168 <printf+0x101>
    4191:	eb 68                	jmp    41fb <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4193:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4197:	75 1d                	jne    41b6 <printf+0x14f>
        putc(fd, *ap);
    4199:	8b 45 e8             	mov    -0x18(%ebp),%eax
    419c:	8b 00                	mov    (%eax),%eax
    419e:	0f be c0             	movsbl %al,%eax
    41a1:	89 44 24 04          	mov    %eax,0x4(%esp)
    41a5:	8b 45 08             	mov    0x8(%ebp),%eax
    41a8:	89 04 24             	mov    %eax,(%esp)
    41ab:	e8 e0 fd ff ff       	call   3f90 <putc>
        ap++;
    41b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    41b4:	eb 45                	jmp    41fb <printf+0x194>
      } else if(c == '%'){
    41b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    41ba:	75 17                	jne    41d3 <printf+0x16c>
        putc(fd, c);
    41bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41bf:	0f be c0             	movsbl %al,%eax
    41c2:	89 44 24 04          	mov    %eax,0x4(%esp)
    41c6:	8b 45 08             	mov    0x8(%ebp),%eax
    41c9:	89 04 24             	mov    %eax,(%esp)
    41cc:	e8 bf fd ff ff       	call   3f90 <putc>
    41d1:	eb 28                	jmp    41fb <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    41d3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    41da:	00 
    41db:	8b 45 08             	mov    0x8(%ebp),%eax
    41de:	89 04 24             	mov    %eax,(%esp)
    41e1:	e8 aa fd ff ff       	call   3f90 <putc>
        putc(fd, c);
    41e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41e9:	0f be c0             	movsbl %al,%eax
    41ec:	89 44 24 04          	mov    %eax,0x4(%esp)
    41f0:	8b 45 08             	mov    0x8(%ebp),%eax
    41f3:	89 04 24             	mov    %eax,(%esp)
    41f6:	e8 95 fd ff ff       	call   3f90 <putc>
      }
      state = 0;
    41fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    4202:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    4206:	8b 55 0c             	mov    0xc(%ebp),%edx
    4209:	8b 45 f0             	mov    -0x10(%ebp),%eax
    420c:	01 d0                	add    %edx,%eax
    420e:	0f b6 00             	movzbl (%eax),%eax
    4211:	84 c0                	test   %al,%al
    4213:	0f 85 70 fe ff ff    	jne    4089 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    4219:	c9                   	leave  
    421a:	c3                   	ret    
    421b:	90                   	nop

0000421c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    421c:	55                   	push   %ebp
    421d:	89 e5                	mov    %esp,%ebp
    421f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4222:	8b 45 08             	mov    0x8(%ebp),%eax
    4225:	83 e8 08             	sub    $0x8,%eax
    4228:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    422b:	a1 c8 63 00 00       	mov    0x63c8,%eax
    4230:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4233:	eb 24                	jmp    4259 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4235:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4238:	8b 00                	mov    (%eax),%eax
    423a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    423d:	77 12                	ja     4251 <free+0x35>
    423f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4242:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4245:	77 24                	ja     426b <free+0x4f>
    4247:	8b 45 fc             	mov    -0x4(%ebp),%eax
    424a:	8b 00                	mov    (%eax),%eax
    424c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    424f:	77 1a                	ja     426b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4251:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4254:	8b 00                	mov    (%eax),%eax
    4256:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4259:	8b 45 f8             	mov    -0x8(%ebp),%eax
    425c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    425f:	76 d4                	jbe    4235 <free+0x19>
    4261:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4264:	8b 00                	mov    (%eax),%eax
    4266:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4269:	76 ca                	jbe    4235 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    426b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    426e:	8b 40 04             	mov    0x4(%eax),%eax
    4271:	c1 e0 03             	shl    $0x3,%eax
    4274:	89 c2                	mov    %eax,%edx
    4276:	03 55 f8             	add    -0x8(%ebp),%edx
    4279:	8b 45 fc             	mov    -0x4(%ebp),%eax
    427c:	8b 00                	mov    (%eax),%eax
    427e:	39 c2                	cmp    %eax,%edx
    4280:	75 24                	jne    42a6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    4282:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4285:	8b 50 04             	mov    0x4(%eax),%edx
    4288:	8b 45 fc             	mov    -0x4(%ebp),%eax
    428b:	8b 00                	mov    (%eax),%eax
    428d:	8b 40 04             	mov    0x4(%eax),%eax
    4290:	01 c2                	add    %eax,%edx
    4292:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4295:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    4298:	8b 45 fc             	mov    -0x4(%ebp),%eax
    429b:	8b 00                	mov    (%eax),%eax
    429d:	8b 10                	mov    (%eax),%edx
    429f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42a2:	89 10                	mov    %edx,(%eax)
    42a4:	eb 0a                	jmp    42b0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    42a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42a9:	8b 10                	mov    (%eax),%edx
    42ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42ae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    42b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42b3:	8b 40 04             	mov    0x4(%eax),%eax
    42b6:	c1 e0 03             	shl    $0x3,%eax
    42b9:	03 45 fc             	add    -0x4(%ebp),%eax
    42bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    42bf:	75 20                	jne    42e1 <free+0xc5>
    p->s.size += bp->s.size;
    42c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42c4:	8b 50 04             	mov    0x4(%eax),%edx
    42c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42ca:	8b 40 04             	mov    0x4(%eax),%eax
    42cd:	01 c2                	add    %eax,%edx
    42cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    42d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42d8:	8b 10                	mov    (%eax),%edx
    42da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42dd:	89 10                	mov    %edx,(%eax)
    42df:	eb 08                	jmp    42e9 <free+0xcd>
  } else
    p->s.ptr = bp;
    42e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
    42e7:	89 10                	mov    %edx,(%eax)
  freep = p;
    42e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42ec:	a3 c8 63 00 00       	mov    %eax,0x63c8
}
    42f1:	c9                   	leave  
    42f2:	c3                   	ret    

000042f3 <morecore>:

static Header*
morecore(uint nu)
{
    42f3:	55                   	push   %ebp
    42f4:	89 e5                	mov    %esp,%ebp
    42f6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    42f9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    4300:	77 07                	ja     4309 <morecore+0x16>
    nu = 4096;
    4302:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    4309:	8b 45 08             	mov    0x8(%ebp),%eax
    430c:	c1 e0 03             	shl    $0x3,%eax
    430f:	89 04 24             	mov    %eax,(%esp)
    4312:	e8 61 fc ff ff       	call   3f78 <sbrk>
    4317:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    431a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    431e:	75 07                	jne    4327 <morecore+0x34>
    return 0;
    4320:	b8 00 00 00 00       	mov    $0x0,%eax
    4325:	eb 22                	jmp    4349 <morecore+0x56>
  hp = (Header*)p;
    4327:	8b 45 f4             	mov    -0xc(%ebp),%eax
    432a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    432d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4330:	8b 55 08             	mov    0x8(%ebp),%edx
    4333:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    4336:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4339:	83 c0 08             	add    $0x8,%eax
    433c:	89 04 24             	mov    %eax,(%esp)
    433f:	e8 d8 fe ff ff       	call   421c <free>
  return freep;
    4344:	a1 c8 63 00 00       	mov    0x63c8,%eax
}
    4349:	c9                   	leave  
    434a:	c3                   	ret    

0000434b <malloc>:

void*
malloc(uint nbytes)
{
    434b:	55                   	push   %ebp
    434c:	89 e5                	mov    %esp,%ebp
    434e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4351:	8b 45 08             	mov    0x8(%ebp),%eax
    4354:	83 c0 07             	add    $0x7,%eax
    4357:	c1 e8 03             	shr    $0x3,%eax
    435a:	83 c0 01             	add    $0x1,%eax
    435d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4360:	a1 c8 63 00 00       	mov    0x63c8,%eax
    4365:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4368:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    436c:	75 23                	jne    4391 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    436e:	c7 45 f0 c0 63 00 00 	movl   $0x63c0,-0x10(%ebp)
    4375:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4378:	a3 c8 63 00 00       	mov    %eax,0x63c8
    437d:	a1 c8 63 00 00       	mov    0x63c8,%eax
    4382:	a3 c0 63 00 00       	mov    %eax,0x63c0
    base.s.size = 0;
    4387:	c7 05 c4 63 00 00 00 	movl   $0x0,0x63c4
    438e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4391:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4394:	8b 00                	mov    (%eax),%eax
    4396:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4399:	8b 45 f4             	mov    -0xc(%ebp),%eax
    439c:	8b 40 04             	mov    0x4(%eax),%eax
    439f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    43a2:	72 4d                	jb     43f1 <malloc+0xa6>
      if(p->s.size == nunits)
    43a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a7:	8b 40 04             	mov    0x4(%eax),%eax
    43aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    43ad:	75 0c                	jne    43bb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    43af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43b2:	8b 10                	mov    (%eax),%edx
    43b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43b7:	89 10                	mov    %edx,(%eax)
    43b9:	eb 26                	jmp    43e1 <malloc+0x96>
      else {
        p->s.size -= nunits;
    43bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43be:	8b 40 04             	mov    0x4(%eax),%eax
    43c1:	89 c2                	mov    %eax,%edx
    43c3:	2b 55 ec             	sub    -0x14(%ebp),%edx
    43c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    43cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43cf:	8b 40 04             	mov    0x4(%eax),%eax
    43d2:	c1 e0 03             	shl    $0x3,%eax
    43d5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    43d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43db:	8b 55 ec             	mov    -0x14(%ebp),%edx
    43de:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    43e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43e4:	a3 c8 63 00 00       	mov    %eax,0x63c8
      return (void*)(p + 1);
    43e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43ec:	83 c0 08             	add    $0x8,%eax
    43ef:	eb 38                	jmp    4429 <malloc+0xde>
    }
    if(p == freep)
    43f1:	a1 c8 63 00 00       	mov    0x63c8,%eax
    43f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    43f9:	75 1b                	jne    4416 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    43fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    43fe:	89 04 24             	mov    %eax,(%esp)
    4401:	e8 ed fe ff ff       	call   42f3 <morecore>
    4406:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    440d:	75 07                	jne    4416 <malloc+0xcb>
        return 0;
    440f:	b8 00 00 00 00       	mov    $0x0,%eax
    4414:	eb 13                	jmp    4429 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4416:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4419:	89 45 f0             	mov    %eax,-0x10(%ebp)
    441c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    441f:	8b 00                	mov    (%eax),%eax
    4421:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    4424:	e9 70 ff ff ff       	jmp    4399 <malloc+0x4e>
}
    4429:	c9                   	leave  
    442a:	c3                   	ret    
