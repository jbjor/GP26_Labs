#include <stdio.h>

__global__ void vecAddKernel(float *A, float *B, float *C, int n) {

  // Calculate global thread index based on the block and thread indices ----

  // INSERT KERNEL CODE HERE
  // Calculate the global index idx of the thread
  int idx = blockDim.x * blockIdx.x + threadIdx.x;

  // Use global index to determine which elements to read, add, and write ---

  // INSERT KERNEL CODE HERE
  if (blockIdx.x == 38) {
    if (threadIdx.x == 9983) {
      printf("Block %d, Thread %d: idx = %d\n", blockIdx.x, threadIdx.x, idx);
      
    }
    if (threadIdx.x > (n % blockIdx.x + 1)- 1) {  // when we have threads in last block that are not needed
      // do nothing                               // - 1 due to 0-based indexing
    }                                             // + 1 for same reason
    else {
        if (idx < n) {
            C[idx] = A[idx] + B[idx];
        }
    }

  }
  else {
    if (idx < n) {
    C[idx] = A[idx] + B[idx];
    }
  }

}
