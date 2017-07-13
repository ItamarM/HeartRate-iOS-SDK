//
//  HeartBeatAppDelegate.m
//  Heartbeat
//
//  Created by michael leybovich on 9/10/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import "HeartBeatAppDelegate.h"
#import "WelcomeScreenViewController.h"


@implementation HeartBeatAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"wasLaunchedBefore"]) {
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"wasLaunchedBefore"];
    } else {
        //self.window.rootViewController = [[WelcomeScreenViewController alloc] initWithNibName:@"WelcomeScreenViewController" bundle:nil];
    }
    //[self.window makeKeyAndVisible];
    
    return YES;
}


@end
