#include "types.h"
#include "stat.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

int procInfoInumAdditionArr[] = {CMDLINE ,CWD, EXE, FDINFO, STATUS};
char* names[] = {"cmdline", "cwd", "exe", "fdinfo", "status"};


static int pidToInum(int pid) {
  return (1000+pid);
}

static int inumToPid(int inum) {
  return (inum-1000);
}

static int indexToProccessInfoAddition(int index, char* dst){
  if(index < 0 || index > 4)
    return 0;

  strncpy(dst, names[index], strlen(names[index])+1);
  return procInfoInumAdditionArr[index];
}


//static int inumToPid(int inum) {
//  return inum - 1000000;
//}

/*The function returns zero if the file represented by ip is not a directory and a non-zero
value otherwise*/
int
procfsisdir(struct inode *ip) {

  int function = ((ip->inum-1000) / 1000 * 1000);
  return ip->type == T_DEV && ip->major == 2 &&
         // /proc
         ((ip->minor == 0) ||
          // pid
          (ip->minor == 1) ||
          // process function
          ((ip->minor == 2) &&
           ((function == CWD) || (function == FDINFO))));
}


/*struct inode {
  uint dev;           // Device number
  uint inum;          // Inode number
  int ref;            // Reference count
  int flags;          // I_BUSY, I_VALID

  short type;         // copy of disk inode
  short major;
  short minor;
  short nlink;
  uint size;
  uint addrs[NDIRECT+1];
};*/

/*The function receives ip (with initialized ip->inum) and initialized dp that represents ip’s
parent directory. This function should update all ip fields. Note that if ip->flags does not
contain the I_VALID flag the inode will be read from the disk (since all files in procfs are
“virtual”, they will not reside on the disk).*/
void 
procfsiread(struct inode* dp, struct inode *ip) {

  if(dp->major == 2) {
    if(dp->minor ==0) {
//      cprintf("procfs.c::iread, /proc assigning to ip->inum: %d\n", ip->inum);
    }

      // pid is parent
    else if(dp->minor == 1){
      struct proc p;
      struct inode node;
      getProcStructFromPid(inumToPid(dp->inum),&p);
      getExeInodeFromPid(inumToPid(dp->inum),&node);


      struct proc * proc = &p;
      struct inode* inode= &node;

      if ((ip->inum-1000)/1000*1000 == CWD) {
//        cprintf("CWDing...ip->inum:%d\n", ip->inum);
//        cprintf("proc: pid:%d name:%s cwd->inum:%d\n", proc->pid, proc->name,proc->cwd->inum);
        memmove(ip->addrs, proc->cwd->addrs, sizeof(proc->cwd->addrs));
//        (NDIRECT+1)*sizeof(uint)
//        cprintf("procfs.c::iread after memmove\n");
        ip->minor = proc->cwd->minor;
        ip->inum = proc->cwd->inum;
        ip->major = proc->cwd->major;
        ip->flags = proc->cwd->flags;
        ip->nlink = proc->cwd->nlink;
        ip->dev = proc->cwd->dev;
        ip->type = proc->cwd->type;
        ip->size = proc->cwd->size;
        ip->ref = proc->cwd->ref;
        return;
      }
      else if((ip->inum-1000)/1000*1000 == EXE) {
        memmove(ip->addrs, inode->addrs, sizeof(inode->addrs));
//        (NDIRECT+1)*sizeof(uint)
//        cprintf("procfs.c::iread after memmove\n");
        ip->minor = inode->minor;
        ip->inum = inode->inum;
        ip->major = inode->major;
        ip->flags = inode->flags;
        ip->nlink = inode->nlink;
        ip->dev = inode->dev;
        ip->type = inode->type;
        ip->size = inode->size;
        ip->ref = inode->ref;
        return;
      }
//      cprintf("procfs.c::iread, /proc/inum:%d assigning to ip->inum: %d\n",dp->inum ,ip->inum);
    }


    ip->dev = dp->dev;
    ip->flags = I_VALID;
    ip->type = dp->type;
    ip->major = dp->major;
    ip->minor = dp->minor+1;
//    cprintf("procfs.c::iread, dp->inum:%d ip->inum:%d ip->type:%d\n",dp->inum,ip->inum,ip->type);

  }
}

/*These functions must implement read/write operations from the file represented by ip.
 *
 * struct dirent {
  ushort inum;
  char name[DIRSIZ];
};
 * */
int
procfsread(struct inode *ip, char *dst, int off, int n) {
  // go over process table
  // create dir entry for each
  // TODO: add options for "." and ".."

//  cprintf("procfs.c::read parent: inum: %d,  major: %d,  minor: %d,  off: %d\n",ip->inum,ip->major,ip->minor,off);
  if(ip->major == 2){

    if(ip->minor==0 && ip ->inum == 18){

      if(off == 0){
        // /proc
        ((struct dirent *) dst)->inum = ip->inum;
        strncpy(((struct dirent *) dst)->name, ".", strlen(".")+1);
        return n;
      }

      if(off == n){
        // root
        ((struct dirent *) dst)->inum = 1;
        strncpy(((struct dirent *) dst)->name, "..", strlen("..")+1);
        return n;
      }

      int pid = getnameandpidbyindex((off/ sizeof (struct dirent))-2,((struct dirent *) dst)->name);

      if (pid == 0) {
  //      cprintf("We are in read returning 0. inum is: %d\n", ((struct dirent *) dst)->inum);
        return 0;
      }

      int inum = pidToInum(pid);
      ((struct dirent *) dst)->inum = inum;

//      cprintf("procfs.c::read child inum : %d\n",inum);
      return n;
    }

      // pid
    else if(ip->minor==1){
//      cprintf("trying to read pid folder. inum: %d off: %d index: %d\n", ip->inum,off,off / sizeof(struct dirent));

      if(off == 0){
        // pid
        ((struct dirent *) dst)->inum = ip->inum;
        strncpy(((struct dirent *) dst)->name, ".", strlen(".")+1);
        return n;
      }

      if(off == n){
        // /proc
        ((struct dirent *) dst)->inum = 18;
        strncpy(((struct dirent *) dst)->name, "..", strlen("..")+1);
        return n;
      }

      int processInfoAdd = indexToProccessInfoAddition((off / sizeof(struct dirent))-2, ((struct dirent *) dst)->name);

      if (processInfoAdd == 0) {
//        cprintf("We are in read returning 0. inum is: %d\n",ip->inum);
        return 0;
      }

      ((struct dirent *) dst)->inum = processInfoAdd+ip->inum;

//      cprintf("We are in read returning sizeof dirent. inum is: %d\n",((struct dirent *) dst)->inum);
      return n;

      // fill de with process request stuff static for all pids, will be filled on demand
    }

    else if(ip->minor==2){
      // run over enums and divide
      int proccessInfo= -1;
      proccessInfo = (ip->inum-1000)/1000*1000;


      if(proccessInfo == -1)
        return 0;

      switch(proccessInfo){
        case CWD:
          cprintf("WTFFFFFFFFFFFFFFFFFFF\n");
          // get from proc
          break;
        case CMDLINE:
          if(off > 0){
            return 0;
          }
              int length = getCmdLineFromPid(ip->inum - CMDLINE - 1000, dst);
              strncpy(dst+length,"\n\0",2);
//              cprintf("I want cmdline! ip->inum: %d dst: %s\n", ip->inum,dst);
              return length;

        case EXE:
          break;
        case FDINFO: {
          // get the open file descriptor indices, itoa them and return them.
//          cprintf("procfs.c::read case FDINFO off:%d\n",off);
          int pid = (ip->inum - FDINFO - 1000);
          int index = getOpenFileNumbersFromPid(pid, off / n);
          if (index == -1) {
//            cprintf("procfs.c::read case FDINFO index returned -1\n");
            return 0;
          }

          int inum = ((7 + index) * 1000 + pid);

          itoa(index, ((struct dirent *) dst)->name);
//          ((struct dirent *) dst)->name[strlen(((struct dirent *) dst)->name)] = 0;
          ((struct dirent *) dst)->inum = inum;
//          cprintf("procfs.c::read case FDINFO index:%d ip->inum:%d returned de.inum:%d de.name:%s\n", index, ip->inum,
//                  ((struct dirent *) dst)->inum, ((struct dirent *) dst)->name);
          // itoa on index and insert to dst name
          return n;
        }

        case STATUS:
          if(off > 0){
            return 0;
          }
              getStatusFromPid(ip->inum - STATUS - 1000, dst);
              return n;
      }
    }

      // fdinfo directory
    else if(ip->minor == 3){
      if(off > 0){
        return 0;
      }
      int fdIndex = ip->inum / 1000 - 7;
      int pid = ip->inum - ip->inum/1000*1000;
      getFileContentFromInum(pid, fdIndex, dst);
      // inum = 7002
      // 7002 / 1000 = 7 - 7 = 0 = fdindex
      // 7002 - 7002 / 1000 * 1000 = 2
      cprintf("profcs.c:: minor=3, inum:%d fdIndex:%d pid:%d dst:%s\n", ip->inum, fdIndex, pid, dst);
      return n;
    }

  }

  return 0;
}

int
procfswrite(struct inode *ip, char *buf, int n)
{
  cprintf("We are in write\n");
  return 0;
}



void
procfsinit(void)
{
  devsw[PROCFS].isdir = procfsisdir;
  devsw[PROCFS].iread = procfsiread;
  devsw[PROCFS].write = procfswrite;
  devsw[PROCFS].read = procfsread;
}
