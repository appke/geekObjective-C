//
//  LOFileUtil.h
//  Foundation
//
//  Created by 方立立 on 2017/8/29.
//
//

#import <Foundation/Foundation.h>

@interface LOFileUtil : NSObject

+ (NSString *)filePathAtResourceDir:(NSString *)fileName;
+ (NSString *)filePathAtDocumentDir:(NSString *)fileName;
+ (NSString *)filePathAtCacheDir:(NSString *)fileName;
+ (NSString *)filePathAtTempDir:(NSString *)fileName;
+ (BOOL)fileExistAtPath:(NSString *)path;
+ (BOOL)dirExistAtPath:(NSString *)path;
+ (BOOL)createFileAtPath:(NSString *)path;
+ (BOOL)createDirAtPath:(NSString *)path;
+ (BOOL)deleteFileAtPath:(NSString *)path;
+ (BOOL)copyFileAtPath:(NSString *)srcPath toPath:(NSString *)destPath;
+ (BOOL)writeFileAtPath:(NSString *)srcPath withData:(NSData *)data;
+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path;
+ (NSUInteger)sizeOfFileAtPath:(NSString *)path;
+ (NSUInteger)sizeOfDirectoryAtPath:(NSString *)path;

@end
