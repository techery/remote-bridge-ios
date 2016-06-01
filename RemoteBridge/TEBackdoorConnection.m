//
//  TEBackdoorConnection.m
//  RemoteBridge
//
//  Created by Sergey Zenchenko on 6/1/16.
//  Copyright © 2016 Techery. All rights reserved.
//

#import "TEBackdoorConnection.h"
#import <SocketRocket/SRWebSocket.h>


@interface TEBackdoorConnection () <SRWebSocketDelegate>

@property (nonatomic, strong) NSURL *bridgeServerURL;
@property (nonatomic, strong) SRWebSocket *webSocket;

@end

@implementation TEBackdoorConnection

- (instancetype)initWithBridgeServerURL:(NSURL*)bridgeServerURL
{
    self = [super init];
    if (self) {
        self.bridgeServerURL = bridgeServerURL;
        
        [self reconnect];
    }
    return self;
}

- (void)reconnect
{
    NSLog(@"Connecting socket:%@", self.bridgeServerURL);
    
    self.webSocket = [[SRWebSocket alloc] initWithURL:self.bridgeServerURL
                                        protocols:@[@"remote-bridge-protocol"]];
    
    self.webSocket.delegate = self;
    
    [self.webSocket open];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"Websocket Failed With Error %@", error);
    
    [self reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSError *error;
    
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *object = [NSJSONSerialization JSONObjectWithData:messageData options:0 error:&error];
    
    NSString *action = object[@"action"];
    NSDictionary *params = object[@"params"];
    
    NSLog(@"Action:%@", action);
    NSLog(@"Params:%@", params);
    
    TEBackdoorInvocation *invocation = [TEBackdoorInvocation new];
    invocation.name = action;
    invocation.params = params;
    
    [self.delegate handleBackdoorInvocation:invocation];
    
    id response = invocation.response;
    
    if (invocation.response == nil) {
        response = @(false);
    }
    
    id responsePackage = @{@"response":response};
    
    NSData *dataResponse = [NSJSONSerialization dataWithJSONObject:responsePackage
                                                        options:0
                                                          error:&error];
    
    NSString *stringResponse = [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding];
    
    [webSocket send:stringResponse];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    [self reconnect];
    NSLog(@"WebSocket closed");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"Websocket received pong");
}


@end
