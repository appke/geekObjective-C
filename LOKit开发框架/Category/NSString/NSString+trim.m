//
//  NSString+trim.m
//  MSZX
//
//  Created by Keldon on 14-3-24.
//  Copyright (c) 2014年 Keldon. All rights reserved.
//

#import "NSString+trim.h"

@implementation NSString (trim)

- (NSString *)spaceTrim:(NSString *)aString
{
    return [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
