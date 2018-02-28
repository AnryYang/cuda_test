/*************************************************************************
    > File Name: hello.cu
    > Author: anryyang
    > Mail: anryyang@gmail.com 
    > Created Time: Mon 26 Feb 2018 04:50:59 PM SGT
 ************************************************************************/

#include<stdio.h>

__global__ void mykernel(void) {
}

int main(void) {
    mykernel<<<1,1>>>();
    printf("Hello World!\n");
    return 0;
}
