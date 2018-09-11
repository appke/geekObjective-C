//
//  UIImage+Scale.h
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import <UIKit/UIKit.h>

@interface UIImage(Scale)

- (UIImage*)imageScaledToConstrainSize:(CGSize)targetSize;
- (UIImage*)imageScaleForWeChat;

@end
