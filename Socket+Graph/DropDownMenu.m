//
//  DropDownMenu.m
//  Socket+Graph
//
//  Created by Admin on 16.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "DropDownMenu.h"
#import "DropDownMenuTableViewCell.h"
#import "AppDelegate.h"

NSString *const DropDownMenuCellIdentifier = @"DropDownMenuCellIdentifier";

@interface DropDownMenu () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DropDownMenu {
    DropDownMenuTableViewCell *_cell;
    UITableView *_tableView;
    UIView *_bgView;
    
    NSLayoutConstraint *_tableViewHeightConstraint;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        _cell = [[DropDownMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DropDownMenuCellIdentifier];
        _cell.translatesAutoresizingMaskIntoConstraints = NO;
        _cell.userInteractionEnabled = NO;
        [self addSubview:_cell];
        
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 35;
        [_tableView registerClass:[DropDownMenuTableViewCell class] forCellReuseIdentifier:DropDownMenuCellIdentifier];
        
        _bgView = [UIView new];
        _bgView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = @{ @"cell": _cell };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[cell]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cell]|" options:0 metrics:nil views:views]];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked)];
        [self addGestureRecognizer:tapRecognizer];
        
        UITapGestureRecognizer *tapRecognizerBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu)];
        [_bgView addGestureRecognizer:tapRecognizerBg];
    }
    
    return self;
}


#pragma mark - Custom methods

- (void)clicked
{
    [self showMenu];
}


- (void)showMenu
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    UIView *targetView = delegate.window.rootViewController.view;
    
    CGRect rect = [targetView convertRect:self.frame toView:targetView];
    
    [targetView addSubview:_bgView];
    
    [targetView addSubview:_tableView];
    
    NSDictionary *views = @{
                            @"tableView": _tableView,
                            @"bg": _bgView
                            };
    NSDictionary *metrics = @{
                              @"top": @(rect.origin.y + rect.size.height),
                              @"left": @(rect.origin.x + self.layer.cornerRadius),
                              @"width": @(rect.size.width - self.layer.cornerRadius * 2),
                              @"height": @(_tableView.contentSize.height),
                              @"high": @(UILayoutPriorityDefaultHigh),
                              @"low": @(UILayoutPriorityDefaultLow)
                              };
    
    [targetView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bg]|" options:0 metrics:metrics views:views]];
    [targetView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bg]|" options:0 metrics:metrics views:views]];
    
    _tableViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0 multiplier:1 constant:0];
    [targetView addConstraint:_tableViewHeightConstraint];
    
    [targetView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(left)-[tableView(width)]" options:0 metrics:metrics views:views]];
    [targetView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[tableView]-(20@high)-|" options:0 metrics:metrics views:views]];
    
    [targetView layoutIfNeeded];
    
    _tableViewHeightConstraint.constant = _tableView.contentSize.height;
    [UIView animateWithDuration:0.2 animations:^{
        [targetView layoutIfNeeded];
    }];
}


- (void)hideMenu
{
    [_bgView.superview layoutIfNeeded];
    _tableViewHeightConstraint.constant = 0;
    
    [UIView animateWithDuration:0.1 animations:^{
        [_bgView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_tableView removeFromSuperview];
    }];
}


#pragma mark - Getters/setters

- (void)setSelectedItem:(DropDownMenuItem *)selectedItem
{
    _selectedItem = selectedItem;
    
    _cell.name = _selectedItem.name;
    
    if ( [_delegate respondsToSelector:@selector(dropDownMenu:didSeletItem:)] ) {
        [_delegate dropDownMenu:self didSeletItem:_selectedItem];
    }
}


#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DropDownMenuCellIdentifier forIndexPath:indexPath];
    
    DropDownMenuItem *item = _items[indexPath.row];
    
    cell.name = item.name;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [cell respondsToSelector:@selector(setSeparatorInset:)] ) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ( [cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)] ) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ( [cell respondsToSelector:@selector(setLayoutMargins:)] ) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem = _items[indexPath.row];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideMenu];
}


@end
