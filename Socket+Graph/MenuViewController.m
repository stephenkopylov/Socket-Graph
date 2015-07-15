//
//  MenuViewController.m
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MenuViewController.h"
#import "DropDownMenu.h"
#import "UserManager.h"

@interface MenuViewController ()

@end

@implementation MenuViewController {
    DropDownMenu *_menu;
    UILabel *_nameLabel;
    UILabel *_balanceLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _menu = [DropDownMenu new];
    _menu.items = @[@"item1", @"item2", @"item3", @"item1", @"item2", @"item3", @"item1", @"item2", @"item3", @"item1", @"item2", @"item3"];
    _menu.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_menu];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.text = @"testName";
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_nameLabel];
    
    _balanceLabel = [UILabel new];
    _balanceLabel.textAlignment = NSTextAlignmentRight;
    _balanceLabel.text = @"testBalance";
    _balanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_balanceLabel];
    
    [_menu addConstraint:[NSLayoutConstraint constraintWithItem:_menu attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:30]];
    [_nameLabel addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_balanceLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_nameLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menu attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    NSDictionary *views = @{
                            @"menu": _menu,
                            @"name": _nameLabel,
                            @"balance": _balanceLabel
                            };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[menu(60)][name]-10-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[name][balance]-5-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
}


@end
