//
//  SubscriptionsManager.h
//  Socket+Graph
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionsManager : NSObject

@property (nonatomic) NSNumber *currentSubscription;

+ (instancetype)sharedManager;

+ (BOOL)subscribeTo:(NSNumber *)assetId;

- (BOOL)subscribeToAssetWithId:(NSNumber *)assetId;

@end
