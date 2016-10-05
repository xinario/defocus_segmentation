/**
 * @file lbpSharpness.cpp
 * @brief mex interface for lbpSharpness
 * @author Xin Yi
 * @date 2016
 */
#include "mexopencv.hpp"
using namespace std;
using namespace cv;

uchar sign(uchar a, uchar b, double thresh) {
    if ((a - b) > uchar(thresh*255))
        return 1;
    else
        return 0;
}


Mat_<uchar> lbpCode(const Mat_< uchar >& gray, double thresh) {
    int h = gray.rows;
    int w = gray.cols;
    int border = 1;
    Mat_<uchar> lbp_map( gray.size() );
    //    lbp_map.setTo(0);
    Mat_<uchar> gray_pad(cvSize(h+border, w+border));
    
    
    copyMakeBorder(gray, gray_pad, border, border,
            border, border, BORDER_REPLICATE);
    for(int j=border;j<=h+border-1;j++) {
        for(int i=border;i<=w+border-1;i++) {
            
            uchar gc = gray_pad.at<uchar>(j,i);
            uchar g0 = gray_pad.at<uchar>(j,i+1);
            uchar g2 = gray_pad.at<uchar>(j-1,i);
            uchar g4 = gray_pad.at<uchar>(j,i-1);
            uchar g6 = gray_pad.at<uchar>(j+1,i);
            uchar tr = gray_pad.at<uchar>(j-1,i+1);
            uchar tl = gray_pad.at<uchar>(j-1,i-1);
            uchar dl = gray_pad.at<uchar>(j+1,i-1);
            uchar dr = gray_pad.at<uchar>(j+1,i+1);
            uchar g1=(1-sqrt(2)/2)*(sqrt(2)/2*g0+(1-sqrt(2)/2)*gc)+sqrt(2)/2*(sqrt(2)/2*tr+(1-sqrt(2)/2)*g2);
            uchar g3=(1-sqrt(2)/2)*(sqrt(2)/2*g4+(1-sqrt(2)/2)*gc)+sqrt(2)/2*(sqrt(2)/2*tl+(1-sqrt(2)/2)*g2);
            uchar g5=(1-sqrt(2)/2)*(sqrt(2)/2*g4+(1-sqrt(2)/2)*gc)+sqrt(2)/2*(sqrt(2)/2*dl+(1-sqrt(2)/2)*g6);
            uchar g7=(1-sqrt(2)/2)*(sqrt(2)/2*g0+(1-sqrt(2)/2)*gc)+sqrt(2)/2*(sqrt(2)/2*dr+(1-sqrt(2)/2)*g6);
            uchar code = 0;
            
            uchar uniformity = abs(sign(g7,gc,thresh)-sign(g0,gc,thresh))+abs(sign(g1,gc,thresh)-sign(g0,gc,thresh))+
                    abs(sign(g2,gc,thresh)-sign(g1,gc,thresh))+abs(sign(g3,gc,thresh)-sign(g2,gc,thresh))+
                    abs(sign(g4,gc,thresh)-sign(g3,gc,thresh))+abs(sign(g5,gc,thresh)-sign(g4,gc,thresh))+
                    abs(sign(g6,gc,thresh)-sign(g5,gc,thresh))+abs(sign(g7,gc,thresh)-sign(g6,gc,thresh));
            
            if (uniformity <=2)
                code = sign(g0,gc,thresh)+sign(g1,gc,thresh)+sign(g2,gc,thresh)+sign(g3,gc,thresh)+sign(g4,gc,thresh)+sign(g5,gc,thresh)+sign(g6,gc,thresh)+sign(g7,gc,thresh);
            else
                code = 9;
            lbp_map.at<uchar>(j-border,i-border) = code;
        }
    }

    return lbp_map;
}




Mat_<uchar> lbpSharpMap(const Mat& im, double scale) {
    int h = im.rows;
    int w = im.cols;
    double border = (scale-1)/2.0;
    Mat_<double> blur_map( im.size() );
    Mat_<uchar> im_pad(cvSize(h + 2*border, w + 2*border));
    
    copyMakeBorder(im, im_pad, border, border,
            border, border, BORDER_REPLICATE);
    

    Mat mask = (im_pad >=6);
    
    
    mask.convertTo(mask, CV_64F);
    
    Mat integral_mask;
    integral(mask, integral_mask,CV_64F);
    
    double count = pow(scale, 2);
    for(int j=0;j<=h-1;j++) {
        for(int i=0;i<=w-1;i++) {
            blur_map.at<double>(j,i) = (integral_mask.at<double>(j+scale-1,i+scale-1) - integral_mask.at<double>(j,i+scale-1) - integral_mask.at<double>(j+scale-1,i) + integral_mask.at<double>(j,i))/count;
        }
    }
    
    Mat_<uchar> temp( im.size() );
    normalize(blur_map, temp, 0, 255, NORM_MINMAX, CV_8UC1);
    return temp;
}

/**
 * Main entry called from Matlab
 * @param nlhs number of left-hand-side arguments
 * @param plhs pointers to mxArrays in the left-hand-side
 * @param nrhs number of right-hand-side arguments
 * @param prhs pointers to mxArrays in the right-hand-side
 */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[] )
{
    // Check the number of arguments
    if (nrhs<1 ||  nlhs>2)
        mexErrMsgIdAndTxt("mexopencv:error","Wrong number of arguments");
    
    // Argument vector
    vector<MxArray> rhs(prhs,prhs+nrhs);
    
    // Option processing
    double scale;
    double threshhold;
//     double senstivity;
    for (int i=1; i<nrhs; i+=1) {
        if (i == 1)
            scale = rhs[i].toDouble();
        else if (i == 2)
            threshhold = rhs[i].toDouble();
    }
    
    
    
    
    // Process
    Mat src(rhs[0].toMat()), dst;
    
    Mat im_gray, lbp;
    
    cvtColor(src, im_gray, CV_BGR2GRAY);
    
    lbp = lbpCode(im_gray, threshhold);
    
    dst = lbpSharpMap(lbp,scale);
    
    plhs[0] = MxArray(dst);
}
