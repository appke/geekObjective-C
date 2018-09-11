//
//  LOLog.h
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#ifndef LOLog_h
#define LOLog_h

#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

#define LOLogVerbose(...) DDLogVerbose(__VA_ARGS__)
#define LOLogDebug(...) DDLogDebug(__VA_ARGS__)
#define LOLogInfo(...) DDLogInfo(__VA_ARGS__)
#define LOLogWarn(...) DDLogWarn(__VA_ARGS__)
#define LOLogError(...) DDLogError(__VA_ARGS__)

#else

static const DDLogLevel ddLogLevel = DDLogLevelWarning;

#define LOLogVerbose(fmt, ...)
#define LOLogDebug(fmt, ...)
#define LOLogInfo(fmt, ...)
#define LOLogWarn(fmt, ...)
#define LOLogError(fmt, ...)

#endif

@interface LOLogger : NSObject

+ (void)setup;

@end

#endif /* LOLog_h */
