#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int i,j,k=0;
  for (i=0; i<80000; i++) {
	for (j=0;j<10000;j++) {
		k++;
	}
  }
  exit(0);
}
