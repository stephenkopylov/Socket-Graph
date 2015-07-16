//
//  ErrorHandler.m
//  Socket+Graph
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ErrorHandler.h"
#import "UIAlertController+Window.h"
#import <UIKit/UIKit.h>
#import "NotificationsManager.h"

static NSString *const MessageKey = @"message";

@implementation ErrorHandler

+ (void)showErrorWithMessage:(NSDictionary *)message
{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Error" message:message[MessageKey] preferredStyle:UIAlertControllerStyleAlert];
    
    [sheet addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    
    [sheet show];
    
    [NotificationsManager postNotificationWithName:SMErrorNotification andObject:nil];
}


@end
