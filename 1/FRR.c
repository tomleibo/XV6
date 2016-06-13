#include "types.h"
#include "user.h"


int
main(int argc, char *argv[])
{
        if (!fork()) {
                printf(1, "1");
        	sleep(10);
                printf(1, "1");
        }
        else {
                printf(1, "2");
                if (!fork()) {
                        printf(1, "3");
                }

                else{
                        printf(1, "4");
                }
        }

        exit(0);
} 
