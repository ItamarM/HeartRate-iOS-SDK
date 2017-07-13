#import "ViewController.h"
#import <HeartRateKit/HeartRateKit.h>

@interface ViewController ()<HeartRateKitControllerDelegate>

@end

@implementation ViewController

-(IBAction)startMonitor:(id)sender {
    #if TARGET_OS_SIMULATOR
    [self presentAlert:@"This code works only on device. Sorry!"];
    #else
    HeartRateKitController *controller = [[HeartRateKitController alloc] init];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    #endif
}

-(void)presentAlert:(NSString *)message {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// HeartRateKitControllerDelegate methods
- (void)heartRateKitController:(HeartRateKitController *)controller didFinishWithResult:(HeartRateKitResult *)result {
    NSString *messageToDisplay = [NSString stringWithFormat:@"BPM : %.01f", result.bpm];
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentAlert:messageToDisplay];
    }];
}

- (void)heartRateKitControllerDidCancel:(HeartRateKitController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
