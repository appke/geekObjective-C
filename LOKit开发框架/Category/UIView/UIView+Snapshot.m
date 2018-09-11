//
//  UIView+Snapshot.m
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import "UIView+Snapshot.h"

@implementation UIView(Snapshot)

- (UIImage *)snapshot {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage* snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

@end
