//
//  SocketManager.h
//  Socket+Graph
//
//  Created by Admin on 14.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, SMActionType) {
    SMActionTypeToken
};

typedef NS_ENUM (NSUInteger, SMServerActionType) {
    SMServerActionTypeProfile
};

extern NSString* const SMProfileNotification;

@interface SocketManager : NSObject

+ (instancetype)sharedManager;

+ (void)sendMessageWithActionType:(SMActionType)actionType andMessage:(NSDictionary *)message;

- (void)send:(NSString *)data;

- (void)getUserInfo;

@end
