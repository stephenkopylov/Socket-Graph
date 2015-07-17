//
//  PlotView.m
//  Socket+Graph
//
//  Created by rovaev on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PlotView.h"

@implementation PlotView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}


- (void)drawPlot:(NSArray *)points
{
}


- (void)addPoint:(PlotPoint *)point
{
}


@end
