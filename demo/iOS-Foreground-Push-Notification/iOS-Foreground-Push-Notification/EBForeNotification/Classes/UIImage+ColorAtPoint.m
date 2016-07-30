//
//  UIImage+ColorAtPoint.m
//  EBForeNotification
//
//  Created by wuxingchen on 16/7/22.
//  Copyright © 2016年 57380422@qq.com. All rights reserved.
//

#import "UIImage+ColorAtPoint.h"

@implementation UIImage (ColorAtPoint)

+(UIColor *)colorAtPoint:(CGPoint)point{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window

    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();

    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, viewImage.size.width, viewImage.size.height), point)) {
        return nil;
    }

    NSInteger pointX = trunc(point.x);

    NSInteger pointY = trunc(point.y);

    CGImageRef cgImage = viewImage.CGImage;

    NSUInteger width = viewImage.size.width;

    NSUInteger height = viewImage.size.height;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    int bytesPerPixel = 4;

    int bytesPerRow = bytesPerPixel * 1;

    NSUInteger bitsPerComponent = 8;

    unsigned char pixelData[4] = { 0, 0, 0, 0 };

    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGColorSpaceRelease(colorSpace);

    CGContextSetBlendMode(context, kCGBlendModeCopy);


    // Draw the pixel we are interested in onto the bitmap context

    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);

    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);

    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    
    CGFloat red = (CGFloat)pixelData[0] / 255.0f;
    
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    
    CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
    
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
