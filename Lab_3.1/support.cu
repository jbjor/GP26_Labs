

#include <stdint.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>

#include "support.h"

void verify(float *A, float *B, float *C, unsigned int m, unsigned int k,
  unsigned int n) {

  const float relativeTolerance = 1e-6;

  for(int row = 0; row < m; ++row) {
    for(int col = 0; col < n; ++col) {
      float sum = 0;
      for(unsigned int i = 0; i < k; ++i) {
        sum += A[(size_t)row*k + i]*B[(size_t)i*n + col];
      }
      float actual = C[(size_t)row*n + col];
      if (!isfinite(actual) || fabsf(sum - actual) >
          relativeTolerance * fmaxf(1.0f, fabsf(sum))) {
        printf("TEST FAILED\n\n");
        exit(EXIT_FAILURE);
      }
    }
  }
  printf("TEST PASSED\n\n");

}

void startTime(Timer* timer) {
    gettimeofday(&(timer->startTime), NULL);
}

void stopTime(Timer* timer) {
    gettimeofday(&(timer->endTime), NULL);
}

float elapsedTime(Timer timer) {
    return ((float) ((timer.endTime.tv_sec - timer.startTime.tv_sec) \
                + (timer.endTime.tv_usec - timer.startTime.tv_usec)/1.0e6));
}

