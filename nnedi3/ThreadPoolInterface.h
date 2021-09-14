/*
 *  ThreadpoolInterface
 *
 *  Allow to use the threadpool, kind of API.
 *  Copyright (C) 2017 JPSDR
 *	
 *  ThreadpoolInterface is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *   
 *  ThreadpoolInterface is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *   
 *  You should have received a copy of the GNU General Public License
 *  along with GNU Make; see the file COPYING.  If not, write to
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
 *
 */

#ifndef __ThreadPoolInterface_H__
#define __ThreadPoolInterface_H__

#include <Windows.h>

#include "./ThreadPoolDef.h"

#define THREADPOOLINTERFACE_VERSION "ThreadPoolInterface 1.9.6"

typedef struct _UserData
{
	uint16_t UserId;
	int8_t nPool;
	bool nPollTab[MAX_THREAD_POOL];
} UserData;


class ThreadPoolInterface
{
	public :

	virtual ~ThreadPoolInterface(void);
	static ThreadPoolInterface* Init(uint8_t num);

	uint8_t GetThreadNumber(uint8_t thread_number,bool logical);
	int16_t AddPool(uint8_t num);
	bool CreatePool(uint8_t num);
	bool DeletePool(uint8_t num);
	bool RemovePool(uint8_t num);
	bool AllocateThreads(uint8_t thread_number,uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore,
		bool SetAffinity,bool sleep,ThreadLevelName priority,int8_t nPool);
	bool AllocateThreads(uint8_t thread_number,uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore,
		bool SetAffinity,bool sleep,int8_t nPool)
		{return(AllocateThreads(thread_number,offset_core,offset_ht,UseMaxPhysCore,SetAffinity,sleep,
			NormalThreadLevel,nPool));}
	bool GetUserId(uint16_t &UserId);
	bool RemoveUserId(uint16_t UserId);
	bool ChangeThreadsAffinity(uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore,bool SetAffinity,int8_t nPool);
	bool ChangeThreadsLevel(ThreadLevelName priority,int8_t nPool);
	bool DeAllocateUserThreads(uint16_t UserId,bool check);
	bool DeAllocatePoolThreads(uint8_t nPool,bool check);
	bool DeAllocateAllThreads(bool check);
	bool RequestThreadPool(uint16_t UserId,uint8_t thread_number,Public_MT_Data_Thread *Data,
		ThreadLevelName priority,int8_t nPool,bool Exclusive);
	bool RequestThreadPool(uint16_t UserId,uint8_t thread_number,Public_MT_Data_Thread *Data,
		ThreadLevelName priority,int8_t &nPool,bool Exclusive,bool AllowSeveral);
	bool RequestThreadPool(uint16_t UserId,uint8_t thread_number,Public_MT_Data_Thread *Data,
		int8_t nPool,bool Exclusive)
		{return(RequestThreadPool(UserId,thread_number,Data,NoneThreadLevel,nPool,Exclusive));}
	bool RequestThreadPool(uint16_t UserId,uint8_t thread_number,Public_MT_Data_Thread *Data,
		int8_t &nPool,bool Exclusive,bool AllowSeveral)
		{return(RequestThreadPool(UserId,thread_number,Data,NoneThreadLevel,nPool,Exclusive,AllowSeveral));}
	bool ReleaseThreadPool(uint16_t UserId,bool sleep);
	bool ReleaseThreadPool(uint16_t UserId,bool sleep,int8_t nPool);
	bool StartThreads(uint16_t UserId);
	bool StartThreads(uint16_t UserId,int8_t nPool);
	bool WaitThreadsEnd(uint16_t UserId);
	bool WaitThreadsEnd(uint16_t UserId,int8_t nPool);
	bool GetThreadPoolStatus(uint16_t UserId,int8_t nPool);
	uint8_t GetCurrentThreadAllocated(uint16_t UserId,int8_t nPool);
	uint8_t GetCurrentThreadUsed(uint16_t UserId,int8_t nPool);
	uint8_t GetLogicalCPUNumber(void);
	uint8_t GetPhysicalCoreNumber(void);
	
	protected :
	
	bool Status_Ok;
	uint8_t NbrePool;
	
	public :

	bool GetThreadPoolInterfaceStatus(void) {return(Status_Ok);}
	int8_t GetCurrentPoolCreated(void) {return((Status_Ok) ? NbrePool:-1);}

	protected :

	ThreadPoolInterface(void);

	CRITICAL_SECTION CriticalSection;
	HANDLE ghMutexResources;
	BOOL CSectionOk;
	HANDLE JobsEnded[MAX_THREAD_POOL],ThreadPoolFree[MAX_THREAD_POOL];
	UserData TabId[MAX_USERS];
	uint16_t NbreUsers;
	HANDLE EndExclusive;
	bool Error_Occured;

	bool ThreadPoolRequested[MAX_THREAD_POOL],JobsRunning[MAX_THREAD_POOL];
	bool ThreadPoolReleased[MAX_THREAD_POOL],ThreadWaitEnd[MAX_THREAD_POOL];
	bool ThreadPoolWaitFree[MAX_THREAD_POOL];
	uint16_t ThreadPoolUserId[MAX_THREAD_POOL];
	bool ExclusiveMode;
	uint8_t NbrePoolEvent;

	bool CreatePoolEvent(uint8_t num);
	void FreeData(void);
	void FreePool(void);
	void FreePool(int8_t nPool);
	bool EnterCS(void);
	void LeaveCS(void);
	bool GetMutex(void);
	void FreeMutex(void);
	int16_t GetUserIdIndex(uint16_t UserId);
	bool ReleaseThreadPoolCore(uint16_t UserId,int16_t index,bool sleep,int8_t nPool);
	bool StartThreadsCore(int8_t nPool);
	bool WaitThreadsEndCore(uint16_t UserId,int8_t nPool);
	
	private :

	ThreadPoolInterface (const ThreadPoolInterface &other);
	ThreadPoolInterface& operator = (const ThreadPoolInterface &other);
	bool operator == (const ThreadPoolInterface &other) const;
	bool operator != (const ThreadPoolInterface &other) const;
};

#endif // __ThreadPoolInterface_H__
