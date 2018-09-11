//
//  QHWebSocketHandler.m
//  PACFB
//
//  Created by lili on 16/3/10.
//  Copyright © 2016年 Keldon. All rights reserved.
//

#import "LOWebSocketManager.h"
#import "LOLog.h"
#import <SocketRocket/SRWebSocket.h>

static dispatch_queue_t app_websocket_manager_processing_queue() {
    static dispatch_queue_t lo_app_websocket_manager_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lo_app_websocket_manager_processing_queue = dispatch_queue_create("com.lo.websocket.manager.processing", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return lo_app_websocket_manager_processing_queue;
}

@interface LOWebSocketManager() <SRWebSocketDelegate>

@property (nonatomic, strong) NSMutableDictionary* webSocketDelegates;
@property (nonatomic, strong) NSMutableDictionary<NSString*, LOWebSocket*>* webSockets;

@end

@implementation LOWebSocketManager

+(LOWebSocketManager*)manager {
    static LOWebSocketManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _webSockets = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

#pragma mark - public method
- (LOWebSocket *)createWebSocketWithURL:(NSString*)url delegate:(id<LOWebSocketDelegate>)delegate {
    LOWebSocket *socket = [self webSocketWithURL:url];
    if (socket == nil) {
        socket = [[LOWebSocket alloc] initWithWebSocketURL:url];
        socket.delegate = self;
        [self.webSockets setObject:socket forKey:url];
    }
    [self.webSocketDelegates setObject:delegate forKey:url];
    
    return socket;
}

- (LOWebSocket *)webSocketWithURL:(NSString *)url {
    return [self.webSockets objectForKey:url];
}

- (void)removeWebSocketWithURL:(NSString *)url {
    [self.webSockets removeObjectForKey:url];
    [self.webSocketDelegates removeObjectForKey:url];
}

- (void)applicationDidEnterBackground {
    LOLogVerbose(@"Application enter background, start to closing all websockets");
    [self.QHWebSockets enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, LOWebSocket * _Nonnull obj, BOOL * _Nonnull stop) {
        id<LOWebSocketDelegate> delegate = [self.webSocketDelegates objectForKey:key];
        if (delegate && [delegate respondsToSelector:@selector(applicationDidEnterBackground)]) {
            [delegate applicationDidEnterBackground];
        }
        [obj destroy];
    }];
}

- (void)applicationWillEnterForeground {
    LOLogVerbose(@"Application enter foreground, start to opening all websockets");
    [self.webSockets enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, LOWebSocket * _Nonnull obj, BOOL * _Nonnull stop) {
        id<LOWebSocketDelegate> delegate = [self.webSocketDelegates objectForKey:key];
        if (!delegate ||([delegate respondsToSelector:@selector(shouldReconnectAfterApplicationEnterForeground)]
            && [delegate shouldReconnectAfterApplicationEnterForeground])) {
            [obj connect];
        }
    }];
}

- (void)destroyAll {
    [self.webSockets enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, LOWebSocket * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj destroy];
        // 销毁所有websocket 目前来看只有在应用退出时使用 暂时不调用任何delegate方法
    }];
    [self.webSockets removeAllObjects];
    [self.webSocketDelegates removeAllObjects];
}

#pragma mark - SRWebSocketDelegate
// 消息处理还是都不走异步，如果需要异步，由代理自行起异步线程去处理
// 理论上所有的消息处理以及其他消息都是在后台异步处理，然后调用代理的方法应当走主线程去调用
// 但是目前用不到在主线程去调用，所以其他方法都放在异步线程去处理
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    LOLogVerbose(@"Websocket(%@) recieved message: %@", [webSocket.url absoluteString], message);
    LOWebSocket* socket = [self.QHWebSockets objectForKey:[webSocket.url absoluteString]];
    id<LOWebSocketDelegate> delegate = [self.webSocketDelegates objectForKey:[webSocket.url absoluteString]];
    if (delegate && socket) {
        if ([message isKindOfClass:[NSString class]]) {
            [delegate webSocket:socket didReceiveTextMessage:(NSString*)message];
        } else if([message isKindOfClass:[NSData class]]) {
            [delegate webSocket:socket didReceiveBinaryMessage:(NSData *)message];
        } else {
            
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    LOLogVerbose(@"Websocket %@ connected", [webSocket.url absoluteString]);
    dispatch_async(app_websocket_manager_processing_queue(), ^{
        LOWebSocket* socket = [self.QHWebSockets objectForKey:[webSocket.url absoluteString]];
        if (socket) {
            [socket startHeartBeat];
            id<LOWebSocketDelegate> delegate = [self.webSocketDelegates objectForKey:[webSocket.url absoluteString]];
            if (delegate && [delegate respondsToSelector:@selector(webSocketDidOpen:)]) {
                [delegate webSocketDidOpen:socket];
            }
        }
    });
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    LOLogVerbose(@"Websocket %@ connect failed, reason: %@", [webSocket.url absoluteString], error);
    dispatch_async(app_websocket_manager_processing_queue(), ^{
        LOWebSocket* socket = [self.QHWebSockets objectForKey:[webSocket.url absoluteString]];
        if (socket) {
            id<LOWebSocketDelegate> delegate = [self.webSocketDelegates objectForKey:[webSocket.url absoluteString]];
            if (delegate) {
                if ([delegate respondsToSelector:@selector(webSocket:didFailWithError:)]) {
                    [delegate webSocket:socket didFailWithError:error];
                }
            }
            [socket reconnect];
        }
    });
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    LOLogVerbose(@"Websocket %@ closed", [webSocket.url absoluteString]);
    dispatch_async(app_websocket_manager_processing_queue(), ^{
        LOWebSocket* socket = [self.QHWebSockets objectForKey:[webSocket.url absoluteString]];
        if (socket) {
            id<LOWebSocketDelegate> delegate = [self.webSocketDelegates objectForKey:[webSocket.url absoluteString]];
            if (delegate) {
                if ([delegate respondsToSelector:@selector(webSocket:didCloseWithCode:reason:wasClean:)]) {
                    [delegate webSocket:socket didCloseWithCode:code reason:reason wasClean:wasClean];
                }
            }
            [socket reconnect];
        }
    });
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    LOLogVerbose(@"Websocket %@ received pong", [webSocket.url absoluteString]);
    dispatch_async(app_websocket_manager_processing_queue(), ^{
        LOWebSocket* socket = [self.QHWebSockets objectForKey:[webSocket.url absoluteString]];
        if (socket) {
            [socket resetPingTime];
            id<LOWebSocketDelegate> delegate = [self.webSocketDelegates objectForKey:[webSocket.url absoluteString]];
            if (delegate && [delegate respondsToSelector:@selector(webSocket:didReceivePong:)]) {
                [delegate webSocket:socket didReceivePong:pongPayload];
            }
        }
    });
}

#pragma mark - setter and getter
- (NSMutableDictionary*)QHWebSockets {
    if (_webSockets == nil) {
        _webSockets = [NSMutableDictionary dictionary];
    }
    return _webSockets;
}

- (NSMutableDictionary*)webSocketDelegates {
    if (_webSocketDelegates == nil) {
        _webSocketDelegates = [NSMutableDictionary dictionary];
    }
    return _webSocketDelegates;
}

@end
