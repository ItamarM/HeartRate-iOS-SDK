#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HeartRateKitResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HeartRateKitControllerDelegate;

@interface HeartRateKitController : UIViewController
@property(nullable,nonatomic,weak) id <HeartRateKitControllerDelegate> delegate;
@end

@protocol HeartRateKitControllerDelegate<NSObject>
@optional
// The controller does not dismiss itself; the client dismisses it in these callbacks.
// The delegate will receive one or the other, but not both, depending whether the user
// confirms or cancels.
- (void)heartRateKitController:(HeartRateKitController *)controller didFinishWithResult:(HeartRateKitResult *)result;
- (void)heartRateKitControllerDidCancel:(HeartRateKitController *)controller;

@end

NS_ASSUME_NONNULL_END
