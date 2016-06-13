#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int i,j,pid;
  int children[20];
  int status,wtime,rtime,iotime;
  int avgWait=0,avgRun=0,avgTa=0;
  set_priority(1);
  for (i=0;i<20;i++) {
	if (!(children[i] = fork())) {
		set_priority((i+1)%3);
		for (j=0;j<70000000;j++) {
			j++;
		}
		pid = getpid();
		exit(pid);
	}
  }
  for (i=0;i<20;i++) {
	pid=wait_stat(&wtime,&rtime,&iotime,&status);
	if (pid==status) {
		printf(2,"pid %d: wait time: %d  | runtime: %d  | turn around time: %d\n",pid,wtime,rtime,(wtime+rtime));	
	}
	avgWait+=wtime;
	avgRun+=rtime;
	avgTa+=rtime;
	avgTa+=wtime;
  }
  avgWait/=20;
  avgRun/=20;
  avgTa/=20;
  printf(2,"avg wait time: %d | avg run time: %d | avg TA time: %d\n",avgWait,avgRun,avgTa);

  exit(0);
}
