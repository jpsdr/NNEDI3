/*
**                    nnedi3 v0.9.4.27 for Avs+/Avisynth 2.6.x
**
**   Copyright (C) 2010-2011 Kevin Stone
**
**   This program is free software; you can redistribute it and/or modify
**   it under the terms of the GNU General Public License as published by
**   the Free Software Foundation; either version 2 of the License, or
**   (at your option) any later version.
**
**   This program is distributed in the hope that it will be useful,
**   but WITHOUT ANY WARRANTY; without even the implied warranty of
**   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**   GNU General Public License for more details.
**
**   You should have received a copy of the GNU General Public License
**   along with this program; if not, write to the Free Software
**   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#include <windows.h>
#define _USE_MATH_DEFINES
#include <math.h>
#include <tchar.h>
#include <process.h>
#include <float.h>
#include <stdio.h>
#include <stdint.h>
#include "avisynth.h"
#include "PlanarFrame.h"
#include "ThreadPoolInterface.h"

#define NUM_NSIZE 7
#define NUM_NNS 5
const int xdiaTable[NUM_NSIZE] = {8,16,32,48,8,16,32};
const int ydiaTable[NUM_NSIZE] = {6,6,6,6,4,4,4};
const int nnsTable[NUM_NNS] = {16,32,64,128,256};
const int nnsTablePow2[NUM_NNS] = {4,5,6,7,8};

#define CB2(n) max(min((n),254),0)

struct PS_INFO {
	int field[3], ident;
	const uint8_t *srcp[3];
	uint8_t *dstp[3];
	int src_pitch[3],dst_pitch[3];
	int height[3],width[3];
	int sheight[3],eheight[3];
	int sheight2[3],eheight2[3];
	int *lcount[3],opt,qual;
	float *input,*temp;
	float *weights0,**weights1;
	int asize,nns,xdia,ydia,fapprox;
	bool Y,U,V;
	int pscrn;
	IScriptEnvironment *env;
};

class nnedi3 : public GenericVideoFilter
{
protected:
	bool dh,Y,U,V;
	int pscrn;
	int field,threads,opt,nns,etype;
	int *lcount[3],qual,nsize,fapprox;
	PlanarFrame *srcPF,*dstPF;
	PS_INFO pssInfo[MAX_MT_THREADS];
	size_t Cache_Setting;
	float *weights0,*weights1[2];
	CRITICAL_SECTION CriticalSection;
	BOOL CSectionOk;
	uint8_t threads_number;
	Public_MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	uint16_t UserId;

	void calcStartEnd2(PVideoFrame dst);
	void copyPad(int n,int fn,IScriptEnvironment *env);

	ThreadPoolFunction StaticThreadpoolF;

	static void StaticThreadpool(void *ptr);

	void FreeData(void);

public:
	nnedi3(PClip _child,int _field,bool _dh,bool _Y,bool _U,bool _V,int _nsize,int _nns,int _qual,int _etype,
		int _pscrn,int _threads,int _opt,int _fapprox,IScriptEnvironment *env);
	~nnedi3();
	PVideoFrame __stdcall nnedi3::GetFrame(int n,IScriptEnvironment *env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);
};

// new prescreener functions
void uc2s64_C(const uint8_t *t,const int pitch,float *p);
void computeNetwork0new_C(const float *datai,const float *weights,uint8_t *d);
