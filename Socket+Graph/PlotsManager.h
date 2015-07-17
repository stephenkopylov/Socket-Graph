//
//  PlotsManager.h
//  Socket+Graph
//
//  Created by rovaev on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlotPoint.h"

@class PlotsManager;

@protocol PlotsManagerDelegate <NSObject>

- (void)plotsManager:(PlotsManager *)manager didRecievePlot:(NSArray *)points;
- (void)plotsManager:(PlotsManager *)manager didRecievePoint:(PlotPoint *)point;

@end

@interface PlotsManager : NSObject

@property (nonatomic, weak) id<PlotsManagerDelegate> delegate;

+ (instancetype)sharedManager;

@end
