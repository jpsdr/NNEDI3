/*
 *  Threadpool
 *
 *  Create and manage a threadpool.
 *  Copyright (C) 2016 JPSDR
 *	
 *  Threadpool is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *   
 *  Threadpool is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *   
 *  You should have received a copy of the GNU General Public License
 *  along with GNU Make; see the file COPYING.  If not, write to
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
 *
 */

#ifndef __ThreadPool_H__
#define __ThreadPool_H__

#include <Windows.h>

#include "ThreadPoolDef.h"

#define THREADPOOL_VERSION "ThreadPool 1.4.0"

typedef struct _MT_Data_Thread
{
	Public_MT_Data_Thread *MTData;
	volatile uint8_t f_process,thread_Id;
	volatile HANDLE nextJob,jobFinished;
} MT_Data_Thread;


typedef struct _Arch_CPU
{
	uint8_t NbPhysCore,NbLogicCPU;
	uint8_t NbHT[64];
	ULONG_PTR ProcMask[64];
	ULONG_PTR FullMask;
} Arch_CPU;


class ThreadPool
{
	public :
	ThreadPool(void);
	virtual ~ThreadPool();

	protected :

	Arch_CPU CPU;

	public :

	uint8_t GetThreadNumber(uint8_t thread_number,bool logical);
	bool AllocateThreads(uint8_t thread_number,uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore,
		bool SetAffinity,bool sleep,ThreadLevelName priority);
	bool DeAllocateThreads(void);
	bool ChangeThreadsAffinity(uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore,bool SetAffinity);
	bool ChangeThreadsLevel(ThreadLevelName priority);
	bool RequestThreadPool(uint8_t thread_number,Public_MT_Data_Thread *Data,ThreadLevelName priority);
	bool ReleaseThreadPool(bool sleep);
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
	volatile bool ThreadSleep[MAX_MT_THREADS];
	volatile ThreadLevelName nPriority;

	volatile bool Status_Ok;
	volatile uint8_t TotalThreadsRequested,CurrentThreadsAllocated,CurrentThreadsUsed;
	
	void FreeThreadPool(void);
	void DestroyThreadPool(void);
	void CreateThreadPool(uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore,bool SetAffinity,
		bool sleep,ThreadLevelName priority);

	private :

	static DWORD WINAPI StaticThreadpool(LPVOID lpParam);

	ThreadPool (const ThreadPool &other);
	ThreadPool& operator = (const ThreadPool &other);
	bool operator == (const ThreadPool &other) const;
	bool operator != (const ThreadPool &other) const;
};

#endif // __ThreadPool_H__
