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
        _animator = [[FloatAnimator alloc] initWithFps:30];
        _animator.delegate = self;
        self.drawsAsynchronously = YES;
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIBezierPath *path = [UIBezierPath new];
        
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(50, 50)];
        [path addLineToPoint:CGPointMake(70, 20)];
        [path addLineToPoint:CGPointMake(90, 100)];
        [path addLineToPoint:[self interpolatePointFrom:CGPointMake(90, 100) to:CGPointMake(94, 105) withProgress:progress]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.path = path.CGPath;
        });
    });
}


- (CGPoint)interpolatePointFrom:(CGPoint)from to:(CGPoint)to withProgress:(float)progress
{
    return CGPointMake(from.x + (to.x - from.x) * progress, from.y + (to.y - from.y) * progress);
}


#pragma mark - FloatAnimatorDelegate

- (void)floatAnimator:(FloatAnimator *)animator didChangeValue:(float)value
{
    [self drawPathWithProgress:value];
}


@end
