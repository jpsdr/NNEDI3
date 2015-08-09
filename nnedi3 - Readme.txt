                                                                                                    |
                                nnedi3 for Avisynth by tritical                                     |
                                       modified by JPSDR                                            |
                                     v0.9.4.15 (09/08/2015)                                          |
                                           HELP FILE                                                |
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


INFO:

      nnedi3 is an intra-field only deinterlacer. It takes in a frame, throws away one field, and
   then interpolates the missing pixels using only information from the kept field. It has same
      rate and double rate modes, and works with YV12, YV411, YV16, YV24, Y8, YUY2, and RGB24 input.
       nnedi3 is also very good for enlarging images by powers of 2, and includes a function
                                  'nnedi3_rpow2' for that purpose.


  Syntax =>

    nnedi3(int field, bool dh, bool Y, bool U, bool V, int nsize, int nns, int qual, int etype,
           int pscrn, int threads, int opt, int fapprox)

    nnedi3_rpow2(int rfactor, int nsize, int nns, int qual, int etype, int pscrn, string cshift,
                 int fwidth, int fheight, float ep0, float ep1, int threads, int opt, int fapprox,
                 bool mpeg2)



PARAMETERS (nnedi3):


   field -

      Controls the mode of operation (double vs same rate) and which field is kept.
      Possible settings:

         -2 = double rate (alternates each frame), uses avisynth's internal parity value to start
         -1 = same rate, uses avisynth's internal parity value
          0 = same rate, keep bottom field
          1 = same rate, keep top field
          2 = double rate (alternates each frame), starts with bottom
          3 = double rate (alternates each frame), starts with top

      If field is set to -1, then nnedi3 calls child->GetParity(0) during initialization.
      If it returns true, then field is set to 1. If it returns false, then field is set to 0.
      If field is set to -2, then the same thing happens, but instead of setting field to 1
      or 0 it is set to 3 or 2.

      Default:  -1  (int)


   dh -

      Doubles the height of the input. Each line of the input is copied to every other line
      of the output and the missing lines are interpolated. If field=0, the input is copied
      to the odd lines of the output. If field=1, the input is copied to the even lines of
      the output. field must be set to either -1, 0, or 1 when using dh=true.

      Default:  false  (int)


   Y, U, V -

      These control whether or not the specified plane is processed. Set to true to
      process or false to ignore. Ignored planes are not copied, zero'd, or even
      considered. So what the ignored planes happen to contain on output is unpredictable.
      For RGB24 input Y=B, U=G, V=R.

      Default:  Y = true  (bool)
                U = true  (bool)
                V = true  (bool)


   nsize -

      Sets the size of the local neighborhood around each pixel that is used by the predictor
      neural network. Possible settings (x_diameter x y_diameter):

          0 -   8x6
          1 -  16x6
          2 -  32x6
          3 -  48x6
          4 -   8x4
          5 -  16x4
          6 -  32x4

      For image enlargement it is recommended to use 0 or 4. Larger y_diameter settings
      will result in sharper output. For deinterlacing larger x_diameter settings will
      allow connecting lines of smaller slope. However, what setting to use really
      depends on the amount of aliasing (lost information) in the source. If the source was
      heavily low-pass filtered before interlacing then aliasing will be low and a large
      x_diameter setting wont be needed, and vice versa.

      Default:  6  (int)


   nns -

      Sets the number of neurons in the predictor neural network. Possible settings are
      0, 1, 2, 3, and 4. 0 is fastest. 4 is slowest, but should give the best quality. This
      is a quality vs speed option; however, differences are usually small. The difference
      in speed will become larger as 'qual' is increased.

         0 - 16
         1 - 32
         2 - 64
         3 - 128
         4 - 256

      Default:  1  (int)


   qual -

      Controls the number of different neural network predictions that are blended together
      to compute the final output value. Each neural network was trained on a different set
      of training data. Blending the results of these different networks improves generalization
      to unseen data. Possible values are 1 or 2. Essentially this is a quality vs speed
      option. Larger values will result in more processing time, but should give better results.
      However, the difference is usually pretty small. I would recommend using qual>1 for
      things like single image enlargement.

      Default:  1  (int)


   etype -

      Controls which set of weights to use in the predictor nn. Possible settings:

           0 - weights trained to minimize absolute error
           1 - weights trained to minimize squared error

      Default:  0  (int)


   pscrn -

      Controls whether or not the prescreener neural network is used to decide which pixels
      should be processed by the predictor neural network and which can be handled by simple
      cubic interpolation. The prescreener is trained to know whether cubic interpolation
      will be sufficient for a pixel or whether it should be predicted by the predictor nn.
      The computational complexity of the prescreener nn is much less than that of the predictor
      nn. Since most pixels can be handled by cubic interpolation, using the prescreener
      generally results in much faster processing. The prescreener is pretty accurate, so the
      difference between using it and not using it is almost always unnoticeable.

      Version 0.9.3 adds a new, faster prescreener with three selectable 'levels', which
      trade off the number of pixels detected as only requiring cubic interpolation versus
      incurred error. Therefore, pscrn is now an integer with possible values of 0, 1, 2, 3,
      and 4.

         0 - no prescreening (same as false in prior versions)
         1 - original prescreener (same as true in prior versions)
         2 - new prescreener level 0
         3 - new prescreener level 1
         4 - new prescreener level 2

          ** Higher levels for the new prescreener result in cubic interpolation being
             used on fewer pixels (so are slower, but incur less error). However, the
             difference is pretty much unnoticable. Level 2 is closest to the original
             prescreener in terms of incurred error, but is much faster.
        
      Default:  2  (int)


   threads -

      Controls how many threads will be used for processing. If set to 0, threads will
      be set equal to the number of detected processors.

      Default:  0  (int)


   opt -

      Sets which cpu optimizations to use. Possible settings:

         0 = auto detect
         1 = use c
         2 = use sse2

        ** for an older version supporting sse use v0.9.1 available at:
        **    http://bengal.missouri.edu/~kes25c/old_stuff/

      Default:  0 (int)


   fapprox -

      Bitmask which enables or disables certain speed-ups. Value range is [0,15].
      Mainly for debugging.

           0 = nothing
          &1 = use int16 dot products in first layer of prescreener nn
          &2 = use int16 dot products in predictor nn
  &12 =    4 = use exp function approximation in predictor nn
  &12 = 8|12 = use faster (and more inaccurate) exp function approximation in predictor nn

      Default:  15 (int)



PARAMETERS (nnedi3_rpow2):


   rfactor -

      Image enlargement factor. Must be a power of 2 in the range [2,1024].

      Default:  not set  (int)


   cshift -

      Sets the resizer used for correcting the image center shift that nnedi3_rpow2
      introduces. This can be any of Avisynth's internal resizers, such as "spline36resize",
      "lanczosresize", etc... If not specified the shift is not corrected. The correction
      is accomplished by using the subpixel cropping capability of Avisynth's internal
      resizers.

      Default:  not set  (string)


   fwidth/fheight -
   
      If correcting the image center shift by using the 'cshift' parameter, fwidth/fheight
      allow you to set a new output resolution. First, the image is enlarged by 'rfactor'
      using nnedi3. Once that is completed the image center shift is corrected, and the
      image is resampled to fwidth x fheight resolution. The shifting and resampling
      happen in one call using the internal Avisynth resizer you specify via the 'cshift'
      string. If fwidth/fheight are not specified, then they are set equal to rfactor*width
      and rfactor*height respectively (in other words they do nothing).

      Default:  not set  (int)
                not set  (int)


   ep0/ep1 -

      Some Avisynth resizers take optional arguments, such as 'taps' for lanczosresize or
      'p' for gaussresize. ep0/ep1 allow you to pass values for these optional arguments
      when using the 'cshift' parameter. If the resizer only takes one optional argument
      then ep0 is used. If the argument that the resizer takes is not a float value,
      then ep0 gets rounded to an integer. If the resizer takes two optional arguments,
      then ep0 corresponds to the first one, and ep1 corresponds to the second. The only
      resizer that takes more than one optional argument is bicubicresize(), which takes
      'b' and 'c'. So ep0 = b, and ep1 = c. If ep0/ep1 are not set then the default value
      for the optional argument(s) of the resizer is used.

      Default:  not set  (float)
                not set  (float)


   nsize/nns/qual/etype/pscrn/threads/opt/fapprox -

      Same as corresponding parameters in nnedi3. However, nnedi3_rpow2 uses nsize=0 and
      nns=3 by default (versus nsize=6 and nns=1 in nnedi3()).
      
   mpeg2
     
      Specify chroma alignment for YV12. If true, chroma subsampling follow MPEG-2
      alignment, and a shift correction is made on the chroma according the resize.
      If false, chroma subsampling for YV12 is MPEG-1, and so no shift is made.
      To keep previous behavior by default, false also don't shift chroma on YV16,
      even if YV16 always have MPEG-2 chroma subsampling.
      
      Default: False



nnedi3_rpow2 EXAMPLES:


   a.) enlarge image by 4x, don't correct for center shift.

          nnedi3_rpow2(rfactor=4)


   b.) enlarge image by 2x, correct for center shift using spline36resize.

          nnedi3_rpow2(rfactor=2,cshift="spline36resize")


   c.) enlarge image by 8x, correct for center shift and downsample from
       8x to 7x using lanczosresize with 5 taps.

          nnedi3_rpow2(rfactor=8,cshift="lanczosresize",fwidth=width*7,fheight=height*7,ep0=5)



CHANGE LIST:
   09/08/2015  v0.9.4.15

       + Change default value of mpeg2 to false, and keep exact
         previous behavior in that case (but doesn't put back chroma shift issue ^_^).

   09/08/2015  v0.9.4.14

       + Add resize adjustment chroma shift in case of MPEG-2 subsampling.
       + Faster RGB24 mode always.
       + Add mpeg2 parameter.

   08/08/2015  v0.9.4.13

       + Correction of chroma shift once for all this time.
       + Faster RGB24 mode if FTurn is usable.
       + Fix YV411 support.

   06/08/2015  v0.9.4.12

       + More checks on use of FTurn.
       + Fix regression on YUY2 introduced in previous release.

   31/07/2015  v0.9.4.11

       + Correction of chroma shift value for 4:2:x color modes.
       + Add YV411 support.

   25/05/2015  v0.9.4.10

       + Integration of commits coming from Vapoursynth version, thanks to Myrsloik.

   10/05/2015  v0.9.4.9

       + Bug correction in x64 ASM file, thanks to jackoneill and HolyWu.

   13/03/2015  v0.9.4.8

       + Update to last AVS+ header files.

   26/01/2014  v0.9.4.7

       + Little correction in YV24 and Y8 support for nnedi3_rpow2.

   17/01/2014  v0.9.4.6

       + Little YV16 optimization.

   16/01/2014  v0.9.4.5

       * Updated YV16 support for nnedi3_rpow2, now fast and direct, not tweaked by going to YUY2.

   15/01/2014  v0.9.4.4

       + Some few little optimizations.
       * Trick YV16 support in nnedi3_rpow2 by working internaly in YUY2 mode to speed-up.

   14/01/2014  v0.9.4.3

       + Add fturn support.

   13/01/2014  v0.9.4.2

       + Add Y8, YV16 and YV24 support.

   03/01/2014  v0.9.4.1

       + Move out all inline ASM code in external files, update code to build x64 version.
       + Update interface to new avisynth 2.6 API.
       - Avisynth 2.5.x not supported anymore.

End of Tritical version
------------------------------------------------------------------------
   06/10/2011  v0.9.4

       + some more optimizations + more aggressive new prescreener levels

   06/06/2011  v0.9.3

       + added new prescreener. Changed 'pscrn' parameter from bool to integer.
       + added 'etype' parameter and merged abs/squared weights into one binary

   09/22/2010  v0.9.2

       + clean up and release source code
       + speed improvements - (thanks Loren Merritt - akupenguin - for many ideas and code)
            int16 dot products in prescreener/predictor neural networks
            faster exp function approximation
            mean removal factored into weights
            lots of smaller changes
       + new prediction nn weights for certain nsize/nns combinations
       + added fapprox parameter
       - fixed bug with border mirroring
       - dropped support for sse/mmx - all asm code requires sse2. changed opt parameter
           accordingly.

   07/15/2010  v0.9.1

       + add nsize=5/6 (16x4,32x4)
       + add nns=0 (16 neurons). nns 0/1/2/3 from v0.9 are now 1/2/3/4.
       - new defaults. nnedi3: nsize=6,nns=1. nnedi3_rpow2: nns=3.
       - fix field=0/1 flipped with rgb24 input

   06/10/2009  v0.9

       + First official release
       - adds nns=0 (32 neurons). nns 0/1/2 from previous beta are now 1/2/3.
       - adds nsize=4 (8x4).
       - different nns/nsize defaults for nnedi3_rpow2() vs nnedi3()
       - change setcachehints call



                         contact:    doom9.org forum (nick = tritical)
