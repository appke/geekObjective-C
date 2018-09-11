//
//  UIImage+ColorPicker.h
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import <UIKit/UIKit.h>

@interface UIImage(ColorPicker)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (int)pixelValueAtPoint:(CGPoint)point;

@end
