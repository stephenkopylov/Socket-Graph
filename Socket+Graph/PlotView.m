//
//  PlotView.m
//  Socket+Graph
//
//  Created by rovaev on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "PlotView.h"
#import "GridView.h"
#import "IndicatorView.h"
#import "TimeBarCell.h"
#import "PlotLine.h"

#define TIME_OFFSET_X   0.6
#define VERTICAL_MARGIN 40
#define POINT_SIZE      6

NSString *const TimeCollectionViewCellIdentifier = @"TimeCollectionViewCellIdentifier";

@implementation PlotView {
    NSMutableArray *_points;
    
    NSNumber *_minVal;
    NSNumber *_maxVal;
    
    NSInteger _startTime;
    CGFloat _diff;
    CGFloat _yStep;
    CGFloat _timeBarOffset;
    
    CAShapeLayer *_strokeLayer;
    CAShapeLayer *_fillLayer;
    CAGradientLayer *_gradientLayer;
    
    UIBezierPath *_strokePath;
    UIBezierPath *_oldStrokePath;
    
    UIBezierPath *_fillPath;
    UIBezierPath *_oldFillPath;
    
    
    UIScrollView *_scrollView;
    UIView *_containerView;
    GridView *_gridView;
    UIView *_pointView;
    IndicatorView *_indicatorView;
    UICollectionView *_timeCollectionView;
    UIActivityIndicatorView *_activity;
    PlotLine *_plotLine;
    
    NSLayoutConstraint *_indicatorCenterYConstraint;
    
    BOOL _readyToAnimate;
    
    dispatch_source_t _timer;
    UIButton *_test;
    
    CGFloat _timeOffsetX;
    
    NSInteger _pointsShift;
    
    NSMutableArray *_pointz;
}

- (void)dealloc
{
    if ( _timer ) {
        dispatch_source_cancel(_timer);
    }
    
    _scrollView.delegate = nil;
}


- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _pointsShift = 0;
        
        _timeOffsetX = TIME_OFFSET_X;
        
        _timeBarOffset = 0;
        
        _readyToAnimate = YES;
        
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
        _pointView.alpha = 0;
        _pointView.frame = CGRectMake(0, 0, POINT_SIZE, POINT_SIZE);
        _pointView.layer.cornerRadius = POINT_SIZE / 2;
        _pointView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_pointView];
        
        _indicatorView = [IndicatorView new];
        _indicatorView.alpha = 0;
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_indicatorView];
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x3BFFFC).CGColor, (id)UIColorFromRGB(0x48A1FF).CGColor, nil];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        
        
        _plotLine = [PlotLine new];
        _plotLine.translatesAutoresizingMaskIntoConstraints = NO;
        [_containerView addSubview:_plotLine];
        
        
        _test = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_test setTitle:@"test" forState:UIControlStateNormal];
        [_test addTarget:self action:@selector(changeXOffset) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_test];
        
        
        UIButton *_test1 = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 100, 40)];
        [_test1 setTitle:@"AddPoint" forState:UIControlStateNormal];
        [_test1 addTarget:self action:@selector(addPoint) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_test1];
        
        
        UIButton *_test2 = [[UIButton alloc] initWithFrame:CGRectMake(140, 0, 100, 40)];
        [_test2 setTitle:@"AddPoints" forState:UIControlStateNormal];
        [_test2 addTarget:self action:@selector(addPoints) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_test2];
        
        
        
        
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _timeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _timeCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _timeCollectionView.backgroundColor = [UIColor clearColor];
        _timeCollectionView.delegate = self;
        _timeCollectionView.dataSource = self;
        [_timeCollectionView registerClass:[TimeBarCell class] forCellWithReuseIdentifier:TimeCollectionViewCellIdentifier];
        [self addSubview:_timeCollectionView];
        
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activity.translatesAutoresizingMaskIntoConstraints = NO;
        [_activity startAnimating];
        [self addSubview:_activity];
        
        NSDictionary *views = @{
                                @"scrollView": _scrollView,
                                @"gridView": _gridView,
                                @"indicator": _indicatorView,
                                @"time": _timeCollectionView,
                                @"plotLine": _plotLine,
                                };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[gridView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(verticalMargin)-[gridView]-verticalMargin-|" options:0 metrics:@{ @"verticalMargin": @(VERTICAL_MARGIN) } views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[indicator]|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:20]];
        _indicatorCenterYConstraint = [NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraint:_indicatorCenterYConstraint];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[time]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[time]|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:10]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_activity attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_activity attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        
        
        
        [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[plotLine]|" options:0 metrics:nil views:views]];
        [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[plotLine]|" options:0 metrics:nil views:views]];
    }
    
    return self;
}


- (void)layoutSubviews
{
    if ( !_strokeLayer ) {
        _strokeLayer = [[CAShapeLayer alloc] init];
        _strokeLayer.bounds = _containerView.bounds;
        _strokeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _strokeLayer.fillColor = [UIColor clearColor].CGColor;
        _strokeLayer.lineWidth = 1.5;
        [_containerView.layer addSublayer:_strokeLayer];
    }
    
    if ( !_fillLayer ) {
        _fillLayer = [[CAShapeLayer alloc] init];
        _fillLayer.bounds = _containerView.bounds;
        _fillLayer.strokeColor = [UIColor clearColor].CGColor;
        _fillLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        _fillLayer.lineWidth = 1.f;
        [_containerView.layer addSublayer:_fillLayer];
    }
    
    CGRect rect = CGRectMake(0, 0, _containerView.bounds.size.width, self.bounds.size.height);
    _containerView.frame = rect;
    
    if ( !CGRectEqualToRect(self.bounds, _gradientLayer.frame)) {
        _gradientLayer.frame = self.bounds;
    }
}


#pragma mark - Public methods

- (void)drawPlot:(NSArray *)points
{
    BOOL redraw = NO;
    
    CGFloat xShift = 0;
    
    if ( points.count == _points.count ) {
        PlotPoint *lastPoint = _points.lastObject;
        
        NSArray *newPoints = [[points rac_sequence] filter:^BOOL (id value) {
            PlotPoint *currentPoint = (PlotPoint *)value;
            return currentPoint.time.integerValue > lastPoint.time.integerValue;
        }].array;
        
        if ( newPoints.count ) {
            CGPoint lastP = [self convertPoint:lastPoint];
            CGPoint newP = [self convertPoint:(PlotPoint *)newPoints.lastObject];
            xShift = newP.x - lastP.x;
        }
        
        redraw = YES;
        
        [_points addObjectsFromArray:newPoints];
    }
    else {
        _points = points.mutableCopy;
    }
    
    _startTime =  ((PlotPoint *)_points.firstObject).time.integerValue;
    
    [self calculateMinMax];
    [self generatePath:_points];
    
    
    /*
     [_plotLine addPoints:[[_points rac_sequence] map:^id (id value) {
     return [NSValue valueWithCGPoint:[self convertPoint:value]];
     }].array withXOffset:xShift];
     
     
     if ( _strokeLayer.path ) {
     _points = points.mutableCopy;
     
     if ( redraw ) {
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     CGAffineTransform transform = CGAffineTransformMakeTranslation(xShift, 0);
     [_strokePath applyTransform:transform];
     [self generatePath:_points];
     _strokeLayer.path = _strokePath.CGPath;
     _fillLayer.path = _fillPath.CGPath;
     });
     
     [UIView animateWithDuration:0.2 animations:^{
     _timeBarOffset += xShift;
     [self refreshCollectionView];
     }];
     }
     
     CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
     strokeAnimation.duration = 0.2;
     strokeAnimation.fromValue = (id)_oldStrokePath.CGPath;
     strokeAnimation.toValue = (id)_strokePath.CGPath;
     strokeAnimation.removedOnCompletion = NO;
     strokeAnimation.fillMode = kCAFillModeBoth;
     [_strokeLayer addAnimation:strokeAnimation forKey:@"path"];
     
     CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
     fillAnimation.duration = 0.2;
     fillAnimation.fromValue = (id)_oldFillPath.CGPath;
     fillAnimation.toValue = (id)_fillPath.CGPath;
     fillAnimation.removedOnCompletion = NO;
     fillAnimation.fillMode = kCAFillModeBoth;
     [_fillLayer addAnimation:fillAnimation forKey:@"path"];
     
     _indicatorCenterYConstraint.constant = _strokePath.currentPoint.y;
     
     [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
     [self layoutIfNeeded];
     [self refreshPoint];
     } completion:nil];
     }
     else {
     [_timeCollectionView reloadData];
     [_activity stopAnimating];
     
     _indicatorView.alpha = 1;
     _pointView.alpha = 1;
     
     _strokeLayer.path = _strokePath.CGPath;
     _fillLayer.path = _fillPath.CGPath;
     
     _pointView.center = _strokePath.currentPoint;
     
     _indicatorCenterYConstraint.constant = _strokePath.currentPoint.y;
     
     [self layoutIfNeeded];
     
     [self refreshScrollView];
     
     if ( _strokePath.currentPoint.x > _scrollView.frame.size.width ) {
     [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width, 0) animated:NO];
     }
     }
     
     PlotPoint *_lastPoint = _points.lastObject;
     
     _indicatorView.value = _lastPoint.value.floatValue;
     
     [self refreshScrollView];
     
     if ( _strokePath.currentPoint.x > _scrollView.frame.size.width && _readyToAnimate ) {
     [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width, 0) animated:YES];
     }
     */
    
    [_activity stopAnimating];
}


#pragma mark - Private methods

- (void)refresh
{
    if ( _points.count ) {
        [self calculateMinMax];
        [self drawPlot:_points];
    }
}


- (void)refreshScrollView
{
    CGRect rect = CGRectMake(0, 0, _strokePath.bounds.size.width + 100, self.bounds.size.height);
    
    _scrollView.contentSize = rect.size;
    
    CGRect rect2 = CGRectMake(0, 0, _strokePath.bounds.size.width + 100, self.bounds.size.height);
    _containerView.frame = rect2;
}


- (void)refreshPoint
{
    CGPoint point = _strokePath.currentPoint;
    
    point.x -= _scrollView.contentOffset.x;
    _pointView.center = point;
}


- (void)refreshCollectionView
{
    CGPoint point = _scrollView.contentOffset;
    
    point.x += _timeBarOffset;
    
    _timeCollectionView.contentOffset = point;
}


- (void)generatePath:(NSArray *)points
{
    if ( _strokePath ) {
        _oldStrokePath = _strokePath;
    }
    
    if ( _fillPath ) {
        _oldFillPath = _fillPath;
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
    
    _strokePath = path.copy;
    
    
    [path addLineToPoint:CGPointMake(path.currentPoint.x + 0.5, path.currentPoint.y + 0.5)];
    [path addLineToPoint:CGPointMake(path.currentPoint.x, 10000)];
    [path addLineToPoint:CGPointMake(path.currentPoint.x + 0.5, 10000 + 0.5)];
    [path addLineToPoint:CGPointMake(0, 10000)];
    
    _fillPath = path.copy;
}


- (CGPoint)convertPoint:(PlotPoint *)point
{
    NSInteger seconds =  (point.time.integerValue - _startTime) / 100000;
    
    CGFloat x = _timeOffsetX * seconds;
    CGFloat y;
    
    if ( _yStep != 0 ) {
        CGFloat yPercents = (point.value.floatValue - _minVal.floatValue)  / _yStep;
        
        y = self.bounds.size.height - VERTICAL_MARGIN - (self.bounds.size.height - VERTICAL_MARGIN * 2) / 100 * yPercents;
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
    
    _minVal = @(MAXFLOAT);
    _maxVal = @0;
    
    for ( PlotPoint *point in currentPoints ) {
        if ( point.value.floatValue > _maxVal.floatValue ) {
            _maxVal = point.value;
        }
        
        if ( point.value.floatValue < _minVal.floatValue ) {
            _minVal = point.value;
        }
    }
    
    _diff = _maxVal.floatValue - _minVal.floatValue;
    
    _yStep = _diff / 100;
    
    [_gridView setMin:_minVal.floatValue andMax:_maxVal.floatValue];
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( scrollView == _scrollView ) {
        [self refreshPoint];
        [self refreshCollectionView];
        
        if ( scrollView.dragging ) {
            _readyToAnimate = NO;
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _readyToAnimate = NO;
    
    if ( _timer ) {
        dispatch_source_cancel(_timer);
    }
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_walltime(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2), 0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        _readyToAnimate = YES;
        dispatch_source_cancel(_timer);
    });
    dispatch_resume(_timer);
}


#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TimeBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TimeCollectionViewCellIdentifier forIndexPath:indexPath];
    
    CGFloat centerOfCell = cell.frame.origin.x + cell.frame.size.width / 2;
    
    NSInteger time = _startTime + centerOfCell / TIME_OFFSET_X * 100;
    
    cell.value = time;
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 10);
}


//-------------

- (void)changeXOffset
{
    if ( _timeOffsetX == TIME_OFFSET_X ) {
        _timeOffsetX = 0.1;
    }
    else {
        _timeOffsetX = TIME_OFFSET_X;
    }
    
    [self calculateMinMax];
    
    [_plotLine addPoints:[[_points rac_sequence] map:^id (id value) {
        return [NSValue valueWithCGPoint:[self convertPoint:value]];
    }].array withXOffset:0];
}


- (void)addPoint
{
    if ( !_pointz ) {
        _pointz = [NSMutableArray new];
    }
    
    int lowerBound = 0;
    int upperBound = self.bounds.size.height;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    CGPoint test = CGPointMake(_pointsShift * 5, rndValue);
    
    [_pointz addObject:[NSValue valueWithCGPoint:test]];
    
    [_plotLine addPoints:_pointz.copy withXOffset:0];
    
    _pointsShift++;
}


- (void)addPoints
{
    if ( !_pointz ) {
        _pointz = [NSMutableArray new];
    }
    
    NSMutableArray *points = [NSMutableArray new];
    
    for ( int i = 0; i < 5; i++ ) {
        int lowerBound = 0;
        int upperBound = self.bounds.size.height;
        int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
        CGPoint test = CGPointMake(_pointsShift * 5, rndValue);
        [points addObject:[NSValue valueWithCGPoint:test]];
        _pointsShift++;
    }
    
    [_pointz addObjectsFromArray:points];
    
    [_plotLine addPoints:_pointz.copy withXOffset:0];
    
}


@end
