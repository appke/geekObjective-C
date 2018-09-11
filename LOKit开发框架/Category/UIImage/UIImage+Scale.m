//
//  UIImage+Scale.m
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import "UIImage+Scale.h"
#import "LOLog.h"
#import "UIImage+Resize.h"

#define COMPRESS_SCALE 0.6

@implementation UIImage(Scale)

- (UIImage*)imageScaledToConstrainSize:(CGSize)targetSize {
#define radians( degrees ) ( degrees * M_PI / 180 )
    CGFloat rawWidth = floorf(targetSize.width);
    CGFloat targetWidth;
    CGFloat targetHeight;
    
    CGImageRef imageRef = [self CGImage];
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown ||
        self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored)
    {
        if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
            targetWidth = CGImageGetWidth(imageRef);
            targetHeight = CGImageGetHeight(imageRef);
        }
        else if (rawWidth>=CGImageGetWidth(imageRef))
        {
            targetWidth = CGImageGetWidth(imageRef);
            targetHeight = CGImageGetHeight(imageRef);
        }
        else
        {
            targetWidth = rawWidth;
            targetHeight = CGImageGetHeight(imageRef)*rawWidth/CGImageGetWidth(imageRef);
        }
    }
    else
    {
        if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
            targetWidth = CGImageGetHeight(imageRef);
            targetHeight = CGImageGetWidth(imageRef);
        }
        else if (rawWidth>=CGImageGetHeight(imageRef))
        {
            targetWidth = CGImageGetHeight(imageRef);
            targetHeight = CGImageGetWidth(imageRef);
        }
        else
        {
            targetWidth = rawWidth;
            targetHeight = CGImageGetWidth(imageRef)*rawWidth/CGImageGetHeight(imageRef);
        }
    }
    
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little;
    CGColorSpaceRef colorSpaceInfo =CGColorSpaceCreateDeviceRGB();;//CGImageGetColorSpace(imageRef);
    
    CGContextRef bitmap;
    
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown ||
        self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored) {
        
        //bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, 8/*CGImageGetBitsPerComponent(imageRef)*/, (4 * targetWidth), colorSpaceInfo, bitmapInfo);
        
    } else {
        // bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, 8/*CGImageGetBitsPerComponent(imageRef)*/, (4 * targetWidth), colorSpaceInfo, bitmapInfo);
        
    }
    CGAffineTransform transform = [self transformForOrientation:CGSizeMake(targetWidth, targetHeight)];
    CGContextConcatCTM(bitmap, transform);
    /*
     if (sourceImage.imageOrientation == UIImageOrientationLeft) {
     CGContextRotateCTM (bitmap, radians(90));
     CGContextTranslateCTM (bitmap, 0, -targetWidth);
     
     } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
     CGContextRotateCTM (bitmap, radians(-90));
     CGContextTranslateCTM (bitmap, -targetHeight, 0);
     
     } else if (sourceImage.imageOrientation == UIImageOrientationUp )
     {}
     else if (sourceImage.imageOrientation == UIImageOrientationUpMirrored)
     {
     CGContextScaleCTM(bitmap, -1, 1);
     CGContextTranslateCTM (bitmap, -targetWidth, 0);
     } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
     CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
     CGContextRotateCTM (bitmap, radians(-180.));
     }
     */
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown
        || self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored) {
        
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    } else {
        CGContextDrawImage(bitmap, CGRectMake(0, 0, targetHeight, targetWidth), imageRef);
    }
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGColorSpaceRelease(colorSpaceInfo);
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

- (UIImage*)imageScaleForWeChat {
    CGFloat scale = 1.0;
    CGFloat width = 240;
    
    UIImage* thumbImage = nil;
    //1.调整长宽比,将图片大小压缩至适当大小
    if (self.size.height/self.size.width >= 3) {
        UIImage* cropImage = [self croppedImage:CGRectMake(0, self.size.width/2, self.size.width, self.size.width*1.5)];
        thumbImage = [cropImage imageScaledToConstrainSize:CGSizeMake(200, 200)];
    }else{
        thumbImage = [self imageScaledToConstrainSize:CGSizeMake(width, width)];
    }
    CGFloat imageSize = UIImageJPEGRepresentation(thumbImage, 1.0).length/1024.0;
    LOLogVerbose(@"thumbImage for 200pix width size:%f KB",imageSize);
    if (imageSize<32.0) {
        return thumbImage;
    }
    //2.调整压缩比使图片趋近32KB同时保证压缩比不低于0.6
    while (imageSize > 32.0 && scale >= COMPRESS_SCALE)
    {
        scale = scale-0.05;
        imageSize = UIImageJPEGRepresentation(thumbImage, scale).length/1024.0;
        LOLogVerbose(@"thumbImage size:%.1f KB width:%.1f height:%.1f compress:%.2f",imageSize, thumbImage.size.width, thumbImage.size.height, scale);
    }
    if(imageSize < 32.0)
    {
        thumbImage = [UIImage imageWithData:UIImageJPEGRepresentation(thumbImage, scale)];
    }else{
        while (imageSize > 32.0 && width > 0) {
            width = width - 10;
            thumbImage = [self imageScaledToConstrainSize:CGSizeMake(width, width)];
            imageSize = UIImageJPEGRepresentation(thumbImage, COMPRESS_SCALE).length/1024.0;
            LOLogVerbose(@"thumbImage size:%.1f KB width:%.1f height:%.1f compress:%.2f",imageSize, thumbImage.size.width, thumbImage.size.height,COMPRESS_SCALE);
        }
        thumbImage = [UIImage imageWithData:UIImageJPEGRepresentation(thumbImage, COMPRESS_SCALE)];
    }
    return thumbImage;
}

@end
