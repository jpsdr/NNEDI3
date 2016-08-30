// ThreadPoolDLL.cpp : définit les fonctions exportées pour l'application DLL.
//

#include "ThreadPoolInterface.h"
#include "ThreadPool.h"

#define myfree(ptr) if (ptr!=NULL) { free(ptr); ptr=NULL;}
#define myCloseHandle(ptr) if (ptr!=NULL) { CloseHandle(ptr); ptr=NULL;}
#define mydelete(ptr) if (ptr!=NULL) { delete ptr; ptr=NULL;}


static ThreadPool *ptrPool[MAX_THREAD_POOL]={NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};


ThreadPoolInterface* ThreadPoolInterface::Init(uint8_t num)
{

	static ThreadPoolInterface PoolInterface;

	if (PoolInterface.EnterCS())
	{
		if (num>=MAX_THREAD_POOL) num=MAX_THREAD_POOL;

		if (num>PoolInterface.NbrePool)
		{
			if (PoolInterface.CreatePoolEvent(num))
			{
				bool ok=true;

				while ((PoolInterface.NbrePool<num) && ok)
				{
					ptrPool[PoolInterface.NbrePool]= new ThreadPool();
					ok=ok && (ptrPool[PoolInterface.NbrePool]!=NULL);
					PoolInterface.NbrePool++;
				}
				if (!ok)
				{
					PoolInterface.Error_Occured=true;
					PoolInterface.FreePool();
					PoolInterface.Status_Ok=false;
					PoolInterface.FreeData();
				}
			}
			else
			{
				PoolInterface.FreePool();
				PoolInterface.Status_Ok=false;
				PoolInterface.FreeData();
			}
		}
		PoolInterface.LeaveCS();
	}

	return(&PoolInterface);
}


bool ThreadPoolInterface::EnterCS(void)
{
	if (!Status_Ok) return(false);

	EnterCriticalSection(&CriticalSection);

	return(true);
}


void ThreadPoolInterface::LeaveCS(void)
{
	LeaveCriticalSection(&CriticalSection);
}



bool ThreadPoolInterface::CreatePoolEvent(uint8_t num)
{
	if ((!Status_Ok) || (num==0) || Error_Occured)  return(false);

	bool ok=true;

	if (num>NbrePoolEvent)
	{
		while((NbrePoolEvent<num) && ok)
		{
			JobsEnded[NbrePoolEvent]=CreateEvent(NULL,TRUE,TRUE,NULL);
			ThreadPoolFree[NbrePoolEvent]=CreateEvent(NULL,TRUE,TRUE,NULL);
			ok=ok && (JobsEnded[NbrePoolEvent]!=NULL) && (ThreadPoolFree[NbrePoolEvent]!=NULL);
			NbrePoolEvent++;
		}
		if (!ok) Error_Occured=true;
	}
	return(ok);
}


void ThreadPoolInterface::FreeData(void)
{
	int16_t i;

	if (NbrePool>0)
	{
		for(i=NbrePool-1; i>=0; i--)
			mydelete(ptrPool[i]);
		NbrePool=0;
	}

	if (NbrePoolEvent>0)
	{
		for(i=NbrePoolEvent-1; i>=0; i--)
		{
			myCloseHandle(ThreadPoolFree[i]);
			myCloseHandle(JobsEnded[i]);
		}
		NbrePoolEvent=0;
	}

	myCloseHandle(EndExclusive);
}


void ThreadPoolInterface::FreePool(void)
{
	if (NbrePool>0)
	{
		for(int16_t i=NbrePool-1; i>=0; i--)
		{
			if (ptrPool[i]!=NULL)
			{
				while(ThreadPoolRequested[i])
				{
					LeaveCriticalSection(&CriticalSection);
					WaitForSingleObject(ThreadPoolFree[i],INFINITE);
					EnterCriticalSection(&CriticalSection);
				}
				ptrPool[i]->DeAllocateThreads();
			}
		}
	}
}


ThreadPoolInterface::ThreadPoolInterface(void):CSectionOk(FALSE),Status_Ok(true),Error_Occured(false),
	NbrePool(0),NbrePoolEvent(0)
{
	CSectionOk=InitializeCriticalSectionAndSpinCount(&CriticalSection,0x00000040);
	if (CSectionOk==TRUE)
	{
		CSectionOk=InitializeCriticalSectionAndSpinCount(&CriticalSectionResources,0x00000040);
		if (CSectionOk==FALSE)
		{
			Status_Ok=false;
			DeleteCriticalSection(&CriticalSection);
		}
	}
	else Status_Ok=false;

	EndExclusive=NULL;
	ExclusiveMode=false;

	uint16_t i;

	for (i=0; i<MAX_THREAD_POOL; i++)
	{
		JobsEnded[i]=NULL;
		ThreadPoolFree[i]=NULL;
		ThreadPoolRequested[i]=false;
		ThreadPoolReleased[i]=false;
		JobsRunning[i]=false;
	}

	for(i=0; i<MAX_USERS; i++)
	{
		TabId[i].UserId=0;
		TabId[i].nPool=-1;
	}
}


ThreadPoolInterface::~ThreadPoolInterface(void)
{
	FreeData();
	if (CSectionOk==TRUE)
	{
		DeleteCriticalSection(&CriticalSectionResources);
		DeleteCriticalSection(&CriticalSection);
	}
}


uint8_t ThreadPoolInterface::GetThreadNumber(uint8_t thread_number,bool logical)
{
	if ((!Status_Ok) || (NbrePool==0)) return(0);
	else return(ptrPool[0]->GetThreadNumber(thread_number,logical));
}



bool ThreadPoolInterface::AllocateThreads(uint16_t &UserId,uint8_t thread_number,uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore,int8_t nPool)
{
	if ((!Status_Ok) || Error_Occured) return(false);

	EnterCriticalSection(&CriticalSection);

	if ((!Status_Ok) || Error_Occured || (thread_number==0) || ((UserId==0) && (NbreUsers>=MAX_USERS)) || ((UserId!=0) && (NbreUsers==0)) 
		|| (nPool>=(int8_t)NbrePool) || (nPool<-1))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	if (UserId!=0)
	{
		uint16_t i=0;

		while ((NbreUsers>i) && (TabId[i].UserId!=UserId)) i++;
		if (i==NbreUsers)
		{
			LeaveCriticalSection(&CriticalSection);
			return(false);
		}
	}

	EnterCriticalSection(&CriticalSectionResources);
	if ((!Status_Ok) || Error_Occured)
	{
		LeaveCriticalSection(&CriticalSection);
		LeaveCriticalSection(&CriticalSectionResources);
		return(false);
	}

	if (UserId==0)
	{
		uint16_t user=1;

		if (NbreUsers>0)
		{
			bool found=false;

			while (!found && (user<=NbreUsers))
			{
				uint16_t i=0;
				bool search=true;

				while (search && (i<NbreUsers))
					search=search && (TabId[i++].UserId!=user);
				found=search;
				if (!found) user++;
			}
		}
		NbreUsers++;
		UserId=user;
		TabId[NbreUsers-1].UserId=UserId;
		TabId[NbreUsers-1].nPool=-1;
	}

	if (nPool==-1)
	{
		for(uint8_t i=0; i<NbrePool; i++)
		{
			if (thread_number>ptrPool[i]->GetCurrentThreadAllocated())
			{
				while (JobsRunning[i])
				{
					LeaveCriticalSection(&CriticalSection);
					WaitForSingleObject(JobsEnded[i],INFINITE);
					EnterCriticalSection(&CriticalSection);
					if ((!Status_Ok) || Error_Occured)
					{
						LeaveCriticalSection(&CriticalSection);
						LeaveCriticalSection(&CriticalSectionResources);
						return(false);
					}
				}
				bool ok=ptrPool[i]->AllocateThreads(thread_number,offset_core,offset_ht,UseMaxPhysCore);
				if (!ok)
				{
					Error_Occured=true;
					FreePool();
					Status_Ok=false;
					FreeData();
					LeaveCriticalSection(&CriticalSection);
					LeaveCriticalSection(&CriticalSectionResources);
					return(false);
				}
			}
		}
	}
	else
	{
		if (thread_number>ptrPool[nPool]->GetCurrentThreadAllocated())
		{
			while (JobsRunning[nPool])
			{
				LeaveCriticalSection(&CriticalSection);
				WaitForSingleObject(JobsEnded[nPool],INFINITE);
				EnterCriticalSection(&CriticalSection);
				if ((!Status_Ok) || Error_Occured)
				{
					LeaveCriticalSection(&CriticalSection);
					LeaveCriticalSection(&CriticalSectionResources);
					return(false);
				}
			}
			bool ok=ptrPool[nPool]->AllocateThreads(thread_number,offset_core,offset_ht,UseMaxPhysCore);
			if (!ok)
			{
				Error_Occured=true;
				FreePool();
				Status_Ok=false;
				FreeData();
				LeaveCriticalSection(&CriticalSection);
				LeaveCriticalSection(&CriticalSectionResources);
				return(false);
			}
		}
	}

	LeaveCriticalSection(&CriticalSection);
	LeaveCriticalSection(&CriticalSectionResources);

	return(true);
}


bool ThreadPoolInterface::DeAllocateThreads(uint16_t UserId)
{
	if (!Status_Ok) return(false);

	EnterCriticalSection(&CriticalSection);

	if ((!Status_Ok) || (UserId==0) || (NbreUsers==0))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	uint16_t index=0;

	while ((NbreUsers>index) && (TabId[index].UserId!=UserId)) index++;
	if (index==NbreUsers)
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	int8_t nPool=TabId[index].nPool;

	if ((nPool<0) || (nPool>=(int8_t)NbrePool))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	EnterCriticalSection(&CriticalSectionResources);
	if (!Status_Ok)
	{
		LeaveCriticalSection(&CriticalSection);
		LeaveCriticalSection(&CriticalSectionResources);
		return(false);
	}

	while (ThreadPoolRequested[nPool])
	{
		LeaveCriticalSection(&CriticalSection);
		WaitForSingleObject(ThreadPoolFree[nPool],INFINITE);
		EnterCriticalSection(&CriticalSection);
		if (!Status_Ok)
		{
			LeaveCriticalSection(&CriticalSection);
			LeaveCriticalSection(&CriticalSectionResources);
			return(false);
		}
	}

	if (index<NbreUsers-1)
	{
		for(uint16_t j=index+1; j<NbreUsers; j++)
			TabId[j-1]=TabId[j];
	}
	NbreUsers--;
	TabId[NbreUsers].UserId=0;
	TabId[NbreUsers].nPool=-1;

	if (NbreUsers==0) FreePool();

	LeaveCriticalSection(&CriticalSection);
	LeaveCriticalSection(&CriticalSectionResources);

	return(true);
}


bool ThreadPoolInterface::RequestThreadPool(uint16_t UserId,uint8_t thread_number,Public_MT_Data_Thread *Data,int8_t nPool,bool Exclusive)
{
	if ((!Status_Ok) || Error_Occured) return(false);

	EnterCriticalSection(&CriticalSection);

	if ((!Status_Ok) || Error_Occured || (UserId==0) || (NbreUsers==0)
		|| (nPool>=(int8_t)NbrePool) || (nPool<-1) || (thread_number==0) || (Data==NULL))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	uint16_t userindex=0;

	while ((NbreUsers>userindex) && (TabId[userindex].UserId!=UserId)) userindex++;
	if (userindex==NbreUsers)
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	int8_t nP=TabId[userindex].nPool;

	if ((nP<-1) || (nP>=(int8_t)NbrePool))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	if (nP>=0)
	{
		if (!ThreadPoolRequested[nP])
		{
			LeaveCriticalSection(&CriticalSection);
			return(false);
		}

		if (thread_number==ptrPool[nP]->GetCurrentThreadUsed())
		{
			LeaveCriticalSection(&CriticalSection);
			return(true);
		}

		if ((nPool>=0) && (thread_number>ptrPool[nPool]->GetCurrentThreadAllocated()))
		{
			LeaveCriticalSection(&CriticalSection);
			return(false);
		}
	}

	bool dealocate_curent=false;

	if (nPool==-1)
	{
		bool check_ok=false;

		for(uint8_t i=0; i<NbrePool; i++)
			check_ok=check_ok || (thread_number<=ptrPool[i]->GetCurrentThreadAllocated());
		if (!check_ok)
		{
			LeaveCriticalSection(&CriticalSection);
			return(false);
		}

		if (nP>=0) dealocate_curent=true;
	}
	else
	{
		if (nP==-1)
		{
			if (thread_number>ptrPool[nPool]->GetCurrentThreadAllocated())
			{
				LeaveCriticalSection(&CriticalSection);
				return(false);
			}
		}
		else dealocate_curent=true;
	}
	
	EnterCriticalSection(&CriticalSectionResources);
	if ((!Status_Ok) || Error_Occured)
	{
		LeaveCriticalSection(&CriticalSection);
		LeaveCriticalSection(&CriticalSectionResources);
		return(false);
	}

	if (dealocate_curent)
	{
		LeaveCriticalSection(&CriticalSection);
		if (!ReleaseThreadPool(UserId))
		{
			LeaveCriticalSection(&CriticalSectionResources);
			return(false);
		}
		EnterCriticalSection(&CriticalSection);
		if ((!Status_Ok) || Error_Occured)
		{
			LeaveCriticalSection(&CriticalSection);
			LeaveCriticalSection(&CriticalSectionResources);
			return(false);
		}
	}

	while (ExclusiveMode)
	{
		LeaveCriticalSection(&CriticalSection);
		WaitForSingleObject(EndExclusive,INFINITE);
		EnterCriticalSection(&CriticalSection);
		if ((!Status_Ok) || Error_Occured)
		{
			LeaveCriticalSection(&CriticalSection);
			LeaveCriticalSection(&CriticalSectionResources);
			return(false);
		}
	}

	if (nPool==-1)
	{
		if ((NbrePool>1) && (!Exclusive))
		{
			HANDLE TabTemp[MAX_THREAD_POOL];
			uint8_t TabNbre[MAX_THREAD_POOL];

			uint8_t Nbre=0;
			for(uint8_t i=0; i<NbrePool; i++)
			{
				if (thread_number<=ptrPool[i]->GetCurrentThreadAllocated())
				{
					TabTemp[Nbre]=ThreadPoolFree[i];
					TabNbre[Nbre++]=i;
				}
			}

			bool PoolFree=false;

			while (!PoolFree)
			{
				LeaveCriticalSection(&CriticalSection);
				DWORD a=WaitForMultipleObjects(Nbre,TabTemp,FALSE,INFINITE);
				EnterCriticalSection(&CriticalSection);
				if ((!Status_Ok) || Error_Occured)
				{
					LeaveCriticalSection(&CriticalSection);
					LeaveCriticalSection(&CriticalSectionResources);
					return(false);
				}
				nPool=(int8_t)TabNbre[(a-WAIT_OBJECT_0)];
				PoolFree=!ThreadPoolRequested[nPool];
			}
		}
		else
		{
			int8_t i=0;
			while ((i<NbrePool) && (thread_number>ptrPool[i]->GetCurrentThreadAllocated())) i++;
			nPool=i;
		}
	}

	if ((!Exclusive) || (NbrePool==1))
	{
		while (ThreadPoolRequested[nPool])
		{
			LeaveCriticalSection(&CriticalSection);
			WaitForSingleObject(ThreadPoolFree[nPool],INFINITE);
			EnterCriticalSection(&CriticalSection);
			if ((!Status_Ok) || Error_Occured)
			{
				LeaveCriticalSection(&CriticalSection);
				LeaveCriticalSection(&CriticalSectionResources);
				return(false);
			}
		}
	}
	else
	{
		bool PoolFree=false;

		while (!PoolFree)
		{
			LeaveCriticalSection(&CriticalSection);
			WaitForMultipleObjects(NbrePool,ThreadPoolFree,TRUE,INFINITE);
			EnterCriticalSection(&CriticalSection);
			if ((!Status_Ok) || Error_Occured)
			{
				LeaveCriticalSection(&CriticalSection);
				LeaveCriticalSection(&CriticalSectionResources);
				return(false);
			}
			PoolFree=true;
			for(uint8_t i=0; i<NbrePool; i++)
				PoolFree=PoolFree && (!ThreadPoolRequested[i]);
		}
	}
	
	bool out=ptrPool[nPool]->RequestThreadPool(thread_number,Data);
	
	if (out)
	{
		ThreadPoolRequested[nPool]=true;
		ResetEvent(ThreadPoolFree[nPool]);
		if (Exclusive)
		{
			ExclusiveMode=true;
			ResetEvent(EndExclusive);
		}
		TabId[userindex].nPool=(int8_t)nPool;
	}
	else TabId[userindex].nPool=-1;
	
	LeaveCriticalSection(&CriticalSection);
	LeaveCriticalSection(&CriticalSectionResources);

	return(out);	
}


bool ThreadPoolInterface::ReleaseThreadPool(uint16_t UserId)
{
	if (!Status_Ok) return(false);

	EnterCriticalSection(&CriticalSection);

	if ((!Status_Ok) || (UserId==0) || (NbreUsers==0))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	uint16_t index=0;

	while ((NbreUsers>index) && (TabId[index].UserId!=UserId)) index++;
	if (index==NbreUsers)
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	int8_t nPool=TabId[index].nPool;

	if ((nPool<-1) || (nPool>=(int8_t)NbrePool))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	if (nPool==-1)
	{
		LeaveCriticalSection(&CriticalSection);
		return(true);
	}

	bool out=true;

	ThreadPoolReleased[nPool]=true;

	if (ThreadPoolRequested[nPool])
	{
		while (JobsRunning[nPool])
		{
			LeaveCriticalSection(&CriticalSection);
			WaitForSingleObject(JobsEnded[nPool],INFINITE);
			EnterCriticalSection(&CriticalSection);
			if (!Status_Ok)
			{
				ThreadPoolReleased[nPool]=false;
				LeaveCriticalSection(&CriticalSection);
				return(false);
			}
		}
		ThreadPoolRequested[nPool]=false;
		out=ptrPool[nPool]->ReleaseThreadPool();
		SetEvent(ThreadPoolFree[nPool]);
		TabId[index].nPool=-1;
	}

	if (ExclusiveMode)
	{
		ExclusiveMode=false;
		SetEvent(EndExclusive);
	}

	ThreadPoolReleased[nPool]=false;

	LeaveCriticalSection(&CriticalSection);

	return(out);
}


bool ThreadPoolInterface::StartThreads(uint16_t UserId)
{
	if ((!Status_Ok) || Error_Occured) return(false);

	EnterCriticalSection(&CriticalSection);

	if ((!Status_Ok) || Error_Occured || (UserId==0) || (NbreUsers==0))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	uint16_t index=0;

	while ((NbreUsers>index) && (TabId[index].UserId!=UserId)) index++;
	if (index==NbreUsers)
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	int8_t nPool=TabId[index].nPool;

	if ((nPool<0) || (nPool>=(int8_t)NbrePool))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	if ((!ThreadPoolRequested[nPool]) || ThreadPoolReleased[nPool])
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	if (JobsRunning[nPool])
	{
		LeaveCriticalSection(&CriticalSection);
		return(true);
	}

	bool out=ptrPool[nPool]->StartThreads();

	if (out)
	{
		JobsRunning[nPool]=true;
		ResetEvent(JobsEnded[nPool]);
	}

	LeaveCriticalSection(&CriticalSection);

	return(out);	
}



bool ThreadPoolInterface::WaitThreadsEnd(uint16_t UserId)
{
	if (!Status_Ok) return(false);

	EnterCriticalSection(&CriticalSection);

	if  ((!Status_Ok) || (UserId==0) || (NbreUsers==0))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	uint16_t index=0;

	while ((NbreUsers>index) && (TabId[index].UserId!=UserId)) index++;
	if (index==NbreUsers)
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	int8_t nPool=TabId[index].nPool;

	if ((nPool<0) || (nPool>=(int8_t)NbrePool))
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	if (!ThreadPoolRequested[nPool])
	{
		LeaveCriticalSection(&CriticalSection);
		return(false);
	}

	if (!JobsRunning[nPool])
	{
		LeaveCriticalSection(&CriticalSection);
		return(true);
	}

	bool out=ptrPool[nPool]->WaitThreadsEnd();

	if (out)
	{
		JobsRunning[nPool]=false;
		SetEvent(JobsEnded[nPool]);
	}

	LeaveCriticalSection(&CriticalSection);

	return(out);
}


bool ThreadPoolInterface::GetThreadPoolStatus(uint16_t UserId,int8_t nPool)
{
	if (Status_Ok && (NbrePool>0))
	{
		if ((UserId==0) || (NbreUsers==0))
		{
			if ((nPool>=0) && (nPool<(int8_t)NbrePool)) return(ptrPool[nPool]->GetThreadPoolStatus());
			else return(false);
		}
		else
		{
			uint16_t i=0;

			while ((NbreUsers>i) && (TabId[i].UserId!=UserId)) i++;
			if (i==NbreUsers)
			{
				if ((nPool>=0) && (nPool<(int8_t)NbrePool)) return(ptrPool[nPool]->GetThreadPoolStatus());
				else return(false);
			}
			if ((TabId[i].nPool>=0) && (TabId[i].nPool<(int8_t)NbrePool))
				return(ptrPool[TabId[i].nPool]->GetThreadPoolStatus());
			else return(false);		
		}
	}
	else return(false);
}


uint8_t ThreadPoolInterface::GetCurrentThreadAllocated(uint16_t UserId,int8_t nPool)
{
	if (Status_Ok && (NbrePool>0))
	{
		if ((UserId==0) || (NbreUsers==0))
		{
			if ((nPool>=0) && (nPool<(int8_t)NbrePool)) return(ptrPool[nPool]->GetCurrentThreadAllocated());
			else return(0);
		}
		else
		{
			uint16_t i=0;

			while ((NbreUsers>i) && (TabId[i].UserId!=UserId)) i++;
			if (i==NbreUsers)
			{
				if ((nPool>=0) && (nPool<(int8_t)NbrePool)) return(ptrPool[nPool]->GetCurrentThreadAllocated());
				else return(0);
			}
			if ((TabId[i].nPool>=0) && (TabId[i].nPool<(int8_t)NbrePool))
				return(ptrPool[TabId[i].nPool]->GetCurrentThreadAllocated());
			else return(0);		
		}
	}
	else return(0);
}


uint8_t ThreadPoolInterface::GetCurrentThreadUsed(uint16_t UserId,int8_t nPool)
{
	if (Status_Ok && (NbrePool>0))
	{
		if ((UserId==0) || (NbreUsers==0))
		{
			if ((nPool>=0) && (nPool<(int8_t)NbrePool)) return(ptrPool[nPool]->GetCurrentThreadUsed());
			else return(0);
		}
		else
		{
			uint16_t i=0;

			while ((NbreUsers>i) && (TabId[i].UserId!=UserId)) i++;
			if (i==NbreUsers)
			{
				if ((nPool>=0) && (nPool<(int8_t)NbrePool)) return(ptrPool[nPool]->GetCurrentThreadUsed());
				else return(0);
			}
			if ((TabId[i].nPool>=0) && (TabId[i].nPool<(int8_t)NbrePool))
				return(ptrPool[TabId[i].nPool]->GetCurrentThreadUsed());
			else return(0);		
		}
	}
	else return(0);
}


uint8_t ThreadPoolInterface::GetLogicalCPUNumber(void)
{
	if (Status_Ok && (NbrePool>0)) return(ptrPool[0]->GetLogicalCPUNumber());
	else return(0);
}


uint8_t ThreadPoolInterface::GetPhysicalCoreNumber(void)
{
	if (Status_Ok && (NbrePool>0)) return(ptrPool[0]->GetPhysicalCoreNumber());
	else return(0);
}

