#include "types.h"
#include "stat.h"
#include "user.h"


int forktest(int* pages) {
	int pid = fork();
	if (pid==0) {
		printf(2,"forktest: value of adress 20000 in child:%d\n",pages[20000]);
		kill(getpid());
	}
	wait();
	return 0;
}

void stackoverflow() {
	stackoverflow();
}

void testOF() {
	if (fork()==0) {
		stackoverflow();
		exit();
	}
	wait();
}

void testUpToKernel() {
	if (fork()==0) {
		printf(2,"trying to malloc up to the kernel. this should fail.\n");
		int* goodAlloc = (int*)malloc(200000000);
		//just shutting up the compiler 
		if (goodAlloc) {
			//do nothing
		}
		int* badAlloc = (int*)malloc(2147000000);
		if (badAlloc <= 0 ) {
			printf(2,"malloc failed. test SUCCESSFUL.\n");
		}
		else {
			printf(2,"malloc succeeded. test FAILED.\n");	
		}
		free(goodAlloc);
		free(badAlloc);
		exit();
	}
	wait();
}
int main (int argc, char** argv) {
	int* manypages = (int*)malloc(4200000);
	printf(2,"malloced 1025+ pages.\nwriting to the first one.\n");
	manypages[4500] = 345;
	printf(2,"writing to the second one.\n");
	manypages[9100] = 345;
	free(manypages);

	printf(2,"fork test:  \n");
	forktest(manypages);
	
	testOF();

	testUpToKernel();
	
	return 0;
}
