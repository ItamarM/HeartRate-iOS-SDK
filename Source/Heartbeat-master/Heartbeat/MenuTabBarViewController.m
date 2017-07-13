//
//  MenuTabBarViewController.m
//  Heartbeat
//
//  Created by michael leybovich on 9/30/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import "MenuTabBarViewController.h"
#import "ResultsViewController.h"

@interface MenuTabBarViewController () <UITabBarDelegate>

@end

@implementation MenuTabBarViewController

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (self.selectedIndex == 0) {
        if ([self.viewControllers[0] isKindOfClass:[UINavigationController class]]) {
            if ([[(UINavigationController *)self.viewControllers[0] visibleViewController] isKindOfClass:[ResultsViewController class]]) {
                [(ResultsViewController *)[(UINavigationController *)self.viewControllers[0] visibleViewController] scrollToTop];
            };
        }
        if ([self.viewControllers[0] isKindOfClass:[ResultsViewController class]]) {
            [self.viewControllers[0] scrollToTop];
        };
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.selectedIndex = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
