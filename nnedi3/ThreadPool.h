#ifndef __ThreadPool_H__
#define __ThreadPool_H__

#include <Windows.h>

#include "ThreadPoolDef.h"

#define THREADPOOL_VERSION "ThreadPool 1.1.1"

typedef struct _MT_Data_Thread
{
	Public_MT_Data_Thread *MTData;
	uint8_t f_process,thread_Id;
	HANDLE nextJob, jobFinished;
} MT_Data_Thread;


typedef struct _Arch_CPU
{
	uint8_t NbPhysCore,NbLogicCPU;
	uint8_t NbHT[64];
	ULONG_PTR ProcMask[64];
} Arch_CPU;


class ThreadPool
{
	public :
	ThreadPool(void);

	protected :

	Arch_CPU CPU;

	public :

	uint8_t GetThreadNumber(uint8_t thread_number,bool logical);
	bool AllocateThreads(uint8_t thread_number,uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore);
	bool DeAllocateThreads(void);
	bool RequestThreadPool(uint8_t thread_number,Public_MT_Data_Thread *Data);
	bool ReleaseThreadPool(void);
	bool StartThreads(void);
	bool WaitThreadsEnd(void);
	bool GetThreadPoolStatus(void) {return(Status_Ok);}
	uint8_t GetCurrentThreadAllocated(void) {return(CurrentThreadsAllocated);}
	uint8_t GetCurrentThreadUsed(void) {return(CurrentThreadsUsed);}
	uint8_t GetLogicalCPUNumber(void) {return(CPU.NbLogicCPU);}
	uint8_t GetPhysicalCoreNumber(void) {return(CPU.NbPhysCore);}

	protected :

	MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	HANDLE nextJob[MAX_MT_THREADS],jobFinished[MAX_MT_THREADS];
	HANDLE thds[MAX_MT_THREADS];
	DWORD tids[MAX_MT_THREADS];
	ULONG_PTR ThreadMask[MAX_MT_THREADS];

	bool Status_Ok;
	uint8_t TotalThreadsRequested,CurrentThreadsAllocated,CurrentThreadsUsed;
	
	void FreeThreadPool(void);
	void CreateThreadPool(uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore);

	private :

	static DWORD WINAPI StaticThreadpool(LPVOID lpParam);

	ThreadPool (const ThreadPool &other);
	ThreadPool& operator = (const ThreadPool &other);
	bool operator == (const ThreadPool &other) const;
	bool operator != (const ThreadPool &other) const;
};

#endif // __ThreadPool_H__
