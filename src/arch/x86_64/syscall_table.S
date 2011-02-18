/*
	All real syscalls are defined here
*/

.intel_syntax noprefix
.include "macro.inc"

ENTRY __syscall_table

def_syscall sys_stub,		0		/* 0 */
def_syscall sys_exit,		1
def_syscall sys_fork,		1
def_syscall sys_read,		3
def_syscall sys_write,		3
def_syscall sys_open,		3		/* 5 */
def_syscall sys_close,		1
def_syscall sys_waitpid,	3
def_syscall sys_creat,		2
def_syscall sys_link,		2
def_syscall sys_unlink,		1		/* 10 */
def_syscall sys_execve,		1
def_syscall sys_chdir,		1
def_syscall sys_time,		1

ENTRY __syscall_table_sz
		.word	(. - __syscall_table)/8
