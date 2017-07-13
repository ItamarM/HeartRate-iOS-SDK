#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// http://www.ignaciomellado.es/blog/Measuring-heart-rate-with-a-smartphone-camera
@interface HeartRateKitAlgorithm : NSObject

//Properties
@property (nonatomic , readonly) int framesCounter;
@property (nonatomic , readwrite) CGFloat frameRate;// the frame rate of the video
@property (nonatomic , readwrite) int windowSize;// size in frames
@property (nonatomic , readwrite) int filterWindowSize;// duration in frames
@property (nonatomic , readwrite) int calibrationDuration;// duration in frames
@property (nonatomic , readwrite) int windowSizeForAverageCalculation;// size must be <= calibrationDuration

@property (nonatomic , readwrite) double ** buttterworthValues;

//
- (CGFloat)getColorValueFrom:(UIColor *)color;

// outside API
@property (nonatomic , readonly) BOOL isCalibrationOver;
@property (nonatomic , readonly) BOOL isFinalResultDetermined;
@property (nonatomic , readonly) CGFloat bpmLatestResult;

@property (nonatomic, readonly) BOOL isPeakInLastFrame;
@property (nonatomic, readonly) BOOL isMissedTheLastPeak;

@property (nonatomic , readonly) BOOL shouldShowLatestResult;

// the method to be called on each frame
- (void)newFrameDetectedWithAverageColor:(UIColor *)color;

@end
