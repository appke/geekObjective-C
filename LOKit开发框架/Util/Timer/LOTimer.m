//
//  LOTimer.m
//  Foundation
//
//  Created by 方立立 on 2017/8/30.
//
//

#import "LOTimer.h"

@interface LOTimer()

@property (nonatomic, assign) int timeout;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation LOTimer

- (instancetype)initWithTimeout:(int)timeout {
    if (self = [super init]) {
        _timeout = timeout;
    }
    return self;
}

- (void)start {
    [self cancle];
    __block int timeout = self.timeout;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        ///倒计时结束
        if (timeout <= 0) {
            [self cancle];
            if (self.timerEndingBlock) {
                dispatch_async(dispatch_get_main_queue(), self.timerEndingBlock);
            }
        }
        ///倒计时进行中
        else {
            if (self.countdownBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.countdownBlock(timeout);
                });
            }
            timeout --;
        }
    });
    dispatch_source_set_cancel_handler(self.timer, ^{
        if (self.timerCancelBlock) {
            dispatch_async(dispatch_get_main_queue(), self.timerCancelBlock);
        }
    });
    
    dispatch_resume(self.timer);
}

-(void)cancle {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

@end
