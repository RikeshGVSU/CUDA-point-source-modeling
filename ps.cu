// vAdd.cu
//
// driver and kernel call

#include <stdio.h>

#define BLOCK_SIZE 256
 
__global__ void getDensity (double *a_d, double *b_d, int numSlice)
{
     // __shared__ double s[BLOCK_SIZE + 2];
      int x = blockIdx.x * blockDim.x + threadIdx.x;

      

      if (x != 0 && x < numSlice - 1) {
        // if(threadIdx.x == 0) {
        // s[0] = a_d[x-1];
        // s[1] = a_d[x];
        // }
        // else if (threadIdx.x == BLOCK_SIZE - 1){
        //   s[BLOCK_SIZE +1] = a_d[x + 1];
        //   s[BLOCK_SIZE] = a_d[x];
        // }
        // else {
        //   s[threadIdx.x + 1] = a_d[x];
        // }
        b_d[x] = (a_d[x-1] + a_d[x+1])/2;
      }
      __syncthreads();
      if (x == numSlice - 1){
      	b_d[numSlice - 1] = b_d[numSlice - 2];
      }

    // Copying result with the neighboring values, just to check the neighbor value

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


extern "C" double compute(int numSlice, int time, double densityAt, int pointSource)
{
	double *a_d, *b_d;

	cudaMalloc ((void**) &a_d, sizeof(double) * numSlice);
	cudaMalloc ((void**) &b_d, sizeof(double) * numSlice);
	//cudaMalloc ((void**) &c_d, sizeof(double) * 5);
	double density = 0;
	
	initialize <<< ceil((float) numSlice/BLOCK_SIZE), BLOCK_SIZE>>> (a_d, b_d, numSlice, pointSource);

  for (int n = 0; n < time; n++){
    getDensity <<< ceil((float) numSlice/BLOCK_SIZE), BLOCK_SIZE>>> (a_d, b_d, numSlice);
    a_d = b_d;
  }

  int index = (int)((numSlice - 1) * 0.7);


  cudaMemcpy(&density, &a_d[index], sizeof(double), cudaMemcpyDeviceToHost);


	cudaError_t err = cudaGetLastError();
	if (err != cudaSuccess)
		printf ("CUDA error: %s\n", cudaGetErrorString(err));
		
	cudaFree (a_d);
	cudaFree (b_d);

  return density;
}

