//
//  SubscriptionsManager.m
//  Socket+Graph
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "SubscriptionsManager.h"
#import "SocketManager.h"
#import "Asset.h"

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsRecieved) name:SMAssetsRecievedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorRecieved) name:SMErrorNotification object:nil];
    }
    
    return self;
}


#pragma mark - Custom methods

- (BOOL)subscribeToAssetWithId:(NSNumber *)assetId
{
    _currentSubscription = assetId;
    
    if ( ![_subscriptions containsObject:assetId] ) {
        [_subscriptions addObject:assetId];
        
        NSDictionary *params = @{ @"assetId": assetId };
        
        [SocketManager sendMessageWithActionType:SMActionTypeSubscribe andMessage:params];
        
        return YES;
    }
    
    return YES;
}


- (void)assetsRecieved
{
    Asset *firstAsset = [Asset allObjects].firstObject;
    
    [SubscriptionsManager subscribeTo:@(firstAsset.assetId)];
}


- (void)errorRecieved
{
    [_subscriptions removeObject:_currentSubscription];
}


@end
