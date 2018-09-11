//
//  NSString+Base64.m
//  LOKit
//
//  Created by 方立立 on 2017/9/1.
//  Copyright © 2017年 lili. All rights reserved.
//

#import "NSString+Base64.h"
#import "GTMBase64.h"

@implementation NSString(Base64)

- (NSString *)base64Encoding {
    NSData *data = [GTMBase64 encodeData:[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)base64Decoding {
    NSData *data = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
