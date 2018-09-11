//
//  LOGlobalMacro.h
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#ifndef LOGlobalMacro_h
#define LOGlobalMacro_h

#pragma mark - UI相关全局宏定义
#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height          //包含状态bar的高度(e.g. 480)

#define IS_IPHONEX (kScreenHeight == 812.0)
#define kNavigationBarHeight  (IS_IPHONEX ? 88 : 64)
#define kSafeAreaBottomHeight (IS_IPHONEX ? 34 : 0)
#define kSingleLineWidth ((IS_SCREEN_55_INCH) ? 0.33 : 0.5)

#pragma mark - 颜色
#define UIColorFromHexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromHexAndAlpha(rgbValue, A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]
#define UIColorFromRGBValue(R,G,B)    [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define UIColorFromRGBAValue(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#pragma mark- 设备尺寸
#define IS_SCREEN_4_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_35_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),  [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_47_INCH   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_55_INCH   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - 设备类型
#define TARGETED_DEVICE_IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define TARGETED_DEVICE_IS_IPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define TARGETED_DEVICE_IS_SIMULATOR (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

#pragma mark - 方法
#define SINGLETON_FOR_CLASS()\
+ (instancetype) sharedInstance {\
    static dispatch_once_t pred = 0;\
    static id _sharedObject = nil;\
    dispatch_once(&pred, ^{\
        _sharedObject = [[self alloc] init];\
    });\
    return _sharedObject;\
}

#define DIMENSION_SELF_ADAPT(width, height)\
(width > 0 ? height * kScreenWidth / width : 0)

#define DIMENSION_SELF_ADAPT_375(height) DIMENSION_SELF_ADAPT(375, height)

#endif /* LOGlobalMacro_h */
