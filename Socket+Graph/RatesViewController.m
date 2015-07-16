//
//  RatesViewController.m
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "RatesViewController.h"

@interface RatesViewController ()
@property (nonatomic) int rate;
@end

@implementation RatesViewController {
    UIButton *_plusButton;
    UIButton *_minusButton;
    UILabel *_valueLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _plusButton = [self stylizeButton:[UIButton new]];
    _plusButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_plusButton setTitle:@"+" forState:UIControlStateNormal];
    [_plusButton addTarget:self action:@selector(incrementValue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_plusButton];
    
    _minusButton = [self stylizeButton:[UIButton new]];
    _minusButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_minusButton setTitle:@"-" forState:UIControlStateNormal];
    [_minusButton addTarget:self action:@selector(decrementValue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_minusButton];
    
    _valueLabel = [UILabel new];
    _valueLabel.textColor = [UIColor grayColor];
    _valueLabel.font = [UIFont boldSystemFontOfSize:15];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _valueLabel.layer.cornerRadius = 5;
    _valueLabel.clipsToBounds = YES;
    _valueLabel.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:_valueLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_plusButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:40]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_minusButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:40]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:40]];
    
    NSDictionary *views = @{
                            @"plus": _plusButton,
                            @"minus": _minusButton,
                            @"label": _valueLabel
                            };
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_valueLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=0)-[minus(40)]-5-[label(60)]-5-[plus(40)]-(>=0)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_plusButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]]; \
    
    self.rate = 0;
}


#pragma mark - Custom methods

- (void)incrementValue
{
    self.rate++;
}


- (void)decrementValue
{
    self.rate--;
}


- (UIButton *)stylizeButton:(UIButton *)button
{
    button.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    return button;
}


#pragma mark - Setters

- (void)setRate:(int)rate
{
    if ( rate >= 0 ) {
        _rate = rate;
        _valueLabel.text = [NSString stringWithFormat:@"%d", _rate];
    }
}


@end
