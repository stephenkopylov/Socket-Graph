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
#import "SocketManager.h"
#import "Asset.h"
#import "PlotPoint.h"
#import "SubscriptionsManager.h"

@interface MenuViewController ()<DropDownMenuDelegate>

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
    _menu.translatesAutoresizingMaskIntoConstraints = NO;
    _menu.delegate = self;
    _menu.layer.cornerRadius = 5;
    _menu.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:_menu];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.text = [UserManager currentUser].name;
    _nameLabel.textColor = [UIColor grayColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:12];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_nameLabel];
    
    _balanceLabel = [UILabel new];
    _balanceLabel.textAlignment = NSTextAlignmentRight;
    _balanceLabel.text = @"100";
    _balanceLabel.textColor = [UIColor grayColor];
    _balanceLabel.font = [UIFont boldSystemFontOfSize:15];
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
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[menu(100)][name]-10-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[name][balance]-8-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [self reloadData];
}


- (void)reloadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMResults *result = [Asset allObjects];
        NSMutableArray *items = [NSMutableArray new];
        
        for ( int i = 0; i < result.count; i++ ) {
            Asset *asset = result[i];
            
            DropDownMenuItem *item = [[DropDownMenuItem alloc] initWithId:@(asset.assetId) andName:asset.name];
            [items addObject:item];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _menu.items = items.copy;
            
            if ( !_menu.selectedItem ) {
                _menu.selectedItem = items[0];
            }
        });
    });
}


#pragma mark - DropDownMenuDelegate

- (void)dropDownMenu:(DropDownMenu *)dropDownMenu didSeletItem:(DropDownMenuItem *)item
{
    [NotificationsManager postNotificationWithName:SMSubscriptionRequested andObject:nil];
    [SubscriptionsManager subscribeTo:item.itemId];
}


@end
