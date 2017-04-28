#ifndef __DEFINES__H__
#define  __DEFINES__H__
#include "defines.h"

/*释放空间*/
#define SAFE_FREE(ptr) do{\
        if(ptr != WD__FS_NULL)\
        {\
            free(ptr);\
            ptr = WD__FS_NULL;\
        }\
    }while(0)

#define SAFE_DELETE(ptr) do{\
        if(ptr != WD__FS_NULL)\
        {\
            delete ptr;\
            ptr = WD__FS_NULL;\
        }\
    }while(0)

#define SAFE_DELETE_ARRAY(ptr) do{\
        if(ptr != WD__FS_NULL)\
        {\
            delete []ptr;\
            ptr = WD__FS_NULL;\
        }\
    }while(0)

/********************************************************/
/*
    year, hour, minute, second的类型都是unsigned char，所以其肯定>=0，为避免编译警告，所以这里没有加此判断
*/
#define WD__VALID_YEAR(year) (year <= 99)
#define WD__VALID_MONTH(month) (((month) >= 1) && (month <= 12))
#define WD__VALID_DAY(day) ((day >= 1) && (day <= 31))
#define WD__VALID_HOUR(hour)   (hour <= 23)
#define WD__VALID_MINUTE(minute)   (minute <= 59)
#define WD__VALID_SECOND(second) (second <= 59)
#define WD__VALID_DSTFLAG(dst) ((dst == 0) || (dst == 1))
#define WD__VALID_RECORDTYPE(record_type)  (record_type < 16)
#define WD__VALID_PRERECFALG(for_pre_record) ((for_pre_record == 0) || (for_pre_record == 1))
#define WD__VALID_DATE_TIME_P(pDt) (pDt && WD__VALID_YEAR(pDt->year) && WD__VALID_MONTH(pDt->month) && WD__VALID_DAY(pDt->day) && \
            WD__VALID_HOUR(pDt->hour) && WD__VALID_MINUTE(pDt->minute) && WD__VALID_SECOND(pDt->second))
#define WD_VALID_DATE_TIME(dt) (WD__VALID_YEAR(dt.year) && WD__VALID_MONTH(dt.month) && WD__VALID_DAY(dt.day) && \
                        WD__VALID_HOUR(dt.hour) && WD__VALID_MINUTE(dt.minute) && WD__VALID_SECOND(dt.second))


#endif// __DEFINES__H__