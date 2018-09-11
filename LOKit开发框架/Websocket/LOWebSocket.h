//
//  QHWebSocket.h
//  PACFB
//
//  Created by lili on 16/3/10.
//  Copyright © 2016年 Keldon. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol SRWebSocketDelegate;

@interface LOWebSocket : NSObject

@property (nonatomic, assign, readonly) BOOL isConnected;
@property (nonatomic, assign) int heartBeatTimeInterval;
@property (nonatomic, assign) int reconnectMaxTime;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, weak) id<SRWebSocketDelegate> delegate;

- (instancetype)initWithWebSocketURL:(NSString*)urlString;

- (void)reconnect;
- (void)connect;
- (void)startHeartBeat;
- (void)sendText:(NSString*)text;
- (void)sendData:(NSData*)data;
- (void)destroy;
- (void)resetPingTime;

@end
