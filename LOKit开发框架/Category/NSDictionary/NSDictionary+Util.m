//
//  NSDictionary+Util.m
//  LOKit
//
//  Created by 方立立 on 2017/9/1.
//  Copyright © 2017年 lili. All rights reserved.
//

#import "NSDictionary+Util.h"

@implementation NSDictionary(Util)

- (NSDictionary *)merge:(NSDictionary *)dictionary {
    NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [newDict addEntriesFromDictionary:self];
    return [newDict copy];
}

@end
