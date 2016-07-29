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

    CGContextRef context = CGBitmapContextCreate(pixelData,

                                                 1,

                                                 1,

                                                 bitsPerComponent,

                                                 bytesPerRow,

                                                 colorSpace,

                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

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


+(UIImage *)fullScreenshots{

    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window

    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();


    return viewImage;
    
}

+(UIColor*) getPixelColorAtLocation:(CGPoint)point withImage:(UIImage*) image {
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }

    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};

    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);

    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
            NSLog(@"offset: %d", offset);
            int alpha =  data[offset];
            int red = data[offset+1];
            int green = data[offset+2];
            int blue = data[offset+3];
            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
        }

    }

    return color;
}
+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {

    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;

    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);

    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);

    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();

    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color spacen");
        return NULL;
    }

    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }

    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

@end
