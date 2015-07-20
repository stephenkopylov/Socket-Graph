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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketConnected) name:SMConnectedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoRecieved:) name:SMProfileRecievedNotification object:nil];
    }
    
    return self;
}


- (void)socketConnected
{
    [[SocketManager sharedManager] getUserInfo];
}


- (void)userInfoRecieved:(NSNotification *)notification
{
    NSDictionary *userInfo  = notification.object;
    
    self.currentUser.name = userInfo[UserInfoNameKey];
    self.currentUser.balance = userInfo[UserInfoBalanceKey];
}


- (void)sync
{
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.name forKey:UserInfoNameKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.balance forKey:UserInfoBalanceKey];
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
