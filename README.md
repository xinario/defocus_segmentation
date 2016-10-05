This package contains an implementation of the defocus segmentation algorithm described in the paper:

>Xin Yi, Mark Eramian, *LBP-based segmentation of defocus blur*:
IEEE transaction on image processing 2016. 


The alpha matting code comes from Levin, 2006:

>A. Levin D. Lischinski and Y. Weiss. *A Closed Form Solution to Natural Image Matting*. 
IEEE Conf. on Computer Vision and Pattern Recognition (CVPR), June 2006, New York.

Please download it from its [project page](http://www.wisdom.weizmann.ac.il/~levina/matting.tar.gz).
Once you have downloaded the matting code, copy the following functions into the project folder

- downSmpIm.m
- getLaplacian1.m
- getLinearCoeff.m
- solveAlpha.m
- solveAlphaC2F.m
- upSampleAlphaUsingImg.m
- upSmpIm.m



The multi-scale inference code was adopted form Jianping Shi, 2014:

>Jianping Shi, Li Xu, Jiaya Jia. *Discriminative Blur Detection Features*.
IEEE Conference on Computer Vision and Pattern Recognition, 2014. 
You can also download it from its [project page](http://www.cse.cuhk.edu.hk/~leojia/projects/dblurdetect/index.html).

Note that the code to create adjancent matrix was modified to remove the boundary effect.
Please see demo.m for an example implementation of how to use the
provided functions. 


## How to
Compute the LBP-based sharpness measure using the mex version.

1. Install [mexopencv](https://github.com/kyamagu/mexopencv)

2. Copy lbpSharpness.cpp to <your mexopencv folder>/src/+cv 

3. Run mexopencv.make() in Matlab command line to compile the provided function.

4. Comment out line 14 and uncomment line 18, 19 in localSharpScoreLBP.m, then you are good to go.

Note that all the results reported in the paper were produced by the mex verison of LBP-based sharpness.


This code is released only for non-commercial research
use. Please cite the above paper if you use this code to generate any
results included in an academic publication.
Xin Yi, xiy525@mail.usask.ca, Feb 2016

 












