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

// ThreadPoolDLL.cpp : Define the exported functions for using with the threadpool.
// Kind of API.

#include "./ThreadPool.h"

#define myfree(ptr) if (ptr!=NULL) { free(ptr); ptr=NULL;}
#define myCloseHandle(ptr) if (ptr!=NULL) { CloseHandle(ptr); ptr=NULL;}

static const int TabThreadLevel[8]={THREAD_PRIORITY_NORMAL,THREAD_PRIORITY_IDLE,THREAD_PRIORITY_LOWEST,
	THREAD_PRIORITY_BELOW_NORMAL,THREAD_PRIORITY_NORMAL,THREAD_PRIORITY_ABOVE_NORMAL,
	THREAD_PRIORITY_HIGHEST,THREAD_PRIORITY_TIME_CRITICAL};

// Helper function to count set bits in the processor mask.
static uint8_t CountSetBits(ULONG_PTR bitMask)
{
    DWORD LSHIFT = sizeof(ULONG_PTR)*8 - 1;
    uint8_t bitSetCount = 0;
    ULONG_PTR bitTest = (ULONG_PTR)1 << LSHIFT;    
    DWORD i;
    
    for (i = 0; i <= LSHIFT; ++i)
    {
        bitSetCount += ((bitMask & bitTest)?1:0);
        bitTest/=2;
    }

    return bitSetCount;
}


static void Get_CPU_Info(Arch_CPU& cpu)
{
    bool done = false;
    PSYSTEM_LOGICAL_PROCESSOR_INFORMATION buffer=NULL;
    PSYSTEM_LOGICAL_PROCESSOR_INFORMATION ptr=NULL;
    DWORD returnLength=0;
    uint8_t logicalProcessorCount=0;
    uint8_t processorCoreCount=0;
    DWORD byteOffset=0;

	cpu.NbLogicCPU=0;
	cpu.NbPhysCore=0;
	cpu.FullMask=0;

    while (!done)
    {
        BOOL rc=GetLogicalProcessorInformation(buffer, &returnLength);

        if (rc==FALSE) 
        {
            if (GetLastError()==ERROR_INSUFFICIENT_BUFFER) 
            {
                myfree(buffer);
                buffer=(PSYSTEM_LOGICAL_PROCESSOR_INFORMATION)malloc(returnLength);

                if (buffer==NULL) return;
            } 
            else
			{
				myfree(buffer);
				return;
			}
        } 
        else done=true;
    }

    ptr=buffer;

    while ((processorCoreCount<MAX_PHYSICAL_CORES) && ((byteOffset+sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION))<=returnLength))
    {
        switch (ptr->Relationship) 
        {
			case RelationProcessorCore :
	            // A hyperthreaded core supplies more than one logical processor.
				cpu.NbHT[processorCoreCount]=CountSetBits(ptr->ProcessorMask);
		        logicalProcessorCount+=cpu.NbHT[processorCoreCount];
				cpu.ProcMask[processorCoreCount++]=ptr->ProcessorMask;
				cpu.FullMask|=ptr->ProcessorMask;
			    break;
			default : break;
        }
        byteOffset+=sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION);
        ptr++;
    }
	free(buffer);

	cpu.NbPhysCore=processorCoreCount;
	cpu.NbLogicCPU=logicalProcessorCount;
}


static ULONG_PTR GetCPUMask(ULONG_PTR bitMask, uint8_t CPU_Nb)
{
    uint8_t LSHIFT=sizeof(ULONG_PTR)*8-1;
    uint8_t i=0,bitSetCount=0;
    ULONG_PTR bitTest=1;    

	CPU_Nb++;
	while (i<=LSHIFT)
	{
		if ((bitMask & bitTest)!=0) bitSetCount++;
		if (bitSetCount==CPU_Nb) return(bitTest);
		else
		{
			i++;
			bitTest<<=1;
		}
	}
	return(0);
}


static void CreateThreadsMasks(Arch_CPU cpu, ULONG_PTR *TabMask,uint8_t NbThread,uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore)
{
	if (NbThread==0) return;

	memset(TabMask,0,NbThread*sizeof(ULONG_PTR));

	if ((cpu.NbLogicCPU==0) || (cpu.NbPhysCore==0)) return;

	uint8_t i_cpu=offset_core%cpu.NbPhysCore;
	uint8_t i_ht=offset_ht%cpu.NbHT[i_cpu];
	uint8_t current_thread=0,nb_cpu=0;

	if (cpu.NbPhysCore==cpu.NbLogicCPU)
	{
		while (NbThread>current_thread)
		{
			uint8_t Nb_Core_Th=NbThread/cpu.NbPhysCore+( ((NbThread%cpu.NbPhysCore)>nb_cpu) ? 1:0 );

			for(uint8_t i=0; i<Nb_Core_Th; i++)
				TabMask[current_thread++]=GetCPUMask(cpu.ProcMask[i_cpu],0);

			nb_cpu++;
			i_cpu=(i_cpu+1)%cpu.NbPhysCore;
		}
	}
	else
	{
		if (UseMaxPhysCore)
		{
			if (NbThread>cpu.NbPhysCore)
			{
				while (NbThread>current_thread)
				{
					uint8_t Nb_Core_Th=NbThread/cpu.NbPhysCore+( ((NbThread%cpu.NbPhysCore)>nb_cpu) ? 1:0 );

					for(uint8_t i=0; i<Nb_Core_Th; i++)
						TabMask[current_thread++]=GetCPUMask(cpu.ProcMask[i_cpu],(i+i_ht)%cpu.NbHT[i_cpu]);

					nb_cpu++;
					i_cpu=(i_cpu+1)%cpu.NbPhysCore;
				}
			}
			else
			{
				while (NbThread>current_thread)
				{
					TabMask[current_thread++]=GetCPUMask(cpu.ProcMask[i_cpu],i_ht);
					i_cpu=(i_cpu+1)%cpu.NbPhysCore;
				}
			}
		}
		else
		{
			while (NbThread>current_thread)
			{
				uint8_t Nb_Core_Th=NbThread/cpu.NbPhysCore+( ((NbThread%cpu.NbPhysCore)>nb_cpu) ? 1:0 );

				Nb_Core_Th=(Nb_Core_Th<(cpu.NbHT[i_cpu]-i_ht)) ? (cpu.NbHT[i_cpu]-i_ht):Nb_Core_Th;
				Nb_Core_Th=(Nb_Core_Th<=(NbThread-current_thread)) ? Nb_Core_Th:(NbThread-current_thread);

				for (uint8_t i=0; i<Nb_Core_Th; i++)
					TabMask[current_thread++]=GetCPUMask(cpu.ProcMask[i_cpu],i+i_ht);

				i_cpu=(i_cpu+1)%cpu.NbPhysCore;
				nb_cpu++;
				i_ht=0;
			}
		}
	}
}


DWORD WINAPI ThreadPool::StaticThreadpool(LPVOID lpParam )
{
	const MT_Data_Thread *data=(MT_Data_Thread *)lpParam;
	
	while (true)
	{
		WaitForSingleObject(data->nextJob,INFINITE);
		switch(data->f_process)
		{
			case 1 :
				if (data->MTData!=NULL)
				{
					data->MTData->thread_Id=data->thread_Id;
					if (data->MTData->pFunc!=NULL) data->MTData->pFunc(data->MTData);
				}
				break;
			case 255 : return(0); break;
			default : break;
		}
		ResetEvent(data->nextJob);
		SetEvent(data->jobFinished);
	}
}


ThreadPool::ThreadPool(void): Status_Ok(true)
{
	int16_t i;

	for (i=0; i<MAX_MT_THREADS; i++)
	{
		jobFinished[i]=NULL;
		nextJob[i]=NULL;
		MT_Thread[i].MTData=NULL;
		MT_Thread[i].f_process=0;
		MT_Thread[i].thread_Id=(uint8_t)i;
		MT_Thread[i].jobFinished=NULL;
		MT_Thread[i].nextJob=NULL;
		thds[i]=NULL;
		tids[i]=0;
		ThreadMask[i]=0;
		ThreadSleep[i]=true;
	}
	nPriority=NormalThreadLevel;
	TotalThreadsRequested=0;
	CurrentThreadsAllocated=0;
	CurrentThreadsUsed=0;

	Get_CPU_Info(CPU);
	Status_Ok=!(((CPU.NbLogicCPU==0) || (CPU.NbPhysCore==0)));
}



void ThreadPool::FreeThreadPool(void) 
{
	int16_t i;

	if (TotalThreadsRequested>0)
	{
		const int nPr=TabThreadLevel[AboveThreadLevel];

		for (i=TotalThreadsRequested-1; i>=0; i--)
		{
			if (thds[i]!=NULL)
			{
				SetThreadPriority(thds[i],nPr);
				if (ThreadSleep[i]) ResumeThread(thds[i]);
				MT_Thread[i].f_process=255;
				SetEvent(nextJob[i]);
				WaitForSingleObject(thds[i],INFINITE);
				myCloseHandle(thds[i]);
				MT_Thread[i].f_process=0;
				MT_Thread[i].MTData=NULL;
				MT_Thread[i].jobFinished=NULL;
				MT_Thread[i].nextJob=NULL;
				ThreadSleep[i]=true;
			}
		}

		for (i=TotalThreadsRequested-1; i>=0; i--)
		{
			myCloseHandle(nextJob[i]);
			myCloseHandle(jobFinished[i]);
		}
	}

	nPriority=NormalThreadLevel;
	TotalThreadsRequested=0;
	CurrentThreadsAllocated=0;
	CurrentThreadsUsed=0;
}


/*
This function is called by the destructor only, meaning there
is a high probability being in an "unload DLL" stage when this
function is called.
In normal usage, threads should have been exited "properly"
before by a FreeThreadPool call, and this function should
do nothing. But, if unfortunately it's not the case, this
function will clean-up the remaining threads in the "hard" way,
the "proper" way not being possible anymore if we are in
an "unload DLL" stage.
*/

void ThreadPool::DestroyThreadPool(void) 
{
	int16_t i;

	if (TotalThreadsRequested>0)
	{
		for (i=TotalThreadsRequested-1; i>=0; i--)
		{
			if (thds[i]!=NULL)
			{
				TerminateThread(thds[i],0);
				myCloseHandle(thds[i]);
			}
		}

		for (i=TotalThreadsRequested-1; i>=0; i--)
		{
			myCloseHandle(nextJob[i]);
			myCloseHandle(jobFinished[i]);
		}
	}
}


ThreadPool::~ThreadPool()
{
	DestroyThreadPool();
}


uint8_t ThreadPool::GetThreadNumber(uint8_t thread_number,bool logical)
{
	const uint8_t nCPU=(logical) ? CPU.NbLogicCPU:CPU.NbPhysCore;

	return((thread_number==0) ? ((nCPU>MAX_MT_THREADS) ? MAX_MT_THREADS:nCPU):thread_number);
}


bool ThreadPool::AllocateThreads(uint8_t thread_number,uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore,
	bool SetAffinity,bool sleep,ThreadLevelName priority)
{
	if ((!Status_Ok) || (thread_number==0)) return(false);

	if (thread_number>CurrentThreadsAllocated)
	{
		TotalThreadsRequested=thread_number;
		CreateThreadPool(offset_core,offset_ht,UseMaxPhysCore,SetAffinity,sleep,priority);
	}

	return(Status_Ok);
}


bool ThreadPool::DeAllocateThreads(void)
{
	if (!Status_Ok) return(false);

	FreeThreadPool();

	return(true);
}


bool ThreadPool::ChangeThreadsAffinity(uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore,bool SetAffinity)
{
	if ((!Status_Ok) || (CurrentThreadsAllocated==0)) return(false);

	CreateThreadsMasks(CPU,ThreadMask,TotalThreadsRequested,offset_core,offset_ht,UseMaxPhysCore);

	for(uint8_t i=0; i<CurrentThreadsAllocated; i++)
		SetThreadAffinityMask(thds[i],SetAffinity?ThreadMask[i]:CPU.FullMask);

	return(true);
}


bool ThreadPool::ChangeThreadsLevel(ThreadLevelName priority)
{
	if ((!Status_Ok) || (CurrentThreadsAllocated==0)) return(false);

	if (priority!=NoneThreadLevel)
	{
		const int nPr=TabThreadLevel[priority];

		nPriority=priority;
		for(int16_t i=0; i<(int16_t)CurrentThreadsUsed; i++)
			SetThreadPriority(thds[i],nPr);
	}

	return(true);
}


void ThreadPool::CreateThreadPool(uint8_t offset_core,uint8_t offset_ht,bool UseMaxPhysCore,
	bool SetAffinity,bool sleep,ThreadLevelName priority)
{
	int16_t i;

	CreateThreadsMasks(CPU,ThreadMask,TotalThreadsRequested,offset_core,offset_ht,UseMaxPhysCore);

	if (sleep)
	{
		for(i=0; i<(int16_t)CurrentThreadsAllocated; i++)
		{
			SetThreadAffinityMask(thds[i],SetAffinity?ThreadMask[i]:CPU.FullMask);
			if (!ThreadSleep[i])
			{
				SuspendThread(thds[i]);
				ThreadSleep[i]=true;
			}
		}
	}
	else
	{
		for(i=0; i<(int16_t)CurrentThreadsAllocated; i++)
		{
			SetThreadAffinityMask(thds[i],SetAffinity?ThreadMask[i]:CPU.FullMask);
			if (ThreadSleep[i])
			{
				ResumeThread(thds[i]);
				ThreadSleep[i]=false;
			}
		}
	}

	if (priority!=NoneThreadLevel) nPriority=priority;

	if (CurrentThreadsAllocated==TotalThreadsRequested) return;

	i=(int16_t)CurrentThreadsAllocated;
	while ((i<(int16_t)TotalThreadsRequested) && Status_Ok)
	{
		jobFinished[i]=CreateEvent(NULL,TRUE,TRUE,NULL);
		nextJob[i]=CreateEvent(NULL,TRUE,FALSE,NULL);
		MT_Thread[i].jobFinished=jobFinished[i];
		MT_Thread[i].nextJob=nextJob[i];
		Status_Ok=Status_Ok && ((MT_Thread[i].jobFinished!=NULL) && (MT_Thread[i].nextJob!=NULL));
		i++;
	}
	if (!Status_Ok)
	{
		FreeThreadPool();
		return;
	}

	const int nPr=TabThreadLevel[IdleThreadLevel];

	i=(int16_t)CurrentThreadsAllocated;
	while ((i<(int16_t)TotalThreadsRequested) && Status_Ok)
	{
		thds[i]=CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)StaticThreadpool,&MT_Thread[i],CREATE_SUSPENDED,&tids[i]);
		Status_Ok=Status_Ok && (thds[i]!=NULL);
		if (Status_Ok)
		{
			SetThreadAffinityMask(thds[i],SetAffinity?ThreadMask[i]:CPU.FullMask);
			SetThreadPriority(thds[i],nPr);
			if (!sleep)
			{
				ResumeThread(thds[i]);
				ThreadSleep[i]=false;
			}
		}
		i++;
	}

	if (!Status_Ok) FreeThreadPool();
	else CurrentThreadsAllocated=TotalThreadsRequested;
}


bool ThreadPool::RequestThreadPool(uint8_t thread_number,Public_MT_Data_Thread *Data,ThreadLevelName priority)
{
	if ((!Status_Ok) || (thread_number>CurrentThreadsAllocated)) return(false);
	
	const int nPr=TabThreadLevel[(priority!=NoneThreadLevel)?priority:nPriority];

	for(uint8_t i=0; i<thread_number; i++)
	{
		MT_Thread[i].MTData=Data+i;
		SetThreadPriority(thds[i],nPr);
		if (ThreadSleep[i])
		{
			ResumeThread(thds[i]);
			ThreadSleep[i]=false;
		}
	}
	
	CurrentThreadsUsed=thread_number;

	return(true);	
}


bool ThreadPool::ReleaseThreadPool(bool sleep)
{
	if (!Status_Ok) return(false);

	if (CurrentThreadsUsed>0)
	{
		const int nPr=TabThreadLevel[IdleThreadLevel];

		for(uint8_t i=0; i<CurrentThreadsUsed; i++)
		{
			if (sleep)
			{
				SuspendThread(thds[i]);
				ThreadSleep[i]=true;
			}
			SetThreadPriority(thds[i],nPr);
			MT_Thread[i].MTData=NULL;
		}
		CurrentThreadsUsed=0;
	}

	return(true);
}


bool ThreadPool::StartThreads(void)
{
	if ((!Status_Ok) || (CurrentThreadsUsed==0)) return(false);

	for(uint8_t i=0; i<CurrentThreadsUsed; i++)
	{
		MT_Thread[i].f_process=1;
		ResetEvent(jobFinished[i]);
		SetEvent(nextJob[i]);
	}

	return(true);	
}


bool ThreadPool::WaitThreadsEnd(void)
{
	if ((!Status_Ok) || (CurrentThreadsUsed==0)) return(false);

	WaitForMultipleObjects(CurrentThreadsUsed,jobFinished,TRUE,INFINITE);

	for(uint8_t i=0; i<CurrentThreadsUsed; i++)
		MT_Thread[i].f_process=0;

	return(true);
}
