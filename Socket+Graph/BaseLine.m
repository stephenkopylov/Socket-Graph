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
        _points = [NSArray new];
        
        _strokeLayer = [[CAShapeLayer alloc] init];
        _strokeLayer.bounds = self.layer.bounds;
        _strokeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _strokeLayer.fillColor = [UIColor clearColor].CGColor;
        _strokeLayer.lineWidth = 3;
        _strokeLayer.lineJoin = kCALineJoinBevel;
        [self.layer addSublayer:_strokeLayer];
        
        
        _plotLayer = [PlotLayer new];
        
        _plotLayer.bounds = self.layer.bounds;
        _plotLayer.strokeColor = [UIColor whiteColor].CGColor;
        _plotLayer.fillColor = [UIColor clearColor].CGColor;
        _plotLayer.lineWidth = 3;
        _plotLayer.lineJoin = kCALineJoinBevel;
        
        [self.layer addSublayer:_plotLayer];
    }
    
    return self;
}


- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    _strokeLayer.frame = layer.frame;
    _plotLayer.frame = layer.frame;
}


- (void)addPoints:(NSArray *)points withXOffset:(CGFloat)offset
{
    _points = points;
    
    [self generatePath];
    /*
     if ( _oldStrokePath ) {

     }
     else {
     */
    
    _plotLayer.animatedPath = _strokePath;
    
    /*
    UIBezierPath *transformedPath = _strokePath.copy;
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(offset, 0);
    [transformedPath applyTransform:transform];
    
    //_strokeLayer.path = _strokePath.CGPath;
    
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    strokeAnimation.duration = 0.2;
    strokeAnimation.fromValue = (id)transformedPath.CGPath;
    strokeAnimation.toValue = (id)_strokePath.CGPath;
    strokeAnimation.removedOnCompletion = NO;
    strokeAnimation.fillMode = kCAFillModeBoth;
    [_strokeLayer addAnimation:strokeAnimation forKey:@"path"];
    
    //}
     */
}


- (void)generatePath
{
    _strokePath = [UIBezierPath bezierPath];
    [_points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGPoint newPoint = [obj CGPointValue];
        
        if ( !idx ) {
            [_strokePath moveToPoint:newPoint];
        }
        else {
            [_strokePath addLineToPoint:newPoint];
        }
    }];
}


@end
