#include <math.h>
#include "mex.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
	/* Variables */
    int n,e,n1,n2,edge,
			nNodes,nEdges,
			*nNei,
			*edgeEnds,
			dims[2], *V, *E;
	
	/* Inputs */
	edgeEnds = (int*)mxGetPr(prhs[0]);
	nNodes = (int)mxGetScalar(prhs[1]);
    nEdges = mxGetDimensions(prhs[0])[0];
	
	if (!mxIsClass(prhs[0],"int32")||!mxIsClass(prhs[1],"int32"))
        mexErrMsgTxt("edgeEnds and nNodes must be int32");
    
	/* Allocate memory */
	nNei = mxCalloc(nNodes,sizeof(int));
	
	/* Outputs */
	dims[0] = nNodes+1;
	dims[1] = 1;
	plhs[0] = mxCreateNumericArray(2,dims,mxINT32_CLASS,mxREAL);
	V = mxGetData(plhs[0]);
	
	dims[0] = 2*nEdges;
	plhs[1] = mxCreateNumericArray(2,dims,mxINT32_CLASS,mxREAL);
	E = mxGetData(plhs[1]);
	
	/* Count number of neighbors for each node */
	for(e=0;e<nEdges;e++) {
		n1 = edgeEnds[e]-1;
		n2 = edgeEnds[e+nEdges]-1;
		nNei[n1]++;
		nNei[n2]++;
	}
    
    /* Make V structure */
    edge = 0;
    for(n=0;n<nNodes;n++) {
        V[n] = edge+1;
        edge = edge + nNei[n];
    }
    V[nNodes] = edge+1;

    /* Reset number of neighbors (info now contained in V) */
    for(n=0;n<nNodes;n++) {
        nNei[n] = 0;
    }
    
    /* Make E structure */
    for(e=0;e<nEdges;e++) {
        n1 = edgeEnds[e]-1;
        n2 = edgeEnds[e+nEdges]-1;
        E[V[n1]-1+nNei[n1]++] = e+1;
        E[V[n2]-1+nNei[n2]++] = e+1;
    }
    
	
	/* Free all memory */
	mxFree(nNei);
}
