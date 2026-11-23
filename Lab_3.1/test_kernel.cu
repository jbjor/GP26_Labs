


#include <stdio.h>

__global__ void mysgemm(int m, int n, int k, const float *A, const float *B, float* C) {

    /********************************************************************
     *
     * Compute C = A x B
     *   where A is a (m x k) matrix
     *   where B is a (k x n) matrix
     *   where C is a (m x n) matrix
     *
     ********************************************************************/

    // INSERT KERNEL CODE HERE
    // aka the math
    unsigned int row = blockIdx.y * blockDim.y + threadIdx.y;
    unsigned int col = blockIdx.x * blockDim.x + threadIdx.x;

    // Check if the thread is within the bounds of the output matrix
    //if (row >= m || col >= n) {
      //  return;
    //}

    float sum = 0.0f;
    for (unsigned int i = 0; i < k; i++) {
        float a = A[row * k + i];
        float b = B[i * n + col];
        float product = a * b;
        sum += product;
        printf("C[%u,%u] += A[%u,%u] * B[%u,%u] = %f * %f = %f; sum = %f\n",
               row, col, row, i, i, col, a, b, product, sum);
    }
    C[row * n + col] = sum;
    printf("C[%u,%u] = %f\n", row, col, sum);



}

void basicSgemm(char transa, char transb, int m, int n, int k, float alpha, const float *A, int lda, const float *B, int ldb, float beta, float *C, int ldc)
{
    if ((transa != 'N') && (transa != 'n')) {
	printf("unsupported value of 'transa'\n");
    	return;
    }

    if ((transb != 'N') && (transb != 'n')) {
	printf("unsupported value of 'transb'\n");
	return;
    }

    if ((alpha - 1.0f > 1e-10) || (alpha - 1.0f < -1e-10)) {
	printf("unsupported value of alpha\n");
	return;
    }

    if ((beta - 0.0f > 1e-10) || (beta - 0.0f < -1e-10)) {
	printf("unsupported value of beta\n");
	return;
    }

    // Initialize thread block and kernel grid dimensions ---------------------

    //const unsigned int BLOCK_SIZE = 16; // Use 16x16 = 256 thread blocks for final submission
    const unsigned int BLOCK_SIZE = 4; // For 4x4

    


    //INSERT CODE HERE
    // aka the block and grid dimensions
    // stuff to use ; (int m, int n, int k, const float *A, const float *B, float* C) 
    //const unsigned int numThreadsPerBlock = 4; // For testing purposes, we can use a smaller number of threads per block

    //Number of blocks in the grid, with the added 1 to account for any remainder threads
    //const unsigned int numBlocks = n / numThreadsPerBlock + 1;

    const dim3 block(BLOCK_SIZE, BLOCK_SIZE);
    const dim3 grid((n + BLOCK_SIZE - 1) / block.x,
                    (m + BLOCK_SIZE - 1) / block.y);  
    
    printf("Launching kernel with %d threads per block and %d blocks\n", BLOCK_SIZE * BLOCK_SIZE, grid.x * grid.y);
    printf("Grid dimensions: (%d, %d), Block dimensions: (%d, %d)\n", grid.x, grid.y, block.x, block.y);

    printf("\nGrid's x dimension: (n + BLOCK_SIZE - 1) / block.x = (%d + %u - 1) / %u = %u\n", n, BLOCK_SIZE, block.x, grid.x);
    printf("(n + BLOCK_SIZE - 1) / block.x\n");
    printf("(%d + %u - 1) / %u = %u\n",
       n, BLOCK_SIZE, block.x, grid.x);
    
    printf("Grid's y dimension: (m + BLOCK_SIZE - 1) / block.y = (%d + %u - 1) / %u = %u\n", m, BLOCK_SIZE, block.y, grid.y);
    printf("(m + BLOCK_SIZE - 1) / block.y\n");
    printf("(%d + %u - 1) / %u = %u\n",
       m, BLOCK_SIZE, block.y, grid.y);


    // Invoke CUDA kernel -----------------------------------------------------

    //INSERT CODE HERE
    mysgemm<<<grid, block>>>(m, n, k, A, B, C);
    // aka the launch, <<< >>> syntax
    //vecAddKernel<<<numBlocks, numThreadsPerBlock>>>(a_d, b_d, c_d, n);
    //__global__ void mysgemm(int m, int n, int k, const float *A, const float *B, float* C) {

    //printf("\nLaunching kernel with %d threads per block and %d blocks\n", numThreadsPerBlock, numBlocks);
    //mysgemm<<<numBlocks, numThreadsPerBlock>>>(m, n, k, A, B, C);






}

