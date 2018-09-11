//
//  LOAppURLHandler.h
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import <Foundation/Foundation.h>

@interface LOAppURLHandler : NSObject

+ (void)openApplicationByURLString:(NSString *)urlString;
+ (void)callTel:(NSString *)phoneNo;

@end
