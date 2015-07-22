//
//  PlotLayer.h
//  Socket+Graph
//
//  Created by rovaev on 22.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PlotLayer : CAShapeLayer

@property (nonatomic) UIBezierPath *animatedPath;
@property (nonatomic) UIBezierPath *oldAnimatedPath;

@property (nonatomic) CGFloat animProgress;

@end
