#include "types.h"
#include "user.h"

void print_nonsense(void){

  printf(1, "a\n");
}

int
main(int argc, char *argv[])
{
	int wtime, rtime, iotime;
	// int i;							//uncomment to check runnning time (1)
	if(fork() == 0){
		// for(i=0; i<=5000; i++)		//uncomment to check runnning time (2)
			// print_nonsense();			//uncomment to check runnning time (3)
		char buf[3];					//uncomment to check sleeping time (1)
		printf(1, "Enter a sole char (any char) and press enter: (the longer you wait, the bigger sleeping time will be)\n");		//uncomment to check sleeping time (2)
		read(0, buf, 3);				//uncomment to check sleeping time (3)
		exit(0);
    }
	wait_stat(&wtime, &rtime, &iotime);
	printf(2, "ready (runnable) time is: %d\n", wtime);
	printf(2, "running time is: %d\n", rtime);
	printf(2, "sleeping (waiting for io) time is: %d\n", iotime);
	exit(0);
}