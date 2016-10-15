#ifndef __ThreadPoolDef_H__
#define __ThreadPoolDef_H__

#include <stdint.h>

#define MAX_MT_THREADS 128
#define MAX_THREAD_POOL 64
#define MAX_USERS 2000

typedef void (*ThreadPoolFunction)(void *ptr);


typedef struct _Public_MT_Data_Thread
{
	ThreadPoolFunction pFunc;
	void *pClass;
	uint8_t f_process,thread_Id;
} Public_MT_Data_Thread;


#endif // __ThreadPoolDef_H__
