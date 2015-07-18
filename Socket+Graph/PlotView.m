//
//  PlotView.m
//  Socket+Graph
//
//  Created by rovaev on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PlotView.h"

#define timeOffsetX 0.4
#define verticalMargin 60

@implementation PlotView {
    NSNumber *_minVal;
    
    NSNumber *_maxVal;
    
    CGFloat _diff;
    
    CGFloat _yStep;
    
    CAShapeLayer *_lineLayer;
    CAShapeLayer *_fillLayer;
    
    UIBezierPath *_openPath;
    UIBezierPath *_closedPath;
    
    
    NSInteger _startTime;
    
    NSMutableArray *_points;
    
    UIScrollView *_scrollView;
    
    UIView *_containerView;
}


- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _points = [NSMutableArray new];
        
        _scrollView = [UIScrollView new];
        _scrollView.bounces = NO;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_scrollView];
        
        NSDictionary *views = @{ @"scrollView": _scrollView };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
        
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        
        [_scrollView addSubview:_containerView];
    }
    
    return self;
}


- (void)didMoveToSuperview
{
}


- (void)layoutSubviews
{
    if ( !_lineLayer ) {
        _lineLayer = [[CAShapeLayer alloc] init];
        _lineLayer.bounds = _containerView.bounds;
        _lineLayer.strokeColor = [UIColor blueColor].CGColor;
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        _lineLayer.lineWidth = 1.f;
        
        [_containerView.layer addSublayer:_lineLayer];
    }
    
    if ( !_fillLayer ) {
        _fillLayer = [[CAShapeLayer alloc] init];
        
        _fillLayer.bounds = _containerView.bounds;
        _fillLayer.strokeColor = [UIColor clearColor].CGColor;
        _fillLayer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2].CGColor;
        _fillLayer.lineWidth = 1.f;
        
        [_containerView.layer addSublayer:_fillLayer];
    }
}


#pragma mark - Public methods

- (void)drawPlot:(NSArray *)points
{
    _points = points.mutableCopy;
    
    PlotPoint *firstPoint = _points.firstObject;
    
    _startTime = firstPoint.time.integerValue;
    
    [self calculateMinMax];
    
    [self generatePath:points];
    
    _lineLayer.path = _openPath.CGPath;
    _fillLayer.path = _closedPath.CGPath;
    
    [self refreshScrollView];
}


- (void)addPoint:(PlotPoint *)point
{
    [_points addObject:point];
    
    [self calculateMinMax];
    
    UIBezierPath *oldStrokePath = _openPath.copy;
    UIBezierPath *oldFillPath = _openPath.copy;
    //graphical glitches avoiding
    [oldFillPath addLineToPoint:CGPointMake(oldFillPath.currentPoint.x + 1, oldFillPath.currentPoint.y)];
    [oldFillPath addLineToPoint:CGPointMake(oldFillPath.currentPoint.x, self.bounds.size.height)];
    [oldFillPath addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    _lineLayer.path = oldFillPath.CGPath;
    
    [self generatePath:_points];
    
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    strokeAnimation.duration = 1;
    strokeAnimation.fromValue = (id)oldStrokePath.CGPath;
    strokeAnimation.toValue = (id)_openPath.CGPath;
    strokeAnimation.removedOnCompletion = NO;
    strokeAnimation.fillMode = kCAFillModeForwards;
    [_lineLayer addAnimation:strokeAnimation forKey:@"path"];
    
    
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = 1;
    fillAnimation.fromValue = (id)oldFillPath.CGPath;
    fillAnimation.toValue = (id)_closedPath.CGPath;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fillMode = kCAFillModeRemoved;
    [_fillLayer addAnimation:fillAnimation forKey:@"path"];
    _fillLayer.path = _closedPath.CGPath;
    
    [self refreshScrollView];
}


- (void)refreshScrollView
{
    CGRect rect = CGRectMake(0, 0, _openPath.bounds.size.width+100, self.bounds.size.height);
    
    _scrollView.contentSize = rect.size;
}


- (void)generatePath:(NSArray *)points
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, self.bounds.size.height)];
    
    [points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGPoint newPoint = [self convertPoint:(PlotPoint *)obj];
        
        if ( idx == 0 ) {
            [path moveToPoint:newPoint];
        }
        else {
            [path addLineToPoint:newPoint];
        }
    }];
    
    _openPath = path;
    
    _closedPath = _openPath.copy;
    [_closedPath addLineToPoint:CGPointMake([self convertPoint:(PlotPoint *)points.lastObject].x, self.bounds.size.height + 1)];
    [_closedPath addLineToPoint:CGPointMake(0, self.bounds.size.height + 1)];
    //[_closedPath closePath];
}


- (CGPoint)convertPoint:(PlotPoint *)point
{
    NSInteger seconds =  (point.time.integerValue - _startTime) / 100;
    
    CGFloat x =  timeOffsetX * seconds;
    
    CGFloat yPercents = (point.value.floatValue - _minVal.floatValue)  / _yStep;
    
    CGFloat y = self.bounds.size.height - verticalMargin - (self.bounds.size.height - verticalMargin*2) / 100 * yPercents;
    
    return CGPointMake(x, y);
}


#pragma mark - Private methods

- (void)calculateMinMax
{
    NSMutableArray *currentPoints = [NSMutableArray new];
    
    for ( PlotPoint *pPoint in _points ) {
        CGPoint point = [self convertPoint:pPoint];
        
        if ( point.x - _scrollView.contentOffset.x > 0 && point.x - _scrollView.contentOffset.x + self.bounds.size.width ) {
            [currentPoints addObject:pPoint];
        }
    }
    
    NSArray *sortedArray = [currentPoints.copy sortedArrayUsingComparator:^NSComparisonResult (id a, id b) {
        NSNumber *first = [(PlotPoint *)a value];
        NSNumber *second = [(PlotPoint *)b value];
        return [first compare:second];
    }];
    
    _minVal = ((PlotPoint *)sortedArray.firstObject).value;
    
    _maxVal = ((PlotPoint *)sortedArray.lastObject).value;
    
    _diff = _maxVal.floatValue - _minVal.floatValue;
    
    _yStep = _diff / 100;
}


@end
