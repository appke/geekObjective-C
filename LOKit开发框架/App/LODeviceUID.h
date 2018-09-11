//
//  LODeviceUID.h
//  Foundation
//
//  Created by 方立立 on 2016/10/26.
//
//

#import <Foundation/Foundation.h>

@interface LODeviceUID : NSObject

@property (nonatomic, copy, readonly) NSString *uid;

+ (LODeviceUID *)currentDevice;

@end
