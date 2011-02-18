#ifndef _DEBUG_H_
#define _DEBUG_H_

#define ASSERT(x) if(!x) {printf("ASSERT: failed assertion at %s:%d, in %s!", __FILE__, __LINE__, __FUNCTION__); die("Assertion failed!");}
#define BUG()  {printf("BUG: at %s:%d, in %s!", __FILE__, __LINE__, __FUNCTION__); die("BUG!");}
#define WARN() printf("WARNING: at %s:%d, in %s!", __FILE__, __LINE__, __FUNCTION__)
#define BUG_ON(x) if(x) BUG()
#define WARN_ON(x) if(x) WARN()

#endif
