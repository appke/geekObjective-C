//
//  LOImageLoader.h
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LOImageSizeType) {
    LOImageSizeType2X,
    LOImageSizeType3X
};

extern NSString * imageConfigPlistPath;

@interface LOImageLoader : NSObject

+ (UIImage *)imageNamed:(NSString *)imageKey;
+ (UIImage *)imageNamed:(NSString *)imageKey sizeType:(LOImageSizeType)type;
+ (CGSize)imageSize:(NSString*)imageKey;
+ (CGSize)imageSizeSelfAdapted:(NSString*)imageKey;

@end
