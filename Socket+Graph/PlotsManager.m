//
//  PlotsManager.m
//  Socket+Graph
//
//  Created by rovaev on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PlotsManager.h"
#import "NotificationsManager.h"

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
        _plots[firstPoint.assetId] = points;
        
        if ( [_delegate respondsToSelector:@selector(plotsManager:didRecievePlot:)] ) {
            [_delegate plotsManager:self didRecievePlot:points];
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
    
    _plots[point.assetId] = newPoints.copy;
    
    if ( [_delegate respondsToSelector:@selector(plotsManager:didRecievePoint:)] ) {
        [_delegate plotsManager:self didRecievePoint:point];
    }
}


@end
