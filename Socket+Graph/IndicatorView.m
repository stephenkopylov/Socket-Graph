//
//  IndicatorView.m
//  Socket+Graph
//
//  Created by Admin on 18.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "IndicatorView.h"

@implementation IndicatorView {
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
        _line.backgroundColor = [UIColor orangeColor];
        [self addSubview:_line];
        
        _labelBg = [UIView new];
        _labelBg.translatesAutoresizingMaskIntoConstraints = NO;
        _labelBg.backgroundColor = [UIColor orangeColor];
        [self addSubview:_labelBg];
        
        _valueLabel = [UILabel new];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.font = [UIFont boldSystemFontOfSize:10];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_valueLabel];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[line]|" options:0 metrics:nil views:@{ @"line": _line }]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:0.5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_labelBg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:10]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_labelBg attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:50]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_labelBg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_labelBg attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_labelBg attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_labelBg attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_labelBg attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_labelBg attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    
    return self;
}


- (void)setValue:(CGFloat)value
{
    _value = value;
    _valueLabel.text = [NSString stringWithFormat:@"%.5f", _value];
}


@end
