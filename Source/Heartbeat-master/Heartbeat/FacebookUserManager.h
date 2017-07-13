//
//  FacebookUserManager.h
//  Heartbeat
//
//  Created by or maayan on 12/01/13.
//  Copyright (c) 2013 Or Maayan. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import <FacebookSDK/FacebookSDK.h>

@protocol FBGraphUser;

@interface FacebookUserManager : NSObject

@property (strong , nonatomic) NSString *userId;
@property (strong , nonatomic) NSString *userName;

- (void)updateUser:(NSDictionary<FBGraphUser> *)user;

- (BOOL)isLoggedIn;

- (void)switchToNoActiveUser;
- (FBSession *)switchToUser;

@end
