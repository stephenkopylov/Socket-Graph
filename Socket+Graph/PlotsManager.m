//
//  PlotsManager.m
//  Socket+Graph
//
//  Created by rovaev on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PlotsManager.h"
#import "NotificationsManager.h"
#import "SubscriptionsManager.h"

static PlotsManager *sharedManager;

static NSString *const PointsKey = @"points";

@implementation PlotsManager {
    NSMutableDictionary *_plots;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [PlotsManager new];
    });
    
    return sharedManager;
}


- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _plots = [NSMutableDictionary new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetHistoryRecieved:) name:SMAssetsHistoryRecievedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointRecieved:) name:SMPointRecievedNotification object:nil];
    }
    
    return self;
}


- (void)assetHistoryRecieved:(NSNotification *)notification
{
    NSDictionary *assetHistory  = notification.object;
    NSArray *points = [PlotPoint parsePoints:assetHistory[PointsKey]];
    
    PlotPoint *firstPoint = points.firstObject;
    
    if ( firstPoint ) {
        _plots[firstPoint.assetId] = [self filterPoints:points];
        
        if ( [_delegate respondsToSelector:@selector(plotsManager:didRecievePlot:)] && [firstPoint.assetId isEqualToNumber:[SubscriptionsManager sharedManager].currentSubscription] ) {
            [_delegate plotsManager:self didRecievePlot:_plots[firstPoint.assetId]];
        }
    }
}


- (void)pointRecieved:(NSNotification *)notification
{
    PlotPoint *point  = notification.object;
    NSArray *existedPoints = _plots[point.assetId];
    NSMutableArray *newPoints;
    
    if ( existedPoints ) {
        newPoints = [existedPoints mutableCopy];
        [newPoints addObject:point];
    }
    else {
        newPoints = [NSMutableArray arrayWithObject:point];
    }
    
    _plots[point.assetId] = [self filterPoints:newPoints.copy];
    
    if ( [_delegate respondsToSelector:@selector(plotsManager:didRecievePlot:)] && [point.assetId isEqualToNumber:[SubscriptionsManager sharedManager].currentSubscription] ) {
        [_delegate plotsManager:self didRecievePlot:_plots[point.assetId]];
    }
}


- (NSArray *)filterPoints:(NSArray *)points
{
    PlotPoint *firstPoint = points.firstObject;
    
    //NSArray *filteredArray = [points subarrayWithRange:NSMakeRange(points.count - 30, 30)];
    /*
    if ( firstPoint ) {
        RACSequence *mapped = [[points rac_sequence] filter:^BOOL (id value) {
            return YES;
        }];
        
        filteredArray = mapped.array;
    }
    */
    
    return points;
}


@end
