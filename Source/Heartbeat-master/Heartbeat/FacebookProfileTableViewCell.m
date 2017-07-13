//
//  FacebookProfileTableViewCell.m
//  Heartbeat
//
//  Created by or maayan on 12/01/13.
//  Copyright (c) 2013 Or Maayan. All rights reserved.
//

#import "FacebookProfileTableViewCell.h"

@implementation FacebookProfileTableViewCell

#define leftMargin 4
#define topMargin 4
#define rightMargin 24
#define pictureWidth 56
#define pictureHeight 56

#pragma mark - Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        [self initializeSubViews];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeSubViews];
    }
    return self;
}

- (void)initializeSubViews {
    FBProfilePictureView *profilePic = [[FBProfilePictureView alloc]
                                        initWithFrame:CGRectMake(leftMargin,
                                                                 topMargin,
                                                                 pictureWidth,
                                                                 pictureHeight)];
    self.profilePic = profilePic;

    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook-cell-background-1x5.png"]];
    self.backgroundView.alpha = 1;
    
    self.clipsToBounds = YES;
    self.autoresizesSubviews = YES;
    
    //currently there is a bug when displaying the label for the first time
    self.textLabel.hidden = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (FBSession.activeSession.isOpen){
        [self.loginView removeFromSuperview];
        
        self.textLabel.frame = CGRectMake(leftMargin * 2 + pictureWidth,
                                          topMargin,
                                          self.bounds.size.width - (leftMargin * 2 + pictureWidth)*2 - rightMargin,
                                          self.bounds.size.height - topMargin*2);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [self.textLabel.font fontWithSize:20];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        //self.textLabel.hidden = NO;
        [self addSubview:self.profilePic];
    } else {
        [self.profilePic removeFromSuperview];
        //self.textLabel.hidden = YES;
        
        self.loginView.frame = self.bounds;
        self.loginView.clipsToBounds = YES;
        [self addSubview:self.loginView];
    }
}

#pragma mark - Properties

- (NSString*)userID {
    return self.profilePic.profileID;
}

- (void)setUserID:(NSString *)userID {
    // Setting the profileID property of the profile picture view causes the view to fetch and display
    // the profile picture for the given user
    self.profilePic.profileID = userID;
}

- (NSString*)userName {
    return self.textLabel.text;
}

- (void)setUserName:(NSString *)userName {
    self.textLabel.text = userName;
}

#warning need to check if [self setNeedsDisplay] necessary in these methods (probably not)

- (void)setProfilePic:(FBProfilePictureView *)profilePic {
    _profilePic = profilePic;
}

- (void)setLoginView:(FBLoginView *)loginView {
    _loginView = loginView;
}

#pragma mark - Public API

#define LoginViewHeight 45 // login view is 45 height maximum
#warning probably shouldn't use here magic number

- (CGFloat)desiredCellHeight {
    if (!FBSession.activeSession.isOpen){
        return LoginViewHeight;
    } else {
        return topMargin * 2 + pictureHeight;
    }
}

@end
