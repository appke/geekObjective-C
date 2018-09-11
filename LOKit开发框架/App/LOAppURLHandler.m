//
//  LOAppURLHandler.m
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import "LOAppURLHandler.h"
#import "LOCommonMacro.h"
#import <UIKit/UIKit.h>

@implementation LOAppURLHandler

+ (void)openApplicationByURLString:(NSString *)urlString {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

+ (void)callTel:(NSString *)phoneNo {
    if (TARGETED_DEVICE_IS_IPHONE)
    {
        NSString *dialURL = [[NSString alloc] initWithFormat:@"tel://%@", phoneNo];
        [[self class] openApplicationByURLString:dialURL];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"此设备不支持电话功能!"
                                                           delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView performSelector:@selector(show) withObject:nil afterDelay:0.3];
    }
}

@end
