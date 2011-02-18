#ifndef _STDIO_H_
#define _STDIO_H_

#include <stdarg.h>
#include <kupos/types.h>

/* Write output to console.*/
extern int kprint(__const char * message);

/* Write formatted output to console.*/
extern int kprintf (__const char * __format, ...);
/* Write formatted output to console from argument list ARG.*/
extern int kvprintf (__const char * __format, va_list __arg);

/* Write formatted output to S.  */
extern int ksprintf (char * __s,
                    __const char * __format, ...);
/* Write formatted output to S from argument list ARG.  */
extern int kvsprintf (char * __s, __const char * __format,
                     va_list __arg);


/* Write formatted output to S, max size bytes, from argument list ARG.  */
extern int ksnprintf (char * __s, size_t size, __const char * __format, ...);
/* Write formatted output to S, max size bytes, from argument list ARG.  */
extern int kvsnprintf (char * __s, size_t size, __const char * __format,
                     va_list __arg);

/* Write formatted output to S, max size bytes, from argument list ARG.  */
extern int kscnprintf (char * __s, size_t size, __const char * __format, ...);
/* Write formatted output to S, max size bytes, from argument list ARG.  */
extern int kvscnprintf (char * __s, size_t size, __const char * __format,
                     va_list __arg);

#endif
