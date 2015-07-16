//
//  LoadingScreenViewController.m
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "LoadingScreenViewController.h"
#import "SocketManager.h"
#import "MainViewController.h"
#import "NotificationsManager.h"

@interface LoadingScreenViewController ()

@end

@implementation LoadingScreenViewController {
    UILabel *_loadingLabel;
    UIActivityIndicatorView *_activity;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SMConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SMProfileRecievedNotification object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _loadingLabel = [UILabel new];
    _loadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _loadingLabel.text = @"Connecting";
    _loadingLabel.textColor = [UIColor grayColor];
    
    _activity = [UIActivityIndicatorView new];
    _activity.translatesAutoresizingMaskIntoConstraints = NO;
    [_activity setColor:[UIColor grayColor]];
    [_activity startAnimating];
    
    [self.view addSubview:_loadingLabel];
    [self.view addSubview:_activity];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadingLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadingLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activity attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_loadingLabel attribute:NSLayoutAttributeTop multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activity attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_loadingLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connected) name:SMConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoRecieved) name:SMProfileRecievedNotification object:nil];
}


#pragma mark - Custom methods

- (void)connected
{
    _loadingLabel.text = @"Loading profile";
}


- (void)userInfoRecieved
{
    _loadingLabel.text = @"Done!";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.view.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            self.view.window.rootViewController = [MainViewController new];
                        }
                        completion:nil];
    });
}


@end
