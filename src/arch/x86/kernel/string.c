/*
	KupOS string and memory manipulation routines
*/

#include <kupos/string.h>

/* Copy SRC to DEST.  */
char* kstrcpy (char *__restrict __dest, __const char *__restrict __src)
{
	asm (	"	.intel_syntax noprefix \n"
			"	push ax \n"
			"	1: \n"
			"	lodsb \n"
			"	stosb \n"
			"	test al,al \n"
			"	jnz 1b \n"
			"	pop ax \n"
			"	.att_syntax prefix \n"
			:
			: "S"(__src), "D"(__dest)
		);
	return __dest;
}

/* Return the length of S.  */
size_t kstrlen (__const char *__s)
{
	long length;
	asm (	"	.intel_syntax noprefix \n"
			"	push ax \n"
			"	xor al,al \n"
			"	repne scasb \n"
			"	neg ecx \n"
			"	sub ecx, 2 \n"
			"	.att_syntax prefix \n"
			: "=c"(length)
			: "S"(__s), "c"((unsigned long)-1)
		);
	return length;
}

/* Return the length of S, max n.  */
size_t kstrnlen(const char * __s, size_t n)
{
	long length;
	asm (	"	.intel_syntax noprefix \n"
			"	push ax \n"
			"	xor al,al \n"
			"	repne scasb \n"
			"	neg ecx \n"
			"	sub ecx, 2 \n"
			"	.att_syntax prefix \n"
			: "=c"(length)
			: "S"(__s), "c"(n)
		);
	return length;

}
