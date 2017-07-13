//
//  UIImage+ImageAverageColor.h
//  Heartbeat
//
//  Created by Or Maayan on 9/14/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageAverageColor)

- (UIColor *)averageColor;
- (UIColor *)averageColorPrecise;

@end
