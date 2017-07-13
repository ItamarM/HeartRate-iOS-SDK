//
//  PulseDetector.h
//  ARDemo
//
//  Created by Chris Greening on 30/10/2010.
//  Copyright 2010 CMG Research. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_PERIODS_TO_STORE 20
#define AVERAGE_SIZE 20
#define INVALID_PULSE_PERIOD -1

@interface PulseDetector : NSObject {
	float upVals[AVERAGE_SIZE];
	float downVals[AVERAGE_SIZE];
	int upValIndex;
	int downValIndex;
	
	float lastVal;
	float periodStart;
	double periods[MAX_PERIODS_TO_STORE];
	double periodTimes[MAX_PERIODS_TO_STORE];
	
	int periodIndex;
	bool started;
	float freq;
	float average;
	
	bool wasDown;
}

@property (nonatomic, assign) float periodStart;


-(float) addNewValue:(float) newVal atTime:(double) time;
-(float) getAverage;
-(void) reset;

@end
