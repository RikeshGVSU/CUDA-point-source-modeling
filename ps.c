
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

extern double compute(int numSlice, int time, double densityAt, int pointSource, double density);

int main (int argc, char *argv[])
{
  int numSlice = atof(argv[1]) + 1;
  int time = atof(argv[2]);
  double densityAt = 0.7;
  int pointSource = atof(argv[3]);
  double density;
    
  struct timeval  tv1, tv2;
  gettimeofday(&tv1, NULL);

  density = compute (numSlice, time, densityAt, pointSource, density);
    
  gettimeofday(&tv2, NULL);

  printf ("Total time = %f seconds\n",
         (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
         (double) (tv2.tv_sec - tv1.tv_sec));


    // Again, print the arrays
    printf ("Density :  %f\n" , density);

    
    return 0;
}
