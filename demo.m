clc;clear;
addpath('./UGM');

im = imread('./images/out_of_focus0088.jpg');


s1 = 11;        % patch size for scale 1
s2 = 15;        % patch size for scale 2
s3 = 21;        % patch size for scale 3

alphaval = 0.5;    % weight for multiscale inference


blurSensitivity = 0.016;  %T_lbp


fprintf('Extracting scale 1 feature...\n');
feature.scale1 = localSharpScoreLBP(im, s1, blurSensitivity);
fprintf('Extracting scale 2 feature...\n');
feature.scale2 = localSharpScoreLBP(im, s2, blurSensitivity);
fprintf('Extracting scale 3 feature...\n');
feature.scale3 = localSharpScoreLBP(im, s3, blurSensitivity);

fprintf('Multiscale Inference...\n');
final_map = multiScaleBlurInferenceFull(feature, alphaval);


figure(1),imshow(im);
figure(2),imshow(final_map);













