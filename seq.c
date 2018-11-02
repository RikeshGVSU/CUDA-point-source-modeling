
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <iostream>
#include <cstdlib>
#include <fstream>
using namespace std;

double compute(double *A, double *B, int numSlice, int time, double densityAt) {
    int index;
    // ofstream outputFile;
    // outputFile.open ("output9.csv");
    for (int n = 0; n < time; n++){
      
      // if (n%3000 == 0){
      //   for (int j = 0; j < numSlice - 1; j++) {
      //   // printf ("%f,",A[j]);
      //   // printf ("\t");
      //   outputFile << A[j];
      //   if (j != numSlice - 2){
      //     outputFile << ",";
      //     }
      //   }
      // outputFile << "\n";
      // }   
      
      for (int i = 1; i < numSlice - 1; i++) {
        B[i] = (A[i - 1] + A[i + 1])/2;
      }
      B[numSlice - 1] = B[numSlice - 2];
      n++;

      // if (n%3000 == 0){
      //   for (int k = 0; k < numSlice - 1; k++) {
      //   // printf ("%f,",B[k]);
      //   // printf ("\t");
      //     outputFile << B[k];
      //     if (k != numSlice - 2){
      //       outputFile << ",";
      //     }
      //   }
      //   outputFile << "\n";
      // }
      
      
      
      for (int i = 1; i < numSlice - 1; i++) {
        A[i] = (B[i - 1] + B[i + 1])/2;
      }
      A[numSlice - 1] = A[numSlice - 2];
    
    }
    index = (int)((numSlice - 1) * densityAt);
    printf ("Index: %d\n" , index);
    return B[index];
}

int main (int argc, char *argv[])
{
  int numSlice = atof(argv[1]) + 1;
  int time = atof(argv[2]);
  double densityAt = 0.7;
  int pointSource = atof(argv[3]);

  double* A = (double *) malloc(numSlice * sizeof(double));
  double* B = (double *) malloc(numSlice * sizeof(double));
  double  density = 0;
  A[0] = pointSource;
  B[0] = pointSource;
  for (int i = 1; i < numSlice; i++){
    A[i] = 0;
    B[i] = 0;
  }
   
    
  struct timeval  tv1, tv2;
  gettimeofday(&tv1, NULL);

  density = compute (A, B, numSlice, time, densityAt);
    
  gettimeofday(&tv2, NULL);

  printf ("Total time = %f seconds\n",
         (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
         (double) (tv2.tv_sec - tv1.tv_sec));


    // Again, print the arrays
    printf ("Density: %f" , density);


    
    return 0;
}
