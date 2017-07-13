//
//  Butterworth.h
//  Heartbeat
//
//  Created by Or Maayan on 9/4/13.
//  Copyright (c) 2013 Or Maayan. All rights reserved.
//

#ifndef __Heartbeat__Butterworth__
#define __Heartbeat__Butterworth__

double** butter(double FrequencyBands[2], int FiltOrd); //bandpass values
void filter(int ord, double *a, double *b, int np, double *x, double *y);

#endif
