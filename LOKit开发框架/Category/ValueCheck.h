//
//  NSDictionary+ValueErrorCheck.h
//  MSZX
//
//  Created by Keldon on 14/11/13.
//  Copyright (c) 2014年 Keldon. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (ValueCheck)

- (BOOL)isNotEmpty;

@end

@interface NSDictionary (ValueCheck)

- (BOOL)isNotEmpty;
- (id)objectCheckForKey:(id)key;

@end

@interface NSArray (ValueCheck)

- (BOOL)isNotEmpty;

@end
