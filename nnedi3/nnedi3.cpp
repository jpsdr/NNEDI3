/*
**                    nnedi3 v0.9.4.4 for Avisynth 2.6.x
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
**
**   Modified by JPSDR
*/

#include "nnedi3.h"
#include <stdint.h>


extern "C" void computeNetwork0_SSE2(const float *input,const float *weights,uint8_t *d);
extern "C" void computeNetwork0_i16_SSE2(const float *inputf,const float *weightsf,uint8_t *d);
extern "C" void uc2f48_SSE2(const uint8_t *t,const int pitch,float *p);
extern "C" void uc2s48_SSE2(const uint8_t *t,const int pitch,float *pf);
extern "C" int processLine0_SSE2_ASM(const uint8_t *tempu,int width,uint8_t *dstp,const uint8_t *src3p,const int src_pitch);
extern "C" void extract_m8_SSE2(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *input);
extern "C" void extract_m8_i16_SSE2(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *inputf);
extern "C" void dotProd_m32_m16_SSE2(const float *data,const float *weights,float *vals,const int n,const int len,const float *istd);
extern "C" void dotProd_m48_m16_SSE2(const float *data,const float *weights,float *vals,const int n,const int len,const float *istd);
extern "C" void dotProd_m32_m16_i16_SSE2(const float *dataf,const float *weightsf,float *vals,const int n,const int len,const float *istd);
extern "C" void dotProd_m48_m16_i16_SSE2(const float *dataf,const float *weightsf,float *vals,const int n,const int len,const float *istd);
extern "C" void e0_m16_SSE2(float *s,const int n);
extern "C" void e1_m16_SSE2(float *s,const int n);
extern "C" void e2_m16_SSE2(float *s,const int n);
extern "C" void weightedAvgElliottMul5_m16_SSE2(const float *w,const int n,float *mstd);
extern "C" void castScale_SSE(const float *val,const float *scale,uint8_t *dstp);
extern "C" void uc2s64_SSE2(const uint8_t *t,const int pitch,float *p);
extern "C" void computeNetwork0new_SSE2(const float *datai,const float *weights,uint8_t *d);


EXTERN_C IMAGE_DOS_HEADER __ImageBase;

int num_processors()
{
#ifdef _DEBUG
	return 1;
#else
	int pcount = 0;
	ULONG_PTR p_aff=0, s_aff=0;
	GetProcessAffinityMask(GetCurrentProcess(), &p_aff, &s_aff);
	for(; p_aff != 0; p_aff>>=1) 
		pcount += (p_aff&1);
	return pcount;
#endif
}

int roundds(const double f)
{
	if (f-floor(f) >= 0.5)
		return min((int)ceil(f),32767);
	return max((int)floor(f),-32768);
}

void shufflePreScrnL2L3(float *wf,float *rf,const int opt)
{
	int j_a=0;

	for (int j=0; j<4; ++j)
	{
		for (int k=0; k<4; ++k)
			wf[(k << 2)+j] = rf[j_a+k];
		j_a+=4;
	}
	rf+=20;
	wf+=20;
	const int jtable[4] = {0,2,1,3};
	for (int j=0; j<4; ++j)
	{
		int j_8=jtable[j] << 3;

		for (int k=0; k<8; ++k)
			wf[(k << 2)+j] = rf[j_8+k];
		wf[32+j] = rf[32+jtable[j]];
	}
}

nnedi3::nnedi3(PClip _child,int _field,bool _dh,bool _Y,bool _U,bool _V,int _nsize,int _nns,int _qual,int _etype,int _pscrn,
	int _threads,int _opt,int _fapprox,IScriptEnvironment *env) : GenericVideoFilter(_child),field(_field),dh(_dh),Y(_Y),U(_U),V(_V),
	nsize(_nsize),nns(_nns),qual(_qual),etype(_etype),pscrn(_pscrn),threads(_threads),opt(_opt),fapprox(_fapprox)
{
	int PlaneMax=3;

	if ((field<-2) || (field>3)) env->ThrowError("nnedi3:  field must be set to -2, -1, 0, 1, 2, or 3!");
	if ((threads<0) || (threads>16)) env->ThrowError("nnedi3:  threads must be between 0 and 16 inclusive!");
	if (dh && ((field<-1) || (field>1))) env->ThrowError("nnedi3:  field must be set to -1, 0, or 1 when dh=true!");
	if ((nsize<0) || (nsize>=NUM_NSIZE)) env->ThrowError("nnedi3:  nsize must be in [0,%d]!\n",NUM_NSIZE-1);
	if ((nns<0) || (nns>=NUM_NNS)) env->ThrowError("nnedi3:  nns must be in [0,%d]!\n",NUM_NNS-1);
	if ((qual<1) || (qual>2)) env->ThrowError("nnedi3:  qual must be set to 1 or 2!\n");
	if ((opt<0) || (opt>2)) env->ThrowError("nnedi3:  opt must be set to 0, 1, or 2!");
	if ((fapprox<0) || (fapprox>15)) env->ThrowError("nnedi3:  fapprox must be [0,15]!\n");
	if ((pscrn<0) || (pscrn>4)) env->ThrowError("nnedi3:  pscrn must be [0,4]!\n");
	if ((etype<0) || (etype>1)) env->ThrowError("nnedi3:  etype must be [0,1]!\n");
	if (field==-2) field = child->GetParity(0) ? 3 : 2;
	else
	{
		if (field==-1) field = child->GetParity(0) ? 1 : 0;
	}
	if (field>1)
	{
		vi.num_frames*=2;
		vi.SetFPS(vi.fps_numerator*2,vi.fps_denominator);
	}
	if (dh) vi.height*=2;
	vi.SetFieldBased(false);
	child->SetCacheHints(CACHE_25_RANGE,3);
	if (threads==0) threads=num_processors();
	srcPF = new PlanarFrame();
	if (vi.IsYV12()) srcPF->createPlanar(vi.height+12,(vi.height>>1)+12,vi.width+64,(vi.width>>1)+64);
	else
	{
		if (vi.IsYV16() || vi.IsYUY2()) srcPF->createPlanar(vi.height+12,vi.height+12,vi.width+64,(vi.width>>1)+64);
		else
		{
			if (vi.IsYV24() || vi.IsRGB24()) srcPF->createPlanar(vi.height+12,vi.height+12,vi.width+64,vi.width+64);
			else
			{
				if (vi.IsY8())
				{
					srcPF->createPlanar(vi.height+12,0,vi.width+64,0);
					U = false;
					V = false;
					PlaneMax=1;
				}
			}
		}
	}
	dstPF = new PlanarFrame(vi);
	if (opt==0)
	{
		const int cpuf = srcPF->cpu;

		if ((cpuf&CPU_SSE2)!=0) opt=2;
		else opt=1;
		char buf[512];
		sprintf(buf,"nnedi3:  auto-detected opt setting = %d (%d)\n",opt,cpuf);
		OutputDebugString(buf);
	}
	const int dims0 = 49*4+5*4+9*4;
	const int dims0new = 4*65+4*5;
	const int dims1 = (xdiaTable[nsize]*ydiaTable[nsize]+1) << (nnsTablePow2[nns]+1);
	int dims1tsize = 0, dims1offset;
	for (int j=0; j<NUM_NNS; ++j)
	{
		int j_a;

		j_a=nnsTablePow2[j]+2;
		for (int i=0; i<NUM_NSIZE; ++i)
		{
			if ((i==nsize) && (j==nns)) dims1offset=dims1tsize;
			dims1tsize+=(xdiaTable[i]*ydiaTable[i]+1) << j_a;
		}
	}
	weights0 = (float*)_aligned_malloc(max(dims0,dims0new)*sizeof(float),16);
	for (int i=0; i<2; ++i)
		weights1[i] = (float*)_aligned_malloc(dims1*sizeof(float),16);
	for (int i=0; i<3; ++i)
		lcount[i]=NULL;
	for (int i=0; i<PlaneMax; ++i)
		lcount[i] = (int*)_aligned_malloc(dstPF->GetHeight(i)*sizeof(int),16);
	char nbuf[512];
	GetModuleFileName((HINSTANCE)&__ImageBase,nbuf,512);
	HMODULE hmod = GetModuleHandle(nbuf);
	if (!hmod) env->ThrowError("nnedi3:  unable to get module handle!");
	HRSRC hrsrc = FindResource(hmod,MAKEINTRESOURCE(101),_T("BINARY"));
	HGLOBAL hglob = LoadResource(hmod,hrsrc);
	LPVOID lplock = LockResource(hglob);
	DWORD dwSize = SizeofResource(hmod,hrsrc);
	if ((hmod==NULL) || (hrsrc==NULL) || (hglob==NULL) || (lplock==NULL) || (dwSize!=(dims0+dims0new*3+dims1tsize*2)*sizeof(float)))
		env->ThrowError("nnedi3:  error loading resource (%x,%x,%x,%x,%d,%d)!",hmod,hrsrc,hglob,lplock,dwSize,
		(dims0+dims0new*3+dims1tsize*2)*sizeof(float));
	float *bdata = (float*)lplock;
	// Adjust prescreener weights
	if (pscrn>=2) // using new prescreener
	{
		int *offt = (int*)calloc(4*64,sizeof(int));
		int j_a;

		j_a=0;
		for (int j=0; j<4; ++j)
		{
			int j_3=(j&3) << 3;

			for (int k=0; k<64; ++k)
				offt[j_a+k] = ((k>>3)<<5)+j_3+(k&7);
			j_a+=64;
		}

		const float *bdw = bdata+dims0+dims0new*(pscrn-2);
		int16_t *ws = (int16_t*)weights0;
		float *wf = (float*)&ws[4*64];
		double mean[4] = {0.0,0.0,0.0,0.0};

		// Calculate mean weight of each first layer neuron
		j_a=0;
		for (int j=0; j<4; ++j)
		{
			double cmean = 0.0;

			for (int k=0; k<64; ++k)
				cmean += bdw[offt[j_a+k]];
			mean[j] = cmean/64.0;
			j_a+=64;
		}
		// Factor mean removal and 1.0/127.5 scaling 
		// into first layer weights. scale to int16 range
		j_a=0;
		for (int j=0; j<4; ++j)
		{
			double mval = 0.0;

			for (int k=0; k<64; ++k)
				mval = max(mval,fabs((bdw[offt[j_a+k]]-mean[j])/127.5));
			const double scale = 32767.0/mval;
			for (int k=0; k<64; ++k)
				ws[offt[j_a+k]] = roundds(((bdw[offt[j_a+k]]-mean[j])/127.5)*scale);
			wf[j] = (float)(mval/32767.0);
			j_a+=64;
		}
		memcpy(wf+4,bdw+4*64,(dims0new-4*64)*sizeof(float));
		free(offt);
	}
	else // using old prescreener
	{
		double mean[4] = {0.0,0.0,0.0,0.0};
		int j_a;

		// Calculate mean weight of each first layer neuron
		j_a=0;
		for (int j=0; j<4; ++j)
		{
			double cmean = 0.0;

			for (int k=0; k<48; ++k)
				cmean += bdata[j_a+k];
			mean[j] = cmean/48.0;
			j_a+=48;
		}
		if (fapprox&1) // use int16 dot products in first layer
		{
			int16_t *ws = (int16_t*)weights0;
			float *wf = (float*)&ws[4*48];
			// Factor mean removal and 1.0/127.5 scaling 
			// into first layer weights. scale to int16 range
			j_a=0;
			for (int j=0; j<4; ++j)
			{
				double mval = 0.0;

				for (int k=0; k<48; ++k)
					mval = max(mval,fabs((bdata[j_a+k]-mean[j])/127.5));
				const double scale = 32767.0/mval;
				for (int k=0; k<48; ++k)
					ws[j_a+k] = roundds(((bdata[j_a+k]-mean[j])/127.5)*scale);
				wf[j] = (float)(mval/32767.0);
				j_a+=48;
			}
			memcpy(wf+4,bdata+4*48,(dims0-4*48)*sizeof(float));
			if (opt>1) // shuffle weight order for asm
			{
				int16_t *rs = (int16_t*)malloc(dims0*sizeof(float));
				int j_b=0;

				memcpy(rs,weights0,dims0*sizeof(float));
				j_a=0;
				for (int j=0; j<4; ++j)
				{
					for (int k=0; k<48; ++k)
						ws[((k >> 3) << 5)+j_b+(k&7)] = rs[j_a+k];
					j_a+=48;
					j_b+=8;
				}
				shufflePreScrnL2L3(wf+8,((float*)&rs[4*48])+8,opt);
				free(rs);
			}
		}
		else // use float dot products in first layer
		{
			// Factor mean removal and 1.0/127.5 scaling 
			// into first layer weights.
			j_a=0;
			for (int j=0; j<4; ++j)
			{
				for (int k=0; k<48; ++k)
					weights0[j_a+k] = (float)((bdata[j_a+k]-mean[j])/127.5);
				j_a+=48;
			}
			memcpy(weights0+4*48,bdata+4*48,(dims0-4*48)*sizeof(float));
			if (opt>1) // shuffle weight order for asm
			{
				float *wf = weights0;
				float *rf = (float*)malloc(dims0*sizeof(float));
				int j_b=0;

				memcpy(rf,weights0,dims0*sizeof(float));
				for (int j=0; j<4; ++j)
				{
					for (int k=0; k<48; ++k)
						wf[((k >> 2) << 4)+j_b+(k&3)] = rf[j_a+k];
					j_a+=48;
					j_b+=4;
				}
				shufflePreScrnL2L3(wf+4*49,rf+4*49,opt);
				free(rf);
			}
		}
	}
	// Adjust prediction weights
	for (int i=0; i<2; ++i)
	{
		const float *bdataT = bdata+dims0+dims0new*3+dims1tsize*etype+dims1offset+i*dims1;
		const int nnst = nnsTable[nns];
		const int nnst2 = nnst << 1;
		const int asize = xdiaTable[nsize]*ydiaTable[nsize];
		const int boff = nnst2*asize;
		double *mean = (double*)calloc(asize+1+nnst2,sizeof(double));
		int j_a,j_d;

		// Calculate mean weight of each neuron (ignore bias)
		j_a=0;
		for (int j=0; j<nnst2; ++j)
		{
			double cmean = 0.0;

			for (int k=0; k<asize; ++k)
				cmean += bdataT[j_a+k];
			mean[asize+1+j] = cmean/(double)asize;
			j_a+=asize;
		}
		// Calculate mean softmax neuron
		j_a=0;
		j_d=asize+1;
		for (int j=0; j<nnst; ++j)
		{
			for (int k=0; k<asize; ++k)
				mean[k] += bdataT[j_a+k]-mean[j_d];
			mean[asize] += bdataT[boff+j];
			j_a+=asize;
			j_d++;
		}
		for (int j=0; j<asize+1; ++j)
			mean[j] /= (double)(nnst);
		if (fapprox&2) // use int16 dot products
		{
			int16_t *ws = (int16_t*)weights1[i];
			float *wf = (float*)&ws[asize*nnst2];
			// Factor mean removal into weights, remove global offset from
			// softmax neurons, and scale weights to int16 range.
			j_a=0;
			j_d=asize+1;

			for (int j=0; j<nnst; ++j) // softmax neurons
			{
				double mval = 0.0;

				for (int k=0; k<asize; ++k)
					mval = max(mval,fabs(bdataT[j_a+k]-mean[j_d]-mean[k]));
				const double scale = 32767.0/mval;
				for (int k=0; k<asize; ++k)
					ws[j_a+k] = roundds((bdataT[j_a+k]-mean[j_d]-mean[k])*scale);
				wf[((j >> 2) << 3)+(j&3)] = (float)(mval/32767.0);
				wf[((j >> 2) << 3)+(j&3)+4] = (float)(bdataT[boff+j]-mean[asize]);
				j_a+=asize;
				j_d++;
			}
			for (int j=nnst; j<nnst2; ++j) // elliott neurons
			{
				double mval = 0.0;

				for (int k=0; k<asize; ++k)
					mval = max(mval,fabs(bdataT[j_a+k]-mean[j_d]));
				const double scale = 32767.0/mval;
				for (int k=0; k<asize; ++k)
					ws[j_a+k] = roundds((bdataT[j_a+k]-mean[j_d])*scale);
				wf[((j >> 2) << 3)+(j&3)] = (float)(mval/32767.0);
				wf[((j >> 2) << 3)+(j&3)+4] = bdataT[boff+j];
				j_a+=asize;
				j_d++;
			}
			if (opt>1) // shuffle weight order for asm
			{
				int16_t *rs = (int16_t*)malloc(nnst2*asize*sizeof(int16_t));

				memcpy(rs,ws,nnst2*asize*sizeof(int16_t));
				j_a=0;
				for (int j=0; j<nnst2; ++j)
				{
					int j_b=((j >> 2) << 2)*asize;
					int j_c=(j&3) << 3;

					for (int k=0; k<asize; ++k)
						ws[j_b+((k >> 3) << 5)+j_c+(k&7)] = rs[j_a+k];
					j_a+=asize;
				}
				free(rs);
			}
		}
		else // use float dot products
		{
			// Factor mean removal into weights, and remove global
			// offset from softmax neurons.
			j_a=0;
			j_d=asize+1;

			if (opt>1) // shuffle weight order for asm
			{
				for (int j=0; j<nnst2; ++j)
				{
					for (int k=0; k<asize; ++k)
					{
						const double q = j < nnst ? mean[k] : 0.0;
						int j_b=((j >> 2) << 2)*asize;
						int j_c=(j&3) << 2;

						weights1[i][j_b+((k >> 2) << 4)+j_c+(k&3)]=(float)(bdataT[j_a+k]-mean[j_d]-q);
					}
					weights1[i][boff+j] = (float)(bdataT[boff+j]-(j<nnst?mean[asize]:0.0));
					j_a+=asize;
					j_d++;
				}
			}
			else
			{
				for (int j=0; j<nnst2; ++j)
				{
					for (int k=0; k<asize; ++k)
					{
						const double q = j < nnst ? mean[k] : 0.0;

						weights1[i][j_a+k] = (float)(bdataT[j_a+k]-mean[j_d]-q);
					}
					weights1[i][boff+j] = (float)(bdataT[boff+j]-(j<nnst?mean[asize]:0.0));
					j_a+=asize;
					j_d++;
				}
			}
		}
		free(mean);
	}
	tids = (unsigned*)malloc(threads*sizeof(unsigned));
	thds = (HANDLE*)malloc(threads*sizeof(HANDLE));
	pssInfo = (PS_INFO**)malloc(threads*sizeof(PS_INFO*));
	int hslice[3],hremain[3];
	int srow[3] = {6,6,6};
	for (int i=0; i<PlaneMax; ++i)
	{
		const int height = srcPF->GetHeight(i)-12;
		hslice[i] = height/threads;
		hremain[i] = height%threads;
	}
	for (int i=0; i<threads; ++i)
	{
		pssInfo[i] = (PS_INFO*)malloc(sizeof(PS_INFO));
		pssInfo[i]->type = 0;
		pssInfo[i]->input = (float*)_aligned_malloc(512*sizeof(float),16);
		pssInfo[i]->temp = (float*)_aligned_malloc(2048*sizeof(float),16);
		pssInfo[i]->weights0 = weights0;
		pssInfo[i]->weights1 = weights1;
		pssInfo[i]->ident = i;
		pssInfo[i]->qual = qual;
		pssInfo[i]->pscrn = pscrn;
		pssInfo[i]->env = env;
		pssInfo[i]->opt = opt;
		pssInfo[i]->Y = Y;
		pssInfo[i]->U = U;
		pssInfo[i]->V = V;
		pssInfo[i]->nns = nnsTable[nns];
		pssInfo[i]->xdia = xdiaTable[nsize];
		pssInfo[i]->ydia = ydiaTable[nsize];
		pssInfo[i]->asize = xdiaTable[nsize]*ydiaTable[nsize];
		pssInfo[i]->fapprox = fapprox;
		for (int b=0; b<PlaneMax; ++b)
		{
			pssInfo[i]->lcount[b] = lcount[b];
			pssInfo[i]->dstp[b] = dstPF->GetPtr(b);
			pssInfo[i]->srcp[b] = srcPF->GetPtr(b);
			pssInfo[i]->dst_pitch[b] = dstPF->GetPitch(b);
			pssInfo[i]->src_pitch[b] = srcPF->GetPitch(b);
			pssInfo[i]->height[b] = srcPF->GetHeight(b);
			pssInfo[i]->width[b] = srcPF->GetWidth(b);
			pssInfo[i]->sheight[b] = srow[b];
			srow[b] += i == 0 ? hslice[b]+hremain[b] : hslice[b];
			pssInfo[i]->eheight[b] = srow[b];
		}
		pssInfo[i]->jobFinished = CreateEvent(NULL, TRUE, TRUE, NULL);
		pssInfo[i]->nextJob = CreateEvent(NULL, TRUE, FALSE, NULL);
		thds[i] = (HANDLE)_beginthreadex(0,0,&threadPool,(void*)(pssInfo[i]),0,&tids[i]);
	}
}

nnedi3::~nnedi3()
{
	delete srcPF;
	delete dstPF;
	_aligned_free(weights0);
	for (int i=0; i<2; ++i)
		_aligned_free(weights1[i]);
	for (int i=0; i<3; ++i)
		if (lcount[i]!=NULL) _aligned_free(lcount[i]);
	for (int i=0; i<threads; ++i)
	{
		pssInfo[i]->type = -1;
		SetEvent(pssInfo[i]->nextJob);
	}
	WaitForMultipleObjects(threads,thds,TRUE,INFINITE);
	for (int i=0; i<threads; ++i)
		CloseHandle(thds[i]);
	free(tids);
	free(thds);
	for (int i=0; i<threads; ++i)
	{
		CloseHandle(pssInfo[i]->jobFinished);
		CloseHandle(pssInfo[i]->nextJob);
		_aligned_free(pssInfo[i]->input);
		_aligned_free(pssInfo[i]->temp);
		free(pssInfo[i]);
	}
	free(pssInfo);
}

PVideoFrame __stdcall nnedi3::GetFrame(int n, IScriptEnvironment *env)
{
	int field_n;
	int PlaneMax=3;

	if (vi.IsY8()) PlaneMax=1;
	if (field>1)
	{
		if (n&1) field_n = field == 3 ? 0 : 1;
		else field_n = field == 3 ? 1 : 0;
	}
	else field_n = field;
	copyPad(field>1?(n>>1):n,field_n,env);
	for (int i=0; i<PlaneMax; ++i)
		memset(lcount[i],0,dstPF->GetHeight(i)*sizeof(int));
	PVideoFrame dst = env->NewVideoFrame(vi);
	const int plane[3] = {PLANAR_Y,PLANAR_U,PLANAR_V};
	for (int i=0; i<threads; ++i)
	{
		for (int b=0; b<PlaneMax; ++b)
		{
			const int srow = pssInfo[i]->sheight[b];
			pssInfo[i]->field[b] = (srow&1) ? 1-field_n : field_n;
			if (vi.IsYV12() || vi.IsYV16() || vi.IsYV24() || vi.IsY8())
			{
				pssInfo[i]->dstp[b] = dst->GetWritePtr(plane[b]);
				pssInfo[i]->dst_pitch[b] = dst->GetPitch(plane[b]);
			}
		}
		pssInfo[i]->type = 0;
		ResetEvent(pssInfo[i]->jobFinished);
		SetEvent(pssInfo[i]->nextJob);
	}
	for (int i=0; i<threads; ++i)
		WaitForSingleObject(pssInfo[i]->jobFinished,INFINITE);
	calcStartEnd2((vi.IsYV12() || vi.IsYV16() || vi.IsYV24() || vi.IsY8())?dst:NULL);
	for (int i=0; i<threads; ++i)
	{
		pssInfo[i]->type = 1;
		ResetEvent(pssInfo[i]->jobFinished);
		SetEvent(pssInfo[i]->nextJob);
	}
	for (int i=0; i<threads; ++i)
		WaitForSingleObject(pssInfo[i]->jobFinished,INFINITE);
	if (!(vi.IsYV12() || vi.IsYV16() || vi.IsYV24() || vi.IsY8())) dstPF->copyTo(dst, vi);
	return dst;
}

void nnedi3::copyPad(int n, int fn, IScriptEnvironment *env)
{
	const int off = 1-fn;
	PVideoFrame src = child->GetFrame(n, env);
	
	if (!dh)
	{
		if (vi.IsYV12() || vi.IsYV16() || vi.IsYV24())
		{
			const int plane[3] = {PLANAR_Y,PLANAR_U,PLANAR_V};

			for (int b=0; b<3; ++b)
				env->BitBlt(srcPF->GetPtr(b)+srcPF->GetPitch(b)*(6+off)+32,
					srcPF->GetPitch(b)*2,
					src->GetReadPtr(plane[b])+src->GetPitch(plane[b])*off,
					src->GetPitch(plane[b])*2,src->GetRowSize(plane[b]),
					src->GetHeight(plane[b])>>1);
		}
		else
		{
			if (vi.IsY8())
			{
				env->BitBlt(srcPF->GetPtr(0)+srcPF->GetPitch(0)*(6+off)+32,
					srcPF->GetPitch(0)*2,
					src->GetReadPtr(PLANAR_Y)+src->GetPitch(PLANAR_Y)*off,
					src->GetPitch(PLANAR_Y)*2,src->GetRowSize(PLANAR_Y),
					src->GetHeight(PLANAR_Y)>>1);
			}
			else
			{
				if (vi.IsYUY2())
				{
					srcPF->convYUY2to422(src->GetReadPtr()+src->GetPitch()*off,
						srcPF->GetPtr(0)+srcPF->GetPitch(0)*(6+off)+32,
						srcPF->GetPtr(1)+srcPF->GetPitch(1)*(6+off)+32,
						srcPF->GetPtr(2)+srcPF->GetPitch(2)*(6+off)+32,
						src->GetPitch()*2,srcPF->GetPitch(0)*2,srcPF->GetPitch(1)*2,
						vi.width,vi.height>>1);
				}
				else
				{
					if (vi.IsRGB24())
					{
						srcPF->convRGB24to444(src->GetReadPtr()+(vi.height-1-off)*src->GetPitch(),
							srcPF->GetPtr(0)+srcPF->GetPitch(0)*(6+off)+32,
							srcPF->GetPtr(1)+srcPF->GetPitch(1)*(6+off)+32,
							srcPF->GetPtr(2)+srcPF->GetPitch(2)*(6+off)+32,
							-src->GetPitch()*2,srcPF->GetPitch(0)*2,srcPF->GetPitch(1)*2,
							vi.width,vi.height>>1);
					}
				}
			}
		}
	}
	else
	{
		if (vi.IsYV12() || vi.IsYV16() || vi.IsYV24())
		{
			const int plane[3] = {PLANAR_Y,PLANAR_U,PLANAR_V};

			for (int b=0; b<3; ++b)
				env->BitBlt(srcPF->GetPtr(b)+srcPF->GetPitch(b)*(6+off)+32,
					srcPF->GetPitch(b)*2,src->GetReadPtr(plane[b]),
					src->GetPitch(plane[b]),src->GetRowSize(plane[b]),
					src->GetHeight(plane[b]));
		}
		else
		{
			if (vi.IsY8())
			{
				env->BitBlt(srcPF->GetPtr(0)+srcPF->GetPitch(0)*(6+off)+32,
					srcPF->GetPitch(0)*2,src->GetReadPtr(PLANAR_Y),
					src->GetPitch(PLANAR_Y),src->GetRowSize(PLANAR_Y),
					src->GetHeight(PLANAR_Y));
			}
			else
			{
				if (vi.IsYUY2())
				{
					srcPF->convYUY2to422(src->GetReadPtr(),
						srcPF->GetPtr(0)+srcPF->GetPitch(0)*(6+off)+32,
						srcPF->GetPtr(1)+srcPF->GetPitch(1)*(6+off)+32,
						srcPF->GetPtr(2)+srcPF->GetPitch(2)*(6+off)+32,
						src->GetPitch(),srcPF->GetPitch(0)*2,srcPF->GetPitch(1)*2,
						vi.width,vi.height>>1);
				}
				else
				{
					if (vi.IsRGB24())
					{
						srcPF->convRGB24to444(src->GetReadPtr()+((vi.height>>1)-1)*src->GetPitch(),
							srcPF->GetPtr(0)+srcPF->GetPitch(0)*(6+off)+32,
							srcPF->GetPtr(1)+srcPF->GetPitch(1)*(6+off)+32,
							srcPF->GetPtr(2)+srcPF->GetPitch(2)*(6+off)+32,
							-src->GetPitch(),srcPF->GetPitch(0)*2,srcPF->GetPitch(1)*2,
							vi.width,vi.height>>1);
					}
				}
			}
		}
	}

	int PlaneMax=3;

	if (vi.IsY8()) PlaneMax=1;
	for (int b=0; b<PlaneMax; ++b)
	{
		uint8_t *dstp = srcPF->GetPtr(b);
		const int dst_pitch = srcPF->GetPitch(b);
		const int dst_pitch2 = dst_pitch << 1;
		const int height = srcPF->GetHeight(b);
		const int height_6 = height-6;
		const int width = srcPF->GetWidth(b);

		dstp += (6+off)*dst_pitch;
		for (int y=6+off; y<height_6; y+=2)
		{
			for (int x=0; x<32; ++x)
				dstp[x] = dstp[64-x];

			int x_c=width-34;

			for (int x=width-32; x<width; ++x)
			{
				dstp[x] = dstp[x_c];
				x_c--;
			}
			dstp+=dst_pitch2;
		}
		dstp = srcPF->GetPtr(b);

		int off1=off*dst_pitch,off2=(12+off)*dst_pitch;

		for (int y=off; y<6; y+=2)
		{
			env->BitBlt(dstp+off1,dst_pitch,dstp+off2,dst_pitch,width,1);
			off1+=dst_pitch2;
			off2-=dst_pitch2;
		}

		off1=(height-6+off)*dst_pitch;
		off2=(height-10+off)*dst_pitch;
		for (int y=height-6+off; y<height; y+=2)
		{
			env->BitBlt(dstp+off1,dst_pitch,dstp+off2,dst_pitch,width,1);
			off1+=dst_pitch2;
			off2-=dst_pitch2;
		}
	}
}

void nnedi3::calcStartEnd2(PVideoFrame dst)
{
	const int plane[3]={PLANAR_Y,PLANAR_U,PLANAR_V};

	for (int b=0; b<3; ++b)
	{
		if (((b==0) && !Y) || ((b==1) && !U) || ((b==2) && !V)) continue;

		const int height = dstPF->GetHeight(b);
		int total=0,fl=-1,ll=0;

		for (int j=0; j<height; ++j)
		{ 
			total+=lcount[b][j];
			if ((fl<0) && (lcount[b][j]>0)) fl = j;
		}
		if (total==0) fl=height;
		else
		{
			for (int j=height-1; j>=0; --j)
			{
				if (lcount[b][j]!=0) break;
				++ll;
			}
		}
		int tslice=int(total/double(threads)+0.95);
		int count=0,countt=0,y=fl,yl=fl,th=0;

		const int height_ll=height-ll;

		while (y<height_ll)
		{
			count+=lcount[b][y++];
			if (count>=tslice)
			{
				pssInfo[th]->sheight2[b]=yl;
				countt+=count;
				if (countt==total) y=height_ll;
				pssInfo[th]->eheight2[b]=y;
				while ((y<height_ll) && (lcount[b][y]==0))
					++y;
				yl=y;
				count=0;
				++th;
			}
		}
		if (yl!=y)
		{
			pssInfo[th]->sheight2[b]=yl;
			countt+=count;
			if (countt==total) y=height_ll;
			pssInfo[th]->eheight2[b]=y;
			++th;
		}
		for (; th<threads; ++th)
			pssInfo[th]->sheight2[b] = pssInfo[th]->eheight2[b] = height;
	}
}

void elliott_C(float *data,const int n)
{
	for (int i=0; i<n; ++i)
		data[i] = data[i]/(1.0f+fabsf(data[i]));
}

void dotProd_C(const float *data,const float *weights,float *vals,const int n,const int len,const float *scale)
{
	int i_len=0;
	const int n_len=n*len;

	for (int i=0; i<n; ++i)
	{
		float sum = 0.0f;

		for (int j=0; j<len; ++j)
			sum += data[j]*weights[i_len+j];
		vals[i] = sum*scale[0]+weights[n_len+i];
		i_len+=len;
	}
}

void dotProdS_C(const float *dataf,const float *weightsf,float *vals,const int n,const int len,const float *scale)
{
	const int16_t *data = (int16_t*)dataf;
	const int16_t *weights = (int16_t*)weightsf;
	const float *wf = (float*)&weights[n*len];
	int i_len=0;

	for (int i=0; i<n; ++i)
	{
		int sum = 0, off = ((i >> 2) << 3)+(i&3);

		for (int j=0; j<len; ++j)
			sum += data[j]*weights[i_len+j];
		vals[i] = sum*wf[off]*scale[0]+wf[off+4];
		i_len+=len;
	}
}

void computeNetwork0_C(const float *input,const float *weights,uint8_t *d)
{
	float temp[12], scale = 1.0f;
	dotProd_C(input,weights,temp,4,48,&scale);
	const float t = temp[0];
	elliott_C(temp,4);
	temp[0]=t;
	dotProd_C(temp,weights+4*49,temp+4,4,4,&scale);
	elliott_C(temp+4,4);
	dotProd_C(temp,weights+4*49+4*5,temp+8,4,8,&scale);
	if (max(temp[10],temp[11])<=max(temp[8],temp[9])) d[0]=1;
	else d[0]=0;
}


void computeNetwork0_i16_C(const float *inputf,const float *weightsf,uint8_t *d)
{
	const float *wf = weightsf+2*48;
	float temp[12], scale = 1.0f;
	dotProdS_C(inputf,weightsf,temp,4,48,&scale);
	const float t = temp[0];
	elliott_C(temp,4);
	temp[0]=t;
	dotProd_C(temp,wf+8,temp+4,4,4,&scale);
	elliott_C(temp+4,4);
	dotProd_C(temp,wf+8+4*5,temp+8,4,8,&scale);
	if (max(temp[10],temp[11])<=max(temp[8],temp[9])) d[0] = 1;
	else d[0] = 0;
}


void uc2f48_C(const uint8_t *t,const int pitch,float *p)
{
	int y_pitch2=0,y_12=0;
	const int pitch2=pitch << 1;

	for (int y=0; y<4; ++y)
	{
		for (int x=0; x<12; ++x)
			p[y_12+x] = t[y_pitch2+x];
		y_12+=12;
		y_pitch2+=pitch2;
	}
}


void uc2s48_C(const uint8_t *t,const int pitch,float *pf)
{
	int y_pitch2=0,y_12=0;
	const int pitch2=pitch << 1;
	int16_t *p = (int16_t*)pf;

	for (int y=0; y<4; ++y)
	{
		for (int x=0; x<12; ++x)
			p[y_12+x] = t[y_pitch2+x];
		y_12+=12;
		y_pitch2+=pitch2;
	}
}

int processLine0_C(const uint8_t *tempu,int width,uint8_t *dstp,const uint8_t *src3p,const int src_pitch)
{
	int count=0;
	const int src_pitch2=src_pitch << 1,src_pitch4=src_pitch << 2,src_pitch6=src_pitch*6;

	for (int x=0; x<width; ++x)
	{
		if (tempu[x])
			dstp[x] = CB2((19*(src3p[x+src_pitch2]+src3p[x+src_pitch4])-
				3*(src3p[x]+src3p[x+src_pitch6])+16)>>5);
		else
		{
			dstp[x] = 255;
			++count;
		}
	}
	return count;
}


int processLine0_SSE2(const uint8_t *tempu,int width,uint8_t *dstp,const uint8_t *src3p,const int src_pitch)
{
	int count;
	const int remain = width&15;
	const int src_pitch2=src_pitch << 1,src_pitch4=src_pitch << 2,src_pitch6=src_pitch*6;

	width -= remain;
	if (width) count=processLine0_SSE2_ASM(tempu,width,dstp,src3p,src_pitch);
	else count=0;

	for (int x=width; x<width+remain; ++x)
	{
		if (tempu[x])
			dstp[x] = CB2((19*(src3p[x+src_pitch2]+src3p[x+src_pitch4])-
				3*(src3p[x]+src3p[x+src_pitch6])+16)>>5);
		else
		{
			dstp[x] = 255;
			++count;
		}
	}
	return count;
}

void evalFunc_0(void *ps)
{
	PS_INFO *pss = (PS_INFO*)ps;
	float *input = pss->input;
	const float *weights0 = pss->weights0;
	float *temp = pss->temp;
	uint8_t *tempu = (uint8_t*)temp;
	const int opt = pss->opt;
	const int pscrn = pss->pscrn;
	const int fapprox = pss->fapprox;
	void (*uc2s)(const uint8_t*,const int,float*);
	void (*computeNetwork0)(const float*,const float*,uint8_t *d);
	int (*processLine0)(const uint8_t*,int,uint8_t*,const uint8_t*,const int);

	if (opt==1) processLine0=processLine0_C;
	else processLine0=processLine0_SSE2;
	if (pscrn<2) // original prescreener
	{
		if (fapprox&1) // int16 dot products
		{
			if (opt==1) uc2s=uc2s48_C;
			else uc2s=uc2s48_SSE2;
			if (opt==1) computeNetwork0=computeNetwork0_i16_C;
			else computeNetwork0=computeNetwork0_i16_SSE2;
		}
		else
		{
			if (opt==1) uc2s=uc2f48_C;
			else uc2s=uc2f48_SSE2;
			if (opt==1) computeNetwork0=computeNetwork0_C;
			else computeNetwork0=computeNetwork0_SSE2;
		}
	}
	else // new prescreener
	{
		// only int16 dot products
		if (opt==1) uc2s=uc2s64_C;
		else uc2s=uc2s64_SSE2;
		if (opt==1) computeNetwork0=computeNetwork0new_C;
		else computeNetwork0=computeNetwork0new_SSE2;
	}
	for (int b=0; b<3; ++b)
	{
		if (((b==0) && !pss->Y) || ((b==1) && !pss->U) || ((b==2) && !pss->V)) continue;

		const uint8_t *srcp = pss->srcp[b];
		const int src_pitch = pss->src_pitch[b];
		const int width = pss->width[b];
		const int width_32=width-32;
		const int width_64=width-64;
		uint8_t *dstp = pss->dstp[b];
		const int dst_pitch = pss->dst_pitch[b];
		pss->env->BitBlt(dstp+(pss->sheight[b]-5-pss->field[b])*dst_pitch,
			dst_pitch*2,srcp+(pss->sheight[b]+1-pss->field[b])*src_pitch+32,
			src_pitch*2,width_64,(pss->eheight[b]-pss->sheight[b]+pss->field[b])>>1);
		const int ystart = pss->sheight[b]+pss->field[b];
		const int ystop = pss->eheight[b];
		const int src_pitch2=src_pitch << 1;
		const int dst_pitch2=dst_pitch << 1;

		srcp+=ystart*src_pitch;
		dstp+=(ystart-6)*dst_pitch-32;

		const uint8_t *src3p = srcp-src_pitch*3;
		int *lcount = pss->lcount[b]-6;

		if (pss->pscrn==1) // original
		{
			for (int y=ystart; y<ystop; y+=2)
			{
				for (int x=32; x<width_32; ++x)
				{
					uc2s(src3p+x-5,src_pitch,input);
					computeNetwork0(input,weights0,tempu+x);
				}
				lcount[y]+=processLine0(tempu+32,width_64,dstp+32,src3p+32,src_pitch);
				src3p+=src_pitch2;
				dstp+=dst_pitch2;
			}
		}
		else
		{
			if (pss->pscrn>=2) // new
			{
				for (int y=ystart; y<ystop; y+=2)
				{
					for (int x=32; x<width_32; x+=4)
					{
						uc2s(src3p+x-6,src_pitch,input);
						computeNetwork0(input,weights0,tempu+x);
					}
					lcount[y]+=processLine0(tempu+32,width_64,dstp+32,src3p+32,src_pitch);
					src3p+=src_pitch2;
					dstp+=dst_pitch2;
				}
			}
			else // no prescreening
			{
				for (int y=ystart; y<ystop; y+=2)
				{
					memset(dstp+32,255,width_64);
					lcount[y]+=width_64;
					dstp+=dst_pitch2;
				}
			}
		}
	}
}


void extract_m8_C(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *input)
{
	int sum = 0, sumsq = 0;
	const int stride2=stride << 1;
	int y_stride=0;

	for (int y=0; y<ydia; ++y)
	{
		const uint8_t *srcpT = srcp+y_stride;

		for (int x=0; x<xdia; ++x, ++input)
		{
			sum += srcpT[x];
			sumsq += srcpT[x]*srcpT[x];
			input[0] = srcpT[x];
		}
		y_stride+=stride2;
	}
	const float scale = 1.0f/(float)(xdia*ydia);

	mstd[0] = sum*scale;
	mstd[1] = sumsq*scale-mstd[0]*mstd[0];
	mstd[3] = 0.0f;
	if (mstd[1]<=FLT_EPSILON) mstd[1]=mstd[2]=0.0f;
	else
	{
		mstd[1]=sqrtf(mstd[1]);
		mstd[2]=1.0f/mstd[1];
	}
}


void extract_m8_i16_C(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *inputf)
{
	int16_t *input = (int16_t*)inputf;
	int sum = 0, sumsq = 0;
	const int stride2=stride << 1;
	int y_stride=0;

	for (int y=0; y<ydia; ++y)
	{
		const uint8_t *srcpT = srcp+y_stride;

		for (int x=0; x<xdia; ++x, ++input)
		{
			sum += srcpT[x];
			sumsq += srcpT[x]*srcpT[x];
			input[0] = srcpT[x];
		}
		y_stride+=stride2;
	}
	const float scale = 1.0f/(float)(xdia*ydia);
	mstd[0] = sum*scale;
	mstd[1] = sumsq*scale-mstd[0]*mstd[0];
	mstd[3] = 0.0f;
	if (mstd[1]<=FLT_EPSILON) mstd[1]=mstd[2]=0.0f;
	else
	{
		mstd[1]=sqrtf(mstd[1]);
		mstd[2]=1.0f/mstd[1];
	}
}


__declspec(align(16)) const float exp_lo[4] = { -80.0f, -80.0f, -80.0f, -80.0f };
__declspec(align(16)) const float exp_hi[4] = { +80.0f, +80.0f, +80.0f, +80.0f };

// exp from:  A Fast, Compact Approximation of the Exponential Function (1998)
//            Nicol N. Schraudolph

__declspec(align(16)) const float e0_mult[4] = { // (1.0/ln(2))*(2^23)
	12102203.161561486f, 12102203.161561486f, 12102203.161561486f, 12102203.161561486f };
__declspec(align(16)) const float e0_bias[4] = { // (2^23)*127.0-486411.0
	1064866805.0f, 1064866805.0f, 1064866805.0f, 1064866805.0f };

void e0_m16_C(float *s,const int n)
{
	for (int i=0; i<n; ++i)
	{
		const int t = (int)(max(min(s[i],exp_hi[0]),exp_lo[0])*e0_mult[0]+e0_bias[0]);
		s[i] = (*((float*)&t));
	}
}

// exp from Loren Merritt

_declspec(align(16)) const float e1_scale[4] = { // 1/ln(2)
	1.4426950409f, 1.4426950409f, 1.4426950409f, 1.4426950409f };
_declspec(align(16)) const float e1_bias[4] = { // 3<<22
	12582912.0f, 12582912.0f, 12582912.0f, 12582912.0f };
_declspec(align(16)) const float e1_c0[4] = { 1.00035f, 1.00035f, 1.00035f, 1.00035f };
_declspec(align(16)) const float e1_c1[4] = { 0.701277797f, 0.701277797f, 0.701277797f, 0.701277797f };
_declspec(align(16)) const float e1_c2[4] = { 0.237348593f, 0.237348593f, 0.237348593f, 0.237348593f };

void e1_m16_C(float *s,const int n)
{
	for (int q=0; q<n; ++q)
	{
		float x = max(min(s[q],exp_hi[0]),exp_lo[0])*e1_scale[0];
		int i = (int)(x + 128.5f) - 128;
		x -= i;
		x = e1_c0[0] + e1_c1[0]*x + e1_c2[0]*x*x;
		i = (i+127)<<23;
		s[q] = x * *((float*)&i);
	}
}

void e2_m16_C(float *s,const int n)
{
	for (int i=0; i<n; ++i)
		s[i] = expf(max(min(s[i],exp_hi[0]),exp_lo[0]));
}


__declspec(align(16)) const float min_weight_sum[4] = { 1e-10f, 1e-10f, 1e-10f, 1e-10f };

void weightedAvgElliottMul5_m16_C(const float *w,const int n,float *mstd)
{
	float vsum = 0.0f, wsum = 0.0f;

	for (int i=0; i<n; ++i)
	{
		vsum+=w[i]*(w[n+i]/(1.0f+fabsf(w[n+i])));
		wsum+=w[i];
	}
	if (wsum>min_weight_sum[0]) mstd[3]+=((5.0f*vsum)/wsum)*mstd[1]+mstd[0];
	else mstd[3]+=mstd[0];
}



void evalFunc_1(void *ps)
{
	PS_INFO *pss = (PS_INFO*)ps;
	float *input = pss->input;
	float *temp = pss->temp;
	float **weights1 = pss->weights1;
	const int opt = pss->opt;
	const int qual = pss->qual;
	const int asize = pss->asize;
	const int nns = pss->nns;
	const int nns2= nns << 1;
	const int xdia = pss->xdia;
	const int xdiad2m1 = (xdia>>1)-1;
	const int ydia = pss->ydia;
	const int fapprox = pss->fapprox;
	const float scale = 1.0f/(float)qual;
	void (*extract)(const uint8_t*,const int,const int,const int,float*,float*);
	void (*dotProd)(const float*,const float*,float*,const int,const int,const float*);
	void (*expf)(float *,const int);
	void (*wae5)(const float*,const int,float*);

	if (opt==1) wae5=weightedAvgElliottMul5_m16_C;
	else wae5=weightedAvgElliottMul5_m16_SSE2;
	if (fapprox&2) // use int16 dot products
	{
		if (opt==1) extract=extract_m8_i16_C;
		else extract=extract_m8_i16_SSE2;
		if (opt==1) dotProd=dotProdS_C;
		else dotProd= (asize%48) ? dotProd_m32_m16_i16_SSE2 : dotProd_m48_m16_i16_SSE2;
	}
	else // use float dot products
	{
		if (opt==1) extract=extract_m8_C;
		else extract=extract_m8_SSE2;
		if (opt==1) dotProd=dotProd_C;
		else dotProd= (asize%48) ? dotProd_m32_m16_SSE2 : dotProd_m48_m16_SSE2;
	}
	if ((fapprox&12)==0) // use slow exp
	{
		if (opt==1) expf=e2_m16_C;
		else expf=e2_m16_SSE2;
	}
	else if ((fapprox&12)==4) // use faster exp
	{
		if (opt == 1) expf=e1_m16_C;
		else expf=e1_m16_SSE2;
	}
	else // use fastest exp
	{
		if (opt==1) expf=e0_m16_C;
		else expf=e0_m16_SSE2;
	}
	for (int b=0; b<3; ++b)
	{
		if (((b==0) && !pss->Y) || ((b==1) && !pss->U) || ((b==2) && !pss->V)) continue;

		const uint8_t *srcp = pss->srcp[b];
		const int src_pitch = pss->src_pitch[b];
		const int width = pss->width[b];
		uint8_t *dstp = pss->dstp[b];
		const int dst_pitch = pss->dst_pitch[b];
		const int ystart = pss->sheight2[b];
		const int ystop = pss->eheight2[b];
		const int src_pitch2=src_pitch << 1;
		const int dst_pitch2=dst_pitch << 1;
		const int width_32=width-32;

		srcp += (ystart+6)*src_pitch;
		dstp += ystart*dst_pitch-32;
		const uint8_t *srcpp = srcp-(ydia-1)*src_pitch-xdiad2m1;

		for (int y=ystart; y<ystop; y+=2)
		{
			for (int x=32; x<width_32; ++x)
			{
				if (dstp[x]!=255) continue;
				float mstd[4];
				extract(srcpp+x,src_pitch,xdia,ydia,mstd,input);
				for (int i=0; i<qual; ++i)
				{
					dotProd(input,weights1[i],temp,nns2,asize,mstd+2);
					expf(temp,nns);
					wae5(temp,nns,mstd);
				}
				if (opt>1) castScale_SSE(mstd,&scale,dstp+x);
				else dstp[x]=min(max((int)(mstd[3]*scale+0.5f),0),255);
			}
			srcpp+=src_pitch2;
			dstp+=dst_pitch2;
		}
	}
}

unsigned __stdcall threadPool(void *ps)
{
	const PS_INFO *pss = (PS_INFO*)ps;
	while (true)
	{
		WaitForSingleObject(pss->nextJob,INFINITE);
		if (pss->type<0) return 0;
		if (pss->type==0) evalFunc_0(ps);
		else evalFunc_1(ps);
		ResetEvent(pss->nextJob);
		SetEvent(pss->jobFinished);
	}
}

AVSValue __cdecl Create_nnedi3(AVSValue args, void* user_data, IScriptEnvironment* env)
{
	if (!args[0].IsClip())
		env->ThrowError("nnedi3:  arg 0 must be a clip!");
	VideoInfo vi = args[0].AsClip()->GetVideoInfo();
	if (!vi.IsYV12() && !vi.IsYUY2() && !vi.IsRGB24() && !vi.IsYV16() && !vi.IsYV24() && !vi.IsY8())
		env->ThrowError("nnedi3:  only YV12, YUY2, YV16, YV24, Y8 and RGB24 input are supported!");
	const bool dh = args[2].AsBool(false);
	if ((vi.height&1) && !dh)
		env->ThrowError("nnedi3:  height must be mod 2 when dh=false (%d)!", vi.height);
	if (!vi.IsY8())
	{
//		if (!vi.IsYV16())
			return new nnedi3(args[0].AsClip(),args[1].AsInt(-1),args[2].AsBool(false),
					args[3].AsBool(true),args[4].AsBool(true),args[5].AsBool(true),
					args[6].AsInt(6),args[7].AsInt(1),args[8].AsInt(1),args[9].AsInt(0),
					args[10].AsInt(2),args[11].AsInt(0),args[12].AsInt(0),args[13].AsInt(15),env);
/*		else
		{
			AVSValue v = args[0].AsClip();

			v = env->Invoke("ConvertToYUY2",v).AsClip();
			v = new nnedi3(v.AsClip(),args[1].AsInt(-1),args[2].AsBool(false),
					args[3].AsBool(true),args[4].AsBool(true),args[5].AsBool(true),
					args[6].AsInt(6),args[7].AsInt(1),args[8].AsInt(1),args[9].AsInt(0),
					args[10].AsInt(2),args[11].AsInt(0),args[12].AsInt(0),args[13].AsInt(15),env);
			v = env->Invoke("ConvertToYV16",v).AsClip();
			return v;
		}*/
	}
	else
		return new nnedi3(args[0].AsClip(),args[1].AsInt(-1),args[2].AsBool(false),
				args[3].AsBool(true),false,false,
				args[6].AsInt(6),args[7].AsInt(1),args[8].AsInt(1),args[9].AsInt(0),
				args[10].AsInt(2),args[11].AsInt(0),args[12].AsInt(0),args[13].AsInt(15),env);
}

AVSValue __cdecl Create_nnedi3_rpow2(AVSValue args, void* user_data, IScriptEnvironment *env)
{
	if (!args[0].IsClip()) env->ThrowError("nnedi3_rpow2:  arg 0 must be a clip!");
	VideoInfo vi = args[0].AsClip()->GetVideoInfo();
	if (!vi.IsYV12() && !vi.IsYUY2() && !vi.IsRGB24() && !vi.IsYV16() && !vi.IsYV24() && !vi.IsY8())
		env->ThrowError("nnedi3_rpow2:  only YV12, YUY2, YV16, YV24, Y8 and RGB24 input are supported!");
	if ((vi.IsYUY2() || vi.IsYV16()) && (vi.width&3))
		env->ThrowError("nnedi3_rpow2:  for YUY2 & YV16 input width must be mod 4 (%d)!", vi.width);
	const int rfactor = args[1].AsInt(-1);
	const int nsize = args[2].AsInt(0);
	const int nns = args[3].AsInt(3);
	const int qual = args[4].AsInt(1);
	const int etype = args[5].AsInt(0);
	const int pscrn = args[6].AsInt(2);
	const char *cshift = args[7].AsString("");
	const int fwidth = args[8].IsInt() ? args[8].AsInt() : rfactor*vi.width;
	const int fheight = args[9].IsInt() ? args[9].AsInt() : rfactor*vi.height;
	const float ep0 = (float)(args[10].IsFloat() ? args[10].AsFloat() : -FLT_MAX);
	const float ep1 = (float)(args[11].IsFloat() ? args[11].AsFloat() : -FLT_MAX);
	const int threads = args[12].AsInt(0);
	const int opt = args[13].AsInt(0);
	const int fapprox = args[14].AsInt(15);
	if (rfactor < 2 || rfactor > 1024) env->ThrowError("nnedi3_rpow2:  2 <= rfactor <= 1024, and rfactor be a power of 2!\n");
	int rf = 1, ct = 0;
	bool YV16Clip=vi.IsYV16();

	while (rf < rfactor)
	{
		rf *= 2;
		++ct;
	}
	if (rf != rfactor)
		env->ThrowError("nnedi3_rpow2:  2 <= rfactor <= 1024, and rfactor be a power of 2!\n");
	if (nsize < 0 || nsize >= NUM_NSIZE)
		env->ThrowError("nnedi3_rpow2:  nsize must be in [0,%d]!\n", NUM_NSIZE-1);
	if (nns < 0 || nns >= NUM_NNS)
		env->ThrowError("nnedi3_rpow2:  nns must be in [0,%d]!\n", NUM_NNS-1);
	if (qual < 1 || qual > 2)
		env->ThrowError("nnedi3_rpow2:  qual must be set to 1 or 2!\n");
	if (threads < 0 || threads > 16)
		env->ThrowError("nnedi3_rpow2:  0 <= threads <= 16!\n");
	if (opt < 0 || opt > 2)
		env->ThrowError("nnedi3_rpow2:  opt must be set to 0, 1, or 2!\n");
	if (fapprox < 0 || fapprox > 15)
		env->ThrowError("nnedi3_rpow2:  fapprox must be [0,15]!\n");

	AVSValue v = args[0].AsClip();
	auto turnRightFunction = env->FunctionExists("FTurnRight") ? "FTurnRight" : "TurnRight";
	auto turnLeftFunction = env->FunctionExists("FTurnLeft") ? "FTurnLeft" : "TurnLeft";

	try 
	{
		double hshift=0.0,vshift=0.0;

		if (vi.IsRGB24())
		{
			for (int i=0; i<ct; ++i)
			{
				v = new nnedi3(v.AsClip(),i==0?1:0,true,true,true,true,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
				v = env->Invoke(turnRightFunction,v).AsClip();
				v = new nnedi3(v.AsClip(),i==0?1:0,true,true,true,true,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
				v = env->Invoke(turnLeftFunction,v).AsClip();
			}
			hshift = vshift = -0.5;
		}
		else
		{
			if (vi.IsYV24())
			{
				for (int i=0; i<ct; ++i)
				{
					v = new nnedi3(v.AsClip(),i==0?1:0,true,true,true,true,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
					v = env->Invoke(turnRightFunction,v).AsClip();
					// always use field=1 to keep chroma/luma horizontal alignment
					v = new nnedi3(v.AsClip(),1,true,true,true,true,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
					v = env->Invoke(turnLeftFunction,v).AsClip();
				}
				hshift = vshift = -0.5;
			}
			else
			{
/*				if (vi.IsYV16())
				{
					for (int i=0; i<ct; ++i)
					{
						v = new nnedi3(v.AsClip(),i==0?1:0,true,true,true,true,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
						v = env->Invoke(turnRightFunction,v).AsClip();
						// always use field=1 to keep chroma/luma horizontal alignment
						v = new nnedi3(v.AsClip(),1,true,true,true,true,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
						v = env->Invoke(turnLeftFunction,v).AsClip();
					}
					for (int i=0; i<ct; ++i)
						hshift = hshift*2.0-0.5;
					vshift = -0.5;
				}
				else
				{*/
					if (vi.IsY8())
					{
						for (int i=0; i<ct; ++i)
						{
							v = new nnedi3(v.AsClip(),i==0?1:0,true,true,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
							v = env->Invoke(turnRightFunction,v).AsClip();
							// always use field=1 to keep chroma/luma horizontal alignment
							v = new nnedi3(v.AsClip(),1,true,true,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
							v = env->Invoke(turnLeftFunction,v).AsClip();
						}
						hshift = vshift = -0.5;
					}
					else
					{
						if (vi.IsYV12())
						{
							for (int i=0; i<ct; ++i)
							{
								v = new nnedi3(v.AsClip(),i==0?1:0,true,true,true,true,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
								v = env->Invoke(turnRightFunction,v).AsClip();
								// always use field=1 to keep chroma/luma horizontal alignment
								v = new nnedi3(v.AsClip(),1,true,true,true,true,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
								v = env->Invoke(turnLeftFunction,v).AsClip();
							}
							// Correct chroma shift (it's always 1/2 pixel upwards).
							// Need a cache here because v/vc will both request from this point.
							v = env->Invoke("InternalCache",v).AsClip();
							v.AsClip()->SetCacheHints(CACHE_25_RANGE,2);
							AVSValue sargs[7]={v,vi.width*rfactor,vi.height*rfactor,0.0,-0.5,
								vi.width*rfactor,vi.height*rfactor};
							const char *nargs[7]={0,0,0,"src_left","src_top","src_width","src_height"};
							AVSValue vc = env->Invoke("Spline36Resize",AVSValue(sargs,7),nargs).AsClip();
							AVSValue margs[2] = {v,vc};
							v = env->Invoke("MergeChroma",AVSValue(margs,2)).AsClip();
							for (int i=0; i<ct; ++i)
								hshift = hshift*2.0-0.5;
							vshift = -0.5;
						}
						else
						{
							if (vi.IsYUY2() || YV16Clip)
//							if (vi.IsYUY2())
							{
								if (YV16Clip) v = env->Invoke("ConvertToYUY2",v).AsClip();
								// Unfortunately, turnleft()/turnright() can't preserve YUY2 chroma, so we convert
								// U/V planes to Y planes in separate clips and process them that way.
								AVSValue vu = env->Invoke("UtoY",v).AsClip();
								AVSValue vv = env->Invoke("VtoY",v).AsClip();
								for (int i=0; i<ct; ++i)
								{
									v = new nnedi3(v.AsClip(),i==0?1:0,true,true,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
									v = env->Invoke(turnRightFunction,v).AsClip();
									// always use field=1 to keep chroma/luma horizontal alignment
									v = new nnedi3(v.AsClip(),1,true,true,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
									v = env->Invoke(turnLeftFunction,v).AsClip();
								}
								for (int i=0; i<ct; ++i)
								{
									vu = new nnedi3(vu.AsClip(),i==0?1:0,true,true,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
									vu = env->Invoke(turnRightFunction,vu).AsClip();
									// always use field=1 to keep chroma/luma horizontal alignment
									vu = new nnedi3(vu.AsClip(),1,true,true,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
									vu = env->Invoke(turnLeftFunction,vu).AsClip();
								}
								for (int i=0; i<ct; ++i)
								{
									vv = new nnedi3(vv.AsClip(),i==0?1:0,true,true,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
									vv = env->Invoke(turnRightFunction,vv).AsClip();
									// always use field=1 to keep chroma/luma horizontal alignment
									vv = new nnedi3(vv.AsClip(),1,true,true,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,env);
									vv = env->Invoke(turnLeftFunction,vv).AsClip();
								}
								AVSValue ytouvargs[3] = {vu,vv,v};
								v=env->Invoke("YtoUV",AVSValue(ytouvargs,3)).AsClip();
								if (YV16Clip) v=env->Invoke("ConvertToYV16",v).AsClip();
								for (int i=0; i<ct; ++i)
									hshift = hshift*2.0-0.5;
								vshift = -0.5;
							}
						}
					}
//				}
			}
		}
		if (cshift[0])
		{
			int type = 0;
			if (_strnicmp(cshift,"blackmanresize",14) == 0 ||
				_strnicmp(cshift,"lanczosresize",13) == 0 ||
				_strnicmp(cshift,"sincresize",10) == 0)
				type = 1;
			else if (_strnicmp(cshift,"gaussresize",11) == 0)
				type = 2;
			else if (_strnicmp(cshift,"bicubicresize",13) == 0)
				type = 3;
			if (!type || (type != 3 && ep0 == -FLT_MAX) ||
				(type == 3 && ep0 == -FLT_MAX && ep1 == -FLT_MAX))
			{
				AVSValue sargs[7] = { v, fwidth, fheight, hshift, vshift, 
					vi.width*rfactor, vi.height*rfactor };
				const char *nargs[7] = { 0, 0, 0, "src_left", "src_top", 
					"src_width", "src_height" };
				v = env->Invoke(cshift,AVSValue(sargs,7),nargs).AsClip();
			}
			else if (type != 3 || min(ep0,ep1) == -FLT_MAX)
			{
				AVSValue sargs[8] = { v, fwidth, fheight, hshift, vshift, 
					vi.width*rfactor, vi.height*rfactor, type==1?AVSValue((int)(ep0+0.5f)):
					(type==2?ep0:max(ep0,ep1)) };
				const char *nargs[8] = { 0, 0, 0, "src_left", "src_top", 
					"src_width", "src_height", type==1?"taps":(type==2?"p":(max(ep0,ep1)==ep0?"b":"c")) };
				v = env->Invoke(cshift,AVSValue(sargs,8),nargs).AsClip();
			}
			else
			{
				AVSValue sargs[9] = { v, fwidth, fheight, hshift, vshift, 
					vi.width*rfactor, vi.height*rfactor, ep0, ep1 };
				const char *nargs[9] = { 0, 0, 0, "src_left", "src_top", 
					"src_width", "src_height", "b", "c" };
				v = env->Invoke(cshift,AVSValue(sargs,9),nargs).AsClip();
			}
		}
	}
	catch (IScriptEnvironment::NotFound)
	{
		env->ThrowError("nnedi3_rpow2:  error using env->invoke (function not found)!\n");
	}
	return v;
}

const AVS_Linkage *AVS_linkage = nullptr;

extern "C" __declspec(dllexport) const char* __stdcall AvisynthPluginInit3(IScriptEnvironment* env, const AVS_Linkage* const vectors)
{
	AVS_linkage = vectors;

    env->AddFunction("nnedi3", "c[field]i[dh]b[Y]b[U]b[V]b[nsize]i[nns]i[qual]i[etype]i[pscrn]i" \
		"[threads]i[opt]i[fapprox]i", Create_nnedi3, 0);
	env->AddFunction("nnedi3_rpow2", "c[rfactor]i[nsize]i[nns]i[qual]i[etype]i[pscrn]i[cshift]s[fwidth]i" \
		"[fheight]i[ep0]f[ep1]f[threads]i[opt]i[fapprox]i", Create_nnedi3_rpow2, 0);

	return "NNEDI3 plugin";
	
}

// new prescreener functions

void uc2s64_C(const uint8_t *t,const int pitch,float *p)
{
	int16_t *ps = (int16_t*)p;
	int y_16=0,y_pitch=0;
	const int pitch2=pitch << 1;

	for (int y=0; y<4; ++y)
	{
		for (int x=0; x<16; ++x)
			ps[y_16+x] = t[y_pitch+x];
		y_16+=16;
		y_pitch+=pitch2;
	}
}



void computeNetwork0new_C(const float *datai,const float *weights,uint8_t *d)
{
	int16_t *data = (int16_t*)datai;
	int16_t *ws = (int16_t*)weights;
	float *wf = (float*)&ws[4*64];
	float vals[8];
	for (int i=0; i<4; ++i)
	{
		int sum = 0;
		for (int j=0; j<64; ++j)
			sum += data[j]*ws[(i << 3)+((j >> 3) << 5)+(j&7)];
		const float t = sum*wf[i]+wf[4+i];
		vals[i] = t/(1.0f+fabsf(t));
	}
	for (int i=0; i<4; ++i)
	{
		float sum = 0.0f;
		for (int j=0; j<4; ++j)
			sum += vals[j]*wf[8+i+(j << 2)];
		vals[4+i] = sum+wf[24+i];
	}
	int mask = 0;
	for (int i=0; i<4; ++i)
	{
		if (vals[4+i]>0.0f)
			mask |= (0x1 << (i << 3));
	}
	((int*)d)[0] = mask;
}

