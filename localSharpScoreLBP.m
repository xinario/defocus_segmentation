%   localSharpScoreLBP -- compute sharpness score after matting 
%   as of Eq.(18) in the paper.
%   Paras:
%   @im        : Input grayscale image. must be of type uint8
%   @s         : Patch size as of a given scale.
%   @threshold : Threshold for creating the lbp code.
%   Author: Xin Yi (xiy525@mail.usask.ca)
%   Date  : 07/01/2015
%   Version : 1.0

function blurScore = localSharpScoreLBP(im, s, threshold)
%comment out the following line to use .mex version
%matlab version
lbp = lbpSharpness(im, s, threshold);

%uncomment the following line to use .mex version
%mex version
% lbp = cv.lbpSharpness(im, s, threshold);
% lbp = im2double(lbp);


%**************************************************************************
% creating the mask
%**************************************************************************
%double thresholding Eq.(21)
T_m1 = 0.3;

T_m2 = 0.01;

%bkg
bkg_bw = im2bw(1 - normPatch(lbp), 1-T_m2);

%obj
obj_bw = im2bw(normPatch(lbp), T_m1);




%I and mI are all of type double
I = im2double(im);
mI = I;
mI_R = mI(:,:,1);
mI_G = mI(:,:,2);
mI_B = mI(:,:,3);

%foreground
mI_R(obj_bw == 1) = 1;
mI_G(obj_bw == 1) = 1;
mI_B(obj_bw == 1) = 1;
%background
mI_R(bkg_bw == 1) = 0;
mI_G(bkg_bw == 1) = 0;
mI_B(bkg_bw == 1) = 0;

mI(:,:,1) = mI_R;
mI(:,:,2) = mI_G;
mI(:,:,3) = mI_B;


% %**************************************************************************
% % image matting
% %**************************************************************************
levels_num = 3;
active_levels_num = 1;
thr_alpha = [];
epsilon = [];
win_size = [];



consts_map = sum(abs(I-mI),3) > 0.001;
if (size(I,3)== 3)
    consts_vals = rgb2gray(mI).*consts_map;
end
if (size(I,3) == 1)
    consts_vals = mI.*consts_map;
end



alpha = solveAlphaC2F(I,consts_map,consts_vals,levels_num, ...
    active_levels_num,thr_alpha,epsilon,win_size);



alpha(alpha < 0) = 0;

alpha(alpha > 1) = 1;

blurScore = alpha;


