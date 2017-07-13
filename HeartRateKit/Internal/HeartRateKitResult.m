#import "HeartRateKitResult.h"
#import "HeartRateKitResult+Protected.h"

@interface HeartRateKitResult() {
    @private
    BOOL _markedBPM;
}

@end

@implementation HeartRateKitResult

// designated initializer
- (instancetype)initWithStart:(NSDate *)start  {
    self = [super init];
    
    if (self) {
        _start = start;
        _end = start;
        _markedBPM = NO;
    }
    return self;
}
    
+(HeartRateKitResult *)createResult{
    return [[HeartRateKitResult alloc] initWithStart:[NSDate date]];
}

- (void)markBPM:(CGFloat)bpm {
    if (_markedBPM) return;
    _markedBPM = YES;
    
    _end = [NSDate date];
    _bpm = bpm;
}

- (NSTimeInterval)duration
{
    if (!_markedBPM) return 0;
    
    return [self.end timeIntervalSinceDate:self.start];
}

@end
