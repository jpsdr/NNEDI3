/*
**   My PlanarFrame class... fast mmx/sse2 YUY2 packed to planar and planar 
**   to packed conversions, and always gives 16 bit alignment for all
**   planes.  Supports Y8/YV12/YV16/YV24/YUY2/RGB24 frames from avisynth, can do any planar format 
**   internally.
**
**   Copyright (C) 2005-2006 Kevin Stone
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

#ifndef __PlanarFrame_H__
#define __PlanarFrame_H__

#include <windows.h>
#include <malloc.h>
#include <stdint.h>
#include "internal.h"
#include ".\avs\cpuid.h"

#define MIN_PAD 10
#define MIN_ALIGNMENT 64

#define PLANAR_420 1
#define PLANAR_422 2
#define PLANAR_444 3


class PlanarFrame
{
private:
	bool useSIMD,useAVX;
	int cpu;
	int ypitch,uvpitch;
	int ywidth,uvwidth;
	int yheight,uvheight;
	bool alloc_ok;
	
	bool grey,isRGBPfamily,isAlphaChannel;
	uint8_t pixelsize; // AVS16
	uint8_t bits_per_pixel;
	
	uint8_t *planar_1,*planar_2,*planar_3,*planar_4;
	bool allocSpace(VideoInfo &viInfo);
	bool allocSpace(int specs[4],bool rgbplanar,bool alphaplanar,uint8_t _pixelsize,uint8_t _bits_per_pixel);
	int getCPUInfo(void);
	int checkCPU(void);
	bool copyInternalFrom(PVideoFrame &frame,VideoInfo &viInfo);
	bool copyInternalFrom(PlanarFrame &frame);
	bool copyInternalTo(PVideoFrame &frame,VideoInfo &viInfo);
	bool copyInternalTo(PlanarFrame &frame);
	bool copyInternalPlaneTo(PlanarFrame &frame,uint8_t plane);
	void conv422toYUY2(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
		int width,int height);
	void conv444toRGB24(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
		int width,int height);

public:
	PlanarFrame(void);
	PlanarFrame(VideoInfo &viInfo);
	virtual ~PlanarFrame(void);
	bool GetAllocStatus(void) {return(alloc_ok);}
	bool createPlanar(int yheight,int uvheight,int ywidth,int uvwidth,bool rgbplanar,bool alphaplanar,uint8_t pixelsize,uint8_t bits_per_pixel);
	bool createPlanar(int height,int width,uint8_t chroma_format,bool rgbplanar,bool alphaplanar,uint8_t pixelsize,uint8_t bits_per_pixel);
	bool createFromProfile(VideoInfo &viInfo);
	bool createFromFrame(PVideoFrame &frame,VideoInfo &viInfo);
	bool createFromPlanar(PlanarFrame &frame);
	bool copyFrom(PVideoFrame &frame,VideoInfo &viInfo);
	bool copyTo(PVideoFrame &frame,VideoInfo &viInfo);
	bool copyFrom(PlanarFrame &frame);
	bool copyTo(PlanarFrame &frame);
	bool copyChromaTo(PlanarFrame &dst);
	bool copyPlaneTo(PlanarFrame &dst,uint8_t plane);
	void freePlanar();
	uint8_t* GetPtr(uint8_t plane);
	int GetWidth(uint8_t plane);
	int GetHeight(uint8_t plane);
	int GetPitch(uint8_t plane);
	int getCPUFlags(void) {return cpu;}
	inline void BitBlt(uint8_t *dstp,int dst_pitch,const uint8_t *srcp,int src_pitch,int row_size,int height);
	PlanarFrame& PlanarFrame::operator=(PlanarFrame &ob2);
	void convYUY2to422(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
		int width,int height);
	void convRGB24to444(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
		int width,int height);
};

#endif