//
//  NSData+Encryption.h
//  MSZX
//
//  Created by Keldon on 14-11-11.
//  Copyright (c) 2014年 Keldon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES : NSObject

// 加密
+ (NSData *)encryptData:(NSData *)data key:(NSString *)key;
+ (NSString *)encryptString:(NSString *)string key:(NSString *)key;

// 解密
+ (NSData *)decryptData:(NSData *)data key:(NSString *)key;
+ (NSString *)decryptString:(NSString *)string key:(NSString *)key;

@end
