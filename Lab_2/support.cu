
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "support.h"

void verify(float *A, float *B, float *C, int n) {

  const float relativeTolerance = 1e-6;

  for (int i = 0; i < n; i++) {
    float sum = A[i] + B[i];
    if (!isfinite(C[i]) ||
        fabsf(sum - C[i]) > relativeTolerance * fmaxf(1.0f, fabsf(sum))) {
      printf("TEST FAILED\n\n");
      exit(EXIT_FAILURE);
    }
  }
  printf("TEST PASSED\n\n");
}

void startTime(Timer *timer) { gettimeofday(&(timer->startTime), NULL); }

void stopTime(Timer *timer) { gettimeofday(&(timer->endTime), NULL); }

float elapsedTime(Timer timer) {
  return ((float)((timer.endTime.tv_sec - timer.startTime.tv_sec) +
                  (timer.endTime.tv_usec - timer.startTime.tv_usec) / 1.0e6));
}
