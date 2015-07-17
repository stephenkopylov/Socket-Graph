//
//  NotificationsManager.h
//  Socket+Graph
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SMConnectedNotification;
extern NSString *const SMErrorNotification;
extern NSString *const SMProfileRecievedNotification;
extern NSString *const SMAssetsRecievedNotification;
extern NSString *const SMAssetsHistoryRecievedNotification;
extern NSString *const SMPointRecievedNotification;

@interface NotificationsManager : NSObject

+ (void)postNotificationWithName:(NSString *)name andObject:(id)object;

@end
