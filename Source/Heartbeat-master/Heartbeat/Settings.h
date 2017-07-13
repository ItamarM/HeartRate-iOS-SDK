//
//  Settings.h
//  Heartbeat
//
//  Created by michael leybovich on 9/24/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (nonatomic) BOOL beepWithPulse;
@property (nonatomic, getter = isContinuousMode) BOOL continuousMode;
@property (nonatomic) NSUInteger autoStopAfter; // in seconds

+ (Settings *)defaultSettings;
+ (Settings *)currentSettings;

- (void)synchronize;

@end
