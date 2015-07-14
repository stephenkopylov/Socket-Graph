//
//  SocketManager.m
//  Socket+Graph
//
//  Created by Admin on 14.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "SocketManager.h"
#import "SRWebSocket.h"

@interface SocketManager ()<SRWebSocketDelegate>

@end

static SocketManager *sharedManager;

static NSDictionary *actions;

@implementation SocketManager {
    SRWebSocket *_webSocket;
    
    BOOL _connected;
    
    NSMutableArray *_dataQueue;
}

+ (void)load
{
    actions = @{
                @(SMActionTypeToken): @"token"
                };
}


+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [SocketManager new];
    });
    
    return sharedManager;
}


+ (void)sendMessageWithActionType:(SMActionType)actionType andMessage:(NSDictionary *)message
{
    NSString *action = actions[@(actionType)];
    
    NSDictionary *body = @{
                           @"action": action,
                           @"message": message
                           };
    
    
    SocketManager *socketManager = [SocketManager sharedManager];
    
    [socketManager send:body.description];
}


- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SERVER_PATH]]];
        _webSocket.delegate = self;
        
        [_webSocket open];
        
        _dataQueue = [NSMutableArray new];
    }
    
    return self;
}


#pragma mark - Custom methods

- (void)send:(NSString *)data
{
    if ( _connected ) {
        [_webSocket send:data];
    }
    else {
        [_dataQueue addObject:data];
    }
}


- (void)runQueue
{
    if ( _dataQueue.count ) {
        [_dataQueue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *data = (NSString *)obj;
            [_webSocket send:data];
        }];
        
        _dataQueue = [NSMutableArray new];
    }
}


#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    _connected = YES;
    [self runQueue];
}


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
}


@end
