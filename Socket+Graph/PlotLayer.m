//
//  PlotLayer.m
//  Socket+Graph
//
//  Created by rovaev on 22.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PlotLayer.h"
#import "FloatAnimator.h"

@interface PlotLayer ()<FloatAnimatorDelegate>

@end

@implementation PlotLayer {
    FloatAnimator *_animator;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _animator = [[FloatAnimator alloc] initWithFps:60];
        _animator.delegate = self;
    }
    
    return self;
}

- (void)setAnimatedPath:(UIBezierPath *)animatedPath
{
    if ( _animatedPath ) {
        _oldAnimatedPath = _animatedPath;
    }
    
    _animatedPath = animatedPath;
    
    [_animator animateFrom:0 andTo:1 withDuration:0.2];
}


- (void)drawPathWithProgress:(float)progress
{
    NSLog(@"draw plot with progress %f", progress);
    UIBezierPath *path = [UIBezierPath new];
}


- (CGPoint)interpolatePointFrom:(CGPoint)from to:(CGPoint)to withProgress:(float)progress
{
    return CGPointMake((to.x - from.x) * progress, (to.y - from.y) * progress);
}


#pragma mark - FloatAnimatorDelegate

- (void)floatAnimator:(FloatAnimator *)animator didChangeValue:(float)value
{
    [self drawPathWithProgress:value];
}


@end
