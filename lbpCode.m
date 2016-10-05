% lbpCode -- 8bit rorational invariant uniform lbp.
%   Paras:
%   @im        : Input grayscale image. must be of type uint8
%   @threshold         : %threshold is the T_lbp mentioned in the paper
function out = lbpCode(I, threshold)
interpOff = sqrt(2)/2;
I = double(I);

P = padarray(I, [1 1], 'replicate');

% Entry (i,j) of this matrix contains the pixel to the
% right of (i,j) in I.
right = P(2:end-1, 3:end);

% Meanings of these are similar to that of 'right', above.
left = P(2:end-1, 1:end-2);
above = P(1:end-2, 2:end-1);
below = P(3:end, 2:end-1);
aboveRight = P(1:end-2, 3:end);
aboveLeft = P(1:end-2, 1:end-2);
belowRight = P(3:end, 3:end);
belowLeft = P(3:end, 1:end-2);

% Entry (i,j) of interpK contains the interpolated value of g_k for
% pixel (i,j) of the original image.
interp0 = right;
interp1 = (1-interpOff)*((1-interpOff) .* I + interpOff .* right) + interpOff *((1-interpOff) .* above + interpOff .* aboveRight);
interp2 = above;
interp3 = (1-interpOff)*((1-interpOff) .* I + interpOff .* left ) + interpOff *((1-interpOff) .* above + interpOff .* aboveLeft);
interp4 = left;
interp5 = (1-interpOff)*((1-interpOff) .* I + interpOff .* left ) + interpOff *((1-interpOff) .* below + interpOff .* belowLeft);
interp6 = below;
interp7 = (1-interpOff)*((1-interpOff) .* I + interpOff .* right ) + interpOff *((1-interpOff) .* below + interpOff .* belowRight);



interp0 = floor(interp0);
interp1 = floor(interp1);
interp2 = floor(interp2);
interp3 = floor(interp3);
interp4 = floor(interp4);
interp5 = floor(interp5);
interp6 = floor(interp6);
interp7 = floor(interp7);
% Image s_k at (i,j) contains the bit for g_k at (i,j)
s0 = s(interp0 - I-threshold);
s1 = s(interp1 - I-threshold);
s2 = s(interp2 - I-threshold);
s3 = s(interp3 - I-threshold);
s4 = s(interp4 - I-threshold);
s5 = s(interp5 - I-threshold);
s6 = s(interp6 - I-threshold);
s7 = s(interp7 - I-threshold);




% Compute the uniformity.
U = abs(s0 - s7) + ...
    abs(s1 - s0) + ...
    abs(s2 - s1) + ...
    abs(s3 - s2) + ...
    abs(s4 - s3) + ...
    abs(s5 - s4) + ...
    abs(s6 - s5) + ...
    abs(s7 - s6);

% Compute number of bits in each LBP.  For the uniform
% patterns this is the correct pattern id.
LBP81riu2 = s0 + s1 + s2 + s3 + s4 + s5 + s6 + s7;

% If the pattern is not uniform, replace the bit count
% with 9, to indicate a non-uniform pattern.
LBP81riu2(U > 2) = 9;


out = LBP81riu2;
end

function sVal = s(x)
sVal = x >0;
end

