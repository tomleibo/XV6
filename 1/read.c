#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  char buf[100];
  for (;;){
	gets(buf,100);
	if (strcmp(buf,"q\n") == 0) break;
	printf(1,"%s\n",buf);
  }
  return 0;
}
