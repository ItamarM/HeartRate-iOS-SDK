//
//  UIImage+ImageAverageColor.m
//  Heartbeat
//
//  Created by Or Maayan on 9/14/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import "UIImage+ImageAverageColor.h"

@implementation UIImage (ImageAverageColor)

- (UIColor *)averageColorPrecise
{
    CGImageRef rawImageRef = self.CGImage;
    
    // This function returns the raw pixel values
	CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(rawImageRef));
    const UInt8 *rawPixelData = CFDataGetBytePtr(data);
    
    NSUInteger imageHeight = CGImageGetHeight(rawImageRef);
    NSUInteger imageWidth  = CGImageGetWidth(rawImageRef);
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(rawImageRef);
	NSUInteger stride = CGImageGetBitsPerPixel(rawImageRef) / 8;
    
    // Here I sort the R,G,B, values and get the average over the whole image
    unsigned int red   = 0;
    unsigned int green = 0;
    unsigned int blue  = 0;
    
	for (int row = 0; row < imageHeight; row++) {
		const UInt8 *rowPtr = rawPixelData + bytesPerRow * row;
		for (int column = 0; column < imageWidth; column++) {
            red    += rowPtr[2];
            green  += rowPtr[1];
            blue   += rowPtr[0];
			rowPtr += stride;
            
        }
    }
	CFRelease(data);
    
	CGFloat f = 1.0f / (255.0f * imageWidth * imageHeight);
	return [UIColor colorWithRed:f*red  green:f*green blue:f*blue alpha:1];
}

// should be at least four time faster than averageColorPrecise
// but the result isn't accurate, color values only given in integers (if multiplied by 255.0f)
- (UIColor *)averageColor
{
    CGSize size = {1, 1};
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
	[self drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
	uint8_t *data = CGBitmapContextGetData(ctx);
	UIColor *color = [UIColor colorWithRed:data[0] / 255.0f
									 green:data[1] / 255.0f
									  blue:data[2] / 255.0f
									 alpha:data[3]];
	UIGraphicsEndImageContext();
	return color;
    
    // another implemention that should work on every UIImage
    /*
     CGImageRef rawImageRef = [self CGImage];
     
     // scale image to an one pixel image
     
     uint8_t  bitmapData[4];
     int bitmapByteCount;
     int bitmapBytesPerRow;
     int width = 1;
     int height = 1;
     
     bitmapBytesPerRow = (width * 4);
     bitmapByteCount = (bitmapBytesPerRow * height);
     memset(bitmapData, 0, bitmapByteCount);
     CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
     CGContextRef context = CGBitmapContextCreate (bitmapData,width,height,8,bitmapBytesPerRow,
     colorspace,kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
     CGColorSpaceRelease(colorspace);
     CGContextSetBlendMode(context, kCGBlendModeCopy);
     CGContextSetInterpolationQuality(context, kCGInterpolationMedium);
     CGContextDrawImage(context, CGRectMake(0, 0, width, height), rawImageRef);
     CGContextRelease(context);
     return [UIColor colorWithRed:bitmapData[2] / 255.0f
     green:bitmapData[1] / 255.0f
     blue:bitmapData[0] / 255.0f
     alpha:1];
     */
}

@end
