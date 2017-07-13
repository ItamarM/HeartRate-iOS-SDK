#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeartRateKitResult : NSObject

-(instancetype) init __attribute__((unavailable("init not available")));

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (readonly, nonatomic) CGFloat bpm;

@end

NS_ASSUME_NONNULL_END
