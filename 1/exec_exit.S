#include "syscall.h"
#include "traps.h"

.globl exec_exit;
.globl exec_exit_end;

exec_exit:
	pushl %eax;
	movl $SYS_exit, %eax;
	int $T_SYSCALL;
	ret;
exec_exit_end:
