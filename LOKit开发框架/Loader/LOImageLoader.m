//
//  LOImageLoader.m
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import "LOImageLoader.h"
#import "LOCommonMacro.h"
#import "LOFileUtil.h"
#import "LOLog.h"

NSString * imageConfigPlistPath = @"/image/config.plist";

@interface LOImageLoader()

@property (nonatomic, strong) NSMutableDictionary *imagePathDict;

@end

@implementation LOImageLoader

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithConfigPlistPath: imageConfigPlistPath];
    });
    return _sharedObject;
}

- (instancetype)initWithConfigPlistPath:(NSString *)path {
    if (self = [super init]) {
        [self loadImagePathFromConfigPlist:path];
    }
    
    return self;
}

+ (UIImage *)imageNamed:(NSString *)imageKey {
    return [[self class] imageNamed:imageKey sizeType:LOImageSizeType2X];
}

+ (UIImage *)imageNamed:(NSString *)imageKey sizeType:(LOImageSizeType)type {
    return [UIImage imageWithContentsOfFile:[[[self class] sharedInstance] pathForImage:imageKey imageSizeType:type]];
}

// 默认是2x
+ (CGSize)imageSize:(NSString*)imageKey {
    return [[self class] imageNamed:imageKey].size;
}

+ (CGSize)imageSizeSelfAdapted:(NSString*)imageKey {
    CGSize size = [[self class] imageSize:imageKey];
    return CGSizeMake(DIMENSION_SELF_ADAPT_375(size.width), DIMENSION_SELF_ADAPT_375(size.height));
}

- (void)loadImagePathFromConfigPlist:(NSString *)path {
    NSString *imageConfigPath = [LOFileUtil filePathAtResourceDir: path];
    self.imagePathDict = [[NSMutableDictionary alloc] initWithContentsOfFile:imageConfigPath];
}

- (NSString *)pathForImage:(NSString *)imageName imageSizeType:(LOImageSizeType)type {
    NSString *imagePath = [self.imagePathDict objectForKey:imageName];
    if (imagePath) {
        imagePath = [LOFileUtil filePathAtResourceDir:imagePath];
        switch (type) {
            case LOImageSizeType2X:
                imagePath = [imagePath stringByAppendingString:@"@2x.png"];
                break;
            case LOImageSizeType3X:
                imagePath = [imagePath stringByAppendingString:@"@3x.png"];
                break;
                
            default:
                break;
        }
        
        if (![LOFileUtil fileExistAtPath:imagePath]) {
            LOLogWarn(@"Image file missing: %@", imageName);
        }
    } else {
        LOLogWarn(@"Image file(%@) not found in config plist", imageName);
    }
    
    return imagePath;
}

@end
