
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

extern void compute(double *c, int numSlice, int time, double densityAt, int pointSource);

int main (int argc, char *argv[])
{
  int numSlice = atof(argv[1]) + 1;
  int time = atof(argv[2]);
  double densityAt = 0.7;
  int pointSource = atof(argv[3]);
  double *c = (double *) malloc(5 * sizeof(double));
    
  struct timeval  tv1, tv2;
  gettimeofday(&tv1, NULL);

   compute (c, numSlice, time, densityAt, pointSource);
    
  gettimeofday(&tv2, NULL);

  printf ("Total time = %f seconds\n",
         (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
         (double) (tv2.tv_sec - tv1.tv_sec));


    // Again, print the arrays
    printf ("Density1: %f\n" , c[0]);
    printf ("Density2: %f\n" , c[1]);
    printf ("Density3: %f\n" , c[2]);
    printf ("Density4: %f\n" , c[3]);
    printf ("Density5: %f\n" , c[4]);

    
    return 0;
}
