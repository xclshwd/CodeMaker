
#ifndef __DEFINES__H__
#define  __DEFINES__H__

/**数据类型宏定义*/
typedef char                WD_CHAR;
typedef unsigned char       WD_UCHAR;
typedef short               WD_SHORT;
typedef unsigned short      WD_USHORT;
typedef int                 WD_INT;
typedef unsigned int        WD_UINT;
typedef long                WD_LONG;
typedef unsigned long       WD_ULONG; 
typedef void                WD_VOID;

#define WD_NULL             NULL
#define WD_TRUE             1
#define WD_FALSE            0

#if defined(_PLATFORM_LINX_)
    typedef long long       WD_LL;
    typedef unsigned long long  WD_ULL;
#else
    typedef __int64           WD_LL;
    typedef unsigned __int64  WD_ULL;
#endif


#endif// __DEFINES__H__