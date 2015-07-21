//
//  BaseLine.m
//  Socket+Graph
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "BaseLine.h"

@implementation BaseLine

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _strokeLayer = [[CAShapeLayer alloc] init];
        _strokeLayer.bounds = self.layer.bounds;
        _strokeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _strokeLayer.fillColor = [UIColor clearColor].CGColor;
        _strokeLayer.lineWidth = 3;
        _strokeLayer.lineJoin = @"round";
        [self.layer addSublayer:_strokeLayer];
    }
    
    return self;
}


- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    _strokeLayer.frame = layer.frame;
}


- (void)addPoints:(NSArray *)points withXOffset:(CGFloat *)offset
{
    _points = points;
    
    [self generatePath];
    
    if ( _oldStrokePath ) {
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        strokeAnimation.duration = 0.2;
        strokeAnimation.fromValue = (id)_oldStrokePath.CGPath;
        strokeAnimation.toValue = (id)_strokePath.CGPath;
        strokeAnimation.removedOnCompletion = NO;
        strokeAnimation.fillMode = kCAFillModeBoth;
        [_strokeLayer addAnimation:strokeAnimation forKey:@"path"];
    }
    else {
        _strokeLayer.path = _strokePath.CGPath;
    }
}


- (void)generatePath
{
    if ( _strokePath ) {
        _oldStrokePath = _strokePath;
    }
    
    _strokePath = [UIBezierPath bezierPath];
    [_points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGPoint newPoint = [obj CGPointValue];
        
        if ( CGPointEqualToPoint(_strokePath.currentPoint, CGPointZero)) {
            [_strokePath moveToPoint:newPoint];
        }
        else {
            //[_strokePath addQuadCurveToPoint:newPoint controlPoint:newPoint];
            [_strokePath addLineToPoint:newPoint];
        }
    }];
}


@end
