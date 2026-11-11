#include <stdio.h>

__global__ void vecAddKernel(float *A, float *B, float *C, int n) {

  // Calculate global thread index based on the block and thread indices ----

  // INSERT KERNEL CODE HERE
  // Calculate the global index idx of the thread
  int idx = blockDim.x * blockIdx.x + threadIdx.x;

  // Use global index to determine which elements to read, add, and write ---

  // INSERT KERNEL CODE HERE
  // Check if idx is within bounds of the arrays
  if (idx < n) { 
    C[idx] = A[idx] + B[idx]; // Perform vector addition
  }
  else { // Else try to do nothing
    // Handle out-of-bounds threads (optional)
    // For example, you could set C[idx] to 0 or some other value
    // C[idx] = 0.0f;
  }


}
