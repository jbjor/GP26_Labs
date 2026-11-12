#include "kernel.cu"
#include "support.h"
#include <stdio.h>

int main(int argc, char **argv) {

  Timer timer;
  cudaError_t cuda_ret;

  // Initialize host variables ----------------------------------------------

  printf("\nSetting up the problem...");
  fflush(stdout);
  startTime(&timer);

  unsigned int n;       // Vector size !
  if (argc == 1) {
    n = 10000;  // default vector size
  } else if (argc == 2) {
    n = atoi(argv[1]);
  } else {
    printf("\n    Invalid input parameters!"
           "\n    Usage: ./vecadd               # Vector of size 10,000 is used"
           "\n    Usage: ./vecadd <m>           # Vector of size m is used"
           "\n");
    exit(0);
  }

  // In host memory

  float *A_h = (float *)malloc(sizeof(float) * n);
  for (unsigned int i = 0; i < n; i++) {
    A_h[i] = (rand() % 100) / 100.00;
  }

  float *B_h = (float *)malloc(sizeof(float) * n);
  for (unsigned int i = 0; i < n; i++) {
    B_h[i] = (rand() % 100) / 100.00;
  }

  float *C_h = (float *)malloc(sizeof(float) * n);

  // Print host memory allocation times
  stopTime(&timer);
  printf("%f s\n", elapsedTime(timer));
  printf("    Vector size = %u\n", n);

  // Allocate device variables ----------------------------------------------
  // aka. allocate device/GPU memory and variables

  printf("Allocating device variables...");
  fflush(stdout);
  startTime(&timer);

  // INSERT CODE HERE
  float *a_d, *b_d, *c_d;
  cudaMalloc((void**) &a_d, n*sizeof(float));
  cudaMalloc((void**) &b_d, n*sizeof(float));
  cudaMalloc((void**) &c_d, n*sizeof(float));


  cudaDeviceSynchronize();
  stopTime(&timer);
  printf("%f s\n", elapsedTime(timer));

  // Copy host variables to device ------------------------------------------

  printf("Copying data from host to device...");
  fflush(stdout);
  startTime(&timer);

  // INSERT CODE HERE
  cudaMemcpy(a_d, A_h, n*sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(b_d, B_h, n*sizeof(float), cudaMemcpyHostToDevice);


  cudaDeviceSynchronize();    // wait on above to all finish before continuing
  stopTime(&timer);
  printf("%f s\n", elapsedTime(timer));

  // Launch kernel ----------------------------------------------------------
  // also Initialize thread block and kernel grid dimensions

  printf("Launching kernel...");
  fflush(stdout);
  startTime(&timer);

  // INSERT CODE HERE
  const unsigned int numThreadsPerBlock = 250; // If can't find better solution
  //const unsigned int numThreadsPerBlock = 4; // For testing purposes, we can use a smaller number of threads per block

  // Grid size or number of blocks is the number of blocks needed to cover all elements
  const unsigned int numBlocks = n / numThreadsPerBlock;
  printf("Launching kernel with %d threads per block and %d blocks\n", numThreadsPerBlock, numBlocks);
  printf("Using this suboptimal number of threads per block if I can't find a solution to the half empty block problem\n");
  
  
  vecAddKernel<<<numBlocks, numThreadsPerBlock>>>(a_d, b_d, c_d, n);

  cuda_ret = cudaDeviceSynchronize();
  if (cuda_ret != cudaSuccess)
    FATAL("Unable to launch kernel");
  stopTime(&timer);
  printf("%f s\n", elapsedTime(timer));

  // Copy device variables from host ----------------------------------------

  printf("Copying data from device to host...");
  fflush(stdout);
  startTime(&timer);

  // INSERT CODE HERE
  cudaMemcpy(C_h, c_d, n*sizeof(float), cudaMemcpyDeviceToHost);

  cudaDeviceSynchronize();
  stopTime(&timer);
  printf("%f s\n", elapsedTime(timer));

  // Verify correctness -----------------------------------------------------

  printf("Verifying results...");
  fflush(stdout);

  verify(A_h, B_h, C_h, n);

  // Free memory ------------------------------------------------------------

  // free host memory
  free(A_h);
  free(B_h);
  free(C_h);

  // free device memory too
  // INSERT CODE HERE
  cudaFree(a_d);
  cudaFree(b_d);
  cudaFree(c_d);

  return 0;
}
