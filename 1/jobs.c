#include "jobs.h"

extern printf(int,char*,...);

void printJobs(struct job * jobs) {
  //check if no process exists and print something
  int i=0;
  while (jobs!=0) {
	printOneJob(jobs,i);
	jobs=jobs->next;
	i++;
  }
};

void printOneJob(struct job * jobs, int i) {
  struct inJobProcess * procs; 
  procs = jobs->procs;
  int size = jobs->numberOfProcs;
  printf(2,"Job %d: %s\n",i,jobs->command);  
  int j;
  for (j=0;j<size; j++){
	if (procs->process->state != ZOMBIE){
		printf(2,"%d: %s\n",procs->process->pid,procs->command);
	}
	procs=procs->next;
  }
};

struct job * addJob(struct job * jobList, struct job * job) {
  if (job!=0) {
	job->next=jobList;
  }
  return job;
}

void removeJob(struct job * list, int index) {
  struct job * previous;
  int i=0;
  while (i<index-1){
	list=list->next;
	i++;
  }
  previous = list;
  list = list->next;
  previous->next = list->next;
  //delete (list) ?? ignore?
  // test: printf("next: %d\n",(int)(previous->next));  
  
}

struct job * newJob(int i, char * command, int num, struct job * next) {
  struct job * job;
  job = malloc(sizeof(*job));
  job->i=i;
  job->command=command;
  job->numberOfProcs=num;
  job->procs=procs;
  job->next=next;
  return job;
}

// get the i job.
struct job * fg(struct job * list, int i) {
  if (i<0) {
	i=0;
  }
  return (list+i);  
}


/*

struct job {
  char * command; //the command which created this process.
  int numberOfProcs;
  struct inJobProcess * procs; // list of pointers to processes.  
  struct job * next; // the next job in the list.
};

struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)
  int status;			// exit code.
};
jobs 
– prints a list of pending jobs ( all jobs that have at least one process that did not terminate yet) . 
For each job print the command that created it and a list of job proces ses that are still alive . 
The format should be as follows: 
 the first line of every job must contain a job index and the job command , for example: 
Job 1: read | cat & 
 the following lines describes the processes (name and pid) of this job: 7: read 9: cat 
 if no jobs currently exist, an appropriate message must appear:
There are no jobs*/
