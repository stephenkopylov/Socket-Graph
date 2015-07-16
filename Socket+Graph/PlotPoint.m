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
    PlotPoint *newPoint = [PlotPoint new];
    
    newPoint.assetId = point[AssetIdKey];
    newPoint.name = point[AssetNameKey];
    newPoint.value = point[ValueKey];
    
    [NotificationsManager postNotificationWithName:SMPointRecievedNotification andObject:newPoint];
}


@end
