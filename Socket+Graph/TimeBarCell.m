//
//  TimeBarCell.m
//  Socket+Graph
//
//  Created by Admin on 18.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "TimeBarCell.h"

static NSDateFormatter *formatter;

@implementation TimeBarCell {
    UILabel *_valueLabel;
}

+(void)load{
    formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateFormat = @"HH:mm";
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self ) {
        _valueLabel = [UILabel new];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        _valueLabel.font = [UIFont boldSystemFontOfSize:8];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_valueLabel];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[valueLabel]|" options:0 metrics:nil views:@{ @"valueLabel": _valueLabel }]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:10]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-2]];
    }
    
    return self;
}

- (void)setValue:(NSInteger)value
{
    _value = value;
    _valueLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:value]];
}

@end
