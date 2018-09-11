//
//  NSData+Encryption.m
//  MSZX
//
//  Created by Keldon on 14-11-11.
//  Copyright (c) 2014年 Keldon. All rights reserved.
//

#import "AES.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation AES

// 实现的是256位AES加解密
+ (NSData *)encryptData:(NSData *)data key:(NSString *)key {
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+ (NSString *)encryptString:(NSString *)string key:(NSString *)key {
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encodedData = [AES encryptData:data key:key];
    NSString *postString = [GTMBase64 stringByEncodingData:encodedData];
    
    return postString;
}

+ (NSData *)decryptData:(NSData *)data key:(NSString *)key {
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

+ (NSString *)decryptString:(NSString *)string key:(NSString *)key {
    NSData* data = [GTMBase64 decodeString:string];
    NSData* decodedData =  [AES decryptData:data key:key];
    NSString* requestString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    return requestString;
}


@end
