//
//  Settings.m
//  Heartbeat
//
//  Created by michael leybovich on 9/24/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import "Settings.h"

@interface Settings()

@end

@implementation Settings

#define ALL_SETTINGS_KEY @"Setings_All"

#define BEEP_WITH_PULSE_KEY @"beepWithPulse"
#define CONTINUOUS_MODE_KEY @"continuousMode"
#define AUTO_STOP_AFTER_KEY @"autoStopAfter"

- (id)asPropertyList
{
    return @{ BEEP_WITH_PULSE_KEY : @(self.beepWithPulse), CONTINUOUS_MODE_KEY : @(self.isContinuousMode), AUTO_STOP_AFTER_KEY : @(self.autoStopAfter) };
}

+ (Settings *)defaultSettings
{
    Settings *settings = [[Settings alloc] init];
    
    settings.beepWithPulse = YES;
    settings.continuousMode = NO;
    settings.autoStopAfter = 20;
    
    return settings;
}

+ (Settings *)currentSettings
{
    NSDictionary *settingsFromUserDefaulats = [[NSUserDefaults standardUserDefaults] objectForKey:ALL_SETTINGS_KEY];
    
    Settings *currentSettings = [[Settings alloc] init];
    
    if (!settingsFromUserDefaulats) {
        currentSettings = [Settings defaultSettings];
        [currentSettings synchronize];
        
    } else {
        currentSettings.beepWithPulse = [settingsFromUserDefaulats[BEEP_WITH_PULSE_KEY] boolValue];
        currentSettings.continuousMode = [settingsFromUserDefaulats[CONTINUOUS_MODE_KEY] boolValue];
        currentSettings.autoStopAfter = [settingsFromUserDefaulats[AUTO_STOP_AFTER_KEY] unsignedIntegerValue];
    }
    return currentSettings;
}

- (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] setObject:[self asPropertyList] forKey:ALL_SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
