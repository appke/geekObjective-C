//
//  LOAppInfo.h.m
//  Foundation
//
//  Created by Keldon on 16/6/6.
//
//

#import "LOAppInfo.h"
#import "LODeviceUID.h"
#import <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "LOLog.h"

@implementation LOAppInfo

+ (NSString *)deviceIdentifier
{
    return [[LODeviceUID currentDevice] uid];
}

+ (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}

+ (NSString *)devicePlatform
{
    NSString *platform = [self machineInfo];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G （A1203）";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G （A1241/A1324）";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS （A1303/A1325）";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 （A1332）";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 （A1332）";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 （A1349）";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S （A1387/A1431）";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 （A1428）";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 （A1429/A1442）";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c （A1456/A1532）";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c （A1507/A1516/A1526/A1529）";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s （A1453/A1533）";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s （A1457/A1518/A1528/A1530）";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus （A1522/A1524）";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 （A1549/A1586）";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G （A1213）";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G （A1288）";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G （A1318）";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G （A1367）";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G （A1421/A1509）";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G （A1219/A1337）";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 （A1395）";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 （A1396）";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 （A1397）";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 （A1395+New Chip）";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G （A1432）";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G （A1454）";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G （A1455）";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 （A1416）";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 （A1403）";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 （A1430）";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 （A1458）";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 （A1459）";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 （A1460）";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air （A1474）";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air （A1475）";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air （A1476）";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G （A1489）";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G （A1490）";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G （A1491）";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (NSString *)machineInfo
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
    free(name);
    return machine;
}

+ (BOOL)isDevicePhone
{
    NSString * deviceType = [UIDevice currentDevice].model;
    
    if ([deviceType rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0)
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isDevicePad
{
    NSString * deviceType = [UIDevice currentDevice].model;
    
    if ([deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0)
    {
        return YES;
    }
    
    return NO;
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (CGFloat)systemVersionValue
{
    return [[[self class] systemVersion] floatValue];
}

+ (NSString*)preferredLanguage {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

+ (BOOL)displayZoomed {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    if (scale == 3 && width == 375) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isJailBreak {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        LOLogWarn(@"The device is jailbreak!!!");
        return YES;
    }
    
    return NO;
}

+ (BOOL)isSupportFingerAuthError:(NSError * __autoreleasing *)error {
    LAContext* context = [[LAContext alloc]init];
    if (!context) {
        return NO;
    }
    
    return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:error];
}

+ (void)fingerAuth:(NSString *)hintString success:(void(^)(void))successBlock fail:(void(^)(NSError *))failBlock {
    hintString = [hintString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!hintString.length) {
        hintString = @"验证指纹";
    }
    
    NSError* error = nil;
    if (![[self class] isSupportFingerAuthError:&error]) {
        failBlock(error);
        return;
    }
    
    LAContext* context = [[LAContext alloc]init];
    context.localizedFallbackTitle = @"";
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:hintString
                      reply:^(BOOL success, NSError *error) {
                          if (success) {
                              successBlock();
                          } else {
                              if (error.code == kLAErrorUserFallback) {
                                  LOLogVerbose(@"User tapped Enter Password");
                              } else if (error.code == kLAErrorUserCancel) {
                                  LOLogVerbose(@"User tapped Cancel");
                              } else {
                                  LOLogVerbose(@"Authenticated failed.");
                              }
                              failBlock(error);
                          };
                      }];
}

+ (NSString *)appVersion
{
	NSString *versionValue = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	return versionValue;
}

+ (NSString *)appBuildVersion
{
    NSString *versionValue = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return versionValue;
}

+ (NSString *)appBundleIdentifier
{
    static NSString * _identifier = nil;
    if (nil == _identifier)
    {
        _identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    }
    
    return _identifier;
}

+ (NSString *)appDisplayName
{
    NSString *value = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    return value;
}

+ (NSString *)appSchema:(NSString *)name
{
	NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
	for ( NSDictionary * dict in array )
	{
		if ( name )
		{
			NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
			if ( nil == URLName )
			{
				continue;
			}
            
			if ( NO == [URLName isEqualToString:name] )
			{
				continue;
			}
		}
        
		NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
		if ( nil == URLSchemes || 0 == URLSchemes.count )
		{
			continue;
		}
        
		NSString * schema = [URLSchemes objectAtIndex:0];
		if ( schema && schema.length )
		{
			return schema;
		}
	}
    
	return nil;
}

+ (BOOL)isCameraAuthorized {
    BOOL __block bResponse = NO;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted){
        bResponse = NO;
    } else if(status == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                bResponse = YES;
            }else{
                bResponse = NO;
            }
        }];
    } else {
        bResponse = YES;
    }
    return bResponse;
}

@end
