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
}

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _line = [UIView new];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        _line.backgroundColor = [UIColor redColor];
        
        [self addSubview:_line];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[line]|" options:0 metrics:nil views:@{ @"line": _line }]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:0.5]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.5]];
    }
    
    return self;
}


@end
