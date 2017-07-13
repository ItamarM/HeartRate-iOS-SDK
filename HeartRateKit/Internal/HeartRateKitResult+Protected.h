#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HeartRateKitResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeartRateKitResult (Protected)

+(HeartRateKitResult *)createResult;
- (void)markBPM:(CGFloat)bpm;

@end

NS_ASSUME_NONNULL_END
