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

#ifndef __ThreadPoolDef_H__
#define __ThreadPoolDef_H__

#include <stdint.h>

#define MAX_MT_THREADS 128  // Maximum possible 255
#define MAX_THREAD_POOL 64  // Maximum possible 127

typedef void (*ThreadPoolFunction)(void *ptr);

enum ThreadLevelName {NoneThreadLevel,IdleThreadLevel,LowestThreadLevel,BelowThreadLevel,
	NormalThreadLevel,AboveThreadLevel,HighestThreadLevel,CriticalThreadLevel};

typedef struct _Public_MT_Data_Thread
{
	ThreadPoolFunction pFunc;
	void *pClass;
	uint8_t f_process,thread_Id;
	void *pData;
} Public_MT_Data_Thread;


#endif // __ThreadPoolDef_H__
