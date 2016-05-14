/* By Yiren Lu 04/20/2016 */
#include "mex.h"
#include <string.h>

double * xio = NULL;
double * yio = NULL;

#define MAX_NUM_CELLS 3000000

void mexExit(void)
{
  printf("exiting getMapCellsFromRay\n");
  if (xio) delete [] xio; xio = NULL;
  if (yio) delete [] yio; yio = NULL;
}


//Bresenham's line algorithm
void mexFunction( int nlhs, mxArray *plhs[], 
          int nrhs, const mxArray*prhs[] ){ 

    if (!xio)
    {
      xio = new double[MAX_NUM_CELLS];
      yio = new double[MAX_NUM_CELLS];
      mexAtExit(mexExit);
    }

    int x0t = *mxGetPr(prhs[0]); 
    int y0t = *mxGetPr(prhs[1]);

    double * xis = mxGetPr(prhs[2]);
    double * yis = mxGetPr(prhs[3]);
    int nPoints = mxGetNumberOfElements(prhs[2]);

    double * pxio = xio;
    double * pyio = yio;

    for (int ii=0; ii<nPoints; ii++)
    {
        int x0 = x0t;
        int y0 = y0t;
        int x1 = (int)*xis++;
        int y1 = (int)*yis++;
        bool steep = abs(y1 - y0) > abs(x1 - x0);
        if(steep){
            // then increment by y
            double xinc = 0;
            double deltax = abs(x1 - x0);
            double deltay = abs(y1 - y0);
            int y = y0, x = x0;
            int ystep,xstep;
            if(y0 < y1)
                ystep = 1;
            else
                ystep = -1;

            if(x0<x1) xstep = 1;
            else xstep = -1;

            for(int y=y0;y!=y1;y+=ystep){
                *pyio++ = y;
                *pxio++ = x;
                xinc += deltax/deltay;
                if(xinc > 1){
                    xinc -=1;
                    x += xstep;
                }
            }
        }else{
            // then increment by x
            double yinc = 0;
            double deltax = abs(x1 - x0);
            double deltay = abs(y1 - y0);
            int y = y0, x = x0;
            int ystep,xstep;

            if(y0<y1) ystep = 1;
            else ystep = -1;

            if(x0<x1) xstep = 1;
            else xstep = -1;

            for(int x=x0;x!=x1;x+=xstep){
                *pyio++ = y;
                *pxio++ = x;
                yinc += deltay/deltax;
                if(yinc > 1){
                    yinc -=1;
                    y += ystep;
                }
            }
        }
    }

    int numCells = pxio - xio;

    plhs[0] = mxCreateDoubleMatrix(numCells,1,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(numCells,1,mxREAL);

    memcpy(mxGetPr(plhs[0]),xio,numCells*sizeof(double));
    memcpy(mxGetPr(plhs[1]),yio,numCells*sizeof(double));
    return;
}