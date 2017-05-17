#ifndef __COMMON_MACRO_H__
#define __COMMON_MACRO_H__
#ifndef PLATFORM_WIN32
#include <sys/wait.h>
#endif
#include <string.h>

//namespace Common
{

#define WD_MIN(a, b)  (((a) < (b)) ? (a) : (b))

#define WD_MAX(a, b)  (((a) > (b)) ? (a) : (b))

#define WD_ABS(a)	   (((a) < 0) ? -(a) : (a))

#define WD_CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

#define WD_RETURN_IF_FAIL(expr) { if(!(expr)) return; }

#define WD_RETURN_VAL_IF_FAIL(expr,val) {if(!(expr)) return(val);}

#define WD_BIT_VAL_TEST(val,offset) (((val) & (1ll<<offset))!=0)

#define WD_BIT_VAL_SET(val,offset) (val=((val)|(1ll<<(offset))))

#define WD_BIT_VAL_CLEAR(val,offset) (val=((val)&(~(1ll<<(offset)))))

#define WD_ARRAY_BIT_SET(array, offset) ( array[offset/8] = (array[offset/8] | (1<<(7-offset%8))) )

#define WD_ARRAY_BIT_TEST(array, offset) ( (array[offset/8] >> (7-offset%8)) & 0x1 )

#define WD_ARRAY_BIT_CLEAR(array, offset) ( array[offset/8] = (array[offset/8] & (~(1<<(7-offset%8)))) )

#define WD_ARRAY_BIT_SET_ALL(array, max) { memset(array, 0xff, ((max-1)/8)+1 );}

#define WD_ARRAY_BIT_CLEAR_ALL(array, max) { memset(array, 0x0, ((max-1)/8)+1 );}

/*ÊÍ·Å¿Õ¼ä*/
#define WD_FREE(ptr) do{\
        if(ptr != NULL)\
        {\
            free(ptr);\
            ptr = NULL;\
        }\
    }while(0)

#define WD_DELETE(ptr) do{\
        if(ptr != NULL)\
        {\
            delete ptr;\
            ptr = NULL;\
        }\
    }while(0)

#define WD_DELETE_ARRAY(ptr) do{\
        if(ptr != NULL)\
        {\
            delete []ptr;\
            ptr = NULL;\
        }\
    }while(0)
}
#endif /*__COMMON_MACRO_H__*/
