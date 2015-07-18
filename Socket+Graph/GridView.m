//
//  GridView.m
//  Socket+Graph
//
//  Created by Admin on 18.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "GridView.h"
#import "GridLineView.h"

#define HORIZONTAL_LINES_COUNT 7

@implementation GridView {
    NSMutableArray *_lines;
    CGFloat _minValue;
    CGFloat _maxValue;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _lines = [NSMutableArray new];
        
        for ( int i = 0; i < HORIZONTAL_LINES_COUNT; i++ ) {
            GridLineView *line = [GridLineView new];
            line.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:line];
            [_lines addObject:line];
        }
        
        [_lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GridLineView *line = (GridLineView *)obj;
            
            [line addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:0.5]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[line]|" options:0 metrics:nil views:@{ @"line": line }]];
            
            if ( idx == 0 ) {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[line]" options:0 metrics:nil views:@{ @"line": line }]];
            }
            else if ( idx == _lines.count - 1 ) {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line]|" options:0 metrics:nil views:@{ @"line": line }]];
            }
            else {
                CGFloat multiplier = (2 * (idx - 1) + 2) / (CGFloat)((HORIZONTAL_LINES_COUNT - 2) + 1);
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:multiplier constant:0];
                [self  addConstraint:constraint];
            }
        }];
    }
    
    return self;
}


- (void)setMin:(CGFloat)min andMax:(CGFloat)max
{
    _minValue = min;
    _maxValue = max;
    
    CGFloat diff = _maxValue - _minValue;
    
    [_lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GridLineView *line = (GridLineView *)obj;
        line.value =  _maxValue - diff / HORIZONTAL_LINES_COUNT * idx;
    }];
}


@end
