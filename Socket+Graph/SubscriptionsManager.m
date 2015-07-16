//
//  SubscriptionsManager.m
//  Socket+Graph
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "SubscriptionsManager.h"
#import "SocketManager.h"

static SubscriptionsManager *sharedManager;

@implementation SubscriptionsManager {
    NSMutableArray *_subscriptions;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [SubscriptionsManager new];
    });
    
    return sharedManager;
}


+ (BOOL)subscribeTo:(NSNumber *)assetId
{
    return [[SubscriptionsManager sharedManager] subscribeToAssetWithId:assetId];
}


- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _subscriptions = [NSMutableArray new];
    }
    
    return self;
}


- (BOOL)subscribeToAssetWithId:(NSNumber *)assetId
{
    if ( ![_subscriptions containsObject:assetId] ) {
        _currentSubscription = assetId;
        
        [_subscriptions addObject:assetId];
        
        NSDictionary *params = @{ @"assetId": assetId };
        
        [SocketManager sendMessageWithActionType:SMActionTypeSubscribe andMessage:params];
        
        return YES;
    }
    
    return NO;
}


@end
