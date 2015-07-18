//
//  PlotView.m
//  Socket+Graph
//
//  Created by rovaev on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PlotView.h"
#import "LineContainer.h"
#import "GridView.h"
#import "IndicatorView.h"

#define timeOffsetX      0.4
#define horizontalMargin 0
#define verticalMargin   40
#define POINT_SIZE       6

@implementation PlotView {
    NSNumber *_minVal;
    
    NSNumber *_maxVal;
    
    CGFloat _diff;
    
    CGFloat _yStep;
    
    CAShapeLayer *_lineLayer;
    CAShapeLayer *_fillLayer;
    
    UIBezierPath *_strokePath;
    UIBezierPath *_oldStrokePath;
    
    
    NSInteger _startTime;
    
    NSMutableArray *_points;
    NSMutableArray *_prevPoints;
    
    UIScrollView *_scrollView;
    
    UIView *_containerView;
    
    GridView *_gridView;
    
    UIView *_pointView;
    
    IndicatorView *_indicatorView;
    
    NSLayoutConstraint *_indicatorCenterYConstraint;
    
    CAGradientLayer *_gradientLayer;
}


- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _points = [NSMutableArray new];
        
        _gridView = [GridView new];
        _gridView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_gridView];
        
        _scrollView = [UIScrollView new];
        _scrollView.bounces = NO;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        
        [_scrollView addSubview:_containerView];
        
        _pointView = [UIView new];
        _pointView.frame = CGRectMake(0, 0, POINT_SIZE, POINT_SIZE);
        _pointView.layer.cornerRadius = POINT_SIZE / 2;
        _pointView.backgroundColor = [UIColor orangeColor];
        
        [self addSubview:_pointView];
        
        _indicatorView = [IndicatorView new];
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_indicatorView];
        
        NSDictionary *views = @{
                                @"scrollView": _scrollView,
                                @"gridView": _gridView,
                                @"indicator": _indicatorView
                                };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[gridView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(verticalMargin)-[gridView]-verticalMargin-|" options:0 metrics:@{ @"verticalMargin": @(verticalMargin) } views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[indicator]|" options:0 metrics:nil views:views]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:20]];
        
        _indicatorCenterYConstraint = [NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraint:_indicatorCenterYConstraint];
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x3BFFFC).CGColor, (id)UIColorFromRGB(0x48A1FF).CGColor, nil];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
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
        _lineLayer.strokeColor = [UIColor whiteColor].CGColor;
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        _lineLayer.lineWidth = 1.5;
        
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
    
    if ( !CGRectEqualToRect(self.bounds, _gradientLayer.frame)) {
        _gradientLayer.frame = self.bounds;
    }
    
    //[self refresh];
}


#pragma mark - Public methods

- (void)drawPlot:(NSArray *)points
{
    BOOL redraw = NO;
    
    if ( points.count == _points.count ) {
        PlotPoint *lastPoint = _points.lastObject;
        
        NSArray *newPoints = [[points rac_sequence] filter:^BOOL (id value) {
            PlotPoint *currentPoint = (PlotPoint *)value;
            return currentPoint.time.integerValue > lastPoint.time.integerValue;
        }].array;
        
        redraw = YES;
        
        [_points addObjectsFromArray:newPoints];
    }
    else {
        _points = points.mutableCopy;
    }
    
    PlotPoint *firstPoint = _points.firstObject;
    
    _startTime = firstPoint.time.integerValue;
    
    [self calculateMinMax];
    
    if ( _strokePath ) {
        [self generatePath:_points];
        _points = points.mutableCopy;
        
        if ( redraw ) {
            CGFloat xShift = _strokePath.currentPoint.x - _oldStrokePath.currentPoint.x;
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-xShift, 0);
            [_strokePath applyTransform:transform];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CGAffineTransform transform = CGAffineTransformMakeTranslation(xShift, 0);
                [_strokePath applyTransform:transform];
                [self generatePath:_points];
                _lineLayer.path = _strokePath.CGPath;
            });
        }
        
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        strokeAnimation.duration = 0.2;
        strokeAnimation.fromValue = (id)_oldStrokePath.CGPath;
        strokeAnimation.toValue = (id)_strokePath.CGPath;
        strokeAnimation.removedOnCompletion = NO;
        strokeAnimation.fillMode = kCAFillModeBoth;
        [_lineLayer addAnimation:strokeAnimation forKey:@"path"];
        
        _indicatorCenterYConstraint.constant = _strokePath.currentPoint.y;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
            [self refreshPoint];
        }];
    }
    else {
        [self generatePath:_points];
        _lineLayer.path = _strokePath.CGPath;
        _pointView.center = _strokePath.currentPoint;
        _indicatorCenterYConstraint.constant = _strokePath.currentPoint.y;
    }
    
    PlotPoint *_lastPoint = _points.lastObject;
    
    _indicatorView.value = _lastPoint.value.floatValue;
    
    [self refreshScrollView];
}


#pragma mark - Private methods

- (void)refreshScrollView
{
    CGRect rect = CGRectMake(0, 0, _strokePath.bounds.size.width + 100, self.bounds.size.height);
    
    _scrollView.contentSize = rect.size;
}


- (void)refreshPoint
{
    CGPoint point = _strokePath.currentPoint;
    
    point.x -= _scrollView.contentOffset.x;
    _pointView.center = point;
}


- (void)refresh
{
    if ( _points.count ) {
        [self calculateMinMax];
        [self drawPlot:_points];
    }
}


- (void)generatePath:(NSArray *)points
{
    if ( _strokePath ) {
        _oldStrokePath = _strokePath;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGPoint newPoint = [self convertPoint:(PlotPoint *)obj];
        
        if ( idx == 0 ) {
            [path moveToPoint:newPoint];
        }
        else {
            [path addLineToPoint:newPoint];
        }
    }];
    
    _strokePath = path;
}


- (CGPoint)convertPoint:(PlotPoint *)point
{
    NSInteger seconds =  (point.time.integerValue - _startTime) / 100;
    
    CGFloat x =  horizontalMargin + timeOffsetX * seconds;
    CGFloat y;
    
    if ( _yStep != 0 ) {
        CGFloat yPercents = (point.value.floatValue - _minVal.floatValue)  / _yStep;
        
        y = self.bounds.size.height - verticalMargin - (self.bounds.size.height - verticalMargin * 2) / 100 * yPercents;
    }
    else {
        y = self.bounds.size.height - self.bounds.size.height / 2;
    }
    
    return CGPointMake(x, y);
}


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
    
    [_gridView setMin:_minVal.floatValue andMax:_maxVal.floatValue];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self refreshPoint];
}


@end
