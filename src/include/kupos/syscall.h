#ifndef _SYSCALL_H_
#define _SYSCALL_H_

/*
	System call routines
*/

#define syscall0()
#define syscall1(a)
#define syscall2(a,b)
#define syscall3(a,b,c)
#define syscall4(a,b,c,d)
#define syscall5(a,b,c,d,e)
#define syscall6(a,b,c,d,e,f)



extern void syscall_handler();

#endif
