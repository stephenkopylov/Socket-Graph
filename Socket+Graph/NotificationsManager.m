//
//  NotificationsManager.m
//  Socket+Graph
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NotificationsManager.h"

NSString *const SMConnectedNotification = @"SMConnectedNotification";
NSString *const SMErrorNotification = @"SMErrorNotification";
NSString *const SMProfileRecievedNotification = @"SMProfileRecievedNotification";
NSString *const SMAssetsRecievedNotification = @"SMAssetsRecievedNotification";
NSString *const SMAssetsHistoryRecievedNotification = @"SMAssetsHistoryRecievedNotification";
NSString *const SMPointRecievedNotification = @"SMPointRecievedNotification";

@implementation NotificationsManager

+ (void)postNotificationWithName:(NSString *)name andObject:(id)object
{
    if ( [NSThread isMainThread] ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
        });
    }
}

@end
