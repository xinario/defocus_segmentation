% lbpSharpness -- sharpness metric proposed as Eq.(15) in the paper.
%   Paras:
%   @im        : Input grayscale image. must be of type uint8
%   @s         : Patch size as of a given scale.
%   @threshold : threshold for creating the lbp code.
%   Author: Xin Yi (xiy525@mail.usask.ca)
%   Date  : 02/01/2016
function sharpnessMap = lbpSharpness(im, s, threshold)

if (size(im,3)==3)
    im_gray = rgb2gray(im);
else
    im_gray = im;
end

[height, width, ~] = size(im);

window_r = (s-1)/2;

num = s^2;

lbpmap = lbpCode(im_gray,threshold*255);

lbp_map_pad = padarray(lbpmap,[window_r,window_r],'replicate');

% naive implementation
map = zeros(height,width);
for j = 1:height
    for i = 1:width
        lbpmap_patch = lbp_map_pad(j:j+s-1,i:i+s-1);
        temp = (lbpmap_patch>=6);
        map(j,i) = sum(temp(:))/num;
        
        
    end
end


sharpnessMap = normPatch(map);
