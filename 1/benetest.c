#include "types.h"
#include "user.h"


int
main(int argc, char *argv[])
{
/*int pid;
int status;

if (!(pid = fork()))
{
exit(0x7f);
}
else
{
// wait(&status);
	printf(1, "PID: %d\n",pid);
	waitpid(pid, &status, 1);
}
if (status == 0x7f)
{
printf(1, "OK\n");
}
else
{
printf(1, "FAILED\n");
}*/
if (fork()) {
	int i,j;
	for(j=0;j<20;j++){
		for (i=0;i<10000000;i++){
		
		}
		printf(1,"1");
		char buf[50];
		if (j==10) read(0,buf,5);
	}
wait(0);
}
else {
	int i,j;
	for(j=0;j<20;j++){
		for (i=0;i<10000000;i++){
		
		}
		printf(1,"2");
		char buf[50];
		if (j==10) read(0,buf,5);
	}
}
exit(0);
} 
