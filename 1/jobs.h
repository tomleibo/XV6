struct job {
  int i;
  char * command; //the command which created this process.
  int numberOfProcs;
  struct job * next; // the next job in the list.
};

struct job * newJob(int i, char * command, int num, struct job * next);
/*void printJobs(struct job *);
void printOneJob(struct job *, int); */
void removeJob(struct job * list, int gid);
struct job * fg(struct job * list, int i);
struct job * addJob(struct job * jobList, struct job * job);
