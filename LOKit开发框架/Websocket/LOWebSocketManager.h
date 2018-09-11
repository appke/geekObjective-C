//
//  QHWebSocketHandler.h
//  PACFB
//
//  Created by lili on 16/3/10.
//  Copyright © 2016年 Keldon. All rights reserved.
//  接收到数据时 目前采用的是异步处理 这就要求在delegate中如果要更新页面展示的话 必须要指定主线程执行

#import <UIKit/UIKit.h>
#import "LOWebSocket.h"

@protocol LOWebSocketDelegate <NSObject>

- (void)webSocket:(LOWebSocket *)webSocket didReceiveTextMessage:(NSString*)message;
- (void)webSocket:(LOWebSocket *)webSocket didReceiveBinaryMessage:(NSData*)message;

@optional

- (void)webSocketDidOpen:(LOWebSocket *)webSocket;
- (void)webSocket:(LOWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(LOWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
- (void)webSocket:(LOWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
- (void)applicationDidEnterBackground;
- (BOOL)shouldReconnectAfterApplicationEnterForeground;

@end

@interface LOWebSocketManager : NSObject

+ (LOWebSocketManager *)manager;

- (LOWebSocket *)createWebSocketWithURL:(NSString*)url delegate:(id<LOWebSocketDelegate>)delegate;
- (void)removeWebSocketWithURL:(NSString*)url;
- (LOWebSocket *)webSocketWithURL:(NSString*)url;
- (void)destroyAll;

@end
