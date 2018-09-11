//
//  LOLog.m
//  LOKit
//
//  Created by 方立立 on 2017/9/4.
//  Copyright © 2017年 lili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LOLog.h"
#import "LOCustomFormatter.h"

@implementation LOLogger

+ (void)setup {
    [DDTTYLogger sharedInstance].logFormatter = [[LOCustomFormatter alloc] init];
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
//    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

@end
