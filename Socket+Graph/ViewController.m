//
//  ViewController.m
//  Socket+Graph
//
//  Created by Admin on 14.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ViewController.h"
#import "SocketManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *message = @{
                              @"token": @"fredclark201590@gmail.com/fredclark201590@gmail.com"
                              };
    
    [SocketManager sendMessageWithActionType:SMActionTypeToken andMessage:message];
}


@end
