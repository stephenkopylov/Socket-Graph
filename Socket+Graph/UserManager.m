//
//  UserManager.m
//  Socket+Graph
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "UserManager.h"
#import "SocketManager.h"

static UserManager *sharedManager;

static NSString *const UserInfoNameKey = @"name";
static NSString *const UserInfoBalanceKey = @"balance";

@implementation UserManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [UserManager new];
    });
    
    return sharedManager;
}


+ (User *)currentUser
{
    UserManager *userManager = [UserManager sharedManager];
    
    return userManager.currentUser;
}


- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoRecieved:) name:SMProfileNotification object:nil];
    }
    
    return self;
}


- (void)userInfoRecieved:(NSNotification *)notification
{
    NSDictionary *userInfo  = notification.object;
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo[UserInfoNameKey] forKey:UserInfoNameKey];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo[UserInfoBalanceKey] forKey:UserInfoBalanceKey];
}


#pragma mark - Getters

- (User *)currentUser
{
    if ( !_currentUser ) {
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoNameKey];
        NSNumber *balance = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoBalanceKey];
        
        _currentUser = [[User alloc] initWithName:name andBalance:balance];
    }
    
    return _currentUser;
}


@end
