#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "limits.h"


struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;


static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  //
  p->ctime = ticks;
  p->stime = 0;
  p->retime = 0;
  p->rutime = 0;
  p->priority = MEDIUM;
  //

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;
  p->arrived_in_queue = ticks;
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  np->state = RUNNABLE;
  np->arrived_in_queue = ticks;

  if (np->pid > 2) {
	  if (proc->pid == 2 || proc->pid == 1){
	    np->gid=np->pid;
	  }
	  else{
	    np->gid=proc->gid;
	  }
  }
  release(&ptable.lock);
  
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(int status)
{
  struct proc *p;
  int fd;

  proc->ttime = ticks;

  proc->status=status;
  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(int* status)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
	if (status != 0) {
		*status = p->status;
	}
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
waitpid(int pid, int* status, int options)
{
  struct proc *p;

  acquire(&ptable.lock);

  // Scan through table looking for a child process with given pid
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){

    if(p->pid != pid)
        continue;

    p->parent=proc;

    if(options == 0){
            release(&ptable.lock);
            return -1;
    }

    for(;;){
        if(p->state == ZOMBIE){
            // Found one.
            kfree(p->kstack);
            p->kstack = 0;
            freevm(p->pgdir);
            p->state = UNUSED;
            p->pid = 0;
            p->parent = 0;
            p->name[0] = 0;
            p->killed = 0;
            if (status != 0) {
              *status = p->status;
            }
            release(&ptable.lock);
            return pid;
        } 

        if(proc->killed){
            release(&ptable.lock);
            return -1;
        }

        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}

  // no process with given pid
  release(&ptable.lock);
  return -1;

}

int
wait_stat(int* wtime, int* rtime, int* iotime, int* status)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
	*status = p->status;
        *wtime = p->retime;
        *rtime = p->rutime;
        *iotime = p->stime;
 
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}


//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct proc *earliest_proc;
  struct proc *poorest_proc;
    // Enable interrupts on this processor.
       
  if (strategy==1) { 
    	for(;;){

        sti();

    		acquire(&ptable.lock);	  
    		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    		
    			if(p->state != RUNNABLE)
    				continue;

    		      	// Switch to chosen process.  It is the process's job
    			// to release ptable.lock and then reacquire it
    			// before jumping back to us.
    			proc = p;
    			switchuvm(p);
    			p->state = RUNNING;
    			swtch(&cpu->scheduler, proc->context);
    			switchkvm();
    			// Process is done running for now.
    		      	// It should have changed its p->state before coming back.
    			proc = 0;
    		
    	      }
    		release(&ptable.lock);


    	}
  }

 else if(strategy == 2 || strategy == 3) {

    	for(;;){

        sti();

    		acquire(&ptable.lock);	  
        int earliest_ticks;
        earliest_ticks = SHRT_MAX;
        earliest_proc = 0;

        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        
            if(p->state != RUNNABLE)
              continue;

            if(p->arrived_in_queue < earliest_ticks) {
                earliest_ticks = p->arrived_in_queue;
                earliest_proc = p;
            }
        }

        if(earliest_proc != 0){
            proc = earliest_proc;
            switchuvm(earliest_proc);
            earliest_proc->state = RUNNING;
            swtch(&cpu->scheduler, proc->context);
            switchkvm();
            proc = 0;
        }

        release(&ptable.lock);

    	}	


   }

   else if(strategy==4) {

        for(;;){

            sti();
            acquire(&ptable.lock);  

            int min_vruntime = SHRT_MAX;
            poorest_proc = 0;

            for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
                
                if(p->state != RUNNABLE)
                  continue;

                int vruntime = (p->rutime) * (p->priority);
                // cprintf("rutime: %d priority: %d vruntime: %d\n",p->rutime, p->priority, vruntime);

                if(vruntime < min_vruntime) {
                    min_vruntime = vruntime;
                    poorest_proc = p;
                }
            }

            if(poorest_proc != 0){
                proc = poorest_proc;
                switchuvm(poorest_proc);
                poorest_proc->state = RUNNING;
                swtch(&cpu->scheduler, proc->context);
                switchkvm();
                proc = 0;
            }

            release(&ptable.lock);
      } 

   }

   else {
	       exit(137);
   }


   
}


// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  proc->arrived_in_queue = ticks;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    initlog();
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan){
        p->state = RUNNABLE;
        p->arrived_in_queue = ticks;
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
          p->state = RUNNABLE;
          p->arrived_in_queue = ticks;
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

void
updateProcessesTimes(){

  acquire(&ptable.lock);
  struct proc* p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    switch(p->state){
      case RUNNABLE:
        p->retime++;
        break;
      case RUNNING:
        p->rutime++;
        break;
      case SLEEPING:
        p->stime++;
        break;
      case UNUSED:
      case EMBRYO:
      case ZOMBIE:
      break;
    }
  }
  release(&ptable.lock);
}

int set_priority(int priority){
  int old_priority=proc->priority;
  switch(priority){
    case HIGH:
    case MEDIUM:
    case LOW:
      proc->priority = priority;
      return old_priority;
  }
  
  return -1;
}

int canRemoveJob(int gid) {
  int ans=1;
  struct proc* p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if (p->gid==gid && (p->state == SLEEPING || p->state == RUNNING || p->state == RUNNABLE)) {
		ans=0;
		break;
	}
  }    
  release(&ptable.lock);
  return ans;
}

int jobs(int gid){
  struct proc* p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if (p->gid==gid && p->pid > 2 && !(p->name[0] == 's' && p->name[1] == 'h' && strlen(p->name) == 2)) {
		cprintf("%d: %s\n",p->pid,p->name);
	}
  }    
  release(&ptable.lock);
  return 0;
}

int gidpid(int gid,int min) {
  int pid=-1;
  struct proc* p;
  acquire(&ptable.lock);
//debug:	cprintf("in proc.c: requested gid: %d with min: %d\n",gid,min);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if (p->gid==gid && p->pid > min && (pid > p->pid || pid==-1)) {
		pid = p->pid;
	}
  }    
  release(&ptable.lock);
  return pid;
}

int isShell(int pid) {
  int ans=0;
  struct proc* p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if (p->pid==pid) {
		if (p->name[0] == 's' && p->name[1] == 'h' && strlen(p->name) == 2) {
			ans=1;
			break;
		}
	}
  }    
  release(&ptable.lock);
  return ans;
}