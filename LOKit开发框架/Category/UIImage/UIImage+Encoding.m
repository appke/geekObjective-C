//
//  UIImage+Encoding.m
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import "UIImage+Encoding.h"
#import "GTMBase64.h"

@implementation UIImage(Encoding)

- (NSString *)base64EncodingString {
    return [GTMBase64 stringByEncodingData:UIImagePNGRepresentation(self)];
}

@end
