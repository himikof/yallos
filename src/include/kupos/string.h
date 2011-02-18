#ifndef _STRING_H_
#define _STRING_H_

#include <kupos/types.h>

/*
    Implementation needed:
        kmemcpy
        kmemmove
        kmemset
        kmemcmp
        kmemchr
        
        kstrcpy (!)
        kstrncpy
        kstrcat
        kstrncat
        kstrcmp
        kstrncmp
        kstrchr
        kstrrchr
        kstrcspn
        kstrspn
        kstrpbrk
        kstrstr
        kstrtok
        kstrtok_r
        kstrlen (!)
		kstrnlen (!)
        
*/

/* Copy N bytes of SRC to DEST.  */
extern void* kmemcpy (void *__restrict __dest,  __const void *__restrict __src, size_t __n);
/* Copy N bytes of SRC to DEST, guaranteeing
   correct behavior for overlapping strings.  */
extern void* kmemmove (void *__dest, __const void *__src, size_t __n);
/* Set N bytes of S to C.  */
extern void* kmemset (void *__s, int __c, size_t __n);
/* Compare N bytes of S1 and S2.  */
extern int kmemcmp (__const void *__s1, __const void *__s2, size_t __n);
/* Search N bytes of S for C.  */
extern void* kmemchr (__const void *__s, int __c, size_t __n);

/* Copy SRC to DEST.  */
extern char* kstrcpy (char *__restrict __dest, __const char *__restrict __src);
/* Copy no more than N characters of SRC to DEST.  */
extern char* kstrncpy (char *__restrict __dest, __const char *__restrict __src, size_t __n);
/* Append SRC onto DEST.  */
extern char* kstrcat (char *__restrict __dest, __const char *__restrict __src);
/* Append no more than N characters from SRC onto DEST.  */
extern char* kstrncat (char *__restrict __dest, __const char *__restrict __src, size_t __n);
/* Compare S1 and S2.  */
extern int kstrcmp (__const char *__s1, __const char *__s2);
/* Compare N characters of S1 and S2.  */
extern int kstrncmp (__const char *__s1, __const char *__s2, size_t __n);
/* Find the first occurrence of C in S.  */
extern char* kstrchr (__const char *__s, int __c);
/* Find the last occurrence of C in S.  */
extern char* kstrrchr (__const char *__s, int __c);
/* Return the length of the initial segment of S which
   consists entirely of characters not in REJECT.  */
extern size_t kstrcspn (__const char *__s, __const char *__reject);
/* Return the length of the initial segment of S which
   consists entirely of characters in ACCEPT.  */
extern size_t kstrspn (__const char *__s, __const char *__accept);
/* Find the first occurrence in S of any character in ACCEPT.  */
extern char* kstrpbrk (__const char *__s, __const char *__accept);
/* Find the first occurrence of NEEDLE in HAYSTACK.  */
extern char* kstrstr (__const char *__haystack, __const char *__needle);
/* Divide S into tokens separated by characters in DELIM.  */
extern char* kstrtok (char *__restrict __s, __const char *__restrict __delim);
/* Divide S into tokens separated by characters in DELIM.  Information
   passed between calls are stored in SAVE_PTR.  */
extern char* kstrtok_r (char *__restrict __s, __const char *__restrict __delim, char **__restrict __save_ptr);
/* Return the length of S.  */
extern size_t kstrlen (__const char *__s);
/* Return the length of S, max n.  */
extern size_t kstrnlen(const char * __s, size_t n);




#endif
