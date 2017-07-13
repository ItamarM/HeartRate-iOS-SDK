//
//  WelcomeScreenViewController.m
//  Heartbeat
//
//  Created by michael leybovich on 9/21/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import "WelcomeScreenViewController.h"

@implementation WelcomeScreenViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Hide navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    
    // background configuration
    UIImage *backgroundImage = [UIImage imageNamed:@"iphone_JPG.jpg"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self.view addSubview:backgroundView];
}

@end
