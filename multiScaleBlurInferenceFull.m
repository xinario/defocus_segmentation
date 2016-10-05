% multiScaleBlurInference -- Blur inference given feature map from multiple 
%   scale. This function solves Eq.(19) in the paper.
%   Paras: 
%   @feature   : Input grayscale featureage.
%   @alpha     : Parameter controlling weight for multiscale inference.
%   Author: Xin Yi (xiy525@mail.usask.ca)
%   Date  : 02/01/2016
function [final_fea_map] = multiScaleBlurInferenceFull(feature, alpha)
%% Parameters
nStates = 2;
[nRows, nCols] = size(feature.scale1);
%% Graphic model generation
[adj, nNodes] = loadAdjMatrixFull(nRows, nCols);

edgeStruct = UGM_makeEdgeStruct(adj,nStates);

fea_scale1 = feature.scale1;
fea_scale2 = feature.scale2;
fea_scale3 = feature.scale3;

X = [fea_scale3(:); fea_scale2(:); fea_scale1(:)];
Xstd = UGM_standardizeCols(reshape(X,[1 1 nNodes]),1);

% Make nodePot
nodePot = zeros(nNodes,nStates);
nodePot(:,1) = exp(-abs(1-Xstd(:)));
nodePot(:,2) = exp(-abs(Xstd(:)));


% Make edgePot
edgePot = zeros(nStates,nStates,edgeStruct.nEdges);
for e = 1:edgeStruct.nEdges
    pot_same = 1;
    pot_diff = exp(-alpha);
    edgePot(:,:,e) = [pot_same pot_diff; pot_diff pot_same];
end

%% Hierachical inference
[nodeBel, ~, ~] = UGM_Infer_LBP(nodePot,edgePot,edgeStruct);

%% Seperate to three maps
nNodes = nRows*nCols;

%H^1
final_fea_map = reshape(nodeBel(1:nNodes,2), nRows, nCols);
final_fea_map = final_fea_map * -1 + 1;
end

