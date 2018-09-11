//
//  UIImage+Blur.h
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import <UIKit/UIKit.h>

@interface UIImage(Blur)

- (UIImage *)imageBlur:(float)blur;
- (UIImage *)imageBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;
- (UIImage *)imageAddTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)imageAddLightEffect;
- (UIImage *)imageAddExtraLightEffect;
- (UIImage *)imageAddDarkEffect;

@end
