#include "types.h"
#include "user.h"


int
main(int argc, char *argv[])
{
if (fork()) {
	wait(0);
}
else {
	int i;
	for(i=1; i<4; i++){
		int pri = set_priority(i);
		if(pri != i) {
			printf(1,"YOU SUCK %d %d\n",i, pri);
		}
	}
	printf(1, "OK!\n");
}
exit(0);
} 
