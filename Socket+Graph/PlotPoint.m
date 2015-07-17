//
//  PlotPoint.m
//  Socket+Graph
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PlotPoint.h"
#import "NotificationsManager.h"
#import "SubscriptionsManager.h"


static NSString *const AssetIdKey = @"assetId";
static NSString *const AssetNameKey = @"assetName";
static NSString *const ValueKey = @"value";


@implementation PlotPoint

+ (void)parsePoint:(NSDictionary *)point
{
    PlotPoint *newPoint = [[PlotPoint alloc] initWithServerDictionary:point];
    
    [NotificationsManager postNotificationWithName:SMPointRecievedNotification andObject:newPoint];
}


+ (NSArray *)parsePoints:(NSArray *)pointsDicts
{
    NSMutableArray *points = [NSMutableArray new];
    
    for ( NSDictionary *pointDict in pointsDicts ) {
        PlotPoint *newPoint = [[PlotPoint alloc] initWithServerDictionary:pointDict];
        [points addObject:newPoint];
    }
    
    return points.copy;
}


- (instancetype)initWithServerDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if ( self ) {
        _assetId = dictionary[AssetIdKey];
        _name = dictionary[AssetNameKey];
        _value = dictionary[ValueKey];
    }
    
    return self;
}


@end
