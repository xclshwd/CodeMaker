
#ifndef __DEFINES__H__
#define  __DEFINES__H__
/**数据类型宏定义*/
/********************************************************/
typedef char                WD_FS_CHAR;
typedef unsigned char       WD__FS_UCHAR;
typedef short               WD__FS_SHORT;
typedef unsigned short      WD__FS_USHORT;
typedef int                 WD__FS_INT;
typedef unsigned int        WD__FS_UINT;
typedef long                WD__FS_LONG;
typedef unsigned long       WD__FS_ULONG; 
typedef void                WD__FS_VOID;
typedef WD__FS_UCHAR            WD__FS_BOOL;
#define WD__FS_NULL             NULL
#define WD__FS_TRUE             1
#define WD__FS_FALSE            0

#if defined(_PLATFORM_LINX_)
    typedef long long       WD__FS_LL;
    typedef unsigned long long  WD__FS_ULL;
#else
    typedef __int64           WD__FS_LL;
    typedef unsigned __int64  WD__FS_ULL;
#endif



#endif// __DEFINES__H__