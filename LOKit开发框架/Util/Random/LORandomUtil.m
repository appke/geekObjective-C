//
//  RandomUtil.m
//  OCComponent
//
//  Created by 方立立 on 2017/8/23.
//  Copyright © 2017年 lili. All rights reserved.
//

#import "LORandomUtil.h"

@implementation LORandomUtil

+ (NSString *)randomStringOfLength:(NSUInteger)length {
    char data[length];
    for (int i = 0; i < length; data[i++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

@end
