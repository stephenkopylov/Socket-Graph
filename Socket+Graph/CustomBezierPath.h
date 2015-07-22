//
//  CustomBezierPath.h
//  Socket+Graph
//
//  Created by rovaev on 22.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlotPoint.h"

@interface CustomBezierPath : UIBezierPath

@property (nonatomic) NSArray *points;

- (void)addKeyPlotPoint:(PlotPoint *)point;
- (void)addPlotPoint:(PlotPoint *)point;

@end
