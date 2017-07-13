//
//  VideoManagerViewController.m
//  Heartbeat
//
//  Created by Or Maayan on 9/14/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import "VideoManagerViewController.h"
#import "UIImage+ImageAverageColor.h"
#import "Algorithm.h"
#import "Settings.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Result.h"
#import "UILabel+FSHIghlightAnimationAdditions.h"

@interface VideoManagerViewController ()
// AVFoundation
@property (nonatomic,strong) AVCaptureSession * session;
@property (strong) AVCaptureDevice * videoDevice;
@property (strong) AVCaptureDeviceInput * videoInput;
@property (strong) AVCaptureVideoDataOutput * frameOutput;

// Audio
@property (nonatomic, retain) AVAudioPlayer *BeepSound;

// Algorithm
@property (nonatomic , strong) Algorithm *algorithm;
@property (nonatomic , strong) Algorithm *algorithm2;
@property (strong , nonatomic) NSDate *algorithmStartTime;
@property (strong , nonatomic) NSDate *bpmFinalResultFirstTimeDetected;

@property (strong, nonatomic) Settings *settings;

// view Outlets
@property (weak, nonatomic) IBOutlet UILabel *bpmLabel;
@property (weak, nonatomic) IBOutlet UILabel *fingerDetectLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalBPMLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTillResultLabel;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *beatingHeart;

@property (weak, nonatomic) IBOutlet UIButton *helpButton;

// tab bar configuration properties
@property (strong, nonatomic) UIColor *tabBarColor;
@property (strong, nonatomic) UIColor *tabBarItemColor;
@property (nonatomic, getter = isTabBarTranslucent) BOOL tabBarTranslucent;

@property (nonatomic, strong) Result *result;

@end

@implementation VideoManagerViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

// Properties

- (Settings *)settings
{
    if (!_settings)
        _settings = [Settings currentSettings];
    
    return _settings;
}

- (NSDate *)algorithmStartTime
{
    if (!_algorithmStartTime) {
        _algorithmStartTime = [NSDate date];
    }
    return _algorithmStartTime;
}

- (NSDate *)bpmFinalResultFirstTimeDetected
{
    if (!_bpmFinalResultFirstTimeDetected) {
        _bpmFinalResultFirstTimeDetected = [NSDate date];
    }
    return _bpmFinalResultFirstTimeDetected;
}

- (Algorithm *)algorithm
{
    if (!_algorithm) {
        _algorithm = [[Algorithm alloc] init];
    }
    return _algorithm;
}

- (Algorithm *)algorithm2
{
    if (!_algorithm2) {
        _algorithm2 = [[Algorithm alloc] init];
        _algorithm2.windowSize = 9;
        _algorithm2.filterWindowSize = 45;
    }
    return _algorithm2;
}

- (Result *)result
{
    if (!_result) _result = [[Result alloc] init];
    return _result;
}

//

- (void)startRunningSession
{
    dispatch_queue_t sessionQ = dispatch_queue_create("start running session thread", NULL);
    
    dispatch_async(sessionQ, ^{
        // turn flash on
        if ([self.videoDevice hasTorch] && [self.videoDevice hasFlash]){
            [self.videoDevice lockForConfiguration:nil];
            [self.videoDevice setTorchMode:AVCaptureTorchModeOn];
            [self.videoDevice setFlashMode:AVCaptureFlashModeOn];
            [self.videoDevice unlockForConfiguration];
        }
        [self.session startRunning];
    });
}

- (void)stopRunningSession
{
    dispatch_queue_t sessionQ = dispatch_queue_create("stop running session thread", NULL);
    
    dispatch_async(sessionQ, ^{
        [self.session stopRunning];
        // turn flash off (maybe unnecessary because stopRunning do this)
        if ([self.videoDevice hasTorch] && [self.videoDevice hasFlash]){
            [self.videoDevice lockForConfiguration:nil];
            [self.videoDevice setTorchMode:AVCaptureTorchModeOff];
            [self.videoDevice setFlashMode:AVCaptureFlashModeOff];
            [self.videoDevice unlockForConfiguration];
        }
    });
}

- (void)tabBarConfiguration
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        
        // tab bar configuration
        ///*
        self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.075 green:0.439 blue:0.753 alpha:1.0];
        self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
        self.tabBarController.tabBar.translucent = NO;
        
        // set selected and unselected icons
        UITabBarItem *item0 = [self.tabBarController.tabBar.items objectAtIndex:0];
        UITabBarItem *item1 = [self.tabBarController.tabBar.items objectAtIndex:1];
        UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:2];
        
        // set colors of selected text
        [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.tabBarItemColor, UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        
        [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        
        [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.tabBarItemColor, UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        
        // set colors of un-selected text
        [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
        
        [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
        
        // this way, the icon gets rendered as it is (thus, it needs to be green in this example)
        item0.image = [[UIImage imageNamed:@"pieChart_Line.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item2.image = [[UIImage imageNamed:@"Settings_Line-1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // this icon is used for selected tab and it will get tinted as defined in self.tabBar.tintColor
        item0.selectedImage = [UIImage imageNamed:@"pieChart_full.png"];
        item1.selectedImage = [UIImage imageNamed:@"Heart_Full.png"];
        item2.selectedImage = [UIImage imageNamed:@"settings_full-1.png"];
        //*/
    }
}

- (void)resetAlgorithm
{
    self.settings = nil;
    self.algorithmStartTime = nil;
    self.bpmFinalResultFirstTimeDetected = nil;
    self.algorithm = nil;
    self.algorithm2 = nil;
}

//

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetAlgorithm];
    
    [self tabBarConfiguration];
    
    //[self heartAnimation];
    //[self.fingerDetectLabel setTextWithChangeAnimation:@"שים את האצבע על המצלמה"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startRunningSession];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];// prevent the iphone from sleeping
    
    [self heartAnimation];
    [self.fingerDetectLabel setTextWithChangeAnimation:@"שים את האצבע על המצלמה"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        
        // tab bar configuration
        ///*
        self.tabBarController.tabBar.barTintColor = self.tabBarColor;
        self.tabBarController.tabBar.tintColor = self.tabBarItemColor;
        self.tabBarController.tabBar.translucent = self.isTabBarTranslucent;
        
        // set selected and unselected icons
        UITabBarItem *item0 = [self.tabBarController.tabBar.items objectAtIndex:0];
        UITabBarItem *item1 = [self.tabBarController.tabBar.items objectAtIndex:1];
        UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:2];
        
        // set colors of un-selected text
        [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
        
        [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
        
        [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
        
        // this way, the icon gets rendered as it is (thus, it needs to be green in this example)
        item0.image = [UIImage imageNamed:@"pieChart_Line.png"];
        item1.image = [UIImage imageNamed:@"Heart_line.png"];
        item2.image = [UIImage imageNamed:@"Settings_Line-1.png"];
        //*/
    }
    
    [self stopRunningSession];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];// enable sleeping

}

//

- (void)applicationWillEnterForeground
{
    if (self.isViewLoaded && self.view.window) {
        [self resetAlgorithm];
        
        [self tabBarConfiguration];
    }
}

- (void)applicationEnteredForeground
{
    if (self.isViewLoaded && self.view.window) {
        [self startRunningSession];
    }
}

- (void)applicationEnteredBackground
{
    if (self.isViewLoaded && self.view.window) {
        [self stopRunningSession];
    }
}

//

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //------------------Notifications BLOCK-----------------
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //------------------------------------------------------

    
    //------------------DESIGN BLOCK-----------------
    
    self.helpButton.tintColor = [UIColor whiteColor];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {

        // tab bar configuration
        ///*
        self.tabBarColor = self.tabBarController.tabBar.barTintColor;
        self.tabBarItemColor = self.tabBarController.tabBar.tintColor;
        self.tabBarTranslucent = self.tabBarController.tabBar.translucent;
        //*/
    }

    // background configuration
    UIImage *backgroundImage = [UIImage imageNamed:@"Background_2.jpg"];
    
    self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.backgroundView.alpha = 1;
    
    //------------------------------------------------
    
    // Create the session
    self.session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames
    self.session.sessionPreset = AVCaptureSessionPreset352x288;
    
    // Find a suitable AVCaptureDevice
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Create a device input with the device and add it to the session.
    NSError *error = nil;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:&error];
    
    if (!self.videoInput) {
        // Handling the error appropriately.
    }
    [self.session addInput:self.videoInput];
    
    // Create a VideoDataOutput and add it to the session
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // Configure your output.
    // Specify the pixel format
    self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    // shouldn't throw away frames
    self.frameOutput.alwaysDiscardsLateVideoFrames = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("frameOutputQueue", NULL);
    [self.frameOutput setSampleBufferDelegate:self queue:queue];
    
    [self.session addOutput:self.frameOutput];
    
    //------------------SOUND BEEP BLOCK-------
    
    NSURL *beepSound = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pulse-beep" ofType:@"wav"]];
    self.BeepSound = [[AVAudioPlayer alloc] initWithContentsOfURL:beepSound error:nil];
    self.BeepSound.volume = 0.03;
    
    //-----------------------------------------------
    
    self.beatingHeart.layer.shadowColor = [[UIColor redColor] CGColor];
}

//

#define TIME_TO_DETERMINE_BPM_FINAL_RESULT 3 // in seconds

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // Create a UIImage from the sample buffer data
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    // dispatch all the algorithm functionality to another thread
    dispatch_queue_t algorithmQ = dispatch_queue_create("algorithm thread", NULL);
    dispatch_async(algorithmQ, ^{
        
        UIColor *dominantColor = [image averageColorPrecise];// get the average color from the image
        CGFloat red , green , blue , alpha;
        [dominantColor getRed:&red green:&green blue:&blue alpha:&alpha];
        blue = blue*255.0f;
        green = green*255.0f;
        red = red*255.0f;
        
        [self.algorithm newFrameDetectedWithAverageColor:dominantColor];
        [self.algorithm2 newFrameDetectedWithAverageColor:dominantColor];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (self.algorithm.isFinalResultDetermined) {
                if (TIME_TO_DETERMINE_BPM_FINAL_RESULT <= [[NSDate date] timeIntervalSinceDate:self.bpmFinalResultFirstTimeDetected]) {
                    
                    //------------------Results BLOCK-----------------

                    self.result.bpm = (int)self.algorithm.bpmLatestResult;
                    self.result = nil;
                    self.algorithm = nil;
                    self.tabBarController.selectedIndex = 0;
                    
                    //------------------------------------------------
                    #warning - incomplete implementation
                }
                self.finalBPMLabel.text = [NSString stringWithFormat:@"Final BPM: %d , BPM2: %d" , (int)self.algorithm.bpmLatestResult , (int)self.algorithm2.bpmLatestResult];
                self.timeTillResultLabel.text = [NSString stringWithFormat:@"time till result: %.01fs" , TIME_TO_DETERMINE_BPM_FINAL_RESULT - [[NSDate date] timeIntervalSinceDate:self.bpmFinalResultFirstTimeDetected]];
                
            } else {
                self.finalBPMLabel.text = @"Final BPM: 0 , BPM2: 0";
                self.timeTillResultLabel.text = @"time till result:   ";
                self.bpmFinalResultFirstTimeDetected = nil;
                #warning - incomplete implementation
            }
            
            if (red < 210) {
                //finger isn't on camera
                
                if (self.settings.autoStopAfter) {
#warning - incomplete implementation
                    
                    if ([[NSDate date] timeIntervalSinceDate:self.algorithmStartTime] > self.settings.autoStopAfter) {
                        if (self.algorithm.isFinalResultDetermined) {
                            //------------------Results BLOCK-----------------
                            
                            self.result.bpm = (int)self.algorithm.bpmLatestResult;
                            self.result = nil;
                            self.algorithm = nil;
                            self.algorithm2 = nil;
                            self.algorithmStartTime = nil;
                            self.bpmFinalResultFirstTimeDetected = nil;
                            self.tabBarController.selectedIndex = 0;
                            
                            //------------------------------------------------
                            return;
                        }
                    }
                }
                
                else {
                    if (self.algorithm.isFinalResultDetermined) {
                        //------------------Results BLOCK-----------------
                        
                        self.result.bpm = (int)self.algorithm.bpmLatestResult;
                        self.result = nil;
                        self.algorithm = nil;
                        self.algorithm2 = nil;
                        self.algorithmStartTime = nil;
                        self.bpmFinalResultFirstTimeDetected = nil;
                        self.tabBarController.selectedIndex = 0;
                        
                        //------------------------------------------------
                        return;
                    }
                }
                
                self.fingerDetectLabel.text = @"שים את האצבע על המצלמה";
                self.bpmLabel.text = [NSString stringWithFormat:@"BPM: %d", 0];
                self.algorithm = nil;
                self.algorithm2 = nil;
                self.algorithmStartTime = nil;
                self.bpmFinalResultFirstTimeDetected = nil;
                return;
            }
            else {
                self.fingerDetectLabel.text = @"האלגוריתם התחיל";
                //show the time since the start
                self.timeLabel.text = [NSString stringWithFormat:@"time: %.01fs", [[NSDate date] timeIntervalSinceDate:self.algorithmStartTime]];
            }
            
            NSLog([NSString stringWithFormat:@"red: %.01f , green: %.01f , blue: %.01f" , red , green , blue]);
            
            if (self.algorithm.shouldShowLatestResult && self.algorithm2.shouldShowLatestResult) {
                self.bpmLabel.text = [NSString stringWithFormat:@"BPM: %.01f , BPM2: %.01f", self.algorithm.bpmLatestResult , self.algorithm2.bpmLatestResult];
            }
            else if (self.algorithm.shouldShowLatestResult) {
                self.bpmLabel.text = [NSString stringWithFormat:@"BPM: %.01f , BPM2: %d", self.algorithm.bpmLatestResult , 0];
            }
            else if (self.algorithm2.shouldShowLatestResult) {
                self.bpmLabel.text = [NSString stringWithFormat:@"BPM: %d , BPM2: %.01f", 0 , self.algorithm2.bpmLatestResult];
            }
            else {
                self.bpmLabel.text = [NSString stringWithFormat:@"BPM: %d , BPM2: %d", 0 , 0];
            }
            
        });
        
        [self playBeepSound];
    });
}

//

- (void)playBeepSound
{
    if (self.settings.beepWithPulse){
        if (self.algorithm.isPeakInLastFrame && !self.algorithm.isMissedTheLastPeak) {
            [self.BeepSound play];
        }
    }
}

- (void)heartAnimation
{
    ///*
    CGFloat gradientWidth = 2.0;
    CGFloat transparency = 0.5;
    
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    gradientMask.frame = self.beatingHeart.bounds;
    CGFloat gradientSize = gradientWidth / self.beatingHeart.frame.size.width;
    UIColor *gradient = [UIColor colorWithRed:0.9 green:0 blue:0 alpha:transparency];
    UIView *superview = self.beatingHeart.superview;
    NSArray *startLocations = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:(gradientSize / 2)], [NSNumber numberWithFloat:gradientSize]];
    NSArray *endLocations = @[[NSNumber numberWithFloat:(1.0f - gradientSize)], [NSNumber numberWithFloat:(1.0f -(gradientSize / 2))], [NSNumber numberWithFloat:1.0f]];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    
    gradientMask.colors = @[(id)gradient.CGColor, (id)[UIColor redColor].CGColor, (id)gradient.CGColor];
    gradientMask.locations = startLocations;
    gradientMask.startPoint = CGPointMake(0 - (gradientSize * 2), .5);
    gradientMask.endPoint = CGPointMake(1 + gradientSize, .5);
    
    [self.beatingHeart removeFromSuperview];
    self.beatingHeart.layer.mask = gradientMask;
    [superview addSubview:self.beatingHeart];
    
    animation.fromValue = startLocations;
    animation.toValue = endLocations;
    animation.repeatCount = 3.4e38f;
    animation.duration  = 3.0f;
    
    [gradientMask addAnimation:animation forKey:@"animateGradient"];
    //*/
    /*
    [UIView transitionWithView:self.beatingHeart
                      duration:1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.beatingHeart.layer.shadowColor = [[UIColor redColor] CGColor];
                        self.beatingHeart.layer.shadowOpacity = 1.0;
                        self.beatingHeart.layer.shadowRadius = 3;
                        self.beatingHeart.layer.zPosition = 1;
                    }
                    completion:^(BOOL fin){
                        if (fin) {
                            [UIView transitionWithView:self.beatingHeart
                                              duration:0.3
                                               options:UIViewAnimationOptionTransitionCrossDissolve
                                            animations:^{
                                                self.beatingHeart.layer.shadowOpacity = 0;
                                                self.beatingHeart.layer.shadowRadius = 0;
                                            }
                                            completion:NULL];
                        }
                    }];
     */
}

//

// Create a UIImage from sample buffer data
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return image;
}

@end
