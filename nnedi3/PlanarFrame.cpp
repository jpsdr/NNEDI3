/*
**   My PlanarFrame class... fast mmx/sse2 YUY2 packed to planar and planar 
**   to packed conversions, and always gives 16 bit alignment for all
**   planes.  Supports YV12/YUY2/RGB24 frames from avisynth, can do any planar
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


extern "C" int checkCPU_ASM(void);
extern "C" void checkSSEOSSupport_ASM(void);
extern "C" void checkSSE2OSSupport_ASM(void);
extern "C" void convYUY2to422_MMX(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
	int width,int height);
extern "C" void convYUY2to422_SSE2(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
	int width,int height);
extern "C" void conv422toYUY2_MMX(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
	int width,int height);
extern "C" void conv422toYUY2_SSE2(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
	int width,int height);


int modnpf(const int m, const int n)
{
	if ((m%n) == 0)
		return m;
	return m+n-(m%n);
}

PlanarFrame::PlanarFrame()
{
	ypitch = uvpitch = 0;
	ywidth = uvwidth = 0;
	yheight = uvheight = 0;
	y = u = v = NULL;
	useSIMD = true;
	cpu = getCPUInfo();
}

PlanarFrame::PlanarFrame(VideoInfo &viInfo)
{
	ypitch = uvpitch = 0;
	ywidth = uvwidth = 0;
	yheight = uvheight = 0;
	y = u = v = NULL;
	useSIMD = true;
	cpu = getCPUInfo();
	allocSpace(viInfo);
}

PlanarFrame::~PlanarFrame()
{
	if (y != NULL) { _aligned_free(y); y = NULL; }
	if (u != NULL) { _aligned_free(u); u = NULL; }
	if (v != NULL) { _aligned_free(v); v = NULL; }
}

bool PlanarFrame::allocSpace(VideoInfo &viInfo)
{
	if (y != NULL) { _aligned_free(y); y = NULL; }
	if (u != NULL) { _aligned_free(u); u = NULL; }
	if (v != NULL) { _aligned_free(v); v = NULL; }
	ypitch = uvpitch = 0;
	ywidth = uvwidth = 0;
	yheight = uvheight = 0;

	int height = viInfo.height;
	int width = viInfo.width;
	if ((height==0) || (width==0)) return false;
	if (viInfo.IsYV12())
	{
		ypitch = modnpf(width+MIN_PAD,MIN_ALIGNMENT);
		ywidth = width;
		yheight = height;
		width >>= 1;
		height >>= 1;
		uvpitch = modnpf(width+MIN_PAD,MIN_ALIGNMENT);
		uvwidth = width;
		uvheight = height;
	}
	else
	{
		if (viInfo.IsYUY2() || viInfo.IsYV16())
		{
			ypitch = modnpf(width+MIN_PAD,MIN_ALIGNMENT);
			ywidth = width;
			yheight = height;
			width >>= 1;
			uvpitch = modnpf(width+MIN_PAD,MIN_ALIGNMENT);
			uvwidth = width;
			uvheight = height;
		}
		else
		{
			if (viInfo.IsRGB24() || viInfo.IsYV24())
			{
				ypitch = modnpf(width+MIN_PAD,MIN_ALIGNMENT);
				ywidth = width;
				yheight = height;
				uvpitch = ypitch;
				uvwidth = ywidth;
				uvheight = yheight;
			}
			else
			{
				if (viInfo.IsY8())
				{
					ypitch = modnpf(width+MIN_PAD,MIN_ALIGNMENT);
					ywidth = width;
					yheight = height;
				}
			}
		}
	}
	y = (unsigned char*)_aligned_malloc(ypitch*yheight,MIN_ALIGNMENT);
	if (y == NULL) return false;
	if ((uvpitch!=0) && (uvheight!=0))
	{
		u = (unsigned char*)_aligned_malloc(uvpitch*uvheight,MIN_ALIGNMENT);
		if (u == NULL) return false;
		v = (unsigned char*)_aligned_malloc(uvpitch*uvheight,MIN_ALIGNMENT);
		if (v == NULL) return false;
	}
	return true;
}

bool PlanarFrame::allocSpace(int specs[4])
{
	if (y != NULL) { _aligned_free(y); y = NULL; }
	if (u != NULL) { _aligned_free(u); u = NULL; }
	if (v != NULL) { _aligned_free(v); v = NULL; }
	ypitch = uvpitch = 0;
	ywidth = uvwidth = 0;
	yheight = uvheight = 0;

	int height = specs[0];
	int width = specs[2];
	if ((height==0) || (width==0)) return false;
	ypitch = modnpf(width+MIN_PAD,MIN_ALIGNMENT);
	ywidth = width;
	yheight = height;
	height = specs[1];
	width = specs[3];
	if ((width!=0) && (height!=0))
	{
		uvpitch = modnpf(width+MIN_PAD,MIN_ALIGNMENT);
		uvwidth = width;
		uvheight = height;
	}
	y = (unsigned char*)_aligned_malloc(ypitch*yheight,MIN_ALIGNMENT);
	if (y == NULL) return false;
	if ((uvpitch!=0) && (uvheight!=0))
	{
		u = (unsigned char*)_aligned_malloc(uvpitch*uvheight,MIN_ALIGNMENT);
		if (u == NULL) return false;
		v = (unsigned char*)_aligned_malloc(uvpitch*uvheight,MIN_ALIGNMENT);
		if (v == NULL) return false;
	}
	return true;
}

int PlanarFrame::getCPUInfo()
{
	static const int cpu_saved = checkCPU();
	return cpu_saved;
}

int PlanarFrame::checkCPU()
{
	int cput = 0;

	cput=checkCPU_ASM();
	if (cput&0x04) checkSSEOSSupport(cput);
	if (cput&0x08) checkSSE2OSSupport(cput);
	return cput;
}

void PlanarFrame::checkSSEOSSupport(int &cput)
{
	__try
	{
		checkSSEOSSupport_ASM();
	} 
	__except (EXCEPTION_EXECUTE_HANDLER) 
	{
		if (GetExceptionCode() == 0xC000001Du) cput &= ~0x04;
	}
}

void PlanarFrame::checkSSE2OSSupport(int &cput)
{
	__try
	{
		checkSSE2OSSupport_ASM();
	} 
	__except (EXCEPTION_EXECUTE_HANDLER) 
	{
		if (GetExceptionCode() == 0xC000001Du) cput &= ~0x08;
	}
}

void PlanarFrame::createPlanar(int yheight, int uvheight, int ywidth, int uvwidth)
{
	int specs[4] = {yheight,uvheight,ywidth,uvwidth};
	allocSpace(specs);
}

void PlanarFrame::createPlanar(int height,int width,uint8_t chroma_format)
{
	int specs[4];
	switch(chroma_format)
	{
		case 0 :
		case 1 :
			specs[0] = height; specs[1] = height>>1;
			specs[2] = width; specs[3] = width>>1;
			break;
		case 2 :
			specs[0] = height; specs[1] = height;
			specs[2] = width; specs[3] = width>>1;
			break;
		default :
			specs[0] = height; specs[1] = height;
			specs[2] = width; specs[3] = width;
			break;
	}
	allocSpace(specs);
}

void PlanarFrame::createFromProfile(VideoInfo &viInfo)
{
	allocSpace(viInfo);
}

void PlanarFrame::createFromFrame(PVideoFrame &frame,VideoInfo &viInfo)
{
	allocSpace(viInfo);
	copyInternalFrom(frame,viInfo);
}

void PlanarFrame::createFromPlanar(PlanarFrame &frame)
{
	int specs[4] = {frame.yheight,frame.uvheight,frame.ywidth,frame.uvwidth};
	allocSpace(specs);
	copyInternalFrom(frame);
}

void PlanarFrame::copyFrom(PVideoFrame &frame,VideoInfo &viInfo)
{
	copyInternalFrom(frame,viInfo);
}

void PlanarFrame::copyFrom(PlanarFrame &frame)
{
	copyInternalFrom(frame);
}

void PlanarFrame::copyTo(PVideoFrame &frame,VideoInfo &viInfo)
{
	copyInternalTo(frame,viInfo);
}

void PlanarFrame::copyTo(PlanarFrame &frame)
{
	copyInternalTo(frame);
}

void PlanarFrame::copyPlaneTo(PlanarFrame &frame,uint8_t plane)
{
	copyInternalPlaneTo(frame,plane);
}

uint8_t* PlanarFrame::GetPtr(uint8_t plane)
{
	switch(plane)
	{
		case 0 : return y; break;
		case 1 : return u; break;
		default : return v; break;
	}
}

int PlanarFrame::GetWidth(uint8_t plane)
{
	switch(plane)
	{
		case 0 : return ywidth; break;
		default : return uvwidth; break;
	}
}

int PlanarFrame::GetHeight(uint8_t plane)
{
	switch(plane)
	{
		case 0 : return yheight; break;
		default : return uvheight; break;
	}
}

int PlanarFrame::GetPitch(uint8_t plane)
{
	switch(plane)
	{
		case 0 : return ypitch; break;
		default : return uvpitch; break;
	}
}

void PlanarFrame::freePlanar()
{
	if (y != NULL) { _aligned_free(y); y = NULL; }
	if (u != NULL) { _aligned_free(u); u = NULL; }
	if (v != NULL) { _aligned_free(v); v = NULL; }
	ypitch = uvpitch = 0;
	ywidth = uvwidth = 0;
	yheight = uvheight = 0;
	cpu = 0;
}

void PlanarFrame::copyInternalFrom(PVideoFrame &frame,VideoInfo &viInfo)
{
	if ((y==NULL) || (!viInfo.IsY8() && ((u==NULL) || (v==NULL)))) return;

	if (viInfo.IsYV12() || viInfo.IsYV16() || viInfo.IsYV24())
	{
		BitBlt(y,ypitch,frame->GetReadPtr(PLANAR_Y),frame->GetPitch(PLANAR_Y), 
			frame->GetRowSize(PLANAR_Y),frame->GetHeight(PLANAR_Y));
		BitBlt(u,uvpitch,frame->GetReadPtr(PLANAR_U),frame->GetPitch(PLANAR_U), 
			frame->GetRowSize(PLANAR_U),frame->GetHeight(PLANAR_U));
		BitBlt(v,uvpitch,frame->GetReadPtr(PLANAR_V),frame->GetPitch(PLANAR_V), 
			frame->GetRowSize(PLANAR_V),frame->GetHeight(PLANAR_V));	
	}
	else
	{
		if (viInfo.IsY8())
		{
			BitBlt(y,ypitch,frame->GetReadPtr(PLANAR_Y),frame->GetPitch(PLANAR_Y), 
				frame->GetRowSize(PLANAR_Y),frame->GetHeight(PLANAR_Y));
		}
		else
		{
			if (viInfo.IsYUY2())
			{
				convYUY2to422(frame->GetReadPtr(),y,u,v,frame->GetPitch(),ypitch,uvpitch,
					viInfo.width,viInfo.height);
			}
			else
			{
				if (viInfo.IsRGB24())
				{
					convRGB24to444(frame->GetReadPtr(),y,u,v,frame->GetPitch(),ypitch,uvpitch,
						viInfo.width,viInfo.height);
				}
			}
		}
	}
}

void PlanarFrame::copyInternalFrom(PlanarFrame &frame)
{
	if ((y==NULL) || ((uvpitch!=0) && ((u==NULL) || (v==NULL)))) return;

	BitBlt(y,ypitch,frame.y,frame.ypitch,frame.ywidth,frame.yheight);
	if (uvpitch!=0)
	{
		BitBlt(u,uvpitch,frame.u,frame.uvpitch,frame.uvwidth,frame.uvheight);
		BitBlt(v,uvpitch,frame.v,frame.uvpitch,frame.uvwidth,frame.uvheight);
	}
}

void PlanarFrame::copyInternalTo(PVideoFrame &frame,VideoInfo &viInfo)
{
	if ((y==NULL) || (!viInfo.IsY8() && ((u==NULL) || (v==NULL)))) return;

	if (viInfo.IsYV12() || viInfo.IsYV16() || viInfo.IsYV24())
	{
		BitBlt(frame->GetWritePtr(PLANAR_Y),frame->GetPitch(PLANAR_Y),y,ypitch,ywidth,yheight);
		BitBlt(frame->GetWritePtr(PLANAR_U),frame->GetPitch(PLANAR_U),u,uvpitch,uvwidth,uvheight);
		BitBlt(frame->GetWritePtr(PLANAR_V),frame->GetPitch(PLANAR_V),v,uvpitch,uvwidth,uvheight);	
	}
	else
	{
		if (viInfo.IsY8())
		{
			BitBlt(frame->GetWritePtr(PLANAR_Y),frame->GetPitch(PLANAR_Y),y,ypitch,ywidth,yheight);
		}
		else
		{
			if (viInfo.IsYUY2())
			{
				conv422toYUY2(y,u,v,frame->GetWritePtr(),ypitch,uvpitch,frame->GetPitch(),ywidth,yheight);
			}
			else
			{
				if (viInfo.IsRGB24())
				{
					conv444toRGB24(y,u,v,frame->GetWritePtr(),ypitch,uvpitch,frame->GetPitch(),ywidth,yheight);
				}
			}
		}
	}
}

void PlanarFrame::copyInternalTo(PlanarFrame &frame)
{
	if ((y==NULL) || ((uvpitch!=0) && ((u==NULL) || (v==NULL)))) return;

	BitBlt(frame.y,frame.ypitch,y,ypitch,ywidth,yheight);
	if (uvpitch!=0)
	{
		BitBlt(frame.u,frame.uvpitch,u,uvpitch,uvwidth,uvheight);
		BitBlt(frame.v,frame.uvpitch,v,uvpitch,uvwidth,uvheight);
	}
}

void PlanarFrame::copyInternalPlaneTo(PlanarFrame &frame,uint8_t plane)
{
	switch(plane)
	{
		case 0 : if (y!=NULL) BitBlt(frame.y,frame.ypitch,y,ypitch,ywidth,yheight); break;
		case 1 : if (u!=NULL) BitBlt(frame.u,frame.uvpitch,u,uvpitch,uvwidth,uvheight); break;
		case 2 : if (v!=NULL) BitBlt(frame.v,frame.uvpitch,v,uvpitch,uvwidth,uvheight); break;
	}
}

void PlanarFrame::copyChromaTo(PlanarFrame &dst)
{
	if (uvpitch!=0)
	{
		BitBlt(dst.u,dst.uvpitch,u,uvpitch,dst.uvwidth,dst.uvheight);
		BitBlt(dst.v,dst.uvpitch,v,uvpitch,dst.uvwidth,dst.uvheight);
	}
}


PlanarFrame& PlanarFrame::operator=(PlanarFrame &ob2)
{
	cpu = ob2.cpu;
	ypitch = ob2.ypitch;
	yheight = ob2.yheight;
	ywidth = ob2.ywidth;
	uvpitch = ob2.uvpitch;
	uvheight = ob2.uvheight;
	uvwidth = ob2.uvwidth;
	this->copyFrom(ob2);
	return *this;
}

void PlanarFrame::convYUY2to422(const uint8_t *src,uint8_t *py,uint8_t *pu,uint8_t *pv,int pitch1,int pitch2Y,int pitch2UV,
	int width,int height)
{
	if (((cpu&CPU_SSE2)!=0) && useSIMD && (((size_t(src)|pitch1)&15)==0))
		convYUY2to422_SSE2(src,py,pu,pv,pitch1,pitch2Y,pitch2UV,width,height);
	else
	{
		if (((cpu&CPU_MMX)!=0) && useSIMD) convYUY2to422_MMX(src,py,pu,pv,pitch1,pitch2Y,pitch2UV,width,height);
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


void PlanarFrame::conv422toYUY2(uint8_t *py,uint8_t *pu,uint8_t *pv,uint8_t *dst,int pitch1Y,int pitch1UV,int pitch2,
	int width,int height)
{
	if (((cpu&CPU_SSE2)!=0) && useSIMD && ((size_t(dst)&15)==0))
		conv422toYUY2_SSE2(py,pu,pv,dst,pitch1Y,pitch1UV,pitch2,width,height);
	else
	{
		if (((cpu&CPU_MMX)!=0) && useSIMD) conv422toYUY2_MMX(py,pu,pv,dst,pitch1Y,pitch1UV,pitch2,width,height);
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

void PlanarFrame::BitBlt(uint8_t *dstp,int dst_pitch,const uint8_t *srcp,int src_pitch,int row_size,int height) 
{
	if ((height==0) || (row_size==0) || (dst_pitch==0) || (src_pitch==0)) return;

	if (((cpu&CPU_ISSE)!=0) && useSIMD) 
	{
		if ((height==1) || ((src_pitch==dst_pitch) && (dst_pitch==row_size))) memcpy_amd(dstp,srcp,row_size*height);
		else asm_BitBlt_ISSE(dstp,dst_pitch,srcp,src_pitch,row_size,height);
	}
	else
	{
		if ((height==1) || ((dst_pitch==src_pitch) && (src_pitch==row_size))) memcpy(dstp,srcp,src_pitch*height);
		else 
		{
			for (int y=height; y>0; --y)
			{
				memcpy(dstp,srcp,row_size);
				dstp+=dst_pitch;
				srcp+=src_pitch;
			}
		}
	}
}

  /*****************************
  * Assembler bitblit by Steady
   *****************************/

extern "C" void asm_BitBlt_ISSE_1(const uint8_t *srcStart,uint8_t *dstStart,int row_size,int height,
	int src_pitch,int dst_pitch);
extern "C" void asm_BitBlt_ISSE_2(const uint8_t *srcStart,uint8_t *dstStart,int row_size,int height,
	int src_pitch,int dst_pitch);
extern "C" void asm_BitBlt_ISSE_3(const uint8_t *srcStart,uint8_t *dstStart,int row_size,int height,
	int src_pitch,int dst_pitch);


void PlanarFrame::asm_BitBlt_ISSE(uint8_t *dstp,int dst_pitch,const uint8_t *srcp,int src_pitch,int row_size,int height) 
{
	if ((row_size==0) || (height==0) || (dst_pitch==0) || (src_pitch==0)) return;

	const uint8_t *srcStart=srcp+src_pitch*(height-1);
	uint8_t *dstStart=dstp+dst_pitch*(height-1);

	if(row_size<64) 
	{
		asm_BitBlt_ISSE_1(srcStart,dstStart,row_size,height,src_pitch,dst_pitch);
	}
	else
	{
		if (((size_t(dstp)|row_size|src_pitch|dst_pitch)&7)!=0) 
		{
			asm_BitBlt_ISSE_2(srcStart,dstStart,row_size,height,src_pitch,dst_pitch);
		}
		else 
		{
			asm_BitBlt_ISSE_3(srcStart,dstStart,row_size,height,src_pitch,dst_pitch);
		}
	}
}