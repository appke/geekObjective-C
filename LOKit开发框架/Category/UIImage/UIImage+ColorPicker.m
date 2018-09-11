//
//  UIImage+ColorPicker.m
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import "UIImage+ColorPicker.h"

@implementation UIImage(ColorPicker)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (int)pixelValueAtPoint:(CGPoint)point {
    int *data;
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    unsigned long   bitmapByteCount;
    unsigned long   bitmapBytesPerRow;
    
    size_t width = CGImageGetWidth(self.CGImage);
    size_t height = CGImageGetHeight(self.CGImage);
    
    bitmapBytesPerRow   = (width * 4);
    bitmapByteCount     = (bitmapBytesPerRow * height);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        return 0;
    }
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        CGColorSpaceRelease( colorSpace );
        return 0;
    }
    
    context = CGBitmapContextCreate (bitmapData,
                                     width,
                                     height,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        free (bitmapData);
        return 0;
    }

    CGRect rect = {{0,0},{width,height}};
    
    CGContextDrawImage(context, rect, self.CGImage);
    data = CGBitmapContextGetData (context);
    CGContextRelease(context);
    
    if (data == NULL) {
        return 0;
    }
    
    unsigned long w = point.x;
    if (point.x < 0) w = 0;
    if (point.x >= width) w = width-1;
    
    unsigned long h = point.y;
    if (point.y >= height) h = height-1;
    int pixelValue = data[h*width+w];
    free(data);
    
    return pixelValue;
}

@end
