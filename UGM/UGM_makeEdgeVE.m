function [V,E] = UGM_makeEdgeVE(edgeEnds,nNodes,useMex)
% Calculate : 
% E - [ [indexes of edges connected to node 1][indexes of edges connected to node 2] .... [indexes of edges connected to node nNodes] ]
% V -- V(i) = the sum of the number of edges connected to nodes (1,2,...i-1) plus 1  (the sums of the lengths of the above blocks 1,2..i-1 plus 1)

if nargin < 3
	useMex = 1;
end

if useMex % Note: much more memory efficient
	[V,E] = UGM_makeEdgeVEC(int32(edgeEnds),int32(nNodes));
else
	nEdges = size(edgeEnds,1);
	
	nNei = zeros(nNodes,1);
	nei = zeros(nNodes,0);
	for e = 1:nEdges
		n1 = edgeEnds(e,1);
		n2 = edgeEnds(e,2);
		nNei(n1) = nNei(n1)+1;
		nNei(n2) = nNei(n2)+1;
		nei(n1,nNei(n1)) = e;
		nei(n2,nNei(n2)) = e;
	end
	
	edge = 1;
	V = zeros(nNodes+1,1,'int32');
	E = zeros(2*nEdges,1,'int32');
	for n = 1:nNodes
		V(n) = edge;
		nodeEdges = sort(nei(n,1:nNei(n)));
		E(edge:edge+length(nodeEdges)-1,1) = nodeEdges;
		edge = edge+length(nodeEdges);
	end
	V(nNodes+1) = edge;
end