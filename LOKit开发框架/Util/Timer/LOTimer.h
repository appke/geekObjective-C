//
//  LOTimer.h
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import <Foundation/Foundation.h>

typedef void (^TimerCountdownBlock)(int);
typedef void (^TimerEndingBlock)(void);
typedef void (^TimerCancelBlock)(void);

@interface LOTimer : NSObject

@property (nonatomic, copy) TimerCountdownBlock countdownBlock;
@property (nonatomic, copy) TimerEndingBlock timerEndingBlock;
@property (nonatomic, copy) TimerCancelBlock timerCancelBlock;

- (instancetype)initWithTimeout:(int)timeout;
- (void)start;
- (void)cancle;

@end
