#ifndef __HRKButterworth__
#define __HRKButterworth__

double** butter(double FrequencyBands[2], int FiltOrd); //bandpass values
void filter(int ord, double *a, double *b, int np, double *x, double *y);

#endif // __HRKButterworth__
