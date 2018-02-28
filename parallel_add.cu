#include <stdio.h>
#include <stdlib.h>

#define SIZE_BLOCK 256

__global__ void add(int n, int *a, int *b, int *c) {
    int start = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    for(int i=start; i< n; i+=stride){
        c[i] = a[i] + b[i];
    }
}

void random_ints(int* x, int size)
{
    int i;
    for (i=0;i<size;i++) {
        x[i]=rand()%10;
    }
}

int main(void) 
{
    int *a, *b, *c; // host copies of a, b, c
    int *d_a, *d_b, *d_c; // device copies of a, b, c
    int n = 1<<20;
    int num_block = (n + SIZE_BLOCK - 1) / SIZE_BLOCK;
    int size = n * sizeof(int);
    
    // Alloc space for device copies of a, b, c
    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);
    cudaMalloc((void **)&d_c, size);
    
    // Alloc space for host copies of a, b, c and setup input values
    a = (int *)malloc(size); random_ints(a, n);
    b = (int *)malloc(size); random_ints(b, n);
    c = (int *)malloc(size);

    // Copy inputs to device
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
    
    // Launch add() kernel on GPU with N blocks
    add<<<num_block,SIZE_BLOCK>>>(n, d_a, d_b, d_c);

    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();

    // Copy result back to host
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
    // Cleanup

    free(a); free(b); free(c);
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
    return 0;
}
