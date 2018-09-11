//
//  QHWebSocket.m
//  PACFB
//
//  Created by lili on 16/3/10.
//  Copyright © 2016年 Keldon. All rights reserved.
//

#import "LOWebSocket.h"
#import "LOLog.h"
#import <SocketRocket/SRWebSocket.h>

static const NSTimeInterval kReconnectTimeInterval = 15.0f;
static const int kMaxHeartBeatLostTime = 3;

@interface LOWebSocket()

@property (nonatomic, strong) SRWebSocket* webSocket;
@property (nonatomic, strong) dispatch_source_t heartBeatTimer;
@property (nonatomic, assign) int reconnectTime;
@property (nonatomic, assign) int pingTime;

@end

@implementation LOWebSocket

- (instancetype)initWithWebSocketURL:(NSString*)urlString {
    self = [super init];
    if (self) {
        _url = urlString;
        _heartBeatTimeInterval = 0;
        _reconnectMaxTime = 0;
        _pingTime = 0;
        _reconnectTime = 0;
    }
    return self;
}

#pragma mark - public method
- (BOOL)isConnected {
    return self.webSocket != nil && self.webSocket.readyState == SR_OPEN;
}

-(void)connect {
    [self destroy];
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.webSocket.delegate = self.delegate;
    LOLogVerbose(@"Connecting to websocket: %@", self.webSocket.url.absoluteString);
    [self.webSocket open];
}

-(void)startHeartBeat {
    if (self.heartBeatTimeInterval > 0) {
        if (self.heartBeatTimer) {
            dispatch_source_cancel(self.heartBeatTimer);
        }
        self.heartBeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(self.heartBeatTimer, dispatch_walltime(NULL, self.heartBeatTimeInterval * NSEC_PER_SEC), self.heartBeatTimeInterval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.heartBeatTimer, ^{
            LOLogVerbose(@"Send Ping.......");
            if ([self isConnected]) {
                self.pingTime ++;
                if (self.pingTime > kMaxHeartBeatLostTime) {
                    [self destroy];
                    // 是否需要重连
                    [self reconnect];
                } else {
                    [self sendPing];
                }
            } else {
                
            }
        });
        dispatch_resume(self.heartBeatTimer);
    } else {
        LOLogWarn(@"Heartbeat time is not set, so ping message will not send automatically");
    }
}

-(void)destroy {
    if (self.webSocket == nil) {
        return;
    }
    LOLogVerbose(@"Dstroying websocket: %@", [self.webSocket.url absoluteString]);
    [self disconnect];
    self.webSocket.delegate = nil;
    self.webSocket = nil;
}

- (void)sendText:(NSString*)text {
    [self sendMessage:text];
}

- (void)sendData:(NSData*)data {
    [self sendMessage:data];
}

-(void)reconnect {
    if (self.reconnectTime < self.reconnectMaxTime) {
        [self performSelector:@selector(reconnectWebSokcet) withObject:nil afterDelay:kReconnectTimeInterval];
    } else {
        LOLogWarn(@"Websocket %@ reconnect time is over max time", self.webSocket.url.absoluteString);
    }
}

-(void)resetPingTime {
    self.pingTime = 0;
}

#pragma mark - private method
-(void)reconnectWebSokcet {
    LOLogVerbose(@"Reconnecting %d ....", (int)self.reconnectTime);
    [self connect];
    self.reconnectTime ++;
}


-(void)sendPing {
    if ([self isConnected]) {
        [self.webSocket sendPing:[NSData data]];
    }
}

-(void)disconnect {
    self.pingTime = 0;
    if (self.heartBeatTimer) {
        LOLogVerbose(@"Closing heartbeat tiemr...");
        dispatch_source_cancel(self.heartBeatTimer);
        self.heartBeatTimer = nil;
    }
    if (self.isConnected) {
        LOLogVerbose(@"Closing websocket: %@", [self.webSocket.url absoluteString]);
        [self.webSocket close];
    }
}

-(void)sendMessage:(id)message {
    if (message && [self isConnected]) {
        LOLogVerbose(@"Sending message: %@", message);
        [self.webSocket send:message];
    }
}

@end
