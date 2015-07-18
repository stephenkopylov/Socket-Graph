//
//  PlotView.h
//  Socket+Graph
//
//  Created by rovaev on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlotPoint.h"

@interface PlotView : UIView <UIScrollViewDelegate>

- (void)drawPlot:(NSArray *)points;

- (void)clear;

@end
