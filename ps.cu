// vAdd.cu
//
// driver and kernel call

#include <stdio.h>

#define BLOCK_SIZE 256
 
__global__ void getDensity (double *a_d, double *b_d, double *c_d, int numSlice, int time, double densityAt, int pointSource, double density_d)
{
   	//double * temp;
  int x = blockIdx.x * blockDim.x + threadIdx.x;	
  for (int n = 0; n < 1000; n++){
      if (x != 0 && x < numSlice - 1) {
        b_d[x] = (a_d[x - 1] + a_d[x + 1])/2;
      }
      __syncthreads();
      if (x == numSlice - 1){
      	b_d[x] = b_d[x - 1];
      }
      n++;
      __syncthreads();
      if (x != 0 && x < numSlice - 1) {
        a_d[x] = (b_d[x - 1] + b_d[x + 1])/2;
      }
      __syncthreads();
      if (x == numSlice - 1){
      	a_d[x] = a_d[x - 1];
      }
    }

    // Copying result with the neighboring values, just to check the neighbor value

    int index = (int)((numSlice - 1) * 0.7);
    c_d[0] =  a_d[index - 2];
    c_d[1] =  a_d[index - 1];
    c_d[2] =  a_d[index];
    c_d[3] =  a_d[index+2];
    c_d[4] =  a_d[index+1];


}

__global__ void initialize (double *a_d, double *b_d,  int numSlice, int pointSource)
{
	int x = blockIdx.x * blockDim.x + threadIdx.x;
	
	if (x == 0){
		a_d[x] = pointSource;
		b_d[x] = pointSource;
	}
	else if (x < numSlice) {
		a_d[x] = 0;
		b_d[x] = 0;
	}
}

extern "C" void compute(double *c, int numSlice, int time, double densityAt, int pointSource)
{
	double *a_d, *b_d, *c_d;

	cudaMalloc ((void**) &a_d, sizeof(double) * numSlice);
	cudaMalloc ((void**) &b_d, sizeof(double) * numSlice);
	cudaMalloc ((void**) &c_d, sizeof(double) * 5);
	double density_d = 0;
	
	initialize <<< ceil((float) numSlice/BLOCK_SIZE), BLOCK_SIZE>>> (a_d, b_d, numSlice, pointSource);

	getDensity <<< ceil((float) numSlice/BLOCK_SIZE), BLOCK_SIZE>>> (a_d, b_d, c_d, numSlice, time, densityAt, pointSource, density_d);

	cudaMemcpy (c, c_d, sizeof(double) * 5, cudaMemcpyDeviceToHost);

	cudaError_t err = cudaGetLastError();
	if (err != cudaSuccess)
		printf ("CUDA error: %s\n", cudaGetErrorString(err));
		
	cudaFree (a_d);
	cudaFree (b_d);
	cudaFree (c_d);
}

