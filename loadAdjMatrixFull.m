%   loadAdjMatrix -- Compute adjacency matrix for given input image size
%   Paras: 
%   @nRows     : Number of rows for input image.
%   @nCols     : Number of columns for input image.
%   Author: Xin Yi (xiy525@mail.usask.ca)
%   Date  : 02/01/2016
function [adj, nNodesAll] = loadAdjMatrixFull(nRows, nCols)
nNodes = nRows*nCols;
nNodesAll = 3*nNodes;

y_ind = []; x_ind = [];
%% Add Down edge
% layer 1
ind = 1:nNodes;
exclude = sub2ind([nRows nCols],repmat(nRows,[1 nCols]),1:nCols);
ind = setdiff(ind,exclude);
y_ind = [y_ind, ind]; x_ind = [x_ind, ind+1];

% layer 2
ind = 1:nNodes;
exclude = sub2ind([nRows nCols],repmat(nRows,[1 nCols]),1:nCols);
ind = setdiff(ind,exclude);
ind = ind + nNodes;
y_ind = [y_ind, ind]; x_ind = [x_ind, ind+1];

% layer 3
ind = 1:nNodes;
exclude = sub2ind([nRows nCols],repmat(nRows,[1 nCols]),1:nCols);
ind = setdiff(ind,exclude);
ind = ind + 2*nNodes;
y_ind = [y_ind, ind]; x_ind = [x_ind, ind+1];

%% Add Right Edges
% layer 1
ind = 1:nNodes;
exclude = sub2ind([nRows nCols],1:nRows,repmat(nCols,[1 nRows]));
ind = setdiff(ind, exclude);
y_ind = [y_ind, ind]; x_ind = [x_ind, ind+nRows];

% layer 2
ind = 1:nNodes;
exclude = sub2ind([nRows nCols],1:nRows,repmat(nCols,[1 nRows]));
ind = setdiff(ind, exclude);
ind = ind + nNodes;
y_ind = [y_ind, ind]; x_ind = [x_ind, ind+nRows];

% layer 3
ind = 1:nNodes;
exclude = sub2ind([nRows nCols],1:nRows,repmat(nCols,[1 nRows]));
ind = setdiff(ind, exclude);
ind = ind + 2*nNodes;
y_ind = [y_ind, ind]; x_ind = [x_ind, ind+nRows];

%% Add Link From Layer 1 to Layer 2
y = 1:nRows; x = 1:nCols;
[y, x] = meshgrid(y, x);
ind1 = sub2ind([nRows nCols], y, x);

ind2 = sub2ind([nRows nCols], y, x) + nNodes;
y_ind = [y_ind, ind1(:)']; x_ind = [x_ind, ind2(:)'];

%% Add Link From Layer 2 to Layer 3
y = 1:nRows; x = 1:nCols;
[y, x] = meshgrid(y, x);
ind1 = sub2ind([nRows nCols], y, x) + nNodes;

ind2 = sub2ind([nRows nCols], y, x) + 2*nNodes;
y_ind = [y_ind, ind1(:)']; x_ind = [x_ind, ind2(:)'];

%% Add the reversed links
% adj = adj + adj';
y_ind_final = [y_ind, x_ind]; x_ind_final = [x_ind, y_ind];

%% Generate the sparse Matrix
edgeNum = length(y_ind_final);
edgeValue = ones(1, edgeNum);
adj = sparse(y_ind_final, x_ind_final, edgeValue, nNodesAll, nNodesAll);

end
