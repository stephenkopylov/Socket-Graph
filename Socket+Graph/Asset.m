//
//  Asset.m
//  Socket+Graph
//
//  Created by Admin on 16.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "Asset.h"
#import <Realm+JSON/RLMObject+JSON.h>
#import "NotificationsManager.h"

static NSString *const AssetsKey = @"assets";

@implementation Asset

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}


+ (void)parseNewAssets:(NSDictionary *)assets
{
    NSArray *assetsDicts = assets[AssetsKey];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        RLMResults *previous = [Asset allObjects];
        [realm deleteObjects:previous];
        [Asset createOrUpdateInRealm:realm withJSONArray:assetsDicts];
        [realm commitWriteTransaction];
        [NotificationsManager postNotificationWithName:SMAssetsRecievedNotification andObject:nil];
    });
}


+ (NSDictionary *)JSONInboundMappingDictionary
{
    return @{
             @"id": @"assetId",
             @"name": @"name",
             };
}


+ (NSString *)primaryKey
{
    return @"assetId";
}


@end
