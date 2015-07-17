//
//  PlotView.h
//  Socket+Graph
//
//  Created by rovaev on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlotPoint.h"

@interface PlotView : UIView

- (void)drawPlot:(NSArray *)points;
- (void)addPoint:(PlotPoint *)point;

@end
