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

NSString *const SMConnectedNotification = @"SMConnectedNotification";
NSString *const SMProfileRecievedNotification = @"SMProfileRecievedNotification";


static SocketManager *sharedManager;
static NSDictionary *actions;
static NSDictionary *serverActions;


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
    
    serverActions = @{
                      @"profile": @(SMServerActionTypeProfile)
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

- (void)getUserInfo
{
    NSDictionary *message = @{
                              @"token": @"fredclark201590@gmail.com/fredclark201590@gmail.com"
                              };
    
    [SocketManager sendMessageWithActionType:SMActionTypeToken andMessage:message];
}


- (void)send:(NSString *)data
{
    if ( _connected ) {
        [_webSocket send:data];
    }
    else {
        [_dataQueue addObject:data];
    }
}


- (void)recieved:(NSDictionary *)data
{
    NSString *action = data[@"action"];
    
    NSDictionary *message = data[@"message"];
    
    SMServerActionType serverAction = ((NSNumber *)serverActions[action]).integerValue;
    
    NSString *notificationName;
    
    switch ( serverAction ) {
        case SMServerActionTypeProfile: {
            notificationName = SMProfileRecievedNotification;
            break;
        }
            
        default: {
            break;
        }
    }
    
    if ( notificationName ) {
        [self postNotificationWithName:notificationName andObject:message];
    }
}


- (void)postNotificationWithName:(NSString *)name andObject:(id)object
{
    if ( [NSThread isMainThread] ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
        });
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
    [self postNotificationWithName:SMConnectedNotification andObject:nil];
    [self runQueue];
}


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    [self recieved:data];
}


@end
