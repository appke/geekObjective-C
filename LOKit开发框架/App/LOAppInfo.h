//
//  LOAppInfo.h
//  Foundation
//
//  Created by Keldon on 16/6/6.
//
//

#import <UIKit/UIKit.h>

@interface LOAppInfo : NSObject

// 设备信息
+ (NSString *)deviceIdentifier;
+ (NSString *)deviceName;
+ (NSString *)devicePlatform;
+ (NSString *)machineInfo;
+ (BOOL)isDevicePhone;
+ (BOOL)isDevicePad;
+ (NSString *)systemVersion;
+ (CGFloat)systemVersionValue;
+ (NSString*)preferredLanguage;
+ (BOOL)displayZoomed;
+ (BOOL)isJailBreak;
+ (BOOL)isSupportFingerAuthError:(NSError * __autoreleasing *)error;
+ (void)fingerAuth:(NSString *)hintString success:(void(^)(void))successBlock fail:(void(^)(NSError *))failBlock;

// 应用信息
+ (NSString *)appVersion;
+ (NSString *)appBuildVersion;
+ (NSString *)appBundleIdentifier;
+ (NSString *)appDisplayName;
+ (NSString *)appSchema:(NSString *)name;

// 授权信息
+ (BOOL)isCameraAuthorized;

@end
