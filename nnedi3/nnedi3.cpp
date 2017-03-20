/*
**                    nnedi3 v0.9.4.38 for Avs+/Avisynth 2.6.x
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

#if _MSC_VER >= 1900
#define AVX_BUILD_POSSIBLE
#endif

#ifdef AVX_BUILD_POSSIBLE
extern "C" void computeNetwork0_AVX2(const float *input,const float *weights,uint8_t *d);
extern "C" void computeNetwork0_FMA3(const float *input, const float *weights, uint8_t *d);
extern "C" void computeNetwork0_FMA4(const float *input, const float *weights, uint8_t *d);
extern "C" void computeNetwork0_i16_AVX2(const float *inputf,const float *weightsf,uint8_t *d);
extern "C" void computeNetwork0new_AVX2(const float *datai,const float *weights,uint8_t *d);
extern "C" void uc2f48_AVX2(const uint8_t *t,const int pitch,float *p);
extern "C" void uc2f48_AVX2_16(const uint8_t *t, const int pitch, float *p);
extern "C" void uc2s48_AVX2(const uint8_t *t,const int pitch,float *pf);
extern "C" void uc2s64_AVX2(const uint8_t *t,const int pitch,float *p);
extern "C" void dotProd_m32_m16_AVX2(const float *data, const float *weights, float *vals, const int n, const int len, const float *istd);
extern "C" void dotProd_m32_m16_FMA3(const float *data, const float *weights, float *vals, const int n, const int len, const float *istd);
extern "C" void dotProd_m32_m16_FMA4(const float *data, const float *weights, float *vals, const int n, const int len, const float *istd);
extern "C" void dotProd_m48_m16_AVX2(const float *data, const float *weights, float *vals, const int n, const int len, const float *istd);
extern "C" void dotProd_m48_m16_FMA3(const float *data, const float *weights, float *vals, const int n, const int len, const float *istd);
extern "C" void dotProd_m48_m16_FMA4(const float *data, const float *weights, float *vals, const int n, const int len, const float *istd);
extern "C" void dotProd_m32_m16_i16_AVX2(const float *dataf,const float *weightsf,float *vals,const int n,const int len,const float *istd);
extern "C" void dotProd_m48_m16_i16_AVX2(const float *dataf,const float *weightsf,float *vals,const int n,const int len,const float *istd);
extern "C" void e0_m16_FMA3(float *s, const int n);
extern "C" void e0_m16_FMA4(float *s, const int n);
extern "C" void e0_m16_AVX2(float *s,const int n);
extern "C" void e1_m16_AVX2(float *s,const int n);
extern "C" void e2_m16_AVX2(float *s,const int n);
extern "C" int processLine0_AVX2_ASM(const uint8_t *tempu,int width,uint8_t *dstp,const uint8_t *src3p,const int src_pitch,const int16_t val_min,const int16_t val_max);
extern "C" int processLine0_AVX2_ASM_16(const uint8_t *tempu,int width,uint8_t *dstp,const uint8_t *src3p,const int src_pitch,const uint16_t val_min,const uint16_t val_max);
extern "C" int processLine0_AVX2_ASM_32(const uint8_t *tempu,int width,uint8_t *dstp,const uint8_t *src3p,const int src_pitch);
extern "C" void weightedAvgElliottMul5_m16_AVX2(const float *w,const int n,float *mstd);
extern "C" void weightedAvgElliottMul5_m16_FMA3(const float *w,const int n,float *mstd);
extern "C" void weightedAvgElliottMul5_m16_FMA4(const float *w,const int n,float *mstd);
extern "C" void extract_m8_AVX2(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *input);
extern "C" void extract_m8_FMA3(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *input);
extern "C" void extract_m8_FMA4(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *input);
extern "C" void extract_m8_i16_AVX2(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *inputf);
extern "C" void extract_m8_i16_AVX2_16(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *inputf);
extern "C" void extract_m8_i16_AVX2_16_2(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *inputf,int32_t *sum,int64_t *sumsq);
extern "C" void extract_m8_AVX2_16(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *input);
extern "C" void extract_m8_FMA3_16(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *input);
extern "C" void extract_m8_FMA4_16(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *input);
extern "C" void extract_m8_AVX2_32(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *input);
extern "C" void extract_m8_FMA3_32(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *input);
extern "C" void extract_m8_FMA4_32(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *input);
extern "C" void castScale_AVX2(const float *val,const float *scale,uint8_t *dstp,const uint32_t val_min,const uint32_t val_max);
extern "C" void castScale_AVX2_16(const float *val, const float *scale, uint16_t *dstp,const uint32_t val_min,const uint32_t val_max);
#endif

extern "C" void computeNetwork0_SSE2(const float *input,const float *weights,uint8_t *d);
extern "C" void computeNetwork0_i16_SSE2(const float *inputf,const float *weightsf,uint8_t *d);
extern "C" void uc2f48_SSE2(const uint8_t *t,const int pitch,float *p);
extern "C" void uc2f48_SSE2_16(const uint8_t *t, const int pitch, float *p);
extern "C" void uc2s48_SSE2(const uint8_t *t,const int pitch,float *pf);
extern "C" int processLine0_SSE2_ASM(const uint8_t *tempu,int width,uint8_t *dstp,const uint8_t *src3p,const int src_pitch,const int16_t val_min,const int16_t val_max);
extern "C" int processLine0_SSE2_ASM_16(const uint8_t *tempu,int width,uint8_t *dstp,const uint8_t *src3p,const int src_pitch,const uint16_t val_min,const uint16_t val_max);
extern "C" int processLine0_SSE2_ASM_32(const uint8_t *tempu, int width, uint8_t *dstp, const uint8_t *src3p, const int src_pitch);
extern "C" void extract_m8_SSE2(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *input);
extern "C" void extract_m8_SSE2_16(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *input);
extern "C" void extract_m8_SSE2_32(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *input);
extern "C" void extract_m8_i16_SSE2(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *inputf);
extern "C" void extract_m8_i16_SSE2_16(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *inputf);
extern "C" void extract_m8_i16_SSE2_16_2(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *inputf,int32_t *sum,int64_t *sumsq);
extern "C" void dotProd_m32_m16_SSE2(const float *data,const float *weights,float *vals,const int n,const int len,const float *istd);
extern "C" void dotProd_m48_m16_SSE2(const float *data,const float *weights,float *vals,const int n,const int len,const float *istd);
extern "C" void dotProd_m32_m16_i16_SSE2(const float *dataf,const float *weightsf,float *vals,const int n,const int len,const float *istd);
extern "C" void dotProd_m48_m16_i16_SSE2(const float *dataf,const float *weightsf,float *vals,const int n,const int len,const float *istd);
extern "C" void e0_m16_SSE2(float *s,const int n);
extern "C" void e1_m16_SSE2(float *s,const int n);
extern "C" void e2_m16_SSE2(float *s,const int n);
extern "C" void weightedAvgElliottMul5_m16_SSE2(const float *w,const int n,float *mstd);
extern "C" void castScale_SSE(const float *val,const float *scale,uint8_t *dstp,const uint32_t val_min,const uint32_t val_max);
extern "C" void castScale_SSE_16(const float *val, const float *scale, uint16_t *dstp,const uint32_t val_min,const uint32_t val_max);
extern "C" void uc2s64_SSE2(const uint8_t *t,const int pitch,float *p);
extern "C" void computeNetwork0new_SSE2(const float *datai,const float *weights,uint8_t *d);

EXTERN_C IMAGE_DOS_HEADER __ImageBase;

#define myfree(ptr) if (ptr!=NULL) { free(ptr); ptr=NULL;}
#define myCloseHandle(ptr) if (ptr!=NULL) { CloseHandle(ptr); ptr=NULL;}
#define myalignedfree(ptr) if (ptr!=NULL) { _aligned_free(ptr); ptr=NULL;}
#define mydelete(ptr) if (ptr!=NULL) { delete ptr; ptr=NULL;}

static ThreadPoolInterface *poolInterface;

int roundds(const double f)
{
	if (f-floor(f) >= 0.5)
		return min((int)ceil(f),32767);
	return max((int)floor(f),-32768);
}

void shufflePreScrnL2L3(float *wf, float *rf, const int opt)
{
	int j_a = 0;

	for (int j = 0; j<4; j++)
	{
		for (int k = 0; k<4; k++)
			wf[(k << 2) + j] = rf[j_a + k];
		j_a += 4;
	}
	rf += 20;
	wf += 20;
	const int jtable[4] = { 0,2,1,3 };
	for (int j = 0; j<4; j++)
	{
		int j_8 = jtable[j] << 3;

		for (int k = 0; k<8; k++)
			wf[(k << 2) + j] = rf[j_8 + k];

		wf[32 + j] = rf[32 + jtable[j]];
	}
}


nnedi3::nnedi3(PClip _child,int _field,bool _dh,bool _Y,bool _U,bool _V,bool _A,int _nsize,int _nns,int _qual,int _etype,int _pscrn,
	int _threads,int _opt,int _fapprox,bool _LogicalCores,bool _MaxPhysCores, bool _SetAffinity,bool _Sleep,int range_mode,
	bool _avsp, IScriptEnvironment *env) :
	GenericVideoFilter(_child),field(_field),dh(_dh),Y(_Y),U(_U),V(_V),A(_A),
	nsize(_nsize),nns(_nns),qual(_qual),etype(_etype),pscrn(_pscrn),threads(_threads),opt(_opt),fapprox(_fapprox),
	LogicalCores(_LogicalCores),MaxPhysCores(_MaxPhysCores),SetAffinity(_SetAffinity),Sleep(_Sleep),
	avsp(_avsp)
{
	if ((field<-2) || (field>3)) env->ThrowError("nnedi3: field must be set to -2, -1, 0, 1, 2, or 3!");
	if ((threads<0) || (threads>MAX_MT_THREADS)) env->ThrowError("nnedi3: threads must be between 0 and %d inclusive!",MAX_MT_THREADS);
	if (dh && ((field<-1) || (field>1))) env->ThrowError("nnedi3: field must be set to -1, 0, or 1 when dh=true!");
	if ((nsize<0) || (nsize>=NUM_NSIZE)) env->ThrowError("nnedi3: nsize must be in [0,%d]!\n",NUM_NSIZE-1);
	if ((nns<0) || (nns>=NUM_NNS)) env->ThrowError("nnedi3: nns must be in [0,%d]!\n",NUM_NNS-1);
	if ((qual<1) || (qual>2)) env->ThrowError("nnedi3: qual must be set to 1 or 2!\n");
	if ((opt<0) || (opt>6)) env->ThrowError("nnedi3: opt must be in [0,6]!");
	if ((fapprox<0) || (fapprox>15)) env->ThrowError("nnedi3: fapprox must be [0,15]!\n");
	if ((pscrn<0) || (pscrn>4)) env->ThrowError("nnedi3: pscrn must be [0,4]!\n");
	if ((etype<0) || (etype>1)) env->ThrowError("nnedi3: etype must be [0,1]!\n");
	if ((range_mode<0) || (range_mode>4)) env->ThrowError("nnedi3: range must be [0,4]!\n");
	
	grey = vi.IsY();
	isRGBPfamily = vi.IsPlanarRGB() || vi.IsPlanarRGBA();
	isAlphaChannel = vi.IsYUVA() || vi.IsPlanarRGBA();
	pixelsize = (uint8_t)vi.ComponentSize(); // AVS16
	bits_per_pixel = (uint8_t)vi.BitsPerComponent();

	bool int16_predictor,int16_prescreener;

	if ((pscrn>1) && (pixelsize>2)) pscrn=1;

	int16_predictor = ((fapprox & 2)!=0) && (bits_per_pixel<=15);
	int16_prescreener = ((fapprox & 1)!=0) && (pixelsize<=2);
	
	const int PlaneMax=(grey) ? 1:(isAlphaChannel) ? 4:3;

	uint8_t plane_range[PLANE_MAX];

	if ((range_mode!=1) && (range_mode!=4))
	{
		if (vi.IsYUV())
		{
			plane_range[0]=2;
			plane_range[1]=3;
			plane_range[2]=3;
		}
		else
		{
			if (grey)
			{
				for (uint8_t i=0; i<3; i++)
					plane_range[i]=(range_mode==0) ? 2 : range_mode;
			}
			else
			{
				for (uint8_t i=0; i<3; i++)
					plane_range[i]=1;
			}
		}
	}
	else
	{
		if (vi.IsRGB()) range_mode=1;

		for (uint8_t i=0; i<3; i++)
			plane_range[i]=range_mode;
	}
	plane_range[3]=1;

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

	StaticThreadpoolF=StaticThreadpool;

	srcPF=NULL;
	dstPF=NULL;
	weights0=NULL;
	for (uint8_t i=0; i<2; i++)
		weights1[i]=NULL;
	for (uint8_t i=0; i<PLANE_MAX; i++)
		lcount[i]=NULL;

	for (uint8_t i=0; i<PLANE_MAX; i++)
		NNPixels[i]=NULL;
	for (uint8_t i=0; i<MAX_MT_THREADS; i++)
	{
		MT_Thread[i].pClass=this;
		MT_Thread[i].f_process=0;
		MT_Thread[i].thread_Id=(uint8_t)i;
		MT_Thread[i].pFunc=StaticThreadpoolF;

		pssInfo[i].input=NULL;
		pssInfo[i].temp=NULL;
	}
	ghMutex=NULL;
	UserId=0;

	if (!poolInterface->GetThreadPoolInterfaceStatus()) env->ThrowError("nnedi3: Error with the TheadPool status !");

	threads_number=poolInterface->GetThreadNumber(threads,LogicalCores);
	if (threads_number==0)
		env->ThrowError("nnedi3: Error with the TheadPool while getting CPU info !");

	srcPF = new PlanarFrame();
	if (srcPF==NULL)
		env->ThrowError("nnedi3: Error while creating srcPF!");
	if (vi.Is420())
	{
		if (!srcPF->createPlanar(vi.height+12,(vi.height>>1)+12,vi.width+64,(vi.width>>1)+64,isRGBPfamily,isAlphaChannel,pixelsize,bits_per_pixel))
		{
			FreeData();
			env->ThrowError("nnedi3: Error while creating planar for srcPF!");
		}
	}
	else
	{
		if (vi.IsYV411())
		{
			if (!srcPF->createPlanar(vi.height+12,vi.height+12,vi.width+64,(vi.width>>2)+64,isRGBPfamily,isAlphaChannel,pixelsize,bits_per_pixel))
			{
				FreeData();
				env->ThrowError("nnedi3: Error while creating planar for srcPF!");
			}
		}
		else
		{
			if (vi.Is422() || vi.IsYUY2())
			{
				if (!srcPF->createPlanar(vi.height+12,vi.height+12,vi.width+64,(vi.width>>1)+64,isRGBPfamily,isAlphaChannel,pixelsize,bits_per_pixel))
				{
					FreeData();
					env->ThrowError("nnedi3: Error while creating planar for srcPF!");
				}
			}
			else
			{
				if (vi.Is444() || vi.IsRGB24() || isRGBPfamily)
				{
					if (!srcPF->createPlanar(vi.height+12,vi.height+12,vi.width+64,vi.width+64,isRGBPfamily,isAlphaChannel,pixelsize,bits_per_pixel))
					{
						FreeData();
						env->ThrowError("nnedi3: Error while creating planar for srcPF!");
					}
				}
				else
				{
					if (grey)
					{
						if (!srcPF->createPlanar(vi.height+12,0,vi.width+64,0,isRGBPfamily,isAlphaChannel,pixelsize,bits_per_pixel))
						{
							FreeData();
							env->ThrowError("nnedi3: Error while creating planar for srcPF!");
						}
						U = false;
						V = false;
					}
				}
			}
		}
	}
	if (!isAlphaChannel) A = false;
	
	dstPF = new PlanarFrame(vi);
	if (dstPF==NULL)
	{
		FreeData();
		env->ThrowError("nnedi3: Error while creating dstPF!");
	}
	if (!dstPF->GetAllocStatus())
	{
		FreeData();
		env->ThrowError("nnedi3: Error while allocating planar dstPF!");
	}

	if (opt==0)
	{
		const int CPUF=env->GetCPUFlags();
/*
		if (((CPUF & CPUF_FMA4)!=0) && ((CPUF & CPUF_AVX2)!=0)) opt=6;
		else
		{
			if (((CPUF & CPUF_FMA3)!=0) && ((CPUF & CPUF_AVX2)!=0)) opt=5;
			else
			{
				if ((CPUF & CPUF_AVX2)!=0) opt=4;
				else
				{
					if ((CPUF & CPUF_SSE4_1)!=0) opt=3;
					else
					{
						if ((CPUF & CPUF_SSE2)!=0) opt=2;
						else opt=1;
					}
				}
			}
		}*/

		if ((CPUF & CPUF_AVX2) != 0) opt = 4;
		else
		{
			if ((CPUF & CPUF_SSE4_1) != 0) opt = 3;
			else
			{
				if ((CPUF & CPUF_SSE2) != 0) opt = 2;
				else opt = 1;
			}
		}

		char buf[512];
		sprintf_s(buf,512,"nnedi3: auto-detected opt setting = %d (%d)\n",opt,CPUF);
		OutputDebugString(buf);
	}

	const int dims0 = 49*4+5*4+9*4;
	const int dims0new = 4*65+4*5;
	const int dims1 = (xdiaTable[nsize]*ydiaTable[nsize]+1) << (nnsTablePow2[nns]+1);
	int dims1tsize = 0, dims1offset;
	for (int j=0; j<NUM_NNS; j++)
	{
		int j_a;

		j_a=nnsTablePow2[j]+2;
		for (int i=0; i<NUM_NSIZE; i++)
		{
			if ((i==nsize) && (j==nns)) dims1offset=dims1tsize;
			dims1tsize+=(xdiaTable[i]*ydiaTable[i]+1) << j_a;
		}
	}
	weights0 = (float *)_aligned_malloc(max(dims0,dims0new)*sizeof(float),64);
	if (weights0==NULL)
	{
		FreeData();
		env->ThrowError("nnedi3: Error while allocating weights0!");
	}
	for (uint8_t i=0; i<2; i++)
	{
		weights1[i] = (float *)_aligned_malloc(dims1*sizeof(float),64);
		if (weights1[i]==NULL)
		{
			FreeData();
			env->ThrowError("nnedi3: Error while allocating weights1[%d]!",i);
		}
	}
	for (uint8_t i=0; i<PlaneMax; i++)
	{
		lcount[i] = (int *)_aligned_malloc(dstPF->GetHeight(i)*sizeof(int),64);
		if (lcount[i]==NULL)
		{
			FreeData();
			env->ThrowError("nnedi3: Error while allocating lcount[%d]!",i);
		}
	}
	char nbuf[512];
	GetModuleFileName((HINSTANCE)&__ImageBase,nbuf,512);
	HMODULE hmod = GetModuleHandle(nbuf);
	if (hmod==NULL)
	{
		FreeData();
		env->ThrowError("nnedi3: unable to get module handle!");
	}
	HRSRC hrsrc = FindResource(hmod,MAKEINTRESOURCE(101),_T("BINARY"));
	HGLOBAL hglob = LoadResource(hmod,hrsrc);
	LPVOID lplock = LockResource(hglob);
	DWORD dwSize = SizeofResource(hmod,hrsrc);
	if ((hmod==NULL) || (hrsrc==NULL) || (hglob==NULL) || (lplock==NULL) || (dwSize!=(dims0+dims0new*3+dims1tsize*2)*sizeof(float)))
	{
		FreeData();
		env->ThrowError("nnedi3: error loading resource (%x,%x,%x,%x,%d,%d)!",hmod,hrsrc,hglob,lplock,dwSize,
		(dims0+dims0new*3+dims1tsize*2)*sizeof(float));
	}

	float *bdata = (float *)lplock;

	// Adjust prescreener weights
	if (pscrn>=2) // using new prescreener
	{
		int offt[4*64],offt2[4*64];
		int j_a=0,j_b=0;

		for (int j=0; j<4; j++)
		{
			for (int k=0; k<64; k++)
				offt[j_a+k] = ((k>>3)<<5)+j_b+(k&7);

			j_a+=64;
			j_b+=8;
		}


		j_a=0,j_b=0;
		if (opt>=4)
		{
			for (int j=0; j<4; j++)
			{
				for (int k=0; k<64; k++)
					offt2[j_a+k] = ((k>>4)<<6)+j_b+(k&15);

				j_a+=64;
				j_b+=16;
			}
		}
		else
		{
			for (int j=0; j<4; j++)
			{
				for (int k=0; k<64; k++)
					offt2[j_a+k] = ((k>>3)<<5)+j_b+(k&7);

				j_a+=64;
				j_b+=8;
			}
		}

		const float *bdw = bdata+(dims0+dims0new*(pscrn-2));
		int16_t *ws = (int16_t *)weights0;
		float *wf = (float *)&ws[4*64];
		double mean[4] = {0.0,0.0,0.0,0.0};

		// Calculate mean weight of each first layer neuron
		j_a=0;
		for (int j=0; j<4; j++)
		{
			double cmean = 0.0;

			for (int k=0; k<64; k++)
				cmean += bdw[offt[j_a+k]];
			mean[j] = cmean/64.0;
			j_a+=64;
		}

		// 16 bit pixels will be shifted by 1 for the prescreener.
		const int prescreener_bits = min(bits_per_pixel,15);
		const double half = (((int)1 << prescreener_bits)-1)/2.0;

		// Factor mean removal and 1.0/half scaling
		// into first layer weights. scale to int16 range
		j_a=0;
		for (int j=0; j<4; j++)
		{
			double mval = 0.0;

			for (int k=0; k<64; k++)
				mval = max(mval,fabs((bdw[offt[j_a+k]]-mean[j])/half));

			const double scale = 32767.0/mval;

			for (int k=0; k<64; k++)
				ws[offt2[j_a+k]] = roundds(((bdw[offt[j_a+k]]-mean[j])/half)*scale);

			wf[j] = (float)(mval/32767.0);
			j_a+=64;
		}
		memcpy(wf+4,bdw+4*64,(dims0new-4*64)*sizeof(float));
	}
	else // using old prescreener
	{
		double mean[4] = {0.0,0.0,0.0,0.0};
		int j_a=0;

		// Calculate mean weight of each first layer neuron
		for (int j=0; j<4; j++)
		{
			double cmean = 0.0;

			for (int k=0; k<48; k++)
				cmean += bdata[j_a+k];
			mean[j] = cmean/48.0;
			j_a+=48;
		}
		if (int16_prescreener) // use int16 dot products in first layer
		{
			int16_t *ws = (int16_t *)weights0;
			float *wf = (float *)&ws[4*48];

			// 16 bit pixels will be shifted by 1 for the prescreener.
			const int prescreener_bits = min(bits_per_pixel,15);
			const double half = (((int)1 << prescreener_bits)-1)/2.0;

			// Factor mean removal and 1.0/half scaling
			// into first layer weights. scale to int16 range
			j_a=0;
			for (int j=0; j<4; j++)
			{
				double mval = 0.0;

				for (int k=0; k<48; k++)
					mval = max(mval,fabs((bdata[j_a+k]-mean[j])/half));

				const double scale = 32767.0/mval;

				for (int k=0; k<48; k++)
					ws[j_a+k] = roundds(((bdata[j_a+k]-mean[j])/half)*scale);

				wf[j] = (float)(mval/32767.0);
				j_a+=48;
			}
			memcpy(wf+4,bdata+4*48,(dims0-4*48)*sizeof(float));

			if ((opt>1) && (bits_per_pixel<=14))// shuffle weight order for asm
			{
				int16_t *rs = (int16_t*)malloc(dims0*sizeof(float));

				if (rs==NULL)
				{
					FreeData();
					env->ThrowError("nnedi3: Error while allocating rs!");
				}
				int j_b=0;

				memcpy(rs,weights0,dims0*sizeof(float));
				j_a=0;
				if (opt>=4)
				{
					for (int j=0; j<4; j++)
					{
						for (int k=0; k<48; k++)
							ws[((k >> 4) << 6)+j_b+(k&15)] = rs[j_a+k];
						j_a+=48;
						j_b+=16;
					}
				}
				else
				{
					for (int j=0; j<4; j++)
					{
						for (int k=0; k<48; k++)
							ws[((k >> 3) << 5)+j_b+(k&7)] = rs[j_a+k];
						j_a+=48;
						j_b+=8;
					}
				}
				shufflePreScrnL2L3(wf+8,((float*)&rs[4*48])+8,opt);
				free(rs);
			}
		}
		else // use float dot products in first layer
		{
			double half = ((int)1 << bits_per_pixel)-1;

			if (pixelsize==4) half = 1.0;
			half /= 2.0;

			// Factor mean removal and 1.0/half scaling
			// into first layer weights.
			j_a=0;
			for (int j=0; j<4; j++)
			{
				for (int k=0; k<48; k++)
					weights0[j_a+k] = (float)((bdata[j_a+k]-mean[j])/half);
				j_a+=48;
			}
			memcpy(weights0+4*48,bdata+4*48,(dims0-4*48)*sizeof(float));

			if (opt>1) // shuffle weight order for asm
			{
				float *wf = weights0;
				float *rf = (float*)malloc(dims0*sizeof(float));
				if (rf==NULL)
				{
					FreeData();
					env->ThrowError("nnedi3: Error while allocating rf!");
				}
				int j_b=0;

				memcpy(rf,weights0,dims0*sizeof(float));
				j_a=0;
				if (opt>=4)
				{
					for (int j=0; j<4; j++)
					{
						for (int k=0; k<48; k++)
							wf[((k >> 3) << 5)+j_b+(k&7)] = rf[j_a+k];
						j_a+=48;
						j_b+=8;
					}
				}
				else
				{
					for (int j=0; j<4; j++)
					{
						for (int k=0; k<48; k++)
							wf[((k >> 2) << 4)+j_b+(k&3)] = rf[j_a+k];
						j_a+=48;
						j_b+=4;
					}
				}
				shufflePreScrnL2L3(wf+4*49,rf+4*49,opt);
				free(rf);
			}
		}
	}

	// Adjust prediction weights
	for (int i=0; i<2; i++)
	{
		const float *bdataT = bdata+(dims0+dims0new*3+dims1tsize*etype+dims1offset+i*dims1);
		const int nnst = nnsTable[nns];
		const int nnst2 = nnst << 1;
		const int asize = xdiaTable[nsize]*ydiaTable[nsize];
		const int boff = nnst2*asize;
		double *mean = (double *)calloc(asize+1+nnst2,sizeof(double));
		if (mean==NULL)
		{
			FreeData();
			env->ThrowError("nnedi3: Error while allocating mean!");
		}

		int j_a=0,j_d;

		// Calculate mean weight of each neuron (ignore bias)
		for (int j=0; j<nnst2; j++)
		{
			double cmean = 0.0;

			for (int k=0; k<asize; k++)
				cmean += bdataT[j_a+k];
			mean[asize+1+j] = cmean/(double)asize;
			j_a+=asize;
		}

		// Calculate mean softmax neuron
		j_a=0;
		j_d=asize+1;
		for (int j=0; j<nnst; j++)
		{
			for (int k=0; k<asize; k++)
				mean[k] += bdataT[j_a+k]-mean[j_d];
			mean[asize] += bdataT[boff+j];
			j_a+=asize;
			j_d++;
		}
		for (int j=0; j<asize+1; j++)
			mean[j] /= (double)(nnst);

		if (int16_predictor) // use int16 dot products
		{
			int16_t *ws = (int16_t *)weights1[i];
			float *wf = (float *)&ws[asize*nnst2];

			// Factor mean removal into weights, remove global offset from
			// softmax neurons, and scale weights to int16 range.
			j_a=0;
			j_d=asize+1;

			for (int j=0; j<nnst; j++) // softmax neurons
			{
				double mval = 0.0;

				for (int k=0; k<asize; k++)
					mval = max(mval,fabs(bdataT[j_a+k]-mean[j_d]-mean[k]));

				const double scale = 32767.0/mval;

				for (int k=0; k<asize; k++)
					ws[j_a+k] = roundds((bdataT[j_a+k]-mean[j_d]-mean[k])*scale);

				wf[((j >> 2) << 3)+(j&3)] = (float)(mval/32767.0);
				wf[((j >> 2) << 3)+(j&3)+4] = (float)(bdataT[boff+j]-mean[asize]);
				j_a+=asize;
				j_d++;
			}

			for (int j=nnst; j<nnst2; j++) // elliott neurons
			{
				double mval = 0.0;

				for (int k=0; k<asize; k++)
					mval = max(mval,fabs(bdataT[j_a+k]-mean[j_d]));

				const double scale = 32767.0/mval;

				for (int k=0; k<asize; k++)
					ws[j_a+k] = roundds((bdataT[j_a+k]-mean[j_d])*scale);

				wf[((j >> 2) << 3)+(j&3)] = (float)(mval/32767.0);
				wf[((j >> 2) << 3)+(j&3)+4] = bdataT[boff+j];
				j_a+=asize;
				j_d++;
			}

			if ((opt>1) && (bits_per_pixel<=14)) // shuffle weight order for asm
			{
				int16_t *rs = (int16_t *)malloc(nnst2*asize*sizeof(int16_t));
				if (rs==NULL)
				{
					free(mean);
					FreeData();
					env->ThrowError("nnedi3: Error while allocating rs!");
				}

				memcpy(rs,ws,nnst2*asize*sizeof(int16_t));
				j_a=0;
				if (opt>=4)
				{
					for (int j=0; j<nnst2; j++)
					{
						int j_b=((j >> 2) << 2)*asize;
						int j_c=(j&3) << 4;

						for (int k=0; k<asize; k++)
							ws[j_b+((k >> 4) << 6)+j_c+(k&15)] = rs[j_a+k];
						j_a+=asize;
					}
				}
				else
				{
					for (int j=0; j<nnst2; j++)
					{
						int j_b=((j >> 2) << 2)*asize;
						int j_c=(j&3) << 3;

						for (int k=0; k<asize; k++)
							ws[j_b+((k >> 3) << 5)+j_c+(k&7)] = rs[j_a+k];
						j_a+=asize;
					}
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
				if (opt>=4)
				{
					for (int j=0; j<nnst2; j++)
					{
						for (int k=0; k<asize; k++)
						{
							const double q = j < nnst ? mean[k] : 0.0;
							int j_b=((j >> 2) << 2)*asize;
							int j_c=(j&3) << 3;

							weights1[i][j_b+((k >> 3) << 5)+j_c+(k&7)]=(float)(bdataT[j_a+k]-mean[j_d]-q);
						}
						weights1[i][boff+j] = (float)(bdataT[boff+j]-(j<nnst?mean[asize]:0.0));
						j_a+=asize;
						j_d++;
					}
				}
				else
				{
					for (int j=0; j<nnst2; j++)
					{
						for (int k=0; k<asize; k++)
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
			}
			else
			{
				for (int j=0; j<nnst2; j++)
				{
					for (int k=0; k<asize; k++)
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
	
	int hslice[PLANE_MAX],hremain[PLANE_MAX];
	int srow[PLANE_MAX] = {6,6,6,6};
	for (int i=0; i<PlaneMax; i++)
	{
		const int height = srcPF->GetHeight(i)-12;
		hslice[i] = height/(int)threads_number;
		hremain[i] = height%(int)threads_number;
	}

	ghMutex=CreateMutex(NULL,FALSE,NULL);
	if (ghMutex==NULL)
	{
		FreeData();
		env->ThrowError("nnedi3: Unable to create Mutex!");
	}

	int NNPixels_pitch[PLANE_MAX];
	size_t NNPixels_Size[PLANE_MAX];

	for (uint8_t i=0; i<PlaneMax; i++)
	{
		NNPixels_pitch[i]=((srcPF->GetWidth(i)+63) >> 6) << 6;
		NNPixels_Size[i]=(size_t)srcPF->GetHeight(i)*(size_t)NNPixels_pitch[i];
	}
	for (uint8_t i=0; i<PlaneMax; i++)
		NNPixels[i]=(uint8_t *)_aligned_malloc(NNPixels_Size[i],64);
	for (uint8_t i=0; i<PlaneMax; i++)
	{
		if (NNPixels[i]==NULL)
		{
			FreeData();
			env->ThrowError("nnedi3: Unable to create NNPixels[%d]!",i);
		}
	}
	for (uint8_t i=0; i<PlaneMax; i++)
		memset(NNPixels[i],1,NNPixels_Size[i]);

	for (uint8_t i=0; i<threads_number; i++)
	{
		pssInfo[i].input = (float *)_aligned_malloc(512*sizeof(float),64);
		pssInfo[i].temp = (float *)_aligned_malloc(512*sizeof(float),64);
		if ((pssInfo[i].input==NULL) || (pssInfo[i].temp==NULL))
		{
			FreeData();
			env->ThrowError("nnedi3: Error while allocating pssInfo[%d]!",i);
		}
		pssInfo[i].weights0 = weights0;
		pssInfo[i].weights1 = weights1;
		pssInfo[i].ident = i;
		pssInfo[i].qual = qual;
		pssInfo[i].pscrn = pscrn;
		pssInfo[i].env = env;
		pssInfo[i].opt = opt;
		pssInfo[i].Y = Y;
		pssInfo[i].U = U;
		pssInfo[i].V = V;
		pssInfo[i].A = A;
		pssInfo[i].nns = nnsTable[nns];
		pssInfo[i].xdia = xdiaTable[nsize];
		pssInfo[i].ydia = ydiaTable[nsize];
		pssInfo[i].asize = xdiaTable[nsize]*ydiaTable[nsize];
		pssInfo[i].fapprox = fapprox;
		pssInfo[i].int16_predictor = int16_predictor;
		pssInfo[i].int16_prescreener = int16_prescreener;
		pssInfo[i].bits_per_pixel = bits_per_pixel;
		for (int b=0; b<PlaneMax; b++)
		{
			pssInfo[i].NNPixels[b] = NNPixels[b];
			pssInfo[i].NNPixels_pitch[b] = NNPixels_pitch[b];
			pssInfo[i].lcount[b] = lcount[b];
			pssInfo[i].dstp[b] = dstPF->GetPtr(b);
			pssInfo[i].srcp[b] = srcPF->GetPtr(b);
			pssInfo[i].dst_pitch[b] = dstPF->GetPitch(b);
			pssInfo[i].src_pitch[b] = srcPF->GetPitch(b);
			pssInfo[i].height[b] = srcPF->GetHeight(b);
			pssInfo[i].width[b] = srcPF->GetWidth(b);
			pssInfo[i].sheight[b] = srow[b];
			srow[b] += i == 0 ? hslice[b]+hremain[b] : hslice[b];
			pssInfo[i].eheight[b] = srow[b];
			pssInfo[i].plane_range[b] = plane_range[b];
		}
	}

	if (threads_number>1)
	{
		if (!poolInterface->AllocateThreads(UserId,threads_number,0,0,MaxPhysCores,SetAffinity,Sleep,-1))
		{
			FreeData();
			env->ThrowError("nnedi3: Error with the TheadPool while allocating threadpool !");
		}
	}
}


int __stdcall nnedi3::SetCacheHints(int cachehints,int frame_range)
{
  switch (cachehints)
  {
  case CACHE_GET_MTMODE :
    return MT_MULTI_INSTANCE;
  default :
    return 0;
  }
}


void nnedi3::FreeData(void)
{
	for (int8_t i=threads_number-1; i>=0; i--)
	{
		myalignedfree(pssInfo[i].temp);
		myalignedfree(pssInfo[i].input);
	}
	for (int8_t i=PLANE_MAX-1; i>=0; i--)
		myalignedfree(NNPixels[i]);
	myCloseHandle(ghMutex);
	for (int8_t i=PLANE_MAX-1; i>=0; i--)
		myalignedfree(lcount[i]);
	for (int8_t i=1; i>=0; i--)
		myalignedfree(weights1[i]);
	myalignedfree(weights0);
	mydelete(dstPF);
	mydelete(srcPF);
}

nnedi3::~nnedi3()
{
	if (threads_number>1) poolInterface->DeAllocateThreads(UserId);
	FreeData();
}


void evalFunc_1(void *ps);
void evalFunc_2(void *ps);
void evalFunc_1_16(void *ps);
void evalFunc_2_16(void *ps);
void evalFunc_1_32(void *ps);
void evalFunc_2_32(void *ps);


PVideoFrame __stdcall nnedi3::GetFrame(int n, IScriptEnvironment *env)
{
	int field_n;

	if (field>1)
	{
		if (n&1) field_n = field == 3 ? 0 : 1;
		else field_n = field == 3 ? 1 : 0;
	}
	else field_n = field;
	copyPad(field>1?(n>>1):n,field_n,env);
	
	const uint8_t PlaneMax=(grey) ? 1:(isAlphaChannel) ? 4:3;
	int plane[4];

	if (isRGBPfamily)
	{
		plane[0]=PLANAR_G;
		plane[1]=PLANAR_B;
		plane[2]=PLANAR_R;
		plane[3]=PLANAR_A;		
	}
	else
	{
		plane[0]=PLANAR_Y;
		plane[1]=PLANAR_U;
		plane[2]=PLANAR_V;
		plane[3]=PLANAR_A;				
	}

	for (uint8_t i=0; i<PlaneMax; i++)
		memset(lcount[i],0,dstPF->GetHeight(i)*sizeof(int));

	PVideoFrame dst = env->NewVideoFrame(vi,64);

	uint8_t f_proc_1=0,f_proc_2=0;

	switch (pixelsize)
	{
		case 1 : f_proc_1=1; f_proc_2=2; break;
		case 2 : f_proc_1=3; f_proc_2=4; break;
		case 4 : f_proc_1=5; f_proc_2=6; break;
		default : ;
	}
	
	for (uint8_t i=0; i<threads_number; i++)
	{
		for (uint8_t b=0; b<PlaneMax; b++)
		{
			const int srow = pssInfo[i].sheight[b];

			pssInfo[i].field[b] = (srow&1) ? 1-field_n : field_n;
			if (vi.IsPlanar())
			{
				pssInfo[i].dstp[b] = dst->GetWritePtr(plane[b]);
				pssInfo[i].dst_pitch[b] = dst->GetPitch(plane[b]);
			}
		}
		MT_Thread[i].f_process=f_proc_1;
	}
	
	if (threads_number>1)
	{
		if (!poolInterface->RequestThreadPool(UserId,threads_number,MT_Thread,-1,false))
		{
			ReleaseMutex(ghMutex);
			env->ThrowError("nnedi3: Error with the TheadPool while requesting threadpool !");
		}
		for (uint8_t b=0; b<PlaneMax; b++)
		{
			for (uint8_t i=0; i<threads_number; i++)
				pssInfo[i].current_plane=b;

			if (poolInterface->StartThreads(UserId)) poolInterface->WaitThreadsEnd(UserId);
		}
	}
	else
	{
		switch (f_proc_1)
		{
			case 1 :
				for (uint8_t b=0; b<PlaneMax; b++)
				{
					pssInfo[0].current_plane=b;
					evalFunc_1(pssInfo);
				}
				break;
			case 3 :
				for (uint8_t b=0; b<PlaneMax; b++)
				{
					pssInfo[0].current_plane=b;
					evalFunc_1_16(pssInfo);
				}
				break;
			case 5 :
				for (uint8_t b=0; b<PlaneMax; b++)
				{
					pssInfo[0].current_plane=b;
					evalFunc_1_32(pssInfo);
				}
				break;
			default : ;
		}
	}
	
	calcStartEnd2(vi.IsPlanar() ? dst:NULL);
	
	if (threads_number>1)
	{
		for (uint8_t i=0; i<threads_number; i++)
			MT_Thread[i].f_process= f_proc_2;

		for (uint8_t b=0; b<PlaneMax; b++)
		{
			for (uint8_t i=0; i<threads_number; i++)
				pssInfo[i].current_plane=b;

			if (poolInterface->StartThreads(UserId)) poolInterface->WaitThreadsEnd(UserId);
		}
		poolInterface->ReleaseThreadPool(UserId,Sleep);
	}
	else
	{
		switch (f_proc_2)
		{
			case 2 :
				for (uint8_t b=0; b<PlaneMax; b++)
				{
					pssInfo[0].current_plane=b;
					evalFunc_2(pssInfo);
				}
				break;
			case 4 :
				for (uint8_t b=0; b<PlaneMax; b++)
				{
					pssInfo[0].current_plane=b;
					evalFunc_2_16(pssInfo);
				}
				break;
			case 6 :
				for (uint8_t b=0; b<PlaneMax; b++)
				{
					pssInfo[0].current_plane=b;
					evalFunc_2_32(pssInfo);
				}
				break;
			default :;
		}
	}

	
	if (!vi.IsPlanar()) dstPF->copyTo(dst, vi);

	ReleaseMutex(ghMutex);

	return dst;
}


void nnedi3::copyPad(int n, int fn, IScriptEnvironment *env)
{
	const int off = 1-fn;
	PVideoFrame src = child->GetFrame(n, env);
	
	WaitForSingleObject(ghMutex,INFINITE);
	
	const uint8_t PlaneMax=(grey) ? 1:(isAlphaChannel) ? 4:3;
	int plane[4];
	if (isRGBPfamily)
	{
		plane[0]=PLANAR_G;
		plane[1]=PLANAR_B;
		plane[2]=PLANAR_R;
		plane[3]=PLANAR_A;		
	}
	else
	{
		plane[0]=PLANAR_Y;
		plane[1]=PLANAR_U;
		plane[2]=PLANAR_V;
		plane[3]=PLANAR_A;				
	}
	
	if (!dh)
	{
		if (vi.IsPlanar())
		{
			for (uint8_t b=0; b<PlaneMax; b++)
				env->BitBlt(srcPF->GetPtr(b)+(srcPF->GetPitch(b)*(6+off)+32*(int)pixelsize),
					srcPF->GetPitch(b) << 1,
					src->GetReadPtr(plane[b])+src->GetPitch(plane[b])*off,
					src->GetPitch(plane[b])<<1,src->GetRowSize(plane[b]),
					src->GetHeight(plane[b])>>1);
		}
		else
		{
			if (vi.IsYUY2())
			{
				srcPF->convYUY2to422(src->GetReadPtr()+src->GetPitch()*off,
					srcPF->GetPtr(0)+(srcPF->GetPitch(0)*(6+off)+32),
					srcPF->GetPtr(1)+(srcPF->GetPitch(1)*(6+off)+32),
					srcPF->GetPtr(2)+(srcPF->GetPitch(2)*(6+off)+32),
					src->GetPitch() << 1,srcPF->GetPitch(0) << 1,srcPF->GetPitch(1) << 1,
					vi.width,vi.height>>1);
			}
			else
			{
				if (vi.IsRGB24())
				{
					srcPF->convRGB24to444(src->GetReadPtr()+(vi.height-1-off)*src->GetPitch(),
						srcPF->GetPtr(0)+(srcPF->GetPitch(0)*(6+off)+32),
						srcPF->GetPtr(1)+(srcPF->GetPitch(1)*(6+off)+32),
						srcPF->GetPtr(2)+(srcPF->GetPitch(2)*(6+off)+32),
						-src->GetPitch() << 1,srcPF->GetPitch(0) << 1,srcPF->GetPitch(1) << 1,
						vi.width,vi.height>>1);
				}
			}
		}
	}
	else
	{
		if (vi.IsPlanar())
		{
			for (uint8_t b=0; b<PlaneMax; b++)
				env->BitBlt(srcPF->GetPtr(b)+(srcPF->GetPitch(b)*(6+off)+32*(int)pixelsize),
					srcPF->GetPitch(b) << 1,src->GetReadPtr(plane[b]),
					src->GetPitch(plane[b]),src->GetRowSize(plane[b]),
					src->GetHeight(plane[b]));
		}
		else
		{
			if (vi.IsYUY2())
			{
				srcPF->convYUY2to422(src->GetReadPtr(),
					srcPF->GetPtr(0)+(srcPF->GetPitch(0)*(6+off)+32),
					srcPF->GetPtr(1)+(srcPF->GetPitch(1)*(6+off)+32),
					srcPF->GetPtr(2)+(srcPF->GetPitch(2)*(6+off)+32),
					src->GetPitch(),srcPF->GetPitch(0) << 1,srcPF->GetPitch(1) << 1,
					vi.width,vi.height>>1);
			}
			else
			{
				if (vi.IsRGB24())
				{
					srcPF->convRGB24to444(src->GetReadPtr()+((vi.height>>1)-1)*src->GetPitch(),
						srcPF->GetPtr(0)+(srcPF->GetPitch(0)*(6+off)+32),
						srcPF->GetPtr(1)+(srcPF->GetPitch(1)*(6+off)+32),
						srcPF->GetPtr(2)+(srcPF->GetPitch(2)*(6+off)+32),
						-src->GetPitch(),srcPF->GetPitch(0) << 1,srcPF->GetPitch(1) << 1,
						vi.width,vi.height>>1);
				}
			}
		}
	}

	for (uint8_t b=0; b<PlaneMax; b++)
	{
		uint8_t *dstp = srcPF->GetPtr(b);
		const int dst_pitch = srcPF->GetPitch(b);
		const int dst_pitch2 = dst_pitch << 1;
		const int height = srcPF->GetHeight(b);
		const int height_6 = height-6;
		const int width = srcPF->GetWidth(b);
		const int width_ = width*(int)pixelsize;

		dstp += (6+off)*dst_pitch;
		if (pixelsize==1)
		{
			for (int y=6+off; y<height_6; y+=2)
			{
				for (int x=0; x<32; x++)
					dstp[x] = dstp[64-x];

				int x_c = width-34;

				for (int x=width-32; x<width; x++)
					dstp[x] = dstp[x_c--];

				dstp += dst_pitch2;
			}
		}
		else
		{
			if (pixelsize==2)
			{
				for (int y=6+off; y<height_6; y+=2)
				{
					uint16_t *dst0 = (uint16_t *)dstp;

					for (int x=0; x<32; x++)
						dst0[x] = dst0[64-x];

					int x_c = width-34;

					for (int x=width-32; x<width; x++)
						dst0[x] = dst0[x_c--];

					dstp += dst_pitch2;
				}
			}
			else
			{
				for (int y=6+off; y<height_6; y+=2)
				{
					float *dst0 = (float *)dstp;

					for (int x=0; x<32; x++)
						dst0[x] = dst0[64-x];

					int x_c = width-34;

					for (int x=width-32; x<width; x++)
						dst0[x] = dst0[x_c--];

					dstp += dst_pitch2;
				}
			}
		}

		dstp = srcPF->GetPtr(b);

		int off1=off*dst_pitch,off2=(12+off)*dst_pitch;

		for (int y=off; y<6; y+=2)
		{
			memcpy(dstp+off1,dstp+off2,width_);
			off1+=dst_pitch2;
			off2-=dst_pitch2;
		}

		off1=(height-6+off)*dst_pitch;
		off2=(height-10+off)*dst_pitch;
		for (int y=height-6+off; y<height; y+=2)
		{
			memcpy(dstp+off1,dstp+off2,width_);
			off1+=dst_pitch2;
			off2-=dst_pitch2;
		}
	}
}


void nnedi3::calcStartEnd2(PVideoFrame dst)
{
	const uint8_t PlaneMax = (grey) ? 1 : (isAlphaChannel) ? 4 : 3;

	for (uint8_t b=0; b<PlaneMax; b++)
	{
		if (((b==0) && !Y) || ((b==1) && !U) || ((b==2) && !V) || ((b==3) && !A)) continue;

		const int height=dstPF->GetHeight(b);
		int total=0,fl=-1,ll=0;

		for (int j=0; j<height; j++)
		{
			total+=lcount[b][j];
			if ((fl<0) && (lcount[b][j]>0)) fl=j;
		}
		if (total==0) fl=height;
		else
		{
			for (int j=height-1; j>=0; j--)
			{
				if (lcount[b][j]!=0) break;
				ll++;
			}
		}
		int tslice=int((double)total/double(threads_number)+0.95);
		int count=0,countt=0,y=fl,yl=fl,th=0;

		const int height_ll=height-ll;

		while (y<height_ll)
		{
			count+=lcount[b][y++];
			if (count>=tslice)
			{
				pssInfo[th].sheight2[b]=yl;
				countt+=count;
				if (countt==total) y=height_ll;
				pssInfo[th].eheight2[b]=y;
				while ((y<height_ll) && (lcount[b][y]==0))
					y++;
				yl=y;
				count=0;
				th++;
			}
		}
		if (yl!=y)
		{
			pssInfo[th].sheight2[b]=yl;
			countt+=count;
			if (countt==total) y=height_ll;
			pssInfo[th].eheight2[b]=y;
			th++;
		}
		for (; th<(int)threads_number; th++)
			pssInfo[th].sheight2[b]=pssInfo[th].eheight2[b]=height;
	}
}


void elliott_C(float *data, const int n)
{
	for (int i=0; i<n; i++)
		data[i]/=1.0f+fabsf(data[i]);
}


void dotProd_C(const float *data, const float *weights, float *vals, const int n, const int len, const float *scale)
{
	const float *weights0 = weights;

	weights+=n*len;

	for (int i=0; i<n; i++)
	{
		float sum = 0.0f;

		for (int j=0; j<len; j++)
			sum += data[j]*weights0[j];

		vals[i] = sum*(*scale)+weights[i];
		weights0 += len;
	}
}


void dotProdS_C(const float *dataf, const float *weightsf, float *vals, const int n, const int len, const float *scale)
{
	const int16_t *data = (int16_t *)dataf;
	const int16_t *weights = (int16_t *)weightsf;
	const float *wf = (float *)&weights[n*len];

	for (int i=0; i<n; i++)
	{
		int sum = 0, off = ((i>>2)<< 3)+(i&3);

		for (int j=0; j<len; j++)
			sum += data[j]*weights[j];

		vals[i] = sum*wf[off]*(*scale)+wf[off+4];
		weights += len;
	}
}


void computeNetwork0_C(const float *input, const float *weights, uint8_t *d)
{
	float temp[12],scale=1.0f;

	dotProd_C(input,weights,temp,4,48,&scale);

	const float t=temp[0];

	elliott_C(temp,4);
	temp[0] = t;
	dotProd_C(temp,weights+4*49,temp+4,4,4,&scale);
	elliott_C(temp+4,4);
	dotProd_C(temp,weights+4*49+4*5,temp+8,4,8,&scale);

	if (max(temp[10],temp[11])<=max(temp[8],temp[9])) d[0]=1;
	else d[0]=0;
}


void computeNetwork0_i16_C(const float *inputf, const float *weightsf, uint8_t *d)
{
	const float *wf = weightsf+2*48;
	float temp[12],scale=1.0f;

	dotProdS_C(inputf,weightsf,temp,4,48,&scale);

	const float t=temp[0];

	elliott_C(temp,4);
	temp[0] = t;
	dotProd_C(temp,wf+8,temp+4,4,4,&scale);
	elliott_C(temp+4,4);
	dotProd_C(temp,wf+8+4*5,temp+8,4,8,&scale);

	if (max(temp[10],temp[11])<=max(temp[8],temp[9])) d[0]=1;
	else d[0]=0;
}


void uc2f48_C(const uint8_t *t, const int pitch, float *p)
{
	const int pitch2 = pitch << 1;

	for (int y = 0; y<4; y++)
	{
		for (int x = 0; x<12; x++)
			p[x] = t[x];

		p += 12;
		t += pitch2;
	}
}


void uc2s48_C(const uint8_t *t, const int pitch, float *pf)
{
	const int pitch2 = pitch << 1;
	int16_t *p = (int16_t *)pf;

	for (int y = 0; y<4; y++)
	{
		for (int x = 0; x<12; x++)
			p[x] = t[x];

		p += 12;
		t += pitch2;
	}
}


int processLine0_C(const uint8_t *tempu, int width, uint8_t *dstp, const uint8_t *src3p, const int src_pitch,const int16_t val_min,const int16_t val_max)
{
	int count = 0;
	const uint8_t *src2 = src3p+(src_pitch << 1);
	const uint8_t *src4 = src3p+(src_pitch << 2);
	const uint8_t *src6 = src3p+(src_pitch*6);

	for (int x=0; x<width; x++)
	{
		if (tempu[x]!=0) dstp[x]=(uint8_t)clamp(((19*((int16_t)(src2[x])+(int16_t)(src4[x]))-3*((int16_t)(src3p[x])+(int16_t)(src6[x]))+16)>>5),val_min,val_max);
		else count++;
	}
	return count;
}


int processLine0_SSE2(const uint8_t *tempu, int width, uint8_t *dstp, const uint8_t *src3p, const int src_pitch,const int16_t val_min,const int16_t val_max)
{
	int count;
	const int width_m = ((width+15) >> 4) << 4;

	if (width_m!=0) count=processLine0_SSE2_ASM(tempu,width_m,dstp,src3p,src_pitch,val_min,val_max);
	else count=0;
	return count;
}


#ifdef AVX_BUILD_POSSIBLE
int processLine0_AVX2(const uint8_t *tempu, int width, uint8_t *dstp, const uint8_t *src3p, const int src_pitch,const int16_t val_min,const int16_t val_max)
{
	int count;
	const int width_m = ((width+31) >> 5) << 5;

	if (width_m!=0) count=processLine0_AVX2_ASM(tempu,width_m,dstp,src3p,src_pitch,val_min,val_max);
	else count=0;
	return count;
}
#endif


// new prescreener functions

void uc2s64_C(const uint8_t *t, const int pitch, float *p)
{
	int16_t *ps = (int16_t *)p;
	const int pitch2 = pitch << 1;

	for (int y = 0; y<4; y++)
	{
		for (int x = 0; x<16; x++)
			ps[x] = t[x];

		ps += 16;
		t += pitch2;
	}
}


void computeNetwork0new_C(const float *datai, const float *weights, uint8_t *d)
{
	int16_t *data = (int16_t *)datai;
	int16_t *ws = (int16_t *)weights;
	float *wf = (float *)&ws[4 * 64];
	float vals[8];

	for (int i = 0; i<4; i++)
	{
		int sum = 0;
		const int i_3 = i << 3;

		for (int j = 0; j<64; j++)
			sum += data[j] * ws[i_3 + ((j >> 3) << 5) + (j & 7)];

		const float t = sum*wf[i] + wf[4 + i];
		vals[i] = t / (1.0f + fabsf(t));
	}

	for (int i = 0; i<4; i++)
	{
		float sum = 0.0f;
		int const i_8 = 8 + i;

		for (int j = 0; j<4; j++)
			sum += vals[j] * wf[i_8 + (j << 2)];

		vals[4 + i] = sum + wf[8 + 16 + i];
	}

	int mask = 0;

	for (int i = 0; i<4; i++)
	{
		if (vals[4 + i]>0.0f)
			mask |= (0x1 << (i << 3));
	}
	*((int*)d) = mask;
}


void evalFunc_1(void *ps)
{
	PS_INFO *pss = (PS_INFO *)ps;
	float *input = pss->input;
	const float *weights0 = pss->weights0;
	const int opt = pss->opt;
	const int pscrn = pss->pscrn;
	const int fapprox = pss->fapprox;
	const bool int16_prescreener = pss->int16_prescreener;
	void (*uc2s)(const uint8_t*,const int,float*);
	void (*computeNetwork0)(const float*,const float*,uint8_t*);
	int (*processLine0)(const uint8_t*,int,uint8_t*,const uint8_t*,const int,const int16_t,const int16_t);

#ifdef AVX_BUILD_POSSIBLE
	if (opt==1) processLine0=processLine0_C;
	else
	{
		if (opt>=4) processLine0=processLine0_AVX2;
		else processLine0=processLine0_SSE2;
	}

	if (pscrn<2) // original prescreener
	{
		if (int16_prescreener) // int16 dot products
		{
			if (opt==1) uc2s=uc2s48_C;
			else
			{
				if (opt>=4) uc2s=uc2s48_AVX2;
				else uc2s=uc2s48_SSE2;
			}
			if (opt==1) computeNetwork0=computeNetwork0_i16_C;
			else
			{
				if (opt>=4) computeNetwork0=computeNetwork0_i16_AVX2;
				else computeNetwork0=computeNetwork0_i16_SSE2;
			}
		}
		else
		{
			if (opt==1) uc2s=uc2f48_C;
			else
			{
				if (opt>=4) uc2s=uc2f48_AVX2;
				else uc2s=uc2f48_SSE2;
			}
			if (opt==1) computeNetwork0=computeNetwork0_C;
			else
			{
				if (opt==6) computeNetwork0=computeNetwork0_FMA4;
				else
				{
					if (opt==5) computeNetwork0=computeNetwork0_FMA3;
					else
					{
						if (opt>=4) computeNetwork0=computeNetwork0_AVX2;
						else computeNetwork0=computeNetwork0_SSE2;
					}
				}
			}
		}
	}
	else // new prescreener
	{
		// only int16 dot products
		if (opt==1) uc2s=uc2s64_C;
		else
		{
			if (opt>=4) uc2s=uc2s64_AVX2;
			else uc2s=uc2s64_SSE2;
		}
		if (opt==1) computeNetwork0=computeNetwork0new_C;
		else
		{
			if (opt>=4) computeNetwork0=computeNetwork0new_AVX2;
			else computeNetwork0=computeNetwork0new_SSE2;
		}
	}
#else
	if (opt==1) processLine0=processLine0_C;
	else processLine0=processLine0_SSE2;

	if (pscrn<2) // original prescreener
	{
		if (int16_prescreener) // int16 dot products
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
#endif

	uint8_t b = pss->current_plane;

	if (((b==0) && pss->Y) || ((b==1) && pss->U) || ((b==2) && pss->V) || ((b==3) && pss->A))
	{
		uint8_t *NNPixels = pss->NNPixels[b];
		const int NNPixels_pitch = pss->NNPixels_pitch[b];
		const int NNPixels_pitch_2 = NNPixels_pitch << 1;
		const uint8_t range_mode=pss->plane_range[b];
		const uint8_t *srcp = pss->srcp[b];
		const int src_pitch = pss->src_pitch[b];
		const int width = pss->width[b];
		const int width_32=width-32;
		const int width_64=width-64;
		uint8_t *dstp = pss->dstp[b];
		const int dst_pitch = pss->dst_pitch[b];
		pss->env->BitBlt(dstp+(pss->sheight[b]-5-pss->field[b])*dst_pitch,
			dst_pitch << 1,srcp+((pss->sheight[b]+1-pss->field[b])*src_pitch+32),
			src_pitch << 1,width_64,(pss->eheight[b]-pss->sheight[b]+pss->field[b])>>1);
		const int ystart = pss->sheight[b]+pss->field[b];
		const int ystop = pss->eheight[b];
		const int src_pitch2=src_pitch << 1;
		const int dst_pitch2=dst_pitch << 1;

		uint8_t val_min,val_max;

		switch(range_mode)
		{
			case 1 :
				val_min=0; val_max=255;
				break;
			case 2 :
				val_min=16; val_max=235;
				break;
			case 3 :
				val_min=16; val_max=240;
				break;
			case 4 :
				val_min=16; val_max=255;
				break;
			default :
				val_min=0; val_max=255;
				break;
		}

		srcp+=ystart*src_pitch;
		dstp+=(ystart-6)*dst_pitch-32;
		NNPixels+=(ystart-6)*NNPixels_pitch;

		const uint8_t *src3p = srcp-src_pitch*3;
		int *lcount = pss->lcount[b]-6;

		if (pscrn==1) // original
		{
			for (int y=ystart; y<ystop; y+=2)
			{
				const uint8_t *src0 =src3p-5;

				for (int x=32; x<width_32; x++)
				{
					uc2s(src0+x,src_pitch,input);
					computeNetwork0(input,weights0,NNPixels+x);
				}
				lcount[y]+=processLine0(NNPixels+32,width_64,dstp+32,src3p+32,src_pitch,val_min,val_max);
				src3p+=src_pitch2;
				dstp+=dst_pitch2;
				NNPixels+=NNPixels_pitch_2;
			}
		}
		else
		{
			if (pscrn>=2) // new
			{
				for (int y=ystart; y<ystop; y+=2)
				{
					const uint8_t *src0=src3p-6;

					for (int x=32; x<width_32; x+=4)
					{
						uc2s(src0+x,src_pitch,input);
						computeNetwork0(input,weights0,NNPixels+x);
					}
					lcount[y]+=processLine0(NNPixels+32,width_64,dstp+32,src3p+32,src_pitch,val_min,val_max);
					src3p+=src_pitch2;
					dstp+=dst_pitch2;
					NNPixels+=NNPixels_pitch_2;
				}
			}
			else // no prescreening
			{
				for (int y=ystart; y<ystop; y+=2)
				{
					memset(NNPixels,0,width);
					lcount[y]+=width_64;
					dstp+=dst_pitch2;
					NNPixels+=NNPixels_pitch_2;
				}
			}
		}
	}
}


int processLine0_C_16(const uint8_t *tempu,int width, uint8_t *dstp,const uint8_t *src3p,const int src_pitch,const uint16_t val_min,const uint16_t val_max)
{
	int count = 0;
	const uint16_t *src0 = (uint16_t *)src3p;
	const uint16_t *src2 = (uint16_t *)(src3p+(src_pitch << 1));
	const uint16_t *src4 = (uint16_t *)(src3p+(src_pitch << 2));
	const uint16_t *src6 = (uint16_t *)(src3p+(src_pitch*6));
	uint16_t *dst0 = (uint16_t *)dstp;

	for (int x=0; x<width; x++)
	{
		if (tempu[x]!=0) dst0[x]=(uint16_t)clamp(((19*((int32_t)src2[x]+(int32_t)src4[x])-3*((int32_t)src0[x]+(int32_t)src6[x])+16)>>5),val_min,val_max);
		else count++;
	}
	return count;
}


void uc2s48_C_16(const uint8_t *t, const int pitch, float *pf)
{
	const int pitch2 = pitch << 1;
	uint16_t *p = (uint16_t *)pf;

	for (int y=0; y<4; y++)
	{
		memcpy(p,t,24);

		p += 12;
		t += pitch2;
	}
}


void uc2f48_C_16(const uint8_t *t, const int pitch, float *p)
{
	const int pitch2 = pitch << 1;

	for (int y=0; y<4; y++)
	{
		uint16_t *t0 = (uint16_t *)t;

		for (int x=0; x<12; x++)
			p[x] = t0[x];

		p += 12;
		t += pitch2;
	}
}


void uc2s64_C_16(const uint8_t *t, const int pitch, float *p)
{
	uint16_t *ps = (uint16_t *)p;
	const int pitch2 = pitch << 1;

	for (int y=0; y<4; y++)
	{
		memcpy(ps,t,32);

		ps += 16;
		t += pitch2;
	}
}


void dotProdS_C_16(const float *dataf,const float *weightsf,float *vals,const int n,const int len,const float *scale)
{
	const uint16_t *data = (uint16_t *)dataf;
	const int16_t *weights = (int16_t *)weightsf;
	const float *wf = (float *)&weights[n*len];

	for (int i=0; i<n; i++)
	{
		__int64 sum = 0;
		const int off = ((i>>2)<<3)+(i&3);

		for (int j=0; j<len; j++)
			sum += (int)data[j]*(int)weights[j];

		vals[i] = sum*wf[off]*(*scale)+wf[off+4];
		weights += len;
	}
}


void computeNetwork0_i16_C_16(const float *inputf, const float *weightsf, uint8_t *d)
{
	const float *wf = weightsf+2*48;
	float temp[12],scale=1.0f;

	dotProdS_C_16(inputf,weightsf,temp,4,48,&scale);

	const float t=temp[0];

	elliott_C(temp,4);
	temp[0] = t;
	dotProd_C(temp,wf+8,temp+4,4,4,&scale);
	elliott_C(temp+4,4);
	dotProd_C(temp,wf+8+4*5,temp+8,4,8,&scale);

	if (max(temp[10],temp[11]) <= max(temp[8],temp[9])) d[0]=1;
	else d[0]=0;
}


void computeNetwork0new_C_16(const float *datai, const float *weights, uint8_t *d)
{
	uint16_t *data = (uint16_t *)datai;
	int16_t *ws = (int16_t *)weights;
	float *wf = (float *)&ws[4*64];
	float vals[8];

	for (int i=0; i<4; i++)
	{
		__int64 sum = 0;
		const int i_3 = i << 3;

		for (int j=0; j<64; j++)
			sum += (int)data[j]*(int)ws[i_3+((j>>3)<<5)+(j&7)];

		const float t=sum*wf[i]+wf[4+i];
		vals[i] = t/(1.0f+fabsf(t));
	}

	for (int i=0; i<4; i++)
	{
		float sum = 0.0f;
		const int i_8 = i + 8;

		for (int j=0; j<4; j++)
			sum += vals[j]*wf[i_8+(j<<2)];

		vals[4+i] = sum+wf[8+16+i];
	}

	int mask=0;

	for (int i=0; i<4; i++)
	{
		if (vals[4+i]>0.0f)
			mask |= (0x1 << (i<<3));
	}
	*((int*)d) = mask;
}


int processLine0_SSE2_16(const uint8_t *tempu, int width, uint8_t *dstp, const uint8_t *src3p, const int src_pitch,const uint16_t val_min,const uint16_t val_max)
{
	int count;
	const int width_m = ((width+7) >> 3) << 3;

	if (width_m!=0) count=processLine0_SSE2_ASM_16(tempu,width_m,dstp,src3p,src_pitch,val_min,val_max);
	else count=0;

	return count;
}


#ifdef AVX_BUILD_POSSIBLE
int processLine0_AVX2_16(const uint8_t *tempu, int width, uint8_t *dstp, const uint8_t *src3p, const int src_pitch,const uint16_t val_min,const uint16_t val_max)
{
	int count;
	const int width_m = ((width+15) >> 4) << 4;

	if (width_m!=0) count=processLine0_AVX2_ASM_16(tempu,width_m,dstp,src3p,src_pitch,val_min,val_max);
	else count=0;

	return count;
}
#endif


void evalFunc_1_16(void *ps)
{
	PS_INFO *pss = (PS_INFO *)ps;
	float *input = pss->input;
	const float *weights0 = pss->weights0;
	const int opt = pss->opt;
	const int pscrn = pss->pscrn;
	const int fapprox = pss->fapprox;
	const bool int16_prescreener = pss->int16_prescreener;
	const uint8_t bits_per_pixel = pss->bits_per_pixel;
	void(*uc2s)(const uint8_t*, const int, float*);
	void(*computeNetwork0)(const float*, const float*, uint8_t*);
	int(*processLine0)(const uint8_t*, int, uint8_t*, const uint8_t*, const int,const uint16_t,const uint16_t);

#ifdef AVX_BUILD_POSSIBLE
	if (opt<3) processLine0=processLine0_C_16;
	else
	{
		if (opt>=4) processLine0=processLine0_AVX2_16;
		else processLine0=processLine0_SSE2_16;
	}

	if (pscrn<2) // original prescreener
	{
		if (int16_prescreener) // int16 dot products
		{
			uc2s=uc2s48_C_16;
			if ((opt==1) || (bits_per_pixel>14)) computeNetwork0=computeNetwork0_i16_C;
			else
			{
				if (opt>=4) computeNetwork0=computeNetwork0_i16_AVX2;
				else computeNetwork0=computeNetwork0_i16_SSE2;
			}
		}
		else
		{
			if (opt==1) uc2s=uc2f48_C_16;
			else
			{
				if (opt>=4) uc2s=uc2f48_AVX2_16;
				else uc2s=uc2f48_SSE2_16;
			}
			if (opt==1) computeNetwork0=computeNetwork0_C;
			else
			{
				if (opt==6) computeNetwork0=computeNetwork0_FMA4;
				else
				{
					if (opt==5) computeNetwork0=computeNetwork0_FMA3;
					else
					{
						if (opt>=4) computeNetwork0=computeNetwork0_AVX2;
						else computeNetwork0=computeNetwork0_SSE2;
					}
				}
			}
		}
	}
	else // new prescreener
	{
		// only int16 dot products
		uc2s = uc2s64_C_16;
		if ((opt==1) || (bits_per_pixel>14)) computeNetwork0=computeNetwork0new_C_16;
		else
		{
			if (opt>=4) computeNetwork0=computeNetwork0new_AVX2;
			else computeNetwork0=computeNetwork0new_SSE2;
		}
	}
#else
	if (opt>=3) processLine0 = processLine0_SSE2_16;
	else processLine0 = processLine0_C_16;

	if (pscrn<2) // original prescreener
	{
		if (int16_prescreener) // int16 dot products
		{
			uc2s=uc2s48_C_16;
			if ((opt==1) || (bits_per_pixel>14)) computeNetwork0=computeNetwork0_i16_C;
			else computeNetwork0=computeNetwork0_i16_SSE2;
		}
		else
		{
			if (opt==1) uc2s=uc2f48_C_16;
			else uc2s=uc2f48_SSE2_16;
			if (opt==1) computeNetwork0=computeNetwork0_C;
			else computeNetwork0=computeNetwork0_SSE2;
		}
	}
	else // new prescreener
	{
		// only int16 dot products
		uc2s = uc2s64_C_16;
		if ((opt==1) || (bits_per_pixel>14)) computeNetwork0=computeNetwork0new_C_16;
		else computeNetwork0=computeNetwork0new_SSE2;
	}
#endif

	uint8_t b = pss->current_plane;

	if (((b==0) && pss->Y) || ((b==1) && pss->U) || ((b==2) && pss->V) || ((b==3) && pss->A))
	{
		uint8_t *NNPixels = pss->NNPixels[b];
		const int NNPixels_pitch = pss->NNPixels_pitch[b];
		const int NNPixels_pitch_2 = NNPixels_pitch << 1;
		const uint8_t range_mode=pss->plane_range[b];
		const uint8_t *srcp = pss->srcp[b];
		const int src_pitch = pss->src_pitch[b];
		const int width = pss->width[b];
		const int width_32 = width - 32;
		const int width_64 = width - 64;
		const int width_64_2 = width_64 << 1;
		uint8_t *dstp = pss->dstp[b];
		const int dst_pitch = pss->dst_pitch[b];
		pss->env->BitBlt(dstp+(pss->sheight[b]-5-pss->field[b])*dst_pitch,
			dst_pitch << 1,srcp+((pss->sheight[b]+1-pss->field[b])*src_pitch+64),
			src_pitch << 1,width_64_2,(pss->eheight[b]-pss->sheight[b]+pss->field[b]) >> 1);
		const int ystart = pss->sheight[b]+pss->field[b];
		const int ystop = pss->eheight[b];
		const int src_pitch2 = src_pitch << 1;
		const int dst_pitch2 = dst_pitch << 1;

		uint16_t val_min,val_max;

		switch(range_mode)
		{
			case 1 :
				val_min=0; val_max=(uint16_t)(((int)1 << bits_per_pixel) - 1);
				break;
			case 2 :
				val_min=(uint16_t)((int)16 << (bits_per_pixel-8)); val_max=(uint16_t)((int)235 << (bits_per_pixel-8));
				break;
			case 3 :
				val_min=(uint16_t)((int)16 << (bits_per_pixel-8)); val_max=(uint16_t)((int)240 << (bits_per_pixel-8));
				break;
			case 4 :
				val_min=(uint16_t)((int)16 << (bits_per_pixel-8)); val_max=(uint16_t)(((int)1 << bits_per_pixel) - 1);
				break;
			default :
				val_min=0; val_max=(uint16_t)(((int)1 << bits_per_pixel) - 1);
				break;
		}

		srcp += ystart*src_pitch;
		dstp += (ystart-6)*dst_pitch-64;
		NNPixels+=(ystart-6)*NNPixels_pitch;

		const uint8_t *src3p = srcp-src_pitch*3;
		int *lcount = pss->lcount[b]-6;

		if (pscrn==1) // original
		{
			for (int y=ystart; y<ystop; y+=2)
			{
				const uint8_t *src0=src3p-10;

				for (int x=32; x<width_32; x++)
				{
					uc2s(src0+(x<<1),src_pitch,input);
					computeNetwork0(input,weights0,NNPixels+x);
				}
				lcount[y]+=processLine0(NNPixels+32,width_64,dstp+64,src3p+64,src_pitch,val_min,val_max);

				src3p += src_pitch2;
				dstp += dst_pitch2;
				NNPixels+=NNPixels_pitch_2;
			}
		}
		else
		{
			if (pscrn>=2) // new
			{
				for (int y=ystart; y<ystop; y+=2)
				{
					const uint8_t *src0=src3p-12;

					for (int x=32; x<width_32; x+=4)
					{
						uc2s(src0+(x<<1),src_pitch,input);
						computeNetwork0(input,weights0,NNPixels+x);
					}
					lcount[y] += processLine0(NNPixels+32,width_64,dstp+64,src3p+64,src_pitch,val_min,val_max);
					src3p += src_pitch2;
					dstp += dst_pitch2;
					NNPixels+=NNPixels_pitch_2;
				}
			}
			else // no prescreening
			{
				for (int y=ystart; y<ystop; y+=2)
				{
					memset(NNPixels,0,width);
					lcount[y] += width_64;
					dstp += dst_pitch2;
					NNPixels+=NNPixels_pitch_2;
				}
			}
		}
	}
}



int processLine0_C_32(const uint8_t *tempu, int width, uint8_t *dstp, const uint8_t *src3p, const int src_pitch)
{
	int count = 0;
	const float *src0 = (float *)src3p;
	const float *src2 = (float *)(src3p + (src_pitch << 1));
	const float *src4 = (float *)(src3p + (src_pitch << 2));
	const float *src6 = (float *)(src3p + (src_pitch * 6));
	float *dst0 = (float *)dstp;
	uint32_t *dst = (uint32_t *)dstp;

	for (int x=0; x<width; x++)
	{
		if (tempu[x]!=0) dst0[x] = 0.59375f*(src2[x]+src4[x])-0.09375f*(src0[x]+src6[x]);
		else count++;
	}
	return count;
}


void uc2f48_C_32(const uint8_t *t, const int pitch, float *p)
{
	const int pitch2 = pitch << 1;

	for (int y=0; y<4; y++)
	{
		memcpy(p,t,48);

		p += 12;
		t += pitch2;
	}
}


int processLine0_SSE2_32(const uint8_t *tempu, int width, uint8_t *dstp, const uint8_t *src3p, const int src_pitch)
{
	int count;
	const int width_m = ((width+3) >> 2) << 2;

	if (width_m!=0) count=processLine0_SSE2_ASM_32(tempu,width_m,dstp,src3p,src_pitch);
	else count=0;

	return count;
}


#ifdef AVX_BUILD_POSSIBLE
int processLine0_AVX2_32(const uint8_t *tempu, int width, uint8_t *dstp, const uint8_t *src3p, const int src_pitch)
{
	int count;
	const int width_m = ((width+7) >> 3) << 3;

	if (width_m!=0) count=processLine0_AVX2_ASM_32(tempu,width_m,dstp,src3p,src_pitch);
	else count=0;

	return count;
}
#endif


void evalFunc_1_32(void *ps)
{
	PS_INFO *pss = (PS_INFO *)ps;
	float *input = pss->input;
	const float *weights0 = pss->weights0;
	const int opt = pss->opt;
	const int pscrn = pss->pscrn;
	const int fapprox = pss->fapprox;
	void(*uc2s)(const uint8_t*, const int, float*);
	void(*computeNetwork0)(const float*, const float*, uint8_t*);
	int(*processLine0)(const uint8_t*, int, uint8_t*, const uint8_t*, const int);

#ifdef AVX_BUILD_POSSIBLE
	if (opt==1) processLine0=processLine0_C_32;
	else
	{
		if (opt>=4) processLine0=processLine0_AVX2_32;
		else processLine0=processLine0_SSE2_32;
	}

	if (opt==1) computeNetwork0=computeNetwork0_C;
	else
	{
		if (opt==6) computeNetwork0=computeNetwork0_FMA4;
		else
		{
			if (opt==5) computeNetwork0=computeNetwork0_FMA3;
			else
			{
				if (opt>=4) computeNetwork0=computeNetwork0_AVX2;
				else computeNetwork0=computeNetwork0_SSE2;
			}
		}
	}
#else
	if (opt==1) processLine0 = processLine0_C_32;
	else processLine0 = processLine0_SSE2_32;
	if (opt==1) computeNetwork0=computeNetwork0_C;
	else computeNetwork0=computeNetwork0_SSE2;
#endif
	uc2s=uc2f48_C_32;

	uint8_t b = pss->current_plane;

	if (((b == 0) && pss->Y) || ((b == 1) && pss->U) || ((b == 2) && pss->V) || ((b == 3) && pss->A))
	{
		uint8_t *NNPixels = pss->NNPixels[b];
		const int NNPixels_pitch = pss->NNPixels_pitch[b];
		const int NNPixels_pitch_2 = NNPixels_pitch << 1;
		const uint8_t *srcp = pss->srcp[b];
		const int src_pitch = pss->src_pitch[b];
		const int width = pss->width[b];
		const int width_32 = width - 32;
		const int width_64 = width - 64;
		const int width_64_4 = width_64 << 2;
		uint8_t *dstp = pss->dstp[b];
		const int dst_pitch = pss->dst_pitch[b];
		pss->env->BitBlt(dstp+(pss->sheight[b]-5-pss->field[b])*dst_pitch,
			dst_pitch<<1,srcp+((pss->sheight[b]+1-pss->field[b])*src_pitch+128),
			src_pitch<<1,width_64_4,(pss->eheight[b]-pss->sheight[b]+pss->field[b])>>1);
		const int ystart = pss->sheight[b]+pss->field[b];
		const int ystop = pss->eheight[b];
		const int src_pitch2 = src_pitch << 1;
		const int dst_pitch2 = dst_pitch << 1;

		srcp += ystart*src_pitch;
		dstp += (ystart-6)*dst_pitch-128;
		NNPixels+=(ystart-6)*NNPixels_pitch;

		const uint8_t *src3p = srcp-src_pitch*3;
		int *lcount = pss->lcount[b]-6;

		if (pscrn==1) // original
		{
			for (int y=ystart; y<ystop; y+=2)
			{
				const uint8_t *src0=src3p-20;

				for (int x=32; x<width_32; x++)
				{
					uc2s(src0+(x<<2),src_pitch,input);
					computeNetwork0(input,weights0,NNPixels+x);
				}
				lcount[y] += processLine0(NNPixels+32,width_64,dstp+128,src3p+128,src_pitch);

				src3p += src_pitch2;
				dstp += dst_pitch2;
				NNPixels+=NNPixels_pitch_2;
			}
		}
		else // no prescreening
		{
			for (int y=ystart; y<ystop; y+=2)
			{
				memset(NNPixels,0,width);
				lcount[y]+=width_64;
				dstp+=dst_pitch2;
				NNPixels+=NNPixels_pitch_2;
			}
		}
	}
}


void extract_m8_C(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd, float *input)
{
	int sum = 0, sumsq = 0;
	const int stride2 = stride << 1;

	for (int y = 0; y<ydia; y++)
	{
		for (int x = 0; x<xdia; x++)
		{
			sum += srcp[x];
			sumsq += srcp[x]*srcp[x];
			input[x] = srcp[x];
		}

		srcp += stride2;
		input += xdia;
	}

	const float scale = (float)(1.0/(double)(xdia*ydia));

	mstd[0] = sum*scale;
	mstd[1] = sumsq*scale-mstd[0]*mstd[0];
	mstd[3] = 0.0f;
	if (mstd[1] <= FLT_EPSILON) mstd[1] = mstd[2] = 0.0f;
	else
	{
		mstd[1] = sqrtf(mstd[1]);
		mstd[2] = 1.0f/mstd[1];
	}
}


void extract_m8_i16_C(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *inputf)
{
	int16_t *input = (int16_t *)inputf;
	int sum = 0, sumsq = 0;
	const int stride2 = stride << 1;

	for (int y = 0; y<ydia; y++)
	{
		for (int x = 0; x<xdia; x++)
		{
			sum += srcp[x];
			sumsq += srcp[x]*srcp[x];
			input[x] = srcp[x];
		}

		srcp += stride2;
		input += xdia;
	}

	const float scale = (float)(1.0/(double)(xdia*ydia));

	mstd[0] = sum*scale;
	mstd[1] = sumsq*scale-mstd[0]*mstd[0];
	mstd[3] = 0.0f;
	if (mstd[1] <= FLT_EPSILON) mstd[1] = mstd[2] = 0.0f;
	else
	{
		mstd[1] = sqrtf(mstd[1]);
		mstd[2] = 1.0f/mstd[1];
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
	for (int i=0; i<n; i++)
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
	for (int q=0; q<n; q++)
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
	for (int i=0; i<n; i++)
		s[i] = expf(max(min(s[i],exp_hi[0]),exp_lo[0]));
}


__declspec(align(16)) const float min_weight_sum[4] = { 1e-10f, 1e-10f, 1e-10f, 1e-10f };

void weightedAvgElliottMul5_m16_C(const float *w,const int n,float *mstd)
{
	float vsum = 0.0f, wsum = 0.0f;

	for (int i=0; i<n; i++)
	{
		vsum+=w[i]*(w[n+i]/(1.0f+fabsf(w[n+i])));
		wsum+=w[i];
	}
	if (wsum>min_weight_sum[0]) mstd[3]+=((5.0f*vsum)/wsum)*mstd[1]+mstd[0];
	else mstd[3]+=mstd[0];
}


void evalFunc_2(void *ps)
{
	PS_INFO *pss = (PS_INFO *)ps;
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
	const bool int16_predictor = pss->int16_predictor;
	const float scale = (float)(1.0/(double)qual);
	void (*extract)(const uint8_t*,const int,const int,const int,float*,float*);
	void (*dotProd)(const float*,const float*,float*,const int,const int,const float*);
	void (*expf)(float *,const int);
	void (*wae5)(const float*,const int,float*);

#ifdef AVX_BUILD_POSSIBLE
	if (opt==1) wae5=weightedAvgElliottMul5_m16_C;
	else
	{
		if (opt==6) wae5=weightedAvgElliottMul5_m16_FMA4;
		else
		{
			if (opt==5) wae5=weightedAvgElliottMul5_m16_FMA3;
			else
			{
				if (opt>=4) wae5=weightedAvgElliottMul5_m16_AVX2;
				else wae5=weightedAvgElliottMul5_m16_SSE2;
			}
		}
	}

	if (int16_predictor) // use int16 dot products
	{
		if (opt==1) extract=extract_m8_i16_C;
		else
		{
			if (opt>=4) extract=extract_m8_i16_AVX2;
			else extract=extract_m8_i16_SSE2;
		}
		if (opt==1) dotProd=dotProdS_C;
		else
		{
			if (opt>=4)
				dotProd= ((asize%48)!=0) ? dotProd_m32_m16_i16_AVX2 : dotProd_m48_m16_i16_AVX2;
			else dotProd= ((asize%48)!=0) ? dotProd_m32_m16_i16_SSE2 : dotProd_m48_m16_i16_SSE2;
		}
	}
	else // use float dot products
	{
		if (opt==1) extract=extract_m8_C;
		else
		{
			if (opt==6) extract=extract_m8_FMA4;
			else
			{
				if (opt==5) extract=extract_m8_FMA3;
				else
				{
					if (opt>=4) extract=extract_m8_AVX2;
					else extract=extract_m8_SSE2;
				}
			}
		}
		if (opt==1) dotProd=dotProd_C;
		else
		{
			if (opt==6)
				dotProd = ((asize%48)!=0) ? dotProd_m32_m16_FMA4 : dotProd_m48_m16_FMA4;
			else
			{
				if (opt==5)
					dotProd = ((asize%48)!=0) ? dotProd_m32_m16_FMA3 : dotProd_m48_m16_FMA3;
				else
				{
					if (opt>=4)
						dotProd = ((asize%48)!=0) ? dotProd_m32_m16_AVX2 : dotProd_m48_m16_AVX2;
					else dotProd = ((asize%48)!=0) ? dotProd_m32_m16_SSE2 : dotProd_m48_m16_SSE2;
				}
			}
		}
	}

	if ((fapprox&12)==0) // use slow exp
	{
		if (opt==1) expf=e2_m16_C;
		else
		{
			if (opt>=4) expf=e2_m16_AVX2;
			else expf=e2_m16_SSE2;
		}
	}
	else if ((fapprox&12)==4) // use faster exp
	{
		if (opt==1) expf=e1_m16_C;
		else
		{
			if (opt>=4) expf=e1_m16_AVX2;
			else expf=e1_m16_SSE2;
		}
	}
	else // use fastest exp
	{
		if (opt==1) expf=e0_m16_C;
		else
		{
			if (opt==6) expf=e0_m16_FMA4;
			else
			{
				if (opt==5) expf=e0_m16_FMA3;
				else
				{
					if (opt>=4) expf=e0_m16_AVX2;
					else expf=e0_m16_SSE2;
				}
			}
		}
	}
#else
	if (opt==1) wae5=weightedAvgElliottMul5_m16_C;
	else wae5=weightedAvgElliottMul5_m16_SSE2;

	if (int16_predictor) // use int16 dot products
	{
		if (opt==1) extract=extract_m8_i16_C;
		else extract=extract_m8_i16_SSE2;
		if (opt==1) dotProd=dotProdS_C;
		else dotProd= ((asize%48)!=0) ? dotProd_m32_m16_i16_SSE2 : dotProd_m48_m16_i16_SSE2;
	}
	else // use float dot products
	{
		if (opt==1) extract=extract_m8_C;
		else extract=extract_m8_SSE2;
		if (opt==1) dotProd=dotProd_C;
		else dotProd= ((asize%48)!=0) ? dotProd_m32_m16_SSE2 : dotProd_m48_m16_SSE2;
	}

	if ((fapprox&12)==0) // use slow exp
	{
		if (opt==1) expf=e2_m16_C;
		else expf=e2_m16_SSE2;
	}
	else if ((fapprox&12)==4) // use faster exp
	{
		if (opt==1) expf=e1_m16_C;
		else expf=e1_m16_SSE2;
	}
	else // use fastest exp
	{
		if (opt==1) expf=e0_m16_C;
		else expf=e0_m16_SSE2;
	}
#endif

	uint8_t b = pss->current_plane;

	if (((b==0) && pss->Y) || ((b==1) && pss->U) || ((b==2) && pss->V) || ((b==3) && pss->A))
	{
		uint8_t *NNPixels = pss->NNPixels[b];
		const int NNPixels_pitch = pss->NNPixels_pitch[b];
		const int NNPixels_pitch_2 = NNPixels_pitch << 1;
		const uint8_t range_mode=pss->plane_range[b];
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

		int32_t val_min,val_max;

		switch(range_mode)
		{
			case 1 :
				val_min=0; val_max=255;
				break;
			case 2 :
				val_min=16; val_max=235;
				break;
			case 3 :
				val_min=16; val_max=240;
				break;
			case 4 :
				val_min=16; val_max=255;
				break;
			default :
				val_min=0; val_max=255;
				break;
		}

		srcp += (ystart+6)*src_pitch;
		dstp += ystart*dst_pitch-32;
		NNPixels+=ystart*NNPixels_pitch;

		const uint8_t *srcpp = srcp-((ydia-1)*src_pitch+xdiad2m1);

		if (opt==1)
		{
			for (int y=ystart; y<ystop; y+=2)
			{
				for (int x=32; x<width_32; x++)
				{
					if (NNPixels[x]!=0) continue;

					float mstd[4];

					extract(srcpp+x,src_pitch,xdia,ydia,mstd,input);
					for (int i=0; i<qual; i++)
					{
						dotProd(input,weights1[i],temp,nns2,asize,mstd+2);
						expf(temp,nns);
						wae5(temp,nns,mstd);
					}
					dstp[x]=min(max((int)(mstd[3]*scale+0.5f),val_min),val_max);
				}
				srcpp += src_pitch2;
				dstp += dst_pitch2;
				NNPixels+=NNPixels_pitch_2;
			}
		}
		else
		{
#ifdef AVX_BUILD_POSSIBLE
			if (opt>=4)
			{
				for (int y=ystart; y<ystop; y+=2)
				{
					for (int x=32; x<width_32; x++)
					{
						if (NNPixels[x]!=0) continue;

						float mstd[4];

						extract(srcpp+x,src_pitch,xdia,ydia,mstd,input);
						for (int i=0; i<qual; i++)
						{
							dotProd(input,weights1[i],temp,nns2,asize,mstd+2);
							expf(temp,nns);
							wae5(temp,nns,mstd);
						}
						castScale_AVX2(mstd,&scale,dstp+x,val_min,val_max);
					}
					srcpp += src_pitch2;
					dstp += dst_pitch2;
					NNPixels+=NNPixels_pitch_2;
				}
			}
			else
#endif
			{
				for (int y=ystart; y<ystop; y+=2)
				{
					for (int x=32; x<width_32; x++)
					{
						if (NNPixels[x]!=0) continue;

						float mstd[4];

						extract(srcpp+x,src_pitch,xdia,ydia,mstd,input);
						for (int i=0; i<qual; i++)
						{
							dotProd(input,weights1[i],temp,nns2,asize,mstd+2);
							expf(temp,nns);
							wae5(temp,nns,mstd);
						}
						castScale_SSE(mstd,&scale,dstp+x,val_min,val_max);
					}
					srcpp += src_pitch2;
					dstp += dst_pitch2;
					NNPixels+=NNPixels_pitch_2;
				}
			}
		}
	}
}


void extract_m8_i16_C_16(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *inputf)
{
	uint16_t *input = (uint16_t *)inputf;
	int64_t sum = 0, sumsq = 0;
	const int stride2 = stride << 1;
	const int xdia2 = xdia << 1;

	for (int y=0; y<ydia; y++)
	{
		const uint16_t *srcpT = (uint16_t *)srcp;

		memcpy(input,srcpT,xdia2);

		for (int x=0; x<xdia; x++)
		{
			sum += srcpT[x];
			sumsq += (uint32_t)srcpT[x]*(uint32_t)srcpT[x];
		}
		srcp += stride2;
		input += xdia;
	}

	const float scale=(float)(1.0/(double)(xdia*ydia));

	mstd[0] = sum*scale;
	const double tmp =(double)sumsq*scale-(double)mstd[0]*mstd[0];
	mstd[3] = 0.0f;
	if (tmp <= FLT_EPSILON) mstd[1] = mstd[2] = 0.0f;
	else
	{
		mstd[1] = (float)sqrt(tmp);
		mstd[2] = 1.0f/mstd[1];
	}
}


void extract_m8_i16_C_16_2(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *inputf)
{
	int64_t sumsq;
	int32_t sum;

	extract_m8_i16_SSE2_16_2(srcp,stride,xdia,ydia,inputf,&sum,&sumsq);

	const float scale = (float)(1.0/(double)(xdia*ydia));

	mstd[0] = sum*scale;
	const double tmp = (double)sumsq*scale-(double)mstd[0]*mstd[0];
	mstd[3] = 0.0f;
	if (tmp<=FLT_EPSILON) mstd[1] = mstd[2] = 0.0f;
	else
	{
		mstd[1] = (float)sqrt(tmp);
		mstd[2] = 1.0f/mstd[1];
	}
}


#ifdef AVX_BUILD_POSSIBLE
void extract_m8_i16_C_16_3(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *inputf)
{
	int64_t sumsq;
	int32_t sum;

	extract_m8_i16_AVX2_16_2(srcp,stride,xdia,ydia,inputf,&sum,&sumsq);

	const float scale = (float)(1.0/(double)(xdia*ydia));

	mstd[0] = sum*scale;
	const double tmp = (double)sumsq*scale-(double)mstd[0]*mstd[0];
	mstd[3] = 0.0f;
	if (tmp<=FLT_EPSILON) mstd[1] = mstd[2] = 0.0f;
	else
	{
		mstd[1] = (float)sqrt(tmp);
		mstd[2] = 1.0f/mstd[1];
	}
}
#endif

void extract_m8_C_16(const uint8_t *srcp,const int stride,const int xdia,const int ydia,float *mstd,float *input)
{
	int64_t sum = 0, sumsq = 0;
	const int stride2 = stride << 1;

	for (int y=0; y<ydia; y++)
	{
		const uint16_t *srcpT = (uint16_t *)srcp;

		for (int x=0; x<xdia; x++)
		{
			sum += srcpT[x];
			sumsq += (uint32_t)srcpT[x]*(uint32_t)srcpT[x];
			input[x] = srcpT[x];
		}
		input += xdia;
		srcp += stride2;
	}

	const float scale = (float)(1.0/(double)(xdia*ydia));

	mstd[0] = sum*scale;
	const double tmp=(double)sumsq*scale-(double)mstd[0]*mstd[0];
	mstd[3] = 0.0f;
	if (tmp <= FLT_EPSILON) mstd[1] = mstd[2] = 0.0f;
	else
	{
		mstd[1] = (float)sqrt(tmp);
		mstd[2] = 1.0f/mstd[1];
	}
}


void evalFunc_2_16(void *ps)
{
	PS_INFO *pss = (PS_INFO *)ps;
	float *input = pss->input;
	float *temp = pss->temp;
	float **weights1 = pss->weights1;
	const int opt = pss->opt;
	const int qual = pss->qual;
	const int asize = pss->asize;
	const int nns = pss->nns;
	const int nns2 = nns << 1;
	const int xdia = pss->xdia;
	const int xdiad2m1 = (xdia >> 1) - 1;
	const int ydia = pss->ydia;
	const int fapprox = pss->fapprox;
	const bool int16_predictor = pss->int16_predictor;
	const float scale = (float)(1.0/(double)qual);
	const uint8_t bits_per_pixel = pss->bits_per_pixel;
	void(*extract)(const uint8_t*, const int, const int, const int, float*, float*);
	void(*dotProd)(const float*, const float*, float*, const int, const int, const float*);
	void(*expf)(float *, const int);
	void(*wae5)(const float*, const int, float*);

#ifdef AVX_BUILD_POSSIBLE
	if (opt==1) wae5=weightedAvgElliottMul5_m16_C;
	else
	{
		if (opt==6) wae5=weightedAvgElliottMul5_m16_FMA4;
		else
		{
			if (opt==5) wae5=weightedAvgElliottMul5_m16_FMA3;
			else
			{
				if (opt>=4) wae5=weightedAvgElliottMul5_m16_AVX2;
				else wae5=weightedAvgElliottMul5_m16_SSE2;
			}
		}
	}

	if (int16_predictor) // use int16 dot products
	{
		if (opt>=4)
		{
			if (bits_per_pixel<=10) extract=extract_m8_i16_AVX2_16;
			else extract=extract_m8_i16_C_16_3;
		}
		else
		{
			if (opt>=3)
			{
				if (bits_per_pixel<=10) extract=extract_m8_i16_SSE2_16;
				else extract=extract_m8_i16_C_16_2;
			}
			else
			{
				if ((opt>=2) && (bits_per_pixel<=10)) extract=extract_m8_i16_SSE2_16;
				else extract=extract_m8_i16_C_16;
			}
		}

		if ((opt==1) || (bits_per_pixel>14)) dotProd=dotProdS_C_16;
		else
		{
			if (opt>=4)
				dotProd= ((asize%48)!=0) ? dotProd_m32_m16_i16_AVX2 : dotProd_m48_m16_i16_AVX2;
			else dotProd= ((asize%48)!=0) ? dotProd_m32_m16_i16_SSE2 : dotProd_m48_m16_i16_SSE2;
		}
	}
	else // use float dot products
	{
		if (opt==1) extract=extract_m8_C_16;
		else
		{
			if (opt==6) extract=extract_m8_FMA4_16;
			else
			{
				if (opt==5) extract=extract_m8_FMA3_16;
				else
				{
					if (opt>=4) extract=extract_m8_AVX2_16;
					else extract=extract_m8_SSE2_16;
				}
			}
		}
		if (opt==1) dotProd = dotProd_C;
		else
		{
			if (opt==6)
				dotProd = ((asize%48)!=0) ? dotProd_m32_m16_FMA4 : dotProd_m48_m16_FMA4;
			else
			{
				if (opt==5)
					dotProd = ((asize%48)!=0) ? dotProd_m32_m16_FMA3 : dotProd_m48_m16_FMA3;
				else
				{
					if (opt>=4)
						dotProd = ((asize%48)!=0) ? dotProd_m32_m16_AVX2 : dotProd_m48_m16_AVX2;
					else dotProd = ((asize%48)!=0) ? dotProd_m32_m16_SSE2 : dotProd_m48_m16_SSE2;
				}
			}
		}
	}

	if ((fapprox & 12)==0) // use slow exp
	{
		if (opt==1) expf = e2_m16_C;
		else
		{
			if (opt>=4) expf = e2_m16_AVX2;
			else expf = e2_m16_SSE2;
		}
	}
	else if ((fapprox & 12)==4) // use faster exp
	{
		if (opt==1) expf = e1_m16_C;
		else
		{
			if (opt>=4) expf = e1_m16_AVX2;
			else expf = e1_m16_SSE2;
		}
	}
	else // use fastest exp
	{
		if (opt==1) expf=e0_m16_C;
		else
		{
			if (opt==6) expf=e0_m16_FMA4;
			else
			{
				if (opt==5) expf=e0_m16_FMA3;
				else
				{
					if (opt>=4) expf=e0_m16_AVX2;
					else expf=e0_m16_SSE2;
				}
			}
		}
	}
#else
	if (opt==1) wae5=weightedAvgElliottMul5_m16_C;
	else wae5=weightedAvgElliottMul5_m16_SSE2;

	if (int16_predictor) // use int16 dot products
	{
		if (opt>=3)
		{
			if (bits_per_pixel<=10) extract=extract_m8_i16_SSE2_16;
			else extract=extract_m8_i16_C_16_2;
		}
		else
		{
			if ((opt>=2) && (bits_per_pixel<=10)) extract=extract_m8_i16_SSE2_16;
			else extract=extract_m8_i16_C_16;
		}

		if ((opt==1) || (bits_per_pixel>14)) dotProd=dotProdS_C_16;
		else dotProd= ((asize%48)!=0) ? dotProd_m32_m16_i16_SSE2 : dotProd_m48_m16_i16_SSE2;
	}
	else // use float dot products
	{
		if (opt==1) extract=extract_m8_C_16;
		else extract=extract_m8_SSE2_16;
		if (opt==1) dotProd = dotProd_C;
		else dotProd = ((asize%48)!=0) ? dotProd_m32_m16_SSE2 : dotProd_m48_m16_SSE2;
	}

	if ((fapprox & 12)==0) // use slow exp
	{
		if (opt==1) expf = e2_m16_C;
		else expf = e2_m16_SSE2;
	}
	else if ((fapprox & 12)==4) // use faster exp
	{
		if (opt==1) expf = e1_m16_C;
		else expf = e1_m16_SSE2;
	}
	else // use fastest exp
	{
		if (opt==1) expf=e0_m16_C;
		else expf=e0_m16_SSE2;
	}
#endif

	uint8_t b = pss->current_plane;

	if (((b==0) && pss->Y) || ((b==1) && pss->U) || ((b==2) && pss->V) || ((b==3) && pss->A))
	{
		uint8_t *NNPixels = pss->NNPixels[b];
		const int NNPixels_pitch = pss->NNPixels_pitch[b];
		const int NNPixels_pitch_2 = NNPixels_pitch << 1;
		const uint8_t range_mode=pss->plane_range[b];
		const uint8_t *srcp = pss->srcp[b];
		const int src_pitch = pss->src_pitch[b];
		const int width = pss->width[b];
		uint8_t *dstp = pss->dstp[b];
		const int dst_pitch = pss->dst_pitch[b];
		const int ystart = pss->sheight2[b];
		const int ystop = pss->eheight2[b];
		const int src_pitch2 = src_pitch << 1;
		const int dst_pitch2 = dst_pitch << 1;
		const int width_32 = width - 32;

		int32_t val_min,val_max;

		switch(range_mode)
		{
			case 1 :
				val_min=0; val_max=(int32_t)(((int32_t)1 << bits_per_pixel) - 1);
				break;
			case 2 :
				val_min=(int32_t)((int32_t)16 << (bits_per_pixel-8)); val_max=(int32_t)((int32_t)235 << (bits_per_pixel-8));
				break;
			case 3 :
				val_min=(int32_t)((int32_t)16 << (bits_per_pixel-8)); val_max=(int32_t)((int32_t)240 << (bits_per_pixel-8));
				break;
			case 4 :
				val_min=(int32_t)((int32_t)16 << (bits_per_pixel-8)); val_max=(int32_t)(((int32_t)1 << bits_per_pixel) - 1);
				break;
			default :
				val_min=0; val_max=(int32_t)(((int32_t)1 << bits_per_pixel) - 1);
				break;
		}

		srcp += (ystart + 6)*src_pitch;
		dstp += ystart*dst_pitch-64;
		const uint8_t *srcpp = srcp-((ydia-1)*src_pitch+(xdiad2m1 << 1));
		NNPixels+=ystart*NNPixels_pitch;

		if (opt==1)
		{
			for (int y=ystart; y<ystop; y+=2)
			{
				uint16_t *dst0 = (uint16_t *)dstp;

				for (int x=32; x<width_32; x++)
				{
					if (NNPixels[x]!=0) continue;

					float mstd[4];

					extract(srcpp+(x<<1),src_pitch,xdia,ydia,mstd,input);
					for (int i=0; i<qual; i++)
					{
						dotProd(input,weights1[i],temp,nns2,asize,mstd+2);
						expf(temp,nns);
						wae5(temp,nns,mstd);
					}
					dst0[x]=min(max((int)(mstd[3]*scale+0.5f),val_min),val_max);
				}
				srcpp += src_pitch2;
				dstp += dst_pitch2;
				NNPixels+=NNPixels_pitch_2;
			}
		}
		else
		{
#ifdef AVX_BUILD_POSSIBLE
			if (opt>=4)
			{
				for (int y=ystart; y<ystop; y+=2)
				{
					for (int x=32; x<width_32; x++)
					{
						uint16_t *dst0 = (uint16_t *)dstp;

						if (NNPixels[x]!=0) continue;

						float mstd[4];

						extract(srcpp+(x<<1),src_pitch,xdia,ydia,mstd,input);
						for (int i=0; i<qual; i++)
						{
							dotProd(input,weights1[i],temp,nns2,asize,mstd+2);
							expf(temp,nns);
							wae5(temp,nns,mstd);
						}
						castScale_AVX2_16(mstd,&scale,dst0+x,val_min,val_max);
					}
					srcpp += src_pitch2;
					dstp += dst_pitch2;
					NNPixels+=NNPixels_pitch_2;
				}
			}
			else
#endif
			{
				for (int y=ystart; y<ystop; y+=2)
				{
					for (int x=32; x<width_32; x++)
					{
						uint16_t *dst0 = (uint16_t *)dstp;

						if (NNPixels[x]!=0) continue;

						float mstd[4];

						extract(srcpp+(x<<1),src_pitch,xdia,ydia,mstd,input);
						for (int i=0; i<qual; i++)
						{
							dotProd(input,weights1[i],temp,nns2,asize,mstd+2);
							expf(temp,nns);
							wae5(temp,nns,mstd);
						}
						castScale_SSE_16(mstd,&scale,dst0+x,val_min,val_max);
					}
					srcpp += src_pitch2;
					dstp += dst_pitch2;
					NNPixels+=NNPixels_pitch_2;
				}
			}
		}
	}
}


void extract_m8_C_32(const uint8_t *srcp, const int stride, const int xdia, const int ydia, float *mstd, float *input)
{
	float sum = 0, sumsq = 0;
	const int stride2 = stride << 1;
	const uint32_t xdia4 = xdia << 2;

	for (int y=0; y<ydia; y++)
	{
		const float *srcpT = (float *)srcp;

		memcpy(input,srcpT,xdia4);

		for (int x=0; x<xdia; x++)
		{
			sum += srcpT[x];
			sumsq += srcpT[x]*srcpT[x];
		}
		input += xdia;
		srcp += stride2;
	}

	const float scale = (float)(1.0/(double)(xdia*ydia));

	mstd[0] = sum*scale;
	mstd[1] = sumsq*scale-mstd[0]*mstd[0];
	mstd[3] = 0.0f;
	if (mstd[1] <= FLT_EPSILON) mstd[1] = mstd[2] = 0.0f;
	else
	{
		mstd[1] = (float)sqrtf(mstd[1]);
		mstd[2] = 1.0f/mstd[1];
	}
}


void evalFunc_2_32(void *ps)
{
	PS_INFO *pss = (PS_INFO *)ps;
	float *input = pss->input;
	float *temp = pss->temp;
	float **weights1 = pss->weights1;
	const int opt = pss->opt;
	const int qual = pss->qual;
	const int asize = pss->asize;
	const int nns = pss->nns;
	const int nns2 = nns << 1;
	const int xdia = pss->xdia;
	const int xdiad2m1 = (xdia >> 1) - 1;
	const int ydia = pss->ydia;
	const int fapprox = pss->fapprox;
	const float scale = (float)(1.0/(double)qual);
	void(*extract)(const uint8_t*, const int, const int, const int, float*, float*);
	void(*dotProd)(const float*, const float*, float*, const int, const int, const float*);
	void(*expf)(float *, const int);
	void(*wae5)(const float*, const int, float*);

#ifdef AVX_BUILD_POSSIBLE
	if (opt==1) wae5=weightedAvgElliottMul5_m16_C;
	else
	{
		if (opt==6) wae5=weightedAvgElliottMul5_m16_FMA4;
		else
		{
			if (opt==5) wae5=weightedAvgElliottMul5_m16_FMA3;
			else
			{
				if (opt>=4) wae5=weightedAvgElliottMul5_m16_AVX2;
				else wae5=weightedAvgElliottMul5_m16_SSE2;
			}
		}
	}

	if (opt==1) extract=extract_m8_C_32;
	else
	{
		if (opt==6) extract=extract_m8_FMA4_32;
		else
		{
			if (opt==5) extract=extract_m8_FMA3_32;
			else
			{
				if (opt>=4) extract=extract_m8_AVX2_32;
				else extract=extract_m8_SSE2_32;
			}
		}
	}

	if (opt==1) dotProd = dotProd_C;
	else
	{
		if (opt==6)
			dotProd = ((asize%48)!=0) ? dotProd_m32_m16_FMA4 : dotProd_m48_m16_FMA4;
		else
		{
			if (opt==5)
				dotProd = ((asize%48)!=0) ? dotProd_m32_m16_FMA3 : dotProd_m48_m16_FMA3;
			else
			{
				if (opt>=4)
					dotProd = ((asize%48)!=0) ? dotProd_m32_m16_AVX2 : dotProd_m48_m16_AVX2;
				else dotProd = ((asize%48)!=0) ? dotProd_m32_m16_SSE2 : dotProd_m48_m16_SSE2;
			}
		}
	}

	if ((fapprox & 12)==0) // use slow exp
	{
		if (opt==1) expf = e2_m16_C;
		else
		{
			if (opt>=4) expf = e2_m16_AVX2;
			else expf = e2_m16_SSE2;
		}
	}
	else if ((fapprox & 12)==4) // use faster exp
	{
		if (opt==1) expf = e1_m16_C;
		else
		{
			if (opt>=4) expf = e1_m16_AVX2;
			else expf = e1_m16_SSE2;
		}
	}
	else // use fastest exp
	{
		if (opt==1) expf=e0_m16_C;
		else
		{
			if (opt==6) expf=e0_m16_FMA4;
			else
			{
				if (opt==5) expf=e0_m16_FMA3;
				else
				{
					if (opt>=4) expf=e0_m16_AVX2;
					else expf=e0_m16_SSE2;
				}
			}
		}
	}
#else
	if (opt==1) wae5=weightedAvgElliottMul5_m16_C;
	else wae5=weightedAvgElliottMul5_m16_SSE2;

	if (opt==1) extract=extract_m8_C_32;
	else extract=extract_m8_SSE2_32;

	if (opt==1) dotProd = dotProd_C;
	else dotProd = ((asize%48)!=0) ? dotProd_m32_m16_SSE2 : dotProd_m48_m16_SSE2;

	if ((fapprox & 12)==0) // use slow exp
	{
		if (opt==1) expf = e2_m16_C;
		else expf = e2_m16_SSE2;
	}
	else if ((fapprox & 12)==4) // use faster exp
	{
		if (opt==1) expf = e1_m16_C;
		else expf = e1_m16_SSE2;
	}
	else // use fastest exp
	{
		if (opt==1) expf=e0_m16_C;
		else expf=e0_m16_SSE2;
	}
#endif

	uint8_t b = pss->current_plane;

	if (((b==0) && pss->Y) || ((b==1) && pss->U) || ((b==2) && pss->V) || ((b==3) && pss->A))
	{
		uint8_t *NNPixels = pss->NNPixels[b];
		const int NNPixels_pitch = pss->NNPixels_pitch[b];
		const int NNPixels_pitch_2 = NNPixels_pitch << 1;
		const uint8_t *srcp = pss->srcp[b];
		const int src_pitch = pss->src_pitch[b];
		const int width = pss->width[b];
		uint8_t *dstp = pss->dstp[b];
		const int dst_pitch = pss->dst_pitch[b];
		const int ystart = pss->sheight2[b];
		const int ystop = pss->eheight2[b];
		const int src_pitch2 = src_pitch << 1;
		const int dst_pitch2 = dst_pitch << 1;
		const int width_32 = width-32;

		srcp += (ystart+6)*src_pitch;
		dstp += ystart*dst_pitch-128;
		NNPixels+=ystart*NNPixels_pitch;

		const uint8_t *srcpp = srcp-((ydia-1)*src_pitch+(xdiad2m1<<2));

		for (int y=ystart; y<ystop; y+=2)
		{
			float *dst0 = (float *)dstp;

			for (int x=32; x<width_32; x++)
			{
				if (NNPixels[x]!=0) continue;

				float mstd[4];

				extract(srcpp+(x<<2),src_pitch,xdia,ydia,mstd,input);
				for (int i=0; i<qual; i++)
				{
					dotProd(input,weights1[i],temp,nns2,asize,mstd+2);
					expf(temp,nns);
					wae5(temp,nns,mstd);
				}
				dst0[x]=mstd[3]*scale;
			}
			srcpp += src_pitch2;
			dstp += dst_pitch2;
			NNPixels+=NNPixels_pitch_2;
		}
	}
}


void nnedi3::StaticThreadpool(void *ptr)
{
	const Public_MT_Data_Thread *data=(const Public_MT_Data_Thread *)ptr;
	nnedi3 *ptrClass=(nnedi3 *)data->pClass;
	void *ps = &(ptrClass->pssInfo[data->thread_Id]);
	
	switch(data->f_process)
	{
		case 1 : evalFunc_1(ps);
			break;
		case 2 : evalFunc_2(ps);
			break;
		case 3 : evalFunc_1_16(ps);
			break;
		case 4 : evalFunc_2_16(ps);
			break;
		case 5 : evalFunc_1_32(ps);
			break;
		case 6 : evalFunc_2_32(ps);
			break;
		default : ;
	}
}


AVSValue __cdecl Create_nnedi3(AVSValue args, void* user_data, IScriptEnvironment* env)
{
	if (!args[0].IsClip())
		env->ThrowError("nnedi3: arg 0 must be a clip!");
	VideoInfo vi = args[0].AsClip()->GetVideoInfo();
	
  const bool avsp=env->FunctionExists("ConvertBits");
  const bool RGB32=vi.IsRGB32();
  const bool RGB48=vi.IsRGB48();
  const bool RGB64=vi.IsRGB64();

	if (avsp)
	{
		if (!vi.IsPlanar() && !vi.IsYUY2() && !vi.IsRGB24() && !RGB32 && !RGB48 && !RGB64)
			env->ThrowError("nnedi3: only planar, YUY2, RGB64, RGB48, RGB32 and RGB24 input are supported!");				
	}
	else
	{
		if (!vi.IsPlanar() && !vi.IsYUY2() && !vi.IsRGB24())
			env->ThrowError("nnedi3: only planar, YUY2 and RGB24 input are supported!");				
	}

	int prefetch = args[18].AsInt(0);
	if (prefetch == 0) prefetch = 1;
	if ((prefetch<0) || (prefetch>MAX_THREAD_POOL)) env->ThrowError("ResizeMT: [prefetch] must be between 0 and %d.", MAX_THREAD_POOL);
			
	const bool dh = args[2].AsBool(false);
	if ((vi.height&1) && !dh)
		env->ThrowError("nnedi3: height must be mod 2 when dh=false (%d)!", vi.height);

	if (!poolInterface->CreatePool(prefetch)) env->ThrowError("nnedi3: Unable to create ThreadPool!");

	if (!vi.IsY8())
	{
		if (RGB32 || RGB48 || RGB64)
		{
			AVSValue v=args[0].AsClip();
			
			if (RGB32 || RGB64) v=env->Invoke("ConvertToPlanarRGBA",v).AsClip();
			else v=env->Invoke("ConvertToPlanarRGB",v).AsClip();
			v= new nnedi3(v.AsClip(),args[1].AsInt(-1),args[2].AsBool(false),
				args[3].AsBool(true),args[4].AsBool(true),args[5].AsBool(true),args[17].AsBool(true),
				args[6].AsInt(6),args[7].AsInt(1),args[8].AsInt(1),args[9].AsInt(0),
				args[10].AsInt(2),args[11].AsInt(0),args[12].AsInt(0),args[13].AsInt(15),
				args[14].AsBool(true),args[15].AsBool(true),args[16].AsBool(false),args[17].AsBool(false),
				args[19].AsInt(1),avsp,env);
			if (RGB32) return env->Invoke("ConvertToRGB32",v).AsClip();
			else
			{
				if (RGB48) return env->Invoke("ConvertToRGB48",v).AsClip();
				else return env->Invoke("ConvertToRGB64",v).AsClip();
			}
		}
		else return new nnedi3(args[0].AsClip(),args[1].AsInt(-1),args[2].AsBool(false),
				args[3].AsBool(true),args[4].AsBool(true),args[5].AsBool(true),args[17].AsBool(true),
				args[6].AsInt(6),args[7].AsInt(1),args[8].AsInt(1),args[9].AsInt(0),
				args[10].AsInt(2),args[11].AsInt(0),args[12].AsInt(0),args[13].AsInt(15),
				args[14].AsBool(true),args[15].AsBool(true),args[16].AsBool(false),args[17].AsBool(false),
				args[19].AsInt(1),avsp,env);
			
	}
	else
		return new nnedi3(args[0].AsClip(),args[1].AsInt(-1),args[2].AsBool(false),
				args[3].AsBool(true),false,false,false,args[6].AsInt(6),args[7].AsInt(1),args[8].AsInt(1),
				args[9].AsInt(0),args[10].AsInt(2),args[11].AsInt(0),args[12].AsInt(0),
				args[13].AsInt(15),args[14].AsBool(true),args[15].AsBool(true),args[16].AsBool(false),args[17].AsBool(false),
				args[19].AsInt(1),avsp,env);
}


AVSValue __cdecl Create_nnedi3_rpow2(AVSValue args, void* user_data, IScriptEnvironment *env)
{
	if (!args[0].IsClip()) env->ThrowError("nnedi3_rpow2:  arg 0 must be a clip!");
	VideoInfo vi = args[0].AsClip()->GetVideoInfo();

  const bool avsp=env->FunctionExists("ConvertBits");  
  const bool RGB32=vi.IsRGB32();
  const bool RGB48=vi.IsRGB48();
  const bool RGB64=vi.IsRGB64();
  const bool RGB24=vi.IsRGB24();  
  const bool isRGBPfamily = vi.IsPlanarRGB() || vi.IsPlanarRGBA();
  const bool grey = vi.IsY();  
  const bool isAlphaChannel = vi.IsYUVA() || vi.IsPlanarRGBA();
	
	if (avsp)
	{
		if (!vi.IsPlanar() && !vi.IsYUY2() && !RGB24 && !RGB32 && !RGB48 && !RGB64)
			env->ThrowError("nnedi3: only planar, YUY2, RGB32, RGB48, RGB64 and RGB24 input are supported!");				
	}
	else
	{
		if (!vi.IsPlanar() && !vi.IsYUY2() && !RGB24)
			env->ThrowError("nnedi3: only planar, YUY2 and RGB24 input are supported!");				
	}
  
	if ((vi.IsYUY2() || vi.IsYV16()|| vi.IsYV12() || vi.IsYV411()) && (vi.width&3))
		env->ThrowError("nnedi3_rpow2: for YV12, YV411, YUY2 and YV16 input width must be mod 4 (%d)!", vi.width);
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
	const bool chroma_shift_resize = args[15].AsBool(true);
	const bool mpeg2_chroma = args[16].AsBool(true);
	const bool LogicalCores = args[17].AsBool(true);
	const bool MaxPhysCores = args[18].AsBool(true);
	const bool SetAffinity = args[19].AsBool(false);
	const int threads_rs = args[20].AsInt(0);
	const bool LogicalCores_rs = args[21].AsBool(true);
	const bool MaxPhysCores_rs = args[22].AsBool(true);
	const bool SetAffinity_rs = args[23].AsBool(false);
	const bool sleep = args[24].AsBool(false);
	int prefetch = args[25].AsInt(0);
	int range_mode = args[26].AsInt(1);

	if ((rfactor<2) || (rfactor>1024)) env->ThrowError("nnedi3_rpow2: 2 <= rfactor <= 1024, and rfactor be a power of 2!\n");
	int rf=1,ct=0;

	while (rf<rfactor)
	{
		rf*=2;
		ct++;
	}

	if (rf!=rfactor)
		env->ThrowError("nnedi3_rpow2: 2 <= rfactor <= 1024, and rfactor be a power of 2!\n");
	if (nsize < 0 || nsize >= NUM_NSIZE)
		env->ThrowError("nnedi3_rpow2: nsize must be in [0,%d]!\n", NUM_NSIZE-1);
	if (nns < 0 || nns >= NUM_NNS)
		env->ThrowError("nnedi3_rpow2: nns must be in [0,%d]!\n", NUM_NNS-1);
	if (qual < 1 || qual > 2)
		env->ThrowError("nnedi3_rpow2: qual must be set to 1 or 2!\n");
	if (threads < 0 || threads > MAX_MT_THREADS)
		env->ThrowError("nnedi3_rpow2: 0 <= threads <= %d!\n",MAX_MT_THREADS);
	if (threads_rs < 0 || threads_rs > MAX_MT_THREADS)
		env->ThrowError("nnedi3_rpow2: 0 <= threads_rs <= %d!\n",MAX_MT_THREADS);
	if (opt < 0 || opt > 6)
		env->ThrowError("nnedi3_rpow2: opt must be in [0,6]!\n");
	if (fapprox < 0 || fapprox > 15)
		env->ThrowError("nnedi3_rpow2: fapprox must be [0,15]!\n");

	if ((range_mode<0) || (range_mode>4)) env->ThrowError("nnedi3_rpow2: [range] must be between 0 and 4!");

	if (prefetch==0) prefetch=1;
	if ((prefetch<0) || (prefetch>MAX_THREAD_POOL)) env->ThrowError("nnedi3_rpow2: [prefetch] must be between 0 and %d.", MAX_THREAD_POOL);

	if (!poolInterface->CreatePool(prefetch)) env->ThrowError("nnedi3_rpow2: Unable to create ThreadPool!");

	AVSValue v = args[0].AsClip();

	const bool FTurnL=(!avsp) && (env->FunctionExists("FTurnLeft") && ((env->GetCPUFlags() & CPUF_SSE2)!=0));
	const bool FTurnR=(!avsp) && (env->FunctionExists("FTurnRight") && ((env->GetCPUFlags() & CPUF_SSE2)!=0));
	const bool SplineMT=env->FunctionExists("Spline36ResizeMT");

	auto turnRightFunction = (FTurnR) ? "FTurnRight" : "TurnRight";
	auto turnLeftFunction =  (FTurnL) ? "FTurnLeft" : "TurnLeft";
	auto Spline36 = (SplineMT) ? "Spline36ResizeMT" : "Spline36Resize";

	uint8_t plane_range[PLANE_MAX];

	if ((range_mode!=1) && (range_mode!=4))
	{
		if (vi.IsYUV())
		{
			plane_range[0]=2;
			plane_range[1]=3;
			plane_range[2]=3;
		}
		else
		{
			if (grey)
			{
				for (uint8_t i=0; i<3; i++)
					plane_range[i]=(range_mode==0) ? 2 : range_mode;
			}
			else
			{
				for (uint8_t i=0; i<3; i++)
					plane_range[i]=1;
			}
		}
	}
	else
	{
		if (vi.IsRGB()) range_mode=1;

		for (uint8_t i=0; i<3; i++)
			plane_range[i]=range_mode;
	}
	plane_range[3]=1;
	range_mode=plane_range[0];

	try 
	{
		double Y_hshift=0.0,Y_vshift=0.0,C_hshift=0.0,C_vshift=0.0;

		const bool do_resize=(cshift[0]!=0) || vi.Is420();

		AVSValue vv,vu,va;

		if (RGB24 || vi.Is444() || vi.IsY() || RGB32 || RGB48 || RGB64 || isRGBPfamily)
		{
			Y_hshift = Y_vshift = -0.5;
		}
		else
		{
			Y_hshift = -0.5*(rf-1);
			Y_vshift = -0.5;

			C_hshift=Y_hshift;
			C_vshift=Y_vshift;

			if (vi.Is420())
			{
				// Correct chroma shift (it's always 1/2 pixel upwards).
				C_vshift-=0.5;

				C_vshift/=2.0;
				C_hshift/=2.0;

				C_hshift-=0.25*(rf-1);

				// Correct resize chroma position if YV12 has MPEG2 chroma subsampling
				if (chroma_shift_resize && mpeg2_chroma && (fwidth!=vi.width))
					C_hshift+=0.25*rf*(1.0-(double)vi.width/(double)fwidth);
			}
			else
			{
				if (vi.IsYV411())
				{
					C_hshift/=4.0;
					C_hshift-=0.375*(rf-1);

				// Correct resize chroma position
				if (chroma_shift_resize && (fwidth!=vi.width))
					C_hshift+=0.375*rf*(1.0-(double)vi.width/(double)fwidth);
				}
				else
				{
					C_hshift/=2.0;
					C_hshift-=0.25*(rf-1);

					//YV16 always has MPEG2 chroma subsampling
					if (chroma_shift_resize && (fwidth!=vi.width))
						C_hshift+=0.25*rf*(1.0-(double)vi.width/(double)fwidth);
				}
			}
		}

		if (RGB24 || vi.Is444() || vi.IsY() || RGB32 || RGB48 || RGB64 || isRGBPfamily)
		{
			if (RGB24 || RGB48)
			{
				if (avsp) v=env->Invoke("ConvertToPlanarRGB",v).AsClip();
				else
				{
					AVSValue sargs[3] = {v,"Y8",0};
					
					vu=env->Invoke("ShowRed",AVSValue(sargs,2)).AsClip();
					vv=env->Invoke("ShowGreen",AVSValue(sargs,2)).AsClip();
					v=env->Invoke("ShowBlue",AVSValue(sargs,2)).AsClip();
					sargs[0]=vu; sargs[1]=vv; sargs[2]=v;
					v=env->Invoke("Interleave",AVSValue(sargs,3)).AsClip();
				}					
			}
			
			if (RGB32 || RGB64) v=env->Invoke("ConvertToPlanarRGBA",v).AsClip();

			const bool UV_process=!(vi.IsY() || (RGB24 && !avsp));

			const int range_=(do_resize) ? 1 : range_mode;

			for (int i=0; i<ct; i++)
			{
				v = env->Invoke(turnRightFunction,v).AsClip();
				v = new nnedi3(v.AsClip(),i==0?1:0,true,true,UV_process,UV_process,isAlphaChannel || RGB32,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,LogicalCores,MaxPhysCores,SetAffinity,sleep,1,avsp,env);
				v = env->Invoke(turnLeftFunction,v).AsClip();
				v = new nnedi3(v.AsClip(),i==0?1:0,true,true,UV_process,UV_process,isAlphaChannel || RGB32,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,LogicalCores,MaxPhysCores,SetAffinity,sleep,(i==(ct-1))?range_:1,avsp,env);
			}
		}
		else
		{
			if (avsp && !vi.IsYUY2())
			{
				AVSValue sargs[2] = {v,"U"};
				
				vu=env->Invoke("PlaneToY",AVSValue(sargs,2)).AsClip();
				sargs[1]="V";				
				vv=env->Invoke("PlaneToY",AVSValue(sargs,2)).AsClip();
				if (isAlphaChannel)
				{
					sargs[1]="A";
					va=env->Invoke("PlaneToY",AVSValue(sargs,2)).AsClip();					
				}
				sargs[1]="Y";
				v=env->Invoke("PlaneToY",AVSValue(sargs,2)).AsClip();				
			}
			else
			{
				vu = env->Invoke("UtoY8",v).AsClip();
				vv = env->Invoke("VtoY8",v).AsClip();
				v = env->Invoke("ConvertToY8",v).AsClip();				
			}

			int range_=(do_resize) ? 1 : plane_range[0];

			for (int i=0; i<ct; i++)
			{
				v = env->Invoke(turnRightFunction,v).AsClip();
				// always use field=1 to keep chroma/luma horizontal alignment
				v = new nnedi3(v.AsClip(),1,true,true,false,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,LogicalCores,MaxPhysCores,SetAffinity,sleep,1,avsp,env);
				v = env->Invoke(turnLeftFunction,v).AsClip();
				v = new nnedi3(v.AsClip(),i==0?1:0,true,true,false,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,LogicalCores,MaxPhysCores,SetAffinity,sleep,(i==(ct-1))?range_:1,avsp,env);
			}

			range_=(do_resize) ? 1 : plane_range[1];
			for (int i=0; i<ct; i++)
			{
				vu = env->Invoke(turnRightFunction,vu).AsClip();
				// always use field=1 to keep chroma/luma horizontal alignment
				vu = new nnedi3(vu.AsClip(),1,true,true,false,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,LogicalCores,MaxPhysCores,SetAffinity,sleep,1,avsp,env);
				vu = env->Invoke(turnLeftFunction,vu).AsClip();
				vu = new nnedi3(vu.AsClip(),i==0?1:0,true,true,false,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,LogicalCores,MaxPhysCores,SetAffinity,sleep,(i==(ct-1))?range_:1,avsp,env);
			}

			range_=(do_resize) ? 1 : plane_range[2];
			for (int i=0; i<ct; i++)
			{
				vv = env->Invoke(turnRightFunction,vv).AsClip();
				// always use field=1 to keep chroma/luma horizontal alignment
				vv = new nnedi3(vv.AsClip(),1,true,true,false,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,LogicalCores,MaxPhysCores,SetAffinity,sleep,1,avsp,env);
				vv = env->Invoke(turnLeftFunction,vv).AsClip();
				vv = new nnedi3(vv.AsClip(),i==0?1:0,true,true,false,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,LogicalCores,MaxPhysCores,SetAffinity,sleep,(i==(ct-1))?range_:1,avsp,env);
			}

			range_=(do_resize) ? 1 : plane_range[3];
			if (isAlphaChannel)
			{
				for (int i=0; i<ct; i++)
				{
					va = env->Invoke(turnRightFunction,va).AsClip();
					// always use field=1 to keep chroma/luma horizontal alignment
					va = new nnedi3(va.AsClip(),1,true,true,false,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,LogicalCores,MaxPhysCores,SetAffinity,sleep,1,avsp,env);
					va = env->Invoke(turnLeftFunction,va).AsClip();
					va = new nnedi3(va.AsClip(),i==0?1:0,true,true,false,false,false,nsize,nns,qual,etype,pscrn,threads,opt,fapprox,LogicalCores,MaxPhysCores,SetAffinity,sleep,(i==(ct-1))?range_:1,avsp,env);
				}				
			}
		}

		if (cshift[0]!=0)
		{
			const bool use_rs_mt=((_strnicmp(cshift,"pointresizemt",13)==0) || (_strnicmp(cshift,"bilinearresizemt",16)==0)
				|| (_strnicmp(cshift,"bicubicresizemt",15)==0) || (_strnicmp(cshift,"lanczosresizemt",15)==0)
				|| (_strnicmp(cshift,"lanczos4resizemt",16)==0) || (_strnicmp(cshift,"blackmanresizemt",16)==0)
				|| (_strnicmp(cshift,"spline16resizemt",16)==0) || (_strnicmp(cshift,"spline36resizemt",16)==0)
				|| (_strnicmp(cshift,"spline64resizemt",16)==0) || (_strnicmp(cshift,"gaussresizemt",13)==0)
				|| (_strnicmp(cshift,"sincresizemt",12)==0));

			int type = 0;
			
			if ((_strnicmp(cshift,"blackmanresize",14)==0) || (_strnicmp(cshift,"lanczosresize",13)==0)
				|| (_strnicmp(cshift,"sincresize",10)==0)) type=1;
			else
			{
				if (_strnicmp(cshift,"gaussresize",11)==0) type=2;
				else
				{
					if (_strnicmp(cshift,"bicubicresize",13)==0) type=3;
				}
			}
			
			if ((type==0) || ((type!=3) && (ep0==-FLT_MAX)) ||
				((type==3) && (ep0==-FLT_MAX) && (ep1==-FLT_MAX)))
			{
				AVSValue sargs[14] = { v, fwidth, fheight, Y_hshift, Y_vshift, 
					vi.width*rfactor, vi.height*rfactor,threads_rs,LogicalCores_rs,MaxPhysCores_rs,SetAffinity_rs,sleep,
					prefetch,range_mode };
				const char *nargs[14] = { 0, 0, 0, "src_left", "src_top", 
					"src_width", "src_height","threads","logicalCores","MaxPhysCore","SetAffinity","sleep","prefetch","range" };
				const uint8_t nbarg=(use_rs_mt) ? 14:7;

				v=env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();

				if (!(RGB24 || vi.Is444() || vi.IsY() || RGB32 || RGB48 || RGB64 || isRGBPfamily))
				{
					if (isAlphaChannel)
					{
						sargs[0]=va;
						sargs[13]=plane_range[3];
						va=env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();
					}
					
					sargs[3]=C_hshift;
					sargs[4]=C_vshift;

					if (vi.Is420())
					{
						sargs[1]=fwidth >> 1;
						sargs[2]=fheight >> 1;
						sargs[5]=(vi.width*rfactor) >> 1;
						sargs[6]=(vi.height*rfactor) >> 1;
					}
					else
					{
						if (vi.IsYV411())
						{
							sargs[1]=fwidth >> 2;
							sargs[5]=(vi.width*rfactor) >> 2;
						}
						else
						{
							sargs[1]=fwidth >> 1;
							sargs[5]=(vi.width*rfactor) >> 1;
						}
					}

					sargs[0]=vu;
					sargs[13]=plane_range[1];
					vu = env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();
					sargs[0]=vv;
					sargs[13]=plane_range[2];
					vv = env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();

					AVSValue ytouvargs[4] = {vu,vv,v,va};
					if (isAlphaChannel) v=env->Invoke("YtoUV",AVSValue(ytouvargs,4)).AsClip();
					else v=env->Invoke("YtoUV",AVSValue(ytouvargs,3)).AsClip();

					if (vi.IsYUY2()) v=env->Invoke("ConvertToYUY2",v).AsClip();
				}
				else
				{
					if (RGB24)
					{
						if (avsp) v=env->Invoke("ConvertToRGB24",v).AsClip();
						else
						{
							sargs[0]=v; sargs[1]=3;
							sargs[2]=0;
							vu=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
							sargs[2]=1;
							vv=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
							sargs[2]=2;
							v=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
							sargs[0]=vu; sargs[1]=vv; sargs[2]=v; sargs[3]="RGB24";
							v=env->Invoke("MergeRGB",AVSValue(sargs,4)).AsClip();							
						}
					}
					if (RGB32) v=env->Invoke("ConvertToRGB32",v).AsClip();
					if (RGB48) v=env->Invoke("ConvertToRGB48",v).AsClip();
					if (RGB64) v=env->Invoke("ConvertToRGB64",v).AsClip();
				}
			}
			else if ((type!=3) || (min(ep0,ep1)==-FLT_MAX))
			{
				AVSValue sargs[15] = { v, fwidth, fheight, Y_hshift, Y_vshift, 
					vi.width*rfactor, vi.height*rfactor, type==1?AVSValue((int)(ep0+0.5f)):
					(type==2?ep0:max(ep0,ep1)),threads_rs,LogicalCores_rs,MaxPhysCores_rs,SetAffinity_rs,sleep,prefetch,range_mode };
				const char *nargs[15] = { 0, 0, 0, "src_left", "src_top", 
					"src_width", "src_height", type==1?"taps":(type==2?"p":(max(ep0,ep1)==ep0?"b":"c")),
					"threads","logicalCores","MaxPhysCore","SetAffinity","sleep","prefetch","range" };
				const uint8_t nbarg=(use_rs_mt) ? 15:8;

				v=env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();

				if (!(RGB24 || vi.Is444() || vi.IsY() || RGB32 || RGB48 || RGB64 || isRGBPfamily))
				{
					if (isAlphaChannel)
					{
						sargs[0]=va;
						sargs[14]=plane_range[3];
						va=env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();
					}
					
					sargs[3]=C_hshift;
					sargs[4]=C_vshift;

					if (vi.Is420())
					{
						sargs[1]=fwidth >> 1;
						sargs[2]=fheight >> 1;
						sargs[5]=(vi.width*rfactor) >> 1;
						sargs[6]=(vi.height*rfactor) >> 1;
					}
					else
					{
						if (vi.IsYV411())
						{
							sargs[1]=fwidth >> 2;
							sargs[5]=(vi.width*rfactor) >> 2;
						}
						else
						{
							sargs[1]=fwidth >> 1;
							sargs[5]=(vi.width*rfactor) >> 1;
						}
					}

					sargs[0]=vu;
					sargs[14]=plane_range[1];
					vu = env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();
					sargs[0]=vv;
					sargs[14]=plane_range[2];
					vv = env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();

					AVSValue ytouvargs[4] = {vu,vv,v,va};
					if (isAlphaChannel) v=env->Invoke("YtoUV",AVSValue(ytouvargs,4)).AsClip();
					else v=env->Invoke("YtoUV",AVSValue(ytouvargs,3)).AsClip();

					if (vi.IsYUY2()) v=env->Invoke("ConvertToYUY2",v).AsClip();
				}
				else
				{
					if (RGB24)
					{
						if (avsp) v=env->Invoke("ConvertToRGB24",v).AsClip();
						else
						{
							sargs[0]=v; sargs[1]=3;
							sargs[2]=0;
							vu=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
							sargs[2]=1;
							vv=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
							sargs[2]=2;
							v=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
							sargs[0]=vu; sargs[1]=vv; sargs[2]=v; sargs[3]="RGB24";
							v=env->Invoke("MergeRGB",AVSValue(sargs,4)).AsClip();							
						}
					}
					if (RGB32) v=env->Invoke("ConvertToRGB32",v).AsClip();
					if (RGB48) v=env->Invoke("ConvertToRGB48",v).AsClip();
					if (RGB64) v=env->Invoke("ConvertToRGB64",v).AsClip();
				}
			}
			else
			{
				AVSValue sargs[16] = { v, fwidth, fheight, Y_hshift, Y_vshift, 
					vi.width*rfactor, vi.height*rfactor, ep0, ep1,threads_rs,LogicalCores_rs,MaxPhysCores_rs,
					SetAffinity_rs,sleep,prefetch,range_mode };
				const char *nargs[16] = { 0, 0, 0, "src_left", "src_top", 
					"src_width", "src_height", "b", "c", "threads","logicalCores","MaxPhysCore","SetAffinity",
					"sleep","prefetch","range" };
				const uint8_t nbarg=(use_rs_mt) ? 16:9;

				v = env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();

				if (!(RGB24 || vi.Is444() || vi.IsY() || RGB32 || RGB48 || RGB64 || isRGBPfamily))
				{
					if (isAlphaChannel)
					{
						sargs[0]=va;
						sargs[15]=plane_range[3];
						va=env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();
					}
					
					sargs[3]=C_hshift;
					sargs[4]=C_vshift;

					if (vi.Is420())
					{
						sargs[1]=fwidth >> 1;
						sargs[2]=fheight >> 1;
						sargs[5]=(vi.width*rfactor) >> 1;
						sargs[6]=(vi.height*rfactor) >> 1;
					}
					else
					{
						if (vi.IsYV411())
						{
							sargs[1]=fwidth >> 2;
							sargs[5]=(vi.width*rfactor) >> 2;
						}
						else
						{
							sargs[1]=fwidth >> 1;
							sargs[5]=(vi.width*rfactor) >> 1;
						}
					}

					sargs[0]=vu;
					sargs[15]=plane_range[1];
					vu = env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();
					sargs[0]=vv;
					sargs[15]=plane_range[2];
					vv = env->Invoke(cshift,AVSValue(sargs,nbarg),nargs).AsClip();

					AVSValue ytouvargs[4] = {vu,vv,v,va};
					if (isAlphaChannel) v=env->Invoke("YtoUV",AVSValue(ytouvargs,4)).AsClip();
					else v=env->Invoke("YtoUV",AVSValue(ytouvargs,3)).AsClip();

					if (vi.IsYUY2()) v=env->Invoke("ConvertToYUY2",v).AsClip();
				}
				else
				{
					if (RGB24)
					{
						if (avsp) v=env->Invoke("ConvertToRGB24",v).AsClip();
						else
						{
							sargs[0]=v; sargs[1]=3;
							sargs[2]=0;
							vu=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
							sargs[2]=1;
							vv=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
							sargs[2]=2;
							v=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
							sargs[0]=vu; sargs[1]=vv; sargs[2]=v; sargs[3]="RGB24";
							v=env->Invoke("MergeRGB",AVSValue(sargs,4)).AsClip();							
						}
					}
					if (RGB32) v=env->Invoke("ConvertToRGB32",v).AsClip();
					if (RGB48) v=env->Invoke("ConvertToRGB48",v).AsClip();
					if (RGB64) v=env->Invoke("ConvertToRGB64",v).AsClip();
				}
			}
		}
		else
		{
			if (!(RGB24 || vi.Is444() || vi.IsY() || RGB32 || RGB48 || RGB64 || isRGBPfamily))
			{
				if (vi.Is420())
				{
					AVSValue sargs[14]={vu,(vi.width*rfactor)>>1,(vi.height*rfactor)>>1,0.0,-0.25,
						(vi.width*rfactor)>>1,(vi.height*rfactor)>>1,threads_rs,LogicalCores_rs,MaxPhysCores_rs,
						SetAffinity_rs,sleep,prefetch,plane_range[1]};
					const char *nargs[14]={0,0,0,"src_left","src_top","src_width","src_height","threads",
					"logicalCores","MaxPhysCore","SetAffinity","sleep","prefetch","range" };
					const uint8_t nbarg=(SplineMT) ? 14:7;

					vu = env->Invoke(Spline36,AVSValue(sargs,nbarg),nargs).AsClip();
					sargs[0]=vv;
					sargs[13]=plane_range[2];
					vv = env->Invoke(Spline36,AVSValue(sargs,nbarg),nargs).AsClip();
				}

				AVSValue ytouvargs[4] = {vu,vv,v,va};
				if (isAlphaChannel) v=env->Invoke("YtoUV",AVSValue(ytouvargs,4)).AsClip();
				else v=env->Invoke("YtoUV",AVSValue(ytouvargs,3)).AsClip();

				if (vi.IsYUY2()) v=env->Invoke("ConvertToYUY2",v).AsClip();
			}
			else
			{
				if (RGB24)
				{
					if (avsp) v=env->Invoke("ConvertToRGB24",v).AsClip();
					else
					{
						AVSValue sargs[4];

						sargs[0]=v; sargs[1]=3;
						sargs[2]=0;
						vu=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
						sargs[2]=1;
						vv=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
						sargs[2]=2;
						v=env->Invoke("SelectEvery",AVSValue(sargs,3)).AsClip();
						sargs[0]=vu; sargs[1]=vv; sargs[2]=v; sargs[3]="RGB24";
						v=env->Invoke("MergeRGB",AVSValue(sargs,4)).AsClip();						
					}
				}				
				if (RGB32) v=env->Invoke("ConvertToRGB32",v).AsClip();
				if (RGB48) v=env->Invoke("ConvertToRGB48",v).AsClip();
				if (RGB64) v=env->Invoke("ConvertToRGB64",v).AsClip();
			}
		}
	}
	catch (IScriptEnvironment::NotFound)
	{
		env->ThrowError("nnedi3_rpow2: error using env->invoke (function not found)!\n");
	}
	return v;
}

const AVS_Linkage *AVS_linkage = nullptr;


extern "C" __declspec(dllexport) const char* __stdcall AvisynthPluginInit3(IScriptEnvironment* env, const AVS_Linkage* const vectors)
{
	poolInterface=ThreadPoolInterface::Init(0);

	AVS_linkage = vectors;

	env->AddFunction("nnedi3", "c[field]i[dh]b[Y]b[U]b[V]b[nsize]i[nns]i[qual]i[etype]i[pscrn]i" \
		"[threads]i[opt]i[fapprox]i[logicalCores]b[MaxPhysCore]b[SetAffinity]b[A]b[sleep]b[prefetch]i[range]i", Create_nnedi3, 0);
	env->AddFunction("nnedi3_rpow2", "c[rfactor]i[nsize]i[nns]i[qual]i[etype]i[pscrn]i[cshift]s[fwidth]i" \
		"[fheight]i[ep0]f[ep1]f[threads]i[opt]i[fapprox]i[csresize]b[mpeg2]b[logicalCores]b[MaxPhysCore]b" \
		"[SetAffinity]b[threads_rs]i[logicalCores_rs]b[MaxPhysCore_rs]b[SetAffinity_rs]b[sleep]b[prefetch]i[range]i", Create_nnedi3_rpow2, 0);

	return "NNEDI3 plugin";
	
}
