//
//  FacebookUserManager.m
//  Heartbeat
//
//  Created by or maayan on 12/01/13.
//  Copyright (c) 2013 Or Maayan. All rights reserved.
//


#import "FacebookUserManager.h"

@interface FacebookUserManager()

@property (nonatomic, weak, readwrite) FBSession *currentSession;

@end

static NSString *const SUUserIDKeyFormat = @"FacebookUserID";
static NSString *const SUUserNameKeyFormat = @"FacebookUserName";

@implementation FacebookUserManager

- (void)sendNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookUserManagerUserChanged"
                                                        object:nil];
}

- (FBSession *)currentSession {
    return FBSession.activeSession;
}

- (BOOL)isFacebookSessionActive{
    return self.currentSession.isOpen;
}

- (FBSession*)createSession{
    NSArray *permissions = @[@"basic_info",@"user_birthday"];
    // create a session object, with defaults accross the board
    FBSession *session = FBSession.activeSession.isOpen ? FBSession.activeSession : [[FBSession alloc] initWithAppID:nil
                                                                                                                permissions:permissions
                                                                                                            urlSchemeSuffix:nil
                                                                                                         tokenCacheStrategy:nil];
    FBSession.activeSession = session;
    return session;
}

- (NSString*)getUserID{
    if (!_userName) {
        NSString *key = [NSString stringWithFormat:SUUserIDKeyFormat];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _userId = [defaults objectForKey:key];
    }
    return _userId;
}

- (NSString*)userName{
    if (!_userName) {
        NSString *key = [NSString stringWithFormat:SUUserNameKeyFormat];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _userName = [defaults objectForKey:key];
    }
    return _userName;
}

- (void)updateUser:(NSDictionary<FBGraphUser> *)user {

    NSString *idKey = [NSString stringWithFormat:SUUserIDKeyFormat];
    NSString *nameKey = [NSString stringWithFormat:SUUserNameKeyFormat];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (user != nil) {
        NSLog(@"FacebookUserManager updating..., fbid = %@, name = %@", user.id, user.name);
        
        self.userId = user.id;
        self.userName = user.name;
        
        [defaults setObject:user.id forKey:idKey];
        [defaults setObject:user.name forKey:nameKey];
    } else {
        NSLog(@"FacebookUserManager clearing user...");

        // Can't be current user anymore
        [self switchToNoActiveUser];
        
        self.userName = nil;
        self.userId = nil;
        // Also need to remove the user from useDefaults
        [defaults removeObjectForKey:idKey];
        [defaults removeObjectForKey:nameKey];
    }

    [defaults synchronize];
}

- (void)switchToNoActiveUser {
    NSLog(@"FacebookUserManager switching to no active user");

    [self sendNotification];
}

- (FBSession *)switchToUser {

    FBSession *session = [self createSession];

    self.currentSession = session;

    [self sendNotification];

    return session;
}

@end
