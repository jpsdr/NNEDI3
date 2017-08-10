/*
**   My PlanarFrame class... fast mmx/sse2 YUY2 packed to planar and planar 
**   to packed conversions, and always gives 16 bit alignment for all
**   planes.  Supports Y8/YV12/YV16/YV24/YUY2/RGB24 frames from avisynth, can do any planar
**   format internally.
**
**   Copyright (C) 2005-2010 Kevin Stone
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

#include "PlanarFrame.h"
#include <stdint.h>
#include <intrin.h>

#define myalignedfree(ptr) if (ptr!=NULL) { _aligned_free(ptr); ptr=NULL;}

extern "C" void convYUY2to422_MMX(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
	int width,int height);
extern "C" void convYUY2to422_SSE2(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
	int width,int height);
extern "C" void convYUY2to422_AVX(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
	int width,int height);
extern "C" void conv422toYUY2_MMX(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
	int width,int height);
extern "C" void conv422toYUY2_SSE2(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
	int width,int height);
extern "C" void conv422toYUY2_AVX(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
	int width,int height);


#define IS_BIT_SET(bitfield, bit) ((bitfield) & (1<<(bit)) ? true : false)

static int CPUCheckForExtensions()
{
  int result = 0;
  int cpuinfo[4];

  __cpuid(cpuinfo, 1);
  if (IS_BIT_SET(cpuinfo[3], 0))
    result |= CPUF_FPU;
  if (IS_BIT_SET(cpuinfo[3], 23))
    result |= CPUF_MMX;
  if (IS_BIT_SET(cpuinfo[3], 25))
    result |= CPUF_SSE | CPUF_INTEGER_SSE;
  if (IS_BIT_SET(cpuinfo[3], 26))
    result |= CPUF_SSE2;
  if (IS_BIT_SET(cpuinfo[2], 0))
    result |= CPUF_SSE3;
  if (IS_BIT_SET(cpuinfo[2], 9))
    result |= CPUF_SSSE3;
  if (IS_BIT_SET(cpuinfo[2], 19))
    result |= CPUF_SSE4_1;
  if (IS_BIT_SET(cpuinfo[2], 20))
    result |= CPUF_SSE4_2;
  if (IS_BIT_SET(cpuinfo[2], 22))
    result |= CPUF_MOVBE;
  if (IS_BIT_SET(cpuinfo[2], 23))
    result |= CPUF_POPCNT;
  if (IS_BIT_SET(cpuinfo[2], 25))
    result |= CPUF_AES;
  if (IS_BIT_SET(cpuinfo[2], 29))
    result |= CPUF_F16C;
  // AVX
  bool xgetbv_supported = IS_BIT_SET(cpuinfo[2], 27);
  bool avx_supported = IS_BIT_SET(cpuinfo[2], 28);
  if (xgetbv_supported && avx_supported)
  {
    unsigned long long xgetbv0 = _xgetbv(_XCR_XFEATURE_ENABLED_MASK);
    if ((xgetbv0 & 0x6ull) == 0x6ull) {
      result |= CPUF_AVX;
      if (IS_BIT_SET(cpuinfo[2], 12))
        result |= CPUF_FMA3;
      __cpuid(cpuinfo, 7);
      if (IS_BIT_SET(cpuinfo[1], 5))
        result |= CPUF_AVX2;
    }
    if((xgetbv0 & (0x7ull << 5)) && // OPMASK: upper-256 enabled by OS
       (xgetbv0 & (0x3ull << 1))) { // XMM/YMM enabled by OS
      // Verify that XCR0[7:5] = ‘111b’ (OPMASK state, upper 256-bit of ZMM0-ZMM15 and
      // ZMM16-ZMM31 state are enabled by OS)
      /// and that XCR0[2:1] = ‘11b’ (XMM state and YMM state are enabled by OS).
      __cpuid(cpuinfo, 7);
      if (IS_BIT_SET(cpuinfo[1], 16))
        result |= CPUF_AVX512F;
      if (IS_BIT_SET(cpuinfo[1], 17))
        result |= CPUF_AVX512DQ;
      if (IS_BIT_SET(cpuinfo[1], 21))
        result |= CPUF_AVX512IFMA;
      if (IS_BIT_SET(cpuinfo[1], 26))
        result |= CPUF_AVX512PF;
      if (IS_BIT_SET(cpuinfo[1], 27))
        result |= CPUF_AVX512ER;
      if (IS_BIT_SET(cpuinfo[1], 28))
        result |= CPUF_AVX512CD;
      if (IS_BIT_SET(cpuinfo[1], 30))
        result |= CPUF_AVX512BW;
      if (IS_BIT_SET(cpuinfo[1], 31))
        result |= CPUF_AVX512VL;
      if (IS_BIT_SET(cpuinfo[2], 1)) // [2]!
        result |= CPUF_AVX512VBMI;
    }
  }

  // 3DNow!, 3DNow!, ISSE, FMA4
  __cpuid(cpuinfo, 0x80000000);   
  if (cpuinfo[0] >= 0x80000001)
  {
    __cpuid(cpuinfo, 0x80000001);

    if (IS_BIT_SET(cpuinfo[3], 31))
      result |= CPUF_3DNOW;

    if (IS_BIT_SET(cpuinfo[3], 30))
      result |= CPUF_3DNOW_EXT;

    if (IS_BIT_SET(cpuinfo[3], 22))
      result |= CPUF_INTEGER_SSE;

    if (result & CPUF_AVX) {
      if (IS_BIT_SET(cpuinfo[2], 16))
        result |= CPUF_FMA4;
    }
  }

  return result;
}


int modnpf(const int m, const int n)
{
	if ((m%n) == 0)
		return m;
	return m+n-(m%n);
}


PlanarFrame::PlanarFrame(void)
{
	alloc_ok=false;
	ypitch = uvpitch = 0;
	ywidth = uvwidth = 0;
	yheight = uvheight = 0;
	planar_1 = planar_2 = planar_3 = planar_4 = NULL;
	useSIMD = true;
	useAVX = true;
	cpu = CPUCheckForExtensions();
	isRGBPfamily = false;
	isAlphaChannel = false;
	grey = false;
	pixelsize=1;
	bits_per_pixel=8;
}


PlanarFrame::PlanarFrame(VideoInfo &viInfo)
{
	ypitch = uvpitch = 0;
	ywidth = uvwidth = 0;
	yheight = uvheight = 0;
	planar_1 = planar_2 = planar_3 = planar_4 = NULL;
	useSIMD = true;
	useAVX = true;
	cpu = CPUCheckForExtensions();
	alloc_ok=allocSpace(viInfo);
}


PlanarFrame::~PlanarFrame(void)
{
	myalignedfree(planar_4);
	myalignedfree(planar_3);
	myalignedfree(planar_2);
	myalignedfree(planar_1);
}


bool PlanarFrame::allocSpace(VideoInfo &viInfo)
{
	myalignedfree(planar_4);
	myalignedfree(planar_3);
	myalignedfree(planar_2);
	myalignedfree(planar_1);
	alloc_ok=false;

	grey = viInfo.IsY();
	isRGBPfamily = viInfo.IsPlanarRGB() || viInfo.IsPlanarRGBA();
	isAlphaChannel = viInfo.IsYUVA() || viInfo.IsPlanarRGBA();
	pixelsize = (uint8_t)viInfo.ComponentSize(); // AVS16
	bits_per_pixel = (uint8_t)viInfo.BitsPerComponent();
	
	ypitch = uvpitch = 0;
	ywidth = uvwidth = 0;
	yheight = uvheight = 0;

	int height = viInfo.height;
	int width = viInfo.width;
	if ((height==0) || (width==0)) return(false);
	if (viInfo.Is420())
	{
		ypitch = modnpf((int)pixelsize*(width+MIN_PAD),MIN_ALIGNMENT);
		ywidth = width;
		yheight = height;
		width >>= 1;
		height >>= 1;
		uvpitch = modnpf((int)pixelsize*(width+MIN_PAD),MIN_ALIGNMENT);
		uvwidth = width;
		uvheight = height;
	}
	else
	{
		if (viInfo.IsYUY2() || viInfo.Is422())
		{
			ypitch = modnpf((int)pixelsize*(width+MIN_PAD),MIN_ALIGNMENT);
			ywidth = width;
			yheight = height;
			width >>= 1;
			uvpitch = modnpf((int)pixelsize*(width+MIN_PAD),MIN_ALIGNMENT);
			uvwidth = width;
			uvheight = height;
		}
		else
		{
			if (viInfo.IsRGB24() || viInfo.Is444() || isRGBPfamily)
			{
				ypitch = modnpf((int)pixelsize*(width+MIN_PAD),MIN_ALIGNMENT);
				ywidth = width;
				yheight = height;
				uvpitch = ypitch;
				uvwidth = ywidth;
				uvheight = yheight;
			}
			else
			{
				if (grey)
				{
					ypitch = modnpf((int)pixelsize*(width+MIN_PAD),MIN_ALIGNMENT);
					ywidth = width;
					yheight = height;
				}
				else
				{
					if (viInfo.IsYV411())
					{
						ypitch = modnpf((int)pixelsize*(width+MIN_PAD),MIN_ALIGNMENT);
						ywidth = width;
						yheight = height;
						width >>= 2;
						uvpitch = modnpf((int)pixelsize*(width+MIN_PAD),MIN_ALIGNMENT);
						uvwidth = width;
						uvheight = height;
					}
				}
			}
		}
	}
	planar_1 = (uint8_t *)_aligned_malloc((size_t)ypitch*(size_t)yheight,MIN_ALIGNMENT);
	if (planar_1 == NULL) return(false);
	if ((uvpitch!=0) && (uvheight!=0))
	{
		planar_2 = (uint8_t *)_aligned_malloc((size_t)uvpitch*(size_t)uvheight,MIN_ALIGNMENT);
		if (planar_2 == NULL) return(false);
		planar_3 = (uint8_t *)_aligned_malloc((size_t)uvpitch*(size_t)uvheight,MIN_ALIGNMENT);
		if (planar_3 == NULL) return(false);
		
		if (isAlphaChannel)
		{
			planar_4 = (uint8_t *)_aligned_malloc((size_t)ypitch*(size_t)yheight,MIN_ALIGNMENT);
			if (planar_4 == NULL) return(false);
		}
	}
	alloc_ok=true;
	return(true);
}


bool PlanarFrame::allocSpace(int specs[4],bool rgbplanar,bool alphaplanar,uint8_t _pixelsize,uint8_t _bits_per_pixel)
{
	myalignedfree(planar_4);
	myalignedfree(planar_3);
	myalignedfree(planar_2);
	myalignedfree(planar_1);
	alloc_ok=false;

	ypitch = uvpitch = 0;
	ywidth = uvwidth = 0;
	yheight = uvheight = 0;

	int height = specs[0];
	int width = specs[2];
	if ((height==0) || (width==0)) return(false);
	ypitch = modnpf((int)_pixelsize*(width+MIN_PAD),MIN_ALIGNMENT);
	ywidth = width;
	yheight = height;
	height = specs[1];
	width = specs[3];
	if ((width!=0) && (height!=0))
	{
		uvpitch = modnpf((int)_pixelsize*(width+MIN_PAD),MIN_ALIGNMENT);
		uvwidth = width;
		uvheight = height;
		grey=false;
	}
	else grey=true;
	isRGBPfamily=rgbplanar;
	isAlphaChannel=alphaplanar;
	pixelsize=_pixelsize;
	bits_per_pixel=_bits_per_pixel;
	
	planar_1 = (uint8_t *)_aligned_malloc((size_t)ypitch*(size_t)yheight,MIN_ALIGNMENT);
	if (planar_1 == NULL) return(false);
	if ((uvpitch!=0) && (uvheight!=0))
	{
		planar_2 = (uint8_t *)_aligned_malloc((size_t)uvpitch*(size_t)uvheight,MIN_ALIGNMENT);
		if (planar_2 == NULL) return(false);
		planar_3 = (uint8_t *)_aligned_malloc((size_t)uvpitch*(size_t)uvheight,MIN_ALIGNMENT);
		if (planar_3 == NULL) return(false);
		
		if (isAlphaChannel)
		{
			planar_4 = (uint8_t *)_aligned_malloc((size_t)ypitch*(size_t)yheight,MIN_ALIGNMENT);
			if (planar_4 == NULL) return(false);
		}
	}
	
	alloc_ok=true;
	return(true);
}


int PlanarFrame::getCPUInfo(void)
{
	static const int cpu_saved = CPUCheckForExtensions();
	return cpu_saved;
}

int PlanarFrame::checkCPU(void)
{
	int cput = 0;

	cput=CPUCheckForExtensions();
	return cput;
}


bool PlanarFrame::createPlanar(int yheight, int uvheight, int ywidth, int uvwidth,bool rgbplanar,bool alphaplanar,uint8_t pixelsize,uint8_t bits_per_pixel)
{
	int specs[4] = {yheight,uvheight,ywidth,uvwidth};
	return(allocSpace(specs,rgbplanar,alphaplanar,pixelsize,bits_per_pixel));
}


bool PlanarFrame::createPlanar(int height,int width,uint8_t chroma_format,bool rgbplanar,bool alphaplanar,uint8_t pixelsize,uint8_t bits_per_pixel)
{
	int specs[4];
	switch(chroma_format)
	{
		case 0 :
			specs[0] = height; specs[1] = height;
			specs[2] = width; specs[3] = width;
			break;		
		case 1 :
			specs[0] = height; specs[1] = height>>1;
			specs[2] = width; specs[3] = width>>1;
			break;
		case 2 :
			specs[0] = height; specs[1] = height;
			specs[2] = width; specs[3] = width>>1;
			break;
		case 3 :
			specs[0] = height; specs[1] = height;
			specs[2] = width; specs[3] = width>>2;
			break;
		case 4 :
			specs[0] = height; specs[1] = 0;
			specs[2] = width; specs[3] = 0;
			break;
		default :
			specs[0] = height; specs[1] = height;
			specs[2] = width; specs[3] = width;
			break;
	}
	return(allocSpace(specs,rgbplanar,alphaplanar,pixelsize,bits_per_pixel));
}


bool PlanarFrame::createFromProfile(VideoInfo &viInfo)
{
	return(allocSpace(viInfo));
}


bool PlanarFrame::createFromFrame(PVideoFrame &frame,VideoInfo &viInfo)
{
	if (!allocSpace(viInfo)) return(false);
	else return(copyInternalFrom(frame,viInfo));
}


bool PlanarFrame::createFromPlanar(PlanarFrame &frame)
{
	int specs[4] = {frame.yheight,frame.uvheight,frame.ywidth,frame.uvwidth};
	if (!allocSpace(specs,frame.isRGBPfamily,frame.isAlphaChannel,frame.pixelsize,frame.bits_per_pixel)) return(false);
	else return(copyInternalFrom(frame));
}


bool PlanarFrame::copyFrom(PVideoFrame &frame,VideoInfo &viInfo)
{
	return(copyInternalFrom(frame,viInfo));
}


bool PlanarFrame::copyFrom(PlanarFrame &frame)
{
	return(copyInternalFrom(frame));
}


bool PlanarFrame::copyTo(PVideoFrame &frame,VideoInfo &viInfo)
{
	return(copyInternalTo(frame,viInfo));
}


bool PlanarFrame::copyTo(PlanarFrame &frame)
{
	return(copyInternalTo(frame));
}


bool PlanarFrame::copyPlaneTo(PlanarFrame &frame,uint8_t plane)
{
	return(copyInternalPlaneTo(frame,plane));
}


uint8_t* PlanarFrame::GetPtr(uint8_t plane)
{
	switch(plane)
	{
		case 0 : return planar_1; break;
		case 1 : return planar_2; break;
		case 2 : return planar_3; break;
		case 3 : return planar_4; break;
		default : return NULL; break;
	}
}


int PlanarFrame::GetWidth(uint8_t plane)
{
	switch(plane)
	{
		case 0 : return ywidth; break;
		case 1 : return uvwidth; break;
		case 2 : return uvwidth; break;
		case 3 : return ywidth; break;
		default : return 0; break;
	}
}


int PlanarFrame::GetHeight(uint8_t plane)
{
	switch(plane)
	{
		case 0 : return yheight; break;
		case 1 : return uvheight; break;
		case 2 : return uvheight; break;
		case 3 : return yheight; break;
		default : return 0; break;
	}
}


int PlanarFrame::GetPitch(uint8_t plane)
{
	switch(plane)
	{
		case 0 : return ypitch; break;
		case 1 : return uvpitch; break;
		case 2 : return uvpitch; break;
		case 3 : return ypitch; break;
		default : return 0; break;
	}
}


void PlanarFrame::freePlanar()
{
	myalignedfree(planar_4);
	myalignedfree(planar_3);
	myalignedfree(planar_2);
	myalignedfree(planar_1);
	alloc_ok=false;
	isRGBPfamily = false;
	isAlphaChannel = false;
	grey = false;

	ypitch = uvpitch = 0;
	ywidth = uvwidth = 0;
	yheight = uvheight = 0;
	cpu = 0;
	pixelsize=1;
	bits_per_pixel=8;
}


bool PlanarFrame::copyInternalFrom(PVideoFrame &frame,VideoInfo &viInfo)
{
	bool _grey,_isRGBPfamily,_isAlphaChannel;
	
	_grey = viInfo.IsY();
	_isRGBPfamily = viInfo.IsPlanarRGB() || viInfo.IsPlanarRGBA();
	_isAlphaChannel = viInfo.IsYUVA() || viInfo.IsPlanarRGBA();
	
	if ((planar_1==NULL) || (!_grey && ((planar_2==NULL) || (planar_3==NULL))) || (_isAlphaChannel && (planar_4==NULL))) return(false);

	if (!_grey && viInfo.IsPlanar())
	{
		if (!_isRGBPfamily)
		{
			BitBlt(planar_1,ypitch,frame->GetReadPtr(PLANAR_Y),frame->GetPitch(PLANAR_Y), 
				frame->GetRowSize(PLANAR_Y),frame->GetHeight(PLANAR_Y));
			BitBlt(planar_2,uvpitch,frame->GetReadPtr(PLANAR_U),frame->GetPitch(PLANAR_U), 
				frame->GetRowSize(PLANAR_U),frame->GetHeight(PLANAR_U));
			BitBlt(planar_3,uvpitch,frame->GetReadPtr(PLANAR_V),frame->GetPitch(PLANAR_V), 
				frame->GetRowSize(PLANAR_V),frame->GetHeight(PLANAR_V));				
		}
		else
		{
			BitBlt(planar_1,ypitch,frame->GetReadPtr(PLANAR_G),frame->GetPitch(PLANAR_G), 
				frame->GetRowSize(PLANAR_G),frame->GetHeight(PLANAR_G));
			BitBlt(planar_2,uvpitch,frame->GetReadPtr(PLANAR_B),frame->GetPitch(PLANAR_B), 
				frame->GetRowSize(PLANAR_B),frame->GetHeight(PLANAR_B));
			BitBlt(planar_3,uvpitch,frame->GetReadPtr(PLANAR_R),frame->GetPitch(PLANAR_R), 
				frame->GetRowSize(PLANAR_R),frame->GetHeight(PLANAR_R));				
		}			
	}
	else
	{
		if (_grey)
		{
			BitBlt(planar_1,ypitch,frame->GetReadPtr(PLANAR_Y),frame->GetPitch(PLANAR_Y), 
				frame->GetRowSize(PLANAR_Y),frame->GetHeight(PLANAR_Y));
		}
		else
		{
			if (viInfo.IsYUY2())
			{
				convYUY2to422(frame->GetReadPtr(),planar_1,planar_2,planar_3,frame->GetPitch(),ypitch,uvpitch,
					viInfo.width,viInfo.height);
			}
			else
			{
				if (viInfo.IsRGB24())
				{
					convRGB24to444(frame->GetReadPtr(),planar_1,planar_2,planar_3,frame->GetPitch(),ypitch,uvpitch,
						viInfo.width,viInfo.height);
				}
			}
		}
	}
	
	if (_isAlphaChannel) BitBlt(planar_4,uvpitch,frame->GetReadPtr(PLANAR_A),frame->GetPitch(PLANAR_A), 
	 frame->GetRowSize(PLANAR_A),frame->GetHeight(PLANAR_A));				

	return(true);
}


bool PlanarFrame::copyInternalFrom(PlanarFrame &frame)
{
	if ((planar_1==NULL) || ((frame.uvpitch!=0) && ((planar_2==NULL) || (planar_3==NULL))) || (frame.isAlphaChannel && (planar_4==NULL))) return(false);

	BitBlt(planar_1,ypitch,frame.planar_1,frame.ypitch,(int)frame.pixelsize*frame.ywidth,frame.yheight);
	if (frame.uvpitch!=0)
	{
		BitBlt(planar_2,uvpitch,frame.planar_2,frame.uvpitch,(int)frame.pixelsize*frame.uvwidth,frame.uvheight);
		BitBlt(planar_3,uvpitch,frame.planar_3,frame.uvpitch,(int)frame.pixelsize*frame.uvwidth,frame.uvheight);
	}
	if (frame.isAlphaChannel) BitBlt(planar_4,ypitch,frame.planar_4,frame.ypitch,(int)frame.pixelsize*frame.ywidth,frame.yheight);
	return(true);
}


bool PlanarFrame::copyInternalTo(PVideoFrame &frame,VideoInfo &viInfo)
{
	if ((planar_1==NULL) || (!grey && ((planar_2==NULL) || (planar_3==NULL))) || (isAlphaChannel && (planar_4==NULL))) return(false);

	if (!grey && viInfo.IsPlanar())
	{
		if (!isRGBPfamily)
		{
			BitBlt(frame->GetWritePtr(PLANAR_Y),frame->GetPitch(PLANAR_Y),planar_1,ypitch,(int)pixelsize*ywidth,yheight);
			BitBlt(frame->GetWritePtr(PLANAR_U),frame->GetPitch(PLANAR_U),planar_2,uvpitch,(int)pixelsize*uvwidth,uvheight);
			BitBlt(frame->GetWritePtr(PLANAR_V),frame->GetPitch(PLANAR_V),planar_3,uvpitch,(int)pixelsize*uvwidth,uvheight);				
		}
		else
		{
			BitBlt(frame->GetWritePtr(PLANAR_G),frame->GetPitch(PLANAR_G),planar_1,ypitch,(int)pixelsize*ywidth,yheight);
			BitBlt(frame->GetWritePtr(PLANAR_B),frame->GetPitch(PLANAR_B),planar_2,uvpitch,(int)pixelsize*uvwidth,uvheight);
			BitBlt(frame->GetWritePtr(PLANAR_R),frame->GetPitch(PLANAR_R),planar_3,uvpitch,(int)pixelsize*uvwidth,uvheight);				
		}			
	}
	else
	{
		if (grey)
		{
			BitBlt(frame->GetWritePtr(PLANAR_Y),frame->GetPitch(PLANAR_Y),planar_1,ypitch,(int)pixelsize*ywidth,yheight);
		}
		else
		{
			if (viInfo.IsYUY2())
			{
				conv422toYUY2(planar_1,planar_2,planar_3,frame->GetWritePtr(),ypitch,uvpitch,frame->GetPitch(),ywidth,yheight);
			}
			else
			{
				if (viInfo.IsRGB24())
				{
					conv444toRGB24(planar_1,planar_2,planar_3,frame->GetWritePtr(),ypitch,uvpitch,frame->GetPitch(),ywidth,yheight);
				}
			}
		}
	}
	if (isAlphaChannel) BitBlt(frame->GetWritePtr(PLANAR_A),frame->GetPitch(PLANAR_A),planar_4,ypitch,(int)pixelsize*ywidth,yheight);
	return(true);
}


bool PlanarFrame::copyInternalTo(PlanarFrame &frame)
{
	if ((planar_1==NULL) || ((uvpitch!=0) && ((planar_2==NULL) || (planar_3==NULL))) || (isAlphaChannel && (planar_4==NULL))) return(false);

	BitBlt(frame.planar_1,frame.ypitch,planar_1,ypitch,(int)pixelsize*ywidth,yheight);
	if (uvpitch!=0)
	{
		BitBlt(frame.planar_2,frame.uvpitch,planar_2,uvpitch,(int)pixelsize*uvwidth,uvheight);
		BitBlt(frame.planar_3,frame.uvpitch,planar_3,uvpitch,(int)pixelsize*uvwidth,uvheight);
	}
	if (isAlphaChannel) BitBlt(frame.planar_4,frame.ypitch,planar_4,ypitch,(int)pixelsize*ywidth,yheight);
	return(true);
}


bool PlanarFrame::copyInternalPlaneTo(PlanarFrame &frame,uint8_t plane)
{
	bool out=true;

	switch(plane)
	{
		case 0 :
			if (planar_1!=NULL) BitBlt(frame.planar_1,frame.ypitch,planar_1,ypitch,(int)pixelsize*ywidth,yheight);
			else out=false;
			break;
		case 1 :
			if (planar_2!=NULL) BitBlt(frame.planar_2,frame.uvpitch,planar_2,uvpitch,(int)pixelsize*uvwidth,uvheight);
			else out=false;
			break;
		case 2 :
			if (planar_3!=NULL) BitBlt(frame.planar_3,frame.uvpitch,planar_3,uvpitch,(int)pixelsize*uvwidth,uvheight);
			else out=false;
			break;
		case 3 :
			if (planar_4!=NULL) BitBlt(frame.planar_4,frame.ypitch,planar_4,ypitch,(int)pixelsize*ywidth,yheight);
			else out=false;
			break;
		default : out=false; break;
	}
	return(out);
}


bool PlanarFrame::copyChromaTo(PlanarFrame &dst)
{
	bool out=true;

	if (uvpitch!=0)
	{
		BitBlt(dst.planar_2,dst.uvpitch,planar_2,uvpitch,(int)dst.pixelsize*dst.uvwidth,dst.uvheight);
		BitBlt(dst.planar_3,dst.uvpitch,planar_3,uvpitch,(int)dst.pixelsize*dst.uvwidth,dst.uvheight);
	}
	else out=false;

	return(out);
}


PlanarFrame& PlanarFrame::operator=(PlanarFrame &ob2)
{
	useSIMD = ob2.useSIMD;
	useAVX = ob2.useAVX;
	cpu = ob2.cpu;
	ypitch = ob2.ypitch;
	yheight = ob2.yheight;
	ywidth = ob2.ywidth;
	uvpitch = ob2.uvpitch;
	uvheight = ob2.uvheight;
	uvwidth = ob2.uvwidth;
	alloc_ok=ob2.alloc_ok;
	grey=ob2.grey;
	isAlphaChannel=ob2.isAlphaChannel;
	isRGBPfamily=ob2.isRGBPfamily;
	bits_per_pixel = ob2.bits_per_pixel;
	pixelsize = ob2.pixelsize;
	this->copyFrom(ob2);
	return *this;
}


void PlanarFrame::convYUY2to422(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
	int width,int height)
{
	if (((cpu&CPUF_AVX)!=0) && useAVX && (((size_t(src)|pitch1)&15)==0))
		convYUY2to422_AVX(src,py,pu,pv,pitch1,pitch2Y,pitch2UV,(width+7)>>3,height);
	else
	{
		if (((cpu&CPUF_SSE2)!=0) && useSIMD && (((size_t(src)|pitch1)&15)==0))
			convYUY2to422_SSE2(src,py,pu,pv,pitch1,pitch2Y,pitch2UV,(width+7)>>3,height);
		else
		{
			if (((cpu&CPUF_MMX)!=0) && useSIMD) convYUY2to422_MMX(src,py,pu,pv,pitch1,pitch2Y,pitch2UV,width,height);
			else
			{
				width >>= 1;
				for (int y=0; y<height; ++y)
				{
					int x_1=0,x_2=0;

					for (int x=0; x<width; ++x)
					{
						py[x_1] = src[x_2];
						pu[x] = src[x_2+1];
						py[x_1+1] = src[x_2+2];
						pv[x] = src[x_2+3];
						x_1+=2;
						x_2+=4;
					}
					py += pitch2Y;
					pu += pitch2UV;
					pv += pitch2UV;
					src += pitch1;
				}
			}
		}
	}
}


void PlanarFrame::conv422toYUY2(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
	int width,int height)
{
	const int w_8=(width+7)>>3;
	const int modulo2=pitch2-(w_8 << 4);

	if (((cpu&CPUF_AVX)!=0) && useAVX) conv422toYUY2_AVX(py,pu,pv,dst,pitch1Y,pitch1UV,modulo2,w_8,height);
	else
	{
		if (((cpu&CPUF_SSE2)!=0) && useSIMD) conv422toYUY2_SSE2(py,pu,pv,dst,pitch1Y,pitch1UV,modulo2,w_8,height);
		else
		{
			if (((cpu&CPUF_MMX)!=0) && useSIMD) conv422toYUY2_MMX(py,pu,pv,dst,pitch1Y,pitch1UV,pitch2,width,height);
			else
			{
				width >>= 1;
				for (int y=0; y<height; ++y)
				{
					int x_1=0,x_2=0;

					for (int x=0; x<width; ++x)
					{
						dst[x_2] = py[x_1];
						dst[x_2+1] = pu[x];
						dst[x_2+2] = py[x_1+1];
						dst[x_2+3] = pv[x];
						x_1+=2;
						x_2+=4;
					}
					py += pitch1Y;
					pu += pitch1UV;
					pv += pitch1UV;
					dst += pitch2;
				}
			}
		}
	}
}


void PlanarFrame::convRGB24to444(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
	int width,int height)
{
	for (int y=0; y<height; ++y)
	{
		int x_3=0;

		for (int x=0; x<width; ++x)
		{
			py[x] = src[x_3];
			pu[x] = src[x_3+1];
			pv[x] = src[x_3+2];
			x_3+=3;
		}
		src += pitch1;
		py += pitch2Y;
		pu += pitch2UV;
		pv += pitch2UV;
	}
}


void PlanarFrame::conv444toRGB24(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
	int width,int height)
{
	dst += (height-1)*pitch2;
	for (int y=0; y<height; ++y)
	{
		int x_3=0;

		for (int x=0; x<width; ++x)
		{
			dst[x_3] = py[x];
			dst[x_3+1] = pu[x];
			dst[x_3+2] = pv[x];
			x_3+=3;
		}
		py += pitch1Y;
		pu += pitch1UV;
		pv += pitch1UV;
		dst -= pitch2;
	}
}


// Avisynth v2.5.  Copyright 2002 Ben Rudiak-Gould et al.
// http://www.avisynth.org

// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA, or visit
// http://www.gnu.org/copyleft/gpl.html .
//
// Linking Avisynth statically or dynamically with other modules is making a
// combined work based on Avisynth.  Thus, the terms and conditions of the GNU
// General Public License cover the whole combination.
//
// As a special exception, the copyright holders of Avisynth give you
// permission to link Avisynth with independent modules that communicate with
// Avisynth solely through the interfaces defined in avisynth.h, regardless of the license
// terms of these independent modules, and to copy and distribute the
// resulting combined work under terms of your choice, provided that
// every copy of the combined work is accompanied by a complete copy of
// the source code of Avisynth (the version of Avisynth used to produce the
// combined work), being distributed under the terms of the GNU General
// Public License plus this exception.  An independent module is a module
// which is not derived from or based on Avisynth, such as 3rd-party filters,
// import and export plugins, or graphical user interfaces.

// from AviSynth 2.55 source...
// copied so we don't need an
// IScriptEnvironment pointer 
// to call it

inline void PlanarFrame::BitBlt(uint8_t *dstp,int dst_pitch,const uint8_t *srcp,int src_pitch,int row_size,int height) 
{
	if ((height==0) || (row_size==0)) return;

	if ((height==1) || ((dst_pitch==src_pitch) && (abs(src_pitch)==row_size)))
	{
		if (src_pitch<0)
		{
			srcp+=(height-1)*src_pitch;
			dstp+=(height-1)*dst_pitch;
		}
		memcpy(dstp,srcp,(size_t)row_size*(size_t)height);
	}
	else 
	{
		for (int y=0; y<height; y++)
		{
			memcpy(dstp,srcp,row_size);
			dstp+=dst_pitch;
			srcp+=src_pitch;
		}
	}
}
