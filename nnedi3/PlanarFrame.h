/*
**   My PlanarFrame class... fast mmx/sse2 YUY2 packed to planar and planar 
**   to packed conversions, and always gives 16 bit alignment for all
**   planes.  Supports YV12/YUY2 frames from avisynth, can do any planar format 
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
#include "memcpy_amd.h"

#define MIN_PAD 10
#define MIN_ALIGNMENT 16
#define CPU_MMX 0x00000001
#define CPU_ISSE 0x00000002
#define CPU_SSE 0x00000004
#define CPU_SSE2 0x00000008
#define CPU_3DNOW 0x00000010
#define CPU_3DNOW2 0x00000020
#define CPU_SSE3 0x00000040
#define CPU_SSSE3 0x00000080
#define CPU_SSE41 0x00000100
#define CPU_SSE42 0x00000200

#define PLANAR_420 1
#define PLANAR_422 2
#define PLANAR_444 3


class PlanarFrame
{
private:
	bool useSIMD;
	int ypitch,uvpitch;
	int ywidth,uvwidth;
	int yheight,uvheight;
	uint8_t *y,*u,*v;
	bool PlanarFrame::allocSpace(VideoInfo &viInfo);
	bool PlanarFrame::allocSpace(int specs[4]);
	int PlanarFrame::getCPUInfo();
	int PlanarFrame::checkCPU();
	void PlanarFrame::checkSSEOSSupport(int &cput);
	void PlanarFrame::checkSSE2OSSupport(int &cput);
	void PlanarFrame::copyInternalFrom(PVideoFrame &frame,VideoInfo &viInfo);
	void PlanarFrame::copyInternalFrom(PlanarFrame &frame);
	void PlanarFrame::copyInternalTo(PVideoFrame &frame,VideoInfo &viInfo);
	void PlanarFrame::copyInternalTo(PlanarFrame &frame);
	void PlanarFrame::copyInternalPlaneTo(PlanarFrame &frame,uint8_t plane);
	static void PlanarFrame::asm_BitBlt_ISSE(uint8_t *dstp,int dst_pitch,const uint8_t *srcp,int src_pitch,int row_size,int height);
	void PlanarFrame::conv422toYUY2(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
		int width,int height);
	void PlanarFrame::conv444toRGB24(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
		int width,int height);

public:
	int cpu;
	PlanarFrame::PlanarFrame();
	PlanarFrame::PlanarFrame(VideoInfo &viInfo);
	PlanarFrame::~PlanarFrame();
	void PlanarFrame::createPlanar(int yheight,int uvheight,int ywidth,int uvwidth);
	void PlanarFrame::createPlanar(int height,int width,uint8_t chroma_format);
	void PlanarFrame::createFromProfile(VideoInfo &viInfo);
	void PlanarFrame::createFromFrame(PVideoFrame &frame,VideoInfo &viInfo);
	void PlanarFrame::createFromPlanar(PlanarFrame &frame);
	void PlanarFrame::copyFrom(PVideoFrame &frame,VideoInfo &viInfo);
	void PlanarFrame::copyTo(PVideoFrame &frame,VideoInfo &viInfo);
	void PlanarFrame::copyFrom(PlanarFrame &frame);
	void PlanarFrame::copyTo(PlanarFrame &frame);
	void PlanarFrame::copyChromaTo(PlanarFrame &dst);
	void PlanarFrame::copyPlaneTo(PlanarFrame &dst,uint8_t plane);
	void PlanarFrame::freePlanar();
	uint8_t* PlanarFrame::GetPtr(uint8_t plane);
	int PlanarFrame::GetWidth(uint8_t plane);
	int PlanarFrame::GetHeight(uint8_t plane);
	int PlanarFrame::GetPitch(uint8_t plane);
	void PlanarFrame::BitBlt(uint8_t *dstp,int dst_pitch,const uint8_t *srcp,int src_pitch,int row_size,int height);
	PlanarFrame& PlanarFrame::operator=(PlanarFrame &ob2);
	void PlanarFrame::convYUY2to422(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
		int width,int height);
	void PlanarFrame::convRGB24to444(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
		int width,int height);
};

#endif