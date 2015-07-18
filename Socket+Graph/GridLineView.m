//
//  IndicatorView.m
//  Socket+Graph
//
//  Created by Admin on 18.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "GridLineView.h"

@implementation GridLineView {
    UIView *_line;
    UILabel *_valueLabel;
    UIView *_labelBg;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _line = [UIView new];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        _line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self addSubview:_line];
        
        _valueLabel = [UILabel new];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        _valueLabel.font = [UIFont boldSystemFontOfSize:8];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_valueLabel];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[line]|" options:0 metrics:nil views:@{ @"line": _line }]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:0.5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:10]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:50]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-1]];
    }
    
    return self;
}


- (void)setValue:(CGFloat)value
{
    _value = value;
    _valueLabel.text = [NSString stringWithFormat:@"%.5f", _value];
}


@end
