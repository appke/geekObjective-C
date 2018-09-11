//
//  LOCustomFormatter.m
//  LOKit
//
//  Created by 方立立 on 2017/9/22.
//  Copyright © 2017年 lili. All rights reserved.
//

#import "LOCustomFormatter.h"

@interface LOCustomFormatter()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LOCustomFormatter

- (instancetype)init {
    if (self = [super init]) {
        _dateFormatter= [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    }
    
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"💔 ERROR"; break;
        case DDLogFlagWarning  : logLevel = @"💛 WARN"; break;
        case DDLogFlagInfo     : logLevel = @"💚 INFO"; break;
        case DDLogFlagDebug    : logLevel = @"💙 DEBUG"; break;
        case DDLogFlagVerbose  : logLevel = @"💜 VERBOSE"; break;
        default                : logLevel = @"🖤 UNKNOWN"; break;
    }
    
    NSString *dateAndTime = [self.dateFormatter stringFromDate:(logMessage->_timestamp)];
    
    return [NSString stringWithFormat:@"%@ %@ %@ [%@] - %@", dateAndTime, logLevel, logMessage->_function, logMessage->_threadID, logMessage->_message];
}

@end
